//! 轻量指标采集与 Prometheus 文本导出。
//!
//! 只用标准库实现：标签基数由路由模板控制，延迟桶固定，导出格式遵循
//! Prometheus 0.0.4 文本协议。数据库连接池、判题队列与 Worker 心跳等需要
//! 异步读数的指标由 `metrics_handler` 追加到同一份输出。

use std::{
    collections::HashMap,
    sync::{
        Arc, OnceLock, RwLock,
        atomic::{AtomicI64, AtomicU64, Ordering},
    },
    time::{Duration, Instant},
};

use axum::{extract::MatchedPath, extract::Request, middleware::Next, response::Response};

/// 延迟桶（秒）。覆盖接口、判题查询与上传的常见量级。
const LATENCY_BUCKETS: [f64; 10] = [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0];

/// 状态码标签，索引与 `RouteSeries::status` 对齐。
const STATUS_LABELS: [&str; 6] = ["other", "1xx", "2xx", "3xx", "4xx", "5xx"];

#[derive(Default)]
struct RouteSeries {
    status: [AtomicU64; 6],
    buckets: [AtomicU64; LATENCY_BUCKETS.len()],
    count: AtomicU64,
    sum_micros: AtomicU64,
}

impl RouteSeries {
    fn record(&self, status: u16, elapsed: Duration) {
        let class = match status / 100 {
            1..=5 => (status / 100) as usize,
            _ => 0,
        };
        self.status[class].fetch_add(1, Ordering::Relaxed);
        let seconds = elapsed.as_secs_f64();
        // 每个不小于本次耗时的桶都加一，桶天然是累计值。
        for (index, bucket) in LATENCY_BUCKETS.iter().enumerate() {
            if seconds <= *bucket {
                self.buckets[index].fetch_add(1, Ordering::Relaxed);
            }
        }
        self.count.fetch_add(1, Ordering::Relaxed);
        self.sum_micros
            .fetch_add(elapsed.as_micros() as u64, Ordering::Relaxed);
    }
}

/// 进程内 HTTP 指标。按（方法，路由模板）保存，路由模板来自 `MatchedPath`，
/// 不会因为路径参数不同产生新的时间序列。
#[derive(Default)]
pub struct HttpMetrics {
    routes: RwLock<HashMap<(String, String), Arc<RouteSeries>>>,
    in_flight: AtomicI64,
}

impl HttpMetrics {
    fn series(&self, method: &str, route: &str) -> Arc<RouteSeries> {
        let key = (method.to_owned(), route.to_owned());
        if let Some(series) = self
            .routes
            .read()
            .unwrap_or_else(|poison| poison.into_inner())
            .get(&key)
        {
            return Arc::clone(series);
        }
        let mut routes = self
            .routes
            .write()
            .unwrap_or_else(|poison| poison.into_inner());
        Arc::clone(routes.entry(key).or_default())
    }

    pub fn record(&self, method: &str, route: &str, status: u16, elapsed: Duration) {
        self.series(method, route).record(status, elapsed);
    }

    /// 渲染 Prometheus 文本格式的 HTTP 指标部分。
    pub fn render(&self) -> String {
        let mut out = String::with_capacity(8192);
        append_header(
            &mut out,
            "theseus_http_requests_total",
            "counter",
            "HTTP requests handled, by method, route and status class.",
        );

        let entries: Vec<((String, String), Arc<RouteSeries>)> = {
            let routes = self
                .routes
                .read()
                .unwrap_or_else(|poison| poison.into_inner());
            let mut entries: Vec<_> = routes
                .iter()
                .map(|(key, series)| (key.clone(), Arc::clone(series)))
                .collect();
            entries.sort_by(|left, right| left.0.cmp(&right.0));
            entries
        };

        for ((method, route), series) in &entries {
            for (index, count) in series.status.iter().enumerate() {
                let count = count.load(Ordering::Relaxed);
                if count == 0 {
                    continue;
                }
                out.push_str("theseus_http_requests_total");
                write_labels(
                    &mut out,
                    &[
                        ("method", method.as_str()),
                        ("route", route.as_str()),
                        ("status", STATUS_LABELS[index]),
                    ],
                );
                push_value(&mut out, count as f64);
            }
        }

        append_header(
            &mut out,
            "theseus_http_request_duration_seconds",
            "histogram",
            "HTTP request latency in seconds.",
        );
        for ((method, route), series) in &entries {
            let count = series.count.load(Ordering::Relaxed);
            if count == 0 {
                continue;
            }
            let labels = [("method", method.as_str()), ("route", route.as_str())];
            for (index, bucket) in LATENCY_BUCKETS.iter().enumerate() {
                out.push_str("theseus_http_request_duration_seconds_bucket");
                write_labels_with(&mut out, &labels, ("le", &format_bucket(*bucket)));
                push_value(
                    &mut out,
                    series.buckets[index].load(Ordering::Relaxed) as f64,
                );
            }
            out.push_str("theseus_http_request_duration_seconds_bucket");
            write_labels_with(&mut out, &labels, ("le", "+Inf"));
            push_value(&mut out, count as f64);

            out.push_str("theseus_http_request_duration_seconds_sum");
            write_labels(&mut out, &labels);
            push_value(
                &mut out,
                series.sum_micros.load(Ordering::Relaxed) as f64 / 1_000_000.0,
            );

            out.push_str("theseus_http_request_duration_seconds_count");
            write_labels(&mut out, &labels);
            push_value(&mut out, count as f64);
        }

        append_header(
            &mut out,
            "theseus_http_requests_in_flight",
            "gauge",
            "HTTP requests currently being served.",
        );
        out.push_str("theseus_http_requests_in_flight");
        push_value(&mut out, self.in_flight.load(Ordering::Relaxed) as f64);
        out
    }
}

/// 全局指标实例。`route_layer` 不携带状态，因此这里用进程级单例。
pub fn http_metrics() -> &'static HttpMetrics {
    static INSTANCE: OnceLock<HttpMetrics> = OnceLock::new();
    INSTANCE.get_or_init(HttpMetrics::default)
}

/// 记录每个匹配到路由的请求。需要挂在 `Router::route_layer` 上，
/// 这样 `MatchedPath` 已经写入请求扩展，拿得到路由模板而不是真实路径。
pub async fn track_http(request: Request, next: Next) -> Response {
    let method = request.method().as_str().to_owned();
    let route = request
        .extensions()
        .get::<MatchedPath>()
        .map(|path| path.as_str().to_owned())
        .unwrap_or_else(|| "unmatched".to_owned());

    let metrics = http_metrics();
    metrics.in_flight.fetch_add(1, Ordering::Relaxed);
    let guard = InFlightGuard;
    let started = Instant::now();
    let response = next.run(request).await;
    metrics.record(
        &method,
        &route,
        response.status().as_u16(),
        started.elapsed(),
    );
    drop(guard);
    response
}

/// 处理函数 panic 时也要归还 in-flight 计数。
struct InFlightGuard;

impl Drop for InFlightGuard {
    fn drop(&mut self) {
        http_metrics().in_flight.fetch_sub(1, Ordering::Relaxed);
    }
}

/// 追加一条 HELP 与 TYPE，供异步指标使用。
pub fn append_header(out: &mut String, name: &str, kind: &str, help: &str) {
    out.push_str("# HELP ");
    out.push_str(name);
    out.push(' ');
    out.push_str(help);
    out.push('\n');
    out.push_str("# TYPE ");
    out.push_str(name);
    out.push(' ');
    out.push_str(kind);
    out.push('\n');
}

/// 追加一条无标签或带标签的样本。
pub fn append_gauge(out: &mut String, name: &str, labels: &[(&str, &str)], value: f64) {
    out.push_str(name);
    write_labels(out, labels);
    push_value(out, value);
}

fn write_labels(out: &mut String, labels: &[(&str, &str)]) {
    if labels.is_empty() {
        return;
    }
    out.push('{');
    for (index, (key, value)) in labels.iter().enumerate() {
        if index > 0 {
            out.push(',');
        }
        out.push_str(key);
        out.push_str("=\"");
        push_escaped(out, value);
        out.push('"');
    }
    out.push('}');
}

fn write_labels_with(out: &mut String, labels: &[(&str, &str)], extra: (&str, &str)) {
    out.push('{');
    for (key, value) in labels {
        out.push_str(key);
        out.push_str("=\"");
        push_escaped(out, value);
        out.push_str("\",");
    }
    out.push_str(extra.0);
    out.push_str("=\"");
    push_escaped(out, extra.1);
    out.push_str("\"}");
}

fn push_escaped(out: &mut String, value: &str) {
    for ch in value.chars() {
        match ch {
            '\\' => out.push_str("\\\\"),
            '"' => out.push_str("\\\""),
            '\n' => out.push_str("\\n"),
            _ => out.push(ch),
        }
    }
}

fn push_value(out: &mut String, value: f64) {
    out.push(' ');
    if value.is_finite() && value.fract() == 0.0 {
        out.push_str(&format!("{}", value as i64));
    } else {
        out.push_str(&format!("{value}"));
    }
    out.push('\n');
}

fn format_bucket(bucket: f64) -> String {
    if bucket.fract() == 0.0 {
        format!("{}", bucket as i64)
    } else {
        format!("{bucket}")
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn records_by_route_and_status_class() {
        let metrics = HttpMetrics::default();
        metrics.record("GET", "/api/problems", 200, Duration::from_millis(3));
        metrics.record("GET", "/api/problems", 500, Duration::from_millis(1200));
        metrics.record("POST", "/api/auth/login", 401, Duration::from_millis(8));

        let rendered = metrics.render();
        assert!(rendered.contains(
            "theseus_http_requests_total{method=\"GET\",route=\"/api/problems\",status=\"2xx\"} 1"
        ));
        assert!(rendered.contains(
            "theseus_http_requests_total{method=\"GET\",route=\"/api/problems\",status=\"5xx\"} 1"
        ));
        assert!(rendered.contains(
            "theseus_http_request_duration_seconds_count{method=\"GET\",route=\"/api/problems\"} 2"
        ));
        // 1.2s 落在 2.5 秒桶，3ms 落在 5ms 桶；桶必须累计。
        assert!(rendered.contains(
            "theseus_http_request_duration_seconds_bucket{method=\"GET\",route=\"/api/problems\",le=\"0.005\"} 1"
        ));
        assert!(rendered.contains(
            "theseus_http_request_duration_seconds_bucket{method=\"GET\",route=\"/api/problems\",le=\"+Inf\"} 2"
        ));
    }

    #[test]
    fn escapes_label_values() {
        let mut out = String::new();
        append_gauge(&mut out, "theseus_test", &[("path", "a\"b\\c\nd")], 1.0);
        assert_eq!(out, "theseus_test{path=\"a\\\"b\\\\c\\nd\"} 1\n");
    }

    #[test]
    fn formats_fractional_values() {
        let mut out = String::new();
        append_gauge(&mut out, "theseus_test", &[], 0.25);
        assert_eq!(out, "theseus_test 0.25\n");
    }
}

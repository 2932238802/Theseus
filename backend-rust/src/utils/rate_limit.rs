//! 进程内限流与登录失败锁定。
//!
//! 后端只监听 127.0.0.1，客户端地址取自反向代理写入的 `X-Real-IP` /
//! `X-Forwarded-For`。计数保存在进程内存里，适合当前单实例部署；多实例时需要
//! 换成 Redis 计数，否则每个实例各自放行一份配额。

use std::{
    collections::HashMap,
    sync::{Mutex, OnceLock},
    time::{Duration, Instant},
};

use axum::http::HeaderMap;

/// 清理过期计数的最小间隔。
const PRUNE_INTERVAL: Duration = Duration::from_secs(60);

#[derive(Debug, Clone, Copy)]
pub struct Rule {
    pub max: u32,
    pub period: Duration,
}

impl Rule {
    pub const fn new(max: u32, period: Duration) -> Self {
        Self { max, period }
    }
}

struct Window {
    started_at: Instant,
    expires_at: Instant,
    count: u32,
}

struct Failures {
    started_at: Instant,
    expires_at: Instant,
    count: u32,
    locked_until: Option<Instant>,
}

#[derive(Default)]
struct Limiter {
    windows: HashMap<(String, String), Window>,
    failures: HashMap<(String, String), Failures>,
    last_prune: Option<Instant>,
}

impl Limiter {
    fn prune(&mut self, now: Instant) {
        if self
            .last_prune
            .is_some_and(|last| now.duration_since(last) < PRUNE_INTERVAL)
        {
            return;
        }
        self.last_prune = Some(now);
        self.windows.retain(|_, window| window.expires_at > now);
        self.failures.retain(|_, entry| {
            entry.expires_at > now || entry.locked_until.is_some_and(|until| until > now)
        });
    }

    fn check(
        &mut self,
        scope: &str,
        subject: &str,
        rule: Rule,
        now: Instant,
    ) -> Result<(), Duration> {
        self.prune(now);
        let key = (scope.to_owned(), subject.to_owned());
        let window = self.windows.entry(key).or_insert_with(|| Window {
            started_at: now,
            expires_at: now + rule.period,
            count: 0,
        });
        if now.duration_since(window.started_at) >= rule.period {
            window.started_at = now;
            window.expires_at = now + rule.period;
            window.count = 0;
        }
        if window.count >= rule.max {
            let remaining = window.expires_at.saturating_duration_since(now);
            return Err(remaining.max(Duration::from_secs(1)));
        }
        window.count += 1;
        Ok(())
    }

    fn lockout_remaining(&mut self, scope: &str, subject: &str, now: Instant) -> Option<Duration> {
        self.prune(now);
        let entry = self.failures.get(&(scope.to_owned(), subject.to_owned()))?;
        let until = entry.locked_until?;
        (until > now).then(|| until.saturating_duration_since(now))
    }

    fn register_failure(
        &mut self,
        scope: &str,
        subject: &str,
        rule: Rule,
        lockout: Duration,
        now: Instant,
    ) {
        self.prune(now);
        let key = (scope.to_owned(), subject.to_owned());
        let entry = self.failures.entry(key).or_insert_with(|| Failures {
            started_at: now,
            expires_at: now + rule.period,
            count: 0,
            locked_until: None,
        });
        if now.duration_since(entry.started_at) >= rule.period {
            entry.started_at = now;
            entry.expires_at = now + rule.period;
            entry.count = 0;
        }
        entry.count += 1;
        if entry.count >= rule.max {
            entry.count = 0;
            entry.started_at = now;
            entry.expires_at = now + rule.period;
            entry.locked_until = Some(now + lockout);
        }
    }

    fn clear_failures(&mut self, scope: &str, subject: &str) {
        self.failures
            .remove(&(scope.to_owned(), subject.to_owned()));
    }
}

fn limiter() -> &'static Mutex<Limiter> {
    static LIMITER: OnceLock<Mutex<Limiter>> = OnceLock::new();
    LIMITER.get_or_init(|| Mutex::new(Limiter::default()))
}

fn with_limiter<T>(action: impl FnOnce(&mut Limiter) -> T) -> T {
    let mut guard = limiter()
        .lock()
        .unwrap_or_else(|poisoned| poisoned.into_inner());
    action(&mut guard)
}

/// 固定窗口计数：窗口内超过 `rule.max` 次数时返回需要等待的时长。
pub fn check(scope: &str, subject: &str, rule: Rule) -> Result<(), Duration> {
    with_limiter(|limiter| limiter.check(scope, subject, rule, Instant::now()))
}

/// 失败次数达到阈值后进入锁定，返回剩余锁定时长。
pub fn lockout_remaining(scope: &str, subject: &str) -> Option<Duration> {
    with_limiter(|limiter| limiter.lockout_remaining(scope, subject, Instant::now()))
}

/// 记录一次失败；达到 `rule.max` 次后锁定 `lockout`。
pub fn register_failure(scope: &str, subject: &str, rule: Rule, lockout: Duration) {
    with_limiter(|limiter| limiter.register_failure(scope, subject, rule, lockout, Instant::now()));
}

/// 登录成功或密码重置后清除失败计数。
pub fn clear_failures(scope: &str, subject: &str) {
    with_limiter(|limiter| limiter.clear_failures(scope, subject));
}

/// 客户端地址：优先取反向代理写入的 `X-Real-IP`，其次取 `X-Forwarded-For`
/// 的第一段。两处都没有时返回 `unknown`，此时同一进程共用一份配额。
pub fn client_ip(headers: &HeaderMap) -> String {
    if let Some(value) = headers
        .get("x-real-ip")
        .and_then(|value| value.to_str().ok())
        .map(str::trim)
        .filter(|value| !value.is_empty())
    {
        return value.to_owned();
    }
    if let Some(value) = headers
        .get("x-forwarded-for")
        .and_then(|value| value.to_str().ok())
        .and_then(|value| value.split(',').next())
        .map(str::trim)
        .filter(|value| !value.is_empty())
    {
        return value.to_owned();
    }
    "unknown".to_owned()
}

#[cfg(test)]
mod tests {
    use super::{Limiter, Rule};
    use std::time::{Duration, Instant};

    fn rule(max: u32, seconds: u64) -> Rule {
        Rule::new(max, Duration::from_secs(seconds))
    }

    #[test]
    fn window_allows_up_to_limit() {
        let mut limiter = Limiter::default();
        let now = Instant::now();
        let rule = rule(2, 60);
        for _ in 0..2 {
            assert!(limiter.check("login", "ip", rule, now).is_ok());
        }
        let retry = limiter.check("login", "ip", rule, now).unwrap_err();
        assert!(retry <= Duration::from_secs(60));
        assert!(retry >= Duration::from_secs(1));
    }

    #[test]
    fn window_resets_after_period() {
        let mut limiter = Limiter::default();
        let now = Instant::now();
        let rule = rule(1, 10);
        assert!(limiter.check("login", "ip", rule, now).is_ok());
        assert!(limiter.check("login", "ip", rule, now).is_err());
        assert!(
            limiter
                .check("login", "ip", rule, now + Duration::from_secs(10))
                .is_ok()
        );
    }

    #[test]
    fn keys_are_isolated_by_scope_and_subject() {
        let mut limiter = Limiter::default();
        let now = Instant::now();
        let rule = rule(1, 60);
        assert!(limiter.check("login", "a", rule, now).is_ok());
        assert!(limiter.check("login", "b", rule, now).is_ok());
        assert!(limiter.check("register", "a", rule, now).is_ok());
    }

    #[test]
    fn failures_lock_until_lockout_expires() {
        let mut limiter = Limiter::default();
        let now = Instant::now();
        let failures = rule(2, 60);
        let lockout = Duration::from_secs(30);
        limiter.register_failure("login", "alice", failures, lockout, now);
        assert!(limiter.lockout_remaining("login", "alice", now).is_none());
        limiter.register_failure("login", "alice", failures, lockout, now);
        let remaining = limiter
            .lockout_remaining("login", "alice", now)
            .expect("应处于锁定状态");
        assert!(remaining <= lockout && remaining >= Duration::from_secs(1));
        assert!(
            limiter
                .lockout_remaining("login", "alice", now + Duration::from_secs(31))
                .is_none()
        );
    }

    #[test]
    fn success_clears_failure_history() {
        let mut limiter = Limiter::default();
        let now = Instant::now();
        let failures = rule(1, 60);
        limiter.register_failure("login", "bob", failures, Duration::from_secs(30), now);
        assert!(limiter.lockout_remaining("login", "bob", now).is_some());
        limiter.clear_failures("login", "bob");
        assert!(limiter.lockout_remaining("login", "bob", now).is_none());
    }
}

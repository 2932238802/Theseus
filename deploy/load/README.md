# Theseus 压测脚本（k6）

`k6-theseus.js` 用真实 HTTP 请求压测题库、首页、论坛、通知与提交记录等读路径，用于建立单机容量基线，并对比新增复合索引前后的差异。

默认只发送只读请求。真实提交（`submit` 场景）默认关闭，因为每次提交都会写入数据库并占用判题 Worker 与 gVisor 沙箱。

## 1. 安全约定

- 使用**专用压测账号**，不要使用真实用户或管理员账号。登录会递增 `users.token_version`，该账号此前的会话会立即失效。
- 单实例部署同一账号只能保持一个会话。读场景所有 VU 共用 `setup()` 登录得到的 token，不会重复登录；`submit` 场景要求每个 VU 使用独立账号，账号之间不要混用。
- 脚本只输出数据数量与指标，不打印账号、密码或 token。
- 不要在比赛、作业截止或判题高峰期运行；真实提交会挤占判题队列。
- 压测账号的提交、通知、审计日志会留在数据库中，建议在测试环境执行，或测试后清理。

## 2. 准备

### 2.1 安装 k6

```bash
# Debian/Ubuntu（k6 官方仓库）
sudo gpg -k
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg \
  --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" \
  | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt update && sudo apt install k6
```

也可以使用镜像（Linux 下 `--network host` 才能访问宿主机端口）：

```bash
docker run --rm -i --network host \
  -e K6_USERNAME -e K6_PASSWORD \
  -v "$PWD/deploy/load:/scripts:ro" \
  grafana/k6 run /scripts/k6-theseus.js
```

### 2.2 检查接口可用

```bash
curl -fsS http://127.0.0.1:8080/api/problems?page=1\&size=1 >/dev/null && echo ok
```

脚本会在 `setup()` 中登录并读取题库、帖子列表；题库为空时 `browse` 只压列表页，论坛为空时会退化为只压列表。面经板块只对 Plus、管理员与作者开放，普通压测账号遇到 403 会自动跳过面经请求，不影响其余场景。

### 2.3 先执行数据库索引迁移

```bash
cd /opt/theseus/deploy
./scripts/backup.sh
cd ..
./update.sh
```

`0045_performance_indexes.sql` 会创建提交记录与通知列表的复合索引；论坛帖子流已由 `0032` 的索引覆盖，本次不重复创建。首次在较大表上执行时 `CREATE INDEX` 会短暂阻塞写入，建议在低峰期升级；数据量很大时可先手工用 `CREATE INDEX CONCURRENTLY` 建索引，再执行迁移（`IF NOT EXISTS` 会跳过已存在的索引）。

## 3. 运行

```bash
export K6_USERNAME='loadtest-user'
export K6_PASSWORD='<专用账号密码>'
k6 run deploy/load/k6-theseus.js
```

默认两个场景各持续约 4 分钟：

| 场景 | 默认 VU | 行为 |
|---|---|---|
| `browse` | 10 | 题库分页、难度筛选、随机题目详情 |
| `read` | 8 | 首页概览、当前用户、通知、论坛列表/详情、提交记录、榜单 |

常用环境变量：

| 变量 | 默认值 | 说明 |
|---|---|---|
| `BASE_URL` | `http://127.0.0.1:8080` | 前端入口；直连后端时可用 `http://127.0.0.1:3000` |
| `K6_USERNAME` / `K6_PASSWORD` | 无 | 必填，专用压测账号 |
| `K6_BROWSE_VUS` / `K6_READ_VUS` | `10` / `8` | 两个场景的并发数 |
| `K6_DURATION` | `3m` | 每个场景的稳定期 |
| `K6_RAMP_UP` / `K6_RAMP_DOWN` | `30s` / `30s` | 爬坡与收尾 |
| `K6_INSECURE` | 未设置 | `1` 时跳过 TLS 证书校验 |
| `K6_SUMMARY_OUT` | 未设置 | 额外保存完整 JSON 摘要的路径 |

示例：先做低并发校准，再逐步加压：

```bash
K6_BROWSE_VUS=5 K6_READ_VUS=3 K6_DURATION=2m k6 run deploy/load/k6-theseus.js
K6_BROWSE_VUS=20 K6_READ_VUS=15 K6_DURATION=3m k6 run deploy/load/k6-theseus.js
```

默认阈值：失败率 < 1%、检查通过率 > 99%、全局 P95 < 800 ms、P99 < 2000 ms，主要列表接口 P95 < 500 ms。阈值按 2 核 4 GB 单机给出，换环境后应重新校准，不建议为了“跑绿”直接放宽。

## 4. 可选：提交场景

提交场景用于测量判题入队与 API 写入，不测量判题耗时本身。启用前确认：

- `VITE_SUBMIT_JUDGE_ENABLED=true` 且判题 Worker 正常；
- 准备至少与 `K6_SUBMIT_VUS` 数量相同的专用账号，且每个账号只被一个 VU 使用；
- 选定题目支持 `K6_SUBMIT_LANGUAGE`，`K6_SUBMIT_CODE` 能通过编译（不要求答案正确）。

```bash
K6_ENABLE_SUBMIT=1 \
K6_SUBMIT_VUS=2 \
K6_SUBMIT_ACCOUNTS='load-a:pass-a,load-b:pass-b' \
K6_SUBMIT_PROBLEM_ID=1001 \
K6_SUBMIT_LANGUAGE=python \
K6_SUBMIT_CODE='print(0)' \
K6_DURATION=2m \
k6 run deploy/load/k6-theseus.js
```

每个 VU 每次提交后等待 10 秒，避免把队列塞满后测到的是积压而不是处理能力。提交产生的记录不会自动删除。

## 5. 建立前后对比

1. 在部署机上启用统计并清空历史：

   ```bash
   cd deploy
   ./scripts/pg_stats.sh enable   # 只需一次；旧部署可能需要先重建 postgres
   ./scripts/pg_stats.sh reset --yes
   ```

2. 运行同一份压测脚本，保存摘要：

   ```bash
   K6_SUMMARY_OUT=/tmp/k6-before.json k6 run deploy/load/k6-theseus.js
   ```

3. 收集 SQL 统计：

   ```bash
   ./scripts/pg_stats.sh --limit 30 | tee /tmp/pg-before.txt
   ```

4. 应用 `0045` 迁移（或直接在测试库执行其中的 `CREATE INDEX`），重复第 1–3 步，文件改为 `after`。

对比时同时看：

- `http_req_duration` 的 P95/P99 与各 `name` 标签的分接口延迟；
- `http_reqs` 速率与失败率；
- `pg_stat_statements` 中相关语句的 `mean_ms`、`calls` 与 `cache_hit_pct`；
- `EXPLAIN (ANALYZE, BUFFERS)` 是否从 `Sort` + `Seq Scan` 变为索引顺序扫描。

压测机与服务器尽量在同一内网；跨公网的结果主要反映网络延迟，不适合作为容量基线。

## 6. 结果解读

- 失败率升高但延迟不变：优先检查 API 限流（登录、提交等）与连接池上限 `DB_MAX_CONNECTIONS`。
- 延迟随 VU 线性上升、CPU 未打满：多为连接池排队或锁等待，查看 `pg_stat_activity`。
- 判题队列长度持续增长：submit 场景超过 Worker 处理能力，降低 `K6_SUBMIT_VUS` 或提高 `RUN_WORKER_CONCURRENCY`。
- 单接口 P95 明显高于其他接口：用 `pg_stats.sh` 找到对应 SQL，再用 `EXPLAIN` 确认索引是否命中。

本仓库不记录固定机器上的绝对数字；把实际结果写入 `doc/2611052_性能压测与索引收口.md` 的验证章节，并注明硬件、并发与数据规模，避免脱离上下文比较。

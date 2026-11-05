-- 仅清理 seed_dev.sql、seed_problems_15.sql、seed_problems_82.sql、
-- seed_problems_100.sql 与 seed_problems_batch1.sql 写入的固定 ID 数据，禁止全表清空。

DELETE FROM problems
WHERE id IN (1001, 1002, 1003)
   OR id BETWEEN 1101 AND 1197
   OR id BETWEEN 1200 AND 1299
   OR id BETWEEN 1300 AND 1499;

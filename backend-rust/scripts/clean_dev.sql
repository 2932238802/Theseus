-- 仅清理 seed_dev.sql、seed_problems_15.sql、seed_problems_82.sql、
-- seed_problems_100.sql、seed_problems_batch1.sql、seed_problems_batch2.sql、
-- seed_problems_batch3.sql 与 seed_problems_batch4.sql 写入的固定 ID 数据，
-- 禁止全表清空。

DELETE FROM problems
WHERE id IN (1001, 1002, 1003)
   OR id BETWEEN 1101 AND 1197
   OR id BETWEEN 1200 AND 1299
   OR id BETWEEN 1300 AND 1499
   OR id BETWEEN 1500 AND 1699
   OR id BETWEEN 1700 AND 1899
   OR id BETWEEN 1900 AND 2099;

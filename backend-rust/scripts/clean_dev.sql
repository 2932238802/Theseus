-- 仅清理 seed_dev.sql 与 seed_problems_15.sql 写入的固定 ID 数据，禁止全表清空。

DELETE FROM problems WHERE id IN (1001, 1002, 1003) OR id BETWEEN 1101 AND 1115;

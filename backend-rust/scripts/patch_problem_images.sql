-- 题面示例配图补丁：由 update.sh 在数据库迁移成功后自动执行。
--
-- 约定：
--   * 图片放在 frontend-vue/public/problem-images/，随前端镜像发布，
--     题目里统一用站内路径 /problem-images/<文件名> 引用。
--   * 每条 UPDATE 都必须幂等：只更新与目标值不同的行，重复执行不会
--     反复刷新 updated_at。
--   * 新增题目配图时，在本文件末尾追加一条 UPDATE 即可，无需新增迁移。
--
-- 示例配图按数组下标写入 examples JSONB；下标与种子数据中的示例顺序一致。

-- 1113 接雨水：示例 1（接 6 格）与示例 2（接 9 格）各一张示意图
UPDATE problems
SET examples = jsonb_set(
        jsonb_set(
            examples,
            '{0,image}',
            '"/problem-images/1113-trapping-rain-water-1.png"'
        ),
        '{1,image}',
        '"/problem-images/1113-trapping-rain-water-2.png"'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1113
  AND jsonb_typeof(examples) = 'array'
  AND jsonb_array_length(examples) >= 2
  AND (
        examples -> 0 ->> 'image'
            IS DISTINCT FROM '/problem-images/1113-trapping-rain-water-1.png'
     OR examples -> 1 ->> 'image'
            IS DISTINCT FROM '/problem-images/1113-trapping-rain-water-2.png'
  );

-- 1106 反转链表：三个示例各一张示意图
UPDATE problems
SET examples = jsonb_set(
        jsonb_set(
            jsonb_set(
                examples,
                '{0,image}',
                '"/problem-images/1106-reverse-linked-list-1.png"'
            ),
            '{1,image}',
            '"/problem-images/1106-reverse-linked-list-2.png"'
        ),
        '{2,image}',
        '"/problem-images/1106-reverse-linked-list-3.png"'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1106
  AND jsonb_typeof(examples) = 'array'
  AND jsonb_array_length(examples) >= 3
  AND (
        examples -> 0 ->> 'image'
            IS DISTINCT FROM '/problem-images/1106-reverse-linked-list-1.png'
     OR examples -> 1 ->> 'image'
            IS DISTINCT FROM '/problem-images/1106-reverse-linked-list-2.png'
     OR examples -> 2 ->> 'image'
            IS DISTINCT FROM '/problem-images/1106-reverse-linked-list-3.png'
  );

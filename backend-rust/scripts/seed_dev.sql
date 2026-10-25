-- 仅用于本地/测试环境的开发种子数据。
-- 使用固定 ID 1001-1003，便于通过 clean_dev.sql 安全清理。

INSERT INTO problems (
    id, title, description, difficulty, time_limit, memory_limit, tags,
    examples, test_cases, code_template, run_config, judge_cases, review_status
) VALUES
(
    1001,
    '两数之和',
    '给定一个整数数组 nums 和一个整数目标值 target，请你在该数组中找出和为目标值 target 的两个整数，并返回它们的数组下标。

你可以假设每种输入只会对应一个答案，并且不能使用两次相同的元素。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
        {"input": "nums = [2, 7, 11, 15], target = 9", "output": "[0, 1]", "explanation": "因为 nums[0] + nums[1] == 9，返回 [0, 1]。"}
    ]$json$::jsonb,
    $json$[
        {"input": "nums = [2, 7, 11, 15], target = 9", "output": "[0, 1]"},
        {"input": "nums = [3, 2, 4], target = 6", "output": "[1, 2]"}
    ]$json$::jsonb,
    $json${
        "javascript": "var twoSum = function(nums, target) {\n};\n",
        "python": "class Solution:\n    def twoSum(self, nums: list[int], target: int) -> list[int]:\n        pass\n",
        "cpp": "#include <vector>\n#include <unordered_map>\nusing namespace std;\n\nclass Solution {\npublic:\n    vector<int> twoSum(vector<int>& nums, int target) {\n        \n    }\n};\n",
        "java": "import java.util.*;\n\nclass Solution {\n    public int[] twoSum(int[] nums, int target) {\n        \n    }\n}\n"
    }$json$::jsonb,
    $json${
        "version": 1,
        "function_name": "twoSum",
        "params": [
            {"name": "nums", "type": "int[]"},
            {"name": "target", "type": "int"}
        ],
        "return_type": "int[]",
        "compare": {"mode": "exact"},
        "public_cases": [
            {"args": [[2, 7, 11, 15], 9], "expected": [0, 1]},
            {"args": [[3, 2, 4], 6], "expected": [1, 2]},
            {"args": [[3, 3], 6], "expected": [0, 1]}
        ]
    }$json$::jsonb,
    $json$[
        {"args": [[1, 2], 3], "expected": [0, 1]},
        {"args": [[0, 4, 3, 0], 0], "expected": [0, 3]},
        {"args": [[-1, -2, -3, -4, -5], -8], "expected": [2, 4]}
    ]$json$::jsonb,
    'approved'
),
(
    1002,
    '无重复字符的最长子串',
    '给定一个字符串 s，请找出其中不含有重复字符的最长子串的长度。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '哈希表', '滑动窗口'],
    $json$[
        {"input": "s = \"abcabcbb\"", "output": "3", "explanation": "因为无重复字符的最长子串是 \"abc\"。"},
        {"input": "s = \"bbbbb\"", "output": "1", "explanation": "因为最长子串是 \"b\"。"}
    ]$json$::jsonb,
    $json$[
        {"input": "abcabcbb", "output": "3"},
        {"input": "bbbbb", "output": "1"},
        {"input": "pwwkew", "output": "3"}
    ]$json$::jsonb,
    $json${
        "javascript": "function lengthOfLongestSubstring(s) {\n  \n}\n",
        "python": "class Solution:\n    def lengthOfLongestSubstring(self, s: str) -> int:\n        pass\n",
        "cpp": "#include <string>\nusing namespace std;\n\nclass Solution {\npublic:\n    int lengthOfLongestSubstring(string s) {\n        \n    }\n};\n",
        "java": "class Solution {\n    public int lengthOfLongestSubstring(String s) {\n        \n    }\n}\n"
    }$json$::jsonb,
    $json${
        "version": 1,
        "function_name": "lengthOfLongestSubstring",
        "params": [
            {"name": "s", "type": "string"}
        ],
        "return_type": "int",
        "compare": {"mode": "exact"},
        "public_cases": [
            {"args": ["abcabcbb"], "expected": 3},
            {"args": ["bbbbb"], "expected": 1},
            {"args": ["pwwkew"], "expected": 3}
        ]
    }$json$::jsonb,
    $json$[
        {"args": ["dvdf"], "expected": 3},
        {"args": ["abba"], "expected": 2},
        {"args": [""], "expected": 0}
    ]$json$::jsonb,
    'approved'
),
(
    1003,
    '寻找两个正序数组的中位数',
    '给定两个大小分别为 m 和 n 的正序数组 nums1 和 nums2，请找出并返回这两个正序数组的中位数。算法的时间复杂度应为 O(log (m+n))。',
    'hard',
    2000,
    256,
    ARRAY['数组', '二分查找', '分治'],
    $json$[
        {"input": "nums1 = [1, 3], nums2 = [2]", "output": "2.0", "explanation": "合并数组为 [1, 2, 3]，中位数是 2。"},
        {"input": "nums1 = [1, 2], nums2 = [3, 4]", "output": "2.5", "explanation": "合并数组为 [1, 2, 3, 4]，中位数是 (2 + 3) / 2 = 2.5。"}
    ]$json$::jsonb,
    $json$[
        {"input": "[1,3]\n[2]", "output": "2.0"},
        {"input": "[1,2]\n[3,4]", "output": "2.5"}
    ]$json$::jsonb,
    $json${
        "javascript": "function findMedianSortedArrays(nums1, nums2) {\n  \n}\n",
        "python": "class Solution:\n    def findMedianSortedArrays(self, nums1: list[int], nums2: list[int]) -> float:\n        pass\n",
        "cpp": "#include <vector>\nusing namespace std;\n\nclass Solution {\npublic:\n    double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {\n        \n    }\n};\n",
        "java": "class Solution {\n    public double findMedianSortedArrays(int[] nums1, int[] nums2) {\n        \n    }\n}\n"
    }$json$::jsonb,
    NULL,
    NULL,
    'approved'
)
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    difficulty = EXCLUDED.difficulty,
    time_limit = EXCLUDED.time_limit,
    memory_limit = EXCLUDED.memory_limit,
    tags = EXCLUDED.tags,
    examples = EXCLUDED.examples,
    test_cases = EXCLUDED.test_cases,
    code_template = EXCLUDED.code_template,
    run_config = EXCLUDED.run_config,
    judge_cases = EXCLUDED.judge_cases,
    review_status = EXCLUDED.review_status,
    updated_at = CURRENT_TIMESTAMP;

SELECT setval(
    pg_get_serial_sequence('problems', 'id'),
    GREATEST((SELECT COALESCE(MAX(id), 1) FROM problems), 1003)
);

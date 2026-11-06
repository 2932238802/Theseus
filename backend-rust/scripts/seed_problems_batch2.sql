-- 仅用于本地/测试环境的题目种子数据。
-- 使用固定 ID 1500-1699，便于通过 clean_dev.sql 安全清理。
-- 200 道函数式题目（run_config + 公开用例 + 隐藏 judge_cases），
-- 与 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）、seed_problems_82.sql（1116-1197）、seed_problems_100.sql（1200-1299）、seed_problems_batch1.sql（1300-1499）合计 600 题。

INSERT INTO problems (
    id, title, description, difficulty, time_limit, memory_limit, tags,
    examples, test_cases, code_template, run_config, judge_cases, review_status
) VALUES
(
    1500,
    '实现 strStr()',
    '给定两个字符串 haystack 和 needle，在 haystack 中找出 needle 第一次出现的起始下标。
如果 needle 不是 haystack 的一部分，返回 -1。
1 <= needle.length <= haystack.length <= 10^4，两个字符串都只包含小写英文字母。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "haystack = \"hello\", needle = \"ll\"",
    "output": "2"
  },
  {
    "input": "haystack = \"aaaaa\", needle = \"bba\"",
    "output": "-1"
  },
  {
    "input": "haystack = \"mississippi\", needle = \"issip\"",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "haystack = \"hello\", needle = \"ll\"",
    "output": "2"
  },
  {
    "input": "haystack = \"aaaaa\", needle = \"bba\"",
    "output": "-1"
  },
  {
    "input": "haystack = \"mississippi\", needle = \"issip\"",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var implementStrStr = function(haystack, needle) {\n};\n",
  "python": "class Solution:\n    def implementStrStr(self, haystack: str, needle: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int implementStrStr(std::string haystack, std::string needle) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int implementStrStr(String haystack, String needle) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "implementStrStr",
  "params": [
    {
      "name": "haystack",
      "type": "string"
    },
    {
      "name": "needle",
      "type": "string"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "hello",
        "ll"
      ],
      "expected": 2
    },
    {
      "args": [
        "aaaaa",
        "bba"
      ],
      "expected": -1
    },
    {
      "args": [
        "mississippi",
        "issip"
      ],
      "expected": 4
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      "a"
    ],
    "expected": 0
  },
  {
    "args": [
      "abc",
      "c"
    ],
    "expected": 2
  },
  {
    "args": [
      "abc",
      "abc"
    ],
    "expected": 0
  },
  {
    "args": [
      "abc",
      "d"
    ],
    "expected": -1
  },
  {
    "args": [
      "sadbutsad",
      "sad"
    ],
    "expected": 0
  },
  {
    "args": [
      "leetcode",
      "leeto"
    ],
    "expected": -1
  }
]$json$::jsonb,
    'approved'
),
(
    1501,
    '最后一个单词的长度',
    '给定仅由英文字母和空格组成的字符串 s，返回其中最后一个单词的长度。
单词由连续的非空格字符组成，单词之间以及字符串两侧可能有多余空格。
1 <= s.length <= 10^4，s 至少包含一个单词。',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "s = \"Hello World\"",
    "output": "5"
  },
  {
    "input": "s = \"   fly me   to   the moon  \"",
    "output": "4"
  },
  {
    "input": "s = \"luffy is still joyboy\"",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"Hello World\"",
    "output": "5"
  },
  {
    "input": "s = \"   fly me   to   the moon  \"",
    "output": "4"
  },
  {
    "input": "s = \"luffy is still joyboy\"",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var lengthOfLastWord = function(s) {\n};\n",
  "python": "class Solution:\n    def lengthOfLastWord(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int lengthOfLastWord(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int lengthOfLastWord(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "lengthOfLastWord",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "Hello World"
      ],
      "expected": 5
    },
    {
      "args": [
        "   fly me   to   the moon  "
      ],
      "expected": 4
    },
    {
      "args": [
        "luffy is still joyboy"
      ],
      "expected": 6
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a"
    ],
    "expected": 1
  },
  {
    "args": [
      "a "
    ],
    "expected": 1
  },
  {
    "args": [
      "Hello"
    ],
    "expected": 5
  },
  {
    "args": [
      "one"
    ],
    "expected": 3
  },
  {
    "args": [
      "two  three"
    ],
    "expected": 5
  },
  {
    "args": [
      "a b c"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1502,
    'x 的平方根',
    '给定一个非负整数 x，返回 x 的算术平方根向下取整后的整数部分。
0 <= x <= 2^31 - 1。',
    'easy',
    1000,
    256,
    ARRAY['数学', '二分查找'],
    $json$[
  {
    "input": "x = 4",
    "output": "2"
  },
  {
    "input": "x = 8",
    "output": "2"
  },
  {
    "input": "x = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "x = 4",
    "output": "2"
  },
  {
    "input": "x = 8",
    "output": "2"
  },
  {
    "input": "x = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var mySqrt = function(x) {\n};\n",
  "python": "class Solution:\n    def mySqrt(self, x: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int mySqrt(int x) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int mySqrt(int x) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "mySqrt",
  "params": [
    {
      "name": "x",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        4
      ],
      "expected": 2
    },
    {
      "args": [
        8
      ],
      "expected": 2
    },
    {
      "args": [
        0
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1
    ],
    "expected": 1
  },
  {
    "args": [
      2
    ],
    "expected": 1
  },
  {
    "args": [
      3
    ],
    "expected": 1
  },
  {
    "args": [
      2147395599
    ],
    "expected": 46339
  },
  {
    "args": [
      2147483647
    ],
    "expected": 46340
  },
  {
    "args": [
      100
    ],
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1503,
    '存在重复元素',
    '给定整数数组 nums，如果数组中存在至少出现两次的元素则返回 true，否则返回 false。
1 <= nums.length <= 10^5，-10^9 <= nums[i] <= 10^9。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '排序'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 1]",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "false"
  },
  {
    "input": "nums = [1, 1, 1, 3, 3, 4, 3, 2, 4, 2]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 1]",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "false"
  },
  {
    "input": "nums = [1, 1, 1, 3, 3, 4, 3, 2, 4, 2]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var containsDuplicate = function(nums) {\n};\n",
  "python": "class Solution:\n    def containsDuplicate(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool containsDuplicate(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean containsDuplicate(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "containsDuplicate",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3,
          1
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          1,
          1,
          1,
          3,
          3,
          4,
          3,
          2,
          4,
          2
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        2
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        -1,
        -1
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        0,
        0
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        2,
        14,
        18,
        22,
        22
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1504,
    '计数质数',
    '给定整数 n，统计所有小于 n 的质数的数量。
0 <= n <= 5 * 10^6。',
    'easy',
    1000,
    256,
    ARRAY['数学', '数组'],
    $json$[
  {
    "input": "n = 10",
    "output": "4"
  },
  {
    "input": "n = 0",
    "output": "0"
  },
  {
    "input": "n = 1",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 10",
    "output": "4"
  },
  {
    "input": "n = 0",
    "output": "0"
  },
  {
    "input": "n = 1",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countPrimes = function(n) {\n};\n",
  "python": "class Solution:\n    def countPrimes(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countPrimes(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countPrimes(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countPrimes",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        10
      ],
      "expected": 4
    },
    {
      "args": [
        0
      ],
      "expected": 0
    },
    {
      "args": [
        1
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2
    ],
    "expected": 0
  },
  {
    "args": [
      3
    ],
    "expected": 1
  },
  {
    "args": [
      4
    ],
    "expected": 2
  },
  {
    "args": [
      5
    ],
    "expected": 2
  },
  {
    "args": [
      100
    ],
    "expected": 25
  },
  {
    "args": [
      1000
    ],
    "expected": 168
  }
]$json$::jsonb,
    'approved'
),
(
    1505,
    'Nim 游戏',
    '桌上有 n 枚石子，两名玩家轮流取走 1 到 3 枚石子，取走最后一枚石子的人获胜。
你作为先手，双方都采取最优策略，返回你能否获胜。
1 <= n <= 2^31 - 1。',
    'easy',
    1000,
    256,
    ARRAY['数学', '博弈'],
    $json$[
  {
    "input": "n = 4",
    "output": "false"
  },
  {
    "input": "n = 1",
    "output": "true"
  },
  {
    "input": "n = 2",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4",
    "output": "false"
  },
  {
    "input": "n = 1",
    "output": "true"
  },
  {
    "input": "n = 2",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canWinNim = function(n) {\n};\n",
  "python": "class Solution:\n    def canWinNim(self, n: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canWinNim(int n) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canWinNim(int n) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canWinNim",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        4
      ],
      "expected": false
    },
    {
      "args": [
        1
      ],
      "expected": true
    },
    {
      "args": [
        2
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      3
    ],
    "expected": true
  },
  {
    "args": [
      5
    ],
    "expected": true
  },
  {
    "args": [
      8
    ],
    "expected": false
  },
  {
    "args": [
      12
    ],
    "expected": false
  },
  {
    "args": [
      100
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1506,
    '2 的幂',
    '给定一个整数 n，判断它是否为 2 的整数次幂。
n 在 32 位有符号整数范围内。',
    'easy',
    1000,
    256,
    ARRAY['数学', '位运算'],
    $json$[
  {
    "input": "n = 1",
    "output": "true"
  },
  {
    "input": "n = 16",
    "output": "true"
  },
  {
    "input": "n = 3",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 1",
    "output": "true"
  },
  {
    "input": "n = 16",
    "output": "true"
  },
  {
    "input": "n = 3",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isPowerOfTwo = function(n) {\n};\n",
  "python": "class Solution:\n    def isPowerOfTwo(self, n: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isPowerOfTwo(int n) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isPowerOfTwo(int n) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isPowerOfTwo",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        1
      ],
      "expected": true
    },
    {
      "args": [
        16
      ],
      "expected": true
    },
    {
      "args": [
        3
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      0
    ],
    "expected": false
  },
  {
    "args": [
      2
    ],
    "expected": true
  },
  {
    "args": [
      4
    ],
    "expected": true
  },
  {
    "args": [
      6
    ],
    "expected": false
  },
  {
    "args": [
      -16
    ],
    "expected": false
  },
  {
    "args": [
      1024
    ],
    "expected": true
  },
  {
    "args": [
      2147483647
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1507,
    '验证回文字符串 II',
    '给定一个只含小写英文字母的字符串 s，最多允许删除一个字符。
判断能否通过至多删除一个字符使 s 变成回文串，可以则返回 true，否则返回 false。
1 <= s.length <= 10^5。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针', '贪心'],
    $json$[
  {
    "input": "s = \"aba\"",
    "output": "true"
  },
  {
    "input": "s = \"abca\"",
    "output": "true"
  },
  {
    "input": "s = \"abc\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aba\"",
    "output": "true"
  },
  {
    "input": "s = \"abca\"",
    "output": "true"
  },
  {
    "input": "s = \"abc\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var validPalindromeII = function(s) {\n};\n",
  "python": "class Solution:\n    def validPalindromeII(self, s: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool validPalindromeII(std::string s) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean validPalindromeII(String s) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "validPalindromeII",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "aba"
      ],
      "expected": true
    },
    {
      "args": [
        "abca"
      ],
      "expected": true
    },
    {
      "args": [
        "abc"
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a"
    ],
    "expected": true
  },
  {
    "args": [
      "ab"
    ],
    "expected": true
  },
  {
    "args": [
      "abcba"
    ],
    "expected": true
  },
  {
    "args": [
      "abcdef"
    ],
    "expected": false
  },
  {
    "args": [
      "deeee"
    ],
    "expected": true
  },
  {
    "args": [
      "racecar"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1508,
    '最常见的单词',
    '给定一个字符串 paragraph 和一个禁用单词列表 banned，返回 paragraph 中出现次数最多且不在 banned 中的单词。
单词由英文字母组成，比较时忽略大小写，结果全部小写；标点符号和空格用于分隔单词。
paragraph 至少包含一个非禁用单词，且出现次数最多的候选单词唯一。
1 <= paragraph.length <= 1000，0 <= banned.length <= 100，banned[i] 只含小写英文字母。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "paragraph = \"Bob hit a ball, the hit BALL flew far after it was hit.\", banned = [\"hit\"]",
    "output": "\"ball\""
  },
  {
    "input": "paragraph = \"a.\", banned = []",
    "output": "\"a\""
  },
  {
    "input": "paragraph = \"Bob\", banned = []",
    "output": "\"bob\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "paragraph = \"Bob hit a ball, the hit BALL flew far after it was hit.\", banned = [\"hit\"]",
    "output": "\"ball\""
  },
  {
    "input": "paragraph = \"a.\", banned = []",
    "output": "\"a\""
  },
  {
    "input": "paragraph = \"Bob\", banned = []",
    "output": "\"bob\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var mostCommonWord = function(paragraph, banned) {\n};\n",
  "python": "class Solution:\n    def mostCommonWord(self, paragraph: str, banned: list[str]) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string mostCommonWord(std::string paragraph, std::vector<std::string>& banned) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String mostCommonWord(String paragraph, String[] banned) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "mostCommonWord",
  "params": [
    {
      "name": "paragraph",
      "type": "string"
    },
    {
      "name": "banned",
      "type": "string[]"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "Bob hit a ball, the hit BALL flew far after it was hit.",
        [
          "hit"
        ]
      ],
      "expected": "ball"
    },
    {
      "args": [
        "a.",
        []
      ],
      "expected": "a"
    },
    {
      "args": [
        "Bob",
        []
      ],
      "expected": "bob"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a, a, a, b,b,b,c",
      [
        "a"
      ]
    ],
    "expected": "b"
  },
  {
    "args": [
      "It's a test, isn't it?",
      []
    ],
    "expected": "it"
  },
  {
    "args": [
      "a b c a b a",
      []
    ],
    "expected": "a"
  },
  {
    "args": [
      "Hello hello world",
      [
        "world"
      ]
    ],
    "expected": "hello"
  },
  {
    "args": [
      "a b c",
      [
        "a",
        "b"
      ]
    ],
    "expected": "c"
  }
]$json$::jsonb,
    'approved'
),
(
    1509,
    '字符串中的单词数',
    '给定字符串 s，统计其中单词的数量。
单词是连续的非空格字符段，单词之间可能有一个或多个空格，字符串首尾也可能有空格。空字符串或全空格字符串的单词数为 0。
0 <= s.length <= 10^4。',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "s = \"Hello, my name is John\"",
    "output": "5"
  },
  {
    "input": "s = \"\"",
    "output": "0"
  },
  {
    "input": "s = \"          \"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"Hello, my name is John\"",
    "output": "5"
  },
  {
    "input": "s = \"\"",
    "output": "0"
  },
  {
    "input": "s = \"          \"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countSegments = function(s) {\n};\n",
  "python": "class Solution:\n    def countSegments(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countSegments(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countSegments(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countSegments",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "Hello, my name is John"
      ],
      "expected": 5
    },
    {
      "args": [
        ""
      ],
      "expected": 0
    },
    {
      "args": [
        "          "
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a"
    ],
    "expected": 1
  },
  {
    "args": [
      "a b"
    ],
    "expected": 2
  },
  {
    "args": [
      "  a  b  "
    ],
    "expected": 2
  },
  {
    "args": [
      "a, b, c"
    ],
    "expected": 3
  },
  {
    "args": [
      "x"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1510,
    '和为零的 N 个不同整数',
    '给定整数 n，返回 n 个互不相同的整数，使它们的和为 0。
为保证输出唯一，请按如下顺序构造：依次输出 1、-1、2、-2、3、-3，直到凑够 n 个数；如果 n 为奇数，最后再输出一个 0。
1 <= n <= 1000。',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "n = 5",
    "output": "[1, -1, 2, -2, 0]"
  },
  {
    "input": "n = 3",
    "output": "[1, -1, 0]"
  },
  {
    "input": "n = 1",
    "output": "[0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5",
    "output": "[1, -1, 2, -2, 0]"
  },
  {
    "input": "n = 3",
    "output": "[1, -1, 0]"
  },
  {
    "input": "n = 1",
    "output": "[0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumZero = function(n) {\n};\n",
  "python": "class Solution:\n    def sumZero(self, n: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> sumZero(int n) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] sumZero(int n) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumZero",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        5
      ],
      "expected": [
        1,
        -1,
        2,
        -2,
        0
      ]
    },
    {
      "args": [
        3
      ],
      "expected": [
        1,
        -1,
        0
      ]
    },
    {
      "args": [
        1
      ],
      "expected": [
        0
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2
    ],
    "expected": [
      1,
      -1
    ]
  },
  {
    "args": [
      4
    ],
    "expected": [
      1,
      -1,
      2,
      -2
    ]
  },
  {
    "args": [
      6
    ],
    "expected": [
      1,
      -1,
      2,
      -2,
      3,
      -3
    ]
  },
  {
    "args": [
      7
    ],
    "expected": [
      1,
      -1,
      2,
      -2,
      3,
      -3,
      0
    ]
  },
  {
    "args": [
      10
    ],
    "expected": [
      1,
      -1,
      2,
      -2,
      3,
      -3,
      4,
      -4,
      5,
      -5
    ]
  },
  {
    "args": [
      99
    ],
    "expected": [
      1,
      -1,
      2,
      -2,
      3,
      -3,
      4,
      -4,
      5,
      -5,
      6,
      -6,
      7,
      -7,
      8,
      -8,
      9,
      -9,
      10,
      -10,
      11,
      -11,
      12,
      -12,
      13,
      -13,
      14,
      -14,
      15,
      -15,
      16,
      -16,
      17,
      -17,
      18,
      -18,
      19,
      -19,
      20,
      -20,
      21,
      -21,
      22,
      -22,
      23,
      -23,
      24,
      -24,
      25,
      -25,
      26,
      -26,
      27,
      -27,
      28,
      -28,
      29,
      -29,
      30,
      -30,
      31,
      -31,
      32,
      -32,
      33,
      -33,
      34,
      -34,
      35,
      -35,
      36,
      -36,
      37,
      -37,
      38,
      -38,
      39,
      -39,
      40,
      -40,
      41,
      -41,
      42,
      -42,
      43,
      -43,
      44,
      -44,
      45,
      -45,
      46,
      -46,
      47,
      -47,
      48,
      -48,
      49,
      -49,
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1511,
    '键盘行',
    '给定字符串数组 words，返回其中能够只用美式键盘同一行字母打出的单词，保持它们在输入中的相对顺序。
键盘三行分别为 "qwertyuiop"、"asdfghjkl"、"zxcvbnm"，判断时忽略字母大小写，返回原字符串。
1 <= words.length <= 20，1 <= words[i].length <= 100，单词只含英文字母。',
    'easy',
    1000,
    256,
    ARRAY['数组', '字符串', '哈希表'],
    $json$[
  {
    "input": "words = [\"Hello\", \"Alaska\", \"Dad\", \"Peace\"]",
    "output": "[\"Alaska\", \"Dad\"]"
  },
  {
    "input": "words = [\"omk\"]",
    "output": "[]"
  },
  {
    "input": "words = [\"adsdf\", \"sfd\"]",
    "output": "[\"adsdf\", \"sfd\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"Hello\", \"Alaska\", \"Dad\", \"Peace\"]",
    "output": "[\"Alaska\", \"Dad\"]"
  },
  {
    "input": "words = [\"omk\"]",
    "output": "[]"
  },
  {
    "input": "words = [\"adsdf\", \"sfd\"]",
    "output": "[\"adsdf\", \"sfd\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findWords = function(words) {\n};\n",
  "python": "class Solution:\n    def findWords(self, words: list[str]) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> findWords(std::vector<std::string>& words) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] findWords(String[] words) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findWords",
  "params": [
    {
      "name": "words",
      "type": "string[]"
    }
  ],
  "return_type": "string[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "Hello",
          "Alaska",
          "Dad",
          "Peace"
        ]
      ],
      "expected": [
        "Alaska",
        "Dad"
      ]
    },
    {
      "args": [
        [
          "omk"
        ]
      ],
      "expected": []
    },
    {
      "args": [
        [
          "adsdf",
          "sfd"
        ]
      ],
      "expected": [
        "adsdf",
        "sfd"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "A",
        "B"
      ]
    ],
    "expected": [
      "A",
      "B"
    ]
  },
  {
    "args": [
      [
        "qwerty",
        "asdfgh"
      ]
    ],
    "expected": [
      "qwerty",
      "asdfgh"
    ]
  },
  {
    "args": [
      [
        "zxc"
      ]
    ],
    "expected": [
      "zxc"
    ]
  },
  {
    "args": [
      [
        "a",
        "b",
        "c"
      ]
    ],
    "expected": [
      "a",
      "b",
      "c"
    ]
  },
  {
    "args": [
      [
        "QWERTY",
        "asdf",
        "ZXCV"
      ]
    ],
    "expected": [
      "QWERTY",
      "asdf",
      "ZXCV"
    ]
  },
  {
    "args": [
      [
        "hello",
        "world"
      ]
    ],
    "expected": []
  }
]$json$::jsonb,
    'approved'
),
(
    1512,
    '反转字符串中的单词 III',
    '给定字符串 s，单词之间以单个空格分隔，单词只含英文字母。
反转每个单词内部的字符顺序，保持单词顺序和空格位置不变，返回结果。
1 <= s.length <= 10^4。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "s = \"Let's take LeetCode contest\"",
    "output": "\"s'teL ekat edoCteeL tsetnoc\""
  },
  {
    "input": "s = \"Mr Ding\"",
    "output": "\"rM gniD\""
  },
  {
    "input": "s = \"hello\"",
    "output": "\"olleh\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"Let's take LeetCode contest\"",
    "output": "\"s'teL ekat edoCteeL tsetnoc\""
  },
  {
    "input": "s = \"Mr Ding\"",
    "output": "\"rM gniD\""
  },
  {
    "input": "s = \"hello\"",
    "output": "\"olleh\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var reverseWordsIII = function(s) {\n};\n",
  "python": "class Solution:\n    def reverseWordsIII(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string reverseWordsIII(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String reverseWordsIII(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reverseWordsIII",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "Let's take LeetCode contest"
      ],
      "expected": "s'teL ekat edoCteeL tsetnoc"
    },
    {
      "args": [
        "Mr Ding"
      ],
      "expected": "rM gniD"
    },
    {
      "args": [
        "hello"
      ],
      "expected": "olleh"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a"
    ],
    "expected": "a"
  },
  {
    "args": [
      "ab cd"
    ],
    "expected": "ba dc"
  },
  {
    "args": [
      "hello world"
    ],
    "expected": "olleh dlrow"
  },
  {
    "args": [
      "I love coding"
    ],
    "expected": "I evol gnidoc"
  },
  {
    "args": [
      "a b c"
    ],
    "expected": "a b c"
  }
]$json$::jsonb,
    'approved'
),
(
    1513,
    '两个列表的最小索引总和',
    '给定两个餐厅名称数组 list1 和 list2，名称在各自数组中互不相同，且至少有一个名称同时出现在两个数组中。
对每个同时出现的餐厅，记它在 list1 中的下标为 i、在 list2 中的下标为 j，索引和为 i + j。
返回所有索引和最小的餐厅名称，按字典序升序排列。
1 <= list1.length, list2.length <= 1000，名称只含英文字母和空格。',
    'easy',
    1000,
    256,
    ARRAY['数组', '字符串', '哈希表'],
    $json$[
  {
    "input": "list1 = [\"Shogun\", \"Tapioca Express\", \"Burger King\", \"KFC\"], list2 = [\"Piatti\", \"The Grill at Torrey Pines\", \"Hungry Hunter Steakhouse\", \"Shogun\"]",
    "output": "[\"Shogun\"]"
  },
  {
    "input": "list1 = [\"Shogun\", \"Tapioca Express\", \"Burger King\", \"KFC\"], list2 = [\"KFC\", \"Shogun\", \"Burger King\"]",
    "output": "[\"Shogun\"]"
  },
  {
    "input": "list1 = [\"Shogun\", \"Tapioca Express\", \"Burger King\", \"KFC\"], list2 = [\"KFC\", \"Burger King\", \"Tapioca Express\", \"Shogun\"]",
    "output": "[\"Burger King\", \"KFC\", \"Shogun\", \"Tapioca Express\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "list1 = [\"Shogun\", \"Tapioca Express\", \"Burger King\", \"KFC\"], list2 = [\"Piatti\", \"The Grill at Torrey Pines\", \"Hungry Hunter Steakhouse\", \"Shogun\"]",
    "output": "[\"Shogun\"]"
  },
  {
    "input": "list1 = [\"Shogun\", \"Tapioca Express\", \"Burger King\", \"KFC\"], list2 = [\"KFC\", \"Shogun\", \"Burger King\"]",
    "output": "[\"Shogun\"]"
  },
  {
    "input": "list1 = [\"Shogun\", \"Tapioca Express\", \"Burger King\", \"KFC\"], list2 = [\"KFC\", \"Burger King\", \"Tapioca Express\", \"Shogun\"]",
    "output": "[\"Burger King\", \"KFC\", \"Shogun\", \"Tapioca Express\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findRestaurant = function(list1, list2) {\n};\n",
  "python": "class Solution:\n    def findRestaurant(self, list1: list[str], list2: list[str]) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> findRestaurant(std::vector<std::string>& list1, std::vector<std::string>& list2) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] findRestaurant(String[] list1, String[] list2) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findRestaurant",
  "params": [
    {
      "name": "list1",
      "type": "string[]"
    },
    {
      "name": "list2",
      "type": "string[]"
    }
  ],
  "return_type": "string[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "Shogun",
          "Tapioca Express",
          "Burger King",
          "KFC"
        ],
        [
          "Piatti",
          "The Grill at Torrey Pines",
          "Hungry Hunter Steakhouse",
          "Shogun"
        ]
      ],
      "expected": [
        "Shogun"
      ]
    },
    {
      "args": [
        [
          "Shogun",
          "Tapioca Express",
          "Burger King",
          "KFC"
        ],
        [
          "KFC",
          "Shogun",
          "Burger King"
        ]
      ],
      "expected": [
        "Shogun"
      ]
    },
    {
      "args": [
        [
          "Shogun",
          "Tapioca Express",
          "Burger King",
          "KFC"
        ],
        [
          "KFC",
          "Burger King",
          "Tapioca Express",
          "Shogun"
        ]
      ],
      "expected": [
        "Burger King",
        "KFC",
        "Shogun",
        "Tapioca Express"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "a",
        "b",
        "c"
      ],
      [
        "c",
        "b",
        "a"
      ]
    ],
    "expected": [
      "a",
      "b",
      "c"
    ]
  },
  {
    "args": [
      [
        "a",
        "b"
      ],
      [
        "a",
        "b"
      ]
    ],
    "expected": [
      "a"
    ]
  },
  {
    "args": [
      [
        "x",
        "y",
        "z"
      ],
      [
        "y",
        "x"
      ]
    ],
    "expected": [
      "x",
      "y"
    ]
  },
  {
    "args": [
      [
        "p",
        "q",
        "r"
      ],
      [
        "r",
        "p"
      ]
    ],
    "expected": [
      "p"
    ]
  },
  {
    "args": [
      [
        "a",
        "b",
        "c",
        "d"
      ],
      [
        "b",
        "a"
      ]
    ],
    "expected": [
      "a",
      "b"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1514,
    '字符的最短距离',
    '给定字符串 s 和字符 c（用长度为 1 的字符串表示），c 在 s 中至少出现一次。
返回一个整数数组 answer，其中 answer[i] 表示 s[i] 到 s 中最近的字符 c 的距离。
1 <= s.length <= 10^4，s 和 c 只含小写英文字母。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '数组', '双指针'],
    $json$[
  {
    "input": "s = \"loveleetcode\", c = \"e\"",
    "output": "[3, 2, 1, 0, 1, 0, 0, 1, 2, 2, 1, 0]"
  },
  {
    "input": "s = \"aaab\", c = \"b\"",
    "output": "[3, 2, 1, 0]"
  },
  {
    "input": "s = \"a\", c = \"a\"",
    "output": "[0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"loveleetcode\", c = \"e\"",
    "output": "[3, 2, 1, 0, 1, 0, 0, 1, 2, 2, 1, 0]"
  },
  {
    "input": "s = \"aaab\", c = \"b\"",
    "output": "[3, 2, 1, 0]"
  },
  {
    "input": "s = \"a\", c = \"a\"",
    "output": "[0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var shortestToChar = function(s, c) {\n};\n",
  "python": "class Solution:\n    def shortestToChar(self, s: str, c: str) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> shortestToChar(std::string s, std::string c) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] shortestToChar(String s, String c) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "shortestToChar",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "c",
      "type": "string"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "loveleetcode",
        "e"
      ],
      "expected": [
        3,
        2,
        1,
        0,
        1,
        0,
        0,
        1,
        2,
        2,
        1,
        0
      ]
    },
    {
      "args": [
        "aaab",
        "b"
      ],
      "expected": [
        3,
        2,
        1,
        0
      ]
    },
    {
      "args": [
        "a",
        "a"
      ],
      "expected": [
        0
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abaa",
      "a"
    ],
    "expected": [
      0,
      1,
      0,
      0
    ]
  },
  {
    "args": [
      "baab",
      "a"
    ],
    "expected": [
      1,
      0,
      0,
      1
    ]
  },
  {
    "args": [
      "abcabc",
      "c"
    ],
    "expected": [
      2,
      1,
      0,
      1,
      1,
      0
    ]
  },
  {
    "args": [
      "cccc",
      "c"
    ],
    "expected": [
      0,
      0,
      0,
      0
    ]
  },
  {
    "args": [
      "ab",
      "b"
    ],
    "expected": [
      1,
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1515,
    '至少是其他数字两倍的最大数',
    '给定整数数组 nums，最大元素是唯一的。
如果最大元素至少是数组中其余每个元素的两倍，返回最大元素的下标；否则返回 -1。
1 <= nums.length <= 50，0 <= nums[i] <= 100。',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "nums = [3, 6, 1, 0]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "-1"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 6, 1, 0]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "-1"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var dominantIndex = function(nums) {\n};\n",
  "python": "class Solution:\n    def dominantIndex(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int dominantIndex(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int dominantIndex(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "dominantIndex",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          3,
          6,
          1,
          0
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4
        ]
      ],
      "expected": -1
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        0
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        0,
        0,
        0,
        1
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        5,
        3
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        2,
        3,
        1
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        0
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1516,
    '最长和谐子序列',
    '和谐子序列是指一个子序列中最大值与最小值恰好相差 1。
给定整数数组 nums，返回其最长和谐子序列的长度；不存在这样的子序列时返回 0。
子序列不要求连续，但必须保持元素相对顺序。
1 <= nums.length <= 2 * 10^4，-10^9 <= nums[i] <= 10^9。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "nums = [1, 3, 2, 2, 5, 2, 3, 7]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "2"
  },
  {
    "input": "nums = [1, 1, 1, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3, 2, 2, 5, 2, 3, 7]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "2"
  },
  {
    "input": "nums = [1, 1, 1, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findLHS = function(nums) {\n};\n",
  "python": "class Solution:\n    def findLHS(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findLHS(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findLHS(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findLHS",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          3,
          2,
          2,
          5,
          2,
          3,
          7
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1,
          1,
          1,
          1
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        1,
        2,
        2,
        3,
        3,
        4
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        2,
        2,
        1,
        1,
        5,
        3,
        3,
        3
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        1,
        3,
        5,
        7
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        1,
        1,
        2,
        2,
        2,
        2
      ]
    ],
    "expected": 7
  }
]$json$::jsonb,
    'approved'
),
(
    1517,
    '二分查找',
    '给定一个元素互不相同且按升序排列的整数数组 nums，以及目标值 target。
如果 target 存在，返回它的下标；否则返回 -1。
1 <= nums.length <= 10^4，-10^4 <= nums[i], target <= 10^4。',
    'easy',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "nums = [-1, 0, 3, 5, 9, 12], target = 9",
    "output": "4"
  },
  {
    "input": "nums = [-1, 0, 3, 5, 9, 12], target = 2",
    "output": "-1"
  },
  {
    "input": "nums = [5], target = 5",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [-1, 0, 3, 5, 9, 12], target = 9",
    "output": "4"
  },
  {
    "input": "nums = [-1, 0, 3, 5, 9, 12], target = 2",
    "output": "-1"
  },
  {
    "input": "nums = [5], target = 5",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var binarySearch = function(nums, target) {\n};\n",
  "python": "class Solution:\n    def binarySearch(self, nums: list[int], target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int binarySearch(std::vector<int>& nums, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int binarySearch(int[] nums, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "binarySearch",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "target",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          -1,
          0,
          3,
          5,
          9,
          12
        ],
        9
      ],
      "expected": 4
    },
    {
      "args": [
        [
          -1,
          0,
          3,
          5,
          9,
          12
        ],
        2
      ],
      "expected": -1
    },
    {
      "args": [
        [
          5
        ],
        5
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        5
      ],
      -5
    ],
    "expected": -1
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ],
      1
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ],
      5
    ],
    "expected": 4
  },
  {
    "args": [
      [
        1,
        3,
        5,
        7,
        9
      ],
      7
    ],
    "expected": 3
  },
  {
    "args": [
      [
        -10,
        -5,
        0,
        5,
        10
      ],
      -10
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1518,
    '写字符串需要的行数',
    '给定长度为 26 的数组 widths，其中 widths[i] 表示字母表中第 i 个小写字母占用的宽度。
现在要把字符串 s 按字符顺序从左到右排版，每行总宽度不能超过 100，字符不能拆分到两行。
返回一个长度为 2 的数组 [行数, 最后一行已使用的宽度]。
1 <= s.length <= 1000，2 <= widths[i] <= 10，s 只含小写英文字母。',
    'easy',
    1000,
    256,
    ARRAY['数组', '字符串', '模拟'],
    $json$[
  {
    "input": "widths = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10], s = \"abcdefghijklmnopqrstuvwxyz\"",
    "output": "[3, 60]"
  },
  {
    "input": "widths = [4, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10], s = \"bbbcccdddaaa\"",
    "output": "[2, 4]"
  },
  {
    "input": "widths = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10], s = \"a\"",
    "output": "[1, 10]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "widths = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10], s = \"abcdefghijklmnopqrstuvwxyz\"",
    "output": "[3, 60]"
  },
  {
    "input": "widths = [4, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10], s = \"bbbcccdddaaa\"",
    "output": "[2, 4]"
  },
  {
    "input": "widths = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10], s = \"a\"",
    "output": "[1, 10]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numberOfLines = function(widths, s) {\n};\n",
  "python": "class Solution:\n    def numberOfLines(self, widths: list[int], s: str) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> numberOfLines(std::vector<int>& widths, std::string s) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] numberOfLines(int[] widths, String s) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numberOfLines",
  "params": [
    {
      "name": "widths",
      "type": "int[]"
    },
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10
        ],
        "abcdefghijklmnopqrstuvwxyz"
      ],
      "expected": [
        3,
        60
      ]
    },
    {
      "args": [
        [
          4,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10
        ],
        "bbbcccdddaaa"
      ],
      "expected": [
        2,
        4
      ]
    },
    {
      "args": [
        [
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10,
          10
        ],
        "a"
      ],
      "expected": [
        1,
        10
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10
      ],
      "zzzzzzzzzz"
    ],
    "expected": [
      1,
      100
    ]
  },
  {
    "args": [
      [
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10
      ],
      "zzzzzzzzzzz"
    ],
    "expected": [
      2,
      10
    ]
  },
  {
    "args": [
      [
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10
      ],
      "abcde"
    ],
    "expected": [
      1,
      50
    ]
  },
  {
    "args": [
      [
        4,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10
      ],
      "aaa"
    ],
    "expected": [
      1,
      12
    ]
  },
  {
    "args": [
      [
        4,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10
      ],
      "aaaaaaaaaaaaaaaaaaaaaaaaa"
    ],
    "expected": [
      1,
      100
    ]
  },
  {
    "args": [
      [
        4,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10
      ],
      "aaaaaaaaaaaaaaaaaaaaaaaaaa"
    ],
    "expected": [
      2,
      4
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1519,
    '翻转图像',
    '给定一个 n x n 的二进制矩阵 image。
对每一行，先将其水平翻转（左右颠倒），再把每个元素取反（0 变 1，1 变 0）。
返回处理后的矩阵。
1 <= n <= 20，image[i][j] 只会是 0 或 1。',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵', '模拟'],
    $json$[
  {
    "input": "image = [[1, 1, 0], [1, 0, 1], [0, 0, 0]]",
    "output": "[[1, 0, 0], [0, 1, 0], [1, 1, 1]]"
  },
  {
    "input": "image = [[1, 1, 0, 0], [1, 0, 0, 1], [0, 1, 1, 1], [1, 0, 1, 0]]",
    "output": "[[1, 1, 0, 0], [0, 1, 1, 0], [0, 0, 0, 1], [1, 0, 1, 0]]"
  },
  {
    "input": "image = [[0]]",
    "output": "[[1]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "image = [[1, 1, 0], [1, 0, 1], [0, 0, 0]]",
    "output": "[[1, 0, 0], [0, 1, 0], [1, 1, 1]]"
  },
  {
    "input": "image = [[1, 1, 0, 0], [1, 0, 0, 1], [0, 1, 1, 1], [1, 0, 1, 0]]",
    "output": "[[1, 1, 0, 0], [0, 1, 1, 0], [0, 0, 0, 1], [1, 0, 1, 0]]"
  },
  {
    "input": "image = [[0]]",
    "output": "[[1]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var flipAndInvertImage = function(image) {\n};\n",
  "python": "class Solution:\n    def flipAndInvertImage(self, image: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> flipAndInvertImage(std::vector<std::vector<int>>& image) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] flipAndInvertImage(int[][] image) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "flipAndInvertImage",
  "params": [
    {
      "name": "image",
      "type": "int[][]"
    }
  ],
  "return_type": "int[][]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            1,
            0
          ],
          [
            1,
            0,
            1
          ],
          [
            0,
            0,
            0
          ]
        ]
      ],
      "expected": [
        [
          1,
          0,
          0
        ],
        [
          0,
          1,
          0
        ],
        [
          1,
          1,
          1
        ]
      ]
    },
    {
      "args": [
        [
          [
            1,
            1,
            0,
            0
          ],
          [
            1,
            0,
            0,
            1
          ],
          [
            0,
            1,
            1,
            1
          ],
          [
            1,
            0,
            1,
            0
          ]
        ]
      ],
      "expected": [
        [
          1,
          1,
          0,
          0
        ],
        [
          0,
          1,
          1,
          0
        ],
        [
          0,
          0,
          0,
          1
        ],
        [
          1,
          0,
          1,
          0
        ]
      ]
    },
    {
      "args": [
        [
          [
            0
          ]
        ]
      ],
      "expected": [
        [
          1
        ]
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1
        ]
      ]
    ],
    "expected": [
      [
        0
      ]
    ]
  },
  {
    "args": [
      [
        [
          1,
          0
        ],
        [
          0,
          1
        ]
      ]
    ],
    "expected": [
      [
        1,
        0
      ],
      [
        0,
        1
      ]
    ]
  },
  {
    "args": [
      [
        [
          0,
          0,
          1
        ],
        [
          1,
          1,
          0
        ],
        [
          1,
          0,
          0
        ]
      ]
    ],
    "expected": [
      [
        0,
        1,
        1
      ],
      [
        1,
        0,
        0
      ],
      [
        1,
        1,
        0
      ]
    ]
  },
  {
    "args": [
      [
        [
          1,
          1,
          1
        ],
        [
          0,
          0,
          0
        ],
        [
          1,
          0,
          1
        ]
      ]
    ],
    "expected": [
      [
        0,
        0,
        0
      ],
      [
        1,
        1,
        1
      ],
      [
        0,
        1,
        0
      ]
    ]
  },
  {
    "args": [
      [
        [
          0,
          1
        ]
      ]
    ],
    "expected": [
      [
        0,
        1
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1520,
    '最小差值 I',
    '给定整数数组 nums 和非负整数 k。对数组中的每个元素 nums[i]，可以选择一个区间 [-k, k] 内的整数加到它上面，每个元素独立选择。
返回操作后数组最大值与最小值之差的最小可能值。
1 <= nums.length <= 10^4，0 <= k <= 10^4。',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "nums = [1], k = 0",
    "output": "0"
  },
  {
    "input": "nums = [0, 10], k = 2",
    "output": "6"
  },
  {
    "input": "nums = [1, 3, 6], k = 3",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1], k = 0",
    "output": "0"
  },
  {
    "input": "nums = [0, 10], k = 2",
    "output": "6"
  },
  {
    "input": "nums = [1, 3, 6], k = 3",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestRangeI = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def smallestRangeI(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int smallestRangeI(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int smallestRangeI(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestRangeI",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1
        ],
        0
      ],
      "expected": 0
    },
    {
      "args": [
        [
          0,
          10
        ],
        2
      ],
      "expected": 6
    },
    {
      "args": [
        [
          1,
          3,
          6
        ],
        3
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        5
      ],
      3
    ],
    "expected": 0
  },
  {
    "args": [
      [
        0,
        0
      ],
      0
    ],
    "expected": 0
  },
  {
    "args": [
      [
        2,
        7,
        2
      ],
      1
    ],
    "expected": 3
  },
  {
    "args": [
      [
        -5,
        5
      ],
      3
    ],
    "expected": 4
  },
  {
    "args": [
      [
        10,
        1,
        7
      ],
      5
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1521,
    '增减字符串匹配',
    '给定只包含字符 ''I''（表示增加）和 ''D''（表示减少）的字符串 s，长度为 n，要求返回 [0, n] 的一个排列 perm，使得：
当 s[i] == ''I'' 时 perm[i] < perm[i + 1]，当 s[i] == ''D'' 时 perm[i] > perm[i + 1]。
为得到唯一确定的输出，请使用下述贪心构造：维护当前可用的最小值 low 和最大值 high，初始 low = 0、high = n。
依次遍历 s 的每个字符，遇到 ''I'' 时输出 low 并令 low 加一，遇到 ''D'' 时输出 high 并令 high 减一；遍历结束后再输出剩下的唯一数字。
1 <= s.length <= 10^5。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '数组', '贪心'],
    $json$[
  {
    "input": "s = \"IDID\"",
    "output": "[0, 4, 1, 3, 2]"
  },
  {
    "input": "s = \"III\"",
    "output": "[0, 1, 2, 3]"
  },
  {
    "input": "s = \"DDI\"",
    "output": "[3, 2, 0, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"IDID\"",
    "output": "[0, 4, 1, 3, 2]"
  },
  {
    "input": "s = \"III\"",
    "output": "[0, 1, 2, 3]"
  },
  {
    "input": "s = \"DDI\"",
    "output": "[3, 2, 0, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var diStringMatch = function(s) {\n};\n",
  "python": "class Solution:\n    def diStringMatch(self, s: str) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> diStringMatch(std::string s) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] diStringMatch(String s) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "diStringMatch",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "IDID"
      ],
      "expected": [
        0,
        4,
        1,
        3,
        2
      ]
    },
    {
      "args": [
        "III"
      ],
      "expected": [
        0,
        1,
        2,
        3
      ]
    },
    {
      "args": [
        "DDI"
      ],
      "expected": [
        3,
        2,
        0,
        1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "I"
    ],
    "expected": [
      0,
      1
    ]
  },
  {
    "args": [
      "D"
    ],
    "expected": [
      1,
      0
    ]
  },
  {
    "args": [
      "ID"
    ],
    "expected": [
      0,
      2,
      1
    ]
  },
  {
    "args": [
      "DID"
    ],
    "expected": [
      3,
      0,
      2,
      1
    ]
  },
  {
    "args": [
      "IIID"
    ],
    "expected": [
      0,
      1,
      2,
      4,
      3
    ]
  },
  {
    "args": [
      "DDDD"
    ],
    "expected": [
      4,
      3,
      2,
      1,
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1522,
    '重复 N 次的元素',
    '给定长度为 2n 的整数数组 nums，其中恰好有 n + 1 个不同的元素，并且其中一个元素恰好重复 n 次。
返回重复了 n 次的元素。
4 <= nums.length <= 10^4，且 nums.length 为偶数。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 3]",
    "output": "3"
  },
  {
    "input": "nums = [2, 1, 2, 5, 3, 2]",
    "output": "2"
  },
  {
    "input": "nums = [5, 1, 5, 2, 5, 3, 5, 4]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 3]",
    "output": "3"
  },
  {
    "input": "nums = [2, 1, 2, 5, 3, 2]",
    "output": "2"
  },
  {
    "input": "nums = [5, 1, 5, 2, 5, 3, 5, 4]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var repeatedNTimes = function(nums) {\n};\n",
  "python": "class Solution:\n    def repeatedNTimes(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int repeatedNTimes(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int repeatedNTimes(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "repeatedNTimes",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3,
          3
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          2,
          1,
          2,
          5,
          3,
          2
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          5,
          1,
          5,
          2,
          5,
          3,
          5,
          4
        ]
      ],
      "expected": 5
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        3,
        1,
        3,
        2
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        2,
        1,
        3
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        9,
        9,
        1,
        2
      ]
    ],
    "expected": 9
  },
  {
    "args": [
      [
        7,
        2,
        7,
        1,
        7,
        3,
        7,
        4
      ]
    ],
    "expected": 7
  },
  {
    "args": [
      [
        0,
        4,
        0,
        3,
        0,
        2,
        0,
        1
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1523,
    '有效的山脉数组',
    '给定整数数组 nums，如果它是有效的山脉数组则返回 true，否则返回 false。
有效山脉数组需满足：长度至少为 3；存在下标 i（0 < i < length - 1），使得从开头到 i 严格递增，从 i 到结尾严格递减。
1 <= nums.length <= 10^4。',
    'easy',
    1000,
    256,
    ARRAY['数组', '双指针'],
    $json$[
  {
    "input": "nums = [2, 1]",
    "output": "false"
  },
  {
    "input": "nums = [3, 5, 5]",
    "output": "false"
  },
  {
    "input": "nums = [0, 3, 2, 1]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 1]",
    "output": "false"
  },
  {
    "input": "nums = [3, 5, 5]",
    "output": "false"
  },
  {
    "input": "nums = [0, 3, 2, 1]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var validMountainArray = function(nums) {\n};\n",
  "python": "class Solution:\n    def validMountainArray(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool validMountainArray(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean validMountainArray(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "validMountainArray",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          2,
          1
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          3,
          5,
          5
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          0,
          3,
          2,
          1
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        9,
        8,
        7,
        6,
        5,
        4,
        3,
        2,
        1,
        0
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        2,
        3
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        3,
        2,
        1
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        3,
        2
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        0,
        1,
        2,
        1,
        0
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1524,
    '字符串的最大公因子',
    '给定两个字符串 str1 和 str2。如果存在字符串 X，使得 str1 和 str2 都可以由 X 重复若干次拼接而成，返回满足条件的最长字符串 X；否则返回空字符串。
1 <= str1.length, str2.length <= 1000，字符串只含大写英文字母。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '数学'],
    $json$[
  {
    "input": "str1 = \"ABCABC\", str2 = \"ABC\"",
    "output": "\"ABC\""
  },
  {
    "input": "str1 = \"ABABAB\", str2 = \"ABAB\"",
    "output": "\"AB\""
  },
  {
    "input": "str1 = \"LEET\", str2 = \"CODE\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "str1 = \"ABCABC\", str2 = \"ABC\"",
    "output": "\"ABC\""
  },
  {
    "input": "str1 = \"ABABAB\", str2 = \"ABAB\"",
    "output": "\"AB\""
  },
  {
    "input": "str1 = \"LEET\", str2 = \"CODE\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var gcdOfStrings = function(str1, str2) {\n};\n",
  "python": "class Solution:\n    def gcdOfStrings(self, str1: str, str2: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string gcdOfStrings(std::string str1, std::string str2) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String gcdOfStrings(String str1, String str2) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "gcdOfStrings",
  "params": [
    {
      "name": "str1",
      "type": "string"
    },
    {
      "name": "str2",
      "type": "string"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "ABCABC",
        "ABC"
      ],
      "expected": "ABC"
    },
    {
      "args": [
        "ABABAB",
        "ABAB"
      ],
      "expected": "AB"
    },
    {
      "args": [
        "LEET",
        "CODE"
      ],
      "expected": ""
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "ABC",
      "ABC"
    ],
    "expected": "ABC"
  },
  {
    "args": [
      "ABAB",
      "AB"
    ],
    "expected": "AB"
  },
  {
    "args": [
      "A",
      "A"
    ],
    "expected": "A"
  },
  {
    "args": [
      "ABCDEF",
      "ABC"
    ],
    "expected": ""
  },
  {
    "args": [
      "TAUXXTAUXXTAUXXTAUXXTAUXX",
      "TAUXXTAUXXTAUXXTAUXXTAUXXTAUXXTAUXXTAUXXTAUXX"
    ],
    "expected": "TAUXX"
  }
]$json$::jsonb,
    'approved'
),
(
    1525,
    '可以被一步捕获的棋子数',
    '给定一个 8 x 8 的棋盘 board，用字符串二维数组表示，每个格子是以下字符之一：
''.'' 表示空格，''p'' 表示可被捕获的黑色兵，''B'' 表示会阻挡车的白色象，''R'' 表示白色车（棋盘上恰好有一个）。
车的移动规则：选择上、下、左、右四个方向之一，沿该方向一直移动，直到遇到第一个非空格子。
如果第一个非空格子是 ''p''，则捕获该兵并停止；如果是 ''B''，则被挡住并停止；如果到达棋盘边缘也停止。
返回车在一步中能够捕获的兵的数量（每个方向最多捕获一个）。
board 固定为 8 行 8 列。',
    'easy',
    1000,
    256,
    ARRAY['数组', '模拟'],
    $json$[
  {
    "input": "board = [[\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \"p\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \"R\", \".\", \".\", \".\", \"p\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \"p\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"]]",
    "output": "3"
  },
  {
    "input": "board = [[\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \"p\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \"B\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \"R\", \".\", \"B\", \".\", \"p\"], [\".\", \".\", \".\", \"p\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"]]",
    "output": "1"
  },
  {
    "input": "board = [[\".\", \".\", \".\", \".\", \"p\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \"R\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \"p\", \".\", \".\", \".\"]]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "board = [[\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \"p\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \"R\", \".\", \".\", \".\", \"p\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \"p\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"]]",
    "output": "3"
  },
  {
    "input": "board = [[\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \"p\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \"B\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \"R\", \".\", \"B\", \".\", \"p\"], [\".\", \".\", \".\", \"p\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"]]",
    "output": "1"
  },
  {
    "input": "board = [[\".\", \".\", \".\", \".\", \"p\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \"R\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \".\", \".\", \".\", \".\"], [\".\", \".\", \".\", \".\", \"p\", \".\", \".\", \".\"]]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numRookCaptures = function(board) {\n};\n",
  "python": "class Solution:\n    def numRookCaptures(self, board: list[list[str]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numRookCaptures(std::vector<std::vector<std::string>>& board) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numRookCaptures(String[][] board) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numRookCaptures",
  "params": [
    {
      "name": "board",
      "type": "string[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            "p",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            "R",
            ".",
            ".",
            ".",
            "p"
          ],
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            "p",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            "p",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            "B",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            "R",
            ".",
            "B",
            ".",
            "p"
          ],
          [
            ".",
            ".",
            ".",
            "p",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ]
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          [
            ".",
            ".",
            ".",
            ".",
            "p",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            "R",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            ".",
            "."
          ],
          [
            ".",
            ".",
            ".",
            ".",
            "p",
            ".",
            ".",
            "."
          ]
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          "R",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          "p",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          "B",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          "p",
          "B",
          "R",
          "B",
          "p",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          "B",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          "p",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          "p",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          "p",
          "R",
          "p",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          "p",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          "R",
          "p",
          "p",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          "p",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ],
        [
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          ".",
          "."
        ]
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1526,
    '山脉数组的峰顶索引',
    '给定一个山脉数组 arr：它先严格递增再严格递减，长度至少为 3，且相邻元素不相等。
返回峰顶元素的下标。
3 <= arr.length <= 10^4，0 <= arr[i] <= 10^6。',
    'easy',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "arr = [0, 1, 0]",
    "output": "1"
  },
  {
    "input": "arr = [0, 2, 1, 0]",
    "output": "1"
  },
  {
    "input": "arr = [24, 69, 100, 99, 79, 78, 67, 36, 26, 19]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [0, 1, 0]",
    "output": "1"
  },
  {
    "input": "arr = [0, 2, 1, 0]",
    "output": "1"
  },
  {
    "input": "arr = [24, 69, 100, 99, 79, 78, 67, 36, 26, 19]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var peakIndexInMountainArray = function(arr) {\n};\n",
  "python": "class Solution:\n    def peakIndexInMountainArray(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int peakIndexInMountainArray(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int peakIndexInMountainArray(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "peakIndexInMountainArray",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          0,
          1,
          0
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          0,
          2,
          1,
          0
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          24,
          69,
          100,
          99,
          79,
          78,
          67,
          36,
          26,
          19
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        3,
        4,
        5,
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        0,
        10,
        5,
        2
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        0,
        1,
        2,
        3,
        4,
        5,
        4,
        3,
        2,
        1
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        1,
        2,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        3,
        5,
        4
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        0,
        4,
        3,
        2,
        1
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1527,
    '托普利茨矩阵',
    '给定一个 m x n 的整数矩阵 matrix。
如果矩阵中每一条从左上到右下的对角线上的元素都相同，则称它是托普利茨矩阵。
判断 matrix 是否为托普利茨矩阵，是则返回 true，否则返回 false。
1 <= m, n <= 20，0 <= matrix[i][j] <= 99。',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵'],
    $json$[
  {
    "input": "matrix = [[1, 2, 3, 4], [5, 1, 2, 3], [9, 5, 1, 2]]",
    "output": "true"
  },
  {
    "input": "matrix = [[1, 2], [2, 2]]",
    "output": "false"
  },
  {
    "input": "matrix = [[1]]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 2, 3, 4], [5, 1, 2, 3], [9, 5, 1, 2]]",
    "output": "true"
  },
  {
    "input": "matrix = [[1, 2], [2, 2]]",
    "output": "false"
  },
  {
    "input": "matrix = [[1]]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isToeplitzMatrix = function(matrix) {\n};\n",
  "python": "class Solution:\n    def isToeplitzMatrix(self, matrix: list[list[int]]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isToeplitzMatrix(std::vector<std::vector<int>>& matrix) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isToeplitzMatrix(int[][] matrix) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isToeplitzMatrix",
  "params": [
    {
      "name": "matrix",
      "type": "int[][]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            2,
            3,
            4
          ],
          [
            5,
            1,
            2,
            3
          ],
          [
            9,
            5,
            1,
            2
          ]
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            2,
            2
          ]
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          [
            1
          ]
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          1,
          2
        ]
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        [
          1,
          2,
          3
        ],
        [
          4,
          1,
          2
        ],
        [
          5,
          4,
          1
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        [
          1,
          2,
          3
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          1
        ],
        [
          2
        ],
        [
          3
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          1,
          1,
          1
        ],
        [
          1,
          1,
          1
        ]
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1528,
    '验证外星语词典',
    '给定字符串数组 words 和一个字符串 order。order 是全部 26 个小写英文字母的一种排列，表示外星语言的字母表顺序。
如果 words 中的单词按照该外星语言的字典序从小到大排列，返回 true；否则返回 false。
字典序比较规则与常规字典序相同，只是字符大小由 order 中的位置决定。
1 <= words.length <= 100，1 <= words[i].length <= 20，words 中单词互不相同。',
    'easy',
    1000,
    256,
    ARRAY['数组', '字符串', '哈希表'],
    $json$[
  {
    "input": "words = [\"hello\", \"leetcode\"], order = \"hlabcdefgijkmnopqrstuvwxyz\"",
    "output": "true"
  },
  {
    "input": "words = [\"word\", \"world\", \"row\"], order = \"worldabcefghijkmnpqstuvxyz\"",
    "output": "false"
  },
  {
    "input": "words = [\"apple\", \"app\"], order = \"abcdefghijklmnopqrstuvwxyz\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"hello\", \"leetcode\"], order = \"hlabcdefgijkmnopqrstuvwxyz\"",
    "output": "true"
  },
  {
    "input": "words = [\"word\", \"world\", \"row\"], order = \"worldabcefghijkmnpqstuvxyz\"",
    "output": "false"
  },
  {
    "input": "words = [\"apple\", \"app\"], order = \"abcdefghijklmnopqrstuvwxyz\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isAlienSorted = function(words, order) {\n};\n",
  "python": "class Solution:\n    def isAlienSorted(self, words: list[str], order: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isAlienSorted(std::vector<std::string>& words, std::string order) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isAlienSorted(String[] words, String order) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isAlienSorted",
  "params": [
    {
      "name": "words",
      "type": "string[]"
    },
    {
      "name": "order",
      "type": "string"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "hello",
          "leetcode"
        ],
        "hlabcdefgijkmnopqrstuvwxyz"
      ],
      "expected": true
    },
    {
      "args": [
        [
          "word",
          "world",
          "row"
        ],
        "worldabcefghijkmnpqstuvxyz"
      ],
      "expected": false
    },
    {
      "args": [
        [
          "apple",
          "app"
        ],
        "abcdefghijklmnopqrstuvwxyz"
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "a",
        "b"
      ],
      "ba"
    ],
    "expected": false
  },
  {
    "args": [
      [
        "b",
        "a"
      ],
      "ba"
    ],
    "expected": true
  },
  {
    "args": [
      [
        "aa",
        "ab"
      ],
      "ab"
    ],
    "expected": true
  },
  {
    "args": [
      [
        "ab",
        "aa"
      ],
      "ab"
    ],
    "expected": false
  },
  {
    "args": [
      [
        "z",
        "x"
      ],
      "zyx"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1529,
    '找到小镇的法官',
    '小镇有 n 个人，编号从 1 到 n。给定信任关系数组 trust，其中 trust[i] = [a, b] 表示编号 a 的人信任编号 b 的人。
小镇法官满足两个条件：法官不信任任何人；除法官外所有人都信任法官。
如果存在法官，返回其编号；否则返回 -1。n = 1 且没有任何信任关系时，编号 1 就是法官。
1 <= n <= 1000，0 <= trust.length <= 10^4，trust[i] 中两个人不同。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '图'],
    $json$[
  {
    "input": "n = 2, trust = [[1, 2]]",
    "output": "2"
  },
  {
    "input": "n = 3, trust = [[1, 3], [2, 3]]",
    "output": "3"
  },
  {
    "input": "n = 3, trust = [[1, 3], [2, 3], [3, 1]]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 2, trust = [[1, 2]]",
    "output": "2"
  },
  {
    "input": "n = 3, trust = [[1, 3], [2, 3]]",
    "output": "3"
  },
  {
    "input": "n = 3, trust = [[1, 3], [2, 3], [3, 1]]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findJudge = function(n, trust) {\n};\n",
  "python": "class Solution:\n    def findJudge(self, n: int, trust: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findJudge(int n, std::vector<std::vector<int>>& trust) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findJudge(int n, int[][] trust) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findJudge",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "trust",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        2,
        [
          [
            1,
            2
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        3,
        [
          [
            1,
            3
          ],
          [
            2,
            3
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        3,
        [
          [
            1,
            3
          ],
          [
            2,
            3
          ],
          [
            3,
            1
          ]
        ]
      ],
      "expected": -1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      3,
      [
        [
          1,
          2
        ],
        [
          2,
          3
        ]
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      4,
      [
        [
          1,
          3
        ],
        [
          1,
          4
        ],
        [
          2,
          3
        ],
        [
          2,
          4
        ],
        [
          4,
          3
        ]
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      1,
      []
    ],
    "expected": 1
  },
  {
    "args": [
      2,
      []
    ],
    "expected": -1
  },
  {
    "args": [
      3,
      [
        [
          1,
          2
        ],
        [
          2,
          1
        ]
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      4,
      [
        [
          1,
          2
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": -1
  }
]$json$::jsonb,
    'approved'
),
(
    1530,
    '重新排列句子中的单词',
    '给定字符串 s，其中每个单词末尾都附加了一个 1 到 9 的数字，表示该单词在句子中的实际位置。
单词之间用单个空格分隔，数字不会出现在单词的其他位置，且位置编号连续、不重复。
请去掉每个单词末尾的数字，按位置重新排列单词，返回用单个空格连接的新句子。
1 <= 单词数量 <= 9。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '数组', '排序'],
    $json$[
  {
    "input": "s = \"is2 sentence4 This1 a3\"",
    "output": "\"This is a sentence\""
  },
  {
    "input": "s = \"Myself2 Me1 I4 and3\"",
    "output": "\"Me Myself and I\""
  },
  {
    "input": "s = \"one1\"",
    "output": "\"one\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"is2 sentence4 This1 a3\"",
    "output": "\"This is a sentence\""
  },
  {
    "input": "s = \"Myself2 Me1 I4 and3\"",
    "output": "\"Me Myself and I\""
  },
  {
    "input": "s = \"one1\"",
    "output": "\"one\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var sortSentence = function(s) {\n};\n",
  "python": "class Solution:\n    def sortSentence(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string sortSentence(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String sortSentence(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sortSentence",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "is2 sentence4 This1 a3"
      ],
      "expected": "This is a sentence"
    },
    {
      "args": [
        "Myself2 Me1 I4 and3"
      ],
      "expected": "Me Myself and I"
    },
    {
      "args": [
        "one1"
      ],
      "expected": "one"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a2 b1"
    ],
    "expected": "b a"
  },
  {
    "args": [
      "J3 b2 a1"
    ],
    "expected": "a b J"
  },
  {
    "args": [
      "z2 a1"
    ],
    "expected": "a z"
  },
  {
    "args": [
      "b2 a1 c3"
    ],
    "expected": "a b c"
  },
  {
    "args": [
      "c3 b2 a1"
    ],
    "expected": "a b c"
  }
]$json$::jsonb,
    'approved'
),
(
    1531,
    '统计好三元组',
    '给定整数数组 arr 和三个整数 a、b、c，统计满足以下全部条件的三元组 (i, j, k) 的数量：
0 <= i < j < k < arr.length；
|arr[i] - arr[j]| <= a；
|arr[j] - arr[k]| <= b；
|arr[i] - arr[k]| <= c。
3 <= arr.length <= 100，0 <= arr[i] <= 1000，0 <= a, b, c <= 1000。',
    'easy',
    1000,
    256,
    ARRAY['数组', '枚举'],
    $json$[
  {
    "input": "arr = [3, 0, 1, 1, 9, 7], a = 7, b = 2, c = 3",
    "output": "4"
  },
  {
    "input": "arr = [1, 1, 2, 2, 3], a = 0, b = 0, c = 1",
    "output": "0"
  },
  {
    "input": "arr = [0, 0, 0], a = 0, b = 0, c = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [3, 0, 1, 1, 9, 7], a = 7, b = 2, c = 3",
    "output": "4"
  },
  {
    "input": "arr = [1, 1, 2, 2, 3], a = 0, b = 0, c = 1",
    "output": "0"
  },
  {
    "input": "arr = [0, 0, 0], a = 0, b = 0, c = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countGoodTriplets = function(arr, a, b, c) {\n};\n",
  "python": "class Solution:\n    def countGoodTriplets(self, arr: list[int], a: int, b: int, c: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countGoodTriplets(std::vector<int>& arr, int a, int b, int c) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countGoodTriplets(int[] arr, int a, int b, int c) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countGoodTriplets",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
    },
    {
      "name": "a",
      "type": "int"
    },
    {
      "name": "b",
      "type": "int"
    },
    {
      "name": "c",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          3,
          0,
          1,
          1,
          9,
          7
        ],
        7,
        2,
        3
      ],
      "expected": 4
    },
    {
      "args": [
        [
          1,
          1,
          2,
          2,
          3
        ],
        0,
        0,
        1
      ],
      "expected": 0
    },
    {
      "args": [
        [
          0,
          0,
          0
        ],
        0,
        0,
        0
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        3
      ],
      1,
      1,
      1
    ],
    "expected": 0
  },
  {
    "args": [
      [
        5
      ],
      0,
      0,
      0
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        1,
        1,
        1
      ],
      0,
      0,
      0
    ],
    "expected": 4
  },
  {
    "args": [
      [
        2,
        2,
        2,
        2
      ],
      1,
      1,
      1
    ],
    "expected": 4
  },
  {
    "args": [
      [
        0,
        1,
        2,
        3
      ],
      1,
      1,
      1
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1532,
    '判断矩阵经轮转后是否一致',
    '给定两个 n x n 的整数矩阵 mat 和 target。
判断能否将 mat 顺时针旋转 90 度的 0 次、1 次、2 次或 3 次后得到 target，可以则返回 true，否则返回 false。
1 <= n <= 10。',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵', '模拟'],
    $json$[
  {
    "input": "mat = [[0, 1], [1, 0]], target = [[1, 0], [0, 1]]",
    "output": "true"
  },
  {
    "input": "mat = [[0, 1], [1, 1]], target = [[1, 0], [0, 1]]",
    "output": "false"
  },
  {
    "input": "mat = [[0, 0, 0], [0, 1, 0], [1, 1, 1]], target = [[1, 1, 1], [0, 1, 0], [0, 0, 0]]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mat = [[0, 1], [1, 0]], target = [[1, 0], [0, 1]]",
    "output": "true"
  },
  {
    "input": "mat = [[0, 1], [1, 1]], target = [[1, 0], [0, 1]]",
    "output": "false"
  },
  {
    "input": "mat = [[0, 0, 0], [0, 1, 0], [1, 1, 1]], target = [[1, 1, 1], [0, 1, 0], [0, 0, 0]]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findRotation = function(mat, target) {\n};\n",
  "python": "class Solution:\n    def findRotation(self, mat: list[list[int]], target: list[list[int]]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool findRotation(std::vector<std::vector<int>>& mat, std::vector<std::vector<int>>& target) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean findRotation(int[][] mat, int[][] target) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findRotation",
  "params": [
    {
      "name": "mat",
      "type": "int[][]"
    },
    {
      "name": "target",
      "type": "int[][]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            0,
            1
          ],
          [
            1,
            0
          ]
        ],
        [
          [
            1,
            0
          ],
          [
            0,
            1
          ]
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          [
            0,
            1
          ],
          [
            1,
            1
          ]
        ],
        [
          [
            1,
            0
          ],
          [
            0,
            1
          ]
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          [
            0,
            0,
            0
          ],
          [
            0,
            1,
            0
          ],
          [
            1,
            1,
            1
          ]
        ],
        [
          [
            1,
            1,
            1
          ],
          [
            0,
            1,
            0
          ],
          [
            0,
            0,
            0
          ]
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1
        ]
      ],
      [
        [
          1
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          1
        ]
      ],
      [
        [
          0
        ]
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        [
          0,
          0
        ],
        [
          0,
          1
        ]
      ],
      [
        [
          0,
          0
        ],
        [
          1,
          0
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          0,
          1
        ],
        [
          1,
          0
        ]
      ],
      [
        [
          0,
          1
        ],
        [
          1,
          0
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          3,
          4
        ]
      ],
      [
        [
          3,
          1
        ],
        [
          4,
          2
        ]
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1533,
    '找到星形图的中心节点',
    '有一个无向星形图，包含 n + 1 个节点，编号从 1 到 n + 1。
图中有 n 条边，每条边都连接中心节点与一个叶子节点。
给定二维数组 edges，其中 edges[i] = [u, v] 表示节点 u 与 v 之间有一条边。
返回中心节点的编号。
1 <= edges.length <= 10^5，1 <= u, v <= n + 1，u != v。',
    'easy',
    1000,
    256,
    ARRAY['图', '数组'],
    $json$[
  {
    "input": "edges = [[1, 2], [2, 3], [4, 2]]",
    "output": "2"
  },
  {
    "input": "edges = [[1, 2], [5, 1], [1, 3], [1, 4]]",
    "output": "1"
  },
  {
    "input": "edges = [[1, 2]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "edges = [[1, 2], [2, 3], [4, 2]]",
    "output": "2"
  },
  {
    "input": "edges = [[1, 2], [5, 1], [1, 3], [1, 4]]",
    "output": "1"
  },
  {
    "input": "edges = [[1, 2]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findCenter = function(edges) {\n};\n",
  "python": "class Solution:\n    def findCenter(self, edges: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findCenter(std::vector<std::vector<int>>& edges) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findCenter(int[][] edges) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findCenter",
  "params": [
    {
      "name": "edges",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            2,
            3
          ],
          [
            4,
            2
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            5,
            1
          ],
          [
            1,
            3
          ],
          [
            1,
            4
          ]
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          [
            1,
            2
          ]
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          2,
          3
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          5,
          1
        ],
        [
          1,
          2
        ],
        [
          1,
          3
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          3,
          4
        ],
        [
          4,
          5
        ],
        [
          4,
          6
        ],
        [
          4,
          7
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          2,
          1
        ],
        [
          1,
          3
        ],
        [
          1,
          4
        ],
        [
          1,
          5
        ]
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1534,
    '检查两个字符串数组是否相等',
    '给定两个字符串数组 word1 和 word2。
将 word1 中的所有字符串按顺序拼接成一个字符串，再用同样方式拼接 word2。
如果两个拼接结果相等，返回 true；否则返回 false。
1 <= word1.length, word2.length <= 10^3，1 <= word1[i].length, word2[i].length <= 10^3。',
    'easy',
    1000,
    256,
    ARRAY['数组', '字符串'],
    $json$[
  {
    "input": "word1 = [\"ab\", \"c\"], word2 = [\"a\", \"bc\"]",
    "output": "true"
  },
  {
    "input": "word1 = [\"a\", \"cb\"], word2 = [\"ab\", \"c\"]",
    "output": "false"
  },
  {
    "input": "word1 = [\"abc\", \"d\", \"defg\"], word2 = [\"abcddefg\"]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "word1 = [\"ab\", \"c\"], word2 = [\"a\", \"bc\"]",
    "output": "true"
  },
  {
    "input": "word1 = [\"a\", \"cb\"], word2 = [\"ab\", \"c\"]",
    "output": "false"
  },
  {
    "input": "word1 = [\"abc\", \"d\", \"defg\"], word2 = [\"abcddefg\"]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var arrayStringsAreEqual = function(word1, word2) {\n};\n",
  "python": "class Solution:\n    def arrayStringsAreEqual(self, word1: list[str], word2: list[str]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool arrayStringsAreEqual(std::vector<std::string>& word1, std::vector<std::string>& word2) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean arrayStringsAreEqual(String[] word1, String[] word2) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "arrayStringsAreEqual",
  "params": [
    {
      "name": "word1",
      "type": "string[]"
    },
    {
      "name": "word2",
      "type": "string[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "ab",
          "c"
        ],
        [
          "a",
          "bc"
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          "a",
          "cb"
        ],
        [
          "ab",
          "c"
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          "abc",
          "d",
          "defg"
        ],
        [
          "abcddefg"
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "a"
      ],
      [
        "a"
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        "a"
      ],
      [
        "b"
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        "ab",
        "cd"
      ],
      [
        "abcd"
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        "",
        ""
      ],
      [
        ""
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        "a",
        "b",
        "c"
      ],
      [
        "abc"
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1535,
    '图像平滑',
    '给定一个 m x n 的整数矩阵 img，表示一张灰度图像。
对每个格子，取以它为中心的 3 x 3 邻域（包括该格子自身，越界部分忽略）内所有整数的平均值，并向下取整，作为新矩阵对应位置的值。
返回大小相同的新矩阵。
1 <= m, n <= 200，0 <= img[i][j] <= 255。',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵', '模拟'],
    $json$[
  {
    "input": "img = [[1, 1, 1], [1, 0, 1], [1, 1, 1]]",
    "output": "[[0, 0, 0], [0, 0, 0], [0, 0, 0]]"
  },
  {
    "input": "img = [[100, 200, 100], [200, 50, 200], [100, 200, 100]]",
    "output": "[[137, 141, 137], [141, 138, 141], [137, 141, 137]]"
  },
  {
    "input": "img = [[1]]",
    "output": "[[1]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "img = [[1, 1, 1], [1, 0, 1], [1, 1, 1]]",
    "output": "[[0, 0, 0], [0, 0, 0], [0, 0, 0]]"
  },
  {
    "input": "img = [[100, 200, 100], [200, 50, 200], [100, 200, 100]]",
    "output": "[[137, 141, 137], [141, 138, 141], [137, 141, 137]]"
  },
  {
    "input": "img = [[1]]",
    "output": "[[1]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var imageSmoother = function(img) {\n};\n",
  "python": "class Solution:\n    def imageSmoother(self, img: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> imageSmoother(std::vector<std::vector<int>>& img) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] imageSmoother(int[][] img) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "imageSmoother",
  "params": [
    {
      "name": "img",
      "type": "int[][]"
    }
  ],
  "return_type": "int[][]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            1,
            1
          ],
          [
            1,
            0,
            1
          ],
          [
            1,
            1,
            1
          ]
        ]
      ],
      "expected": [
        [
          0,
          0,
          0
        ],
        [
          0,
          0,
          0
        ],
        [
          0,
          0,
          0
        ]
      ]
    },
    {
      "args": [
        [
          [
            100,
            200,
            100
          ],
          [
            200,
            50,
            200
          ],
          [
            100,
            200,
            100
          ]
        ]
      ],
      "expected": [
        [
          137,
          141,
          137
        ],
        [
          141,
          138,
          141
        ],
        [
          137,
          141,
          137
        ]
      ]
    },
    {
      "args": [
        [
          [
            1
          ]
        ]
      ],
      "expected": [
        [
          1
        ]
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          2,
          3
        ],
        [
          4,
          5
        ]
      ]
    ],
    "expected": [
      [
        3,
        3
      ],
      [
        3,
        3
      ]
    ]
  },
  {
    "args": [
      [
        [
          1,
          2,
          3
        ]
      ]
    ],
    "expected": [
      [
        1,
        2,
        2
      ]
    ]
  },
  {
    "args": [
      [
        [
          1
        ],
        [
          2
        ],
        [
          3
        ]
      ]
    ],
    "expected": [
      [
        1
      ],
      [
        2
      ],
      [
        2
      ]
    ]
  },
  {
    "args": [
      [
        [
          10,
          20,
          30
        ],
        [
          40,
          50,
          60
        ],
        [
          70,
          80,
          90
        ]
      ]
    ],
    "expected": [
      [
        30,
        35,
        40
      ],
      [
        45,
        50,
        55
      ],
      [
        60,
        65,
        70
      ]
    ]
  },
  {
    "args": [
      [
        [
          5,
          5
        ],
        [
          5,
          5
        ]
      ]
    ],
    "expected": [
      [
        5,
        5
      ],
      [
        5,
        5
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1536,
    '截断句子',
    '给定一个由单个空格分隔单词组成的字符串 s，以及整数 k。
返回由 s 中前 k 个单词组成的句子，单词之间用单个空格分隔。
1 <= 单词数量 <= 500，1 <= k <= 单词数量，s 只含英文字母和空格。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '数组'],
    $json$[
  {
    "input": "s = \"Hello how are you Contestant\", k = 4",
    "output": "\"Hello how are you\""
  },
  {
    "input": "s = \"What is the solution to this problem\", k = 4",
    "output": "\"What is the solution\""
  },
  {
    "input": "s = \"chopper is not a tanuki\", k = 5",
    "output": "\"chopper is not a tanuki\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"Hello how are you Contestant\", k = 4",
    "output": "\"Hello how are you\""
  },
  {
    "input": "s = \"What is the solution to this problem\", k = 4",
    "output": "\"What is the solution\""
  },
  {
    "input": "s = \"chopper is not a tanuki\", k = 5",
    "output": "\"chopper is not a tanuki\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var truncateSentence = function(s, k) {\n};\n",
  "python": "class Solution:\n    def truncateSentence(self, s: str, k: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string truncateSentence(std::string s, int k) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String truncateSentence(String s, int k) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "truncateSentence",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "Hello how are you Contestant",
        4
      ],
      "expected": "Hello how are you"
    },
    {
      "args": [
        "What is the solution to this problem",
        4
      ],
      "expected": "What is the solution"
    },
    {
      "args": [
        "chopper is not a tanuki",
        5
      ],
      "expected": "chopper is not a tanuki"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      1
    ],
    "expected": "a"
  },
  {
    "args": [
      "a b c",
      1
    ],
    "expected": "a"
  },
  {
    "args": [
      "a b c",
      3
    ],
    "expected": "a b c"
  },
  {
    "args": [
      "hello world",
      2
    ],
    "expected": "hello world"
  },
  {
    "args": [
      "one two three four five",
      2
    ],
    "expected": "one two"
  }
]$json$::jsonb,
    'approved'
),
(
    1537,
    '将一维数组转变成二维数组',
    '给定一维整数数组 original、整数 m 和 n。
如果 m * n == original.length，将 original 按行优先顺序填入一个 m 行 n 列的二维数组并返回；否则返回空数组。
1 <= original.length <= 5 * 10^4，1 <= m, n <= 10^4。',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵', '模拟'],
    $json$[
  {
    "input": "original = [1, 2, 3, 4], m = 2, n = 2",
    "output": "[[1, 2], [3, 4]]"
  },
  {
    "input": "original = [1, 2, 3], m = 1, n = 3",
    "output": "[[1, 2, 3]]"
  },
  {
    "input": "original = [1, 2], m = 2, n = 2",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "original = [1, 2, 3, 4], m = 2, n = 2",
    "output": "[[1, 2], [3, 4]]"
  },
  {
    "input": "original = [1, 2, 3], m = 1, n = 3",
    "output": "[[1, 2, 3]]"
  },
  {
    "input": "original = [1, 2], m = 2, n = 2",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var construct2DArray = function(original, m, n) {\n};\n",
  "python": "class Solution:\n    def construct2DArray(self, original: list[int], m: int, n: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> construct2DArray(std::vector<int>& original, int m, int n) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] construct2DArray(int[] original, int m, int n) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "construct2DArray",
  "params": [
    {
      "name": "original",
      "type": "int[]"
    },
    {
      "name": "m",
      "type": "int"
    },
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "int[][]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3,
          4
        ],
        2,
        2
      ],
      "expected": [
        [
          1,
          2
        ],
        [
          3,
          4
        ]
      ]
    },
    {
      "args": [
        [
          1,
          2,
          3
        ],
        1,
        3
      ],
      "expected": [
        [
          1,
          2,
          3
        ]
      ]
    },
    {
      "args": [
        [
          1,
          2
        ],
        2,
        2
      ],
      "expected": []
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5,
        6
      ],
      2,
      3
    ],
    "expected": [
      [
        1,
        2,
        3
      ],
      [
        4,
        5,
        6
      ]
    ]
  },
  {
    "args": [
      [
        3
      ],
      1,
      1
    ],
    "expected": [
      [
        3
      ]
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3
      ],
      3,
      1
    ],
    "expected": [
      [
        1
      ],
      [
        2
      ],
      [
        3
      ]
    ]
  },
  {
    "args": [
      [
        1,
        2
      ],
      1,
      2
    ],
    "expected": [
      [
        1,
        2
      ]
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ],
      4,
      1
    ],
    "expected": [
      [
        1
      ],
      [
        2
      ],
      [
        3
      ],
      [
        4
      ]
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ],
      1,
      4
    ],
    "expected": [
      [
        1,
        2,
        3,
        4
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1538,
    '环形链表',
    '给定一个整数数组 head 表示一条单链表的值，以及整数 pos 表示链表末尾连接到的节点下标（从 0 开始）。
若 pos 为 -1，表示链表没有环。
判断链表中是否存在环。',
    'easy',
    1000,
    256,
    ARRAY['链表', '双指针', '哈希表'],
    $json$[
  {
    "input": "head = [3, 2, 0, -4], pos = 1",
    "output": "true"
  },
  {
    "input": "head = [1, 2], pos = 0",
    "output": "true"
  },
  {
    "input": "head = [1], pos = -1",
    "output": "false"
  },
  {
    "input": "head = [1, 2], pos = -1",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [3, 2, 0, -4], pos = 1",
    "output": "true"
  },
  {
    "input": "head = [1, 2], pos = 0",
    "output": "true"
  },
  {
    "input": "head = [1], pos = -1",
    "output": "false"
  },
  {
    "input": "head = [1, 2], pos = -1",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var hasCycle = function(head, pos) {\n};\n",
  "python": "class Solution:\n    def hasCycle(self, head: list[int], pos: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool hasCycle(std::vector<int>& head, int pos) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean hasCycle(int[] head, int pos) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "hasCycle",
  "params": [
    {
      "name": "head",
      "type": "int[]"
    },
    {
      "name": "pos",
      "type": "int"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          3,
          2,
          0,
          -4
        ],
        1
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          2
        ],
        0
      ],
      "expected": true
    },
    {
      "args": [
        [
          1
        ],
        -1
      ],
      "expected": false
    },
    {
      "args": [
        [
          1,
          2
        ],
        -1
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [],
      -1
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ],
      0
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ],
      4
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ],
      -1
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        2
      ],
      1
    ],
    "expected": true
  },
  {
    "args": [
      [
        1
      ],
      0
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1539,
    '相交链表',
    '给定两个整数数组 listA、listB 表示两条单链表的值，节点值均为正整数且链表无环。
再给定两个下标 skipA、skipB：
若两者都等于 -1，则两条链表不相交；
否则从 listA[skipA] 与 listB[skipB] 开始，两条链表共享同一段后缀，且两段后缀的值相同。
返回两条链表相交节点的值；若不相交返回 -1。',
    'easy',
    1000,
    256,
    ARRAY['链表', '双指针'],
    $json$[
  {
    "input": "listA = [4, 1, 8, 4, 5], listB = [5, 6, 1, 8, 4, 5], skipA = 2, skipB = 3",
    "output": "8"
  },
  {
    "input": "listA = [1, 9, 1, 2, 4], listB = [3, 2, 4], skipA = 3, skipB = 1",
    "output": "2"
  },
  {
    "input": "listA = [2, 6, 4], listB = [1, 5], skipA = -1, skipB = -1",
    "output": "-1"
  },
  {
    "input": "listA = [1], listB = [1], skipA = 0, skipB = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "listA = [4, 1, 8, 4, 5], listB = [5, 6, 1, 8, 4, 5], skipA = 2, skipB = 3",
    "output": "8"
  },
  {
    "input": "listA = [1, 9, 1, 2, 4], listB = [3, 2, 4], skipA = 3, skipB = 1",
    "output": "2"
  },
  {
    "input": "listA = [2, 6, 4], listB = [1, 5], skipA = -1, skipB = -1",
    "output": "-1"
  },
  {
    "input": "listA = [1], listB = [1], skipA = 0, skipB = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var getIntersectionNode = function(listA, listB, skipA, skipB) {\n};\n",
  "python": "class Solution:\n    def getIntersectionNode(self, listA: list[int], listB: list[int], skipA: int, skipB: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int getIntersectionNode(std::vector<int>& listA, std::vector<int>& listB, int skipA, int skipB) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int getIntersectionNode(int[] listA, int[] listB, int skipA, int skipB) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getIntersectionNode",
  "params": [
    {
      "name": "listA",
      "type": "int[]"
    },
    {
      "name": "listB",
      "type": "int[]"
    },
    {
      "name": "skipA",
      "type": "int"
    },
    {
      "name": "skipB",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          4,
          1,
          8,
          4,
          5
        ],
        [
          5,
          6,
          1,
          8,
          4,
          5
        ],
        2,
        3
      ],
      "expected": 8
    },
    {
      "args": [
        [
          1,
          9,
          1,
          2,
          4
        ],
        [
          3,
          2,
          4
        ],
        3,
        1
      ],
      "expected": 2
    },
    {
      "args": [
        [
          2,
          6,
          4
        ],
        [
          1,
          5
        ],
        -1,
        -1
      ],
      "expected": -1
    },
    {
      "args": [
        [
          1
        ],
        [
          1
        ],
        0,
        0
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        3
      ],
      [
        4,
        5,
        6
      ],
      -1,
      -1
    ],
    "expected": -1
  },
  {
    "args": [
      [
        5,
        6,
        7
      ],
      [
        1,
        2,
        3,
        5,
        6,
        7
      ],
      0,
      3
    ],
    "expected": 5
  },
  {
    "args": [
      [
        10,
        20,
        30,
        40
      ],
      [
        99,
        40
      ],
      3,
      1
    ],
    "expected": 40
  },
  {
    "args": [
      [
        7,
        8
      ],
      [
        9,
        7,
        8
      ],
      0,
      1
    ],
    "expected": 7
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ],
      [
        5,
        6,
        3,
        4
      ],
      2,
      2
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1540,
    '下一个更大元素 I',
    '给定两个没有重复元素的整数数组 nums1 和 nums2，且 nums1 是 nums2 的子集。
对 nums1 中的每个元素，在 nums2 中找到它右侧第一个更大的元素；若不存在，结果为 -1。
按 nums1 的顺序返回结果数组。',
    'easy',
    1000,
    256,
    ARRAY['栈', '数组', '哈希表'],
    $json$[
  {
    "input": "nums1 = [4, 1, 2], nums2 = [1, 3, 4, 2]",
    "output": "[-1, 3, -1]"
  },
  {
    "input": "nums1 = [2, 4], nums2 = [1, 2, 3, 4]",
    "output": "[3, -1]"
  },
  {
    "input": "nums1 = [1], nums2 = [1]",
    "output": "[-1]"
  },
  {
    "input": "nums1 = [2, 1, 3], nums2 = [2, 1, 3, 4]",
    "output": "[3, 3, 4]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums1 = [4, 1, 2], nums2 = [1, 3, 4, 2]",
    "output": "[-1, 3, -1]"
  },
  {
    "input": "nums1 = [2, 4], nums2 = [1, 2, 3, 4]",
    "output": "[3, -1]"
  },
  {
    "input": "nums1 = [1], nums2 = [1]",
    "output": "[-1]"
  },
  {
    "input": "nums1 = [2, 1, 3], nums2 = [2, 1, 3, 4]",
    "output": "[3, 3, 4]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var nextGreaterElement = function(nums1, nums2) {\n};\n",
  "python": "class Solution:\n    def nextGreaterElement(self, nums1: list[int], nums2: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> nextGreaterElement(std::vector<int>& nums1, std::vector<int>& nums2) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] nextGreaterElement(int[] nums1, int[] nums2) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "nextGreaterElement",
  "params": [
    {
      "name": "nums1",
      "type": "int[]"
    },
    {
      "name": "nums2",
      "type": "int[]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          4,
          1,
          2
        ],
        [
          1,
          3,
          4,
          2
        ]
      ],
      "expected": [
        -1,
        3,
        -1
      ]
    },
    {
      "args": [
        [
          2,
          4
        ],
        [
          1,
          2,
          3,
          4
        ]
      ],
      "expected": [
        3,
        -1
      ]
    },
    {
      "args": [
        [
          1
        ],
        [
          1
        ]
      ],
      "expected": [
        -1
      ]
    },
    {
      "args": [
        [
          2,
          1,
          3
        ],
        [
          2,
          1,
          3,
          4
        ]
      ],
      "expected": [
        3,
        3,
        4
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        3,
        5
      ],
      [
        5,
        4,
        3,
        2,
        1
      ]
    ],
    "expected": [
      -1,
      -1,
      -1
    ]
  },
  {
    "args": [
      [
        4,
        2
      ],
      [
        2,
        4
      ]
    ],
    "expected": [
      -1,
      4
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3
      ],
      [
        1,
        2,
        3
      ]
    ],
    "expected": [
      2,
      3,
      -1
    ]
  },
  {
    "args": [
      [
        7,
        6,
        5
      ],
      [
        5,
        6,
        7
      ]
    ],
    "expected": [
      -1,
      7,
      6
    ]
  },
  {
    "args": [
      [
        2
      ],
      [
        2,
        3
      ]
    ],
    "expected": [
      3
    ]
  },
  {
    "args": [
      [
        3,
        4
      ],
      [
        3,
        4,
        5
      ]
    ],
    "expected": [
      4,
      5
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1541,
    '棒球比赛',
    '给定一个字符串数组 ops 表示棒球比赛的记录，按顺序处理：
整数 x 表示本回合得到 x 分；
"+" 表示本回合得分是前两回合得分之和；
"D" 表示本回合得分是前一回合得分的两倍；
"C" 表示使前一回合的得分无效并将其移除。
返回所有有效回合得分的总和。题目保证操作序列合法。',
    'easy',
    1000,
    256,
    ARRAY['栈', '数组', '模拟'],
    $json$[
  {
    "input": "ops = [\"5\", \"2\", \"C\", \"D\", \"+\"]",
    "output": "30"
  },
  {
    "input": "ops = [\"5\", \"-2\", \"4\", \"C\", \"D\", \"9\", \"+\", \"+\"]",
    "output": "27"
  },
  {
    "input": "ops = [\"1\"]",
    "output": "1"
  },
  {
    "input": "ops = [\"1\", \"C\"]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "ops = [\"5\", \"2\", \"C\", \"D\", \"+\"]",
    "output": "30"
  },
  {
    "input": "ops = [\"5\", \"-2\", \"4\", \"C\", \"D\", \"9\", \"+\", \"+\"]",
    "output": "27"
  },
  {
    "input": "ops = [\"1\"]",
    "output": "1"
  },
  {
    "input": "ops = [\"1\", \"C\"]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var calPoints = function(ops) {\n};\n",
  "python": "class Solution:\n    def calPoints(self, ops: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int calPoints(std::vector<std::string>& ops) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int calPoints(String[] ops) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "calPoints",
  "params": [
    {
      "name": "ops",
      "type": "string[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "5",
          "2",
          "C",
          "D",
          "+"
        ]
      ],
      "expected": 30
    },
    {
      "args": [
        [
          "5",
          "-2",
          "4",
          "C",
          "D",
          "9",
          "+",
          "+"
        ]
      ],
      "expected": 27
    },
    {
      "args": [
        [
          "1"
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          "1",
          "C"
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "5",
        "D",
        "+"
      ]
    ],
    "expected": 30
  },
  {
    "args": [
      [
        "1",
        "2",
        "3"
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        "10",
        "20",
        "C",
        "D"
      ]
    ],
    "expected": 30
  },
  {
    "args": [
      [
        "-3",
        "C"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "2",
        "3",
        "+",
        "D"
      ]
    ],
    "expected": 20
  },
  {
    "args": [
      [
        "4",
        "C",
        "5",
        "D",
        "+"
      ]
    ],
    "expected": 30
  }
]$json$::jsonb,
    'approved'
),
(
    1542,
    '删除字符串中的所有相邻重复项',
    '给定只包含小写字母的字符串 s，重复删除相邻且相同的两个字符，直到无法继续删除。
返回最终得到的字符串。',
    'easy',
    1000,
    256,
    ARRAY['栈', '字符串'],
    $json$[
  {
    "input": "s = \"abbaca\"",
    "output": "\"ca\""
  },
  {
    "input": "s = \"azxxzy\"",
    "output": "\"ay\""
  },
  {
    "input": "s = \"a\"",
    "output": "\"a\""
  },
  {
    "input": "s = \"aa\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abbaca\"",
    "output": "\"ca\""
  },
  {
    "input": "s = \"azxxzy\"",
    "output": "\"ay\""
  },
  {
    "input": "s = \"a\"",
    "output": "\"a\""
  },
  {
    "input": "s = \"aa\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeDuplicates = function(s) {\n};\n",
  "python": "class Solution:\n    def removeDuplicates(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string removeDuplicates(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String removeDuplicates(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeDuplicates",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "abbaca"
      ],
      "expected": "ca"
    },
    {
      "args": [
        "azxxzy"
      ],
      "expected": "ay"
    },
    {
      "args": [
        "a"
      ],
      "expected": "a"
    },
    {
      "args": [
        "aa"
      ],
      "expected": ""
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abba"
    ],
    "expected": ""
  },
  {
    "args": [
      "aab"
    ],
    "expected": "b"
  },
  {
    "args": [
      "mississippi"
    ],
    "expected": "m"
  },
  {
    "args": [
      "aaaa"
    ],
    "expected": ""
  },
  {
    "args": [
      "abccba"
    ],
    "expected": ""
  }
]$json$::jsonb,
    'approved'
),
(
    1543,
    '买票需要的时间',
    '有 n 个人排队买票，tickets[i] 表示第 i 个人想买的票数，每个人每次只能买一张票。
售票员从队首开始，依次为每个人卖一张票；买完所需票数的人立刻离开队列，否则回到队尾。
求第 k 个人（下标从 0 开始）买完所有票需要的时间（按卖出的票数计）。',
    'easy',
    1000,
    256,
    ARRAY['队列', '数组', '模拟'],
    $json$[
  {
    "input": "tickets = [2, 3, 2], k = 2",
    "output": "6"
  },
  {
    "input": "tickets = [5, 1, 1, 1], k = 0",
    "output": "8"
  },
  {
    "input": "tickets = [1], k = 0",
    "output": "1"
  },
  {
    "input": "tickets = [3, 4, 5], k = 1",
    "output": "10"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "tickets = [2, 3, 2], k = 2",
    "output": "6"
  },
  {
    "input": "tickets = [5, 1, 1, 1], k = 0",
    "output": "8"
  },
  {
    "input": "tickets = [1], k = 0",
    "output": "1"
  },
  {
    "input": "tickets = [3, 4, 5], k = 1",
    "output": "10"
  }
]$json$::jsonb,
    $json${
  "javascript": "var timeRequiredToBuy = function(tickets, k) {\n};\n",
  "python": "class Solution:\n    def timeRequiredToBuy(self, tickets: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int timeRequiredToBuy(std::vector<int>& tickets, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int timeRequiredToBuy(int[] tickets, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "timeRequiredToBuy",
  "params": [
    {
      "name": "tickets",
      "type": "int[]"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          2,
          3,
          2
        ],
        2
      ],
      "expected": 6
    },
    {
      "args": [
        [
          5,
          1,
          1,
          1
        ],
        0
      ],
      "expected": 8
    },
    {
      "args": [
        [
          1
        ],
        0
      ],
      "expected": 1
    },
    {
      "args": [
        [
          3,
          4,
          5
        ],
        1
      ],
      "expected": 10
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        2,
        3,
        2
      ],
      1
    ],
    "expected": 7
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ],
      4
    ],
    "expected": 15
  },
  {
    "args": [
      [
        5,
        5,
        5
      ],
      1
    ],
    "expected": 14
  },
  {
    "args": [
      [
        100
      ],
      0
    ],
    "expected": 100
  },
  {
    "args": [
      [
        2,
        1,
        2,
        1,
        2
      ],
      3
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1544,
    '二叉搜索树中的众数',
    '给定一棵二叉搜索树的层序序列 root（None 表示空位），找出其中出现次数最多的节点值。
若存在多个众数，按升序返回所有众数。',
    'easy',
    1000,
    256,
    ARRAY['二叉树', '深度优先搜索', '哈希表'],
    $json$[
  {
    "input": "root = [1, null, 2, 2]",
    "output": "[2]"
  },
  {
    "input": "root = [0]",
    "output": "[0]"
  },
  {
    "input": "root = [1, null, 2]",
    "output": "[1, 2]"
  },
  {
    "input": "root = [2, 1, 3]",
    "output": "[1, 2, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, null, 2, 2]",
    "output": "[2]"
  },
  {
    "input": "root = [0]",
    "output": "[0]"
  },
  {
    "input": "root = [1, null, 2]",
    "output": "[1, 2]"
  },
  {
    "input": "root = [2, 1, 3]",
    "output": "[1, 2, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar findMode = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def findMode(self, root: TreeNode | None) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::vector<int> findMode(TreeNode* root) {\n        return {};\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int[] findMode(TreeNode root) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findMode",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          null,
          2,
          2
        ]
      ],
      "expected": [
        2
      ]
    },
    {
      "args": [
        [
          0
        ]
      ],
      "expected": [
        0
      ]
    },
    {
      "args": [
        [
          1,
          null,
          2
        ]
      ],
      "expected": [
        1,
        2
      ]
    },
    {
      "args": [
        [
          2,
          1,
          3
        ]
      ],
      "expected": [
        1,
        2,
        3
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        1
      ]
    ],
    "expected": [
      1
    ]
  },
  {
    "args": [
      [
        3,
        1,
        4,
        null,
        2
      ]
    ],
    "expected": [
      1,
      2,
      3,
      4
    ]
  },
  {
    "args": [
      [
        2,
        2
      ]
    ],
    "expected": [
      2
    ]
  },
  {
    "args": [
      [
        5,
        3,
        8,
        2,
        4,
        7,
        9
      ]
    ],
    "expected": [
      2,
      3,
      4,
      5,
      7,
      8,
      9
    ]
  },
  {
    "args": [
      [
        6,
        2,
        8,
        0,
        4,
        7,
        9,
        null,
        null,
        2,
        6
      ]
    ],
    "expected": [
      2,
      6
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1545,
    '二叉搜索树的最小绝对差',
    '给定一棵二叉搜索树的层序序列 root（None 表示空位），节点值互不相同。
返回任意两个不同节点值之间的最小绝对差。',
    'easy',
    1000,
    256,
    ARRAY['二叉搜索树', '树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [4, 2, 6, 1, 3]",
    "output": "1"
  },
  {
    "input": "root = [1, 0, 48, null, null, 12, 49]",
    "output": "1"
  },
  {
    "input": "root = [5, 4, 7]",
    "output": "1"
  },
  {
    "input": "root = [1, null, 2]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [4, 2, 6, 1, 3]",
    "output": "1"
  },
  {
    "input": "root = [1, 0, 48, null, null, 12, 49]",
    "output": "1"
  },
  {
    "input": "root = [5, 4, 7]",
    "output": "1"
  },
  {
    "input": "root = [1, null, 2]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar getMinimumDifference = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def getMinimumDifference(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int getMinimumDifference(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int getMinimumDifference(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getMinimumDifference",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          4,
          2,
          6,
          1,
          3
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          0,
          48,
          null,
          null,
          12,
          49
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          5,
          4,
          7
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          null,
          2
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        236,
        104,
        701,
        null,
        227,
        null,
        911
      ]
    ],
    "expected": 9
  },
  {
    "args": [
      [
        1,
        0,
        2
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        10,
        5,
        15,
        2,
        8
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        3,
        1,
        4
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        0,
        null,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        2,
        1
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1546,
    '把二叉搜索树转换为累加树',
    '给定一棵二叉搜索树的层序序列 root（None 表示空位）。
把每个节点值替换为原树中大于或等于该节点值的所有节点值之和，返回修改后树的层序序列。',
    'easy',
    1000,
    256,
    ARRAY['二叉搜索树', '树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [4, 1, 6, 0, 2, 5, 7, null, null, null, 3, null, null, null, 8]",
    "output": "[30, 36, 21, 36, 35, 26, 15, null, null, null, 33, null, null, null, 8]"
  },
  {
    "input": "root = [0, null, 1]",
    "output": "[1, null, 1]"
  },
  {
    "input": "root = [1, 0, 2]",
    "output": "[3, 3, 2]"
  },
  {
    "input": "root = [2, 1]",
    "output": "[2, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [4, 1, 6, 0, 2, 5, 7, null, null, null, 3, null, null, null, 8]",
    "output": "[30, 36, 21, 36, 35, 26, 15, null, null, null, 33, null, null, null, 8]"
  },
  {
    "input": "root = [0, null, 1]",
    "output": "[1, null, 1]"
  },
  {
    "input": "root = [1, 0, 2]",
    "output": "[3, 3, 2]"
  },
  {
    "input": "root = [2, 1]",
    "output": "[2, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar convertBST = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def convertBST(self, root: TreeNode | None) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* convertBST(TreeNode* root) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode convertBST(TreeNode root) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "convertBST",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    }
  ],
  "return_type": "TreeNode",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          4,
          1,
          6,
          0,
          2,
          5,
          7,
          null,
          null,
          null,
          3,
          null,
          null,
          null,
          8
        ]
      ],
      "expected": [
        30,
        36,
        21,
        36,
        35,
        26,
        15,
        null,
        null,
        null,
        33,
        null,
        null,
        null,
        8
      ]
    },
    {
      "args": [
        [
          0,
          null,
          1
        ]
      ],
      "expected": [
        1,
        null,
        1
      ]
    },
    {
      "args": [
        [
          1,
          0,
          2
        ]
      ],
      "expected": [
        3,
        3,
        2
      ]
    },
    {
      "args": [
        [
          2,
          1
        ]
      ],
      "expected": [
        2,
        3
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ]
    ],
    "expected": [
      1
    ]
  },
  {
    "args": [
      [
        5,
        2,
        13
      ]
    ],
    "expected": [
      18,
      20,
      13
    ]
  },
  {
    "args": [
      [
        3,
        1,
        4,
        null,
        2
      ]
    ],
    "expected": [
      7,
      10,
      4,
      null,
      9
    ]
  },
  {
    "args": [
      [
        10,
        5,
        15
      ]
    ],
    "expected": [
      25,
      30,
      15
    ]
  },
  {
    "args": [
      [
        2,
        1,
        3
      ]
    ],
    "expected": [
      5,
      6,
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1547,
    '二叉树的坡度',
    '给定一棵二叉树的层序序列 root（None 表示空位）。
一个节点的坡度定义为它的左子树所有节点值之和与右子树所有节点值之和的绝对差。
返回整棵树中所有节点坡度之和。',
    'easy',
    1000,
    256,
    ARRAY['树', '二叉树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [1, 2, 3]",
    "output": "1"
  },
  {
    "input": "root = [4, 2, 9, 3, 5, null, 7]",
    "output": "15"
  },
  {
    "input": "root = [21, 7, 14, 1, 1, 2, 2, 3, 3]",
    "output": "9"
  },
  {
    "input": "root = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3]",
    "output": "1"
  },
  {
    "input": "root = [4, 2, 9, 3, 5, null, 7]",
    "output": "15"
  },
  {
    "input": "root = [21, 7, 14, 1, 1, 2, 2, 3, 3]",
    "output": "9"
  },
  {
    "input": "root = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar findTilt = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def findTilt(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int findTilt(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int findTilt(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findTilt",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          4,
          2,
          9,
          3,
          5,
          null,
          7
        ]
      ],
      "expected": 15
    },
    {
      "args": [
        [
          21,
          7,
          14,
          1,
          1,
          2,
          2,
          3,
          3
        ]
      ],
      "expected": 9
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        null,
        2
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        2,
        1,
        3
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        null,
        null,
        5
      ]
    ],
    "expected": 11
  },
  {
    "args": [
      [
        5,
        2,
        9,
        null,
        null,
        4,
        7
      ]
    ],
    "expected": 21
  },
  {
    "args": [
      [
        0,
        null,
        0
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1548,
    '另一棵树的子树',
    '给定两棵二叉树的层序序列 root 和 subRoot（None 表示空位）。
判断 subRoot 是否是 root 的某一棵子树：即 root 中存在一个节点，以该节点为根的树与 subRoot 结构和节点值完全相同。',
    'easy',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '字符串匹配'],
    $json$[
  {
    "input": "root = [3, 4, 5, 1, 2], subRoot = [4, 1, 2]",
    "output": "true"
  },
  {
    "input": "root = [3, 4, 5, 1, 2, null, null, null, null, 0], subRoot = [4, 1, 2]",
    "output": "false"
  },
  {
    "input": "root = [1], subRoot = [1]",
    "output": "true"
  },
  {
    "input": "root = [1, null, 1], subRoot = [1]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 4, 5, 1, 2], subRoot = [4, 1, 2]",
    "output": "true"
  },
  {
    "input": "root = [3, 4, 5, 1, 2, null, null, null, null, 0], subRoot = [4, 1, 2]",
    "output": "false"
  },
  {
    "input": "root = [1], subRoot = [1]",
    "output": "true"
  },
  {
    "input": "root = [1, null, 1], subRoot = [1]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar isSubtree = function(root, subRoot) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def isSubtree(self, root: TreeNode | None, subRoot: TreeNode | None) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool isSubtree(TreeNode* root, TreeNode* subRoot) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean isSubtree(TreeNode root, TreeNode subRoot) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isSubtree",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    },
    {
      "name": "subRoot",
      "type": "TreeNode"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          3,
          4,
          5,
          1,
          2
        ],
        [
          4,
          1,
          2
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          3,
          4,
          5,
          1,
          2,
          null,
          null,
          null,
          null,
          0
        ],
        [
          4,
          1,
          2
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          1
        ],
        [
          1
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          null,
          1
        ],
        [
          1
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        3
      ],
      [
        2
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        3
      ],
      [
        3
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ],
      [
        2,
        4,
        5
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ],
      [
        2,
        4
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        3
      ],
      [
        2,
        4
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        3,
        4,
        5,
        1,
        2
      ],
      [
        1,
        2
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1549,
    '根据二叉树创建字符串',
    '给定一棵二叉树的层序序列 root（None 表示空位），按前序遍历把它转换成由括号和整数组成的字符串。
空子树用一对空括号 "()" 表示，但需要省略所有不影响树结构一对一还原的空括号：
若节点有右子节点但没有左子节点，则必须保留左子节点的空括号 "()"。',
    'easy',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '字符串'],
    $json$[
  {
    "input": "root = [1, 2, 3, 4]",
    "output": "\"1(2(4))(3)\""
  },
  {
    "input": "root = [1, 2, 3, null, 4]",
    "output": "\"1(2()(4))(3)\""
  },
  {
    "input": "root = [1]",
    "output": "\"1\""
  },
  {
    "input": "root = [1, null, 2]",
    "output": "\"1()(2)\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3, 4]",
    "output": "\"1(2(4))(3)\""
  },
  {
    "input": "root = [1, 2, 3, null, 4]",
    "output": "\"1(2()(4))(3)\""
  },
  {
    "input": "root = [1]",
    "output": "\"1\""
  },
  {
    "input": "root = [1, null, 2]",
    "output": "\"1()(2)\""
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar tree2str = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def tree2str(self, root: TreeNode | None) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::string tree2str(TreeNode* root) {\n        return \"\";\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public String tree2str(TreeNode root) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "tree2str",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3,
          4
        ]
      ],
      "expected": "1(2(4))(3)"
    },
    {
      "args": [
        [
          1,
          2,
          3,
          null,
          4
        ]
      ],
      "expected": "1(2()(4))(3)"
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": "1"
    },
    {
      "args": [
        [
          1,
          null,
          2
        ]
      ],
      "expected": "1()(2)"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2
      ]
    ],
    "expected": "1(2)"
  },
  {
    "args": [
      [
        1,
        null,
        2,
        3
      ]
    ],
    "expected": "1()(2(3))"
  },
  {
    "args": [
      [
        1,
        2,
        null,
        3
      ]
    ],
    "expected": "1(2(3))"
  },
  {
    "args": [
      [
        1,
        2,
        3
      ]
    ],
    "expected": "1(2)(3)"
  },
  {
    "args": [
      [
        1,
        null,
        2,
        null,
        3
      ]
    ],
    "expected": "1()(2()(3))"
  }
]$json$::jsonb,
    'approved'
),
(
    1550,
    '合并二叉树',
    '给定两棵二叉树的层序序列 root1 和 root2（None 表示空位）。
把两棵树对应位置的节点值相加，返回合并后树的层序序列：
若两个节点都存在，新节点值为两者之和；若只有一个存在，新节点值取存在的那个。',
    'easy',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '二叉树'],
    $json$[
  {
    "input": "root1 = [1, 3, 2, 5], root2 = [2, 1, 3, null, 4, null, 7]",
    "output": "[3, 4, 5, 5, 4, null, 7]"
  },
  {
    "input": "root1 = [1], root2 = [1, 2]",
    "output": "[2, 2]"
  },
  {
    "input": "root1 = [1], root2 = [2]",
    "output": "[3]"
  },
  {
    "input": "root1 = [1, 2, 3], root2 = [1, 2, 3]",
    "output": "[2, 4, 6]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root1 = [1, 3, 2, 5], root2 = [2, 1, 3, null, 4, null, 7]",
    "output": "[3, 4, 5, 5, 4, null, 7]"
  },
  {
    "input": "root1 = [1], root2 = [1, 2]",
    "output": "[2, 2]"
  },
  {
    "input": "root1 = [1], root2 = [2]",
    "output": "[3]"
  },
  {
    "input": "root1 = [1, 2, 3], root2 = [1, 2, 3]",
    "output": "[2, 4, 6]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar mergeTrees = function(root1, root2) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def mergeTrees(self, root1: TreeNode | None, root2: TreeNode | None) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* mergeTrees(TreeNode* root1, TreeNode* root2) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode mergeTrees(TreeNode root1, TreeNode root2) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "mergeTrees",
  "params": [
    {
      "name": "root1",
      "type": "TreeNode"
    },
    {
      "name": "root2",
      "type": "TreeNode"
    }
  ],
  "return_type": "TreeNode",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          3,
          2,
          5
        ],
        [
          2,
          1,
          3,
          null,
          4,
          null,
          7
        ]
      ],
      "expected": [
        3,
        4,
        5,
        5,
        4,
        null,
        7
      ]
    },
    {
      "args": [
        [
          1
        ],
        [
          1,
          2
        ]
      ],
      "expected": [
        2,
        2
      ]
    },
    {
      "args": [
        [
          1
        ],
        [
          2
        ]
      ],
      "expected": [
        3
      ]
    },
    {
      "args": [
        [
          1,
          2,
          3
        ],
        [
          1,
          2,
          3
        ]
      ],
      "expected": [
        2,
        4,
        6
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [],
      [
        1,
        2,
        3
      ]
    ],
    "expected": [
      1,
      2,
      3
    ]
  },
  {
    "args": [
      [
        1,
        2
      ],
      [
        3,
        null,
        4
      ]
    ],
    "expected": [
      4,
      2,
      4
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3
      ],
      [
        1,
        2,
        3,
        4,
        5,
        6,
        7
      ]
    ],
    "expected": [
      2,
      4,
      6,
      4,
      5,
      6,
      7
    ]
  },
  {
    "args": [
      [
        1,
        2
      ],
      [
        3,
        4,
        5
      ]
    ],
    "expected": [
      4,
      6,
      5
    ]
  },
  {
    "args": [
      [
        1,
        null,
        2
      ],
      [
        3,
        4
      ]
    ],
    "expected": [
      4,
      4,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1551,
    '二叉搜索树中的搜索',
    '给定一棵二叉搜索树的层序序列 root（None 表示空位）和目标值 val。
在树中查找值等于 val 的节点，返回以该节点为根的子树层序序列；若不存在则返回空数组。',
    'easy',
    1000,
    256,
    ARRAY['二叉搜索树', '树', '递归'],
    $json$[
  {
    "input": "root = [4, 2, 7, 1, 3], val = 2",
    "output": "[2, 1, 3]"
  },
  {
    "input": "root = [4, 2, 7, 1, 3], val = 5",
    "output": "[]"
  },
  {
    "input": "root = [1], val = 1",
    "output": "[1]"
  },
  {
    "input": "root = [4, 2, 7, 1, 3], val = 7",
    "output": "[7]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [4, 2, 7, 1, 3], val = 2",
    "output": "[2, 1, 3]"
  },
  {
    "input": "root = [4, 2, 7, 1, 3], val = 5",
    "output": "[]"
  },
  {
    "input": "root = [1], val = 1",
    "output": "[1]"
  },
  {
    "input": "root = [4, 2, 7, 1, 3], val = 7",
    "output": "[7]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar searchBST = function(root, val) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def searchBST(self, root: TreeNode | None, val: int) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* searchBST(TreeNode* root, int val) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode searchBST(TreeNode root, int val) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "searchBST",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    },
    {
      "name": "val",
      "type": "int"
    }
  ],
  "return_type": "TreeNode",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          4,
          2,
          7,
          1,
          3
        ],
        2
      ],
      "expected": [
        2,
        1,
        3
      ]
    },
    {
      "args": [
        [
          4,
          2,
          7,
          1,
          3
        ],
        5
      ],
      "expected": []
    },
    {
      "args": [
        [
          1
        ],
        1
      ],
      "expected": [
        1
      ]
    },
    {
      "args": [
        [
          4,
          2,
          7,
          1,
          3
        ],
        7
      ],
      "expected": [
        7
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [],
      1
    ],
    "expected": []
  },
  {
    "args": [
      [
        8,
        3,
        10,
        1,
        6,
        null,
        14,
        null,
        null,
        4,
        7,
        13,
        null
      ],
      6
    ],
    "expected": [
      6,
      4,
      7
    ]
  },
  {
    "args": [
      [
        5,
        3,
        8
      ],
      3
    ],
    "expected": [
      3
    ]
  },
  {
    "args": [
      [
        5,
        3,
        8
      ],
      9
    ],
    "expected": []
  },
  {
    "args": [
      [
        2,
        1,
        3
      ],
      2
    ],
    "expected": [
      2,
      1,
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1552,
    '二叉搜索树的范围和',
    '给定一棵二叉搜索树的层序序列 root（None 表示空位）以及整数 low、high。
返回树中所有值在闭区间 [low, high] 内的节点值之和。',
    'easy',
    1000,
    256,
    ARRAY['二叉搜索树', '树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [10, 5, 15, 3, 7, null, 18], low = 7, high = 15",
    "output": "32"
  },
  {
    "input": "root = [10, 5, 15, 3, 7, 13, 18, 1, null, 6], low = 6, high = 10",
    "output": "23"
  },
  {
    "input": "root = [1], low = 1, high = 1",
    "output": "1"
  },
  {
    "input": "root = [5, 3, 8], low = 2, high = 6",
    "output": "8"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [10, 5, 15, 3, 7, null, 18], low = 7, high = 15",
    "output": "32"
  },
  {
    "input": "root = [10, 5, 15, 3, 7, 13, 18, 1, null, 6], low = 6, high = 10",
    "output": "23"
  },
  {
    "input": "root = [1], low = 1, high = 1",
    "output": "1"
  },
  {
    "input": "root = [5, 3, 8], low = 2, high = 6",
    "output": "8"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar rangeSumBST = function(root, low, high) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def rangeSumBST(self, root: TreeNode | None, low: int, high: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int rangeSumBST(TreeNode* root, int low, int high) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int rangeSumBST(TreeNode root, int low, int high) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "rangeSumBST",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    },
    {
      "name": "low",
      "type": "int"
    },
    {
      "name": "high",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          10,
          5,
          15,
          3,
          7,
          null,
          18
        ],
        7,
        15
      ],
      "expected": 32
    },
    {
      "args": [
        [
          10,
          5,
          15,
          3,
          7,
          13,
          18,
          1,
          null,
          6
        ],
        6,
        10
      ],
      "expected": 23
    },
    {
      "args": [
        [
          1
        ],
        1,
        1
      ],
      "expected": 1
    },
    {
      "args": [
        [
          5,
          3,
          8
        ],
        2,
        6
      ],
      "expected": 8
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        10,
        5,
        15,
        3,
        7,
        null,
        18
      ],
      5,
      15
    ],
    "expected": 37
  },
  {
    "args": [
      [],
      1,
      2
    ],
    "expected": 0
  },
  {
    "args": [
      [
        2,
        1,
        3
      ],
      1,
      3
    ],
    "expected": 6
  },
  {
    "args": [
      [
        5,
        3,
        8
      ],
      9,
      10
    ],
    "expected": 0
  },
  {
    "args": [
      [
        20,
        10,
        30,
        5,
        15,
        25,
        35
      ],
      10,
      30
    ],
    "expected": 100
  }
]$json$::jsonb,
    'approved'
),
(
    1553,
    '查找共用字符',
    '给定一个字符串数组 words，找出在所有字符串中都出现过的字符。
每个字符在结果中出现的次数等于它在所有字符串中出现次数的最小值。
按字母升序返回结果，每个字符重复对应的次数。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '字符串'],
    $json$[
  {
    "input": "words = [\"bella\", \"label\", \"roller\"]",
    "output": "[\"e\", \"l\", \"l\"]"
  },
  {
    "input": "words = [\"cool\", \"lock\", \"cook\"]",
    "output": "[\"c\", \"o\"]"
  },
  {
    "input": "words = [\"a\", \"a\"]",
    "output": "[\"a\"]"
  },
  {
    "input": "words = [\"abc\", \"def\"]",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"bella\", \"label\", \"roller\"]",
    "output": "[\"e\", \"l\", \"l\"]"
  },
  {
    "input": "words = [\"cool\", \"lock\", \"cook\"]",
    "output": "[\"c\", \"o\"]"
  },
  {
    "input": "words = [\"a\", \"a\"]",
    "output": "[\"a\"]"
  },
  {
    "input": "words = [\"abc\", \"def\"]",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findCommonChars = function(words) {\n};\n",
  "python": "class Solution:\n    def findCommonChars(self, words: list[str]) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> findCommonChars(std::vector<std::string>& words) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] findCommonChars(String[] words) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findCommonChars",
  "params": [
    {
      "name": "words",
      "type": "string[]"
    }
  ],
  "return_type": "string[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "bella",
          "label",
          "roller"
        ]
      ],
      "expected": [
        "e",
        "l",
        "l"
      ]
    },
    {
      "args": [
        [
          "cool",
          "lock",
          "cook"
        ]
      ],
      "expected": [
        "c",
        "o"
      ]
    },
    {
      "args": [
        [
          "a",
          "a"
        ]
      ],
      "expected": [
        "a"
      ]
    },
    {
      "args": [
        [
          "abc",
          "def"
        ]
      ],
      "expected": []
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "a"
      ]
    ],
    "expected": [
      "a"
    ]
  },
  {
    "args": [
      [
        "ab",
        "ab",
        "ab"
      ]
    ],
    "expected": [
      "a",
      "b"
    ]
  },
  {
    "args": [
      [
        "abcd",
        "ab",
        "a"
      ]
    ],
    "expected": [
      "a"
    ]
  },
  {
    "args": [
      [
        "zz",
        "zzz",
        "zzzz"
      ]
    ],
    "expected": [
      "z",
      "z"
    ]
  },
  {
    "args": [
      [
        "hello",
        "world"
      ]
    ],
    "expected": [
      "l",
      "o"
    ]
  },
  {
    "args": [
      [
        "b",
        "b"
      ]
    ],
    "expected": [
      "b"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1554,
    '一年中的第几天',
    '给定格式为 YYYY-MM-DD 的日期字符串 date，返回这一天是该年的第几天。
需正确处理闰年：能被 400 整除，或能被 4 整除但不能被 100 整除的年份为闰年。',
    'easy',
    1000,
    256,
    ARRAY['数学', '字符串'],
    $json$[
  {
    "input": "date = \"2019-01-09\"",
    "output": "9"
  },
  {
    "input": "date = \"2019-02-10\"",
    "output": "41"
  },
  {
    "input": "date = \"2003-03-01\"",
    "output": "60"
  },
  {
    "input": "date = \"2004-03-01\"",
    "output": "61"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "date = \"2019-01-09\"",
    "output": "9"
  },
  {
    "input": "date = \"2019-02-10\"",
    "output": "41"
  },
  {
    "input": "date = \"2003-03-01\"",
    "output": "60"
  },
  {
    "input": "date = \"2004-03-01\"",
    "output": "61"
  }
]$json$::jsonb,
    $json${
  "javascript": "var dayOfYear = function(date) {\n};\n",
  "python": "class Solution:\n    def dayOfYear(self, date: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int dayOfYear(std::string date) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int dayOfYear(String date) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "dayOfYear",
  "params": [
    {
      "name": "date",
      "type": "string"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "2019-01-09"
      ],
      "expected": 9
    },
    {
      "args": [
        "2019-02-10"
      ],
      "expected": 41
    },
    {
      "args": [
        "2003-03-01"
      ],
      "expected": 60
    },
    {
      "args": [
        "2004-03-01"
      ],
      "expected": 61
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "2019-12-31"
    ],
    "expected": 365
  },
  {
    "args": [
      "2020-12-31"
    ],
    "expected": 366
  },
  {
    "args": [
      "1900-03-01"
    ],
    "expected": 60
  },
  {
    "args": [
      "2000-03-01"
    ],
    "expected": 61
  },
  {
    "args": [
      "2016-02-29"
    ],
    "expected": 60
  },
  {
    "args": [
      "2021-01-01"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1555,
    '构造矩形',
    '给定矩形面积 area，返回由两个整数组成的长和宽 [length, width]：
要求 length >= width，length * width == area，且 length 与 width 的差最小。
结果数组中第一项为长、第二项为宽。',
    'easy',
    1000,
    256,
    ARRAY['数学'],
    $json$[
  {
    "input": "area = 4",
    "output": "[2, 2]"
  },
  {
    "input": "area = 2",
    "output": "[2, 1]"
  },
  {
    "input": "area = 37",
    "output": "[37, 1]"
  },
  {
    "input": "area = 122122",
    "output": "[427, 286]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "area = 4",
    "output": "[2, 2]"
  },
  {
    "input": "area = 2",
    "output": "[2, 1]"
  },
  {
    "input": "area = 37",
    "output": "[37, 1]"
  },
  {
    "input": "area = 122122",
    "output": "[427, 286]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var constructRectangle = function(area) {\n};\n",
  "python": "class Solution:\n    def constructRectangle(self, area: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> constructRectangle(int area) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] constructRectangle(int area) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "constructRectangle",
  "params": [
    {
      "name": "area",
      "type": "int"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        4
      ],
      "expected": [
        2,
        2
      ]
    },
    {
      "args": [
        2
      ],
      "expected": [
        2,
        1
      ]
    },
    {
      "args": [
        37
      ],
      "expected": [
        37,
        1
      ]
    },
    {
      "args": [
        122122
      ],
      "expected": [
        427,
        286
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1
    ],
    "expected": [
      1,
      1
    ]
  },
  {
    "args": [
      3
    ],
    "expected": [
      3,
      1
    ]
  },
  {
    "args": [
      6
    ],
    "expected": [
      3,
      2
    ]
  },
  {
    "args": [
      12
    ],
    "expected": [
      4,
      3
    ]
  },
  {
    "args": [
      100
    ],
    "expected": [
      10,
      10
    ]
  },
  {
    "args": [
      1000000
    ],
    "expected": [
      1000,
      1000
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1556,
    '七进制数',
    '给定整数 num，返回它的七进制表示字符串。负数需要保留负号。',
    'easy',
    1000,
    256,
    ARRAY['数学', '字符串'],
    $json$[
  {
    "input": "num = 100",
    "output": "\"202\""
  },
  {
    "input": "num = -7",
    "output": "\"-10\""
  },
  {
    "input": "num = 0",
    "output": "\"0\""
  },
  {
    "input": "num = 7",
    "output": "\"10\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 100",
    "output": "\"202\""
  },
  {
    "input": "num = -7",
    "output": "\"-10\""
  },
  {
    "input": "num = 0",
    "output": "\"0\""
  },
  {
    "input": "num = 7",
    "output": "\"10\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var convertToBase7 = function(num) {\n};\n",
  "python": "class Solution:\n    def convertToBase7(self, num: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string convertToBase7(int num) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String convertToBase7(int num) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "convertToBase7",
  "params": [
    {
      "name": "num",
      "type": "int"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        100
      ],
      "expected": "202"
    },
    {
      "args": [
        -7
      ],
      "expected": "-10"
    },
    {
      "args": [
        0
      ],
      "expected": "0"
    },
    {
      "args": [
        7
      ],
      "expected": "10"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1
    ],
    "expected": "1"
  },
  {
    "args": [
      -1
    ],
    "expected": "-1"
  },
  {
    "args": [
      49
    ],
    "expected": "100"
  },
  {
    "args": [
      50
    ],
    "expected": "101"
  },
  {
    "args": [
      -100
    ],
    "expected": "-202"
  }
]$json$::jsonb,
    'approved'
),
(
    1557,
    '完美数',
    '完全数是指一个正整数，它所有的正因子（不包含自身）之和恰好等于它本身。
给定整数 num，判断它是否为完全数。',
    'easy',
    1000,
    256,
    ARRAY['数学'],
    $json$[
  {
    "input": "num = 28",
    "output": "true"
  },
  {
    "input": "num = 6",
    "output": "true"
  },
  {
    "input": "num = 496",
    "output": "true"
  },
  {
    "input": "num = 2",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 28",
    "output": "true"
  },
  {
    "input": "num = 6",
    "output": "true"
  },
  {
    "input": "num = 496",
    "output": "true"
  },
  {
    "input": "num = 2",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var checkPerfectNumber = function(num) {\n};\n",
  "python": "class Solution:\n    def checkPerfectNumber(self, num: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool checkPerfectNumber(int num) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean checkPerfectNumber(int num) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkPerfectNumber",
  "params": [
    {
      "name": "num",
      "type": "int"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        28
      ],
      "expected": true
    },
    {
      "args": [
        6
      ],
      "expected": true
    },
    {
      "args": [
        496
      ],
      "expected": true
    },
    {
      "args": [
        2
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1
    ],
    "expected": false
  },
  {
    "args": [
      12
    ],
    "expected": false
  },
  {
    "args": [
      27
    ],
    "expected": false
  },
  {
    "args": [
      8128
    ],
    "expected": true
  },
  {
    "args": [
      33550336
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1558,
    '找出数组的最大公约数',
    '给定一个正整数数组 nums，返回数组中最大值与最小值的最大公约数。',
    'easy',
    1000,
    256,
    ARRAY['数学', '数组', '数论'],
    $json$[
  {
    "input": "nums = [2, 5, 6, 9, 10]",
    "output": "2"
  },
  {
    "input": "nums = [7, 5, 6, 8, 3]",
    "output": "1"
  },
  {
    "input": "nums = [3, 3]",
    "output": "3"
  },
  {
    "input": "nums = [1, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 5, 6, 9, 10]",
    "output": "2"
  },
  {
    "input": "nums = [7, 5, 6, 8, 3]",
    "output": "1"
  },
  {
    "input": "nums = [3, 3]",
    "output": "3"
  },
  {
    "input": "nums = [1, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findGCD = function(nums) {\n};\n",
  "python": "class Solution:\n    def findGCD(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findGCD(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findGCD(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findGCD",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          2,
          5,
          6,
          9,
          10
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          7,
          5,
          6,
          8,
          3
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          3,
          3
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          1,
          1
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        2,
        4,
        6,
        8
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        9,
        6
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        10,
        10,
        10
      ]
    ],
    "expected": 10
  },
  {
    "args": [
      [
        5,
        10,
        15,
        20
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        13,
        17
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2,
        3
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1559,
    '矩形重叠',
    '矩形用数组 [x1, y1, x2, y2] 表示，(x1, y1) 为左下角，(x2, y2) 为右上角。
给定两个矩形 rec1 和 rec2，判断它们是否重叠。
仅边或点接触不算重叠。',
    'easy',
    1000,
    256,
    ARRAY['数学', '几何'],
    $json$[
  {
    "input": "rec1 = [0, 0, 2, 2], rec2 = [1, 1, 3, 3]",
    "output": "true"
  },
  {
    "input": "rec1 = [0, 0, 1, 1], rec2 = [1, 0, 2, 1]",
    "output": "false"
  },
  {
    "input": "rec1 = [0, 0, 1, 1], rec2 = [2, 2, 3, 3]",
    "output": "false"
  },
  {
    "input": "rec1 = [0, 0, 2, 2], rec2 = [0, 0, 2, 2]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "rec1 = [0, 0, 2, 2], rec2 = [1, 1, 3, 3]",
    "output": "true"
  },
  {
    "input": "rec1 = [0, 0, 1, 1], rec2 = [1, 0, 2, 1]",
    "output": "false"
  },
  {
    "input": "rec1 = [0, 0, 1, 1], rec2 = [2, 2, 3, 3]",
    "output": "false"
  },
  {
    "input": "rec1 = [0, 0, 2, 2], rec2 = [0, 0, 2, 2]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isRectangleOverlap = function(rec1, rec2) {\n};\n",
  "python": "class Solution:\n    def isRectangleOverlap(self, rec1: list[int], rec2: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isRectangleOverlap(std::vector<int>& rec1, std::vector<int>& rec2) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isRectangleOverlap(int[] rec1, int[] rec2) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isRectangleOverlap",
  "params": [
    {
      "name": "rec1",
      "type": "int[]"
    },
    {
      "name": "rec2",
      "type": "int[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          0,
          0,
          2,
          2
        ],
        [
          1,
          1,
          3,
          3
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          0,
          0,
          1,
          1
        ],
        [
          1,
          0,
          2,
          1
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          0,
          0,
          1,
          1
        ],
        [
          2,
          2,
          3,
          3
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          0,
          0,
          2,
          2
        ],
        [
          0,
          0,
          2,
          2
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0,
        0,
        2,
        2
      ],
      [
        0,
        2,
        2,
        3
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        5,
        5,
        10,
        10
      ],
      [
        4,
        4,
        6,
        6
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        -1,
        -1,
        1,
        1
      ],
      [
        0,
        0,
        2,
        2
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        0,
        0,
        1,
        1
      ],
      [
        1,
        1,
        2,
        2
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        1,
        2,
        2
      ],
      [
        0,
        0,
        3,
        3
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1560,
    '比特位计数',
    '给定整数 n，返回长度为 n + 1 的数组 ans，其中 ans[i] 是整数 i 的二进制表示中 1 的个数。
结果按 i 从 0 到 n 的顺序排列。',
    'easy',
    1000,
    256,
    ARRAY['位运算', '动态规划', '数组'],
    $json$[
  {
    "input": "n = 2",
    "output": "[0, 1, 1]"
  },
  {
    "input": "n = 5",
    "output": "[0, 1, 1, 2, 1, 2]"
  },
  {
    "input": "n = 0",
    "output": "[0]"
  },
  {
    "input": "n = 1",
    "output": "[0, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 2",
    "output": "[0, 1, 1]"
  },
  {
    "input": "n = 5",
    "output": "[0, 1, 1, 2, 1, 2]"
  },
  {
    "input": "n = 0",
    "output": "[0]"
  },
  {
    "input": "n = 1",
    "output": "[0, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countBits = function(n) {\n};\n",
  "python": "class Solution:\n    def countBits(self, n: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> countBits(int n) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] countBits(int n) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countBits",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        2
      ],
      "expected": [
        0,
        1,
        1
      ]
    },
    {
      "args": [
        5
      ],
      "expected": [
        0,
        1,
        1,
        2,
        1,
        2
      ]
    },
    {
      "args": [
        0
      ],
      "expected": [
        0
      ]
    },
    {
      "args": [
        1
      ],
      "expected": [
        0,
        1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      3
    ],
    "expected": [
      0,
      1,
      1,
      2
    ]
  },
  {
    "args": [
      4
    ],
    "expected": [
      0,
      1,
      1,
      2,
      1
    ]
  },
  {
    "args": [
      8
    ],
    "expected": [
      0,
      1,
      1,
      2,
      1,
      2,
      2,
      3,
      1
    ]
  },
  {
    "args": [
      10
    ],
    "expected": [
      0,
      1,
      1,
      2,
      1,
      2,
      2,
      3,
      1,
      2,
      2
    ]
  },
  {
    "args": [
      16
    ],
    "expected": [
      0,
      1,
      1,
      2,
      1,
      2,
      2,
      3,
      1,
      2,
      2,
      3,
      2,
      3,
      3,
      4,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1561,
    '二进制表示中质数个计算置位',
    '给定两个整数 left 和 right，统计闭区间 [left, right] 内有多少个整数的二进制表示中
1 的个数是质数。',
    'easy',
    1000,
    256,
    ARRAY['位运算', '数学'],
    $json$[
  {
    "input": "left = 6, right = 10",
    "output": "4"
  },
  {
    "input": "left = 10, right = 15",
    "output": "5"
  },
  {
    "input": "left = 1, right = 1",
    "output": "0"
  },
  {
    "input": "left = 2, right = 2",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "left = 6, right = 10",
    "output": "4"
  },
  {
    "input": "left = 10, right = 15",
    "output": "5"
  },
  {
    "input": "left = 1, right = 1",
    "output": "0"
  },
  {
    "input": "left = 2, right = 2",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countPrimeSetBits = function(left, right) {\n};\n",
  "python": "class Solution:\n    def countPrimeSetBits(self, left: int, right: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countPrimeSetBits(int left, int right) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countPrimeSetBits(int left, int right) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countPrimeSetBits",
  "params": [
    {
      "name": "left",
      "type": "int"
    },
    {
      "name": "right",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        6,
        10
      ],
      "expected": 4
    },
    {
      "args": [
        10,
        15
      ],
      "expected": 5
    },
    {
      "args": [
        1,
        1
      ],
      "expected": 0
    },
    {
      "args": [
        2,
        2
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      10
    ],
    "expected": 6
  },
  {
    "args": [
      4,
      4
    ],
    "expected": 0
  },
  {
    "args": [
      3,
      3
    ],
    "expected": 1
  },
  {
    "args": [
      10,
      10
    ],
    "expected": 1
  },
  {
    "args": [
      1,
      2
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1562,
    '二进制间距',
    '给定正整数 n，返回其二进制表示中两个相邻的 1 之间的最大距离。
若二进制表示中 1 的个数少于 2，返回 0。',
    'easy',
    1000,
    256,
    ARRAY['位运算'],
    $json$[
  {
    "input": "n = 22",
    "output": "2"
  },
  {
    "input": "n = 8",
    "output": "0"
  },
  {
    "input": "n = 5",
    "output": "2"
  },
  {
    "input": "n = 6",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 22",
    "output": "2"
  },
  {
    "input": "n = 8",
    "output": "0"
  },
  {
    "input": "n = 5",
    "output": "2"
  },
  {
    "input": "n = 6",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var binaryGap = function(n) {\n};\n",
  "python": "class Solution:\n    def binaryGap(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int binaryGap(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int binaryGap(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "binaryGap",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        22
      ],
      "expected": 2
    },
    {
      "args": [
        8
      ],
      "expected": 0
    },
    {
      "args": [
        5
      ],
      "expected": 2
    },
    {
      "args": [
        6
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1
    ],
    "expected": 0
  },
  {
    "args": [
      2
    ],
    "expected": 0
  },
  {
    "args": [
      3
    ],
    "expected": 1
  },
  {
    "args": [
      7
    ],
    "expected": 1
  },
  {
    "args": [
      100
    ],
    "expected": 3
  },
  {
    "args": [
      1024
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1563,
    '十进制整数的反码',
    '每个非负整数的二进制表示都不含前导零。将其所有位取反得到反码。
给定非负整数 n，返回它的反码对应的十进制值。',
    'easy',
    1000,
    256,
    ARRAY['位运算'],
    $json$[
  {
    "input": "n = 5",
    "output": "2"
  },
  {
    "input": "n = 7",
    "output": "0"
  },
  {
    "input": "n = 10",
    "output": "5"
  },
  {
    "input": "n = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5",
    "output": "2"
  },
  {
    "input": "n = 7",
    "output": "0"
  },
  {
    "input": "n = 10",
    "output": "5"
  },
  {
    "input": "n = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var bitwiseComplement = function(n) {\n};\n",
  "python": "class Solution:\n    def bitwiseComplement(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int bitwiseComplement(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int bitwiseComplement(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "bitwiseComplement",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        5
      ],
      "expected": 2
    },
    {
      "args": [
        7
      ],
      "expected": 0
    },
    {
      "args": [
        10
      ],
      "expected": 5
    },
    {
      "args": [
        0
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1
    ],
    "expected": 0
  },
  {
    "args": [
      2
    ],
    "expected": 1
  },
  {
    "args": [
      3
    ],
    "expected": 0
  },
  {
    "args": [
      4
    ],
    "expected": 3
  },
  {
    "args": [
      8
    ],
    "expected": 7
  },
  {
    "args": [
      1024
    ],
    "expected": 1023
  }
]$json$::jsonb,
    'approved'
),
(
    1564,
    '颠倒二进制位',
    '给定一个非负整数 n，把它看作 32 位无符号整数的二进制表示，将所有位按位颠倒后返回结果。
输入保证颠倒后的结果不超过 2^31 - 1。',
    'easy',
    1000,
    256,
    ARRAY['位运算'],
    $json$[
  {
    "input": "n = 43261596",
    "output": "964176192"
  },
  {
    "input": "n = 2",
    "output": "1073741824"
  },
  {
    "input": "n = 4",
    "output": "536870912"
  },
  {
    "input": "n = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 43261596",
    "output": "964176192"
  },
  {
    "input": "n = 2",
    "output": "1073741824"
  },
  {
    "input": "n = 4",
    "output": "536870912"
  },
  {
    "input": "n = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var reverseBits = function(n) {\n};\n",
  "python": "class Solution:\n    def reverseBits(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int reverseBits(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int reverseBits(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reverseBits",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        43261596
      ],
      "expected": 964176192
    },
    {
      "args": [
        2
      ],
      "expected": 1073741824
    },
    {
      "args": [
        4
      ],
      "expected": 536870912
    },
    {
      "args": [
        0
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      8
    ],
    "expected": 268435456
  },
  {
    "args": [
      16
    ],
    "expected": 134217728
  },
  {
    "args": [
      32
    ],
    "expected": 67108864
  },
  {
    "args": [
      64
    ],
    "expected": 33554432
  },
  {
    "args": [
      964176192
    ],
    "expected": 43261596
  },
  {
    "args": [
      1073741824
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1565,
    '种花问题',
    '给定一个由 0 和 1 组成的数组 flowerbed 表示花坛，0 表示空位，1 表示已种花。
再给定整数 n。花不能种在相邻的两个位置上。
判断能否在不移动已有花的前提下，种下至多 n 朵新花（可以少于 n 朵，只要还能空出位置）。
实际要求为：是否存在一种方式恰好种下 n 朵新花。',
    'easy',
    1000,
    256,
    ARRAY['贪心', '数组'],
    $json$[
  {
    "input": "flowerbed = [1, 0, 0, 0, 1], n = 1",
    "output": "true"
  },
  {
    "input": "flowerbed = [1, 0, 0, 0, 1], n = 2",
    "output": "false"
  },
  {
    "input": "flowerbed = [0, 0, 1, 0, 0], n = 2",
    "output": "true"
  },
  {
    "input": "flowerbed = [0], n = 1",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "flowerbed = [1, 0, 0, 0, 1], n = 1",
    "output": "true"
  },
  {
    "input": "flowerbed = [1, 0, 0, 0, 1], n = 2",
    "output": "false"
  },
  {
    "input": "flowerbed = [0, 0, 1, 0, 0], n = 2",
    "output": "true"
  },
  {
    "input": "flowerbed = [0], n = 1",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canPlaceFlowers = function(flowerbed, n) {\n};\n",
  "python": "class Solution:\n    def canPlaceFlowers(self, flowerbed: list[int], n: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canPlaceFlowers(std::vector<int>& flowerbed, int n) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canPlaceFlowers(int[] flowerbed, int n) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canPlaceFlowers",
  "params": [
    {
      "name": "flowerbed",
      "type": "int[]"
    },
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          0,
          0,
          0,
          1
        ],
        1
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          0,
          0,
          0,
          1
        ],
        2
      ],
      "expected": false
    },
    {
      "args": [
        [
          0,
          0,
          1,
          0,
          0
        ],
        2
      ],
      "expected": true
    },
    {
      "args": [
        [
          0
        ],
        1
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0
      ],
      0
    ],
    "expected": true
  },
  {
    "args": [
      [
        1
      ],
      1
    ],
    "expected": false
  },
  {
    "args": [
      [
        0,
        0,
        0
      ],
      1
    ],
    "expected": true
  },
  {
    "args": [
      [
        0,
        0,
        0
      ],
      2
    ],
    "expected": true
  },
  {
    "args": [
      [
        0,
        0,
        0,
        0
      ],
      2
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1566,
    '柠檬水找零',
    '一杯柠檬水售价 5 美元。顾客只可能用 5、10 或 20 美元付款。
给定按顺序付款的钞票数组 bills，开始时你没有任何零钱。
判断是否能正确给每位顾客找零。',
    'easy',
    1000,
    256,
    ARRAY['贪心', '数组'],
    $json$[
  {
    "input": "bills = [5, 5, 5, 10, 20]",
    "output": "true"
  },
  {
    "input": "bills = [5, 5, 10, 10, 20]",
    "output": "false"
  },
  {
    "input": "bills = [5, 5, 10]",
    "output": "true"
  },
  {
    "input": "bills = [10, 10]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "bills = [5, 5, 5, 10, 20]",
    "output": "true"
  },
  {
    "input": "bills = [5, 5, 10, 10, 20]",
    "output": "false"
  },
  {
    "input": "bills = [5, 5, 10]",
    "output": "true"
  },
  {
    "input": "bills = [10, 10]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var lemonadeChange = function(bills) {\n};\n",
  "python": "class Solution:\n    def lemonadeChange(self, bills: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool lemonadeChange(std::vector<int>& bills) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean lemonadeChange(int[] bills) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "lemonadeChange",
  "params": [
    {
      "name": "bills",
      "type": "int[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          5,
          5,
          5,
          10,
          20
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          5,
          5,
          10,
          10,
          20
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          5,
          5,
          10
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          10,
          10
        ]
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        5
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        20
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        5,
        5,
        5,
        20
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        5,
        10,
        5,
        20
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        5,
        5,
        5,
        5,
        10,
        5,
        10,
        10,
        10,
        20
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1567,
    '最少操作使数组递增',
    '给定整数数组 nums。每次操作可以选择任意一个元素并把它增加 1。
返回使数组严格递增所需的最少操作次数。',
    'easy',
    1000,
    256,
    ARRAY['贪心', '数组'],
    $json$[
  {
    "input": "nums = [1, 1, 1]",
    "output": "3"
  },
  {
    "input": "nums = [1, 5, 2, 4, 1]",
    "output": "14"
  },
  {
    "input": "nums = [8]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 1]",
    "output": "3"
  },
  {
    "input": "nums = [1, 5, 2, 4, 1]",
    "output": "14"
  },
  {
    "input": "nums = [8]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minOperations = function(nums) {\n};\n",
  "python": "class Solution:\n    def minOperations(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minOperations(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minOperations(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minOperations",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          1,
          1
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          1,
          5,
          2,
          4,
          1
        ]
      ],
      "expected": 14
    },
    {
      "args": [
        [
          8
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          1,
          2,
          3
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        3,
        2,
        1
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        1,
        2,
        2
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        5,
        4,
        3,
        2,
        1
      ]
    ],
    "expected": 20
  },
  {
    "args": [
      [
        0,
        0
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1568,
    '玩筹码',
    '给定整数数组 chips，其中 chips[i] 表示第 i 个筹码所在的位置。
可以把任意筹码向左或向右移动 2 个位置，代价为 0；
也可以向左或向右移动 1 个位置，代价为 1。
返回把所有筹码移动到同一位置所需的最小代价。',
    'easy',
    1000,
    256,
    ARRAY['贪心', '数学', '数组'],
    $json$[
  {
    "input": "chips = [1, 2, 3]",
    "output": "1"
  },
  {
    "input": "chips = [2, 2, 2, 3, 3]",
    "output": "2"
  },
  {
    "input": "chips = [1, 2, 2, 2, 2]",
    "output": "1"
  },
  {
    "input": "chips = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "chips = [1, 2, 3]",
    "output": "1"
  },
  {
    "input": "chips = [2, 2, 2, 3, 3]",
    "output": "2"
  },
  {
    "input": "chips = [1, 2, 2, 2, 2]",
    "output": "1"
  },
  {
    "input": "chips = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minCostToMoveChips = function(chips) {\n};\n",
  "python": "class Solution:\n    def minCostToMoveChips(self, chips: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minCostToMoveChips(std::vector<int>& chips) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minCostToMoveChips(int[] chips) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minCostToMoveChips",
  "params": [
    {
      "name": "chips",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          2,
          2,
          2,
          3,
          3
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1,
          2,
          2,
          2,
          2
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        2,
        2
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        3,
        5
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        2
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        3,
        2,
        4
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        1,
        1,
        2,
        2,
        2
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1569,
    '卡车上的最大单元数',
    '给定二维整数数组 boxTypes，其中 boxTypes[i] = [numberOfBoxes, unitsPerBox]
表示第 i 类箱子有 numberOfBoxes 个，每个箱子装有 unitsPerBox 个单元。
再给定卡车最多能装载的箱子数 truckSize。
选择不超过 truckSize 个箱子装车，返回能装载的最大单元总数。',
    'easy',
    1000,
    256,
    ARRAY['贪心', '数组', '排序'],
    $json$[
  {
    "input": "boxTypes = [[1, 3], [2, 2], [3, 1]], truckSize = 4",
    "output": "8"
  },
  {
    "input": "boxTypes = [[5, 10], [2, 5], [4, 7], [3, 9]], truckSize = 10",
    "output": "91"
  },
  {
    "input": "boxTypes = [[1, 1]], truckSize = 1",
    "output": "1"
  },
  {
    "input": "boxTypes = [[2, 3], [3, 4]], truckSize = 1",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "boxTypes = [[1, 3], [2, 2], [3, 1]], truckSize = 4",
    "output": "8"
  },
  {
    "input": "boxTypes = [[5, 10], [2, 5], [4, 7], [3, 9]], truckSize = 10",
    "output": "91"
  },
  {
    "input": "boxTypes = [[1, 1]], truckSize = 1",
    "output": "1"
  },
  {
    "input": "boxTypes = [[2, 3], [3, 4]], truckSize = 1",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumUnits = function(boxTypes, truckSize) {\n};\n",
  "python": "class Solution:\n    def maximumUnits(self, boxTypes: list[list[int]], truckSize: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumUnits(std::vector<std::vector<int>>& boxTypes, int truckSize) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumUnits(int[][] boxTypes, int truckSize) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumUnits",
  "params": [
    {
      "name": "boxTypes",
      "type": "int[][]"
    },
    {
      "name": "truckSize",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            3
          ],
          [
            2,
            2
          ],
          [
            3,
            1
          ]
        ],
        4
      ],
      "expected": 8
    },
    {
      "args": [
        [
          [
            5,
            10
          ],
          [
            2,
            5
          ],
          [
            4,
            7
          ],
          [
            3,
            9
          ]
        ],
        10
      ],
      "expected": 91
    },
    {
      "args": [
        [
          [
            1,
            1
          ]
        ],
        1
      ],
      "expected": 1
    },
    {
      "args": [
        [
          [
            2,
            3
          ],
          [
            3,
            4
          ]
        ],
        1
      ],
      "expected": 4
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          5
        ]
      ],
      0
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          3,
          2
        ]
      ],
      1
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          1,
          4
        ],
        [
          2,
          3
        ],
        [
          1,
          2
        ]
      ],
      3
    ],
    "expected": 10
  },
  {
    "args": [
      [
        [
          2,
          1
        ],
        [
          1,
          10
        ],
        [
          3,
          2
        ]
      ],
      4
    ],
    "expected": 16
  },
  {
    "args": [
      [
        [
          1,
          1
        ],
        [
          1,
          1
        ]
      ],
      2
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1570,
    '相对名次',
    '给定分数互不相同的整数数组 score。
按分数从高到低确定名次：前三名分别返回 "Gold Medal"、"Silver Medal"、"Bronze Medal"，
其余名次返回排名的十进制字符串（如第 4 名返回 "4"）。
结果数组按 score 的原顺序返回。',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序', '字符串'],
    $json$[
  {
    "input": "score = [5, 4, 3, 2, 1]",
    "output": "[\"Gold Medal\", \"Silver Medal\", \"Bronze Medal\", \"4\", \"5\"]"
  },
  {
    "input": "score = [10, 3, 8, 9, 4]",
    "output": "[\"Gold Medal\", \"5\", \"Bronze Medal\", \"Silver Medal\", \"4\"]"
  },
  {
    "input": "score = [1]",
    "output": "[\"Gold Medal\"]"
  },
  {
    "input": "score = [2, 1]",
    "output": "[\"Gold Medal\", \"Silver Medal\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "score = [5, 4, 3, 2, 1]",
    "output": "[\"Gold Medal\", \"Silver Medal\", \"Bronze Medal\", \"4\", \"5\"]"
  },
  {
    "input": "score = [10, 3, 8, 9, 4]",
    "output": "[\"Gold Medal\", \"5\", \"Bronze Medal\", \"Silver Medal\", \"4\"]"
  },
  {
    "input": "score = [1]",
    "output": "[\"Gold Medal\"]"
  },
  {
    "input": "score = [2, 1]",
    "output": "[\"Gold Medal\", \"Silver Medal\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findRelativeRanks = function(score) {\n};\n",
  "python": "class Solution:\n    def findRelativeRanks(self, score: list[int]) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> findRelativeRanks(std::vector<int>& score) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] findRelativeRanks(int[] score) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findRelativeRanks",
  "params": [
    {
      "name": "score",
      "type": "int[]"
    }
  ],
  "return_type": "string[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          5,
          4,
          3,
          2,
          1
        ]
      ],
      "expected": [
        "Gold Medal",
        "Silver Medal",
        "Bronze Medal",
        "4",
        "5"
      ]
    },
    {
      "args": [
        [
          10,
          3,
          8,
          9,
          4
        ]
      ],
      "expected": [
        "Gold Medal",
        "5",
        "Bronze Medal",
        "Silver Medal",
        "4"
      ]
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": [
        "Gold Medal"
      ]
    },
    {
      "args": [
        [
          2,
          1
        ]
      ],
      "expected": [
        "Gold Medal",
        "Silver Medal"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        3,
        1,
        2
      ]
    ],
    "expected": [
      "Gold Medal",
      "Bronze Medal",
      "Silver Medal"
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3
      ]
    ],
    "expected": [
      "Bronze Medal",
      "Silver Medal",
      "Gold Medal"
    ]
  },
  {
    "args": [
      [
        10,
        20,
        30,
        40,
        50
      ]
    ],
    "expected": [
      "5",
      "4",
      "Bronze Medal",
      "Silver Medal",
      "Gold Medal"
    ]
  },
  {
    "args": [
      [
        7,
        8
      ]
    ],
    "expected": [
      "Silver Medal",
      "Gold Medal"
    ]
  },
  {
    "args": [
      [
        100,
        50,
        25,
        12,
        6,
        3
      ]
    ],
    "expected": [
      "Gold Medal",
      "Silver Medal",
      "Bronze Medal",
      "4",
      "5",
      "6"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1571,
    '等价多米诺骨牌对的数量',
    '给定二维整数数组 dominoes，其中 dominoes[i] = [a, b] 表示一块多米诺骨牌的两端数字。
若两块骨牌 (a, b) 与 (c, d) 满足 a == c 且 b == d，或者 a == d 且 b == c，
则称它们等价。统计满足 i < j 且两块骨牌等价的骨牌对数量。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '计数'],
    $json$[
  {
    "input": "dominoes = [[1, 2], [2, 1], [3, 4], [5, 6]]",
    "output": "1"
  },
  {
    "input": "dominoes = [[1, 2], [1, 2], [1, 1], [1, 2], [2, 2]]",
    "output": "3"
  },
  {
    "input": "dominoes = [[1, 1]]",
    "output": "0"
  },
  {
    "input": "dominoes = [[1, 2], [2, 1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "dominoes = [[1, 2], [2, 1], [3, 4], [5, 6]]",
    "output": "1"
  },
  {
    "input": "dominoes = [[1, 2], [1, 2], [1, 1], [1, 2], [2, 2]]",
    "output": "3"
  },
  {
    "input": "dominoes = [[1, 1]]",
    "output": "0"
  },
  {
    "input": "dominoes = [[1, 2], [2, 1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numEquivDominoPairs = function(dominoes) {\n};\n",
  "python": "class Solution:\n    def numEquivDominoPairs(self, dominoes: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numEquivDominoPairs(std::vector<std::vector<int>>& dominoes) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numEquivDominoPairs(int[][] dominoes) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numEquivDominoPairs",
  "params": [
    {
      "name": "dominoes",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            2,
            1
          ],
          [
            3,
            4
          ],
          [
            5,
            6
          ]
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            1,
            2
          ],
          [
            1,
            1
          ],
          [
            1,
            2
          ],
          [
            2,
            2
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          [
            1,
            1
          ]
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            2,
            1
          ]
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          1
        ],
        [
          1,
          1
        ],
        [
          1,
          1
        ]
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          2,
          1
        ],
        [
          1,
          2
        ],
        [
          2,
          1
        ],
        [
          1,
          2
        ]
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        [
          1,
          1
        ],
        [
          2,
          2
        ],
        [
          1,
          1
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          3,
          4
        ],
        [
          4,
          3
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1572,
    '错误的集合',
    '集合本应包含 1 到 n 的所有整数，但其中一个数重复出现，另一个数缺失。
给定长度为 n 的整数数组 nums，返回 [重复的数, 缺失的数]。',
    'easy',
    1000,
    256,
    ARRAY['数学', '数组', '哈希表'],
    $json$[
  {
    "input": "nums = [1, 2, 2, 4]",
    "output": "[2, 3]"
  },
  {
    "input": "nums = [1, 1]",
    "output": "[1, 2]"
  },
  {
    "input": "nums = [2, 2]",
    "output": "[2, 1]"
  },
  {
    "input": "nums = [3, 1, 3]",
    "output": "[3, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 2, 4]",
    "output": "[2, 3]"
  },
  {
    "input": "nums = [1, 1]",
    "output": "[1, 2]"
  },
  {
    "input": "nums = [2, 2]",
    "output": "[2, 1]"
  },
  {
    "input": "nums = [3, 1, 3]",
    "output": "[3, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findErrorNums = function(nums) {\n};\n",
  "python": "class Solution:\n    def findErrorNums(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findErrorNums(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findErrorNums(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findErrorNums",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          2,
          4
        ]
      ],
      "expected": [
        2,
        3
      ]
    },
    {
      "args": [
        [
          1,
          1
        ]
      ],
      "expected": [
        1,
        2
      ]
    },
    {
      "args": [
        [
          2,
          2
        ]
      ],
      "expected": [
        2,
        1
      ]
    },
    {
      "args": [
        [
          3,
          1,
          3
        ]
      ],
      "expected": [
        3,
        2
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        2,
        3
      ]
    ],
    "expected": [
      2,
      4
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        4,
        6
      ]
    ],
    "expected": [
      4,
      5
    ]
  },
  {
    "args": [
      [
        1,
        1,
        2,
        3,
        4
      ]
    ],
    "expected": [
      1,
      5
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5,
        5
      ]
    ],
    "expected": [
      5,
      6
    ]
  },
  {
    "args": [
      [
        2,
        3,
        3,
        4
      ]
    ],
    "expected": [
      3,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1573,
    '好数对的数目',
    '给定整数数组 nums。若下标对 (i, j) 满足 i < j 且 nums[i] == nums[j]，
则称其为一个好数对。返回好数对的总数。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '数学'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 1, 1, 3]",
    "output": "4"
  },
  {
    "input": "nums = [1, 1, 1, 1]",
    "output": "6"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "0"
  },
  {
    "input": "nums = [1, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 1, 1, 3]",
    "output": "4"
  },
  {
    "input": "nums = [1, 1, 1, 1]",
    "output": "6"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "0"
  },
  {
    "input": "nums = [1, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numIdenticalPairs = function(nums) {\n};\n",
  "python": "class Solution:\n    def numIdenticalPairs(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numIdenticalPairs(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numIdenticalPairs(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numIdenticalPairs",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3,
          1,
          1,
          3
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          1,
          1,
          1,
          1
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          1,
          2,
          3
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          1,
          1
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        2,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        2,
        2,
        2
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        4,
        4,
        4,
        4,
        4
      ]
    ],
    "expected": 10
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1574,
    '独一无二的出现次数',
    '给定整数数组 arr，统计每个值出现的次数。
若所有值出现的次数互不相同，返回 true；否则返回 false。',
    'easy',
    1000,
    256,
    ARRAY['哈希表', '数组'],
    $json$[
  {
    "input": "arr = [1, 2, 2, 1, 1, 3]",
    "output": "true"
  },
  {
    "input": "arr = [1, 2]",
    "output": "false"
  },
  {
    "input": "arr = [-3, 0, 1, -3, 1, 1, 1, -3, 10, 0]",
    "output": "true"
  },
  {
    "input": "arr = [1, 1, 2, 2]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [1, 2, 2, 1, 1, 3]",
    "output": "true"
  },
  {
    "input": "arr = [1, 2]",
    "output": "false"
  },
  {
    "input": "arr = [-3, 0, 1, -3, 1, 1, 1, -3, 10, 0]",
    "output": "true"
  },
  {
    "input": "arr = [1, 1, 2, 2]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var uniqueOccurrences = function(arr) {\n};\n",
  "python": "class Solution:\n    def uniqueOccurrences(self, arr: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool uniqueOccurrences(std::vector<int>& arr) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean uniqueOccurrences(int[] arr) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "uniqueOccurrences",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          2,
          1,
          1,
          3
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          2
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          -3,
          0,
          1,
          -3,
          1,
          1,
          1,
          -3,
          10,
          0
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          1,
          2,
          2
        ]
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        1
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        1,
        2
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        3
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        1,
        2,
        2,
        3
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1575,
    '盛最多水的容器',
    '给定长度为 n 的整数数组 height，第 i 条线的两个端点是 (i, 0) 和 (i, height[i])
选出两条线，与 x 轴共同构成一个容器，使容器能容纳的水最多
返回容器可以储存的最大水量',
    'medium',
    1000,
    256,
    ARRAY['数组', '双指针'],
    $json$[
  {
    "input": "height = [1, 8, 6, 2, 5, 4, 8, 3, 7]",
    "output": "49"
  },
  {
    "input": "height = [1, 1]",
    "output": "1"
  },
  {
    "input": "height = [4, 3, 2, 1, 4]",
    "output": "16"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "height = [1, 8, 6, 2, 5, 4, 8, 3, 7]",
    "output": "49"
  },
  {
    "input": "height = [1, 1]",
    "output": "1"
  },
  {
    "input": "height = [4, 3, 2, 1, 4]",
    "output": "16"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxArea = function(height) {\n};\n",
  "python": "class Solution:\n    def maxArea(self, height: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxArea(std::vector<int>& height) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxArea(int[] height) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxArea",
  "params": [
    {
      "name": "height",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          8,
          6,
          2,
          5,
          4,
          8,
          3,
          7
        ]
      ],
      "expected": 49
    },
    {
      "args": [
        [
          1,
          1
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          4,
          3,
          2,
          1,
          4
        ]
      ],
      "expected": 16
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        2,
        3,
        4,
        5,
        18,
        17,
        6
      ]
    ],
    "expected": 17
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10
      ]
    ],
    "expected": 25
  },
  {
    "args": [
      [
        5,
        5,
        5,
        5
      ]
    ],
    "expected": 15
  }
]$json$::jsonb,
    'approved'
),
(
    1576,
    '四数之和',
    '给定整数数组 nums 和目标值 target，找出所有和为 target 且互不相同的四元组
四元组由四个不同的下标对应的元素组成，同一个四元组不能重复出现
每个四元组内部按升序排列，所有四元组整体按字典序升序排列后返回',
    'medium',
    1000,
    256,
    ARRAY['数组', '双指针', '排序'],
    $json$[
  {
    "input": "nums = [1, 0, -1, 0, -2, 2], target = 0",
    "output": "[[-2, -1, 1, 2], [-2, 0, 0, 2], [-1, 0, 0, 1]]"
  },
  {
    "input": "nums = [2, 2, 2, 2, 2], target = 8",
    "output": "[[2, 2, 2, 2]]"
  },
  {
    "input": "nums = [1, 2, 3, 4], target = 10",
    "output": "[[1, 2, 3, 4]]"
  },
  {
    "input": "nums = [-3, -1, 0, 2, 4, 5], target = 2",
    "output": "[[-3, -1, 2, 4]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 0, -1, 0, -2, 2], target = 0",
    "output": "[[-2, -1, 1, 2], [-2, 0, 0, 2], [-1, 0, 0, 1]]"
  },
  {
    "input": "nums = [2, 2, 2, 2, 2], target = 8",
    "output": "[[2, 2, 2, 2]]"
  },
  {
    "input": "nums = [1, 2, 3, 4], target = 10",
    "output": "[[1, 2, 3, 4]]"
  },
  {
    "input": "nums = [-3, -1, 0, 2, 4, 5], target = 2",
    "output": "[[-3, -1, 2, 4]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var fourSum = function(nums, target) {\n};\n",
  "python": "class Solution:\n    def fourSum(self, nums: list[int], target: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> fourSum(std::vector<int>& nums, int target) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] fourSum(int[] nums, int target) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "fourSum",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "target",
      "type": "int"
    }
  ],
  "return_type": "int[][]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          0,
          -1,
          0,
          -2,
          2
        ],
        0
      ],
      "expected": [
        [
          -2,
          -1,
          1,
          2
        ],
        [
          -2,
          0,
          0,
          2
        ],
        [
          -1,
          0,
          0,
          1
        ]
      ]
    },
    {
      "args": [
        [
          2,
          2,
          2,
          2,
          2
        ],
        8
      ],
      "expected": [
        [
          2,
          2,
          2,
          2
        ]
      ]
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4
        ],
        10
      ],
      "expected": [
        [
          1,
          2,
          3,
          4
        ]
      ]
    },
    {
      "args": [
        [
          -3,
          -1,
          0,
          2,
          4,
          5
        ],
        2
      ],
      "expected": [
        [
          -3,
          -1,
          2,
          4
        ]
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0,
        0,
        0,
        0
      ],
      0
    ],
    "expected": [
      [
        0,
        0,
        0,
        0
      ]
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5,
        6
      ],
      12
    ],
    "expected": [
      [
        1,
        2,
        3,
        6
      ],
      [
        1,
        2,
        4,
        5
      ]
    ]
  },
  {
    "args": [
      [
        -2,
        -1,
        -1,
        1,
        1,
        2,
        2
      ],
      0
    ],
    "expected": [
      [
        -2,
        -1,
        1,
        2
      ],
      [
        -1,
        -1,
        1,
        1
      ]
    ]
  },
  {
    "args": [
      [
        100000000,
        100000000,
        100000000,
        100000000
      ],
      400000000
    ],
    "expected": [
      [
        100000000,
        100000000,
        100000000,
        100000000
      ]
    ]
  },
  {
    "args": [
      [
        1,
        2
      ],
      3
    ],
    "expected": []
  }
]$json$::jsonb,
    'approved'
),
(
    1577,
    '除自身以外数组的乘积',
    '给定整数数组 nums，返回数组 answer
其中 answer[i] 等于 nums 中除 nums[i] 之外其余所有元素的乘积
题目保证任意元素的乘积不会溢出 32 位整数
要求不使用除法并在 O(n) 时间内完成',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "[24, 12, 8, 6]"
  },
  {
    "input": "nums = [-1, 1, 0, -3, 3]",
    "output": "[0, 0, 9, 0, 0]"
  },
  {
    "input": "nums = [2, 3]",
    "output": "[3, 2]"
  },
  {
    "input": "nums = [0, 0, 4]",
    "output": "[0, 0, 0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "[24, 12, 8, 6]"
  },
  {
    "input": "nums = [-1, 1, 0, -3, 3]",
    "output": "[0, 0, 9, 0, 0]"
  },
  {
    "input": "nums = [2, 3]",
    "output": "[3, 2]"
  },
  {
    "input": "nums = [0, 0, 4]",
    "output": "[0, 0, 0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var productExceptSelf = function(nums) {\n};\n",
  "python": "class Solution:\n    def productExceptSelf(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> productExceptSelf(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] productExceptSelf(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "productExceptSelf",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3,
          4
        ]
      ],
      "expected": [
        24,
        12,
        8,
        6
      ]
    },
    {
      "args": [
        [
          -1,
          1,
          0,
          -3,
          3
        ]
      ],
      "expected": [
        0,
        0,
        9,
        0,
        0
      ]
    },
    {
      "args": [
        [
          2,
          3
        ]
      ],
      "expected": [
        3,
        2
      ]
    },
    {
      "args": [
        [
          0,
          0,
          4
        ]
      ],
      "expected": [
        0,
        0,
        0
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        2,
        5,
        1
      ]
    ],
    "expected": [
      5,
      2,
      10
    ]
  },
  {
    "args": [
      [
        1,
        2
      ]
    ],
    "expected": [
      2,
      1
    ]
  },
  {
    "args": [
      [
        0,
        4,
        0
      ]
    ],
    "expected": [
      0,
      0,
      0
    ]
  },
  {
    "args": [
      [
        -2,
        -3,
        -4
      ]
    ],
    "expected": [
      12,
      8,
      6
    ]
  },
  {
    "args": [
      [
        5,
        2,
        3,
        1,
        4
      ]
    ],
    "expected": [
      24,
      60,
      40,
      120,
      30
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1578,
    '递增的三元子序列',
    '给定整数数组 nums
判断是否存在下标 i < j < k 使得 nums[i] < nums[j] < nums[k]
若存在返回 true，否则返回 false
要求 O(n) 时间与 O(1) 额外空间',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 4, 5]",
    "output": "true"
  },
  {
    "input": "nums = [5, 4, 3, 2, 1]",
    "output": "false"
  },
  {
    "input": "nums = [2, 1, 5, 0, 4, 6]",
    "output": "true"
  },
  {
    "input": "nums = [1, 1, 1, 1]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 4, 5]",
    "output": "true"
  },
  {
    "input": "nums = [5, 4, 3, 2, 1]",
    "output": "false"
  },
  {
    "input": "nums = [2, 1, 5, 0, 4, 6]",
    "output": "true"
  },
  {
    "input": "nums = [1, 1, 1, 1]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var increasingTriplet = function(nums) {\n};\n",
  "python": "class Solution:\n    def increasingTriplet(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool increasingTriplet(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean increasingTriplet(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "increasingTriplet",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3,
          4,
          5
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          5,
          4,
          3,
          2,
          1
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          2,
          1,
          5,
          0,
          4,
          6
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          1,
          1,
          1
        ]
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        1,
        3
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        20,
        100,
        10,
        12,
        5,
        13
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        0,
        0,
        0,
        0,
        1
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        3,
        5,
        1,
        4,
        2,
        6
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1579,
    '甲板上的战舰',
    '给定由字符 X 和 . 组成的二维甲板 board
战舰只能是水平或垂直的连续 X，且任意两艘战舰互不相邻
返回甲板上战舰的数量
要求只扫描一次并使用 O(1) 额外空间',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵'],
    $json$[
  {
    "input": "board = [[\"X\", \".\", \".\", \"X\"], [\".\", \".\", \".\", \"X\"], [\".\", \".\", \".\", \"X\"]]",
    "output": "2"
  },
  {
    "input": "board = [[\".\"]]",
    "output": "0"
  },
  {
    "input": "board = [[\"X\"]]",
    "output": "1"
  },
  {
    "input": "board = [[\"X\", \"X\", \".\", \".\"], [\".\", \".\", \"X\", \".\"], [\".\", \".\", \"X\", \".\"]]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "board = [[\"X\", \".\", \".\", \"X\"], [\".\", \".\", \".\", \"X\"], [\".\", \".\", \".\", \"X\"]]",
    "output": "2"
  },
  {
    "input": "board = [[\".\"]]",
    "output": "0"
  },
  {
    "input": "board = [[\"X\"]]",
    "output": "1"
  },
  {
    "input": "board = [[\"X\", \"X\", \".\", \".\"], [\".\", \".\", \"X\", \".\"], [\".\", \".\", \"X\", \".\"]]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countBattleships = function(board) {\n};\n",
  "python": "class Solution:\n    def countBattleships(self, board: list[list[str]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countBattleships(std::vector<std::vector<std::string>>& board) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countBattleships(String[][] board) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countBattleships",
  "params": [
    {
      "name": "board",
      "type": "string[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            "X",
            ".",
            ".",
            "X"
          ],
          [
            ".",
            ".",
            ".",
            "X"
          ],
          [
            ".",
            ".",
            ".",
            "X"
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            "."
          ]
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          [
            "X"
          ]
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          [
            "X",
            "X",
            ".",
            "."
          ],
          [
            ".",
            ".",
            "X",
            "."
          ],
          [
            ".",
            ".",
            "X",
            "."
          ]
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          "X",
          ".",
          "X"
        ],
        [
          ".",
          "X",
          "."
        ],
        [
          "X",
          ".",
          "X"
        ]
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        [
          "X",
          "X",
          "X"
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          "X",
          ".",
          ".",
          "X",
          ".",
          "X"
        ]
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        [
          "."
        ],
        [
          "."
        ],
        [
          "."
        ]
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1580,
    '数组中重复的数据',
    '给定长度为 n 的整数数组 nums，其中 1 <= nums[i] <= n
每个整数最多出现两次，有些整数出现一次，有些出现两次
返回所有出现两次的整数，结果按升序排列
要求 O(n) 时间且只使用常量额外空间',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "nums = [4, 3, 2, 7, 8, 2, 3, 1]",
    "output": "[2, 3]"
  },
  {
    "input": "nums = [1, 1, 2]",
    "output": "[1]"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "[]"
  },
  {
    "input": "nums = [2, 2, 1, 1]",
    "output": "[1, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [4, 3, 2, 7, 8, 2, 3, 1]",
    "output": "[2, 3]"
  },
  {
    "input": "nums = [1, 1, 2]",
    "output": "[1]"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "[]"
  },
  {
    "input": "nums = [2, 2, 1, 1]",
    "output": "[1, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findDuplicates = function(nums) {\n};\n",
  "python": "class Solution:\n    def findDuplicates(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findDuplicates(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findDuplicates(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findDuplicates",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          4,
          3,
          2,
          7,
          8,
          2,
          3,
          1
        ]
      ],
      "expected": [
        2,
        3
      ]
    },
    {
      "args": [
        [
          1,
          1,
          2
        ]
      ],
      "expected": [
        1
      ]
    },
    {
      "args": [
        [
          1,
          2,
          3
        ]
      ],
      "expected": []
    },
    {
      "args": [
        [
          2,
          2,
          1,
          1
        ]
      ],
      "expected": [
        1,
        2
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ]
    ],
    "expected": []
  },
  {
    "args": [
      [
        1,
        1
      ]
    ],
    "expected": [
      1
    ]
  },
  {
    "args": [
      [
        5,
        4,
        6,
        7,
        9,
        3,
        10,
        9,
        5,
        6
      ]
    ],
    "expected": [
      5,
      6,
      9
    ]
  },
  {
    "args": [
      [
        1,
        2,
        2,
        3,
        3,
        4
      ]
    ],
    "expected": [
      2,
      3
    ]
  },
  {
    "args": [
      [
        2,
        1,
        2,
        1
      ]
    ],
    "expected": [
      1,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1581,
    '数组嵌套',
    '给定长度为 n 的整数数组 nums，它是 0 到 n-1 的一个排列
从某个下标 i 出发，不断访问 nums[i]，再访问 nums[nums[i]]，如此继续
访问路径最终会形成环，路径长度定义为经过的不同下标数量
返回所有可能路径中的最大长度',
    'medium',
    1000,
    256,
    ARRAY['数组', '图'],
    $json$[
  {
    "input": "nums = [5, 4, 0, 3, 1, 2]",
    "output": "3"
  },
  {
    "input": "nums = [0, 1, 2]",
    "output": "1"
  },
  {
    "input": "nums = [1, 0]",
    "output": "2"
  },
  {
    "input": "nums = [0]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [5, 4, 0, 3, 1, 2]",
    "output": "3"
  },
  {
    "input": "nums = [0, 1, 2]",
    "output": "1"
  },
  {
    "input": "nums = [1, 0]",
    "output": "2"
  },
  {
    "input": "nums = [0]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var arrayNesting = function(nums) {\n};\n",
  "python": "class Solution:\n    def arrayNesting(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int arrayNesting(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int arrayNesting(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "arrayNesting",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          5,
          4,
          0,
          3,
          1,
          2
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          0,
          1,
          2
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          0
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          0
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0,
        2,
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        2,
        0,
        1
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5,
        0
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        4,
        0,
        2,
        1,
        3
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1582,
    '最短无序连续子数组',
    '给定整数数组 nums
找出一个最短的连续子数组，使得只将这个子数组升序排序后整个数组变为升序
返回该子数组的长度，若原数组已经有序则返回 0',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "nums = [2, 6, 4, 8, 10, 9, 15]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "0"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  },
  {
    "input": "nums = [1, 3, 2, 2, 2]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 6, 4, 8, 10, 9, 15]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "0"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  },
  {
    "input": "nums = [1, 3, 2, 2, 2]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findUnsortedSubarray = function(nums) {\n};\n",
  "python": "class Solution:\n    def findUnsortedSubarray(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findUnsortedSubarray(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findUnsortedSubarray(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findUnsortedSubarray",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          2,
          6,
          4,
          8,
          10,
          9,
          15
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          1,
          3,
          2,
          2,
          2
        ]
      ],
      "expected": 4
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        3,
        3,
        3
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        3,
        2,
        4,
        5
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        5,
        4,
        3,
        2,
        1
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        2,
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        2,
        4,
        5,
        3
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1583,
    '环形数组是否存在循环',
    '给定不含 0 的整数数组 nums，从下标 i 移动 nums[i] 步到达 (i + nums[i]) % n
移动时正数表示前进，负数表示后退
若存在一个循环，循环中的移动方向一致且循环长度大于 1，返回 true，否则返回 false',
    'medium',
    1000,
    256,
    ARRAY['数组', '双指针'],
    $json$[
  {
    "input": "nums = [2, -1, 1, 2, 2]",
    "output": "true"
  },
  {
    "input": "nums = [-1, 2]",
    "output": "false"
  },
  {
    "input": "nums = [-2, 1, -1, -2, -2]",
    "output": "false"
  },
  {
    "input": "nums = [1]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, -1, 1, 2, 2]",
    "output": "true"
  },
  {
    "input": "nums = [-1, 2]",
    "output": "false"
  },
  {
    "input": "nums = [-2, 1, -1, -2, -2]",
    "output": "false"
  },
  {
    "input": "nums = [1]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var circularArrayLoop = function(nums) {\n};\n",
  "python": "class Solution:\n    def circularArrayLoop(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool circularArrayLoop(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean circularArrayLoop(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "circularArrayLoop",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          2,
          -1,
          1,
          2,
          2
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          -1,
          2
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          -2,
          1,
          -1,
          -2,
          -2
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        1,
        1,
        1,
        1
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        -1,
        -1,
        -1,
        -1,
        -1
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        -1,
        1,
        -1
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        3,
        1,
        2
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        2,
        2,
        2,
        2
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1584,
    'H 指数',
    '给定研究者的引用次数数组 citations
H 指数定义为最大的 h，使得至少有 h 篇论文分别被引用至少 h 次
返回该研究者的 H 指数',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "citations = [3, 0, 6, 1, 5]",
    "output": "3"
  },
  {
    "input": "citations = [1, 3, 1]",
    "output": "1"
  },
  {
    "input": "citations = [0]",
    "output": "0"
  },
  {
    "input": "citations = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "citations = [3, 0, 6, 1, 5]",
    "output": "3"
  },
  {
    "input": "citations = [1, 3, 1]",
    "output": "1"
  },
  {
    "input": "citations = [0]",
    "output": "0"
  },
  {
    "input": "citations = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var hIndex = function(citations) {\n};\n",
  "python": "class Solution:\n    def hIndex(self, citations: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int hIndex(std::vector<int>& citations) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int hIndex(int[] citations) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "hIndex",
  "params": [
    {
      "name": "citations",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          3,
          0,
          6,
          1,
          5
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          1,
          3,
          1
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          0
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        4,
        4,
        4,
        4
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        10,
        8,
        5,
        3,
        3
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        100
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        0,
        0,
        0
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        2,
        2,
        2
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1585,
    '最少移动次数使数组元素相等 II',
    '给定整数数组 nums
每次操作可以将任意一个元素加 1 或减 1
返回使所有数组元素相等所需的最小操作次数',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '中位数'],
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "2"
  },
  {
    "input": "nums = [1, 10, 2, 9]",
    "output": "16"
  },
  {
    "input": "nums = [1, 0, 0, 8, 6]",
    "output": "14"
  },
  {
    "input": "nums = [5]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "2"
  },
  {
    "input": "nums = [1, 10, 2, 9]",
    "output": "16"
  },
  {
    "input": "nums = [1, 0, 0, 8, 6]",
    "output": "14"
  },
  {
    "input": "nums = [5]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minMoves2 = function(nums) {\n};\n",
  "python": "class Solution:\n    def minMoves2(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long minMoves2(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long minMoves2(int[] nums) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minMoves2",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "long",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1,
          10,
          2,
          9
        ]
      ],
      "expected": 16
    },
    {
      "args": [
        [
          1,
          0,
          0,
          8,
          6
        ]
      ],
      "expected": 14
    },
    {
      "args": [
        [
          5
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        1,
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        -1,
        2,
        4
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        0,
        1000000000
      ]
    ],
    "expected": 1000000000
  }
]$json$::jsonb,
    'approved'
),
(
    1586,
    '整数替换',
    '给定正整数 n
当 n 为偶数时，可以将 n 替换为 n / 2
当 n 为奇数时，可以将 n 替换为 n - 1 或 n + 1
返回把 n 变成 1 所需的最少操作次数',
    'medium',
    1000,
    256,
    ARRAY['数学', '位运算', '贪心'],
    $json$[
  {
    "input": "n = 8",
    "output": "3"
  },
  {
    "input": "n = 7",
    "output": "4"
  },
  {
    "input": "n = 4",
    "output": "2"
  },
  {
    "input": "n = 1",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 8",
    "output": "3"
  },
  {
    "input": "n = 7",
    "output": "4"
  },
  {
    "input": "n = 4",
    "output": "2"
  },
  {
    "input": "n = 1",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var integerReplacement = function(n) {\n};\n",
  "python": "class Solution:\n    def integerReplacement(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int integerReplacement(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int integerReplacement(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "integerReplacement",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        8
      ],
      "expected": 3
    },
    {
      "args": [
        7
      ],
      "expected": 4
    },
    {
      "args": [
        4
      ],
      "expected": 2
    },
    {
      "args": [
        1
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2
    ],
    "expected": 1
  },
  {
    "args": [
      3
    ],
    "expected": 2
  },
  {
    "args": [
      15
    ],
    "expected": 5
  },
  {
    "args": [
      16
    ],
    "expected": 4
  },
  {
    "args": [
      10
    ],
    "expected": 4
  },
  {
    "args": [
      2147483647
    ],
    "expected": 32
  }
]$json$::jsonb,
    'approved'
),
(
    1587,
    '最大数',
    '给定非负整数数组 nums
将数组中的数字重新排列并拼接，使得到的字符串表示的数最大
返回这个最大的数字字符串
若结果全是 0 则返回字符串 0',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '字符串'],
    $json$[
  {
    "input": "nums = [10, 2]",
    "output": "\"210\""
  },
  {
    "input": "nums = [3, 30, 34, 5, 9]",
    "output": "\"9534330\""
  },
  {
    "input": "nums = [0, 0]",
    "output": "\"0\""
  },
  {
    "input": "nums = [1]",
    "output": "\"1\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [10, 2]",
    "output": "\"210\""
  },
  {
    "input": "nums = [3, 30, 34, 5, 9]",
    "output": "\"9534330\""
  },
  {
    "input": "nums = [0, 0]",
    "output": "\"0\""
  },
  {
    "input": "nums = [1]",
    "output": "\"1\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestNumber = function(nums) {\n};\n",
  "python": "class Solution:\n    def largestNumber(self, nums: list[int]) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string largestNumber(std::vector<int>& nums) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String largestNumber(int[] nums) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestNumber",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          10,
          2
        ]
      ],
      "expected": "210"
    },
    {
      "args": [
        [
          3,
          30,
          34,
          5,
          9
        ]
      ],
      "expected": "9534330"
    },
    {
      "args": [
        [
          0,
          0
        ]
      ],
      "expected": "0"
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": "1"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        3
      ]
    ],
    "expected": "321"
  },
  {
    "args": [
      [
        0
      ]
    ],
    "expected": "0"
  },
  {
    "args": [
      [
        121,
        12
      ]
    ],
    "expected": "12121"
  },
  {
    "args": [
      [
        999999998,
        999999997,
        999999999
      ]
    ],
    "expected": "999999999999999998999999997"
  },
  {
    "args": [
      [
        0,
        0,
        0,
        1
      ]
    ],
    "expected": "1000"
  }
]$json$::jsonb,
    'approved'
),
(
    1588,
    '最小时间差',
    '给定一个 24 小时制时间列表 timePoints，格式为 HH:MM
返回列表中任意两个时间之间的最小分钟差
时间按环形计算，例如 23:59 与 00:00 相差 1 分钟',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '字符串'],
    $json$[
  {
    "input": "timePoints = [\"23:59\", \"00:00\"]",
    "output": "1"
  },
  {
    "input": "timePoints = [\"00:00\", \"23:59\", \"00:00\"]",
    "output": "0"
  },
  {
    "input": "timePoints = [\"01:01\", \"02:01\", \"03:01\"]",
    "output": "60"
  },
  {
    "input": "timePoints = [\"05:31\", \"22:08\", \"00:35\"]",
    "output": "147"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "timePoints = [\"23:59\", \"00:00\"]",
    "output": "1"
  },
  {
    "input": "timePoints = [\"00:00\", \"23:59\", \"00:00\"]",
    "output": "0"
  },
  {
    "input": "timePoints = [\"01:01\", \"02:01\", \"03:01\"]",
    "output": "60"
  },
  {
    "input": "timePoints = [\"05:31\", \"22:08\", \"00:35\"]",
    "output": "147"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findMinDifference = function(timePoints) {\n};\n",
  "python": "class Solution:\n    def findMinDifference(self, timePoints: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findMinDifference(std::vector<std::string>& timePoints) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findMinDifference(String[] timePoints) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findMinDifference",
  "params": [
    {
      "name": "timePoints",
      "type": "string[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "23:59",
          "00:00"
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          "00:00",
          "23:59",
          "00:00"
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          "01:01",
          "02:01",
          "03:01"
        ]
      ],
      "expected": 60
    },
    {
      "args": [
        [
          "05:31",
          "22:08",
          "00:35"
        ]
      ],
      "expected": 147
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "00:00",
        "00:01"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "00:00",
        "12:00"
      ]
    ],
    "expected": 720
  },
  {
    "args": [
      [
        "12:00",
        "12:01",
        "00:00"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "01:00",
        "01:30",
        "02:00",
        "23:00"
      ]
    ],
    "expected": 30
  }
]$json$::jsonb,
    'approved'
),
(
    1589,
    '存在重复元素 III',
    '给定整数数组 nums 以及整数 indexDiff 和 valueDiff
判断是否存在两个不同下标 i 和 j 满足 abs(i - j) <= indexDiff 且 abs(nums[i] - nums[j]) <= valueDiff
若存在返回 true，否则返回 false',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表', '滑动窗口'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 1], indexDiff = 3, valueDiff = 0",
    "output": "true"
  },
  {
    "input": "nums = [1, 0, 1, 1], indexDiff = 1, valueDiff = 2",
    "output": "true"
  },
  {
    "input": "nums = [1, 5, 9, 1, 5, 9], indexDiff = 2, valueDiff = 3",
    "output": "false"
  },
  {
    "input": "nums = [1, 2], indexDiff = 0, valueDiff = 1",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 1], indexDiff = 3, valueDiff = 0",
    "output": "true"
  },
  {
    "input": "nums = [1, 0, 1, 1], indexDiff = 1, valueDiff = 2",
    "output": "true"
  },
  {
    "input": "nums = [1, 5, 9, 1, 5, 9], indexDiff = 2, valueDiff = 3",
    "output": "false"
  },
  {
    "input": "nums = [1, 2], indexDiff = 0, valueDiff = 1",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var containsNearbyAlmostDuplicate = function(nums, indexDiff, valueDiff) {\n};\n",
  "python": "class Solution:\n    def containsNearbyAlmostDuplicate(self, nums: list[int], indexDiff: int, valueDiff: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool containsNearbyAlmostDuplicate(std::vector<int>& nums, int indexDiff, int valueDiff) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean containsNearbyAlmostDuplicate(int[] nums, int indexDiff, int valueDiff) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "containsNearbyAlmostDuplicate",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "indexDiff",
      "type": "int"
    },
    {
      "name": "valueDiff",
      "type": "int"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3,
          1
        ],
        3,
        0
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          0,
          1,
          1
        ],
        1,
        2
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          5,
          9,
          1,
          5,
          9
        ],
        2,
        3
      ],
      "expected": false
    },
    {
      "args": [
        [
          1,
          2
        ],
        0,
        1
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        3,
        1
      ],
      3,
      1
    ],
    "expected": true
  },
  {
    "args": [
      [
        -3,
        3
      ],
      1,
      6
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        1,
        2
      ],
      1,
      0
    ],
    "expected": false
  },
  {
    "args": [
      [
        0,
        10,
        20
      ],
      5,
      5
    ],
    "expected": false
  },
  {
    "args": [
      [
        4,
        1,
        2,
        3
      ],
      2,
      1
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1590,
    '四数相加 II',
    '给定四个整数数组 nums1、nums2、nums3、nums4，长度都为 n
统计有多少个四元组 (i, j, k, l) 满足 nums1[i] + nums2[j] + nums3[k] + nums4[l] == 0
返回满足条件的元组数量',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "nums1 = [1, 2], nums2 = [-2, -1], nums3 = [-1, 2], nums4 = [0, 2]",
    "output": "2"
  },
  {
    "input": "nums1 = [0], nums2 = [0], nums3 = [0], nums4 = [0]",
    "output": "1"
  },
  {
    "input": "nums1 = [1, 2], nums2 = [3, 4], nums3 = [5, 6], nums4 = [7, 8]",
    "output": "0"
  },
  {
    "input": "nums1 = [-1, -1], nums2 = [-1, -1], nums3 = [-1, -1], nums4 = [-1, -1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums1 = [1, 2], nums2 = [-2, -1], nums3 = [-1, 2], nums4 = [0, 2]",
    "output": "2"
  },
  {
    "input": "nums1 = [0], nums2 = [0], nums3 = [0], nums4 = [0]",
    "output": "1"
  },
  {
    "input": "nums1 = [1, 2], nums2 = [3, 4], nums3 = [5, 6], nums4 = [7, 8]",
    "output": "0"
  },
  {
    "input": "nums1 = [-1, -1], nums2 = [-1, -1], nums3 = [-1, -1], nums4 = [-1, -1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var fourSumCount = function(nums1, nums2, nums3, nums4) {\n};\n",
  "python": "class Solution:\n    def fourSumCount(self, nums1: list[int], nums2: list[int], nums3: list[int], nums4: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int fourSumCount(std::vector<int>& nums1, std::vector<int>& nums2, std::vector<int>& nums3, std::vector<int>& nums4) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int fourSumCount(int[] nums1, int[] nums2, int[] nums3, int[] nums4) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "fourSumCount",
  "params": [
    {
      "name": "nums1",
      "type": "int[]"
    },
    {
      "name": "nums2",
      "type": "int[]"
    },
    {
      "name": "nums3",
      "type": "int[]"
    },
    {
      "name": "nums4",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2
        ],
        [
          -2,
          -1
        ],
        [
          -1,
          2
        ],
        [
          0,
          2
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          0
        ],
        [
          0
        ],
        [
          0
        ],
        [
          0
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          2
        ],
        [
          3,
          4
        ],
        [
          5,
          6
        ],
        [
          7,
          8
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          -1,
          -1
        ],
        [
          -1,
          -1
        ],
        [
          -1,
          -1
        ],
        [
          -1,
          -1
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ],
      [
        -1
      ],
      [
        0
      ],
      [
        0
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2,
        3
      ],
      [
        0,
        0,
        0
      ],
      [
        0,
        0,
        0
      ],
      [
        -1,
        -2,
        -3
      ]
    ],
    "expected": 27
  },
  {
    "args": [
      [
        2,
        -2
      ],
      [
        2,
        -2
      ],
      [
        2,
        -2
      ],
      [
        2,
        -2
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        5
      ],
      [
        -5
      ],
      [
        0
      ],
      [
        0
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1591,
    '砖墙',
    '给定一面由砖块组成的墙 wall，wall[i] 表示第 i 行每块砖的宽度
所有行的总宽度相同，从顶部画一条垂直线，要求穿过的砖块数量最少
返回穿过砖块的最少数量
垂直线不能画在墙的两端',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "wall = [[1, 2, 2, 1], [3, 1, 2], [1, 3, 2], [2, 4], [3, 1, 2], [1, 3, 1, 1]]",
    "output": "2"
  },
  {
    "input": "wall = [[1], [1], [1]]",
    "output": "3"
  },
  {
    "input": "wall = [[1, 1], [2]]",
    "output": "1"
  },
  {
    "input": "wall = [[2, 2, 2], [1, 1, 2, 2]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "wall = [[1, 2, 2, 1], [3, 1, 2], [1, 3, 2], [2, 4], [3, 1, 2], [1, 3, 1, 1]]",
    "output": "2"
  },
  {
    "input": "wall = [[1], [1], [1]]",
    "output": "3"
  },
  {
    "input": "wall = [[1, 1], [2]]",
    "output": "1"
  },
  {
    "input": "wall = [[2, 2, 2], [1, 1, 2, 2]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var leastBricks = function(wall) {\n};\n",
  "python": "class Solution:\n    def leastBricks(self, wall: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int leastBricks(std::vector<std::vector<int>>& wall) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int leastBricks(int[][] wall) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "leastBricks",
  "params": [
    {
      "name": "wall",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            2,
            2,
            1
          ],
          [
            3,
            1,
            2
          ],
          [
            1,
            3,
            2
          ],
          [
            2,
            4
          ],
          [
            3,
            1,
            2
          ],
          [
            1,
            3,
            1,
            1
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            1
          ],
          [
            1
          ],
          [
            1
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          [
            1,
            1
          ],
          [
            2
          ]
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          [
            2,
            2,
            2
          ],
          [
            1,
            1,
            2,
            2
          ]
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          1,
          1
        ],
        [
          1,
          1,
          1
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          1,
          2,
          3
        ],
        [
          1,
          2,
          3
        ],
        [
          1,
          2,
          3
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          4
        ],
        [
          4
        ],
        [
          4
        ]
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        [
          1,
          1,
          1,
          1
        ]
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1592,
    '重复的 DNA 序列',
    'DNA 序列由字符 A、C、G、T 组成
给定字符串 s，找出所有在 s 中出现不止一次的长度为 10 的子串
返回这些子串，按字典序升序排列，重复子串只返回一次',
    'medium',
    1000,
    256,
    ARRAY['字符串', '哈希表', '滑动窗口'],
    $json$[
  {
    "input": "s = \"AAAAACCCCCAAAAACCCCCCAAAAAGGGTTT\"",
    "output": "[\"AAAAACCCCC\", \"CCCCCAAAAA\"]"
  },
  {
    "input": "s = \"AAAAAAAAAAAAA\"",
    "output": "[\"AAAAAAAAAA\"]"
  },
  {
    "input": "s = \"ACGT\"",
    "output": "[]"
  },
  {
    "input": "s = \"AAAAAAAAAA\"",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"AAAAACCCCCAAAAACCCCCCAAAAAGGGTTT\"",
    "output": "[\"AAAAACCCCC\", \"CCCCCAAAAA\"]"
  },
  {
    "input": "s = \"AAAAAAAAAAAAA\"",
    "output": "[\"AAAAAAAAAA\"]"
  },
  {
    "input": "s = \"ACGT\"",
    "output": "[]"
  },
  {
    "input": "s = \"AAAAAAAAAA\"",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findRepeatedDnaSequences = function(s) {\n};\n",
  "python": "class Solution:\n    def findRepeatedDnaSequences(self, s: str) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> findRepeatedDnaSequences(std::string s) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] findRepeatedDnaSequences(String s) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findRepeatedDnaSequences",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "string[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "AAAAACCCCCAAAAACCCCCCAAAAAGGGTTT"
      ],
      "expected": [
        "AAAAACCCCC",
        "CCCCCAAAAA"
      ]
    },
    {
      "args": [
        "AAAAAAAAAAAAA"
      ],
      "expected": [
        "AAAAAAAAAA"
      ]
    },
    {
      "args": [
        "ACGT"
      ],
      "expected": []
    },
    {
      "args": [
        "AAAAAAAAAA"
      ],
      "expected": []
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "ACGTACGTACGTACGTACGT"
    ],
    "expected": [
      "ACGTACGTAC",
      "CGTACGTACG",
      "GTACGTACGT",
      "TACGTACGTA"
    ]
  },
  {
    "args": [
      "CCCACCCCAAACCCACCCCC"
    ],
    "expected": []
  },
  {
    "args": [
      "GAGAGAGAGAGAGAGAGAGA"
    ],
    "expected": [
      "AGAGAGAGAG",
      "GAGAGAGAGA"
    ]
  },
  {
    "args": [
      "TTTTTTTTTTTTTTTTTTTT"
    ],
    "expected": [
      "TTTTTTTTTT"
    ]
  },
  {
    "args": [
      "A"
    ],
    "expected": []
  }
]$json$::jsonb,
    'approved'
),
(
    1593,
    '连续的子数组和',
    '给定整数数组 nums 和整数 k，k 大于 0
判断是否存在长度至少为 2 的连续子数组，其元素和是 k 的整数倍
若存在返回 true，否则返回 false',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '哈希表'],
    $json$[
  {
    "input": "nums = [23, 2, 4, 6, 7], k = 6",
    "output": "true"
  },
  {
    "input": "nums = [23, 2, 6, 4, 7], k = 6",
    "output": "true"
  },
  {
    "input": "nums = [23, 2, 6, 4, 7], k = 13",
    "output": "false"
  },
  {
    "input": "nums = [5, 0, 0, 0], k = 3",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [23, 2, 4, 6, 7], k = 6",
    "output": "true"
  },
  {
    "input": "nums = [23, 2, 6, 4, 7], k = 6",
    "output": "true"
  },
  {
    "input": "nums = [23, 2, 6, 4, 7], k = 13",
    "output": "false"
  },
  {
    "input": "nums = [5, 0, 0, 0], k = 3",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var checkSubarraySum = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def checkSubarraySum(self, nums: list[int], k: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool checkSubarraySum(std::vector<int>& nums, int k) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean checkSubarraySum(int[] nums, int k) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkSubarraySum",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          23,
          2,
          4,
          6,
          7
        ],
        6
      ],
      "expected": true
    },
    {
      "args": [
        [
          23,
          2,
          6,
          4,
          7
        ],
        6
      ],
      "expected": true
    },
    {
      "args": [
        [
          23,
          2,
          6,
          4,
          7
        ],
        13
      ],
      "expected": false
    },
    {
      "args": [
        [
          5,
          0,
          0,
          0
        ],
        3
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0,
        0
      ],
      1
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        3
      ],
      5
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ],
      9
    ],
    "expected": true
  },
  {
    "args": [
      [
        0
      ],
      1
    ],
    "expected": false
  },
  {
    "args": [
      [
        2,
        4,
        3
      ],
      6
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1594,
    '连续数组',
    '给定只包含 0 和 1 的整数数组 nums
找出含有相同数量 0 和 1 的最长连续子数组，返回其长度
若不存在这样的子数组则返回 0',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '哈希表'],
    $json$[
  {
    "input": "nums = [0, 1]",
    "output": "2"
  },
  {
    "input": "nums = [0, 1, 0]",
    "output": "2"
  },
  {
    "input": "nums = [0, 0, 1, 0, 0, 0, 1, 1]",
    "output": "6"
  },
  {
    "input": "nums = [1, 1, 1, 1, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [0, 1]",
    "output": "2"
  },
  {
    "input": "nums = [0, 1, 0]",
    "output": "2"
  },
  {
    "input": "nums = [0, 0, 1, 0, 0, 0, 1, 1]",
    "output": "6"
  },
  {
    "input": "nums = [1, 1, 1, 1, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findMaxLength = function(nums) {\n};\n",
  "python": "class Solution:\n    def findMaxLength(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findMaxLength(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findMaxLength(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findMaxLength",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          0,
          1
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          0,
          1,
          0
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          0,
          0,
          1,
          0,
          0,
          0,
          1,
          1
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          1,
          1,
          1,
          1,
          1
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        0,
        0,
        1,
        1
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        1,
        0,
        1,
        0,
        1,
        1,
        0,
        0
      ]
    ],
    "expected": 8
  },
  {
    "args": [
      [
        0,
        0,
        0,
        1,
        1,
        1,
        0
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        1,
        0
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1595,
    '二维区域和检索 - 矩阵不可变',
    '给定二维整数矩阵 matrix 和查询列表 queries
每个查询为 [row1, col1, row2, col2]，表示矩阵中一个矩形区域的左上角和右下角下标
计算每个矩形区域内元素之和，区域边界包含在内
返回数组按 queries 的顺序给出每个查询的结果',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '矩阵'],
    $json$[
  {
    "input": "matrix = [[3, 0, 1, 4, 2], [5, 6, 3, 2, 1], [1, 2, 0, 1, 5], [4, 1, 0, 1, 7], [1, 0, 3, 0, 5]], queries = [[2, 1, 4, 3], [1, 1, 2, 2], [1, 2, 2, 4]]",
    "output": "[8, 11, 12]"
  },
  {
    "input": "matrix = [[1]], queries = [[0, 0, 0, 0]]",
    "output": "[1]"
  },
  {
    "input": "matrix = [[1, 2], [3, 4]], queries = [[0, 0, 1, 1], [0, 0, 0, 0], [0, 1, 1, 1]]",
    "output": "[10, 1, 6]"
  },
  {
    "input": "matrix = [[2, 3], [5, 7]], queries = [[0, 0, 0, 1]]",
    "output": "[5]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[3, 0, 1, 4, 2], [5, 6, 3, 2, 1], [1, 2, 0, 1, 5], [4, 1, 0, 1, 7], [1, 0, 3, 0, 5]], queries = [[2, 1, 4, 3], [1, 1, 2, 2], [1, 2, 2, 4]]",
    "output": "[8, 11, 12]"
  },
  {
    "input": "matrix = [[1]], queries = [[0, 0, 0, 0]]",
    "output": "[1]"
  },
  {
    "input": "matrix = [[1, 2], [3, 4]], queries = [[0, 0, 1, 1], [0, 0, 0, 0], [0, 1, 1, 1]]",
    "output": "[10, 1, 6]"
  },
  {
    "input": "matrix = [[2, 3], [5, 7]], queries = [[0, 0, 0, 1]]",
    "output": "[5]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumRegionQueries = function(matrix, queries) {\n};\n",
  "python": "class Solution:\n    def sumRegionQueries(self, matrix: list[list[int]], queries: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> sumRegionQueries(std::vector<std::vector<int>>& matrix, std::vector<std::vector<int>>& queries) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] sumRegionQueries(int[][] matrix, int[][] queries) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumRegionQueries",
  "params": [
    {
      "name": "matrix",
      "type": "int[][]"
    },
    {
      "name": "queries",
      "type": "int[][]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            3,
            0,
            1,
            4,
            2
          ],
          [
            5,
            6,
            3,
            2,
            1
          ],
          [
            1,
            2,
            0,
            1,
            5
          ],
          [
            4,
            1,
            0,
            1,
            7
          ],
          [
            1,
            0,
            3,
            0,
            5
          ]
        ],
        [
          [
            2,
            1,
            4,
            3
          ],
          [
            1,
            1,
            2,
            2
          ],
          [
            1,
            2,
            2,
            4
          ]
        ]
      ],
      "expected": [
        8,
        11,
        12
      ]
    },
    {
      "args": [
        [
          [
            1
          ]
        ],
        [
          [
            0,
            0,
            0,
            0
          ]
        ]
      ],
      "expected": [
        1
      ]
    },
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            3,
            4
          ]
        ],
        [
          [
            0,
            0,
            1,
            1
          ],
          [
            0,
            0,
            0,
            0
          ],
          [
            0,
            1,
            1,
            1
          ]
        ]
      ],
      "expected": [
        10,
        1,
        6
      ]
    },
    {
      "args": [
        [
          [
            2,
            3
          ],
          [
            5,
            7
          ]
        ],
        [
          [
            0,
            0,
            0,
            1
          ]
        ]
      ],
      "expected": [
        5
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          2,
          3
        ],
        [
          4,
          5,
          6
        ]
      ],
      [
        [
          0,
          0,
          1,
          1
        ],
        [
          1,
          0,
          1,
          2
        ]
      ]
    ],
    "expected": [
      12,
      15
    ]
  },
  {
    "args": [
      [
        [
          -1,
          -2
        ],
        [
          -3,
          -4
        ]
      ],
      [
        [
          0,
          0,
          1,
          1
        ],
        [
          0,
          1,
          0,
          1
        ]
      ]
    ],
    "expected": [
      -10,
      -2
    ]
  },
  {
    "args": [
      [
        [
          1,
          1,
          1
        ],
        [
          1,
          1,
          1
        ]
      ],
      [
        [
          0,
          0,
          0,
          2
        ],
        [
          1,
          1,
          1,
          1
        ],
        [
          0,
          1,
          1,
          2
        ]
      ]
    ],
    "expected": [
      3,
      1,
      4
    ]
  },
  {
    "args": [
      [
        [
          0,
          0
        ],
        [
          0,
          0
        ]
      ],
      [
        [
          0,
          0,
          1,
          1
        ]
      ]
    ],
    "expected": [
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1596,
    '旋转函数',
    '给定长度为 n 的整数数组 nums
定义 F(k) = 0 * nums[k] + 1 * nums[k+1] + ... + (n-1) * nums[(k+n-1) % n]
其中 k 从 0 到 n-1，数组下标按循环方式取用
返回 F(0) 到 F(n-1) 中的最大值',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '数学'],
    $json$[
  {
    "input": "nums = [4, 3, 2, 6]",
    "output": "26"
  },
  {
    "input": "nums = [100]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "8"
  },
  {
    "input": "nums = [0, 0, 0]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [4, 3, 2, 6]",
    "output": "26"
  },
  {
    "input": "nums = [100]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "8"
  },
  {
    "input": "nums = [0, 0, 0]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxRotateFunction = function(nums) {\n};\n",
  "python": "class Solution:\n    def maxRotateFunction(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long maxRotateFunction(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long maxRotateFunction(int[] nums) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxRotateFunction",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "long",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          4,
          3,
          2,
          6
        ]
      ],
      "expected": 26
    },
    {
      "args": [
        [
          100
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          1,
          2,
          3
        ]
      ],
      "expected": 8
    },
    {
      "args": [
        [
          0,
          0,
          0
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ]
    ],
    "expected": 40
  },
  {
    "args": [
      [
        -1,
        -2,
        -3
      ]
    ],
    "expected": -5
  },
  {
    "args": [
      [
        5,
        1,
        9
      ]
    ],
    "expected": 19
  },
  {
    "args": [
      [
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        2,
        3,
        4,
        1
      ]
    ],
    "expected": 20
  }
]$json$::jsonb,
    'approved'
),
(
    1597,
    '移掉 K 位数字',
    '给定一个以字符串表示的非负整数 num 和整数 k
移除 num 中的 k 个数字，使剩下的数字组成的新数最小
返回这个最小数字对应的字符串，不能有前导零
如果移除后所有数字都被删掉，返回字符串 0',
    'medium',
    1000,
    256,
    ARRAY['字符串', '栈', '贪心'],
    $json$[
  {
    "input": "num = \"1432219\", k = 3",
    "output": "\"1219\""
  },
  {
    "input": "num = \"10200\", k = 1",
    "output": "\"200\""
  },
  {
    "input": "num = \"10\", k = 2",
    "output": "\"0\""
  },
  {
    "input": "num = \"112\", k = 1",
    "output": "\"11\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = \"1432219\", k = 3",
    "output": "\"1219\""
  },
  {
    "input": "num = \"10200\", k = 1",
    "output": "\"200\""
  },
  {
    "input": "num = \"10\", k = 2",
    "output": "\"0\""
  },
  {
    "input": "num = \"112\", k = 1",
    "output": "\"11\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeKdigits = function(num, k) {\n};\n",
  "python": "class Solution:\n    def removeKdigits(self, num: str, k: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string removeKdigits(std::string num, int k) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String removeKdigits(String num, int k) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeKdigits",
  "params": [
    {
      "name": "num",
      "type": "string"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "1432219",
        3
      ],
      "expected": "1219"
    },
    {
      "args": [
        "10200",
        1
      ],
      "expected": "200"
    },
    {
      "args": [
        "10",
        2
      ],
      "expected": "0"
    },
    {
      "args": [
        "112",
        1
      ],
      "expected": "11"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "9",
      1
    ],
    "expected": "0"
  },
  {
    "args": [
      "12345",
      2
    ],
    "expected": "123"
  },
  {
    "args": [
      "1111",
      2
    ],
    "expected": "11"
  },
  {
    "args": [
      "100200",
      2
    ],
    "expected": "0"
  },
  {
    "args": [
      "4321",
      2
    ],
    "expected": "21"
  }
]$json$::jsonb,
    'approved'
),
(
    1598,
    '去除重复字母',
    '给定字符串 s，删除其中重复的字母，使每个字母只出现一次
在所有可能的结果中，要求返回字典序最小的结果
返回的字符串中字符相对顺序不能改变',
    'medium',
    1000,
    256,
    ARRAY['字符串', '栈', '贪心'],
    $json$[
  {
    "input": "s = \"bcabc\"",
    "output": "\"abc\""
  },
  {
    "input": "s = \"cbacdcbc\"",
    "output": "\"acdb\""
  },
  {
    "input": "s = \"abacb\"",
    "output": "\"abc\""
  },
  {
    "input": "s = \"zab\"",
    "output": "\"zab\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"bcabc\"",
    "output": "\"abc\""
  },
  {
    "input": "s = \"cbacdcbc\"",
    "output": "\"acdb\""
  },
  {
    "input": "s = \"abacb\"",
    "output": "\"abc\""
  },
  {
    "input": "s = \"zab\"",
    "output": "\"zab\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeDuplicateLetters = function(s) {\n};\n",
  "python": "class Solution:\n    def removeDuplicateLetters(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string removeDuplicateLetters(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String removeDuplicateLetters(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeDuplicateLetters",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "bcabc"
      ],
      "expected": "abc"
    },
    {
      "args": [
        "cbacdcbc"
      ],
      "expected": "acdb"
    },
    {
      "args": [
        "abacb"
      ],
      "expected": "abc"
    },
    {
      "args": [
        "zab"
      ],
      "expected": "zab"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a"
    ],
    "expected": "a"
  },
  {
    "args": [
      "aaaa"
    ],
    "expected": "a"
  },
  {
    "args": [
      "cba"
    ],
    "expected": "cba"
  },
  {
    "args": [
      "bacbc"
    ],
    "expected": "abc"
  },
  {
    "args": [
      "edcbaabcd"
    ],
    "expected": "eabcd"
  }
]$json$::jsonb,
    'approved'
),
(
    1599,
    '下一个更大元素 II',
    '给定循环整数数组 nums
对每个元素 nums[i]，找到它后面第一个比它大的元素
查找时可以循环使用数组，若不存在这样的元素则为 -1
返回每个位置对应的下一个更大元素',
    'medium',
    1000,
    256,
    ARRAY['数组', '栈', '单调栈'],
    $json$[
  {
    "input": "nums = [1, 2, 1]",
    "output": "[2, -1, 2]"
  },
  {
    "input": "nums = [1, 2, 3, 4, 3]",
    "output": "[2, 3, 4, -1, 4]"
  },
  {
    "input": "nums = [5, 4, 3, 2, 1]",
    "output": "[-1, 5, 5, 5, 5]"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "[-1, -1, -1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 1]",
    "output": "[2, -1, 2]"
  },
  {
    "input": "nums = [1, 2, 3, 4, 3]",
    "output": "[2, 3, 4, -1, 4]"
  },
  {
    "input": "nums = [5, 4, 3, 2, 1]",
    "output": "[-1, 5, 5, 5, 5]"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "[-1, -1, -1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var nextGreaterElements = function(nums) {\n};\n",
  "python": "class Solution:\n    def nextGreaterElements(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> nextGreaterElements(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] nextGreaterElements(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "nextGreaterElements",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          1
        ]
      ],
      "expected": [
        2,
        -1,
        2
      ]
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4,
          3
        ]
      ],
      "expected": [
        2,
        3,
        4,
        -1,
        4
      ]
    },
    {
      "args": [
        [
          5,
          4,
          3,
          2,
          1
        ]
      ],
      "expected": [
        -1,
        5,
        5,
        5,
        5
      ]
    },
    {
      "args": [
        [
          1,
          1,
          1
        ]
      ],
      "expected": [
        -1,
        -1,
        -1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        2,
        1,
        2
      ]
    ],
    "expected": [
      -1,
      2,
      -1
    ]
  },
  {
    "args": [
      [
        -1,
        0
      ]
    ],
    "expected": [
      0,
      -1
    ]
  },
  {
    "args": [
      [
        3,
        1,
        2,
        4
      ]
    ],
    "expected": [
      4,
      2,
      4,
      -1
    ]
  },
  {
    "args": [
      [
        1
      ]
    ],
    "expected": [
      -1
    ]
  },
  {
    "args": [
      [
        7,
        1,
        5,
        3,
        6,
        4
      ]
    ],
    "expected": [
      -1,
      5,
      6,
      6,
      7,
      7
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1600,
    '132 模式',
    '给定整数数组 nums
判断是否存在下标 i < j < k，满足 nums[i] < nums[k] < nums[j]
若存在返回 true，否则返回 false',
    'medium',
    1000,
    256,
    ARRAY['数组', '栈', '单调栈'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "false"
  },
  {
    "input": "nums = [3, 1, 4, 2]",
    "output": "true"
  },
  {
    "input": "nums = [-1, 3, 2, 0]",
    "output": "true"
  },
  {
    "input": "nums = [1, 0, 1, -1, -1]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "false"
  },
  {
    "input": "nums = [3, 1, 4, 2]",
    "output": "true"
  },
  {
    "input": "nums = [-1, 3, 2, 0]",
    "output": "true"
  },
  {
    "input": "nums = [1, 0, 1, -1, -1]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var find132pattern = function(nums) {\n};\n",
  "python": "class Solution:\n    def find132pattern(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool find132pattern(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean find132pattern(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "find132pattern",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3,
          4
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          3,
          1,
          4,
          2
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          -1,
          3,
          2,
          0
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          0,
          1,
          -1,
          -1
        ]
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        2,
        3,
        1
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        3,
        5,
        0,
        3,
        4
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        -2,
        1,
        2,
        -2,
        1,
        2
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        0,
        -1
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1601,
    '有序数组中的单一元素',
    '给定一个按升序排列的整数数组 nums
除一个元素只出现一次外，其余每个元素都恰好出现两次
返回只出现一次的元素
要求 O(log n) 时间与 O(1) 额外空间',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "nums = [1, 1, 2, 3, 3, 4, 4, 8, 8]",
    "output": "2"
  },
  {
    "input": "nums = [3, 3, 7, 7, 10, 11, 11]",
    "output": "10"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 1, 2]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 2, 3, 3, 4, 4, 8, 8]",
    "output": "2"
  },
  {
    "input": "nums = [3, 3, 7, 7, 10, 11, 11]",
    "output": "10"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 1, 2]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var singleNonDuplicate = function(nums) {\n};\n",
  "python": "class Solution:\n    def singleNonDuplicate(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int singleNonDuplicate(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int singleNonDuplicate(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "singleNonDuplicate",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          1,
          2,
          3,
          3,
          4,
          4,
          8,
          8
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          3,
          3,
          7,
          7,
          10,
          11,
          11
        ]
      ],
      "expected": 10
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          1,
          2
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        2
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        0,
        0,
        1,
        1,
        2,
        3,
        3
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        -1,
        -1,
        0
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        5,
        5,
        6,
        6,
        7,
        8,
        8,
        9,
        9
      ]
    ],
    "expected": 7
  },
  {
    "args": [
      [
        2,
        3,
        3
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1602,
    '寻找右区间',
    '给定一组区间 intervals，其中 intervals[i] = [start_i, end_i]
对于每个区间 i，寻找另一个区间 j，使 start_j >= end_i 且 start_j 最小
返回每个区间对应的 j 的下标，若不存在则返回 -1
结果数组按输入区间的顺序排列',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找', '排序'],
    $json$[
  {
    "input": "intervals = [[1, 2]]",
    "output": "[-1]"
  },
  {
    "input": "intervals = [[3, 4], [2, 3], [1, 2]]",
    "output": "[-1, 0, 1]"
  },
  {
    "input": "intervals = [[1, 4], [2, 3], [3, 4]]",
    "output": "[-1, 2, -1]"
  },
  {
    "input": "intervals = [[1, 2], [2, 3]]",
    "output": "[1, -1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "intervals = [[1, 2]]",
    "output": "[-1]"
  },
  {
    "input": "intervals = [[3, 4], [2, 3], [1, 2]]",
    "output": "[-1, 0, 1]"
  },
  {
    "input": "intervals = [[1, 4], [2, 3], [3, 4]]",
    "output": "[-1, 2, -1]"
  },
  {
    "input": "intervals = [[1, 2], [2, 3]]",
    "output": "[1, -1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findRightInterval = function(intervals) {\n};\n",
  "python": "class Solution:\n    def findRightInterval(self, intervals: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findRightInterval(std::vector<std::vector<int>>& intervals) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findRightInterval(int[][] intervals) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findRightInterval",
  "params": [
    {
      "name": "intervals",
      "type": "int[][]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            2
          ]
        ]
      ],
      "expected": [
        -1
      ]
    },
    {
      "args": [
        [
          [
            3,
            4
          ],
          [
            2,
            3
          ],
          [
            1,
            2
          ]
        ]
      ],
      "expected": [
        -1,
        0,
        1
      ]
    },
    {
      "args": [
        [
          [
            1,
            4
          ],
          [
            2,
            3
          ],
          [
            3,
            4
          ]
        ]
      ],
      "expected": [
        -1,
        2,
        -1
      ]
    },
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            2,
            3
          ]
        ]
      ],
      "expected": [
        1,
        -1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          4
        ],
        [
          2,
          3
        ],
        [
          3,
          4
        ],
        [
          5,
          6
        ]
      ]
    ],
    "expected": [
      3,
      2,
      3,
      -1
    ]
  },
  {
    "args": [
      [
        [
          5,
          6
        ],
        [
          1,
          2
        ],
        [
          2,
          3
        ]
      ]
    ],
    "expected": [
      -1,
      2,
      0
    ]
  },
  {
    "args": [
      [
        [
          -3,
          -2
        ],
        [
          -1,
          0
        ],
        [
          0,
          1
        ]
      ]
    ],
    "expected": [
      1,
      2,
      -1
    ]
  },
  {
    "args": [
      [
        [
          1,
          10
        ],
        [
          2,
          3
        ],
        [
          4,
          5
        ]
      ]
    ],
    "expected": [
      -1,
      2,
      -1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1603,
    '供暖器',
    '给定房屋位置数组 houses 和供暖器位置数组 heaters
供暖器的辐射半径相同，所有房屋都必须被至少一个供暖器覆盖
返回能够覆盖所有房屋的最小辐射半径',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找', '排序'],
    $json$[
  {
    "input": "houses = [1, 2, 3], heaters = [2]",
    "output": "1"
  },
  {
    "input": "houses = [1, 2, 3, 4], heaters = [1, 4]",
    "output": "1"
  },
  {
    "input": "houses = [1, 5], heaters = [2]",
    "output": "3"
  },
  {
    "input": "houses = [1, 2, 3], heaters = [1, 3]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "houses = [1, 2, 3], heaters = [2]",
    "output": "1"
  },
  {
    "input": "houses = [1, 2, 3, 4], heaters = [1, 4]",
    "output": "1"
  },
  {
    "input": "houses = [1, 5], heaters = [2]",
    "output": "3"
  },
  {
    "input": "houses = [1, 2, 3], heaters = [1, 3]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findRadius = function(houses, heaters) {\n};\n",
  "python": "class Solution:\n    def findRadius(self, houses: list[int], heaters: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findRadius(std::vector<int>& houses, std::vector<int>& heaters) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findRadius(int[] houses, int[] heaters) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findRadius",
  "params": [
    {
      "name": "houses",
      "type": "int[]"
    },
    {
      "name": "heaters",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3
        ],
        [
          2
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4
        ],
        [
          1,
          4
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          5
        ],
        [
          2
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          1,
          2,
          3
        ],
        [
          1,
          3
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ],
      [
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ],
      [
        3
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        100
      ],
      [
        50,
        51
      ]
    ],
    "expected": 49
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5,
        6
      ],
      [
        2,
        5
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        10,
        20,
        30
      ],
      [
        15
      ]
    ],
    "expected": 15
  }
]$json$::jsonb,
    'approved'
),
(
    1604,
    '查找和最小的 K 对数字',
    '给定两个升序整数数组 nums1 和 nums2，以及整数 k
从两个数组中各取一个元素组成数对 (nums1[i], nums2[j])
返回和最小的 k 个数对
结果按数对和升序排列；和相同时先按 i 升序、再按 j 升序排列',
    'medium',
    1000,
    256,
    ARRAY['数组', '堆', '排序'],
    $json$[
  {
    "input": "nums1 = [1, 7, 11], nums2 = [2, 4, 6], k = 3",
    "output": "[[1, 2], [1, 4], [1, 6]]"
  },
  {
    "input": "nums1 = [1, 1, 2], nums2 = [1, 2, 3], k = 2",
    "output": "[[1, 1], [1, 1]]"
  },
  {
    "input": "nums1 = [1, 2], nums2 = [3, 4], k = 3",
    "output": "[[1, 3], [1, 4], [2, 3]]"
  },
  {
    "input": "nums1 = [1, 2, 3], nums2 = [1, 1, 1], k = 4",
    "output": "[[1, 1], [1, 1], [1, 1], [2, 1]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums1 = [1, 7, 11], nums2 = [2, 4, 6], k = 3",
    "output": "[[1, 2], [1, 4], [1, 6]]"
  },
  {
    "input": "nums1 = [1, 1, 2], nums2 = [1, 2, 3], k = 2",
    "output": "[[1, 1], [1, 1]]"
  },
  {
    "input": "nums1 = [1, 2], nums2 = [3, 4], k = 3",
    "output": "[[1, 3], [1, 4], [2, 3]]"
  },
  {
    "input": "nums1 = [1, 2, 3], nums2 = [1, 1, 1], k = 4",
    "output": "[[1, 1], [1, 1], [1, 1], [2, 1]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var kSmallestPairs = function(nums1, nums2, k) {\n};\n",
  "python": "class Solution:\n    def kSmallestPairs(self, nums1: list[int], nums2: list[int], k: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> kSmallestPairs(std::vector<int>& nums1, std::vector<int>& nums2, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] kSmallestPairs(int[] nums1, int[] nums2, int k) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kSmallestPairs",
  "params": [
    {
      "name": "nums1",
      "type": "int[]"
    },
    {
      "name": "nums2",
      "type": "int[]"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "int[][]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          7,
          11
        ],
        [
          2,
          4,
          6
        ],
        3
      ],
      "expected": [
        [
          1,
          2
        ],
        [
          1,
          4
        ],
        [
          1,
          6
        ]
      ]
    },
    {
      "args": [
        [
          1,
          1,
          2
        ],
        [
          1,
          2,
          3
        ],
        2
      ],
      "expected": [
        [
          1,
          1
        ],
        [
          1,
          1
        ]
      ]
    },
    {
      "args": [
        [
          1,
          2
        ],
        [
          3,
          4
        ],
        3
      ],
      "expected": [
        [
          1,
          3
        ],
        [
          1,
          4
        ],
        [
          2,
          3
        ]
      ]
    },
    {
      "args": [
        [
          1,
          2,
          3
        ],
        [
          1,
          1,
          1
        ],
        4
      ],
      "expected": [
        [
          1,
          1
        ],
        [
          1,
          1
        ],
        [
          1,
          1
        ],
        [
          2,
          1
        ]
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ],
      [
        1
      ],
      1
    ],
    "expected": [
      [
        1,
        1
      ]
    ]
  },
  {
    "args": [
      [
        1,
        3,
        5
      ],
      [
        2,
        4,
        6
      ],
      4
    ],
    "expected": [
      [
        1,
        2
      ],
      [
        1,
        4
      ],
      [
        3,
        2
      ],
      [
        1,
        6
      ]
    ]
  },
  {
    "args": [
      [
        -5,
        -3,
        -1
      ],
      [
        -2,
        0,
        2
      ],
      3
    ],
    "expected": [
      [
        -5,
        -2
      ],
      [
        -5,
        0
      ],
      [
        -3,
        -2
      ]
    ]
  },
  {
    "args": [
      [
        1,
        2
      ],
      [
        3,
        4,
        5
      ],
      6
    ],
    "expected": [
      [
        1,
        3
      ],
      [
        1,
        4
      ],
      [
        2,
        3
      ],
      [
        1,
        5
      ],
      [
        2,
        4
      ],
      [
        2,
        5
      ]
    ]
  },
  {
    "args": [
      [
        2,
        3
      ],
      [
        1
      ],
      2
    ],
    "expected": [
      [
        2,
        1
      ],
      [
        3,
        1
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1605,
    '分割数组为连续子序列',
    '给定升序排列的整数数组 nums
判断能否把数组分割成一个或多个长度至少为 3 的连续子序列
每个元素必须且只能属于一个子序列
若可以返回 true，否则返回 false',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表', '贪心'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 3, 4, 5]",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3, 3, 4, 4, 5, 5]",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3, 4, 4, 5]",
    "output": "false"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 3, 4, 5]",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3, 3, 4, 4, 5, 5]",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3, 4, 4, 5]",
    "output": "false"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isPossible = function(nums) {\n};\n",
  "python": "class Solution:\n    def isPossible(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isPossible(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isPossible(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isPossible",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3,
          3,
          4,
          5
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          2,
          3,
          3,
          4,
          4,
          5,
          5
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4,
          4,
          5
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          1,
          2,
          3
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        2,
        3,
        5,
        6,
        7
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        3,
        3,
        4,
        5,
        6,
        7
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        1,
        2,
        2,
        3,
        3
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1606,
    '回旋镖的数量',
    '给定平面上 n 个不同的点 points，其中 points[i] = [x_i, y_i]
回旋镖是满足 i、j、k 互不相同且 dist(i, j) == dist(i, k) 的有序三元组 (i, j, k)
返回回旋镖的数量',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表', '数学'],
    $json$[
  {
    "input": "points = [[0, 0], [1, 0], [2, 0]]",
    "output": "2"
  },
  {
    "input": "points = [[1, 1]]",
    "output": "0"
  },
  {
    "input": "points = [[1, 1], [2, 2], [3, 3]]",
    "output": "2"
  },
  {
    "input": "points = [[0, 0], [1, 0], [0, 1]]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "points = [[0, 0], [1, 0], [2, 0]]",
    "output": "2"
  },
  {
    "input": "points = [[1, 1]]",
    "output": "0"
  },
  {
    "input": "points = [[1, 1], [2, 2], [3, 3]]",
    "output": "2"
  },
  {
    "input": "points = [[0, 0], [1, 0], [0, 1]]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numberOfBoomerangs = function(points) {\n};\n",
  "python": "class Solution:\n    def numberOfBoomerangs(self, points: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numberOfBoomerangs(std::vector<std::vector<int>>& points) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numberOfBoomerangs(int[][] points) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numberOfBoomerangs",
  "params": [
    {
      "name": "points",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            0,
            0
          ],
          [
            1,
            0
          ],
          [
            2,
            0
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            1,
            1
          ]
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          [
            1,
            1
          ],
          [
            2,
            2
          ],
          [
            3,
            3
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            0,
            0
          ],
          [
            1,
            0
          ],
          [
            0,
            1
          ]
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          0,
          0
        ],
        [
          1,
          0
        ],
        [
          -1,
          0
        ],
        [
          0,
          1
        ],
        [
          0,
          -1
        ]
      ]
    ],
    "expected": 20
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          2,
          1
        ],
        [
          0,
          0
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          3,
          3
        ],
        [
          3,
          4
        ],
        [
          3,
          5
        ],
        [
          4,
          3
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          0,
          0
        ],
        [
          0,
          1
        ],
        [
          0,
          2
        ],
        [
          0,
          3
        ]
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1607,
    '比较版本号',
    '给定两个版本号字符串 version1 和 version2
版本号由若干以点分隔的修订号组成，每个修订号可包含前导零
按从左到右的顺序逐个比较修订号，缺少的修订号视为 0
若 version1 小于 version2 返回 -1，相等返回 0，大于返回 1',
    'medium',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "version1 = \"1.01\", version2 = \"1.001\"",
    "output": "0"
  },
  {
    "input": "version1 = \"1.0\", version2 = \"1.0.0\"",
    "output": "0"
  },
  {
    "input": "version1 = \"0.1\", version2 = \"1.1\"",
    "output": "-1"
  },
  {
    "input": "version1 = \"1.0.1\", version2 = \"1\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "version1 = \"1.01\", version2 = \"1.001\"",
    "output": "0"
  },
  {
    "input": "version1 = \"1.0\", version2 = \"1.0.0\"",
    "output": "0"
  },
  {
    "input": "version1 = \"0.1\", version2 = \"1.1\"",
    "output": "-1"
  },
  {
    "input": "version1 = \"1.0.1\", version2 = \"1\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var compareVersion = function(version1, version2) {\n};\n",
  "python": "class Solution:\n    def compareVersion(self, version1: str, version2: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int compareVersion(std::string version1, std::string version2) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int compareVersion(String version1, String version2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "compareVersion",
  "params": [
    {
      "name": "version1",
      "type": "string"
    },
    {
      "name": "version2",
      "type": "string"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "1.01",
        "1.001"
      ],
      "expected": 0
    },
    {
      "args": [
        "1.0",
        "1.0.0"
      ],
      "expected": 0
    },
    {
      "args": [
        "0.1",
        "1.1"
      ],
      "expected": -1
    },
    {
      "args": [
        "1.0.1",
        "1"
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "7.5.2.4",
      "7.5.2.4"
    ],
    "expected": 0
  },
  {
    "args": [
      "1.2",
      "1.10"
    ],
    "expected": -1
  },
  {
    "args": [
      "1.0.0.0.1",
      "1"
    ],
    "expected": 1
  },
  {
    "args": [
      "0.0.0",
      "0"
    ],
    "expected": 0
  },
  {
    "args": [
      "10",
      "9.9"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1608,
    '验证 IP 地址',
    '给定字符串 queryIP
若它是有效的 IPv4 地址返回 IPv4，若是有效的 IPv6 地址返回 IPv6，否则返回 Neither
IPv4 由四个 0 到 255 的十进制数组成，用点分隔，不能有前导零
IPv6 由八组 1 到 4 位十六进制数组成，用冒号分隔，允许前导零，不区分大小写',
    'medium',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "queryIP = \"172.16.254.1\"",
    "output": "\"IPv4\""
  },
  {
    "input": "queryIP = \"2001:0db8:85a3:0000:0000:8a2e:0370:7334\"",
    "output": "\"IPv6\""
  },
  {
    "input": "queryIP = \"256.256.256.256\"",
    "output": "\"Neither\""
  },
  {
    "input": "queryIP = \"02001:0db8:85a3:0000:0000:8a2e:0370:7334\"",
    "output": "\"Neither\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "queryIP = \"172.16.254.1\"",
    "output": "\"IPv4\""
  },
  {
    "input": "queryIP = \"2001:0db8:85a3:0000:0000:8a2e:0370:7334\"",
    "output": "\"IPv6\""
  },
  {
    "input": "queryIP = \"256.256.256.256\"",
    "output": "\"Neither\""
  },
  {
    "input": "queryIP = \"02001:0db8:85a3:0000:0000:8a2e:0370:7334\"",
    "output": "\"Neither\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var validIPAddress = function(queryIP) {\n};\n",
  "python": "class Solution:\n    def validIPAddress(self, queryIP: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string validIPAddress(std::string queryIP) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String validIPAddress(String queryIP) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "validIPAddress",
  "params": [
    {
      "name": "queryIP",
      "type": "string"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "172.16.254.1"
      ],
      "expected": "IPv4"
    },
    {
      "args": [
        "2001:0db8:85a3:0000:0000:8a2e:0370:7334"
      ],
      "expected": "IPv6"
    },
    {
      "args": [
        "256.256.256.256"
      ],
      "expected": "Neither"
    },
    {
      "args": [
        "02001:0db8:85a3:0000:0000:8a2e:0370:7334"
      ],
      "expected": "Neither"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "1.1.1.1."
    ],
    "expected": "Neither"
  },
  {
    "args": [
      "2001:db8:85a3:0:0:8A2E:0370:7334"
    ],
    "expected": "IPv6"
  },
  {
    "args": [
      "1e1.4.5.6"
    ],
    "expected": "Neither"
  },
  {
    "args": [
      "192.168.01.1"
    ],
    "expected": "Neither"
  },
  {
    "args": [
      "2001:db8:85a3::8a2e:0370:7334"
    ],
    "expected": "Neither"
  },
  {
    "args": [
      "0.0.0.0"
    ],
    "expected": "IPv4"
  }
]$json$::jsonb,
    'approved'
),
(
    1609,
    '反转字符串中的单词',
    '给定字符串 s，其中包含由空格分隔的若干单词
反转单词的顺序，单词内部字符顺序保持不变
返回结果字符串，单词之间只保留一个空格，且不含首尾空格',
    'medium',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "s = \"the sky is blue\"",
    "output": "\"blue is sky the\""
  },
  {
    "input": "s = \"  hello world  \"",
    "output": "\"world hello\""
  },
  {
    "input": "s = \"a good   example\"",
    "output": "\"example good a\""
  },
  {
    "input": "s = \"  Bob    Loves  Alice   \"",
    "output": "\"Alice Loves Bob\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"the sky is blue\"",
    "output": "\"blue is sky the\""
  },
  {
    "input": "s = \"  hello world  \"",
    "output": "\"world hello\""
  },
  {
    "input": "s = \"a good   example\"",
    "output": "\"example good a\""
  },
  {
    "input": "s = \"  Bob    Loves  Alice   \"",
    "output": "\"Alice Loves Bob\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var reverseWords = function(s) {\n};\n",
  "python": "class Solution:\n    def reverseWords(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string reverseWords(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String reverseWords(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reverseWords",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "the sky is blue"
      ],
      "expected": "blue is sky the"
    },
    {
      "args": [
        "  hello world  "
      ],
      "expected": "world hello"
    },
    {
      "args": [
        "a good   example"
      ],
      "expected": "example good a"
    },
    {
      "args": [
        "  Bob    Loves  Alice   "
      ],
      "expected": "Alice Loves Bob"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "Alice does not even like bob"
    ],
    "expected": "bob like even not does Alice"
  },
  {
    "args": [
      "one"
    ],
    "expected": "one"
  },
  {
    "args": [
      "   "
    ],
    "expected": ""
  },
  {
    "args": [
      "hello"
    ],
    "expected": "hello"
  },
  {
    "args": [
      "  a  b  c  "
    ],
    "expected": "c b a"
  }
]$json$::jsonb,
    'approved'
),
(
    1610,
    '最长特殊序列 II',
    '给定字符串数组 strs
最长特殊序列定义为某个字符串中最长的、且不是其余任何字符串子序列的子序列
若不存在这样的序列返回 -1，否则返回该最长特殊序列的长度',
    'medium',
    1000,
    256,
    ARRAY['字符串', '排序'],
    $json$[
  {
    "input": "strs = [\"aba\", \"cdc\", \"eae\"]",
    "output": "3"
  },
  {
    "input": "strs = [\"aaa\", \"aaa\", \"aa\"]",
    "output": "-1"
  },
  {
    "input": "strs = [\"aabbcc\", \"aabbcc\", \"cb\", \"abc\"]",
    "output": "2"
  },
  {
    "input": "strs = [\"a\", \"b\", \"c\"]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "strs = [\"aba\", \"cdc\", \"eae\"]",
    "output": "3"
  },
  {
    "input": "strs = [\"aaa\", \"aaa\", \"aa\"]",
    "output": "-1"
  },
  {
    "input": "strs = [\"aabbcc\", \"aabbcc\", \"cb\", \"abc\"]",
    "output": "2"
  },
  {
    "input": "strs = [\"a\", \"b\", \"c\"]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findLUSlength = function(strs) {\n};\n",
  "python": "class Solution:\n    def findLUSlength(self, strs: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findLUSlength(std::vector<std::string>& strs) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findLUSlength(String[] strs) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findLUSlength",
  "params": [
    {
      "name": "strs",
      "type": "string[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "aba",
          "cdc",
          "eae"
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          "aaa",
          "aaa",
          "aa"
        ]
      ],
      "expected": -1
    },
    {
      "args": [
        [
          "aabbcc",
          "aabbcc",
          "cb",
          "abc"
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          "a",
          "b",
          "c"
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "a"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "a",
        "aa",
        "aaa"
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        "abc",
        "abc",
        "ab"
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        "abcd",
        "ab",
        "abc"
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        "aaa",
        "bbb",
        "ccc"
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1611,
    '通过删除字母匹配到字典里最长单词',
    '给定字符串 s 和字符串数组 dictionary
找出 dictionary 中最长的字符串，使得它可以通过删除 s 中的一些字符得到
若有多个长度相同的答案，返回字典序最小的那个
若不存在则返回空字符串',
    'medium',
    1000,
    256,
    ARRAY['字符串', '双指针', '排序'],
    $json$[
  {
    "input": "s = \"abpcplea\", dictionary = [\"ale\", \"apple\", \"monkey\", \"plea\"]",
    "output": "\"apple\""
  },
  {
    "input": "s = \"abpcplea\", dictionary = [\"a\", \"b\", \"c\"]",
    "output": "\"a\""
  },
  {
    "input": "s = \"bab\", dictionary = [\"ba\", \"ab\", \"a\", \"b\"]",
    "output": "\"ab\""
  },
  {
    "input": "s = \"aaa\", dictionary = [\"aaa\", \"aa\", \"a\"]",
    "output": "\"aaa\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abpcplea\", dictionary = [\"ale\", \"apple\", \"monkey\", \"plea\"]",
    "output": "\"apple\""
  },
  {
    "input": "s = \"abpcplea\", dictionary = [\"a\", \"b\", \"c\"]",
    "output": "\"a\""
  },
  {
    "input": "s = \"bab\", dictionary = [\"ba\", \"ab\", \"a\", \"b\"]",
    "output": "\"ab\""
  },
  {
    "input": "s = \"aaa\", dictionary = [\"aaa\", \"aa\", \"a\"]",
    "output": "\"aaa\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var findLongestWord = function(s, dictionary) {\n};\n",
  "python": "class Solution:\n    def findLongestWord(self, s: str, dictionary: list[str]) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string findLongestWord(std::string s, std::vector<std::string>& dictionary) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String findLongestWord(String s, String[] dictionary) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findLongestWord",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "dictionary",
      "type": "string[]"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "abpcplea",
        [
          "ale",
          "apple",
          "monkey",
          "plea"
        ]
      ],
      "expected": "apple"
    },
    {
      "args": [
        "abpcplea",
        [
          "a",
          "b",
          "c"
        ]
      ],
      "expected": "a"
    },
    {
      "args": [
        "bab",
        [
          "ba",
          "ab",
          "a",
          "b"
        ]
      ],
      "expected": "ab"
    },
    {
      "args": [
        "aaa",
        [
          "aaa",
          "aa",
          "a"
        ]
      ],
      "expected": "aaa"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abc",
      [
        "def"
      ]
    ],
    "expected": ""
  },
  {
    "args": [
      "apple",
      [
        "z",
        "y",
        "x"
      ]
    ],
    "expected": ""
  },
  {
    "args": [
      "ab",
      [
        "a",
        "b",
        "ab"
      ]
    ],
    "expected": "ab"
  },
  {
    "args": [
      "abcd",
      [
        "ab",
        "abc",
        "bc",
        "bcd"
      ]
    ],
    "expected": "abc"
  },
  {
    "args": [
      "xyz",
      [
        "x",
        "y",
        "z"
      ]
    ],
    "expected": "x"
  }
]$json$::jsonb,
    'approved'
),
(
    1612,
    '复数乘法',
    '给定两个表示复数的字符串 num1 和 num2，格式为 a+bi
其中 a 和 b 是整数，i 表示虚数单位
计算两个复数的乘积，并按 a+bi 的格式返回结果',
    'medium',
    1000,
    256,
    ARRAY['字符串', '数学'],
    $json$[
  {
    "input": "num1 = \"1+1i\", num2 = \"1+1i\"",
    "output": "\"0+2i\""
  },
  {
    "input": "num1 = \"1+-1i\", num2 = \"1+-1i\"",
    "output": "\"0+-2i\""
  },
  {
    "input": "num1 = \"1+0i\", num2 = \"1+0i\"",
    "output": "\"1+0i\""
  },
  {
    "input": "num1 = \"2+3i\", num2 = \"4+5i\"",
    "output": "\"-7+22i\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num1 = \"1+1i\", num2 = \"1+1i\"",
    "output": "\"0+2i\""
  },
  {
    "input": "num1 = \"1+-1i\", num2 = \"1+-1i\"",
    "output": "\"0+-2i\""
  },
  {
    "input": "num1 = \"1+0i\", num2 = \"1+0i\"",
    "output": "\"1+0i\""
  },
  {
    "input": "num1 = \"2+3i\", num2 = \"4+5i\"",
    "output": "\"-7+22i\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var complexNumberMultiply = function(num1, num2) {\n};\n",
  "python": "class Solution:\n    def complexNumberMultiply(self, num1: str, num2: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string complexNumberMultiply(std::string num1, std::string num2) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String complexNumberMultiply(String num1, String num2) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "complexNumberMultiply",
  "params": [
    {
      "name": "num1",
      "type": "string"
    },
    {
      "name": "num2",
      "type": "string"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "1+1i",
        "1+1i"
      ],
      "expected": "0+2i"
    },
    {
      "args": [
        "1+-1i",
        "1+-1i"
      ],
      "expected": "0+-2i"
    },
    {
      "args": [
        "1+0i",
        "1+0i"
      ],
      "expected": "1+0i"
    },
    {
      "args": [
        "2+3i",
        "4+5i"
      ],
      "expected": "-7+22i"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "0+0i",
      "5+7i"
    ],
    "expected": "0+0i"
  },
  {
    "args": [
      "-1+-2i",
      "3+4i"
    ],
    "expected": "5+-10i"
  },
  {
    "args": [
      "3+-2i",
      "1+1i"
    ],
    "expected": "5+1i"
  },
  {
    "args": [
      "-5+0i",
      "-5+0i"
    ],
    "expected": "25+0i"
  },
  {
    "args": [
      "10+-10i",
      "10+10i"
    ],
    "expected": "200+0i"
  }
]$json$::jsonb,
    'approved'
),
(
    1613,
    '文件的最长绝对路径',
    '给定字符串 input 表示文件系统的目录结构
字符串中换行符 \n 分隔不同层级，制表符 \t 表示目录深度
文件名包含点号，目录名不包含点号
返回文件系统中文件绝对路径的最大长度，若没有文件则返回 0
路径长度不包含文件名前的制表符和换行符',
    'medium',
    1000,
    256,
    ARRAY['字符串', '栈'],
    $json$[
  {
    "input": "input = \"dir\\n\\tsubdir1\\n\\tsubdir2\\n\\t\\tfile.ext\"",
    "output": "20"
  },
  {
    "input": "input = \"dir\\n\\tsubdir1\\n\\t\\tfile1.ext\\n\\t\\t\\tsubsubdir1\\n\\tsubdir2\\n\\t\\t\\tsubsubdir2\\n\\t\\t\\t\\tfile2.ext\"",
    "output": "32"
  },
  {
    "input": "input = \"a\"",
    "output": "0"
  },
  {
    "input": "input = \"file1.txt\\nfile2.txt\"",
    "output": "9"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "input = \"dir\\n\\tsubdir1\\n\\tsubdir2\\n\\t\\tfile.ext\"",
    "output": "20"
  },
  {
    "input": "input = \"dir\\n\\tsubdir1\\n\\t\\tfile1.ext\\n\\t\\t\\tsubsubdir1\\n\\tsubdir2\\n\\t\\t\\tsubsubdir2\\n\\t\\t\\t\\tfile2.ext\"",
    "output": "32"
  },
  {
    "input": "input = \"a\"",
    "output": "0"
  },
  {
    "input": "input = \"file1.txt\\nfile2.txt\"",
    "output": "9"
  }
]$json$::jsonb,
    $json${
  "javascript": "var lengthLongestPath = function(input) {\n};\n",
  "python": "class Solution:\n    def lengthLongestPath(self, input: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int lengthLongestPath(std::string input) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int lengthLongestPath(String input) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "lengthLongestPath",
  "params": [
    {
      "name": "input",
      "type": "string"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "dir\n\tsubdir1\n\tsubdir2\n\t\tfile.ext"
      ],
      "expected": 20
    },
    {
      "args": [
        "dir\n\tsubdir1\n\t\tfile1.ext\n\t\t\tsubsubdir1\n\tsubdir2\n\t\t\tsubsubdir2\n\t\t\t\tfile2.ext"
      ],
      "expected": 32
    },
    {
      "args": [
        "a"
      ],
      "expected": 0
    },
    {
      "args": [
        "file1.txt\nfile2.txt"
      ],
      "expected": 9
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "dir\n\ta"
    ],
    "expected": 0
  },
  {
    "args": [
      "dir\n\tfile.txt"
    ],
    "expected": 12
  },
  {
    "args": [
      "a\n\tb\n\t\tc.txt"
    ],
    "expected": 9
  },
  {
    "args": [
      "dir\n\tsubdir\n\t\tfile.txt"
    ],
    "expected": 19
  },
  {
    "args": [
      "a.b.c"
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1614,
    '从英文中重建数字',
    '给定字符串 s，它由若干英文数字单词的字母打乱顺序后拼接而成
英文数字单词为 zero、one、two、three、four、five、six、seven、eight、nine
还原这些数字并按升序拼接成字符串返回',
    'medium',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "s = \"owoztneoer\"",
    "output": "\"012\""
  },
  {
    "input": "s = \"fviefuro\"",
    "output": "\"45\""
  },
  {
    "input": "s = \"zerozero\"",
    "output": "\"00\""
  },
  {
    "input": "s = \"nine\"",
    "output": "\"9\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"owoztneoer\"",
    "output": "\"012\""
  },
  {
    "input": "s = \"fviefuro\"",
    "output": "\"45\""
  },
  {
    "input": "s = \"zerozero\"",
    "output": "\"00\""
  },
  {
    "input": "s = \"nine\"",
    "output": "\"9\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var originalDigits = function(s) {\n};\n",
  "python": "class Solution:\n    def originalDigits(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string originalDigits(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String originalDigits(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "originalDigits",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "owoztneoer"
      ],
      "expected": "012"
    },
    {
      "args": [
        "fviefuro"
      ],
      "expected": "45"
    },
    {
      "args": [
        "zerozero"
      ],
      "expected": "00"
    },
    {
      "args": [
        "nine"
      ],
      "expected": "9"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "zeroonetwothreefourfivesixseveneightnine"
    ],
    "expected": "0123456789"
  },
  {
    "args": [
      "oneone"
    ],
    "expected": "11"
  },
  {
    "args": [
      "sixseven"
    ],
    "expected": "67"
  },
  {
    "args": [
      "fivefourthree"
    ],
    "expected": "345"
  },
  {
    "args": [
      "eight"
    ],
    "expected": "8"
  }
]$json$::jsonb,
    'approved'
),
(
    1615,
    'UTF-8 编码验证',
    '给定整数数组 data 表示若干字节
判断这些字节是否构成合法的 UTF-8 编码
UTF-8 字符长度可以是 1 到 4 字节，后续字节必须以 10 开头
若编码合法返回 true，否则返回 false',
    'medium',
    1000,
    256,
    ARRAY['数组', '位运算'],
    $json$[
  {
    "input": "data = [197, 130, 1]",
    "output": "true"
  },
  {
    "input": "data = [235, 140, 4]",
    "output": "false"
  },
  {
    "input": "data = [10]",
    "output": "true"
  },
  {
    "input": "data = [240, 162, 138, 147]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "data = [197, 130, 1]",
    "output": "true"
  },
  {
    "input": "data = [235, 140, 4]",
    "output": "false"
  },
  {
    "input": "data = [10]",
    "output": "true"
  },
  {
    "input": "data = [240, 162, 138, 147]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var validUtf8 = function(data) {\n};\n",
  "python": "class Solution:\n    def validUtf8(self, data: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool validUtf8(std::vector<int>& data) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean validUtf8(int[] data) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "validUtf8",
  "params": [
    {
      "name": "data",
      "type": "int[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          197,
          130,
          1
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          235,
          140,
          4
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          10
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          240,
          162,
          138,
          147
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        255
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        145
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        248,
        130,
        130,
        130
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        194,
        155
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        240,
        162,
        138
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        0
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1616,
    '第 N 位数字',
    '将正整数按顺序拼接成无限序列 123456789101112...
给定整数 n，返回这个序列中第 n 位数字
n 从 1 开始计数',
    'medium',
    1000,
    256,
    ARRAY['数学', '二分查找'],
    $json$[
  {
    "input": "n = 3",
    "output": "3"
  },
  {
    "input": "n = 11",
    "output": "0"
  },
  {
    "input": "n = 12",
    "output": "1"
  },
  {
    "input": "n = 100",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3",
    "output": "3"
  },
  {
    "input": "n = 11",
    "output": "0"
  },
  {
    "input": "n = 12",
    "output": "1"
  },
  {
    "input": "n = 100",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findNthDigit = function(n) {\n};\n",
  "python": "class Solution:\n    def findNthDigit(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findNthDigit(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findNthDigit(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findNthDigit",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        3
      ],
      "expected": 3
    },
    {
      "args": [
        11
      ],
      "expected": 0
    },
    {
      "args": [
        12
      ],
      "expected": 1
    },
    {
      "args": [
        100
      ],
      "expected": 5
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1
    ],
    "expected": 1
  },
  {
    "args": [
      9
    ],
    "expected": 9
  },
  {
    "args": [
      10
    ],
    "expected": 1
  },
  {
    "args": [
      1000
    ],
    "expected": 3
  },
  {
    "args": [
      2147483647
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1617,
    '最大二叉树',
    '给定一个不含重复元素的整数数组 nums
按以下规则递归构建二叉树：根节点为数组中的最大值，最大值左侧的子数组递归构建左子树，右侧的子数组递归构建右子树
返回构建出的二叉树，用层序序列表示，末尾多余的 null 省略',
    'medium',
    1000,
    256,
    ARRAY['树', '递归', '分治'],
    $json$[
  {
    "input": "nums = [3, 2, 1, 6, 0, 5]",
    "output": "[6, 3, 5, null, 2, 0, null, null, 1]"
  },
  {
    "input": "nums = [3, 2, 1]",
    "output": "[3, null, 2, null, 1]"
  },
  {
    "input": "nums = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 2, 1, 6, 0, 5]",
    "output": "[6, 3, 5, null, 2, 0, null, null, 1]"
  },
  {
    "input": "nums = [3, 2, 1]",
    "output": "[3, null, 2, null, 1]"
  },
  {
    "input": "nums = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar constructMaximumBinaryTree = function(nums) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def constructMaximumBinaryTree(self, nums: list[int]) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* constructMaximumBinaryTree(std::vector<int>& nums) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode constructMaximumBinaryTree(int[] nums) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "constructMaximumBinaryTree",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "TreeNode",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          3,
          2,
          1,
          6,
          0,
          5
        ]
      ],
      "expected": [
        6,
        3,
        5,
        null,
        2,
        0,
        null,
        null,
        1
      ]
    },
    {
      "args": [
        [
          3,
          2,
          1
        ]
      ],
      "expected": [
        3,
        null,
        2,
        null,
        1
      ]
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": [
        1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        2,
        1,
        3
      ]
    ],
    "expected": [
      3,
      2,
      null,
      null,
      1
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ]
    ],
    "expected": [
      4,
      3,
      null,
      2,
      null,
      1
    ]
  },
  {
    "args": [
      [
        5,
        4,
        3,
        2,
        1
      ]
    ],
    "expected": [
      5,
      null,
      4,
      null,
      3,
      null,
      2,
      null,
      1
    ]
  },
  {
    "args": [
      [
        3,
        2,
        1,
        6,
        0,
        5,
        7
      ]
    ],
    "expected": [
      7,
      6,
      null,
      3,
      5,
      null,
      2,
      0,
      null,
      null,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1618,
    '最长同值路径',
    '给定二叉树的根节点 root，用层序列表表示，null 表示空节点
同值路径指路径上所有节点值相同，路径长度为经过的边数
路径不要求经过根节点，也不要求只向下延伸，可以在某个节点处连接左右两侧
返回最长的同值路径长度',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [5, 4, 5, 1, 1, null, 5]",
    "output": "2"
  },
  {
    "input": "root = [1, 4, 5, 4, 4, null, 5]",
    "output": "2"
  },
  {
    "input": "root = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [5, 4, 5, 1, 1, null, 5]",
    "output": "2"
  },
  {
    "input": "root = [1, 4, 5, 4, 4, null, 5]",
    "output": "2"
  },
  {
    "input": "root = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar longestUnivaluePath = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def longestUnivaluePath(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int longestUnivaluePath(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int longestUnivaluePath(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestUnivaluePath",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          5,
          4,
          5,
          1,
          1,
          null,
          5
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1,
          4,
          5,
          4,
          4,
          null,
          5
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        null,
        1,
        1,
        1,
        1,
        1,
        null,
        1
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        4,
        4,
        4,
        4,
        4
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        2,
        3
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1619,
    '二叉树剪枝',
    '给定二叉树的根节点 root，用层序列表表示，null 表示空节点
剪掉所有不包含 1 的子树，即删除所有节点值全为 0 的子树
返回剪枝后的二叉树，用层序序列表示',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [1, null, 0, 0, 1]",
    "output": "[1, null, 0, null, 1]"
  },
  {
    "input": "root = [1, 0, 1, 0, 0, 0, 1]",
    "output": "[1, null, 1, null, 1]"
  },
  {
    "input": "root = [1, 1, 0, 1, 1, 0, 1, 0]",
    "output": "[1, 1, 0, 1, 1, null, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, null, 0, 0, 1]",
    "output": "[1, null, 0, null, 1]"
  },
  {
    "input": "root = [1, 0, 1, 0, 0, 0, 1]",
    "output": "[1, null, 1, null, 1]"
  },
  {
    "input": "root = [1, 1, 0, 1, 1, 0, 1, 0]",
    "output": "[1, 1, 0, 1, 1, null, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar pruneTree = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def pruneTree(self, root: TreeNode | None) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* pruneTree(TreeNode* root) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode pruneTree(TreeNode root) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "pruneTree",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    }
  ],
  "return_type": "TreeNode",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          null,
          0,
          0,
          1
        ]
      ],
      "expected": [
        1,
        null,
        0,
        null,
        1
      ]
    },
    {
      "args": [
        [
          1,
          0,
          1,
          0,
          0,
          0,
          1
        ]
      ],
      "expected": [
        1,
        null,
        1,
        null,
        1
      ]
    },
    {
      "args": [
        [
          1,
          1,
          0,
          1,
          1,
          0,
          1,
          0
        ]
      ],
      "expected": [
        1,
        1,
        0,
        1,
        1,
        null,
        1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0
      ]
    ],
    "expected": []
  },
  {
    "args": [
      [
        1
      ]
    ],
    "expected": [
      1
    ]
  },
  {
    "args": [
      [
        0,
        0,
        0
      ]
    ],
    "expected": []
  },
  {
    "args": [
      [
        1,
        0,
        0,
        null,
        0,
        0,
        null
      ]
    ],
    "expected": [
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1620,
    '二叉树的完全性检验',
    '给定二叉树的根节点 root，用层序列表表示，null 表示空节点
完全二叉树要求除最后一层外每一层都填满，且最后一层的节点都连续集中在最左边
判断该树是否为完全二叉树',
    'medium',
    1000,
    256,
    ARRAY['树', '广度优先搜索'],
    $json$[
  {
    "input": "root = [1, 2, 3, 4, 5, 6]",
    "output": "true"
  },
  {
    "input": "root = [1, 2, 3, 4, 5, null, 7]",
    "output": "false"
  },
  {
    "input": "root = [1]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3, 4, 5, 6]",
    "output": "true"
  },
  {
    "input": "root = [1, 2, 3, 4, 5, null, 7]",
    "output": "false"
  },
  {
    "input": "root = [1]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar isCompleteTree = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def isCompleteTree(self, root: TreeNode | None) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool isCompleteTree(TreeNode* root) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean isCompleteTree(TreeNode root) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isCompleteTree",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3,
          4,
          5,
          6
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4,
          5,
          null,
          7
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5,
        6,
        7
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        null,
        3
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        null,
        2,
        3
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1621,
    '在二叉树中分配硬币',
    '给定二叉树的根节点 root，节点值表示该节点上的硬币数，硬币总数为节点总数
每次操作可以把一枚硬币从某个节点移动到相邻的父节点或子节点
返回使每个节点恰好有一枚硬币所需的最少移动次数',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [3, 0, 0]",
    "output": "2"
  },
  {
    "input": "root = [0, 3, 0]",
    "output": "3"
  },
  {
    "input": "root = [1, 0, 2]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 0, 0]",
    "output": "2"
  },
  {
    "input": "root = [0, 3, 0]",
    "output": "3"
  },
  {
    "input": "root = [1, 0, 2]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar distributeCoins = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def distributeCoins(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int distributeCoins(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int distributeCoins(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "distributeCoins",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          3,
          0,
          0
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          0,
          3,
          0
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          1,
          0,
          2
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        0,
        0,
        null,
        3
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        2,
        1,
        0
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        2,
        1,
        2,
        0,
        0
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        3,
        1,
        1,
        0,
        0,
        0,
        0
      ]
    ],
    "expected": 8
  }
]$json$::jsonb,
    'approved'
),
(
    1622,
    '前序遍历构造二叉搜索树',
    '给定一棵二叉搜索树的前序遍历结果 preorder，节点值互不相同
请根据该遍历结果重构二叉搜索树并返回
返回的树用层序序列表示，末尾多余的 null 省略',
    'medium',
    1000,
    256,
    ARRAY['树', '二叉搜索树', '递归'],
    $json$[
  {
    "input": "preorder = [8, 5, 1, 7, 10, 12]",
    "output": "[8, 5, 10, 1, 7, null, 12]"
  },
  {
    "input": "preorder = [1, 3]",
    "output": "[1, null, 3]"
  },
  {
    "input": "preorder = [4, 2, 1, 3]",
    "output": "[4, 2, null, 1, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "preorder = [8, 5, 1, 7, 10, 12]",
    "output": "[8, 5, 10, 1, 7, null, 12]"
  },
  {
    "input": "preorder = [1, 3]",
    "output": "[1, null, 3]"
  },
  {
    "input": "preorder = [4, 2, 1, 3]",
    "output": "[4, 2, null, 1, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar bstFromPreorder = function(preorder) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def bstFromPreorder(self, preorder: list[int]) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* bstFromPreorder(std::vector<int>& preorder) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode bstFromPreorder(int[] preorder) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "bstFromPreorder",
  "params": [
    {
      "name": "preorder",
      "type": "int[]"
    }
  ],
  "return_type": "TreeNode",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          8,
          5,
          1,
          7,
          10,
          12
        ]
      ],
      "expected": [
        8,
        5,
        10,
        1,
        7,
        null,
        12
      ]
    },
    {
      "args": [
        [
          1,
          3
        ]
      ],
      "expected": [
        1,
        null,
        3
      ]
    },
    {
      "args": [
        [
          4,
          2,
          1,
          3
        ]
      ],
      "expected": [
        4,
        2,
        null,
        1,
        3
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        2,
        1,
        3
      ]
    ],
    "expected": [
      2,
      1,
      3
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ]
    ],
    "expected": [
      1,
      null,
      2,
      null,
      3,
      null,
      4,
      null,
      5
    ]
  },
  {
    "args": [
      [
        5,
        3,
        2,
        4,
        8,
        7,
        9
      ]
    ],
    "expected": [
      5,
      3,
      8,
      2,
      4,
      7,
      9
    ]
  },
  {
    "args": [
      [
        10,
        5,
        1,
        7,
        40,
        50
      ]
    ],
    "expected": [
      10,
      5,
      40,
      1,
      7,
      null,
      50
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1623,
    '最大层内元素和',
    '给定二叉树的根节点 root，用层序列表表示，null 表示空节点
根节点所在层为第 1 层，返回元素和最大的层号
若有多层元素和并列最大，返回层号较小的那一层',
    'medium',
    1000,
    256,
    ARRAY['树', '广度优先搜索'],
    $json$[
  {
    "input": "root = [1, 7, 0, 7, -8, null, null]",
    "output": "2"
  },
  {
    "input": "root = [989, null, 10250, 98693, -89388, null, null, null, -32127]",
    "output": "2"
  },
  {
    "input": "root = [1, 2, null]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 7, 0, 7, -8, null, null]",
    "output": "2"
  },
  {
    "input": "root = [989, null, 10250, 98693, -89388, null, null, null, -32127]",
    "output": "2"
  },
  {
    "input": "root = [1, 2, null]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar maxLevelSum = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def maxLevelSum(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int maxLevelSum(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int maxLevelSum(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxLevelSum",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          7,
          0,
          7,
          -8,
          null,
          null
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          989,
          null,
          10250,
          98693,
          -89388,
          null,
          null,
          null,
          -32127
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1,
          2,
          null
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2,
        3
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        -1,
        -2,
        -3,
        -4,
        -5
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        5,
        4,
        8,
        11,
        null,
        13,
        4,
        7,
        2,
        null,
        null,
        null,
        1
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1624,
    '统计二叉树中好节点的数目',
    '给定二叉树的根节点 root，用层序列表表示，null 表示空节点
好节点定义为：从根节点到该节点路径上不存在值严格大于该节点值的节点
返回好节点的数目',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [3, 1, 4, 3, null, 1, 5]",
    "output": "4"
  },
  {
    "input": "root = [3, 3, null, 4, 2]",
    "output": "3"
  },
  {
    "input": "root = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 1, 4, 3, null, 1, 5]",
    "output": "4"
  },
  {
    "input": "root = [3, 3, null, 4, 2]",
    "output": "3"
  },
  {
    "input": "root = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar goodNodes = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def goodNodes(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int goodNodes(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int goodNodes(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "goodNodes",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          3,
          1,
          4,
          3,
          null,
          1,
          5
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          3,
          3,
          null,
          4,
          2
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        2,
        null,
        4,
        10,
        8,
        null,
        null,
        4
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        9,
        null,
        3,
        6
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2,
        3
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        5,
        4,
        3,
        2,
        1
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1625,
    '所有可能的路径',
    '给定一个有 n 个节点的有向无环图，节点编号为 0 到 n-1
graph[i] 是节点 i 的所有出边终点列表
返回所有从节点 0 到节点 n-1 的路径
每条路径按经过的节点顺序排列，所有路径按字典序升序排列',
    'medium',
    1000,
    256,
    ARRAY['图', '深度优先搜索', '回溯'],
    $json$[
  {
    "input": "graph = [[1, 2], [3], [3], []]",
    "output": "[[0, 1, 3], [0, 2, 3]]"
  },
  {
    "input": "graph = [[4, 3, 1], [3, 2, 4], [3], [4], []]",
    "output": "[[0, 1, 2, 3, 4], [0, 1, 3, 4], [0, 1, 4], [0, 3, 4], [0, 4]]"
  },
  {
    "input": "graph = [[1], []]",
    "output": "[[0, 1]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "graph = [[1, 2], [3], [3], []]",
    "output": "[[0, 1, 3], [0, 2, 3]]"
  },
  {
    "input": "graph = [[4, 3, 1], [3, 2, 4], [3], [4], []]",
    "output": "[[0, 1, 2, 3, 4], [0, 1, 3, 4], [0, 1, 4], [0, 3, 4], [0, 4]]"
  },
  {
    "input": "graph = [[1], []]",
    "output": "[[0, 1]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var allPathsSourceTarget = function(graph) {\n};\n",
  "python": "class Solution:\n    def allPathsSourceTarget(self, graph: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> allPathsSourceTarget(std::vector<std::vector<int>>& graph) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] allPathsSourceTarget(int[][] graph) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "allPathsSourceTarget",
  "params": [
    {
      "name": "graph",
      "type": "int[][]"
    }
  ],
  "return_type": "int[][]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            3
          ],
          [
            3
          ],
          []
        ]
      ],
      "expected": [
        [
          0,
          1,
          3
        ],
        [
          0,
          2,
          3
        ]
      ]
    },
    {
      "args": [
        [
          [
            4,
            3,
            1
          ],
          [
            3,
            2,
            4
          ],
          [
            3
          ],
          [
            4
          ],
          []
        ]
      ],
      "expected": [
        [
          0,
          1,
          2,
          3,
          4
        ],
        [
          0,
          1,
          3,
          4
        ],
        [
          0,
          1,
          4
        ],
        [
          0,
          3,
          4
        ],
        [
          0,
          4
        ]
      ]
    },
    {
      "args": [
        [
          [
            1
          ],
          []
        ]
      ],
      "expected": [
        [
          0,
          1
        ]
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          2,
          3
        ],
        [
          2
        ],
        [
          3
        ],
        []
      ]
    ],
    "expected": [
      [
        0,
        1,
        2,
        3
      ],
      [
        0,
        2,
        3
      ],
      [
        0,
        3
      ]
    ]
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          2,
          3
        ],
        [
          3
        ],
        []
      ]
    ],
    "expected": [
      [
        0,
        1,
        2,
        3
      ],
      [
        0,
        1,
        3
      ],
      [
        0,
        2,
        3
      ]
    ]
  },
  {
    "args": [
      [
        [
          1
        ],
        [
          2
        ],
        [
          3
        ],
        []
      ]
    ],
    "expected": [
      [
        0,
        1,
        2,
        3
      ]
    ]
  },
  {
    "args": [
      [
        [
          1,
          2,
          3,
          4
        ],
        [
          2,
          3,
          4
        ],
        [
          3,
          4
        ],
        [
          4
        ],
        []
      ]
    ],
    "expected": [
      [
        0,
        1,
        2,
        3,
        4
      ],
      [
        0,
        1,
        2,
        4
      ],
      [
        0,
        1,
        3,
        4
      ],
      [
        0,
        1,
        4
      ],
      [
        0,
        2,
        3,
        4
      ],
      [
        0,
        2,
        4
      ],
      [
        0,
        3,
        4
      ],
      [
        0,
        4
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1626,
    '钥匙和房间',
    '有 n 个房间，编号为 0 到 n-1，初始时你在 0 号房间，其余房间都锁着
rooms[i] 是进入房间 i 后能拿到的钥匙列表，每把钥匙可以打开对应编号的房间
判断是否能够进入所有房间',
    'medium',
    1000,
    256,
    ARRAY['图', '广度优先搜索'],
    $json$[
  {
    "input": "rooms = [[1], [2], [3], []]",
    "output": "true"
  },
  {
    "input": "rooms = [[1, 3], [3, 0, 1], [2], [0]]",
    "output": "false"
  },
  {
    "input": "rooms = [[0]]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "rooms = [[1], [2], [3], []]",
    "output": "true"
  },
  {
    "input": "rooms = [[1, 3], [3, 0, 1], [2], [0]]",
    "output": "false"
  },
  {
    "input": "rooms = [[0]]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canVisitAllRooms = function(rooms) {\n};\n",
  "python": "class Solution:\n    def canVisitAllRooms(self, rooms: list[list[int]]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canVisitAllRooms(std::vector<std::vector<int>>& rooms) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canVisitAllRooms(int[][] rooms) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canVisitAllRooms",
  "params": [
    {
      "name": "rooms",
      "type": "int[][]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1
          ],
          [
            2
          ],
          [
            3
          ],
          []
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          [
            1,
            3
          ],
          [
            3,
            0,
            1
          ],
          [
            2
          ],
          [
            0
          ]
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          [
            0
          ]
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1
        ],
        [
          0
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          2,
          1
        ],
        []
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          1
        ],
        [
          2
        ],
        [
          0
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          2
        ],
        [],
        [
          1
        ]
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1627,
    '喧闹和富有',
    '有 n 个人，编号为 0 到 n-1
richer[i] = [a, b] 表示 a 比 b 更有钱，该关系可以传递
quiet[i] 表示第 i 个人的安静值，数值越小越安静
对每个人返回所有比他更有钱的人（包括他自己）中安静值最小的人的编号
若安静值相同，返回编号较小的人',
    'medium',
    1000,
    256,
    ARRAY['图', '深度优先搜索', '记忆化'],
    $json$[
  {
    "input": "richer = [[1, 0], [2, 1], [3, 1], [3, 7], [4, 3], [5, 3], [6, 3]], quiet = [3, 2, 5, 4, 6, 1, 7, 0]",
    "output": "[5, 5, 2, 5, 4, 5, 6, 7]"
  },
  {
    "input": "richer = [], quiet = [3, 1, 2]",
    "output": "[0, 1, 2]"
  },
  {
    "input": "richer = [[0, 1]], quiet = [0, 1]",
    "output": "[0, 0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "richer = [[1, 0], [2, 1], [3, 1], [3, 7], [4, 3], [5, 3], [6, 3]], quiet = [3, 2, 5, 4, 6, 1, 7, 0]",
    "output": "[5, 5, 2, 5, 4, 5, 6, 7]"
  },
  {
    "input": "richer = [], quiet = [3, 1, 2]",
    "output": "[0, 1, 2]"
  },
  {
    "input": "richer = [[0, 1]], quiet = [0, 1]",
    "output": "[0, 0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var loudAndRich = function(richer, quiet) {\n};\n",
  "python": "class Solution:\n    def loudAndRich(self, richer: list[list[int]], quiet: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> loudAndRich(std::vector<std::vector<int>>& richer, std::vector<int>& quiet) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] loudAndRich(int[][] richer, int[] quiet) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "loudAndRich",
  "params": [
    {
      "name": "richer",
      "type": "int[][]"
    },
    {
      "name": "quiet",
      "type": "int[]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            0
          ],
          [
            2,
            1
          ],
          [
            3,
            1
          ],
          [
            3,
            7
          ],
          [
            4,
            3
          ],
          [
            5,
            3
          ],
          [
            6,
            3
          ]
        ],
        [
          3,
          2,
          5,
          4,
          6,
          1,
          7,
          0
        ]
      ],
      "expected": [
        5,
        5,
        2,
        5,
        4,
        5,
        6,
        7
      ]
    },
    {
      "args": [
        [],
        [
          3,
          1,
          2
        ]
      ],
      "expected": [
        0,
        1,
        2
      ]
    },
    {
      "args": [
        [
          [
            0,
            1
          ]
        ],
        [
          0,
          1
        ]
      ],
      "expected": [
        0,
        0
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          0
        ],
        [
          2,
          1
        ]
      ],
      [
        2,
        1,
        3
      ]
    ],
    "expected": [
      1,
      1,
      2
    ]
  },
  {
    "args": [
      [
        [
          1,
          0
        ],
        [
          2,
          0
        ],
        [
          3,
          1
        ],
        [
          3,
          2
        ]
      ],
      [
        5,
        4,
        3,
        2
      ]
    ],
    "expected": [
      3,
      3,
      3,
      3
    ]
  },
  {
    "args": [
      [
        [
          2,
          1
        ],
        [
          3,
          2
        ],
        [
          4,
          3
        ]
      ],
      [
        9,
        8,
        7,
        6,
        5
      ]
    ],
    "expected": [
      0,
      4,
      4,
      4,
      4
    ]
  },
  {
    "args": [
      [
        [
          1,
          0
        ]
      ],
      [
        0,
        0
      ]
    ],
    "expected": [
      0,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1628,
    '不邻接植花',
    '有 n 个花园，编号为 1 到 n，另有若干条连接两个花园的小路
每个花园需要种一种花，花的种类编号为 1 到 4
任意一条小路连接的两个花园必须种不同种类的花，输入保证存在合法方案
按花园编号从小到大，每个花园选择不与已着色邻居冲突的最小编号花色
返回长度为 n 的数组，第 i 个元素为花园 i+1 的花色',
    'medium',
    1000,
    256,
    ARRAY['图', '贪心'],
    $json$[
  {
    "input": "n = 3, paths = [[1, 2], [2, 3], [3, 1]]",
    "output": "[1, 2, 3]"
  },
  {
    "input": "n = 4, paths = [[1, 2], [3, 4]]",
    "output": "[1, 2, 1, 2]"
  },
  {
    "input": "n = 4, paths = [[1, 2], [2, 3], [3, 4], [4, 1], [1, 3], [2, 4]]",
    "output": "[1, 2, 3, 4]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, paths = [[1, 2], [2, 3], [3, 1]]",
    "output": "[1, 2, 3]"
  },
  {
    "input": "n = 4, paths = [[1, 2], [3, 4]]",
    "output": "[1, 2, 1, 2]"
  },
  {
    "input": "n = 4, paths = [[1, 2], [2, 3], [3, 4], [4, 1], [1, 3], [2, 4]]",
    "output": "[1, 2, 3, 4]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var gardenNoAdj = function(n, paths) {\n};\n",
  "python": "class Solution:\n    def gardenNoAdj(self, n: int, paths: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> gardenNoAdj(int n, std::vector<std::vector<int>>& paths) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] gardenNoAdj(int n, int[][] paths) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "gardenNoAdj",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "paths",
      "type": "int[][]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        3,
        [
          [
            1,
            2
          ],
          [
            2,
            3
          ],
          [
            3,
            1
          ]
        ]
      ],
      "expected": [
        1,
        2,
        3
      ]
    },
    {
      "args": [
        4,
        [
          [
            1,
            2
          ],
          [
            3,
            4
          ]
        ]
      ],
      "expected": [
        1,
        2,
        1,
        2
      ]
    },
    {
      "args": [
        4,
        [
          [
            1,
            2
          ],
          [
            2,
            3
          ],
          [
            3,
            4
          ],
          [
            4,
            1
          ],
          [
            1,
            3
          ],
          [
            2,
            4
          ]
        ]
      ],
      "expected": [
        1,
        2,
        3,
        4
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      []
    ],
    "expected": [
      1
    ]
  },
  {
    "args": [
      2,
      [
        [
          1,
          2
        ]
      ]
    ],
    "expected": [
      1,
      2
    ]
  },
  {
    "args": [
      5,
      [
        [
          1,
          2
        ],
        [
          2,
          3
        ],
        [
          3,
          4
        ],
        [
          4,
          5
        ]
      ]
    ],
    "expected": [
      1,
      2,
      1,
      2,
      1
    ]
  },
  {
    "args": [
      4,
      [
        [
          1,
          2
        ],
        [
          1,
          3
        ],
        [
          1,
          4
        ]
      ]
    ],
    "expected": [
      1,
      2,
      2,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1629,
    '颜色交替的最短路径',
    '给定有 n 个节点的有向图，节点编号为 0 到 n-1
redEdges 和 blueEdges 分别描述红色和蓝色有向边，每条边为 [起点, 终点]
从节点 0 出发，路径上的边颜色必须红蓝交替
返回从节点 0 到每个节点的最短路径长度，无法到达的节点返回 -1',
    'medium',
    1000,
    256,
    ARRAY['图', '广度优先搜索'],
    $json$[
  {
    "input": "n = 3, redEdges = [[0, 1], [1, 2]], blueEdges = []",
    "output": "[0, 1, -1]"
  },
  {
    "input": "n = 3, redEdges = [[0, 1]], blueEdges = [[2, 1]]",
    "output": "[0, 1, -1]"
  },
  {
    "input": "n = 3, redEdges = [[0, 1], [0, 2]], blueEdges = [[1, 0]]",
    "output": "[0, 1, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, redEdges = [[0, 1], [1, 2]], blueEdges = []",
    "output": "[0, 1, -1]"
  },
  {
    "input": "n = 3, redEdges = [[0, 1]], blueEdges = [[2, 1]]",
    "output": "[0, 1, -1]"
  },
  {
    "input": "n = 3, redEdges = [[0, 1], [0, 2]], blueEdges = [[1, 0]]",
    "output": "[0, 1, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var shortestAlternatingPaths = function(n, redEdges, blueEdges) {\n};\n",
  "python": "class Solution:\n    def shortestAlternatingPaths(self, n: int, redEdges: list[list[int]], blueEdges: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> shortestAlternatingPaths(int n, std::vector<std::vector<int>>& redEdges, std::vector<std::vector<int>>& blueEdges) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] shortestAlternatingPaths(int n, int[][] redEdges, int[][] blueEdges) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "shortestAlternatingPaths",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "redEdges",
      "type": "int[][]"
    },
    {
      "name": "blueEdges",
      "type": "int[][]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        3,
        [
          [
            0,
            1
          ],
          [
            1,
            2
          ]
        ],
        []
      ],
      "expected": [
        0,
        1,
        -1
      ]
    },
    {
      "args": [
        3,
        [
          [
            0,
            1
          ]
        ],
        [
          [
            2,
            1
          ]
        ]
      ],
      "expected": [
        0,
        1,
        -1
      ]
    },
    {
      "args": [
        3,
        [
          [
            0,
            1
          ],
          [
            0,
            2
          ]
        ],
        [
          [
            1,
            0
          ]
        ]
      ],
      "expected": [
        0,
        1,
        1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      3,
      [
        [
          0,
          1
        ]
      ],
      [
        [
          1,
          2
        ]
      ]
    ],
    "expected": [
      0,
      1,
      2
    ]
  },
  {
    "args": [
      2,
      [
        [
          0,
          1
        ]
      ],
      [
        [
          0,
          1
        ]
      ]
    ],
    "expected": [
      0,
      1
    ]
  },
  {
    "args": [
      4,
      [
        [
          0,
          1
        ],
        [
          2,
          3
        ]
      ],
      [
        [
          1,
          2
        ],
        [
          3,
          0
        ]
      ]
    ],
    "expected": [
      0,
      1,
      2,
      3
    ]
  },
  {
    "args": [
      1,
      [],
      []
    ],
    "expected": [
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1630,
    '跳跃游戏 III',
    '给定非负整数数组 arr 和起始下标 start
从下标 i 出发，可以跳到 i - arr[i] 或 i + arr[i]，前提是目标下标在数组范围内
判断能否到达任意一个值为 0 的下标',
    'medium',
    1000,
    256,
    ARRAY['图', '广度优先搜索', '深度优先搜索'],
    $json$[
  {
    "input": "arr = [4, 2, 3, 0, 3, 1, 2], start = 5",
    "output": "true"
  },
  {
    "input": "arr = [4, 2, 3, 0, 3, 1, 2], start = 0",
    "output": "true"
  },
  {
    "input": "arr = [3, 0, 2, 1, 2], start = 2",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [4, 2, 3, 0, 3, 1, 2], start = 5",
    "output": "true"
  },
  {
    "input": "arr = [4, 2, 3, 0, 3, 1, 2], start = 0",
    "output": "true"
  },
  {
    "input": "arr = [3, 0, 2, 1, 2], start = 2",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canReach = function(arr, start) {\n};\n",
  "python": "class Solution:\n    def canReach(self, arr: list[int], start: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canReach(std::vector<int>& arr, int start) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canReach(int[] arr, int start) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canReach",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
    },
    {
      "name": "start",
      "type": "int"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          4,
          2,
          3,
          0,
          3,
          1,
          2
        ],
        5
      ],
      "expected": true
    },
    {
      "args": [
        [
          4,
          2,
          3,
          0,
          3,
          1,
          2
        ],
        0
      ],
      "expected": true
    },
    {
      "args": [
        [
          3,
          0,
          2,
          1,
          2
        ],
        2
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0
      ],
      0
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        0
      ],
      1
    ],
    "expected": true
  },
  {
    "args": [
      [
        2,
        0,
        1
      ],
      1
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        1,
        0
      ],
      0
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1631,
    '重新规划路线',
    '有 n 个城市，编号为 0 到 n-1，城市之间共有 n-1 条道路构成一棵树
connections[i] = [a, b] 表示存在一条从 a 到 b 的单向道路
为了让所有道路都能直接或间接通向 0 号城市，需要改变部分道路的方向
返回最少需要改变方向的道路数目',
    'medium',
    1000,
    256,
    ARRAY['图', '深度优先搜索'],
    $json$[
  {
    "input": "n = 6, connections = [[0, 1], [1, 3], [2, 3], [4, 0], [4, 5]]",
    "output": "3"
  },
  {
    "input": "n = 5, connections = [[1, 0], [1, 2], [3, 2], [3, 4]]",
    "output": "2"
  },
  {
    "input": "n = 3, connections = [[1, 0], [2, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 6, connections = [[0, 1], [1, 3], [2, 3], [4, 0], [4, 5]]",
    "output": "3"
  },
  {
    "input": "n = 5, connections = [[1, 0], [1, 2], [3, 2], [3, 4]]",
    "output": "2"
  },
  {
    "input": "n = 3, connections = [[1, 0], [2, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minReorder = function(n, connections) {\n};\n",
  "python": "class Solution:\n    def minReorder(self, n: int, connections: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minReorder(int n, std::vector<std::vector<int>>& connections) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minReorder(int n, int[][] connections) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minReorder",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "connections",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        6,
        [
          [
            0,
            1
          ],
          [
            1,
            3
          ],
          [
            2,
            3
          ],
          [
            4,
            0
          ],
          [
            4,
            5
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        5,
        [
          [
            1,
            0
          ],
          [
            1,
            2
          ],
          [
            3,
            2
          ],
          [
            3,
            4
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        3,
        [
          [
            1,
            0
          ],
          [
            2,
            0
          ]
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2,
      [
        [
          1,
          0
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      4,
      [
        [
          0,
          1
        ],
        [
          2,
          1
        ],
        [
          3,
          2
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      5,
      [
        [
          0,
          1
        ],
        [
          1,
          2
        ],
        [
          2,
          3
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      4,
      [
        [
          1,
          0
        ],
        [
          2,
          1
        ],
        [
          3,
          2
        ]
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1632,
    '检查网格中是否存在有效路径',
    '给定 m x n 的网格 grid，每个格子中的数字表示一种管道形状
1 表示连接左右，2 表示连接上下，3 表示连接左下，4 表示连接右下，5 表示连接左上，6 表示连接右上
管道之间只有在相邻格子的开口互相对接时才算连通
判断能否从左上角 (0, 0) 沿连通的管道走到右下角 (m-1, n-1)',
    'medium',
    1000,
    256,
    ARRAY['图', '广度优先搜索', '并查集'],
    $json$[
  {
    "input": "grid = [[2, 4, 3], [6, 5, 2]]",
    "output": "true"
  },
  {
    "input": "grid = [[1, 2, 1], [1, 2, 1]]",
    "output": "false"
  },
  {
    "input": "grid = [[1, 1, 2]]",
    "output": "false"
  },
  {
    "input": "grid = [[1, 1, 1, 1, 1, 1, 3]]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[2, 4, 3], [6, 5, 2]]",
    "output": "true"
  },
  {
    "input": "grid = [[1, 2, 1], [1, 2, 1]]",
    "output": "false"
  },
  {
    "input": "grid = [[1, 1, 2]]",
    "output": "false"
  },
  {
    "input": "grid = [[1, 1, 1, 1, 1, 1, 3]]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var hasValidPath = function(grid) {\n};\n",
  "python": "class Solution:\n    def hasValidPath(self, grid: list[list[int]]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool hasValidPath(std::vector<std::vector<int>>& grid) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean hasValidPath(int[][] grid) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "hasValidPath",
  "params": [
    {
      "name": "grid",
      "type": "int[][]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            2,
            4,
            3
          ],
          [
            6,
            5,
            2
          ]
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          [
            1,
            2,
            1
          ],
          [
            1,
            2,
            1
          ]
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          [
            1,
            1,
            2
          ]
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          [
            1,
            1,
            1,
            1,
            1,
            1,
            3
          ]
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          2
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          2
        ],
        [
          2
        ],
        [
          2
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          4,
          3
        ],
        [
          5,
          2
        ]
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1633,
    '冗余连接',
    '给定一个由 n 个节点和 n 条边组成的无向图，节点编号为 1 到 n
该图由一棵树额外增加一条边得到，返回可以删除的那条边
如果有多条边都可以删除，返回在输入中最后出现的那一条
每条边以 [a, b] 形式给出，返回格式相同',
    'medium',
    1000,
    256,
    ARRAY['并查集', '图'],
    $json$[
  {
    "input": "edges = [[1, 2], [1, 3], [2, 3]]",
    "output": "[2, 3]"
  },
  {
    "input": "edges = [[1, 2], [2, 3], [3, 4], [1, 4], [1, 5]]",
    "output": "[1, 4]"
  },
  {
    "input": "edges = [[1, 2], [2, 3], [3, 1]]",
    "output": "[3, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "edges = [[1, 2], [1, 3], [2, 3]]",
    "output": "[2, 3]"
  },
  {
    "input": "edges = [[1, 2], [2, 3], [3, 4], [1, 4], [1, 5]]",
    "output": "[1, 4]"
  },
  {
    "input": "edges = [[1, 2], [2, 3], [3, 1]]",
    "output": "[3, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findRedundantConnection = function(edges) {\n};\n",
  "python": "class Solution:\n    def findRedundantConnection(self, edges: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findRedundantConnection(std::vector<std::vector<int>>& edges) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findRedundantConnection(int[][] edges) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findRedundantConnection",
  "params": [
    {
      "name": "edges",
      "type": "int[][]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            1,
            3
          ],
          [
            2,
            3
          ]
        ]
      ],
      "expected": [
        2,
        3
      ]
    },
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            2,
            3
          ],
          [
            3,
            4
          ],
          [
            1,
            4
          ],
          [
            1,
            5
          ]
        ]
      ],
      "expected": [
        1,
        4
      ]
    },
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            2,
            3
          ],
          [
            3,
            1
          ]
        ]
      ],
      "expected": [
        3,
        1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          2,
          3
        ],
        [
          1,
          3
        ]
      ]
    ],
    "expected": [
      1,
      3
    ]
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          2,
          3
        ],
        [
          3,
          4
        ],
        [
          4,
          1
        ]
      ]
    ],
    "expected": [
      4,
      1
    ]
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          1,
          3
        ],
        [
          1,
          4
        ],
        [
          2,
          3
        ]
      ]
    ],
    "expected": [
      2,
      3
    ]
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          2,
          3
        ],
        [
          3,
          4
        ],
        [
          4,
          5
        ],
        [
          2,
          5
        ]
      ]
    ],
    "expected": [
      2,
      5
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1634,
    '账户合并',
    '给定账户列表 accounts，每个账户的第一个元素是姓名，其余元素是该账户的邮箱
只要两个账户拥有相同的邮箱，它们就属于同一个人，需要合并
合并后每个人的账户为姓名加上其所有邮箱
每组邮箱按字典序升序排列，最终结果按姓名升序排列，姓名相同则按第一个邮箱升序排列',
    'medium',
    1000,
    256,
    ARRAY['并查集', '哈希表', '排序'],
    $json$[
  {
    "input": "accounts = [[\"John\", \"johnsmith@mail.com\", \"john_newyork@mail.com\"], [\"John\", \"johnsmith@mail.com\", \"john00@mail.com\"], [\"Mary\", \"mary@mail.com\"], [\"John\", \"johnnybravo@mail.com\"]]",
    "output": "[[\"John\", \"john00@mail.com\", \"john_newyork@mail.com\", \"johnsmith@mail.com\"], [\"John\", \"johnnybravo@mail.com\"], [\"Mary\", \"mary@mail.com\"]]"
  },
  {
    "input": "accounts = [[\"Gabe\", \"Gabe0@m.co\", \"Gabe3@m.co\", \"Gabe1@m.co\"], [\"Kevin\", \"Kevin3@m.co\", \"Kevin5@m.co\", \"Kevin0@m.co\"], [\"Ethan\", \"Ethan5@m.co\", \"Ethan4@m.co\", \"Ethan0@m.co\"], [\"Hanzo\", \"Hanzo3@m.co\", \"Hanzo1@m.co\", \"Hanzo0@m.co\"], [\"Fern\", \"Fern5@m.co\", \"Fern1@m.co\", \"Fern0@m.co\"]]",
    "output": "[[\"Ethan\", \"Ethan0@m.co\", \"Ethan4@m.co\", \"Ethan5@m.co\"], [\"Fern\", \"Fern0@m.co\", \"Fern1@m.co\", \"Fern5@m.co\"], [\"Gabe\", \"Gabe0@m.co\", \"Gabe1@m.co\", \"Gabe3@m.co\"], [\"Hanzo\", \"Hanzo0@m.co\", \"Hanzo1@m.co\", \"Hanzo3@m.co\"], [\"Kevin\", \"Kevin0@m.co\", \"Kevin3@m.co\", \"Kevin5@m.co\"]]"
  },
  {
    "input": "accounts = [[\"David\", \"David0@m.co\", \"David1@m.co\"], [\"David\", \"David3@m.co\", \"David4@m.co\"], [\"David\", \"David4@m.co\", \"David5@m.co\"], [\"David\", \"David2@m.co\", \"David3@m.co\"], [\"David\", \"David1@m.co\", \"David2@m.co\"]]",
    "output": "[[\"David\", \"David0@m.co\", \"David1@m.co\", \"David2@m.co\", \"David3@m.co\", \"David4@m.co\", \"David5@m.co\"]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "accounts = [[\"John\", \"johnsmith@mail.com\", \"john_newyork@mail.com\"], [\"John\", \"johnsmith@mail.com\", \"john00@mail.com\"], [\"Mary\", \"mary@mail.com\"], [\"John\", \"johnnybravo@mail.com\"]]",
    "output": "[[\"John\", \"john00@mail.com\", \"john_newyork@mail.com\", \"johnsmith@mail.com\"], [\"John\", \"johnnybravo@mail.com\"], [\"Mary\", \"mary@mail.com\"]]"
  },
  {
    "input": "accounts = [[\"Gabe\", \"Gabe0@m.co\", \"Gabe3@m.co\", \"Gabe1@m.co\"], [\"Kevin\", \"Kevin3@m.co\", \"Kevin5@m.co\", \"Kevin0@m.co\"], [\"Ethan\", \"Ethan5@m.co\", \"Ethan4@m.co\", \"Ethan0@m.co\"], [\"Hanzo\", \"Hanzo3@m.co\", \"Hanzo1@m.co\", \"Hanzo0@m.co\"], [\"Fern\", \"Fern5@m.co\", \"Fern1@m.co\", \"Fern0@m.co\"]]",
    "output": "[[\"Ethan\", \"Ethan0@m.co\", \"Ethan4@m.co\", \"Ethan5@m.co\"], [\"Fern\", \"Fern0@m.co\", \"Fern1@m.co\", \"Fern5@m.co\"], [\"Gabe\", \"Gabe0@m.co\", \"Gabe1@m.co\", \"Gabe3@m.co\"], [\"Hanzo\", \"Hanzo0@m.co\", \"Hanzo1@m.co\", \"Hanzo3@m.co\"], [\"Kevin\", \"Kevin0@m.co\", \"Kevin3@m.co\", \"Kevin5@m.co\"]]"
  },
  {
    "input": "accounts = [[\"David\", \"David0@m.co\", \"David1@m.co\"], [\"David\", \"David3@m.co\", \"David4@m.co\"], [\"David\", \"David4@m.co\", \"David5@m.co\"], [\"David\", \"David2@m.co\", \"David3@m.co\"], [\"David\", \"David1@m.co\", \"David2@m.co\"]]",
    "output": "[[\"David\", \"David0@m.co\", \"David1@m.co\", \"David2@m.co\", \"David3@m.co\", \"David4@m.co\", \"David5@m.co\"]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var accountsMerge = function(accounts) {\n};\n",
  "python": "class Solution:\n    def accountsMerge(self, accounts: list[list[str]]) -> list[list[str]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<std::string>> accountsMerge(std::vector<std::vector<std::string>>& accounts) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[][] accountsMerge(String[][] accounts) {\n        return new String[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "accountsMerge",
  "params": [
    {
      "name": "accounts",
      "type": "string[][]"
    }
  ],
  "return_type": "string[][]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            "John",
            "johnsmith@mail.com",
            "john_newyork@mail.com"
          ],
          [
            "John",
            "johnsmith@mail.com",
            "john00@mail.com"
          ],
          [
            "Mary",
            "mary@mail.com"
          ],
          [
            "John",
            "johnnybravo@mail.com"
          ]
        ]
      ],
      "expected": [
        [
          "John",
          "john00@mail.com",
          "john_newyork@mail.com",
          "johnsmith@mail.com"
        ],
        [
          "John",
          "johnnybravo@mail.com"
        ],
        [
          "Mary",
          "mary@mail.com"
        ]
      ]
    },
    {
      "args": [
        [
          [
            "Gabe",
            "Gabe0@m.co",
            "Gabe3@m.co",
            "Gabe1@m.co"
          ],
          [
            "Kevin",
            "Kevin3@m.co",
            "Kevin5@m.co",
            "Kevin0@m.co"
          ],
          [
            "Ethan",
            "Ethan5@m.co",
            "Ethan4@m.co",
            "Ethan0@m.co"
          ],
          [
            "Hanzo",
            "Hanzo3@m.co",
            "Hanzo1@m.co",
            "Hanzo0@m.co"
          ],
          [
            "Fern",
            "Fern5@m.co",
            "Fern1@m.co",
            "Fern0@m.co"
          ]
        ]
      ],
      "expected": [
        [
          "Ethan",
          "Ethan0@m.co",
          "Ethan4@m.co",
          "Ethan5@m.co"
        ],
        [
          "Fern",
          "Fern0@m.co",
          "Fern1@m.co",
          "Fern5@m.co"
        ],
        [
          "Gabe",
          "Gabe0@m.co",
          "Gabe1@m.co",
          "Gabe3@m.co"
        ],
        [
          "Hanzo",
          "Hanzo0@m.co",
          "Hanzo1@m.co",
          "Hanzo3@m.co"
        ],
        [
          "Kevin",
          "Kevin0@m.co",
          "Kevin3@m.co",
          "Kevin5@m.co"
        ]
      ]
    },
    {
      "args": [
        [
          [
            "David",
            "David0@m.co",
            "David1@m.co"
          ],
          [
            "David",
            "David3@m.co",
            "David4@m.co"
          ],
          [
            "David",
            "David4@m.co",
            "David5@m.co"
          ],
          [
            "David",
            "David2@m.co",
            "David3@m.co"
          ],
          [
            "David",
            "David1@m.co",
            "David2@m.co"
          ]
        ]
      ],
      "expected": [
        [
          "David",
          "David0@m.co",
          "David1@m.co",
          "David2@m.co",
          "David3@m.co",
          "David4@m.co",
          "David5@m.co"
        ]
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          "John",
          "a@b.c"
        ]
      ]
    ],
    "expected": [
      [
        "John",
        "a@b.c"
      ]
    ]
  },
  {
    "args": [
      [
        [
          "A",
          "x@y.z",
          "p@q.r"
        ],
        [
          "A",
          "p@q.r",
          "m@n.o"
        ]
      ]
    ],
    "expected": [
      [
        "A",
        "m@n.o",
        "p@q.r",
        "x@y.z"
      ]
    ]
  },
  {
    "args": [
      [
        [
          "A",
          "a@b",
          "c@d"
        ],
        [
          "A",
          "c@d",
          "e@f"
        ],
        [
          "B",
          "g@h"
        ],
        [
          "B",
          "i@j",
          "g@h"
        ]
      ]
    ],
    "expected": [
      [
        "A",
        "a@b",
        "c@d",
        "e@f"
      ],
      [
        "B",
        "g@h",
        "i@j"
      ]
    ]
  },
  {
    "args": [
      [
        [
          "Z",
          "z@z",
          "zz@z"
        ],
        [
          "Y",
          "y@y"
        ],
        [
          "Z",
          "z@z"
        ]
      ]
    ],
    "expected": [
      [
        "Y",
        "y@y"
      ],
      [
        "Z",
        "z@z",
        "zz@z"
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1635,
    '移除最多的同行或同列石头',
    '给定二维平面上的 n 块石头，stones[i] = [x, y] 表示第 i 块石头的坐标
如果两块石头在同一行或同一列，可以移除其中一块
每次移除后其余石头位置不变，同一位置不会有多块石头
返回最多可以移除的石头数目',
    'medium',
    1000,
    256,
    ARRAY['并查集', '图'],
    $json$[
  {
    "input": "stones = [[0, 0], [0, 1], [1, 0], [1, 2], [2, 1], [2, 2]]",
    "output": "5"
  },
  {
    "input": "stones = [[0, 0], [0, 2], [1, 1], [2, 0], [2, 2]]",
    "output": "3"
  },
  {
    "input": "stones = [[0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "stones = [[0, 0], [0, 1], [1, 0], [1, 2], [2, 1], [2, 2]]",
    "output": "5"
  },
  {
    "input": "stones = [[0, 0], [0, 2], [1, 1], [2, 0], [2, 2]]",
    "output": "3"
  },
  {
    "input": "stones = [[0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeStones = function(stones) {\n};\n",
  "python": "class Solution:\n    def removeStones(self, stones: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int removeStones(std::vector<std::vector<int>>& stones) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int removeStones(int[][] stones) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeStones",
  "params": [
    {
      "name": "stones",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            0,
            0
          ],
          [
            0,
            1
          ],
          [
            1,
            0
          ],
          [
            1,
            2
          ],
          [
            2,
            1
          ],
          [
            2,
            2
          ]
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        [
          [
            0,
            0
          ],
          [
            0,
            2
          ],
          [
            1,
            1
          ],
          [
            2,
            0
          ],
          [
            2,
            2
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          [
            0,
            0
          ]
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          0,
          0
        ],
        [
          0,
          1
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          0,
          0
        ],
        [
          1,
          1
        ],
        [
          2,
          2
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          0,
          0
        ],
        [
          1,
          0
        ],
        [
          2,
          0
        ],
        [
          3,
          0
        ]
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        [
          0,
          0
        ],
        [
          0,
          1
        ],
        [
          1,
          1
        ]
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1636,
    '交换字符串中的元素',
    '给定字符串 s 和下标对数组 pairs
pairs[i] = [a, b] 表示可以任意次交换 s[a] 和 s[b] 的字符
经过任意多次交换后，返回能够得到的字典序最小的字符串',
    'medium',
    1000,
    256,
    ARRAY['并查集', '字符串', '排序'],
    $json$[
  {
    "input": "s = \"dcab\", pairs = [[0, 3], [1, 2]]",
    "output": "\"bacd\""
  },
  {
    "input": "s = \"dcab\", pairs = [[0, 3], [1, 2], [0, 2]]",
    "output": "\"abcd\""
  },
  {
    "input": "s = \"cba\", pairs = [[0, 1], [1, 2]]",
    "output": "\"abc\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"dcab\", pairs = [[0, 3], [1, 2]]",
    "output": "\"bacd\""
  },
  {
    "input": "s = \"dcab\", pairs = [[0, 3], [1, 2], [0, 2]]",
    "output": "\"abcd\""
  },
  {
    "input": "s = \"cba\", pairs = [[0, 1], [1, 2]]",
    "output": "\"abc\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestStringWithSwaps = function(s, pairs) {\n};\n",
  "python": "class Solution:\n    def smallestStringWithSwaps(self, s: str, pairs: list[list[int]]) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string smallestStringWithSwaps(std::string s, std::vector<std::vector<int>>& pairs) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String smallestStringWithSwaps(String s, int[][] pairs) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestStringWithSwaps",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "pairs",
      "type": "int[][]"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "dcab",
        [
          [
            0,
            3
          ],
          [
            1,
            2
          ]
        ]
      ],
      "expected": "bacd"
    },
    {
      "args": [
        "dcab",
        [
          [
            0,
            3
          ],
          [
            1,
            2
          ],
          [
            0,
            2
          ]
        ]
      ],
      "expected": "abcd"
    },
    {
      "args": [
        "cba",
        [
          [
            0,
            1
          ],
          [
            1,
            2
          ]
        ]
      ],
      "expected": "abc"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      []
    ],
    "expected": "a"
  },
  {
    "args": [
      "ba",
      [
        [
          0,
          1
        ]
      ]
    ],
    "expected": "ab"
  },
  {
    "args": [
      "abcd",
      []
    ],
    "expected": "abcd"
  },
  {
    "args": [
      "dcba",
      [
        [
          0,
          1
        ],
        [
          1,
          2
        ],
        [
          2,
          3
        ]
      ]
    ],
    "expected": "abcd"
  }
]$json$::jsonb,
    'approved'
),
(
    1637,
    '按字典序排列最小的等效字符串',
    '给定两个等长字符串 s1 和 s2，以及字符串 baseStr
s1[i] 与 s2[i] 属于同一等价类，等价关系具有传递性
把 baseStr 中每个字符替换成它所在等价类中字典序最小的字符
返回替换后的字符串',
    'medium',
    1000,
    256,
    ARRAY['并查集', '字符串'],
    $json$[
  {
    "input": "s1 = \"parker\", s2 = \"morris\", baseStr = \"parser\"",
    "output": "\"makkek\""
  },
  {
    "input": "s1 = \"hello\", s2 = \"world\", baseStr = \"hold\"",
    "output": "\"hdld\""
  },
  {
    "input": "s1 = \"leetcode\", s2 = \"programs\", baseStr = \"sourcecode\"",
    "output": "\"aauaaaaada\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s1 = \"parker\", s2 = \"morris\", baseStr = \"parser\"",
    "output": "\"makkek\""
  },
  {
    "input": "s1 = \"hello\", s2 = \"world\", baseStr = \"hold\"",
    "output": "\"hdld\""
  },
  {
    "input": "s1 = \"leetcode\", s2 = \"programs\", baseStr = \"sourcecode\"",
    "output": "\"aauaaaaada\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestEquivalentString = function(s1, s2, baseStr) {\n};\n",
  "python": "class Solution:\n    def smallestEquivalentString(self, s1: str, s2: str, baseStr: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string smallestEquivalentString(std::string s1, std::string s2, std::string baseStr) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String smallestEquivalentString(String s1, String s2, String baseStr) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestEquivalentString",
  "params": [
    {
      "name": "s1",
      "type": "string"
    },
    {
      "name": "s2",
      "type": "string"
    },
    {
      "name": "baseStr",
      "type": "string"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "parker",
        "morris",
        "parser"
      ],
      "expected": "makkek"
    },
    {
      "args": [
        "hello",
        "world",
        "hold"
      ],
      "expected": "hdld"
    },
    {
      "args": [
        "leetcode",
        "programs",
        "sourcecode"
      ],
      "expected": "aauaaaaada"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      "b",
      "c"
    ],
    "expected": "c"
  },
  {
    "args": [
      "abc",
      "def",
      "ghi"
    ],
    "expected": "ghi"
  },
  {
    "args": [
      "ab",
      "bc",
      "abc"
    ],
    "expected": "aaa"
  },
  {
    "args": [
      "z",
      "y",
      "x"
    ],
    "expected": "x"
  }
]$json$::jsonb,
    'approved'
),
(
    1638,
    '掷骰子等于目标和的方法数',
    '有 n 个骰子，每个骰子有 k 个面，面上的数字为 1 到 k
同时掷出所有骰子，求点数之和恰好等于 target 的方案数
结果对 10^9 + 7 取模',
    'medium',
    1000,
    256,
    ARRAY['动态规划'],
    $json$[
  {
    "input": "n = 1, k = 6, target = 3",
    "output": "1"
  },
  {
    "input": "n = 2, k = 6, target = 7",
    "output": "6"
  },
  {
    "input": "n = 30, k = 30, target = 500",
    "output": "222616187"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 1, k = 6, target = 3",
    "output": "1"
  },
  {
    "input": "n = 2, k = 6, target = 7",
    "output": "6"
  },
  {
    "input": "n = 30, k = 30, target = 500",
    "output": "222616187"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numRollsToTarget = function(n, k, target) {\n};\n",
  "python": "class Solution:\n    def numRollsToTarget(self, n: int, k: int, target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numRollsToTarget(int n, int k, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numRollsToTarget(int n, int k, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numRollsToTarget",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "k",
      "type": "int"
    },
    {
      "name": "target",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        1,
        6,
        3
      ],
      "expected": 1
    },
    {
      "args": [
        2,
        6,
        7
      ],
      "expected": 6
    },
    {
      "args": [
        30,
        30,
        500
      ],
      "expected": 222616187
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      6,
      1
    ],
    "expected": 1
  },
  {
    "args": [
      2,
      6,
      2
    ],
    "expected": 1
  },
  {
    "args": [
      5,
      3,
      10
    ],
    "expected": 51
  },
  {
    "args": [
      10,
      10,
      100
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1639,
    '删除并获得点数',
    '给定整数数组 nums
选择任意一个数字 x 可以获得 x 分，随后必须删除数组中所有等于 x-1 和 x+1 的数字
可以重复该过程，返回能够获得的最大总分数',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '数组'],
    $json$[
  {
    "input": "nums = [3, 4, 2]",
    "output": "6"
  },
  {
    "input": "nums = [2, 2, 3, 3, 3, 4]",
    "output": "9"
  },
  {
    "input": "nums = [1, 1, 1, 2, 4, 5, 5, 5, 6]",
    "output": "18"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 4, 2]",
    "output": "6"
  },
  {
    "input": "nums = [2, 2, 3, 3, 3, 4]",
    "output": "9"
  },
  {
    "input": "nums = [1, 1, 1, 2, 4, 5, 5, 5, 6]",
    "output": "18"
  }
]$json$::jsonb,
    $json${
  "javascript": "var deleteAndEarn = function(nums) {\n};\n",
  "python": "class Solution:\n    def deleteAndEarn(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int deleteAndEarn(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int deleteAndEarn(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "deleteAndEarn",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          3,
          4,
          2
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          2,
          2,
          3,
          3,
          3,
          4
        ]
      ],
      "expected": 9
    },
    {
      "args": [
        [
          1,
          1,
          1,
          2,
          4,
          5,
          5,
          5,
          6
        ]
      ],
      "expected": 18
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ]
    ],
    "expected": 9
  },
  {
    "args": [
      [
        2,
        2,
        2,
        2
      ]
    ],
    "expected": 8
  },
  {
    "args": [
      [
        1,
        1,
        2,
        2,
        3,
        3,
        4,
        4
      ]
    ],
    "expected": 12
  }
]$json$::jsonb,
    'approved'
),
(
    1640,
    '最低票价',
    '给定一个升序数组 days，表示未来一年中需要出行的日期
costs = [一天通行证价格, 七天通行证价格, 三十天通行证价格]
通行证在购买当天生效，可以覆盖连续的天数，返回覆盖所有出行日的最少花费',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '数组'],
    $json$[
  {
    "input": "days = [1, 4, 6, 7, 8, 20], costs = [2, 7, 15]",
    "output": "11"
  },
  {
    "input": "days = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 30, 31], costs = [2, 7, 15]",
    "output": "17"
  },
  {
    "input": "days = [1, 2, 3], costs = [2, 7, 15]",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "days = [1, 4, 6, 7, 8, 20], costs = [2, 7, 15]",
    "output": "11"
  },
  {
    "input": "days = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 30, 31], costs = [2, 7, 15]",
    "output": "17"
  },
  {
    "input": "days = [1, 2, 3], costs = [2, 7, 15]",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var mincostTickets = function(days, costs) {\n};\n",
  "python": "class Solution:\n    def mincostTickets(self, days: list[int], costs: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int mincostTickets(std::vector<int>& days, std::vector<int>& costs) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int mincostTickets(int[] days, int[] costs) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "mincostTickets",
  "params": [
    {
      "name": "days",
      "type": "int[]"
    },
    {
      "name": "costs",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          4,
          6,
          7,
          8,
          20
        ],
        [
          2,
          7,
          15
        ]
      ],
      "expected": 11
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          30,
          31
        ],
        [
          2,
          7,
          15
        ]
      ],
      "expected": 17
    },
    {
      "args": [
        [
          1,
          2,
          3
        ],
        [
          2,
          7,
          15
        ]
      ],
      "expected": 6
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ],
      [
        2,
        7,
        15
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        365
      ],
      [
        2,
        7,
        15
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        1,
        2,
        4,
        5,
        6,
        7,
        8,
        20
      ],
      [
        2,
        7,
        15
      ]
    ],
    "expected": 11
  },
  {
    "args": [
      [
        1,
        4,
        6,
        7,
        8,
        20
      ],
      [
        7,
        2,
        15
      ]
    ],
    "expected": 6
  }
]$json$::jsonb,
    'approved'
),
(
    1641,
    '分隔数组以得到最大和',
    '给定整数数组 arr 和整数 k
将数组分成若干个连续子数组，每个子数组的长度不超过 k
每个子数组的值等于该子数组的长度乘以子数组中的最大值
返回所有子数组值之和的最大值',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '数组'],
    $json$[
  {
    "input": "arr = [1, 15, 7, 9, 2, 5, 10], k = 3",
    "output": "84"
  },
  {
    "input": "arr = [1, 4, 1, 5, 7, 3, 6, 1, 9, 3], k = 4",
    "output": "72"
  },
  {
    "input": "arr = [1], k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [1, 15, 7, 9, 2, 5, 10], k = 3",
    "output": "84"
  },
  {
    "input": "arr = [1, 4, 1, 5, 7, 3, 6, 1, 9, 3], k = 4",
    "output": "72"
  },
  {
    "input": "arr = [1], k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxSumAfterPartitioning = function(arr, k) {\n};\n",
  "python": "class Solution:\n    def maxSumAfterPartitioning(self, arr: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxSumAfterPartitioning(std::vector<int>& arr, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxSumAfterPartitioning(int[] arr, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxSumAfterPartitioning",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          15,
          7,
          9,
          2,
          5,
          10
        ],
        3
      ],
      "expected": 84
    },
    {
      "args": [
        [
          1,
          4,
          1,
          5,
          7,
          3,
          6,
          1,
          9,
          3
        ],
        4
      ],
      "expected": 72
    },
    {
      "args": [
        [
          1
        ],
        1
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        3
      ],
      1
    ],
    "expected": 6
  },
  {
    "args": [
      [
        1,
        2,
        3
      ],
      2
    ],
    "expected": 7
  },
  {
    "args": [
      [
        7,
        9,
        1
      ],
      3
    ],
    "expected": 27
  },
  {
    "args": [
      [
        2,
        1,
        4,
        3
      ],
      2
    ],
    "expected": 13
  }
]$json$::jsonb,
    'approved'
),
(
    1642,
    '填充书架',
    '给定二维数组 books，books[i] = [厚度, 高度]，以及书架宽度 shelfWidth
按给定顺序把书依次摆放到书架上，每层放的书总厚度不能超过 shelfWidth
每层的高度等于该层中最高的书，书架总高度为各层高度之和
返回摆放所有书的最小总高度',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '数组'],
    $json$[
  {
    "input": "books = [[1, 1], [2, 3], [2, 3], [1, 1], [1, 1], [1, 1], [1, 2]], shelfWidth = 4",
    "output": "6"
  },
  {
    "input": "books = [[1, 3], [2, 4], [3, 2]], shelfWidth = 6",
    "output": "4"
  },
  {
    "input": "books = [[1, 1], [2, 1], [3, 1]], shelfWidth = 4",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "books = [[1, 1], [2, 3], [2, 3], [1, 1], [1, 1], [1, 1], [1, 2]], shelfWidth = 4",
    "output": "6"
  },
  {
    "input": "books = [[1, 3], [2, 4], [3, 2]], shelfWidth = 6",
    "output": "4"
  },
  {
    "input": "books = [[1, 1], [2, 1], [3, 1]], shelfWidth = 4",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minHeightShelves = function(books, shelfWidth) {\n};\n",
  "python": "class Solution:\n    def minHeightShelves(self, books: list[list[int]], shelfWidth: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minHeightShelves(std::vector<std::vector<int>>& books, int shelfWidth) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minHeightShelves(int[][] books, int shelfWidth) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minHeightShelves",
  "params": [
    {
      "name": "books",
      "type": "int[][]"
    },
    {
      "name": "shelfWidth",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            1
          ],
          [
            2,
            3
          ],
          [
            2,
            3
          ],
          [
            1,
            1
          ],
          [
            1,
            1
          ],
          [
            1,
            1
          ],
          [
            1,
            2
          ]
        ],
        4
      ],
      "expected": 6
    },
    {
      "args": [
        [
          [
            1,
            3
          ],
          [
            2,
            4
          ],
          [
            3,
            2
          ]
        ],
        6
      ],
      "expected": 4
    },
    {
      "args": [
        [
          [
            1,
            1
          ],
          [
            2,
            1
          ],
          [
            3,
            1
          ]
        ],
        4
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          1
        ]
      ],
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          4
        ],
        [
          2,
          1
        ]
      ],
      5
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          2,
          2
        ],
        [
          3,
          2
        ]
      ],
      4
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          2,
          3
        ],
        [
          1,
          1
        ],
        [
          1,
          1
        ]
      ],
      4
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1643,
    '最长字符串链',
    '给定单词数组 words
如果单词 word2 可以由 word1 在任意位置插入一个字母得到，则称 word1 是 word2 的前身
字符串链是一系列单词，其中每个单词都是下一个单词的前身
返回最长的字符串链长度',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '哈希表', '字符串'],
    $json$[
  {
    "input": "words = [\"a\", \"b\", \"ba\", \"bca\", \"bda\", \"bdca\"]",
    "output": "4"
  },
  {
    "input": "words = [\"xbc\", \"pcxbcf\", \"xb\", \"cxbc\", \"pcxbc\"]",
    "output": "5"
  },
  {
    "input": "words = [\"abcd\", \"dbqca\"]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"a\", \"b\", \"ba\", \"bca\", \"bda\", \"bdca\"]",
    "output": "4"
  },
  {
    "input": "words = [\"xbc\", \"pcxbcf\", \"xb\", \"cxbc\", \"pcxbc\"]",
    "output": "5"
  },
  {
    "input": "words = [\"abcd\", \"dbqca\"]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestStrChain = function(words) {\n};\n",
  "python": "class Solution:\n    def longestStrChain(self, words: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestStrChain(std::vector<std::string>& words) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestStrChain(String[] words) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestStrChain",
  "params": [
    {
      "name": "words",
      "type": "string[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "a",
          "b",
          "ba",
          "bca",
          "bda",
          "bdca"
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          "xbc",
          "pcxbcf",
          "xb",
          "cxbc",
          "pcxbc"
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        [
          "abcd",
          "dbqca"
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "a"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "a",
        "b",
        "c"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "abc",
        "abd",
        "ab",
        "a"
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        "ksqvsyq",
        "ks",
        "kss",
        "czvh",
        "zczpzvdhx",
        "czpzvd",
        "czpzvdv"
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1644,
    '下降路径最小和',
    '给定 m x n 的整数矩阵 matrix
从第一行的任意元素出发，每次移动到下一行的同一列或相邻列
到达最后一行时，返回经过元素之和的最小值',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '矩阵'],
    $json$[
  {
    "input": "matrix = [[2, 1, 3], [6, 5, 4], [7, 8, 9]]",
    "output": "13"
  },
  {
    "input": "matrix = [[-19, 57], [-40, -5]]",
    "output": "-59"
  },
  {
    "input": "matrix = [[-48]]",
    "output": "-48"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[2, 1, 3], [6, 5, 4], [7, 8, 9]]",
    "output": "13"
  },
  {
    "input": "matrix = [[-19, 57], [-40, -5]]",
    "output": "-59"
  },
  {
    "input": "matrix = [[-48]]",
    "output": "-48"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minFallingPathSum = function(matrix) {\n};\n",
  "python": "class Solution:\n    def minFallingPathSum(self, matrix: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minFallingPathSum(std::vector<std::vector<int>>& matrix) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minFallingPathSum(int[][] matrix) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minFallingPathSum",
  "params": [
    {
      "name": "matrix",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            2,
            1,
            3
          ],
          [
            6,
            5,
            4
          ],
          [
            7,
            8,
            9
          ]
        ]
      ],
      "expected": 13
    },
    {
      "args": [
        [
          [
            -19,
            57
          ],
          [
            -40,
            -5
          ]
        ]
      ],
      "expected": -59
    },
    {
      "args": [
        [
          [
            -48
          ]
        ]
      ],
      "expected": -48
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          2,
          3
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1
        ],
        [
          2
        ],
        [
          3
        ]
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          -1,
          -2,
          -3
        ],
        [
          -4,
          -5,
          -6
        ],
        [
          -7,
          -8,
          -9
        ]
      ]
    ],
    "expected": -18
  }
]$json$::jsonb,
    'approved'
),
(
    1645,
    '多边形三角剖分的最低得分',
    '给定一个凸多边形，values[i] 是第 i 个顶点的值，顶点按顺序排列
用 n-3 条不相交的对角线把多边形剖分成 n-2 个三角形
每个三角形的得分等于三个顶点值的乘积，总得分为所有三角形得分之和
返回所有剖分方案中的最低得分',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '区间动态规划'],
    $json$[
  {
    "input": "values = [1, 2, 3]",
    "output": "6"
  },
  {
    "input": "values = [3, 7, 4, 5]",
    "output": "144"
  },
  {
    "input": "values = [1, 3, 1, 4, 1, 5]",
    "output": "13"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "values = [1, 2, 3]",
    "output": "6"
  },
  {
    "input": "values = [3, 7, 4, 5]",
    "output": "144"
  },
  {
    "input": "values = [1, 3, 1, 4, 1, 5]",
    "output": "13"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minScoreTriangulation = function(values) {\n};\n",
  "python": "class Solution:\n    def minScoreTriangulation(self, values: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minScoreTriangulation(std::vector<int>& values) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minScoreTriangulation(int[] values) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minScoreTriangulation",
  "params": [
    {
      "name": "values",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          3,
          7,
          4,
          5
        ]
      ],
      "expected": 144
    },
    {
      "args": [
        [
          1,
          3,
          1,
          4,
          1,
          5
        ]
      ],
      "expected": 13
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        2,
        3,
        4
      ]
    ],
    "expected": 24
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ]
    ],
    "expected": 18
  },
  {
    "args": [
      [
        4,
        3,
        2,
        1
      ]
    ],
    "expected": 18
  },
  {
    "args": [
      [
        1,
        5,
        2,
        6,
        3
      ]
    ],
    "expected": 40
  }
]$json$::jsonb,
    'approved'
),
(
    1646,
    '石子游戏 II',
    '有若干堆石子排成一行，piles[i] 表示第 i 堆的石子数
两名玩家轮流取石子，先手初始可取前 1 到 2M 堆，初始 M = 1
取走 k 堆后，下一个玩家的 M 更新为 max(M, k)
两人都采用最优策略，返回先手最多能拿到的石子总数',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '博弈'],
    $json$[
  {
    "input": "piles = [2, 7, 9, 4, 4]",
    "output": "10"
  },
  {
    "input": "piles = [1, 2, 3, 4, 5, 100]",
    "output": "104"
  },
  {
    "input": "piles = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "piles = [2, 7, 9, 4, 4]",
    "output": "10"
  },
  {
    "input": "piles = [1, 2, 3, 4, 5, 100]",
    "output": "104"
  },
  {
    "input": "piles = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var stoneGameII = function(piles) {\n};\n",
  "python": "class Solution:\n    def stoneGameII(self, piles: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int stoneGameII(std::vector<int>& piles) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int stoneGameII(int[] piles) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "stoneGameII",
  "params": [
    {
      "name": "piles",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          2,
          7,
          9,
          4,
          4
        ]
      ],
      "expected": 10
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4,
          5,
          100
        ]
      ],
      "expected": 104
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        5,
        4,
        3,
        2,
        1
      ]
    ],
    "expected": 9
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10
      ]
    ],
    "expected": 26
  },
  {
    "args": [
      [
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10
      ]
    ],
    "expected": 60
  }
]$json$::jsonb,
    'approved'
),
(
    1647,
    '活字印刷',
    '给定一个字符串 tiles，其中每个字符代表一块字母牌
可以任意选择若干块牌并按任意顺序排列，组成非空序列
返回能够组成的不同非空序列的数目',
    'medium',
    1000,
    256,
    ARRAY['回溯', '字符串'],
    $json$[
  {
    "input": "tiles = \"AAB\"",
    "output": "8"
  },
  {
    "input": "tiles = \"AAABBC\"",
    "output": "188"
  },
  {
    "input": "tiles = \"V\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "tiles = \"AAB\"",
    "output": "8"
  },
  {
    "input": "tiles = \"AAABBC\"",
    "output": "188"
  },
  {
    "input": "tiles = \"V\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numTilePossibilities = function(tiles) {\n};\n",
  "python": "class Solution:\n    def numTilePossibilities(self, tiles: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numTilePossibilities(std::string tiles) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numTilePossibilities(String tiles) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numTilePossibilities",
  "params": [
    {
      "name": "tiles",
      "type": "string"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "AAB"
      ],
      "expected": 8
    },
    {
      "args": [
        "AAABBC"
      ],
      "expected": 188
    },
    {
      "args": [
        "V"
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "A"
    ],
    "expected": 1
  },
  {
    "args": [
      "AB"
    ],
    "expected": 4
  },
  {
    "args": [
      "AAAB"
    ],
    "expected": 13
  },
  {
    "args": [
      "ABCD"
    ],
    "expected": 64
  },
  {
    "args": [
      "AABBCC"
    ],
    "expected": 270
  }
]$json$::jsonb,
    'approved'
),
(
    1648,
    '黄金矿工',
    '给定 m x n 的网格 grid，0 表示空地，正数表示该格子的金子数
可以从任意一个含金子的格子出发，每次上下左右移动到一个含金子的格子
已经采集过的格子不能再次进入，返回能够采集到的最大金子总数',
    'medium',
    1000,
    256,
    ARRAY['回溯', '矩阵'],
    $json$[
  {
    "input": "grid = [[0, 6, 0], [5, 8, 7], [0, 9, 0]]",
    "output": "24"
  },
  {
    "input": "grid = [[1, 0, 7], [2, 0, 6], [3, 4, 5], [0, 3, 0], [9, 0, 20]]",
    "output": "28"
  },
  {
    "input": "grid = [[2, 3, 4]]",
    "output": "9"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[0, 6, 0], [5, 8, 7], [0, 9, 0]]",
    "output": "24"
  },
  {
    "input": "grid = [[1, 0, 7], [2, 0, 6], [3, 4, 5], [0, 3, 0], [9, 0, 20]]",
    "output": "28"
  },
  {
    "input": "grid = [[2, 3, 4]]",
    "output": "9"
  }
]$json$::jsonb,
    $json${
  "javascript": "var getMaximumGold = function(grid) {\n};\n",
  "python": "class Solution:\n    def getMaximumGold(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int getMaximumGold(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int getMaximumGold(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getMaximumGold",
  "params": [
    {
      "name": "grid",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            0,
            6,
            0
          ],
          [
            5,
            8,
            7
          ],
          [
            0,
            9,
            0
          ]
        ]
      ],
      "expected": 24
    },
    {
      "args": [
        [
          [
            1,
            0,
            7
          ],
          [
            2,
            0,
            6
          ],
          [
            3,
            4,
            5
          ],
          [
            0,
            3,
            0
          ],
          [
            9,
            0,
            20
          ]
        ]
      ],
      "expected": 28
    },
    {
      "args": [
        [
          [
            2,
            3,
            4
          ]
        ]
      ],
      "expected": 9
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          0
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          0,
          1
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          0,
          1
        ],
        [
          0,
          1,
          0
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          1
        ],
        [
          1,
          1
        ]
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1649,
    '串联字符串的最大长度',
    '给定字符串数组 arr
从中选择若干个字符串并按任意顺序拼接，要求拼接结果中每个字母最多出现一次
返回拼接后字符串的最大长度',
    'medium',
    1000,
    256,
    ARRAY['回溯', '位运算', '字符串'],
    $json$[
  {
    "input": "arr = [\"un\", \"iq\", \"ue\"]",
    "output": "4"
  },
  {
    "input": "arr = [\"cha\", \"r\", \"act\", \"ers\"]",
    "output": "6"
  },
  {
    "input": "arr = [\"abcdefghijklmnopqrstuvwxyz\"]",
    "output": "26"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [\"un\", \"iq\", \"ue\"]",
    "output": "4"
  },
  {
    "input": "arr = [\"cha\", \"r\", \"act\", \"ers\"]",
    "output": "6"
  },
  {
    "input": "arr = [\"abcdefghijklmnopqrstuvwxyz\"]",
    "output": "26"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxLength = function(arr) {\n};\n",
  "python": "class Solution:\n    def maxLength(self, arr: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxLength(std::vector<std::string>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxLength(String[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxLength",
  "params": [
    {
      "name": "arr",
      "type": "string[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "un",
          "iq",
          "ue"
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          "cha",
          "r",
          "act",
          "ers"
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          "abcdefghijklmnopqrstuvwxyz"
        ]
      ],
      "expected": 26
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "a"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "aa",
        "bb"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "abc",
        "bcd",
        "cde"
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        "ab",
        "cd",
        "ef"
      ]
    ],
    "expected": 6
  }
]$json$::jsonb,
    'approved'
),
(
    1650,
    '长度为 n 的开心字符串中字典序第 k 小的字符串',
    '开心字符串只包含字母 a、b、c，且相邻字符不能相同
给定长度 n 和整数 k，返回所有长度为 n 的开心字符串中字典序第 k 小的字符串
k 从 1 开始计数，如果开心字符串总数少于 k，返回空字符串',
    'medium',
    1000,
    256,
    ARRAY['回溯', '字符串'],
    $json$[
  {
    "input": "n = 1, k = 3",
    "output": "\"c\""
  },
  {
    "input": "n = 1, k = 4",
    "output": "\"\""
  },
  {
    "input": "n = 3, k = 9",
    "output": "\"cab\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 1, k = 3",
    "output": "\"c\""
  },
  {
    "input": "n = 1, k = 4",
    "output": "\"\""
  },
  {
    "input": "n = 3, k = 9",
    "output": "\"cab\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var getHappyString = function(n, k) {\n};\n",
  "python": "class Solution:\n    def getHappyString(self, n: int, k: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string getHappyString(int n, int k) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String getHappyString(int n, int k) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getHappyString",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        1,
        3
      ],
      "expected": "c"
    },
    {
      "args": [
        1,
        4
      ],
      "expected": ""
    },
    {
      "args": [
        3,
        9
      ],
      "expected": "cab"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      1
    ],
    "expected": "a"
  },
  {
    "args": [
      2,
      1
    ],
    "expected": "ab"
  },
  {
    "args": [
      2,
      3
    ],
    "expected": "ba"
  },
  {
    "args": [
      3,
      1
    ],
    "expected": "aba"
  }
]$json$::jsonb,
    'approved'
),
(
    1651,
    '连续差相同的数字',
    '给定整数 n 和 k
返回所有长度为 n、相邻两位数字之差的绝对值恰好为 k 的整数
数字不能有前导零，n 至少为 2
结果按升序排列',
    'medium',
    1000,
    256,
    ARRAY['回溯', '广度优先搜索'],
    $json$[
  {
    "input": "n = 3, k = 7",
    "output": "[181, 292, 707, 818, 929]"
  },
  {
    "input": "n = 2, k = 1",
    "output": "[10, 12, 21, 23, 32, 34, 43, 45, 54, 56, 65, 67, 76, 78, 87, 89, 98]"
  },
  {
    "input": "n = 2, k = 0",
    "output": "[11, 22, 33, 44, 55, 66, 77, 88, 99]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, k = 7",
    "output": "[181, 292, 707, 818, 929]"
  },
  {
    "input": "n = 2, k = 1",
    "output": "[10, 12, 21, 23, 32, 34, 43, 45, 54, 56, 65, 67, 76, 78, 87, 89, 98]"
  },
  {
    "input": "n = 2, k = 0",
    "output": "[11, 22, 33, 44, 55, 66, 77, 88, 99]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numsSameConsecDiff = function(n, k) {\n};\n",
  "python": "class Solution:\n    def numsSameConsecDiff(self, n: int, k: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> numsSameConsecDiff(int n, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] numsSameConsecDiff(int n, int k) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numsSameConsecDiff",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        3,
        7
      ],
      "expected": [
        181,
        292,
        707,
        818,
        929
      ]
    },
    {
      "args": [
        2,
        1
      ],
      "expected": [
        10,
        12,
        21,
        23,
        32,
        34,
        43,
        45,
        54,
        56,
        65,
        67,
        76,
        78,
        87,
        89,
        98
      ]
    },
    {
      "args": [
        2,
        0
      ],
      "expected": [
        11,
        22,
        33,
        44,
        55,
        66,
        77,
        88,
        99
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      3,
      0
    ],
    "expected": [
      111,
      222,
      333,
      444,
      555,
      666,
      777,
      888,
      999
    ]
  },
  {
    "args": [
      9,
      1
    ],
    "expected": [
      101010101,
      101010121,
      101010123,
      101012101,
      101012121,
      101012123,
      101012321,
      101012323,
      101012343,
      101012345,
      101210101,
      101210121,
      101210123,
      101212101,
      101212121,
      101212123,
      101212321,
      101212323,
      101212343,
      101212345,
      101232101,
      101232121,
      101232123,
      101232321,
      101232323,
      101232343,
      101232345,
      101234321,
      101234323,
      101234343,
      101234345,
      101234543,
      101234545,
      101234565,
      101234567,
      121010101,
      121010121,
      121010123,
      121012101,
      121012121,
      121012123,
      121012321,
      121012323,
      121012343,
      121012345,
      121210101,
      121210121,
      121210123,
      121212101,
      121212121,
      121212123,
      121212321,
      121212323,
      121212343,
      121212345,
      121232101,
      121232121,
      121232123,
      121232321,
      121232323,
      121232343,
      121232345,
      121234321,
      121234323,
      121234343,
      121234345,
      121234543,
      121234545,
      121234565,
      121234567,
      123210101,
      123210121,
      123210123,
      123212101,
      123212121,
      123212123,
      123212321,
      123212323,
      123212343,
      123212345,
      123232101,
      123232121,
      123232123,
      123232321,
      123232323,
      123232343,
      123232345,
      123234321,
      123234323,
      123234343,
      123234345,
      123234543,
      123234545,
      123234565,
      123234567,
      123432101,
      123432121,
      123432123,
      123432321,
      123432323,
      123432343,
      123432345,
      123434321,
      123434323,
      123434343,
      123434345,
      123434543,
      123434545,
      123434565,
      123434567,
      123454321,
      123454323,
      123454343,
      123454345,
      123454543,
      123454545,
      123454565,
      123454567,
      123456543,
      123456545,
      123456565,
      123456567,
      123456765,
      123456767,
      123456787,
      123456789,
      210101010,
      210101012,
      210101210,
      210101212,
      210101232,
      210101234,
      210121010,
      210121012,
      210121210,
      210121212,
      210121232,
      210121234,
      210123210,
      210123212,
      210123232,
      210123234,
      210123432,
      210123434,
      210123454,
      210123456,
      212101010,
      212101012,
      212101210,
      212101212,
      212101232,
      212101234,
      212121010,
      212121012,
      212121210,
      212121212,
      212121232,
      212121234,
      212123210,
      212123212,
      212123232,
      212123234,
      212123432,
      212123434,
      212123454,
      212123456,
      212321010,
      212321012,
      212321210,
      212321212,
      212321232,
      212321234,
      212323210,
      212323212,
      212323232,
      212323234,
      212323432,
      212323434,
      212323454,
      212323456,
      212343210,
      212343212,
      212343232,
      212343234,
      212343432,
      212343434,
      212343454,
      212343456,
      212345432,
      212345434,
      212345454,
      212345456,
      212345654,
      212345656,
      212345676,
      212345678,
      232101010,
      232101012,
      232101210,
      232101212,
      232101232,
      232101234,
      232121010,
      232121012,
      232121210,
      232121212,
      232121232,
      232121234,
      232123210,
      232123212,
      232123232,
      232123234,
      232123432,
      232123434,
      232123454,
      232123456,
      232321010,
      232321012,
      232321210,
      232321212,
      232321232,
      232321234,
      232323210,
      232323212,
      232323232,
      232323234,
      232323432,
      232323434,
      232323454,
      232323456,
      232343210,
      232343212,
      232343232,
      232343234,
      232343432,
      232343434,
      232343454,
      232343456,
      232345432,
      232345434,
      232345454,
      232345456,
      232345654,
      232345656,
      232345676,
      232345678,
      234321010,
      234321012,
      234321210,
      234321212,
      234321232,
      234321234,
      234323210,
      234323212,
      234323232,
      234323234,
      234323432,
      234323434,
      234323454,
      234323456,
      234343210,
      234343212,
      234343232,
      234343234,
      234343432,
      234343434,
      234343454,
      234343456,
      234345432,
      234345434,
      234345454,
      234345456,
      234345654,
      234345656,
      234345676,
      234345678,
      234543210,
      234543212,
      234543232,
      234543234,
      234543432,
      234543434,
      234543454,
      234543456,
      234545432,
      234545434,
      234545454,
      234545456,
      234545654,
      234545656,
      234545676,
      234545678,
      234565432,
      234565434,
      234565454,
      234565456,
      234565654,
      234565656,
      234565676,
      234565678,
      234567654,
      234567656,
      234567676,
      234567678,
      234567876,
      234567878,
      234567898,
      321010101,
      321010121,
      321010123,
      321012101,
      321012121,
      321012123,
      321012321,
      321012323,
      321012343,
      321012345,
      321210101,
      321210121,
      321210123,
      321212101,
      321212121,
      321212123,
      321212321,
      321212323,
      321212343,
      321212345,
      321232101,
      321232121,
      321232123,
      321232321,
      321232323,
      321232343,
      321232345,
      321234321,
      321234323,
      321234343,
      321234345,
      321234543,
      321234545,
      321234565,
      321234567,
      323210101,
      323210121,
      323210123,
      323212101,
      323212121,
      323212123,
      323212321,
      323212323,
      323212343,
      323212345,
      323232101,
      323232121,
      323232123,
      323232321,
      323232323,
      323232343,
      323232345,
      323234321,
      323234323,
      323234343,
      323234345,
      323234543,
      323234545,
      323234565,
      323234567,
      323432101,
      323432121,
      323432123,
      323432321,
      323432323,
      323432343,
      323432345,
      323434321,
      323434323,
      323434343,
      323434345,
      323434543,
      323434545,
      323434565,
      323434567,
      323454321,
      323454323,
      323454343,
      323454345,
      323454543,
      323454545,
      323454565,
      323454567,
      323456543,
      323456545,
      323456565,
      323456567,
      323456765,
      323456767,
      323456787,
      323456789,
      343210101,
      343210121,
      343210123,
      343212101,
      343212121,
      343212123,
      343212321,
      343212323,
      343212343,
      343212345,
      343232101,
      343232121,
      343232123,
      343232321,
      343232323,
      343232343,
      343232345,
      343234321,
      343234323,
      343234343,
      343234345,
      343234543,
      343234545,
      343234565,
      343234567,
      343432101,
      343432121,
      343432123,
      343432321,
      343432323,
      343432343,
      343432345,
      343434321,
      343434323,
      343434343,
      343434345,
      343434543,
      343434545,
      343434565,
      343434567,
      343454321,
      343454323,
      343454343,
      343454345,
      343454543,
      343454545,
      343454565,
      343454567,
      343456543,
      343456545,
      343456565,
      343456567,
      343456765,
      343456767,
      343456787,
      343456789,
      345432101,
      345432121,
      345432123,
      345432321,
      345432323,
      345432343,
      345432345,
      345434321,
      345434323,
      345434343,
      345434345,
      345434543,
      345434545,
      345434565,
      345434567,
      345454321,
      345454323,
      345454343,
      345454345,
      345454543,
      345454545,
      345454565,
      345454567,
      345456543,
      345456545,
      345456565,
      345456567,
      345456765,
      345456767,
      345456787,
      345456789,
      345654321,
      345654323,
      345654343,
      345654345,
      345654543,
      345654545,
      345654565,
      345654567,
      345656543,
      345656545,
      345656565,
      345656567,
      345656765,
      345656767,
      345656787,
      345656789,
      345676543,
      345676545,
      345676565,
      345676567,
      345676765,
      345676767,
      345676787,
      345676789,
      345678765,
      345678767,
      345678787,
      345678789,
      345678987,
      345678989,
      432101010,
      432101012,
      432101210,
      432101212,
      432101232,
      432101234,
      432121010,
      432121012,
      432121210,
      432121212,
      432121232,
      432121234,
      432123210,
      432123212,
      432123232,
      432123234,
      432123432,
      432123434,
      432123454,
      432123456,
      432321010,
      432321012,
      432321210,
      432321212,
      432321232,
      432321234,
      432323210,
      432323212,
      432323232,
      432323234,
      432323432,
      432323434,
      432323454,
      432323456,
      432343210,
      432343212,
      432343232,
      432343234,
      432343432,
      432343434,
      432343454,
      432343456,
      432345432,
      432345434,
      432345454,
      432345456,
      432345654,
      432345656,
      432345676,
      432345678,
      434321010,
      434321012,
      434321210,
      434321212,
      434321232,
      434321234,
      434323210,
      434323212,
      434323232,
      434323234,
      434323432,
      434323434,
      434323454,
      434323456,
      434343210,
      434343212,
      434343232,
      434343234,
      434343432,
      434343434,
      434343454,
      434343456,
      434345432,
      434345434,
      434345454,
      434345456,
      434345654,
      434345656,
      434345676,
      434345678,
      434543210,
      434543212,
      434543232,
      434543234,
      434543432,
      434543434,
      434543454,
      434543456,
      434545432,
      434545434,
      434545454,
      434545456,
      434545654,
      434545656,
      434545676,
      434545678,
      434565432,
      434565434,
      434565454,
      434565456,
      434565654,
      434565656,
      434565676,
      434565678,
      434567654,
      434567656,
      434567676,
      434567678,
      434567876,
      434567878,
      434567898,
      454321010,
      454321012,
      454321210,
      454321212,
      454321232,
      454321234,
      454323210,
      454323212,
      454323232,
      454323234,
      454323432,
      454323434,
      454323454,
      454323456,
      454343210,
      454343212,
      454343232,
      454343234,
      454343432,
      454343434,
      454343454,
      454343456,
      454345432,
      454345434,
      454345454,
      454345456,
      454345654,
      454345656,
      454345676,
      454345678,
      454543210,
      454543212,
      454543232,
      454543234,
      454543432,
      454543434,
      454543454,
      454543456,
      454545432,
      454545434,
      454545454,
      454545456,
      454545654,
      454545656,
      454545676,
      454545678,
      454565432,
      454565434,
      454565454,
      454565456,
      454565654,
      454565656,
      454565676,
      454565678,
      454567654,
      454567656,
      454567676,
      454567678,
      454567876,
      454567878,
      454567898,
      456543210,
      456543212,
      456543232,
      456543234,
      456543432,
      456543434,
      456543454,
      456543456,
      456545432,
      456545434,
      456545454,
      456545456,
      456545654,
      456545656,
      456545676,
      456545678,
      456565432,
      456565434,
      456565454,
      456565456,
      456565654,
      456565656,
      456565676,
      456565678,
      456567654,
      456567656,
      456567676,
      456567678,
      456567876,
      456567878,
      456567898,
      456765432,
      456765434,
      456765454,
      456765456,
      456765654,
      456765656,
      456765676,
      456765678,
      456767654,
      456767656,
      456767676,
      456767678,
      456767876,
      456767878,
      456767898,
      456787654,
      456787656,
      456787676,
      456787678,
      456787876,
      456787878,
      456787898,
      456789876,
      456789878,
      456789898,
      543210101,
      543210121,
      543210123,
      543212101,
      543212121,
      543212123,
      543212321,
      543212323,
      543212343,
      543212345,
      543232101,
      543232121,
      543232123,
      543232321,
      543232323,
      543232343,
      543232345,
      543234321,
      543234323,
      543234343,
      543234345,
      543234543,
      543234545,
      543234565,
      543234567,
      543432101,
      543432121,
      543432123,
      543432321,
      543432323,
      543432343,
      543432345,
      543434321,
      543434323,
      543434343,
      543434345,
      543434543,
      543434545,
      543434565,
      543434567,
      543454321,
      543454323,
      543454343,
      543454345,
      543454543,
      543454545,
      543454565,
      543454567,
      543456543,
      543456545,
      543456565,
      543456567,
      543456765,
      543456767,
      543456787,
      543456789,
      545432101,
      545432121,
      545432123,
      545432321,
      545432323,
      545432343,
      545432345,
      545434321,
      545434323,
      545434343,
      545434345,
      545434543,
      545434545,
      545434565,
      545434567,
      545454321,
      545454323,
      545454343,
      545454345,
      545454543,
      545454545,
      545454565,
      545454567,
      545456543,
      545456545,
      545456565,
      545456567,
      545456765,
      545456767,
      545456787,
      545456789,
      545654321,
      545654323,
      545654343,
      545654345,
      545654543,
      545654545,
      545654565,
      545654567,
      545656543,
      545656545,
      545656565,
      545656567,
      545656765,
      545656767,
      545656787,
      545656789,
      545676543,
      545676545,
      545676565,
      545676567,
      545676765,
      545676767,
      545676787,
      545676789,
      545678765,
      545678767,
      545678787,
      545678789,
      545678987,
      545678989,
      565432101,
      565432121,
      565432123,
      565432321,
      565432323,
      565432343,
      565432345,
      565434321,
      565434323,
      565434343,
      565434345,
      565434543,
      565434545,
      565434565,
      565434567,
      565454321,
      565454323,
      565454343,
      565454345,
      565454543,
      565454545,
      565454565,
      565454567,
      565456543,
      565456545,
      565456565,
      565456567,
      565456765,
      565456767,
      565456787,
      565456789,
      565654321,
      565654323,
      565654343,
      565654345,
      565654543,
      565654545,
      565654565,
      565654567,
      565656543,
      565656545,
      565656565,
      565656567,
      565656765,
      565656767,
      565656787,
      565656789,
      565676543,
      565676545,
      565676565,
      565676567,
      565676765,
      565676767,
      565676787,
      565676789,
      565678765,
      565678767,
      565678787,
      565678789,
      565678987,
      565678989,
      567654321,
      567654323,
      567654343,
      567654345,
      567654543,
      567654545,
      567654565,
      567654567,
      567656543,
      567656545,
      567656565,
      567656567,
      567656765,
      567656767,
      567656787,
      567656789,
      567676543,
      567676545,
      567676565,
      567676567,
      567676765,
      567676767,
      567676787,
      567676789,
      567678765,
      567678767,
      567678787,
      567678789,
      567678987,
      567678989,
      567876543,
      567876545,
      567876565,
      567876567,
      567876765,
      567876767,
      567876787,
      567876789,
      567878765,
      567878767,
      567878787,
      567878789,
      567878987,
      567878989,
      567898765,
      567898767,
      567898787,
      567898789,
      567898987,
      567898989,
      654321010,
      654321012,
      654321210,
      654321212,
      654321232,
      654321234,
      654323210,
      654323212,
      654323232,
      654323234,
      654323432,
      654323434,
      654323454,
      654323456,
      654343210,
      654343212,
      654343232,
      654343234,
      654343432,
      654343434,
      654343454,
      654343456,
      654345432,
      654345434,
      654345454,
      654345456,
      654345654,
      654345656,
      654345676,
      654345678,
      654543210,
      654543212,
      654543232,
      654543234,
      654543432,
      654543434,
      654543454,
      654543456,
      654545432,
      654545434,
      654545454,
      654545456,
      654545654,
      654545656,
      654545676,
      654545678,
      654565432,
      654565434,
      654565454,
      654565456,
      654565654,
      654565656,
      654565676,
      654565678,
      654567654,
      654567656,
      654567676,
      654567678,
      654567876,
      654567878,
      654567898,
      656543210,
      656543212,
      656543232,
      656543234,
      656543432,
      656543434,
      656543454,
      656543456,
      656545432,
      656545434,
      656545454,
      656545456,
      656545654,
      656545656,
      656545676,
      656545678,
      656565432,
      656565434,
      656565454,
      656565456,
      656565654,
      656565656,
      656565676,
      656565678,
      656567654,
      656567656,
      656567676,
      656567678,
      656567876,
      656567878,
      656567898,
      656765432,
      656765434,
      656765454,
      656765456,
      656765654,
      656765656,
      656765676,
      656765678,
      656767654,
      656767656,
      656767676,
      656767678,
      656767876,
      656767878,
      656767898,
      656787654,
      656787656,
      656787676,
      656787678,
      656787876,
      656787878,
      656787898,
      656789876,
      656789878,
      656789898,
      676543210,
      676543212,
      676543232,
      676543234,
      676543432,
      676543434,
      676543454,
      676543456,
      676545432,
      676545434,
      676545454,
      676545456,
      676545654,
      676545656,
      676545676,
      676545678,
      676565432,
      676565434,
      676565454,
      676565456,
      676565654,
      676565656,
      676565676,
      676565678,
      676567654,
      676567656,
      676567676,
      676567678,
      676567876,
      676567878,
      676567898,
      676765432,
      676765434,
      676765454,
      676765456,
      676765654,
      676765656,
      676765676,
      676765678,
      676767654,
      676767656,
      676767676,
      676767678,
      676767876,
      676767878,
      676767898,
      676787654,
      676787656,
      676787676,
      676787678,
      676787876,
      676787878,
      676787898,
      676789876,
      676789878,
      676789898,
      678765432,
      678765434,
      678765454,
      678765456,
      678765654,
      678765656,
      678765676,
      678765678,
      678767654,
      678767656,
      678767676,
      678767678,
      678767876,
      678767878,
      678767898,
      678787654,
      678787656,
      678787676,
      678787678,
      678787876,
      678787878,
      678787898,
      678789876,
      678789878,
      678789898,
      678987654,
      678987656,
      678987676,
      678987678,
      678987876,
      678987878,
      678987898,
      678989876,
      678989878,
      678989898,
      765432101,
      765432121,
      765432123,
      765432321,
      765432323,
      765432343,
      765432345,
      765434321,
      765434323,
      765434343,
      765434345,
      765434543,
      765434545,
      765434565,
      765434567,
      765454321,
      765454323,
      765454343,
      765454345,
      765454543,
      765454545,
      765454565,
      765454567,
      765456543,
      765456545,
      765456565,
      765456567,
      765456765,
      765456767,
      765456787,
      765456789,
      765654321,
      765654323,
      765654343,
      765654345,
      765654543,
      765654545,
      765654565,
      765654567,
      765656543,
      765656545,
      765656565,
      765656567,
      765656765,
      765656767,
      765656787,
      765656789,
      765676543,
      765676545,
      765676565,
      765676567,
      765676765,
      765676767,
      765676787,
      765676789,
      765678765,
      765678767,
      765678787,
      765678789,
      765678987,
      765678989,
      767654321,
      767654323,
      767654343,
      767654345,
      767654543,
      767654545,
      767654565,
      767654567,
      767656543,
      767656545,
      767656565,
      767656567,
      767656765,
      767656767,
      767656787,
      767656789,
      767676543,
      767676545,
      767676565,
      767676567,
      767676765,
      767676767,
      767676787,
      767676789,
      767678765,
      767678767,
      767678787,
      767678789,
      767678987,
      767678989,
      767876543,
      767876545,
      767876565,
      767876567,
      767876765,
      767876767,
      767876787,
      767876789,
      767878765,
      767878767,
      767878787,
      767878789,
      767878987,
      767878989,
      767898765,
      767898767,
      767898787,
      767898789,
      767898987,
      767898989,
      787654321,
      787654323,
      787654343,
      787654345,
      787654543,
      787654545,
      787654565,
      787654567,
      787656543,
      787656545,
      787656565,
      787656567,
      787656765,
      787656767,
      787656787,
      787656789,
      787676543,
      787676545,
      787676565,
      787676567,
      787676765,
      787676767,
      787676787,
      787676789,
      787678765,
      787678767,
      787678787,
      787678789,
      787678987,
      787678989,
      787876543,
      787876545,
      787876565,
      787876567,
      787876765,
      787876767,
      787876787,
      787876789,
      787878765,
      787878767,
      787878787,
      787878789,
      787878987,
      787878989,
      787898765,
      787898767,
      787898787,
      787898789,
      787898987,
      787898989,
      789876543,
      789876545,
      789876565,
      789876567,
      789876765,
      789876767,
      789876787,
      789876789,
      789878765,
      789878767,
      789878787,
      789878789,
      789878987,
      789878989,
      789898765,
      789898767,
      789898787,
      789898789,
      789898987,
      789898989,
      876543210,
      876543212,
      876543232,
      876543234,
      876543432,
      876543434,
      876543454,
      876543456,
      876545432,
      876545434,
      876545454,
      876545456,
      876545654,
      876545656,
      876545676,
      876545678,
      876565432,
      876565434,
      876565454,
      876565456,
      876565654,
      876565656,
      876565676,
      876565678,
      876567654,
      876567656,
      876567676,
      876567678,
      876567876,
      876567878,
      876567898,
      876765432,
      876765434,
      876765454,
      876765456,
      876765654,
      876765656,
      876765676,
      876765678,
      876767654,
      876767656,
      876767676,
      876767678,
      876767876,
      876767878,
      876767898,
      876787654,
      876787656,
      876787676,
      876787678,
      876787876,
      876787878,
      876787898,
      876789876,
      876789878,
      876789898,
      878765432,
      878765434,
      878765454,
      878765456,
      878765654,
      878765656,
      878765676,
      878765678,
      878767654,
      878767656,
      878767676,
      878767678,
      878767876,
      878767878,
      878767898,
      878787654,
      878787656,
      878787676,
      878787678,
      878787876,
      878787878,
      878787898,
      878789876,
      878789878,
      878789898,
      878987654,
      878987656,
      878987676,
      878987678,
      878987876,
      878987878,
      878987898,
      878989876,
      878989878,
      878989898,
      898765432,
      898765434,
      898765454,
      898765456,
      898765654,
      898765656,
      898765676,
      898765678,
      898767654,
      898767656,
      898767676,
      898767678,
      898767876,
      898767878,
      898767898,
      898787654,
      898787656,
      898787676,
      898787678,
      898787876,
      898787878,
      898787898,
      898789876,
      898789878,
      898789898,
      898987654,
      898987656,
      898987676,
      898987678,
      898987876,
      898987878,
      898987898,
      898989876,
      898989878,
      898989898,
      987654321,
      987654323,
      987654343,
      987654345,
      987654543,
      987654545,
      987654565,
      987654567,
      987656543,
      987656545,
      987656565,
      987656567,
      987656765,
      987656767,
      987656787,
      987656789,
      987676543,
      987676545,
      987676565,
      987676567,
      987676765,
      987676767,
      987676787,
      987676789,
      987678765,
      987678767,
      987678787,
      987678789,
      987678987,
      987678989,
      987876543,
      987876545,
      987876565,
      987876567,
      987876765,
      987876767,
      987876787,
      987876789,
      987878765,
      987878767,
      987878787,
      987878789,
      987878987,
      987878989,
      987898765,
      987898767,
      987898787,
      987898789,
      987898987,
      987898989,
      989876543,
      989876545,
      989876565,
      989876567,
      989876765,
      989876767,
      989876787,
      989876789,
      989878765,
      989878767,
      989878787,
      989878789,
      989878987,
      989878989,
      989898765,
      989898767,
      989898787,
      989898789,
      989898987,
      989898989
    ]
  },
  {
    "args": [
      4,
      9
    ],
    "expected": [
      9090
    ]
  },
  {
    "args": [
      5,
      2
    ],
    "expected": [
      13131,
      13135,
      13531,
      13535,
      13575,
      13579,
      20202,
      20242,
      20246,
      24202,
      24242,
      24246,
      24642,
      24646,
      24686,
      31313,
      31353,
      31357,
      35313,
      35353,
      35357,
      35753,
      35757,
      35797,
      42020,
      42024,
      42420,
      42424,
      42464,
      42468,
      46420,
      46424,
      46464,
      46468,
      46864,
      46868,
      53131,
      53135,
      53531,
      53535,
      53575,
      53579,
      57531,
      57535,
      57575,
      57579,
      57975,
      57979,
      64202,
      64242,
      64246,
      64642,
      64646,
      64686,
      68642,
      68646,
      68686,
      75313,
      75353,
      75357,
      75753,
      75757,
      75797,
      79753,
      79757,
      79797,
      86420,
      86424,
      86464,
      86468,
      86864,
      86868,
      97531,
      97535,
      97575,
      97579,
      97975,
      97979
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1652,
    '划分字母区间',
    '给定由小写字母组成的字符串 s
把字符串划分成尽可能多的片段，使每个字母最多出现在一个片段中
返回各片段的长度，按片段从左到右的顺序排列',
    'medium',
    1000,
    256,
    ARRAY['贪心', '哈希表', '字符串'],
    $json$[
  {
    "input": "s = \"ababcbacadefegdehijhklij\"",
    "output": "[9, 7, 8]"
  },
  {
    "input": "s = \"eccbbbbdec\"",
    "output": "[10]"
  },
  {
    "input": "s = \"abc\"",
    "output": "[1, 1, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"ababcbacadefegdehijhklij\"",
    "output": "[9, 7, 8]"
  },
  {
    "input": "s = \"eccbbbbdec\"",
    "output": "[10]"
  },
  {
    "input": "s = \"abc\"",
    "output": "[1, 1, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var partitionLabels = function(s) {\n};\n",
  "python": "class Solution:\n    def partitionLabels(self, s: str) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> partitionLabels(std::string s) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] partitionLabels(String s) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "partitionLabels",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "ababcbacadefegdehijhklij"
      ],
      "expected": [
        9,
        7,
        8
      ]
    },
    {
      "args": [
        "eccbbbbdec"
      ],
      "expected": [
        10
      ]
    },
    {
      "args": [
        "abc"
      ],
      "expected": [
        1,
        1,
        1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a"
    ],
    "expected": [
      1
    ]
  },
  {
    "args": [
      "aaaa"
    ],
    "expected": [
      4
    ]
  },
  {
    "args": [
      "abac"
    ],
    "expected": [
      3,
      1
    ]
  },
  {
    "args": [
      "caedbdedda"
    ],
    "expected": [
      1,
      9
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1653,
    '两地调度',
    '有 2n 个人需要前往 A、B 两个城市，每个城市恰好安排 n 人
第 i 个人去 A 市的费用为 costs[i][0]，去 B 市的费用为 costs[i][1]
返回安排所有人所需的最小总费用',
    'medium',
    1000,
    256,
    ARRAY['贪心', '排序'],
    $json$[
  {
    "input": "costs = [[10, 20], [30, 200], [400, 50], [30, 20]]",
    "output": "110"
  },
  {
    "input": "costs = [[259, 770], [448, 54], [926, 667], [184, 139], [840, 118], [577, 469]]",
    "output": "1859"
  },
  {
    "input": "costs = [[0, 0], [0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "costs = [[10, 20], [30, 200], [400, 50], [30, 20]]",
    "output": "110"
  },
  {
    "input": "costs = [[259, 770], [448, 54], [926, 667], [184, 139], [840, 118], [577, 469]]",
    "output": "1859"
  },
  {
    "input": "costs = [[0, 0], [0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var twoCitySchedCost = function(costs) {\n};\n",
  "python": "class Solution:\n    def twoCitySchedCost(self, costs: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int twoCitySchedCost(std::vector<std::vector<int>>& costs) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int twoCitySchedCost(int[][] costs) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "twoCitySchedCost",
  "params": [
    {
      "name": "costs",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            10,
            20
          ],
          [
            30,
            200
          ],
          [
            400,
            50
          ],
          [
            30,
            20
          ]
        ]
      ],
      "expected": 110
    },
    {
      "args": [
        [
          [
            259,
            770
          ],
          [
            448,
            54
          ],
          [
            926,
            667
          ],
          [
            184,
            139
          ],
          [
            840,
            118
          ],
          [
            577,
            469
          ]
        ]
      ],
      "expected": 1859
    },
    {
      "args": [
        [
          [
            0,
            0
          ],
          [
            0,
            0
          ]
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          2,
          1
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          100,
          1
        ],
        [
          1,
          100
        ],
        [
          50,
          50
        ],
        [
          50,
          50
        ]
      ]
    ],
    "expected": 102
  },
  {
    "args": [
      [
        [
          10,
          10
        ],
        [
          20,
          20
        ]
      ]
    ],
    "expected": 30
  },
  {
    "args": [
      [
        [
          0,
          100
        ],
        [
          100,
          0
        ],
        [
          50,
          60
        ],
        [
          60,
          50
        ]
      ]
    ],
    "expected": 100
  }
]$json$::jsonb,
    'approved'
),
(
    1654,
    '救生艇',
    '给定每个人的体重数组 people 和每艘船的最大载重 limit
每艘船最多载两人，且两人体重之和不能超过 limit
返回运送所有人所需的最少船数',
    'medium',
    1000,
    256,
    ARRAY['贪心', '双指针', '排序'],
    $json$[
  {
    "input": "people = [1, 2], limit = 3",
    "output": "1"
  },
  {
    "input": "people = [3, 2, 2, 1], limit = 3",
    "output": "3"
  },
  {
    "input": "people = [3, 5, 3, 4], limit = 5",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "people = [1, 2], limit = 3",
    "output": "1"
  },
  {
    "input": "people = [3, 2, 2, 1], limit = 3",
    "output": "3"
  },
  {
    "input": "people = [3, 5, 3, 4], limit = 5",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numRescueBoats = function(people, limit) {\n};\n",
  "python": "class Solution:\n    def numRescueBoats(self, people: list[int], limit: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numRescueBoats(std::vector<int>& people, int limit) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numRescueBoats(int[] people, int limit) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numRescueBoats",
  "params": [
    {
      "name": "people",
      "type": "int[]"
    },
    {
      "name": "limit",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2
        ],
        3
      ],
      "expected": 1
    },
    {
      "args": [
        [
          3,
          2,
          2,
          1
        ],
        3
      ],
      "expected": 3
    },
    {
      "args": [
        [
          3,
          5,
          3,
          4
        ],
        5
      ],
      "expected": 4
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ],
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        1
      ],
      2
    ],
    "expected": 1
  },
  {
    "args": [
      [
        3,
        3,
        3
      ],
      3
    ],
    "expected": 3
  },
  {
    "args": [
      [
        2,
        2,
        2,
        2
      ],
      4
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1655,
    '递减元素使数组呈锯齿状',
    '给定整数数组 nums，每次操作可以把任意一个元素减 1
锯齿状数组要求相邻元素的大小关系交替，即 nums[0] < nums[1] > nums[2] < ... 或 nums[0] > nums[1] < nums[2] > ...
返回使数组成为锯齿状数组所需的最少操作次数',
    'medium',
    1000,
    256,
    ARRAY['贪心', '数组'],
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "2"
  },
  {
    "input": "nums = [9, 6, 1, 6, 2]",
    "output": "4"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "2"
  },
  {
    "input": "nums = [9, 6, 1, 6, 2]",
    "output": "4"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var movesToMakeZigzag = function(nums) {\n};\n",
  "python": "class Solution:\n    def movesToMakeZigzag(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int movesToMakeZigzag(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int movesToMakeZigzag(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "movesToMakeZigzag",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          3
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          9,
          6,
          1,
          6,
          2
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        2,
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        2,
        1,
        2,
        3
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        10,
        5,
        9,
        2,
        8
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1656,
    '交换字符使得字符串相同',
    '给定两个等长字符串 s1 和 s2，它们只包含字符 x 和 y
每次操作可以交换 s1 中的一个字符与 s2 中的一个字符，两个字符的下标可以不同
返回使 s1 和 s2 相等的最少交换次数，无法做到则返回 -1',
    'medium',
    1000,
    256,
    ARRAY['贪心', '字符串'],
    $json$[
  {
    "input": "s1 = \"xx\", s2 = \"yy\"",
    "output": "1"
  },
  {
    "input": "s1 = \"xy\", s2 = \"yx\"",
    "output": "2"
  },
  {
    "input": "s1 = \"xx\", s2 = \"xy\"",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s1 = \"xx\", s2 = \"yy\"",
    "output": "1"
  },
  {
    "input": "s1 = \"xy\", s2 = \"yx\"",
    "output": "2"
  },
  {
    "input": "s1 = \"xx\", s2 = \"xy\"",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumSwap = function(s1, s2) {\n};\n",
  "python": "class Solution:\n    def minimumSwap(self, s1: str, s2: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumSwap(std::string s1, std::string s2) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumSwap(String s1, String s2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumSwap",
  "params": [
    {
      "name": "s1",
      "type": "string"
    },
    {
      "name": "s2",
      "type": "string"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "xx",
        "yy"
      ],
      "expected": 1
    },
    {
      "args": [
        "xy",
        "yx"
      ],
      "expected": 2
    },
    {
      "args": [
        "xx",
        "xy"
      ],
      "expected": -1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "x",
      "x"
    ],
    "expected": 0
  },
  {
    "args": [
      "x",
      "y"
    ],
    "expected": -1
  },
  {
    "args": [
      "xx",
      "yx"
    ],
    "expected": -1
  },
  {
    "args": [
      "xxxx",
      "yyyy"
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1657,
    '删除被覆盖区间',
    '给定区间数组 intervals，intervals[i] = [start, end]
如果区间 [a, b] 被区间 [c, d] 完全覆盖，即 c <= a 且 b <= d，则删除 [a, b]
两个相同的区间视为一个覆盖另一个
返回删除后剩余的区间数目',
    'medium',
    1000,
    256,
    ARRAY['贪心', '排序', '区间'],
    $json$[
  {
    "input": "intervals = [[1, 4], [3, 6], [2, 8]]",
    "output": "2"
  },
  {
    "input": "intervals = [[1, 4], [2, 3]]",
    "output": "1"
  },
  {
    "input": "intervals = [[0, 10], [5, 12]]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "intervals = [[1, 4], [3, 6], [2, 8]]",
    "output": "2"
  },
  {
    "input": "intervals = [[1, 4], [2, 3]]",
    "output": "1"
  },
  {
    "input": "intervals = [[0, 10], [5, 12]]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeCoveredIntervals = function(intervals) {\n};\n",
  "python": "class Solution:\n    def removeCoveredIntervals(self, intervals: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int removeCoveredIntervals(std::vector<std::vector<int>>& intervals) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int removeCoveredIntervals(int[][] intervals) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeCoveredIntervals",
  "params": [
    {
      "name": "intervals",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            4
          ],
          [
            3,
            6
          ],
          [
            2,
            8
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            1,
            4
          ],
          [
            2,
            3
          ]
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          [
            0,
            10
          ],
          [
            5,
            12
          ]
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          1,
          4
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          4
        ],
        [
          2,
          3
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          4
        ],
        [
          1,
          4
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          2,
          3
        ],
        [
          1,
          2
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1658,
    '数组大小减半',
    '给定整数数组 arr
可以选择一组整数并从数组中删除它们的全部出现
返回使剩余元素数量不超过原数组长度一半所需删除的最少整数个数',
    'medium',
    1000,
    256,
    ARRAY['贪心', '哈希表', '排序'],
    $json$[
  {
    "input": "arr = [3, 3, 3, 3, 5, 5, 5, 2, 2, 7]",
    "output": "2"
  },
  {
    "input": "arr = [7, 7, 7, 7, 7, 7]",
    "output": "1"
  },
  {
    "input": "arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [3, 3, 3, 3, 5, 5, 5, 2, 2, 7]",
    "output": "2"
  },
  {
    "input": "arr = [7, 7, 7, 7, 7, 7]",
    "output": "1"
  },
  {
    "input": "arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minSetSize = function(arr) {\n};\n",
  "python": "class Solution:\n    def minSetSize(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minSetSize(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minSetSize(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minSetSize",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          3,
          3,
          3,
          3,
          5,
          5,
          5,
          2,
          2,
          7
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          7,
          7,
          7,
          7,
          7,
          7
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10
        ]
      ],
      "expected": 5
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        1,
        2,
        2,
        3,
        3
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        9,
        9,
        9,
        9,
        9,
        9,
        9,
        9,
        9,
        9
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1659,
    '最多可以参加的会议数目',
    '给定会议数组 events，events[i] = [startDay, endDay]
表示第 i 个会议可以在 startDay 到 endDay 之间的任意一天参加
每天最多参加一个会议，同一个会议只能参加一次
返回最多可以参加的会议数目',
    'medium',
    1000,
    256,
    ARRAY['贪心', '堆', '排序'],
    $json$[
  {
    "input": "events = [[1, 2], [2, 3], [3, 4]]",
    "output": "3"
  },
  {
    "input": "events = [[1, 2], [1, 2], [2, 3], [3, 4]]",
    "output": "4"
  },
  {
    "input": "events = [[1, 1], [1, 2], [1, 3]]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "events = [[1, 2], [2, 3], [3, 4]]",
    "output": "3"
  },
  {
    "input": "events = [[1, 2], [1, 2], [2, 3], [3, 4]]",
    "output": "4"
  },
  {
    "input": "events = [[1, 1], [1, 2], [1, 3]]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxEvents = function(events) {\n};\n",
  "python": "class Solution:\n    def maxEvents(self, events: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxEvents(std::vector<std::vector<int>>& events) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxEvents(int[][] events) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxEvents",
  "params": [
    {
      "name": "events",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            2,
            3
          ],
          [
            3,
            4
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            1,
            2
          ],
          [
            2,
            3
          ],
          [
            3,
            4
          ]
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          [
            1,
            1
          ],
          [
            1,
            2
          ],
          [
            1,
            3
          ]
        ]
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          1
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          3
        ],
        [
          2,
          3
        ],
        [
          3,
          3
        ]
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          1,
          2
        ],
        [
          1,
          2
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          1,
          5
        ],
        [
          2,
          3
        ],
        [
          2,
          3
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1660,
    '地下城游戏',
    '给定一个 m x n 的整数矩阵 dungeon，表示地下城的房间。骑士从左上角 (0, 0) 出发，每次只能向右或向下移动，最终到达右下角 (m-1, n-1) 救出公主。
矩阵中的数值含义：负数表示进入该房间失去相应生命值，正数表示获得相应生命值，0 表示没有变化。骑士在任意时刻的生命值必须严格大于 0，否则立即死亡。
返回骑士能够完成旅程所需的最小初始生命值。',
    'hard',
    1000,
    256,
    ARRAY['动态规划', '矩阵'],
    $json$[
  {
    "input": "dungeon = [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]",
    "output": "7"
  },
  {
    "input": "dungeon = [[0]]",
    "output": "1"
  },
  {
    "input": "dungeon = [[1, -3, 3], [-3, -3, -3], [3, -3, 0]]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "dungeon = [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]",
    "output": "7"
  },
  {
    "input": "dungeon = [[0]]",
    "output": "1"
  },
  {
    "input": "dungeon = [[1, -3, 3], [-3, -3, -3], [3, -3, 0]]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var calculateMinimumHP = function(dungeon) {\n};\n",
  "python": "class Solution:\n    def calculateMinimumHP(self, dungeon: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int calculateMinimumHP(std::vector<std::vector<int>>& dungeon) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int calculateMinimumHP(int[][] dungeon) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "calculateMinimumHP",
  "params": [
    {
      "name": "dungeon",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            -2,
            -3,
            3
          ],
          [
            -5,
            -10,
            1
          ],
          [
            10,
            30,
            -5
          ]
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        [
          [
            0
          ]
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          [
            1,
            -3,
            3
          ],
          [
            -3,
            -3,
            -3
          ],
          [
            3,
            -3,
            0
          ]
        ]
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          -3
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          2
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          -1,
          -2
        ],
        [
          -3,
          -4
        ]
      ]
    ],
    "expected": 8
  },
  {
    "args": [
      [
        [
          0,
          -1
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          1,
          -2,
          3
        ],
        [
          2,
          -2,
          -2
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          -2,
          -3
        ],
        [
          -4,
          -5
        ]
      ]
    ],
    "expected": 11
  }
]$json$::jsonb,
    'approved'
),
(
    1661,
    '按要求补齐数组',
    '给定一个按升序排列的正整数数组 nums 和一个正整数 n。每个数组元素最多使用一次，可以任取子集求和。
如果 [1, n] 内的某些整数无法由当前数组表示，可以向数组中添加任意正整数。返回使 [1, n] 内所有整数都能被表示所需添加的最少元素个数。',
    'hard',
    1000,
    256,
    ARRAY['贪心', '数组'],
    $json$[
  {
    "input": "nums = [1, 3], n = 6",
    "output": "1"
  },
  {
    "input": "nums = [1, 5, 10], n = 20",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 2], n = 5",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3], n = 6",
    "output": "1"
  },
  {
    "input": "nums = [1, 5, 10], n = 20",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 2], n = 5",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minPatches = function(nums, n) {\n};\n",
  "python": "class Solution:\n    def minPatches(self, nums: list[int], n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minPatches(std::vector<int>& nums, int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minPatches(int[] nums, int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minPatches",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          3
        ],
        6
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          5,
          10
        ],
        20
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1,
          2,
          2
        ],
        5
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ],
      2
    ],
    "expected": 1
  },
  {
    "args": [
      [
        2
      ],
      3
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2,
        4,
        13,
        43
      ],
      100
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        2,
        2
      ],
      7
    ],
    "expected": 1
  },
  {
    "args": [
      [
        100
      ],
      50
    ],
    "expected": 6
  },
  {
    "args": [
      [
        1,
        2,
        31,
        33
      ],
      100
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1662,
    '矩形区域不超过 K 的最大数值和',
    '给定一个 m x n 的整数矩阵 matrix 和一个整数 k。要求选出矩阵中一个至少包含一个元素的矩形区域，使其元素和不超过 k 且尽可能大。
返回这个最大元素和。数据保证至少存在一个元素和不超过 k 的矩形区域。',
    'hard',
    1000,
    256,
    ARRAY['数组', '前缀和', '二分查找'],
    $json$[
  {
    "input": "matrix = [[1, 0, 1], [0, -2, 3]], k = 2",
    "output": "2"
  },
  {
    "input": "matrix = [[2, 2, -1]], k = 3",
    "output": "3"
  },
  {
    "input": "matrix = [[1]], k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 0, 1], [0, -2, 3]], k = 2",
    "output": "2"
  },
  {
    "input": "matrix = [[2, 2, -1]], k = 3",
    "output": "3"
  },
  {
    "input": "matrix = [[1]], k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxSumSubmatrix = function(matrix, k) {\n};\n",
  "python": "class Solution:\n    def maxSumSubmatrix(self, matrix: list[list[int]], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxSumSubmatrix(std::vector<std::vector<int>>& matrix, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxSumSubmatrix(int[][] matrix, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxSumSubmatrix",
  "params": [
    {
      "name": "matrix",
      "type": "int[][]"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            0,
            1
          ],
          [
            0,
            -2,
            3
          ]
        ],
        2
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            2,
            2,
            -1
          ]
        ],
        3
      ],
      "expected": 3
    },
    {
      "args": [
        [
          [
            1
          ]
        ],
        1
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          -2,
          -3
        ]
      ],
      3
    ],
    "expected": -2
  },
  {
    "args": [
      [
        [
          2,
          2,
          -1
        ]
      ],
      0
    ],
    "expected": -1
  },
  {
    "args": [
      [
        [
          5,
          -4
        ],
        [
          -3,
          2
        ]
      ],
      2
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          -2,
          3
        ]
      ],
      2
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          -1,
          -2
        ],
        [
          -3,
          -4
        ]
      ],
      -3
    ],
    "expected": -3
  },
  {
    "args": [
      [
        [
          2,
          -2
        ],
        [
          -2,
          2
        ]
      ],
      0
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1663,
    '完美矩形',
    '给定整数数组 rectangles，其中 rectangles[i] = [x1, y1, x2, y2] 表示一个左下角为 (x1, y1)、右上角为 (x2, y2) 的矩形。
判断这些矩形能否恰好覆盖一个完整的矩形区域，要求区域内部既没有重叠也没有空隙。能恰好覆盖返回 true，否则返回 false。',
    'hard',
    1000,
    256,
    ARRAY['几何', '哈希表'],
    $json$[
  {
    "input": "rectangles = [[0, 0, 1, 1], [1, 0, 2, 1], [0, 1, 1, 2], [1, 1, 2, 2]]",
    "output": "true"
  },
  {
    "input": "rectangles = [[0, 0, 3, 1], [0, 1, 3, 2], [0, 2, 3, 3]]",
    "output": "true"
  },
  {
    "input": "rectangles = [[0, 0, 1, 1], [1, 0, 2, 1], [0, 1, 1, 2]]",
    "output": "false"
  },
  {
    "input": "rectangles = [[0, 0, 2, 2], [0, 0, 1, 1], [1, 1, 2, 2]]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "rectangles = [[0, 0, 1, 1], [1, 0, 2, 1], [0, 1, 1, 2], [1, 1, 2, 2]]",
    "output": "true"
  },
  {
    "input": "rectangles = [[0, 0, 3, 1], [0, 1, 3, 2], [0, 2, 3, 3]]",
    "output": "true"
  },
  {
    "input": "rectangles = [[0, 0, 1, 1], [1, 0, 2, 1], [0, 1, 1, 2]]",
    "output": "false"
  },
  {
    "input": "rectangles = [[0, 0, 2, 2], [0, 0, 1, 1], [1, 1, 2, 2]]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isRectangleCover = function(rectangles) {\n};\n",
  "python": "class Solution:\n    def isRectangleCover(self, rectangles: list[list[int]]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isRectangleCover(std::vector<std::vector<int>>& rectangles) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isRectangleCover(int[][] rectangles) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isRectangleCover",
  "params": [
    {
      "name": "rectangles",
      "type": "int[][]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            0,
            0,
            1,
            1
          ],
          [
            1,
            0,
            2,
            1
          ],
          [
            0,
            1,
            1,
            2
          ],
          [
            1,
            1,
            2,
            2
          ]
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          [
            0,
            0,
            3,
            1
          ],
          [
            0,
            1,
            3,
            2
          ],
          [
            0,
            2,
            3,
            3
          ]
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          [
            0,
            0,
            1,
            1
          ],
          [
            1,
            0,
            2,
            1
          ],
          [
            0,
            1,
            1,
            2
          ]
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          [
            0,
            0,
            2,
            2
          ],
          [
            0,
            0,
            1,
            1
          ],
          [
            1,
            1,
            2,
            2
          ]
        ]
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          0,
          0,
          1,
          1
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          0,
          0,
          1,
          1
        ],
        [
          0,
          0,
          1,
          1
        ]
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        [
          0,
          0,
          1,
          2
        ],
        [
          1,
          0,
          2,
          2
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          0,
          0,
          1,
          1
        ],
        [
          1,
          0,
          2,
          1
        ],
        [
          0,
          1,
          2,
          2
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          1,
          1,
          3,
          3
        ],
        [
          1,
          1,
          3,
          3
        ]
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1664,
    '可怜的小猪',
    '有 buckets 桶液体，其中恰好一桶有毒，其余无毒。你可以在 minutesToTest 分钟内进行若干轮测试，每轮测试中每只猪可以饮用任意多桶液体，也可以将多桶液体混合后饮用。
猪一旦饮下毒液，会在 minutesToDie 分钟后死亡。保证 minutesToTest 不小于 minutesToDie。
返回在限定时间内确定哪一桶有毒所需的最少猪的数量。',
    'hard',
    1000,
    256,
    ARRAY['数学', '思维'],
    $json$[
  {
    "input": "buckets = 1000, minutesToDie = 15, minutesToTest = 60",
    "output": "5"
  },
  {
    "input": "buckets = 4, minutesToDie = 15, minutesToTest = 15",
    "output": "2"
  },
  {
    "input": "buckets = 4, minutesToDie = 15, minutesToTest = 30",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "buckets = 1000, minutesToDie = 15, minutesToTest = 60",
    "output": "5"
  },
  {
    "input": "buckets = 4, minutesToDie = 15, minutesToTest = 15",
    "output": "2"
  },
  {
    "input": "buckets = 4, minutesToDie = 15, minutesToTest = 30",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var poorPigs = function(buckets, minutesToDie, minutesToTest) {\n};\n",
  "python": "class Solution:\n    def poorPigs(self, buckets: int, minutesToDie: int, minutesToTest: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int poorPigs(int buckets, int minutesToDie, int minutesToTest) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int poorPigs(int buckets, int minutesToDie, int minutesToTest) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "poorPigs",
  "params": [
    {
      "name": "buckets",
      "type": "int"
    },
    {
      "name": "minutesToDie",
      "type": "int"
    },
    {
      "name": "minutesToTest",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        1000,
        15,
        60
      ],
      "expected": 5
    },
    {
      "args": [
        4,
        15,
        15
      ],
      "expected": 2
    },
    {
      "args": [
        4,
        15,
        30
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      1,
      1
    ],
    "expected": 0
  },
  {
    "args": [
      2,
      1,
      1
    ],
    "expected": 1
  },
  {
    "args": [
      125,
      1,
      4
    ],
    "expected": 3
  },
  {
    "args": [
      100,
      1,
      2
    ],
    "expected": 5
  },
  {
    "args": [
      10,
      1,
      10
    ],
    "expected": 1
  },
  {
    "args": [
      1000,
      1,
      1
    ],
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1665,
    '连接词',
    '给定一个不含重复单词的字符串数组 words。若某个单词可以完全拆分成数组中另外两个或更多单词的连接，其中每个单词可以使用任意多次，则称它为连接词。
返回 words 中所有连接词，按字典序升序排列。',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划', '字典树'],
    $json$[
  {
    "input": "words = [\"cat\", \"cats\", \"catsdogcats\", \"dog\", \"dogcatsdog\", \"hippopotamuses\", \"rat\", \"ratcatdogcat\"]",
    "output": "[\"catsdogcats\", \"dogcatsdog\", \"ratcatdogcat\"]"
  },
  {
    "input": "words = [\"cat\", \"dog\", \"catdog\"]",
    "output": "[\"catdog\"]"
  },
  {
    "input": "words = [\"a\", \"b\", \"ab\", \"abc\"]",
    "output": "[\"ab\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"cat\", \"cats\", \"catsdogcats\", \"dog\", \"dogcatsdog\", \"hippopotamuses\", \"rat\", \"ratcatdogcat\"]",
    "output": "[\"catsdogcats\", \"dogcatsdog\", \"ratcatdogcat\"]"
  },
  {
    "input": "words = [\"cat\", \"dog\", \"catdog\"]",
    "output": "[\"catdog\"]"
  },
  {
    "input": "words = [\"a\", \"b\", \"ab\", \"abc\"]",
    "output": "[\"ab\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findAllConcatenatedWords = function(words) {\n};\n",
  "python": "class Solution:\n    def findAllConcatenatedWords(self, words: list[str]) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> findAllConcatenatedWords(std::vector<std::string>& words) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] findAllConcatenatedWords(String[] words) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findAllConcatenatedWords",
  "params": [
    {
      "name": "words",
      "type": "string[]"
    }
  ],
  "return_type": "string[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "cat",
          "cats",
          "catsdogcats",
          "dog",
          "dogcatsdog",
          "hippopotamuses",
          "rat",
          "ratcatdogcat"
        ]
      ],
      "expected": [
        "catsdogcats",
        "dogcatsdog",
        "ratcatdogcat"
      ]
    },
    {
      "args": [
        [
          "cat",
          "dog",
          "catdog"
        ]
      ],
      "expected": [
        "catdog"
      ]
    },
    {
      "args": [
        [
          "a",
          "b",
          "ab",
          "abc"
        ]
      ],
      "expected": [
        "ab"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "a"
      ]
    ],
    "expected": []
  },
  {
    "args": [
      [
        "a",
        "aa",
        "aaa"
      ]
    ],
    "expected": [
      "aa",
      "aaa"
    ]
  },
  {
    "args": [
      [
        "a",
        "b",
        "c",
        "ab",
        "bc",
        "abc"
      ]
    ],
    "expected": [
      "ab",
      "abc",
      "bc"
    ]
  },
  {
    "args": [
      [
        "x",
        "xy",
        "xyz"
      ]
    ],
    "expected": []
  },
  {
    "args": [
      [
        "a",
        "aa",
        "aab"
      ]
    ],
    "expected": [
      "aa"
    ]
  },
  {
    "args": [
      [
        "ab",
        "abc",
        "abcd",
        "a",
        "b",
        "c",
        "d"
      ]
    ],
    "expected": [
      "ab",
      "abc",
      "abcd"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1666,
    '最大回文数乘积',
    '给定整数 n，返回由两个 n 位正整数相乘能够得到的最大的回文整数。
结果返回精确值，不取模。n 的取值范围是 1 到 7。',
    'hard',
    1000,
    256,
    ARRAY['数学', '枚举'],
    $json$[
  {
    "input": "n = 1",
    "output": "9"
  },
  {
    "input": "n = 2",
    "output": "9009"
  },
  {
    "input": "n = 3",
    "output": "906609"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 1",
    "output": "9"
  },
  {
    "input": "n = 2",
    "output": "9009"
  },
  {
    "input": "n = 3",
    "output": "906609"
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestPalindromeProduct = function(n) {\n};\n",
  "python": "class Solution:\n    def largestPalindromeProduct(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long largestPalindromeProduct(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long largestPalindromeProduct(int n) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestPalindromeProduct",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "long",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        1
      ],
      "expected": 9
    },
    {
      "args": [
        2
      ],
      "expected": 9009
    },
    {
      "args": [
        3
      ],
      "expected": 906609
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      4
    ],
    "expected": 99000099
  },
  {
    "args": [
      5
    ],
    "expected": 9966006699
  },
  {
    "args": [
      6
    ],
    "expected": 999000000999
  },
  {
    "args": [
      7
    ],
    "expected": 99956644665999
  }
]$json$::jsonb,
    'approved'
),
(
    1667,
    '项目资本最大化',
    '给定最多可选择的项目数 k、初始资本 w、每个项目的利润 profits[i] 和启动该项目所需的最低资本 capital[i]。
每完成一个项目，其利润会累加到当前资本中。项目可以按任意顺序选择，但每个项目最多完成一次，且选择时当前资本必须不少于该项目的启动资本。
返回最多完成 k 个项目后能获得的最大资本。',
    'hard',
    1000,
    256,
    ARRAY['贪心', '堆', '排序'],
    $json$[
  {
    "input": "k = 2, w = 0, profits = [1, 2, 3], capital = [0, 1, 1]",
    "output": "4"
  },
  {
    "input": "k = 3, w = 0, profits = [1, 2, 3], capital = [0, 1, 2]",
    "output": "6"
  },
  {
    "input": "k = 2, w = 1, profits = [3, 4], capital = [1, 2]",
    "output": "8"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "k = 2, w = 0, profits = [1, 2, 3], capital = [0, 1, 1]",
    "output": "4"
  },
  {
    "input": "k = 3, w = 0, profits = [1, 2, 3], capital = [0, 1, 2]",
    "output": "6"
  },
  {
    "input": "k = 2, w = 1, profits = [3, 4], capital = [1, 2]",
    "output": "8"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findMaximizedCapital = function(k, w, profits, capital) {\n};\n",
  "python": "class Solution:\n    def findMaximizedCapital(self, k: int, w: int, profits: list[int], capital: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findMaximizedCapital(int k, int w, std::vector<int>& profits, std::vector<int>& capital) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findMaximizedCapital(int k, int w, int[] profits, int[] capital) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findMaximizedCapital",
  "params": [
    {
      "name": "k",
      "type": "int"
    },
    {
      "name": "w",
      "type": "int"
    },
    {
      "name": "profits",
      "type": "int[]"
    },
    {
      "name": "capital",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        2,
        0,
        [
          1,
          2,
          3
        ],
        [
          0,
          1,
          1
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        3,
        0,
        [
          1,
          2,
          3
        ],
        [
          0,
          1,
          2
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        2,
        1,
        [
          3,
          4
        ],
        [
          1,
          2
        ]
      ],
      "expected": 8
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      2,
      [
        5
      ],
      [
        3
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      1,
      0,
      [
        1
      ],
      [
        2
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      2,
      0,
      [
        1,
        2
      ],
      [
        0,
        0
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      10,
      5,
      [
        2,
        3
      ],
      [
        0,
        0
      ]
    ],
    "expected": 10
  },
  {
    "args": [
      3,
      0,
      [
        1,
        1,
        1
      ],
      [
        0,
        1,
        2
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      0,
      5,
      [
        1,
        2,
        3
      ],
      [
        0,
        0,
        0
      ]
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1668,
    '自由之路',
    '圆环上按顺时针方向排列着字符串 ring 中的字符，第一个字符与最后一个字符相邻。指针初始指向 ring 的第一个字符。
每一步可以将圆环顺时针或逆时针旋转一格，或者按下按钮输入指针当前指向的字符。给定目标字符串 key，返回按顺序输入整个 key 所需的最少步数，按一次按钮计 1 步。',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "ring = \"godding\", key = \"gd\"",
    "output": "4"
  },
  {
    "input": "ring = \"godding\", key = \"godding\"",
    "output": "13"
  },
  {
    "input": "ring = \"abc\", key = \"abc\"",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "ring = \"godding\", key = \"gd\"",
    "output": "4"
  },
  {
    "input": "ring = \"godding\", key = \"godding\"",
    "output": "13"
  },
  {
    "input": "ring = \"abc\", key = \"abc\"",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findRotateSteps = function(ring, key) {\n};\n",
  "python": "class Solution:\n    def findRotateSteps(self, ring: str, key: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findRotateSteps(std::string ring, std::string key) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findRotateSteps(String ring, String key) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findRotateSteps",
  "params": [
    {
      "name": "ring",
      "type": "string"
    },
    {
      "name": "key",
      "type": "string"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "godding",
        "gd"
      ],
      "expected": 4
    },
    {
      "args": [
        "godding",
        "godding"
      ],
      "expected": 13
    },
    {
      "args": [
        "abc",
        "abc"
      ],
      "expected": 5
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      "a"
    ],
    "expected": 1
  },
  {
    "args": [
      "abcde",
      "ade"
    ],
    "expected": 6
  },
  {
    "args": [
      "godding",
      "dog"
    ],
    "expected": 7
  },
  {
    "args": [
      "aaa",
      "aaaa"
    ],
    "expected": 4
  },
  {
    "args": [
      "abcabc",
      "abc"
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1669,
    '超级洗衣机',
    '有 n 台超级洗衣机排成一排，第 i 台初始有 machines[i] 件衣服。
每一步可以选择任意多台洗衣机，每台向其相邻的一台洗衣机传递一件衣服；同一台洗衣机在一步内最多送出一件衣服。
通过若干步使所有洗衣机的衣服数量相等，返回所需的最少步数。无法做到时返回 -1。',
    'hard',
    1000,
    256,
    ARRAY['贪心', '数组'],
    $json$[
  {
    "input": "machines = [1, 0, 5]",
    "output": "3"
  },
  {
    "input": "machines = [0, 3, 0]",
    "output": "2"
  },
  {
    "input": "machines = [0, 2, 0]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "machines = [1, 0, 5]",
    "output": "3"
  },
  {
    "input": "machines = [0, 3, 0]",
    "output": "2"
  },
  {
    "input": "machines = [0, 2, 0]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findMinMoves = function(machines) {\n};\n",
  "python": "class Solution:\n    def findMinMoves(self, machines: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findMinMoves(std::vector<int>& machines) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findMinMoves(int[] machines) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findMinMoves",
  "params": [
    {
      "name": "machines",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          0,
          5
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          0,
          3,
          0
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          0,
          2,
          0
        ]
      ],
      "expected": -1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        4,
        0,
        0,
        4
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        1,
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        9,
        1,
        8,
        8,
        9
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        0,
        0,
        3,
        0,
        0
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        2,
        2,
        2,
        2
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        5,
        5,
        5
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1670,
    '最小区间',
    '给定 k 个按升序排列的整数数组 nums。找到一个最小区间 [a, b]，使得每个数组中都至少有一个整数落在该区间内。
区间长度定义为 b - a。若有多个长度相同的区间，返回起点 a 较小的那个。返回 [a, b]。',
    'hard',
    1000,
    256,
    ARRAY['堆', '滑动窗口'],
    $json$[
  {
    "input": "nums = [[4, 10, 15, 24, 26], [0, 9, 12, 20], [5, 18, 22, 30]]",
    "output": "[20, 24]"
  },
  {
    "input": "nums = [[1, 2, 3], [1, 2, 3], [1, 2, 3]]",
    "output": "[1, 1]"
  },
  {
    "input": "nums = [[10], [11]]",
    "output": "[10, 11]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [[4, 10, 15, 24, 26], [0, 9, 12, 20], [5, 18, 22, 30]]",
    "output": "[20, 24]"
  },
  {
    "input": "nums = [[1, 2, 3], [1, 2, 3], [1, 2, 3]]",
    "output": "[1, 1]"
  },
  {
    "input": "nums = [[10], [11]]",
    "output": "[10, 11]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestRange = function(nums) {\n};\n",
  "python": "class Solution:\n    def smallestRange(self, nums: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> smallestRange(std::vector<std::vector<int>>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] smallestRange(int[][] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestRange",
  "params": [
    {
      "name": "nums",
      "type": "int[][]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            4,
            10,
            15,
            24,
            26
          ],
          [
            0,
            9,
            12,
            20
          ],
          [
            5,
            18,
            22,
            30
          ]
        ]
      ],
      "expected": [
        20,
        24
      ]
    },
    {
      "args": [
        [
          [
            1,
            2,
            3
          ],
          [
            1,
            2,
            3
          ],
          [
            1,
            2,
            3
          ]
        ]
      ],
      "expected": [
        1,
        1
      ]
    },
    {
      "args": [
        [
          [
            10
          ],
          [
            11
          ]
        ]
      ],
      "expected": [
        10,
        11
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          4,
          7
        ],
        [
          2,
          5,
          8
        ]
      ]
    ],
    "expected": [
      1,
      2
    ]
  },
  {
    "args": [
      [
        [
          0,
          10
        ],
        [
          1,
          2
        ]
      ]
    ],
    "expected": [
      0,
      1
    ]
  },
  {
    "args": [
      [
        [
          1,
          5,
          9
        ],
        [
          2,
          6,
          10
        ],
        [
          3,
          7,
          11
        ]
      ]
    ],
    "expected": [
      1,
      3
    ]
  },
  {
    "args": [
      [
        [
          1
        ],
        [
          1
        ],
        [
          1
        ]
      ]
    ],
    "expected": [
      1,
      1
    ]
  },
  {
    "args": [
      [
        [
          1,
          2,
          3
        ],
        [
          4,
          5,
          6
        ],
        [
          7,
          8,
          9
        ]
      ]
    ],
    "expected": [
      3,
      7
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1671,
    '24 点游戏',
    '给定 4 张写有整数的卡片，判断能否使用加、减、乘、除四种运算和括号，将 4 张卡片各使用恰好一次，计算出 24。
除法为实数除法，过程中不会出现除以 0 的情况。能得到 24 返回 true，否则返回 false。',
    'hard',
    1000,
    256,
    ARRAY['回溯', '数学'],
    $json$[
  {
    "input": "cards = [4, 1, 8, 7]",
    "output": "true"
  },
  {
    "input": "cards = [1, 2, 1, 2]",
    "output": "false"
  },
  {
    "input": "cards = [3, 3, 8, 8]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "cards = [4, 1, 8, 7]",
    "output": "true"
  },
  {
    "input": "cards = [1, 2, 1, 2]",
    "output": "false"
  },
  {
    "input": "cards = [3, 3, 8, 8]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var judgePoint24 = function(cards) {\n};\n",
  "python": "class Solution:\n    def judgePoint24(self, cards: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool judgePoint24(std::vector<int>& cards) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean judgePoint24(int[] cards) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "judgePoint24",
  "params": [
    {
      "name": "cards",
      "type": "int[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          4,
          1,
          8,
          7
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          2,
          1,
          2
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          3,
          3,
          8,
          8
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        1,
        1,
        1
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        6,
        1,
        3,
        4
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        5,
        5,
        5,
        1
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        2,
        2,
        2,
        2
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        8,
        8,
        8,
        8
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        8,
        8,
        3,
        3
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1672,
    '三个无重叠子数组的最大和',
    '给定整数数组 nums 和整数 k。选择三个长度为 k、互不重叠的连续子数组，使它们的元素和最大。
返回三个子数组的起始下标 [i, j, l]，满足 i < j < l。若有多种方案得到相同的最大和，返回字典序最小的下标组合。',
    'hard',
    1000,
    256,
    ARRAY['动态规划', '数组'],
    $json$[
  {
    "input": "nums = [1, 2, 1, 2, 6, 7, 5, 1], k = 2",
    "output": "[0, 3, 5]"
  },
  {
    "input": "nums = [1, 2, 1, 2, 1, 2, 1, 2, 1], k = 2",
    "output": "[0, 2, 4]"
  },
  {
    "input": "nums = [4, 5, 6, 1, 2], k = 1",
    "output": "[0, 1, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 1, 2, 6, 7, 5, 1], k = 2",
    "output": "[0, 3, 5]"
  },
  {
    "input": "nums = [1, 2, 1, 2, 1, 2, 1, 2, 1], k = 2",
    "output": "[0, 2, 4]"
  },
  {
    "input": "nums = [4, 5, 6, 1, 2], k = 1",
    "output": "[0, 1, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxSumOfThreeSubarrays = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def maxSumOfThreeSubarrays(self, nums: list[int], k: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> maxSumOfThreeSubarrays(std::vector<int>& nums, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] maxSumOfThreeSubarrays(int[] nums, int k) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxSumOfThreeSubarrays",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2,
          1,
          2,
          6,
          7,
          5,
          1
        ],
        2
      ],
      "expected": [
        0,
        3,
        5
      ]
    },
    {
      "args": [
        [
          1,
          2,
          1,
          2,
          1,
          2,
          1,
          2,
          1
        ],
        2
      ],
      "expected": [
        0,
        2,
        4
      ]
    },
    {
      "args": [
        [
          4,
          5,
          6,
          1,
          2
        ],
        1
      ],
      "expected": [
        0,
        1,
        2
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        1,
        1,
        1,
        1,
        1
      ],
      1
    ],
    "expected": [
      0,
      1,
      2
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5,
        6
      ],
      2
    ],
    "expected": [
      0,
      2,
      4
    ]
  },
  {
    "args": [
      [
        7,
        5,
        3,
        2,
        1
      ],
      1
    ],
    "expected": [
      0,
      1,
      2
    ]
  },
  {
    "args": [
      [
        -1,
        -2,
        -3,
        -4,
        -5,
        -6
      ],
      2
    ],
    "expected": [
      0,
      2,
      4
    ]
  },
  {
    "args": [
      [
        2,
        1,
        3,
        1,
        2,
        1,
        3,
        1,
        2
      ],
      2
    ],
    "expected": [
      0,
      2,
      5
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1673,
    '摘樱桃',
    '给定一个 n x n 的整数矩阵 grid，0 表示空地，1 表示有一个樱桃，-1 表示障碍。
你从左上角出发，每次向右或向下移动到达右下角；再从右下角出发，每次向左或向上移动回到左上角。经过有樱桃的格子时摘走樱桃，每个樱桃只能摘一次。
起点或终点有障碍时无法完成往返。返回最多能摘到的樱桃数量。',
    'hard',
    1000,
    256,
    ARRAY['动态规划', '矩阵'],
    $json$[
  {
    "input": "grid = [[0, 1, -1], [1, 0, -1], [1, 1, 1]]",
    "output": "5"
  },
  {
    "input": "grid = [[1, 1, -1], [1, -1, 1], [-1, 1, 1]]",
    "output": "0"
  },
  {
    "input": "grid = [[1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[0, 1, -1], [1, 0, -1], [1, 1, 1]]",
    "output": "5"
  },
  {
    "input": "grid = [[1, 1, -1], [1, -1, 1], [-1, 1, 1]]",
    "output": "0"
  },
  {
    "input": "grid = [[1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var cherryPickup = function(grid) {\n};\n",
  "python": "class Solution:\n    def cherryPickup(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int cherryPickup(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int cherryPickup(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "cherryPickup",
  "params": [
    {
      "name": "grid",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            0,
            1,
            -1
          ],
          [
            1,
            0,
            -1
          ],
          [
            1,
            1,
            1
          ]
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        [
          [
            1,
            1,
            -1
          ],
          [
            1,
            -1,
            1
          ],
          [
            -1,
            1,
            1
          ]
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          [
            1
          ]
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          0
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          -1
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          0,
          -1
        ],
        [
          1,
          0
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          0
        ],
        [
          0,
          1
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          0,
          1,
          1
        ],
        [
          1,
          1,
          1
        ],
        [
          1,
          1,
          0
        ]
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        [
          1,
          1
        ],
        [
          1,
          1
        ]
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1674,
    '设置交集大小至少为二',
    '给定二维整数数组 intervals，其中 intervals[i] = [start, end] 表示一个闭区间。
需要选择一个整数集合 S，使每个区间中至少有两个 S 中的元素。返回 S 的最小大小。
题目保证每个区间满足 start < end，因此一定存在可行解。',
    'hard',
    1000,
    256,
    ARRAY['贪心', '数组'],
    $json$[
  {
    "input": "intervals = [[1, 3], [3, 7], [8, 9]]",
    "output": "5"
  },
  {
    "input": "intervals = [[1, 3], [1, 4], [2, 5], [3, 5]]",
    "output": "3"
  },
  {
    "input": "intervals = [[1, 2], [2, 3], [3, 4]]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "intervals = [[1, 3], [3, 7], [8, 9]]",
    "output": "5"
  },
  {
    "input": "intervals = [[1, 3], [1, 4], [2, 5], [3, 5]]",
    "output": "3"
  },
  {
    "input": "intervals = [[1, 2], [2, 3], [3, 4]]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var intersectionSizeTwo = function(intervals) {\n};\n",
  "python": "class Solution:\n    def intersectionSizeTwo(self, intervals: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int intersectionSizeTwo(std::vector<std::vector<int>>& intervals) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int intersectionSizeTwo(int[][] intervals) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "intersectionSizeTwo",
  "params": [
    {
      "name": "intervals",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            3
          ],
          [
            3,
            7
          ],
          [
            8,
            9
          ]
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        [
          [
            1,
            3
          ],
          [
            1,
            4
          ],
          [
            2,
            5
          ],
          [
            3,
            5
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            2,
            3
          ],
          [
            3,
            4
          ]
        ]
      ],
      "expected": 4
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          2
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          1,
          4
        ],
        [
          2,
          3
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          1,
          5
        ],
        [
          2,
          6
        ],
        [
          3,
          7
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          0,
          2
        ],
        [
          1,
          3
        ],
        [
          2,
          4
        ],
        [
          3,
          5
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          10,
          20
        ],
        [
          10,
          20
        ]
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1675,
    '情侣牵手',
    '有 n 对情侣坐在一排共 2n 个座位上，座位编号从 0 到 2n-1。第 i 对情侣的两人编号分别为 2i 和 2i+1。
数组 row 按座位顺序给出每个人编号。每一步可以选择任意两个人交换座位。返回使每对情侣都相邻而坐所需的最少交换次数。',
    'hard',
    1000,
    256,
    ARRAY['并查集', '数组'],
    $json$[
  {
    "input": "row = [0, 2, 1, 3]",
    "output": "1"
  },
  {
    "input": "row = [3, 2, 0, 1]",
    "output": "0"
  },
  {
    "input": "row = [0, 2, 4, 1, 3, 5]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "row = [0, 2, 1, 3]",
    "output": "1"
  },
  {
    "input": "row = [3, 2, 0, 1]",
    "output": "0"
  },
  {
    "input": "row = [0, 2, 4, 1, 3, 5]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minSwapsCouples = function(row) {\n};\n",
  "python": "class Solution:\n    def minSwapsCouples(self, row: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minSwapsCouples(std::vector<int>& row) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minSwapsCouples(int[] row) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minSwapsCouples",
  "params": [
    {
      "name": "row",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          0,
          2,
          1,
          3
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          3,
          2,
          0,
          1
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          0,
          2,
          4,
          1,
          3,
          5
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0,
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        0
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        0,
        3,
        1,
        2
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        0,
        4,
        1,
        5,
        2,
        3
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        5,
        4,
        2,
        3,
        1,
        0
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        0,
        2,
        1,
        3,
        4,
        6,
        5,
        7
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1676,
    '最多能完成排序的块 II',
    '给定整数数组 arr。把数组切分成若干个连续块，对每个块单独排序后，按原顺序拼接，结果恰好等于整个数组升序排序后的结果。
返回最多可以切分成多少个块。',
    'hard',
    1000,
    256,
    ARRAY['栈', '数组', '排序'],
    $json$[
  {
    "input": "arr = [5, 4, 3, 2, 1]",
    "output": "1"
  },
  {
    "input": "arr = [2, 1, 3, 4, 4]",
    "output": "4"
  },
  {
    "input": "arr = [1, 1, 0, 0, 1]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [5, 4, 3, 2, 1]",
    "output": "1"
  },
  {
    "input": "arr = [2, 1, 3, 4, 4]",
    "output": "4"
  },
  {
    "input": "arr = [1, 1, 0, 0, 1]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxChunksToSorted = function(arr) {\n};\n",
  "python": "class Solution:\n    def maxChunksToSorted(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxChunksToSorted(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxChunksToSorted(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxChunksToSorted",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          5,
          4,
          3,
          2,
          1
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          2,
          1,
          3,
          4,
          4
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          1,
          1,
          0,
          0,
          1
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        4,
        3,
        2,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        0,
        2,
        3,
        4
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        1,
        1,
        1,
        1
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        0,
        0,
        1,
        1
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        0,
        2,
        1,
        3
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1677,
    '公交路线',
    '给定公交路线数组 routes，其中 routes[i] 是第 i 辆公交车循环经过的站点列表，同一辆公交车会沿该列表不断循环运行。
你从站点 source 出发，只能通过乘坐公交车移动，每乘坐一辆新的公交车计一次乘车。返回到达站点 target 所需的最少乘车次数；无法到达则返回 -1。起点与终点相同时乘车次数为 0。',
    'hard',
    1000,
    256,
    ARRAY['广度优先搜索', '图'],
    $json$[
  {
    "input": "routes = [[1, 2, 7], [3, 6, 7]], source = 1, target = 6",
    "output": "2"
  },
  {
    "input": "routes = [[1, 2, 3], [3, 4, 5]], source = 1, target = 5",
    "output": "2"
  },
  {
    "input": "routes = [[1, 2, 3]], source = 1, target = 3",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "routes = [[1, 2, 7], [3, 6, 7]], source = 1, target = 6",
    "output": "2"
  },
  {
    "input": "routes = [[1, 2, 3], [3, 4, 5]], source = 1, target = 5",
    "output": "2"
  },
  {
    "input": "routes = [[1, 2, 3]], source = 1, target = 3",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numBusesToDestination = function(routes, source, target) {\n};\n",
  "python": "class Solution:\n    def numBusesToDestination(self, routes: list[list[int]], source: int, target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numBusesToDestination(std::vector<std::vector<int>>& routes, int source, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numBusesToDestination(int[][] routes, int source, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numBusesToDestination",
  "params": [
    {
      "name": "routes",
      "type": "int[][]"
    },
    {
      "name": "source",
      "type": "int"
    },
    {
      "name": "target",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            2,
            7
          ],
          [
            3,
            6,
            7
          ]
        ],
        1,
        6
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            1,
            2,
            3
          ],
          [
            3,
            4,
            5
          ]
        ],
        1,
        5
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            1,
            2,
            3
          ]
        ],
        1,
        3
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          2
        ]
      ],
      1,
      1
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          1,
          2
        ]
      ],
      3,
      1
    ],
    "expected": -1
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          2,
          3
        ],
        [
          3,
          4
        ]
      ],
      1,
      4
    ],
    "expected": 3
  },
  {
    "args": [
      [
        [
          1,
          2,
          3,
          4
        ]
      ],
      1,
      4
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1
        ],
        [
          2
        ]
      ],
      1,
      2
    ],
    "expected": -1
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          3,
          4
        ]
      ],
      1,
      4
    ],
    "expected": -1
  }
]$json$::jsonb,
    'approved'
),
(
    1678,
    '最大人工岛',
    '给定一个 n x n 的二进制矩阵 grid，1 表示陆地，0 表示海洋。你最多可以将一个 0 变成 1，也可以不做任何改变。
返回操作后可能得到的最大岛屿面积。岛屿由上下左右四个方向相连的 1 组成。',
    'hard',
    1000,
    256,
    ARRAY['深度优先搜索', '并查集', '矩阵'],
    $json$[
  {
    "input": "grid = [[1, 0], [0, 1]]",
    "output": "3"
  },
  {
    "input": "grid = [[1, 1], [1, 0]]",
    "output": "4"
  },
  {
    "input": "grid = [[1, 1], [1, 1]]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[1, 0], [0, 1]]",
    "output": "3"
  },
  {
    "input": "grid = [[1, 1], [1, 0]]",
    "output": "4"
  },
  {
    "input": "grid = [[1, 1], [1, 1]]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestIsland = function(grid) {\n};\n",
  "python": "class Solution:\n    def largestIsland(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int largestIsland(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int largestIsland(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestIsland",
  "params": [
    {
      "name": "grid",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            0
          ],
          [
            0,
            1
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          [
            1,
            1
          ],
          [
            1,
            0
          ]
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          [
            1,
            1
          ],
          [
            1,
            1
          ]
        ]
      ],
      "expected": 4
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          0
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          0,
          0
        ],
        [
          0,
          0
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          0,
          1
        ],
        [
          0,
          0,
          0
        ],
        [
          1,
          0,
          1
        ]
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        [
          1,
          1,
          0
        ],
        [
          1,
          0,
          0
        ],
        [
          0,
          0,
          0
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          1,
          1,
          1
        ],
        [
          1,
          0,
          1
        ],
        [
          1,
          1,
          1
        ]
      ]
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1679,
    '树中距离之和',
    '给定一棵有 n 个节点的无向树，节点编号从 0 到 n-1。edges[i] = [a, b] 表示节点 a 与节点 b 之间有一条边。
返回长度为 n 的数组 answer，其中 answer[i] 是节点 i 到其余所有节点的距离之和。节点 i 到节点 j 的距离定义为连接两点的最短路径上的边数。',
    'hard',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '动态规划'],
    $json$[
  {
    "input": "n = 6, edges = [[0, 1], [0, 2], [2, 3], [2, 4], [2, 5]]",
    "output": "[8, 12, 6, 10, 10, 10]"
  },
  {
    "input": "n = 1, edges = []",
    "output": "[0]"
  },
  {
    "input": "n = 2, edges = [[0, 1]]",
    "output": "[1, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 6, edges = [[0, 1], [0, 2], [2, 3], [2, 4], [2, 5]]",
    "output": "[8, 12, 6, 10, 10, 10]"
  },
  {
    "input": "n = 1, edges = []",
    "output": "[0]"
  },
  {
    "input": "n = 2, edges = [[0, 1]]",
    "output": "[1, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumOfDistancesInTree = function(n, edges) {\n};\n",
  "python": "class Solution:\n    def sumOfDistancesInTree(self, n: int, edges: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> sumOfDistancesInTree(int n, std::vector<std::vector<int>>& edges) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] sumOfDistancesInTree(int n, int[][] edges) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumOfDistancesInTree",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "edges",
      "type": "int[][]"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        6,
        [
          [
            0,
            1
          ],
          [
            0,
            2
          ],
          [
            2,
            3
          ],
          [
            2,
            4
          ],
          [
            2,
            5
          ]
        ]
      ],
      "expected": [
        8,
        12,
        6,
        10,
        10,
        10
      ]
    },
    {
      "args": [
        1,
        []
      ],
      "expected": [
        0
      ]
    },
    {
      "args": [
        2,
        [
          [
            0,
            1
          ]
        ]
      ],
      "expected": [
        1,
        1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      3,
      [
        [
          0,
          1
        ],
        [
          1,
          2
        ]
      ]
    ],
    "expected": [
      3,
      2,
      3
    ]
  },
  {
    "args": [
      4,
      [
        [
          0,
          1
        ],
        [
          0,
          2
        ],
        [
          0,
          3
        ]
      ]
    ],
    "expected": [
      3,
      5,
      5,
      5
    ]
  },
  {
    "args": [
      5,
      [
        [
          0,
          1
        ],
        [
          1,
          2
        ],
        [
          2,
          3
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": [
      10,
      7,
      6,
      7,
      10
    ]
  },
  {
    "args": [
      7,
      [
        [
          0,
          1
        ],
        [
          1,
          2
        ],
        [
          2,
          3
        ],
        [
          3,
          4
        ],
        [
          4,
          5
        ],
        [
          5,
          6
        ]
      ]
    ],
    "expected": [
      21,
      16,
      13,
      12,
      13,
      16,
      21
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1680,
    '石子游戏 IV',
    '给定 n 颗石子，两名玩家轮流取走若干颗。
每次只能取走完全平方数颗（1、4、9、16、……）。
取走最后一颗石子的玩家获胜。
返回先手是否必胜。',
    'hard',
    1000,
    256,
    ARRAY['数学', '动态规划', '博弈'],
    $json$[
  {
    "input": "n = 1",
    "output": "true"
  },
  {
    "input": "n = 2",
    "output": "false"
  },
  {
    "input": "n = 4",
    "output": "true"
  },
  {
    "input": "n = 7",
    "output": "false"
  },
  {
    "input": "n = 10",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 1",
    "output": "true"
  },
  {
    "input": "n = 2",
    "output": "false"
  },
  {
    "input": "n = 4",
    "output": "true"
  },
  {
    "input": "n = 7",
    "output": "false"
  },
  {
    "input": "n = 10",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var stoneGameIV = function(n) {\n};\n",
  "python": "class Solution:\n    def stoneGameIV(self, n: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool stoneGameIV(int n) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean stoneGameIV(int n) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "stoneGameIV",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        1
      ],
      "expected": true
    },
    {
      "args": [
        2
      ],
      "expected": false
    },
    {
      "args": [
        4
      ],
      "expected": true
    },
    {
      "args": [
        7
      ],
      "expected": false
    },
    {
      "args": [
        10
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      3
    ],
    "expected": true
  },
  {
    "args": [
      5
    ],
    "expected": false
  },
  {
    "args": [
      6
    ],
    "expected": true
  },
  {
    "args": [
      8
    ],
    "expected": true
  },
  {
    "args": [
      9
    ],
    "expected": true
  },
  {
    "args": [
      11
    ],
    "expected": true
  },
  {
    "args": [
      15
    ],
    "expected": false
  },
  {
    "args": [
      16
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1681,
    '删除回文子数组',
    '给定整数数组 arr。
一次操作可以删除一个连续的回文子数组，删除后剩余元素自动拼接。
返回删除整个数组所需的最少操作次数。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '区间动态规划'],
    $json$[
  {
    "input": "arr = [1, 2]",
    "output": "2"
  },
  {
    "input": "arr = [1, 3, 4, 1, 5]",
    "output": "3"
  },
  {
    "input": "arr = [1, 2, 1, 2]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [1, 2]",
    "output": "2"
  },
  {
    "input": "arr = [1, 3, 4, 1, 5]",
    "output": "3"
  },
  {
    "input": "arr = [1, 2, 1, 2]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var removePalindromicSubarrays = function(arr) {\n};\n",
  "python": "class Solution:\n    def removePalindromicSubarrays(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int removePalindromicSubarrays(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int removePalindromicSubarrays(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removePalindromicSubarrays",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1,
          3,
          4,
          1,
          5
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          1,
          2,
          1,
          2
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2,
        3
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        2,
        2,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2,
        1,
        2,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        3,
        4,
        1,
        5,
        3,
        2
      ]
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1682,
    '转化为全零矩阵的最少反转次数',
    '给定 m x n 的 0/1 矩阵 mat。
每次操作选择一个格子，将该格子以及上下左右相邻格子的值翻转（0 变 1，1 变 0）。
返回使矩阵全为 0 的最少操作次数；无法做到返回 -1。',
    'hard',
    1000,
    256,
    ARRAY['位运算', '广度优先搜索', '矩阵'],
    $json$[
  {
    "input": "mat = [[0, 0], [0, 1]]",
    "output": "3"
  },
  {
    "input": "mat = [[0]]",
    "output": "0"
  },
  {
    "input": "mat = [[1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mat = [[0, 0], [0, 1]]",
    "output": "3"
  },
  {
    "input": "mat = [[0]]",
    "output": "0"
  },
  {
    "input": "mat = [[1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minFlipsToZeroMatrix = function(mat) {\n};\n",
  "python": "class Solution:\n    def minFlipsToZeroMatrix(self, mat: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minFlipsToZeroMatrix(std::vector<std::vector<int>>& mat) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minFlipsToZeroMatrix(int[][] mat) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minFlipsToZeroMatrix",
  "params": [
    {
      "name": "mat",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            0,
            0
          ],
          [
            0,
            1
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          [
            0
          ]
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          [
            1
          ]
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          1
        ],
        [
          1,
          0
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          0,
          1
        ],
        [
          1,
          0
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          1,
          0
        ],
        [
          0,
          1
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          1,
          1
        ],
        [
          1,
          1
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          0,
          1,
          0
        ],
        [
          1,
          0,
          1
        ],
        [
          0,
          1,
          0
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          1,
          1,
          1
        ],
        [
          1,
          1,
          1
        ],
        [
          1,
          1,
          1
        ]
      ]
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1683,
    '多次求和构造目标数组',
    '初始时有一个长度为 n、元素全为 1 的数组。
每次操作可以选择一个下标，把它替换成当前数组所有元素之和。
给定目标数组 target，判断是否能从全 1 数组得到 target。',
    'hard',
    1000,
    256,
    ARRAY['数组', '堆', '数学'],
    $json$[
  {
    "input": "target = [9, 3, 5]",
    "output": "true"
  },
  {
    "input": "target = [1, 1, 1]",
    "output": "true"
  },
  {
    "input": "target = [1, 1, 1, 2]",
    "output": "false"
  },
  {
    "input": "target = [8, 5]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "target = [9, 3, 5]",
    "output": "true"
  },
  {
    "input": "target = [1, 1, 1]",
    "output": "true"
  },
  {
    "input": "target = [1, 1, 1, 2]",
    "output": "false"
  },
  {
    "input": "target = [8, 5]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isPossibleTarget = function(target) {\n};\n",
  "python": "class Solution:\n    def isPossibleTarget(self, target: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isPossibleTarget(std::vector<int>& target) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isPossibleTarget(int[] target) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isPossibleTarget",
  "params": [
    {
      "name": "target",
      "type": "int[]"
    }
  ],
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          9,
          3,
          5
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          1,
          1
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          1,
          1,
          2
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          8,
          5
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        2
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        1000000000
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        2,
        1
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        1,
        2
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        1,
        1,
        1
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        3,
        7,
        11
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1684,
    '使网格图至少有一条有效路径的最小代价',
    '给定 m x n 网格 grid，grid[i][j] 表示该格子的箭头方向：
1 向右，2 向左，3 向下，4 向上。
从 (0,0) 出发，每一步必须沿当前格子的箭头移动。
如果希望移动到箭头以外的相邻格子，需要花费 1 的代价修改当前格子的箭头。
返回到达 (m-1,n-1) 的最小代价。',
    'hard',
    1000,
    256,
    ARRAY['广度优先搜索', '图', '最短路'],
    $json$[
  {
    "input": "grid = [[1, 1, 1, 1], [2, 2, 2, 2], [1, 1, 1, 1], [2, 2, 2, 2]]",
    "output": "3"
  },
  {
    "input": "grid = [[1, 2], [4, 3]]",
    "output": "1"
  },
  {
    "input": "grid = [[2, 2], [2, 2]]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[1, 1, 1, 1], [2, 2, 2, 2], [1, 1, 1, 1], [2, 2, 2, 2]]",
    "output": "3"
  },
  {
    "input": "grid = [[1, 2], [4, 3]]",
    "output": "1"
  },
  {
    "input": "grid = [[2, 2], [2, 2]]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minCostValidPath = function(grid) {\n};\n",
  "python": "class Solution:\n    def minCostValidPath(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minCostValidPath(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minCostValidPath(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minCostValidPath",
  "params": [
    {
      "name": "grid",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            1,
            1,
            1
          ],
          [
            2,
            2,
            2,
            2
          ],
          [
            1,
            1,
            1,
            1
          ],
          [
            2,
            2,
            2,
            2
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            4,
            3
          ]
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          [
            2,
            2
          ],
          [
            2,
            2
          ]
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          2
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          2,
          1
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          2,
          1
        ],
        [
          1,
          2
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          2,
          3,
          4
        ]
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1685,
    '有序矩阵中的第 k 个最小数组和',
    '给定 m 行矩阵 mat，每行都按非递减顺序排列。
从每一行恰好选一个数，得到一个长度为 m 的和。
返回所有可能的和中第 k 小的值（k 从 1 开始）。',
    'hard',
    1000,
    256,
    ARRAY['数组', '堆', '排序'],
    $json$[
  {
    "input": "mat = [[1, 3, 11], [2, 4, 6]], k = 5",
    "output": "7"
  },
  {
    "input": "mat = [[1, 3, 11], [2, 4, 6]], k = 9",
    "output": "17"
  },
  {
    "input": "mat = [[1, 10, 10], [1, 4, 5], [2, 3, 6]], k = 7",
    "output": "9"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mat = [[1, 3, 11], [2, 4, 6]], k = 5",
    "output": "7"
  },
  {
    "input": "mat = [[1, 3, 11], [2, 4, 6]], k = 9",
    "output": "17"
  },
  {
    "input": "mat = [[1, 10, 10], [1, 4, 5], [2, 3, 6]], k = 7",
    "output": "9"
  }
]$json$::jsonb,
    $json${
  "javascript": "var kthSmallestMatrixSum = function(mat, k) {\n};\n",
  "python": "class Solution:\n    def kthSmallestMatrixSum(self, mat: list[list[int]], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int kthSmallestMatrixSum(std::vector<std::vector<int>>& mat, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int kthSmallestMatrixSum(int[][] mat, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kthSmallestMatrixSum",
  "params": [
    {
      "name": "mat",
      "type": "int[][]"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            3,
            11
          ],
          [
            2,
            4,
            6
          ]
        ],
        5
      ],
      "expected": 7
    },
    {
      "args": [
        [
          [
            1,
            3,
            11
          ],
          [
            2,
            4,
            6
          ]
        ],
        9
      ],
      "expected": 17
    },
    {
      "args": [
        [
          [
            1,
            10,
            10
          ],
          [
            1,
            4,
            5
          ],
          [
            2,
            3,
            6
          ]
        ],
        7
      ],
      "expected": 9
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1
        ]
      ],
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          3,
          4
        ]
      ],
      2
    ],
    "expected": 5
  },
  {
    "args": [
      [
        [
          1,
          2
        ],
        [
          3,
          4
        ]
      ],
      4
    ],
    "expected": 6
  },
  {
    "args": [
      [
        [
          5,
          9
        ],
        [
          2,
          7
        ]
      ],
      3
    ],
    "expected": 12
  },
  {
    "args": [
      [
        [
          1,
          1,
          1
        ],
        [
          1,
          1,
          1
        ]
      ],
      5
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1686,
    '切披萨的方案数',
    '给定字符串数组 pizza 表示披萨，''A'' 表示苹果，''.'' 表示空。
需要把披萨切成 k 块，每块至少含一个苹果。
每次切披萨必须沿整行或整列之间的直线切下，并把当前所有块一起切开。
返回切出 k 块的方案数，模 1e9+7。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '前缀和'],
    $json$[
  {
    "input": "pizza = [\"A..\", \"AAA\", \"...\"], k = 3",
    "output": "3"
  },
  {
    "input": "pizza = [\"A..\", \"AA.\", \"...\"], k = 3",
    "output": "1"
  },
  {
    "input": "pizza = [\"A..\", \"A..\", \"...\"], k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "pizza = [\"A..\", \"AAA\", \"...\"], k = 3",
    "output": "3"
  },
  {
    "input": "pizza = [\"A..\", \"AA.\", \"...\"], k = 3",
    "output": "1"
  },
  {
    "input": "pizza = [\"A..\", \"A..\", \"...\"], k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var waysCutPizza = function(pizza, k) {\n};\n",
  "python": "class Solution:\n    def waysCutPizza(self, pizza: list[str], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int waysCutPizza(std::vector<std::string>& pizza, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int waysCutPizza(String[] pizza, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "waysCutPizza",
  "params": [
    {
      "name": "pizza",
      "type": "string[]"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "A..",
          "AAA",
          "..."
        ],
        3
      ],
      "expected": 3
    },
    {
      "args": [
        [
          "A..",
          "AA.",
          "..."
        ],
        3
      ],
      "expected": 1
    },
    {
      "args": [
        [
          "A..",
          "A..",
          "..."
        ],
        1
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "A"
      ],
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "A"
      ],
      2
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "..",
        ".."
      ],
      2
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "AAA",
        "AAA",
        "AAA"
      ],
      3
    ],
    "expected": 10
  },
  {
    "args": [
      [
        "A..",
        "...",
        "..."
      ],
      2
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1687,
    '摘樱桃 II',
    '给定 rows x cols 的 grid，两个机器人分别从 (0,0) 和 (0,cols-1) 出发。
每轮两个机器人同时下移到下一行，列坐标可以分别变化 -1、0、1（不能越界）。
经过的格子中的樱桃会被收集，同一格子若两个机器人同时经过只计一次。
返回到达最后一行时能收集的最多樱桃数。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '矩阵'],
    $json$[
  {
    "input": "grid = [[3, 1, 1], [2, 5, 1], [1, 5, 5], [2, 1, 1]]",
    "output": "24"
  },
  {
    "input": "grid = [[1, 2, 3]]",
    "output": "4"
  },
  {
    "input": "grid = [[1, 2], [3, 4]]",
    "output": "10"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[3, 1, 1], [2, 5, 1], [1, 5, 5], [2, 1, 1]]",
    "output": "24"
  },
  {
    "input": "grid = [[1, 2, 3]]",
    "output": "4"
  },
  {
    "input": "grid = [[1, 2], [3, 4]]",
    "output": "10"
  }
]$json$::jsonb,
    $json${
  "javascript": "var cherryPickupII = function(grid) {\n};\n",
  "python": "class Solution:\n    def cherryPickupII(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int cherryPickupII(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int cherryPickupII(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "cherryPickupII",
  "params": [
    {
      "name": "grid",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            3,
            1,
            1
          ],
          [
            2,
            5,
            1
          ],
          [
            1,
            5,
            5
          ],
          [
            2,
            1,
            1
          ]
        ]
      ],
      "expected": 24
    },
    {
      "args": [
        [
          [
            1,
            2,
            3
          ]
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            3,
            4
          ]
        ]
      ],
      "expected": 10
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          1
        ],
        [
          1,
          1
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          5,
          0,
          5,
          0,
          5
        ]
      ]
    ],
    "expected": 10
  },
  {
    "args": [
      [
        [
          1,
          0,
          1
        ],
        [
          1,
          0,
          1
        ],
        [
          1,
          0,
          1
        ]
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        [
          10,
          0,
          0,
          0,
          10
        ],
        [
          0,
          0,
          0,
          0,
          0
        ],
        [
          10,
          0,
          0,
          0,
          10
        ]
      ]
    ],
    "expected": 40
  }
]$json$::jsonb,
    'approved'
),
(
    1688,
    '保证图可完全遍历',
    '给定 n 个节点（编号 1 到 n）和边数组 edges，edges[i] = [type, u, v]。
type=1 表示只有 Alice 能走，type=2 表示只有 Bob 能走，type=3 表示两人都能走。
删除尽可能多的边，使得 Alice 和 Bob 都能从任意节点到达任意节点。
返回最多可删除的边数；无法做到返回 -1。',
    'hard',
    1000,
    256,
    ARRAY['并查集', '图'],
    $json$[
  {
    "input": "n = 4, edges = [[3, 1, 2], [3, 2, 3], [1, 1, 3], [1, 2, 4], [1, 1, 2], [2, 3, 4]]",
    "output": "2"
  },
  {
    "input": "n = 4, edges = [[3, 1, 2], [3, 2, 3], [1, 1, 4], [2, 1, 4]]",
    "output": "0"
  },
  {
    "input": "n = 4, edges = [[3, 2, 3], [1, 1, 2], [2, 3, 4]]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4, edges = [[3, 1, 2], [3, 2, 3], [1, 1, 3], [1, 2, 4], [1, 1, 2], [2, 3, 4]]",
    "output": "2"
  },
  {
    "input": "n = 4, edges = [[3, 1, 2], [3, 2, 3], [1, 1, 4], [2, 1, 4]]",
    "output": "0"
  },
  {
    "input": "n = 4, edges = [[3, 2, 3], [1, 1, 2], [2, 3, 4]]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxNumEdgesToRemove = function(n, edges) {\n};\n",
  "python": "class Solution:\n    def maxNumEdgesToRemove(self, n: int, edges: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxNumEdgesToRemove(int n, std::vector<std::vector<int>>& edges) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxNumEdgesToRemove(int n, int[][] edges) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxNumEdgesToRemove",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "edges",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        4,
        [
          [
            3,
            1,
            2
          ],
          [
            3,
            2,
            3
          ],
          [
            1,
            1,
            3
          ],
          [
            1,
            2,
            4
          ],
          [
            1,
            1,
            2
          ],
          [
            2,
            3,
            4
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        4,
        [
          [
            3,
            1,
            2
          ],
          [
            3,
            2,
            3
          ],
          [
            1,
            1,
            4
          ],
          [
            2,
            1,
            4
          ]
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        4,
        [
          [
            3,
            2,
            3
          ],
          [
            1,
            1,
            2
          ],
          [
            2,
            3,
            4
          ]
        ]
      ],
      "expected": -1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      []
    ],
    "expected": 0
  },
  {
    "args": [
      2,
      [
        [
          3,
          1,
          2
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      3,
      [
        [
          1,
          1,
          2
        ],
        [
          2,
          2,
          3
        ]
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      3,
      [
        [
          3,
          1,
          2
        ],
        [
          3,
          2,
          3
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      2,
      [
        [
          1,
          1,
          2
        ],
        [
          2,
          1,
          2
        ],
        [
          3,
          1,
          2
        ]
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1689,
    '最多可达成的换楼请求数目',
    '给定 n 栋楼和换楼请求数组 requests，requests[i] = [from, to]。
选择尽可能多的请求同时满足：每栋楼的净流入人数等于净流出人数。
返回最多可满足的请求数。',
    'hard',
    1000,
    256,
    ARRAY['位运算', '数组', '回溯'],
    $json$[
  {
    "input": "n = 5, requests = [[0, 1], [1, 0], [0, 1], [1, 2], [2, 0], [3, 4]]",
    "output": "5"
  },
  {
    "input": "n = 3, requests = [[0, 0], [1, 2], [2, 1]]",
    "output": "3"
  },
  {
    "input": "n = 2, requests = [[0, 1], [1, 0], [1, 1]]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5, requests = [[0, 1], [1, 0], [0, 1], [1, 2], [2, 0], [3, 4]]",
    "output": "5"
  },
  {
    "input": "n = 3, requests = [[0, 0], [1, 2], [2, 1]]",
    "output": "3"
  },
  {
    "input": "n = 2, requests = [[0, 1], [1, 0], [1, 1]]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumRequests = function(n, requests) {\n};\n",
  "python": "class Solution:\n    def maximumRequests(self, n: int, requests: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumRequests(int n, std::vector<std::vector<int>>& requests) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumRequests(int n, int[][] requests) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumRequests",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "requests",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        5,
        [
          [
            0,
            1
          ],
          [
            1,
            0
          ],
          [
            0,
            1
          ],
          [
            1,
            2
          ],
          [
            2,
            0
          ],
          [
            3,
            4
          ]
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        3,
        [
          [
            0,
            0
          ],
          [
            1,
            2
          ],
          [
            2,
            1
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        2,
        [
          [
            0,
            1
          ],
          [
            1,
            0
          ],
          [
            1,
            1
          ]
        ]
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      []
    ],
    "expected": 0
  },
  {
    "args": [
      1,
      [
        [
          0,
          0
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      2,
      [
        [
          0,
          1
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      2,
      [
        [
          0,
          1
        ],
        [
          1,
          0
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      3,
      [
        [
          0,
          1
        ],
        [
          1,
          2
        ],
        [
          2,
          0
        ],
        [
          0,
          0
        ]
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1690,
    '通过给定词典构造目标字符串的方案数',
    '给定长度相同的单词数组 words 和目标字符串 target。
按列构造字符串：第 i 个字符必须来自 words 中某个单词的第 i 个字符，
每一列可以选择不同的单词。
返回构造出 target 的方案数，模 1e9+7。',
    'hard',
    1000,
    256,
    ARRAY['数组', '字符串', '动态规划'],
    $json$[
  {
    "input": "words = [\"acca\", \"bbbb\", \"caca\"], target = \"aba\"",
    "output": "6"
  },
  {
    "input": "words = [\"abba\", \"baab\"], target = \"bab\"",
    "output": "4"
  },
  {
    "input": "words = [\"abcd\"], target = \"abcd\"",
    "output": "1"
  },
  {
    "input": "words = [\"abab\", \"baba\", \"abba\", \"baab\"], target = \"abba\"",
    "output": "16"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"acca\", \"bbbb\", \"caca\"], target = \"aba\"",
    "output": "6"
  },
  {
    "input": "words = [\"abba\", \"baab\"], target = \"bab\"",
    "output": "4"
  },
  {
    "input": "words = [\"abcd\"], target = \"abcd\"",
    "output": "1"
  },
  {
    "input": "words = [\"abab\", \"baba\", \"abba\", \"baab\"], target = \"abba\"",
    "output": "16"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numWaysToFormTarget = function(words, target) {\n};\n",
  "python": "class Solution:\n    def numWaysToFormTarget(self, words: list[str], target: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numWaysToFormTarget(std::vector<std::string>& words, std::string target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numWaysToFormTarget(String[] words, String target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numWaysToFormTarget",
  "params": [
    {
      "name": "words",
      "type": "string[]"
    },
    {
      "name": "target",
      "type": "string"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "acca",
          "bbbb",
          "caca"
        ],
        "aba"
      ],
      "expected": 6
    },
    {
      "args": [
        [
          "abba",
          "baab"
        ],
        "bab"
      ],
      "expected": 4
    },
    {
      "args": [
        [
          "abcd"
        ],
        "abcd"
      ],
      "expected": 1
    },
    {
      "args": [
        [
          "abab",
          "baba",
          "abba",
          "baab"
        ],
        "abba"
      ],
      "expected": 16
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "a"
      ],
      "a"
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "a"
      ],
      "b"
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "ab",
        "ba"
      ],
      "ab"
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "abc",
        "bca",
        "cab"
      ],
      "abc"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1691,
    '检查边长度限制的路径是否存在',
    '给定 n 个节点（编号 0 到 n-1）、无向边数组 edgeList
（edgeList[i] = [u, v, distance]）和查询数组 queries（queries[i] = [p, q, limit]）。
对每个查询，判断是否存在一条从 p 到 q 的路径，
使路径上每条边的距离都严格小于 limit。
返回布尔数组，顺序与查询一致。',
    'hard',
    1000,
    256,
    ARRAY['并查集', '图', '排序'],
    $json$[
  {
    "input": "n = 3, edgeList = [[0, 1, 2], [1, 2, 4], [2, 0, 8], [1, 0, 16]], queries = [[0, 1, 2], [0, 2, 5]]",
    "output": "[false, true]"
  },
  {
    "input": "n = 5, edgeList = [[0, 1, 10], [1, 2, 5], [2, 3, 9], [3, 4, 13]], queries = [[0, 4, 14], [1, 4, 13]]",
    "output": "[true, false]"
  },
  {
    "input": "n = 3, edgeList = [[0, 1, 1], [1, 2, 1]], queries = [[0, 2, 1], [0, 2, 2]]",
    "output": "[false, true]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, edgeList = [[0, 1, 2], [1, 2, 4], [2, 0, 8], [1, 0, 16]], queries = [[0, 1, 2], [0, 2, 5]]",
    "output": "[false, true]"
  },
  {
    "input": "n = 5, edgeList = [[0, 1, 10], [1, 2, 5], [2, 3, 9], [3, 4, 13]], queries = [[0, 4, 14], [1, 4, 13]]",
    "output": "[true, false]"
  },
  {
    "input": "n = 3, edgeList = [[0, 1, 1], [1, 2, 1]], queries = [[0, 2, 1], [0, 2, 2]]",
    "output": "[false, true]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var distanceLimitedPathsExist = function(n, edgeList, queries) {\n};\n",
  "python": "class Solution:\n    def distanceLimitedPathsExist(self, n: int, edgeList: list[list[int]], queries: list[list[int]]) -> list[bool]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<bool> distanceLimitedPathsExist(int n, std::vector<std::vector<int>>& edgeList, std::vector<std::vector<int>>& queries) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public boolean[] distanceLimitedPathsExist(int n, int[][] edgeList, int[][] queries) {\n        return new boolean[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "distanceLimitedPathsExist",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "edgeList",
      "type": "int[][]"
    },
    {
      "name": "queries",
      "type": "int[][]"
    }
  ],
  "return_type": "bool[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        3,
        [
          [
            0,
            1,
            2
          ],
          [
            1,
            2,
            4
          ],
          [
            2,
            0,
            8
          ],
          [
            1,
            0,
            16
          ]
        ],
        [
          [
            0,
            1,
            2
          ],
          [
            0,
            2,
            5
          ]
        ]
      ],
      "expected": [
        false,
        true
      ]
    },
    {
      "args": [
        5,
        [
          [
            0,
            1,
            10
          ],
          [
            1,
            2,
            5
          ],
          [
            2,
            3,
            9
          ],
          [
            3,
            4,
            13
          ]
        ],
        [
          [
            0,
            4,
            14
          ],
          [
            1,
            4,
            13
          ]
        ]
      ],
      "expected": [
        true,
        false
      ]
    },
    {
      "args": [
        3,
        [
          [
            0,
            1,
            1
          ],
          [
            1,
            2,
            1
          ]
        ],
        [
          [
            0,
            2,
            1
          ],
          [
            0,
            2,
            2
          ]
        ]
      ],
      "expected": [
        false,
        true
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      [],
      [
        [
          0,
          0,
          0
        ]
      ]
    ],
    "expected": [
      true
    ]
  },
  {
    "args": [
      2,
      [],
      [
        [
          0,
          1,
          1
        ]
      ]
    ],
    "expected": [
      false
    ]
  },
  {
    "args": [
      2,
      [
        [
          0,
          1,
          5
        ]
      ],
      [
        [
          0,
          1,
          5
        ],
        [
          0,
          1,
          6
        ]
      ]
    ],
    "expected": [
      false,
      true
    ]
  },
  {
    "args": [
      4,
      [
        [
          0,
          1,
          1
        ],
        [
          2,
          3,
          1
        ]
      ],
      [
        [
          0,
          1,
          2
        ],
        [
          0,
          3,
          2
        ],
        [
          2,
          3,
          1
        ]
      ]
    ],
    "expected": [
      true,
      false,
      false
    ]
  },
  {
    "args": [
      3,
      [
        [
          0,
          1,
          1
        ],
        [
          0,
          2,
          2
        ],
        [
          1,
          2,
          2
        ]
      ],
      [
        [
          0,
          2,
          2
        ],
        [
          0,
          2,
          3
        ]
      ]
    ],
    "expected": [
      false,
      true
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1692,
    '完成所有工作的最短时间',
    '给定 n 个工作和 k 名工人，jobs[i] 表示第 i 个工作的耗时。
每个工作必须完整地分配给一名工人，每名工人同一时间只能做一个工作。
返回到完成所有工作的最短时间（即所有工人最大工作耗时的最小值）。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '位运算', '二分查找'],
    $json$[
  {
    "input": "jobs = [3, 2, 3], k = 3",
    "output": "3"
  },
  {
    "input": "jobs = [1, 2, 4, 7, 8], k = 2",
    "output": "11"
  },
  {
    "input": "jobs = [1, 2, 4, 7, 8], k = 3",
    "output": "8"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "jobs = [3, 2, 3], k = 3",
    "output": "3"
  },
  {
    "input": "jobs = [1, 2, 4, 7, 8], k = 2",
    "output": "11"
  },
  {
    "input": "jobs = [1, 2, 4, 7, 8], k = 3",
    "output": "8"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumTimeRequired = function(jobs, k) {\n};\n",
  "python": "class Solution:\n    def minimumTimeRequired(self, jobs: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumTimeRequired(std::vector<int>& jobs, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumTimeRequired(int[] jobs, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumTimeRequired",
  "params": [
    {
      "name": "jobs",
      "type": "int[]"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          3,
          2,
          3
        ],
        3
      ],
      "expected": 3
    },
    {
      "args": [
        [
          1,
          2,
          4,
          7,
          8
        ],
        2
      ],
      "expected": 11
    },
    {
      "args": [
        [
          1,
          2,
          4,
          7,
          8
        ],
        3
      ],
      "expected": 8
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ],
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        5,
        5
      ],
      2
    ],
    "expected": 5
  },
  {
    "args": [
      [
        1,
        1,
        1,
        1
      ],
      2
    ],
    "expected": 2
  },
  {
    "args": [
      [
        10,
        10,
        10
      ],
      3
    ],
    "expected": 10
  },
  {
    "args": [
      [
        2,
        7,
        4,
        1,
        8,
        1
      ],
      2
    ],
    "expected": 12
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5
      ],
      3
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1693,
    '最多可以参加的会议数目 II',
    '给定会议数组 events，events[i] = [startDay, endDay, value]。
最多参加 k 个会议，参加一个会议会占用从 startDay 到 endDay 的全部时间，
且任意两个参加的会议时间不能重叠（前一个会议的 endDay 必须严格小于后一个会议的 startDay）。
返回能获得的最大价值。',
    'hard',
    1000,
    256,
    ARRAY['数组', '二分查找', '动态规划', '排序'],
    $json$[
  {
    "input": "events = [[1, 2, 4], [3, 4, 3], [2, 3, 1]], k = 2",
    "output": "7"
  },
  {
    "input": "events = [[1, 2, 4], [3, 4, 3], [2, 3, 10]], k = 2",
    "output": "10"
  },
  {
    "input": "events = [[1, 1, 1], [2, 2, 2], [3, 3, 3], [4, 4, 4]], k = 3",
    "output": "9"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "events = [[1, 2, 4], [3, 4, 3], [2, 3, 1]], k = 2",
    "output": "7"
  },
  {
    "input": "events = [[1, 2, 4], [3, 4, 3], [2, 3, 10]], k = 2",
    "output": "10"
  },
  {
    "input": "events = [[1, 1, 1], [2, 2, 2], [3, 3, 3], [4, 4, 4]], k = 3",
    "output": "9"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxValueEvents = function(events, k) {\n};\n",
  "python": "class Solution:\n    def maxValueEvents(self, events: list[list[int]], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long maxValueEvents(std::vector<std::vector<int>>& events, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long maxValueEvents(int[][] events, int k) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxValueEvents",
  "params": [
    {
      "name": "events",
      "type": "int[][]"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "long",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            2,
            4
          ],
          [
            3,
            4,
            3
          ],
          [
            2,
            3,
            1
          ]
        ],
        2
      ],
      "expected": 7
    },
    {
      "args": [
        [
          [
            1,
            2,
            4
          ],
          [
            3,
            4,
            3
          ],
          [
            2,
            3,
            10
          ]
        ],
        2
      ],
      "expected": 10
    },
    {
      "args": [
        [
          [
            1,
            1,
            1
          ],
          [
            2,
            2,
            2
          ],
          [
            3,
            3,
            3
          ],
          [
            4,
            4,
            4
          ]
        ],
        3
      ],
      "expected": 9
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          1,
          1
        ]
      ],
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          2,
          4
        ],
        [
          1,
          2,
          5
        ]
      ],
      1
    ],
    "expected": 5
  },
  {
    "args": [
      [
        [
          1,
          2,
          4
        ],
        [
          3,
          4,
          3
        ],
        [
          2,
          3,
          1
        ]
      ],
      1
    ],
    "expected": 4
  },
  {
    "args": [
      [
        [
          1,
          2,
          4
        ],
        [
          3,
          4,
          3
        ],
        [
          2,
          3,
          1
        ]
      ],
      3
    ],
    "expected": 7
  },
  {
    "args": [
      [
        [
          1,
          1,
          2
        ],
        [
          1,
          1,
          3
        ]
      ],
      1
    ],
    "expected": 3
  },
  {
    "args": [
      [
        [
          1,
          2,
          1
        ],
        [
          2,
          3,
          1
        ],
        [
          3,
          4,
          1
        ]
      ],
      2
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1694,
    'N 次操作后的最大分数',
    '给定长度为 2n 的整数数组 nums。
进行 n 次操作：第 i 次操作（i 从 1 开始）选择两个尚未选择的元素，
获得 i 与这两个元素最大公约数的乘积的分数，并删除这两个元素。
返回能获得的最大总分数。',
    'hard',
    1000,
    256,
    ARRAY['数组', '数学', '动态规划', '位运算'],
    $json$[
  {
    "input": "nums = [1, 2]",
    "output": "1"
  },
  {
    "input": "nums = [3, 4, 6, 8]",
    "output": "11"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6]",
    "output": "14"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2]",
    "output": "1"
  },
  {
    "input": "nums = [3, 4, 6, 8]",
    "output": "11"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6]",
    "output": "14"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxScoreOperations = function(nums) {\n};\n",
  "python": "class Solution:\n    def maxScoreOperations(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxScoreOperations(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxScoreOperations(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxScoreOperations",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          2
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          3,
          4,
          6,
          8
        ]
      ],
      "expected": 11
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4,
          5,
          6
        ]
      ],
      "expected": 14
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        2,
        4
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        3,
        6,
        9,
        12
      ]
    ],
    "expected": 15
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        5,
        5,
        5,
        5
      ]
    ],
    "expected": 15
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8
      ]
    ],
    "expected": 28
  }
]$json$::jsonb,
    'approved'
),
(
    1695,
    '有向图中最大颜色值',
    '给定有向图和每个节点的颜色（colors[i] 为小写字母）。
一条路径的颜色值定义为路径上出现次数最多的颜色出现次数。
返回所有路径中的最大颜色值；如果图中有环返回 -1。',
    'hard',
    1000,
    256,
    ARRAY['图', '拓扑排序', '动态规划'],
    $json$[
  {
    "input": "colors = \"abaca\", edges = [[0, 1], [0, 2], [2, 3], [3, 4]]",
    "output": "3"
  },
  {
    "input": "colors = \"a\", edges = []",
    "output": "1"
  },
  {
    "input": "colors = \"abc\", edges = [[0, 1], [1, 2]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "colors = \"abaca\", edges = [[0, 1], [0, 2], [2, 3], [3, 4]]",
    "output": "3"
  },
  {
    "input": "colors = \"a\", edges = []",
    "output": "1"
  },
  {
    "input": "colors = \"abc\", edges = [[0, 1], [1, 2]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestColorValue = function(colors, edges) {\n};\n",
  "python": "class Solution:\n    def largestColorValue(self, colors: str, edges: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int largestColorValue(std::string colors, std::vector<std::vector<int>>& edges) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int largestColorValue(String colors, int[][] edges) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestColorValue",
  "params": [
    {
      "name": "colors",
      "type": "string"
    },
    {
      "name": "edges",
      "type": "int[][]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "abaca",
        [
          [
            0,
            1
          ],
          [
            0,
            2
          ],
          [
            2,
            3
          ],
          [
            3,
            4
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        "a",
        []
      ],
      "expected": 1
    },
    {
      "args": [
        "abc",
        [
          [
            0,
            1
          ],
          [
            1,
            2
          ]
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "ab",
      [
        [
          0,
          1
        ],
        [
          1,
          0
        ]
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      "aa",
      [
        [
          0,
          1
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      "xyz",
      []
    ],
    "expected": 1
  },
  {
    "args": [
      "aab",
      [
        [
          0,
          1
        ],
        [
          1,
          2
        ]
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      "abcabc",
      [
        [
          0,
          1
        ],
        [
          1,
          2
        ],
        [
          2,
          3
        ],
        [
          3,
          4
        ],
        [
          4,
          5
        ]
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1696,
    '从子集的和还原数组',
    '给定数组 arr 的所有子集和（共 2^n 个，包含空子集的和 0），以及 arr 的长度 n。
arr 中的元素均为正整数。
还原任意一个满足条件的数组；返回按非递减顺序排列的结果。',
    'hard',
    1000,
    256,
    ARRAY['数组', '分治', '哈希表'],
    $json$[
  {
    "input": "sums = [0, 1, 2, 3], n = 2",
    "output": "[1, 2]"
  },
  {
    "input": "sums = [0, 1, 1, 2], n = 2",
    "output": "[1, 1]"
  },
  {
    "input": "sums = [0, 1, 2, 3, 4, 5, 6, 7], n = 3",
    "output": "[1, 2, 4]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "sums = [0, 1, 2, 3], n = 2",
    "output": "[1, 2]"
  },
  {
    "input": "sums = [0, 1, 1, 2], n = 2",
    "output": "[1, 1]"
  },
  {
    "input": "sums = [0, 1, 2, 3, 4, 5, 6, 7], n = 3",
    "output": "[1, 2, 4]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findArrayFromSums = function(sums, n) {\n};\n",
  "python": "class Solution:\n    def findArrayFromSums(self, sums: list[int], n: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findArrayFromSums(std::vector<int>& sums, int n) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findArrayFromSums(int[] sums, int n) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findArrayFromSums",
  "params": [
    {
      "name": "sums",
      "type": "int[]"
    },
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          0,
          1,
          2,
          3
        ],
        2
      ],
      "expected": [
        1,
        2
      ]
    },
    {
      "args": [
        [
          0,
          1,
          1,
          2
        ],
        2
      ],
      "expected": [
        1,
        1
      ]
    },
    {
      "args": [
        [
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7
        ],
        3
      ],
      "expected": [
        1,
        2,
        4
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0,
        5
      ],
      1
    ],
    "expected": [
      5
    ]
  },
  {
    "args": [
      [
        0,
        2,
        4,
        6
      ],
      2
    ],
    "expected": [
      2,
      4
    ]
  },
  {
    "args": [
      [
        0,
        3,
        5,
        8
      ],
      2
    ],
    "expected": [
      3,
      5
    ]
  },
  {
    "args": [
      [
        0,
        1,
        1,
        2,
        2,
        3,
        3,
        4
      ],
      3
    ],
    "expected": [
      1,
      1,
      2
    ]
  },
  {
    "args": [
      [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15
      ],
      4
    ],
    "expected": [
      1,
      2,
      4,
      8
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1697,
    '矩阵转换后的秩',
    '给定 m x n 整数矩阵 matrix。
按以下规则把每个元素替换为它的秩：
秩从 1 开始；同一行或同一列中较大的元素秩严格更大；在满足条件的前提下尽量使用较小的秩。
返回替换后的矩阵。',
    'hard',
    1000,
    256,
    ARRAY['数组', '并查集', '矩阵', '排序'],
    $json$[
  {
    "input": "matrix = [[1, 2], [3, 4]]",
    "output": "[[1, 2], [2, 3]]"
  },
  {
    "input": "matrix = [[7, 7], [7, 7]]",
    "output": "[[1, 1], [1, 1]]"
  },
  {
    "input": "matrix = [[20, -21, 14], [-19, 4, 19], [22, -47, 24], [-19, 4, 19]]",
    "output": "[[4, 2, 3], [1, 3, 4], [5, 1, 6], [1, 3, 4]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 2], [3, 4]]",
    "output": "[[1, 2], [2, 3]]"
  },
  {
    "input": "matrix = [[7, 7], [7, 7]]",
    "output": "[[1, 1], [1, 1]]"
  },
  {
    "input": "matrix = [[20, -21, 14], [-19, 4, 19], [22, -47, 24], [-19, 4, 19]]",
    "output": "[[4, 2, 3], [1, 3, 4], [5, 1, 6], [1, 3, 4]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var matrixRankTransform = function(matrix) {\n};\n",
  "python": "class Solution:\n    def matrixRankTransform(self, matrix: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> matrixRankTransform(std::vector<std::vector<int>>& matrix) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] matrixRankTransform(int[][] matrix) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "matrixRankTransform",
  "params": [
    {
      "name": "matrix",
      "type": "int[][]"
    }
  ],
  "return_type": "int[][]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          [
            1,
            2
          ],
          [
            3,
            4
          ]
        ]
      ],
      "expected": [
        [
          1,
          2
        ],
        [
          2,
          3
        ]
      ]
    },
    {
      "args": [
        [
          [
            7,
            7
          ],
          [
            7,
            7
          ]
        ]
      ],
      "expected": [
        [
          1,
          1
        ],
        [
          1,
          1
        ]
      ]
    },
    {
      "args": [
        [
          [
            20,
            -21,
            14
          ],
          [
            -19,
            4,
            19
          ],
          [
            22,
            -47,
            24
          ],
          [
            -19,
            4,
            19
          ]
        ]
      ],
      "expected": [
        [
          4,
          2,
          3
        ],
        [
          1,
          3,
          4
        ],
        [
          5,
          1,
          6
        ],
        [
          1,
          3,
          4
        ]
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1
        ]
      ]
    ],
    "expected": [
      [
        1
      ]
    ]
  },
  {
    "args": [
      [
        [
          1,
          1
        ],
        [
          1,
          1
        ]
      ]
    ],
    "expected": [
      [
        1,
        1
      ],
      [
        1,
        1
      ]
    ]
  },
  {
    "args": [
      [
        [
          1,
          100
        ],
        [
          100,
          1
        ]
      ]
    ],
    "expected": [
      [
        1,
        2
      ],
      [
        2,
        1
      ]
    ]
  },
  {
    "args": [
      [
        [
          5,
          3,
          5
        ]
      ]
    ],
    "expected": [
      [
        2,
        1,
        2
      ]
    ]
  },
  {
    "args": [
      [
        [
          1,
          2,
          3
        ],
        [
          4,
          5,
          6
        ],
        [
          7,
          8,
          9
        ]
      ]
    ],
    "expected": [
      [
        1,
        2,
        3
      ],
      [
        2,
        3,
        4
      ],
      [
        3,
        4,
        5
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1698,
    '恰有 K 根木棍可以看到的排列数目',
    '将 1 到 n 的 n 根木棍按某个顺序排列。
从左边看，只有比之前所有木棍都高的木棍可见。
返回恰好能看到 k 根木棍的排列数目，模 1e9+7。',
    'hard',
    1000,
    256,
    ARRAY['数学', '动态规划', '组合数学'],
    $json$[
  {
    "input": "n = 3, k = 2",
    "output": "3"
  },
  {
    "input": "n = 5, k = 5",
    "output": "1"
  },
  {
    "input": "n = 4, k = 2",
    "output": "11"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, k = 2",
    "output": "3"
  },
  {
    "input": "n = 5, k = 5",
    "output": "1"
  },
  {
    "input": "n = 4, k = 2",
    "output": "11"
  }
]$json$::jsonb,
    $json${
  "javascript": "var kSticksVisible = function(n, k) {\n};\n",
  "python": "class Solution:\n    def kSticksVisible(self, n: int, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int kSticksVisible(int n, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int kSticksVisible(int n, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kSticksVisible",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        3,
        2
      ],
      "expected": 3
    },
    {
      "args": [
        5,
        5
      ],
      "expected": 1
    },
    {
      "args": [
        4,
        2
      ],
      "expected": 11
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      1
    ],
    "expected": 1
  },
  {
    "args": [
      2,
      1
    ],
    "expected": 1
  },
  {
    "args": [
      2,
      2
    ],
    "expected": 1
  },
  {
    "args": [
      5,
      1
    ],
    "expected": 24
  },
  {
    "args": [
      6,
      3
    ],
    "expected": 225
  },
  {
    "args": [
      10,
      4
    ],
    "expected": 723680
  }
]$json$::jsonb,
    'approved'
),
(
    1699,
    '队列中可以看到的人数',
    '给定队列中每个人的身高 heights。
对于 i < j，如果 i 与 j 之间所有人的身高都严格小于 heights[i] 且严格小于 heights[j]，
则 i 能看到 j。返回队列中所有可见对的总数。',
    'hard',
    1000,
    256,
    ARRAY['数组', '栈', '单调栈'],
    $json$[
  {
    "input": "heights = [10, 6, 8, 5, 11, 9]",
    "output": "8"
  },
  {
    "input": "heights = [5, 1, 2, 3, 4]",
    "output": "7"
  },
  {
    "input": "heights = [1, 2, 3, 4, 5]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "heights = [10, 6, 8, 5, 11, 9]",
    "output": "8"
  },
  {
    "input": "heights = [5, 1, 2, 3, 4]",
    "output": "7"
  },
  {
    "input": "heights = [1, 2, 3, 4, 5]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var visiblePeopleCount = function(heights) {\n};\n",
  "python": "class Solution:\n    def visiblePeopleCount(self, heights: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int visiblePeopleCount(std::vector<int>& heights) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int visiblePeopleCount(int[] heights) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "visiblePeopleCount",
  "params": [
    {
      "name": "heights",
      "type": "int[]"
    }
  ],
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          10,
          6,
          8,
          5,
          11,
          9
        ]
      ],
      "expected": 8
    },
    {
      "args": [
        [
          5,
          1,
          2,
          3,
          4
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4,
          5
        ]
      ],
      "expected": 4
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        2,
        2
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        3,
        3,
        3
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        5,
        4,
        3,
        2,
        1
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        1,
        3,
        2,
        4
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        2,
        1,
        2,
        1,
        2
      ]
    ],
    "expected": 6
  }
]$json$::jsonb,
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
    GREATEST((SELECT COALESCE(MAX(id), 1) FROM problems), 1699)
);

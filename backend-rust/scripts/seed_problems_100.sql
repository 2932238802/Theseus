-- 仅用于本地/测试环境的题目种子数据。
-- 使用固定 ID 1200-1299，便于通过 clean_dev.sql 安全清理。
-- 100 道函数式题目（run_config + 公开用例 + 隐藏 judge_cases），
-- 与 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）、seed_problems_82.sql（1116-1197）合计 200 题。

INSERT INTO problems (
    id, title, description, difficulty, time_limit, memory_limit, tags,
    examples, test_cases, code_template, run_config, judge_cases, review_status
) VALUES
(
    1200,
    '有序数组中的两数之和',
    '给定一个按非递减顺序排列的整数数组 nums 和一个目标值 target，请找出和为目标值的两个整数。
返回它们的 1 基下标 [index1, index2]，要求 index1 < index2。可以假设每种输入恰好对应一个答案，且同一个元素不能重复使用。

提示：
- 2 <= nums.length <= 10^4
- -10^9 <= nums[i], target <= 10^9',
    'easy',
    1000,
    256,
    ARRAY['数组', '双指针', '二分查找'],
    $json$[
  {
    "input": "nums = [2, 7, 11, 15], target = 9",
    "output": "[1, 2]"
  },
  {
    "input": "nums = [2, 3, 4], target = 6",
    "output": "[1, 3]"
  },
  {
    "input": "nums = [-1, 0, 1], target = 0",
    "output": "[1, 3]"
  },
  {
    "input": "nums = [1, 2], target = 3",
    "output": "[1, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 7, 11, 15], target = 9",
    "output": "[1, 2]"
  },
  {
    "input": "nums = [2, 3, 4], target = 6",
    "output": "[1, 3]"
  },
  {
    "input": "nums = [-1, 0, 1], target = 0",
    "output": "[1, 3]"
  },
  {
    "input": "nums = [1, 2], target = 3",
    "output": "[1, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var twoSumSorted = function(nums, target) {\n};\n",
  "python": "class Solution:\n    def twoSumSorted(self, nums: list[int], target: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> twoSumSorted(std::vector<int>& nums, int target) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] twoSumSorted(int[] nums, int target) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "twoSumSorted",
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
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          2,
          7,
          11,
          15
        ],
        9
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
          3,
          4
        ],
        6
      ],
      "expected": [
        1,
        3
      ]
    },
    {
      "args": [
        [
          -1,
          0,
          1
        ],
        0
      ],
      "expected": [
        1,
        3
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
        1,
        2,
        3,
        4
      ],
      5
    ],
    "expected": [
      1,
      4
    ]
  },
  {
    "args": [
      [
        0,
        0,
        3,
        4
      ],
      0
    ],
    "expected": [
      1,
      2
    ]
  },
  {
    "args": [
      [
        -5,
        -2,
        -1
      ],
      -7
    ],
    "expected": [
      1,
      2
    ]
  },
  {
    "args": [
      [
        1,
        3,
        5,
        8
      ],
      13
    ],
    "expected": [
      3,
      4
    ]
  },
  {
    "args": [
      [
        1,
        5,
        9
      ],
      10
    ],
    "expected": [
      1,
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1201,
    '整数反转',
    '给定一个 32 位有符号整数 x，返回将 x 中的数字部分反转后的结果。
如果反转后整数超出 32 位有符号整数范围 [-2^31, 2^31 - 1]，返回 0。负数反转后仍为负数。

提示：
- -2^31 <= x <= 2^31 - 1',
    'easy',
    1000,
    256,
    ARRAY['数学', '字符串'],
    $json$[
  {
    "input": "x = 123",
    "output": "321"
  },
  {
    "input": "x = -123",
    "output": "-321"
  },
  {
    "input": "x = 120",
    "output": "21"
  },
  {
    "input": "x = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "x = 123",
    "output": "321"
  },
  {
    "input": "x = -123",
    "output": "-321"
  },
  {
    "input": "x = 120",
    "output": "21"
  },
  {
    "input": "x = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var reverseInteger = function(x) {\n};\n",
  "python": "class Solution:\n    def reverseInteger(self, x: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int reverseInteger(int x) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int reverseInteger(int x) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reverseInteger",
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
        123
      ],
      "expected": 321
    },
    {
      "args": [
        -123
      ],
      "expected": -321
    },
    {
      "args": [
        120
      ],
      "expected": 21
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
      100
    ],
    "expected": 1
  },
  {
    "args": [
      -100
    ],
    "expected": -1
  },
  {
    "args": [
      1534236469
    ],
    "expected": 0
  },
  {
    "args": [
      -2147483648
    ],
    "expected": 0
  },
  {
    "args": [
      2147483647
    ],
    "expected": 0
  },
  {
    "args": [
      901000
    ],
    "expected": 109
  }
]$json$::jsonb,
    'approved'
),
(
    1202,
    '罗马数字转整数',
    '给定一个罗马数字 s，将其转换成整数。
罗马数字包含字符 I、V、X、L、C、D、M；当较小数字位于较大数字左侧时表示减法。

提示：
- 1 <= s.length <= 15
- s 仅包含字符 I、V、X、L、C、D、M
- s 是有效的罗马数字',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表', '数学'],
    $json$[
  {
    "input": "s = \"III\"",
    "output": "3"
  },
  {
    "input": "s = \"IV\"",
    "output": "4"
  },
  {
    "input": "s = \"IX\"",
    "output": "9"
  },
  {
    "input": "s = \"MCMXCIV\"",
    "output": "1994"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"III\"",
    "output": "3"
  },
  {
    "input": "s = \"IV\"",
    "output": "4"
  },
  {
    "input": "s = \"IX\"",
    "output": "9"
  },
  {
    "input": "s = \"MCMXCIV\"",
    "output": "1994"
  }
]$json$::jsonb,
    $json${
  "javascript": "var romanToInt = function(s) {\n};\n",
  "python": "class Solution:\n    def romanToInt(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int romanToInt(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int romanToInt(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "romanToInt",
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
        "III"
      ],
      "expected": 3
    },
    {
      "args": [
        "IV"
      ],
      "expected": 4
    },
    {
      "args": [
        "IX"
      ],
      "expected": 9
    },
    {
      "args": [
        "MCMXCIV"
      ],
      "expected": 1994
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "I"
    ],
    "expected": 1
  },
  {
    "args": [
      "V"
    ],
    "expected": 5
  },
  {
    "args": [
      "XL"
    ],
    "expected": 40
  },
  {
    "args": [
      "XC"
    ],
    "expected": 90
  },
  {
    "args": [
      "LVIII"
    ],
    "expected": 58
  },
  {
    "args": [
      "CDXCIX"
    ],
    "expected": 499
  },
  {
    "args": [
      "MMMCMXCIX"
    ],
    "expected": 3999
  }
]$json$::jsonb,
    'approved'
),
(
    1203,
    '最长公共后缀',
    '给定一个字符串数组 strs，返回这些字符串的最长公共后缀。
如果不存在公共后缀，返回空字符串。

提示：
- 1 <= strs.length <= 200
- 0 <= strs[i].length <= 200',
    'easy',
    1000,
    256,
    ARRAY['字符串', '数组'],
    $json$[
  {
    "input": "strs = [\"walking\", \"running\", \"swimming\"]",
    "output": "\"ing\""
  },
  {
    "input": "strs = [\"computer\", \"developer\", \"teacher\"]",
    "output": "\"er\""
  },
  {
    "input": "strs = [\"abc\", \"abc\"]",
    "output": "\"abc\""
  },
  {
    "input": "strs = [\"dog\", \"racecar\", \"car\"]",
    "output": "\"\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "strs = [\"walking\", \"running\", \"swimming\"]",
    "output": "\"ing\""
  },
  {
    "input": "strs = [\"computer\", \"developer\", \"teacher\"]",
    "output": "\"er\""
  },
  {
    "input": "strs = [\"abc\", \"abc\"]",
    "output": "\"abc\""
  },
  {
    "input": "strs = [\"dog\", \"racecar\", \"car\"]",
    "output": "\"\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestCommonSuffix = function(strs) {\n};\n",
  "python": "class Solution:\n    def longestCommonSuffix(self, strs: list[str]) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string longestCommonSuffix(std::vector<std::string>& strs) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String longestCommonSuffix(String[] strs) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestCommonSuffix",
  "params": [
    {
      "name": "strs",
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
        [
          "walking",
          "running",
          "swimming"
        ]
      ],
      "expected": "ing"
    },
    {
      "args": [
        [
          "computer",
          "developer",
          "teacher"
        ]
      ],
      "expected": "er"
    },
    {
      "args": [
        [
          "abc",
          "abc"
        ]
      ],
      "expected": "abc"
    },
    {
      "args": [
        [
          "dog",
          "racecar",
          "car"
        ]
      ],
      "expected": ""
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "a",
        "ba",
        "cba"
      ]
    ],
    "expected": "a"
  },
  {
    "args": [
      [
        "end",
        "friend",
        "weekend"
      ]
    ],
    "expected": "end"
  },
  {
    "args": [
      [
        "x",
        "y"
      ]
    ],
    "expected": ""
  },
  {
    "args": [
      [
        "function",
        "mountain"
      ]
    ],
    "expected": "n"
  },
  {
    "args": [
      [
        "ab",
        "cab",
        "lab"
      ]
    ],
    "expected": "ab"
  }
]$json$::jsonb,
    'approved'
),
(
    1204,
    '合并两个有序数组',
    '给定两个按非递减顺序排列的整数数组 nums1 和 nums2，返回合并后的非递减数组。

提示：
- 0 <= nums1.length, nums2.length <= 10^4
- -10^9 <= nums1[i], nums2[j] <= 10^9',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "nums1 = [1, 2, 3], nums2 = [2, 5, 6]",
    "output": "[1, 2, 2, 3, 5, 6]"
  },
  {
    "input": "nums1 = [1], nums2 = []",
    "output": "[1]"
  },
  {
    "input": "nums1 = [], nums2 = [1]",
    "output": "[1]"
  },
  {
    "input": "nums1 = [4, 5], nums2 = [1, 2]",
    "output": "[1, 2, 4, 5]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums1 = [1, 2, 3], nums2 = [2, 5, 6]",
    "output": "[1, 2, 2, 3, 5, 6]"
  },
  {
    "input": "nums1 = [1], nums2 = []",
    "output": "[1]"
  },
  {
    "input": "nums1 = [], nums2 = [1]",
    "output": "[1]"
  },
  {
    "input": "nums1 = [4, 5], nums2 = [1, 2]",
    "output": "[1, 2, 4, 5]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var mergeTwoSorted = function(nums1, nums2) {\n};\n",
  "python": "class Solution:\n    def mergeTwoSorted(self, nums1: list[int], nums2: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> mergeTwoSorted(std::vector<int>& nums1, std::vector<int>& nums2) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] mergeTwoSorted(int[] nums1, int[] nums2) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "mergeTwoSorted",
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
          1,
          2,
          3
        ],
        [
          2,
          5,
          6
        ]
      ],
      "expected": [
        1,
        2,
        2,
        3,
        5,
        6
      ]
    },
    {
      "args": [
        [
          1
        ],
        []
      ],
      "expected": [
        1
      ]
    },
    {
      "args": [
        [],
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
          4,
          5
        ],
        [
          1,
          2
        ]
      ],
      "expected": [
        1,
        2,
        4,
        5
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [],
      []
    ],
    "expected": []
  },
  {
    "args": [
      [
        1,
        1
      ],
      [
        1
      ]
    ],
    "expected": [
      1,
      1,
      1
    ]
  },
  {
    "args": [
      [
        -3,
        -1
      ],
      [
        -2
      ]
    ],
    "expected": [
      -3,
      -2,
      -1
    ]
  },
  {
    "args": [
      [
        1,
        4,
        9
      ],
      [
        2,
        3
      ]
    ],
    "expected": [
      1,
      2,
      3,
      4,
      9
    ]
  },
  {
    "args": [
      [
        5
      ],
      [
        1,
        2,
        3,
        4
      ]
    ],
    "expected": [
      1,
      2,
      3,
      4,
      5
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1205,
    '删除有序数组中的重复项 II',
    '给定一个非递减数组 nums，原地删除重复元素，使每个元素最多出现两次，并返回删除后的数组。
元素相对顺序保持不变。

提示：
- 1 <= nums.length <= 10^5
- -10^4 <= nums[i] <= 10^4',
    'easy',
    1000,
    256,
    ARRAY['数组', '双指针'],
    $json$[
  {
    "input": "nums = [1, 1, 1, 2, 2, 3]",
    "output": "[1, 1, 2, 2, 3]"
  },
  {
    "input": "nums = [0, 0, 1, 1, 1, 1, 2, 3, 3]",
    "output": "[0, 0, 1, 1, 2, 3, 3]"
  },
  {
    "input": "nums = [1]",
    "output": "[1]"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "[1, 2, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 1, 2, 2, 3]",
    "output": "[1, 1, 2, 2, 3]"
  },
  {
    "input": "nums = [0, 0, 1, 1, 1, 1, 2, 3, 3]",
    "output": "[0, 0, 1, 1, 2, 3, 3]"
  },
  {
    "input": "nums = [1]",
    "output": "[1]"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "[1, 2, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeDuplicatesII = function(nums) {\n};\n",
  "python": "class Solution:\n    def removeDuplicatesII(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> removeDuplicatesII(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] removeDuplicatesII(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeDuplicatesII",
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
          1,
          1,
          2,
          2,
          3
        ]
      ],
      "expected": [
        1,
        1,
        2,
        2,
        3
      ]
    },
    {
      "args": [
        [
          0,
          0,
          1,
          1,
          1,
          1,
          2,
          3,
          3
        ]
      ],
      "expected": [
        0,
        0,
        1,
        1,
        2,
        3,
        3
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
      1,
      1
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
      1,
      1
    ]
  },
  {
    "args": [
      [
        0,
        0,
        0,
        0
      ]
    ],
    "expected": [
      0,
      0
    ]
  },
  {
    "args": [
      [
        -1,
        -1,
        -1,
        0,
        0,
        1
      ]
    ],
    "expected": [
      -1,
      -1,
      0,
      0,
      1
    ]
  },
  {
    "args": [
      [
        1,
        1,
        2,
        2,
        2,
        3,
        3
      ]
    ],
    "expected": [
      1,
      1,
      2,
      2,
      3,
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1206,
    '删除最外层的括号',
    '给定一个有效的括号字符串 s，删除每一个最外层括号，返回结果字符串。
例如 "(()())(())" 删除最外层后得到 "()()()"。

提示：
- 0 <= s.length <= 10^4
- s 是有效的括号字符串',
    'easy',
    1000,
    256,
    ARRAY['字符串', '栈'],
    $json$[
  {
    "input": "s = \"(()())(())\"",
    "output": "\"()()()\""
  },
  {
    "input": "s = \"(()())(())(()(()))\"",
    "output": "\"()()()()(())\""
  },
  {
    "input": "s = \"()()\"",
    "output": "\"\""
  },
  {
    "input": "s = \"((()))\"",
    "output": "\"(())\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"(()())(())\"",
    "output": "\"()()()\""
  },
  {
    "input": "s = \"(()())(())(()(()))\"",
    "output": "\"()()()()(())\""
  },
  {
    "input": "s = \"()()\"",
    "output": "\"\""
  },
  {
    "input": "s = \"((()))\"",
    "output": "\"(())\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeOuterParentheses = function(s) {\n};\n",
  "python": "class Solution:\n    def removeOuterParentheses(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string removeOuterParentheses(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String removeOuterParentheses(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeOuterParentheses",
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
        "(()())(())"
      ],
      "expected": "()()()"
    },
    {
      "args": [
        "(()())(())(()(()))"
      ],
      "expected": "()()()()(())"
    },
    {
      "args": [
        "()()"
      ],
      "expected": ""
    },
    {
      "args": [
        "((()))"
      ],
      "expected": "(())"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "()"
    ],
    "expected": ""
  },
  {
    "args": [
      "(())"
    ],
    "expected": "()"
  },
  {
    "args": [
      "(((())))"
    ],
    "expected": "((()))"
  },
  {
    "args": [
      "(()(()))"
    ],
    "expected": "()(())"
  },
  {
    "args": [
      "((()())())"
    ],
    "expected": "(()())()"
  }
]$json$::jsonb,
    'approved'
),
(
    1207,
    '二进制中 1 的个数',
    '给定一个非负整数 n，返回其二进制表示中 1 的个数。

提示：
- 0 <= n <= 2^31 - 1',
    'easy',
    1000,
    256,
    ARRAY['位运算'],
    $json$[
  {
    "input": "n = 11",
    "output": "3"
  },
  {
    "input": "n = 128",
    "output": "1"
  },
  {
    "input": "n = 0",
    "output": "0"
  },
  {
    "input": "n = 7",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 11",
    "output": "3"
  },
  {
    "input": "n = 128",
    "output": "1"
  },
  {
    "input": "n = 0",
    "output": "0"
  },
  {
    "input": "n = 7",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var hammingWeight = function(n) {\n};\n",
  "python": "class Solution:\n    def hammingWeight(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int hammingWeight(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int hammingWeight(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "hammingWeight",
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
        11
      ],
      "expected": 3
    },
    {
      "args": [
        128
      ],
      "expected": 1
    },
    {
      "args": [
        0
      ],
      "expected": 0
    },
    {
      "args": [
        7
      ],
      "expected": 3
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
    "expected": 2
  },
  {
    "args": [
      255
    ],
    "expected": 8
  },
  {
    "args": [
      1023
    ],
    "expected": 10
  },
  {
    "args": [
      2147483647
    ],
    "expected": 31
  },
  {
    "args": [
      1024
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1208,
    '只出现一次的数字 II',
    '给定一个非空整数数组，除某个元素只出现一次外，其余元素都恰好出现三次。找出只出现一次的元素。

提示：
- 1 <= nums.length <= 3 * 10^4
- 除答案外，其他元素均出现三次',
    'easy',
    1000,
    256,
    ARRAY['数组', '位运算', '哈希表'],
    $json$[
  {
    "input": "nums = [2, 2, 3, 2]",
    "output": "3"
  },
  {
    "input": "nums = [0, 1, 0, 1, 0, 1, 99]",
    "output": "99"
  },
  {
    "input": "nums = [1, 1, 1, 2]",
    "output": "2"
  },
  {
    "input": "nums = [-2, -2, 1, -2]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 2, 3, 2]",
    "output": "3"
  },
  {
    "input": "nums = [0, 1, 0, 1, 0, 1, 99]",
    "output": "99"
  },
  {
    "input": "nums = [1, 1, 1, 2]",
    "output": "2"
  },
  {
    "input": "nums = [-2, -2, 1, -2]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var singleNumberII = function(nums) {\n};\n",
  "python": "class Solution:\n    def singleNumberII(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int singleNumberII(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int singleNumberII(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "singleNumberII",
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
          2,
          3,
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
          0,
          1,
          0,
          1,
          99
        ]
      ],
      "expected": 99
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
      "expected": 2
    },
    {
      "args": [
        [
          -2,
          -2,
          1,
          -2
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
        5,
        5,
        5,
        7
      ]
    ],
    "expected": 7
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
        0,
        0,
        0,
        4
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        -1,
        -1,
        -1,
        8
      ]
    ],
    "expected": 8
  },
  {
    "args": [
      [
        3,
        3,
        2,
        3,
        2,
        2,
        9
      ]
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1209,
    '缺失数字',
    '给定一个包含 n 个不同整数的数组 nums，数字范围为 [0, n]，找出其中缺失的那个数字。

提示：
- 1 <= nums.length <= 10^4
- 所有数字唯一',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "nums = [3, 0, 1]",
    "output": "2"
  },
  {
    "input": "nums = [0, 1]",
    "output": "2"
  },
  {
    "input": "nums = [9, 6, 4, 2, 3, 5, 7, 0, 1]",
    "output": "8"
  },
  {
    "input": "nums = [0]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 0, 1]",
    "output": "2"
  },
  {
    "input": "nums = [0, 1]",
    "output": "2"
  },
  {
    "input": "nums = [9, 6, 4, 2, 3, 5, 7, 0, 1]",
    "output": "8"
  },
  {
    "input": "nums = [0]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var missingNumber = function(nums) {\n};\n",
  "python": "class Solution:\n    def missingNumber(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int missingNumber(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int missingNumber(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "missingNumber",
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
          1
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          9,
          6,
          4,
          2,
          3,
          5,
          7,
          0,
          1
        ]
      ],
      "expected": 8
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
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        0,
        2
      ]
    ],
    "expected": 1
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
        0,
        1,
        3
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        4,
        3,
        1,
        0
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        5,
        4,
        2,
        1,
        0
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1210,
    '阶乘后的零',
    '给定整数 n，返回 n! 结果中尾随零的数量。

提示：
- 0 <= n <= 10^4',
    'easy',
    1000,
    256,
    ARRAY['数学'],
    $json$[
  {
    "input": "n = 3",
    "output": "0"
  },
  {
    "input": "n = 5",
    "output": "1"
  },
  {
    "input": "n = 0",
    "output": "0"
  },
  {
    "input": "n = 25",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3",
    "output": "0"
  },
  {
    "input": "n = 5",
    "output": "1"
  },
  {
    "input": "n = 0",
    "output": "0"
  },
  {
    "input": "n = 25",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var trailingZeroes = function(n) {\n};\n",
  "python": "class Solution:\n    def trailingZeroes(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int trailingZeroes(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int trailingZeroes(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "trailingZeroes",
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
      "expected": 0
    },
    {
      "args": [
        5
      ],
      "expected": 1
    },
    {
      "args": [
        0
      ],
      "expected": 0
    },
    {
      "args": [
        25
      ],
      "expected": 6
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
      10
    ],
    "expected": 2
  },
  {
    "args": [
      20
    ],
    "expected": 4
  },
  {
    "args": [
      50
    ],
    "expected": 12
  },
  {
    "args": [
      100
    ],
    "expected": 24
  },
  {
    "args": [
      1000
    ],
    "expected": 249
  },
  {
    "args": [
      10000
    ],
    "expected": 2499
  }
]$json$::jsonb,
    'approved'
),
(
    1211,
    'Excel 表列名称',
    '给定一个正整数 columnNumber，返回其在 Excel 表中的列名称。
列名称使用 A-Z 表示，1 对应 A，26 对应 Z，27 对应 AA。

提示：
- 1 <= columnNumber <= 2^31 - 1',
    'easy',
    1000,
    256,
    ARRAY['数学', '字符串'],
    $json$[
  {
    "input": "columnNumber = 1",
    "output": "\"A\""
  },
  {
    "input": "columnNumber = 28",
    "output": "\"AB\""
  },
  {
    "input": "columnNumber = 701",
    "output": "\"ZY\""
  },
  {
    "input": "columnNumber = 26",
    "output": "\"Z\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "columnNumber = 1",
    "output": "\"A\""
  },
  {
    "input": "columnNumber = 28",
    "output": "\"AB\""
  },
  {
    "input": "columnNumber = 701",
    "output": "\"ZY\""
  },
  {
    "input": "columnNumber = 26",
    "output": "\"Z\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var excelTitle = function(columnNumber) {\n};\n",
  "python": "class Solution:\n    def excelTitle(self, columnNumber: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string excelTitle(int columnNumber) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String excelTitle(int columnNumber) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "excelTitle",
  "params": [
    {
      "name": "columnNumber",
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
        1
      ],
      "expected": "A"
    },
    {
      "args": [
        28
      ],
      "expected": "AB"
    },
    {
      "args": [
        701
      ],
      "expected": "ZY"
    },
    {
      "args": [
        26
      ],
      "expected": "Z"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2
    ],
    "expected": "B"
  },
  {
    "args": [
      27
    ],
    "expected": "AA"
  },
  {
    "args": [
      52
    ],
    "expected": "AZ"
  },
  {
    "args": [
      53
    ],
    "expected": "BA"
  },
  {
    "args": [
      702
    ],
    "expected": "ZZ"
  },
  {
    "args": [
      18278
    ],
    "expected": "ZZZ"
  },
  {
    "args": [
      2147483647
    ],
    "expected": "FXSHRXW"
  }
]$json$::jsonb,
    'approved'
),
(
    1212,
    '快乐数',
    '编写算法判断一个数 n 是否为快乐数。
快乐数的定义为：不断将数字替换为各位数字平方和，最终得到 1；若循环则不是快乐数。

提示：
- 1 <= n <= 2^31 - 1',
    'easy',
    1000,
    256,
    ARRAY['数学', '哈希表'],
    $json$[
  {
    "input": "n = 19",
    "output": "true"
  },
  {
    "input": "n = 2",
    "output": "false"
  },
  {
    "input": "n = 7",
    "output": "true"
  },
  {
    "input": "n = 100",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 19",
    "output": "true"
  },
  {
    "input": "n = 2",
    "output": "false"
  },
  {
    "input": "n = 7",
    "output": "true"
  },
  {
    "input": "n = 100",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isHappy = function(n) {\n};\n",
  "python": "class Solution:\n    def isHappy(self, n: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isHappy(int n) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isHappy(int n) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isHappy",
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
        19
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
        7
      ],
      "expected": true
    },
    {
      "args": [
        100
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1
    ],
    "expected": true
  },
  {
    "args": [
      4
    ],
    "expected": false
  },
  {
    "args": [
      10
    ],
    "expected": true
  },
  {
    "args": [
      13
    ],
    "expected": true
  },
  {
    "args": [
      23
    ],
    "expected": true
  },
  {
    "args": [
      68
    ],
    "expected": true
  },
  {
    "args": [
      1111111
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1213,
    '各位相加',
    '给定一个非负整数 num，反复将各位数字相加，直到结果为一位数并返回。

提示：
- 0 <= num <= 2^31 - 1',
    'easy',
    1000,
    256,
    ARRAY['数学', '模拟'],
    $json$[
  {
    "input": "num = 38",
    "output": "2"
  },
  {
    "input": "num = 0",
    "output": "0"
  },
  {
    "input": "num = 9",
    "output": "9"
  },
  {
    "input": "num = 123",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 38",
    "output": "2"
  },
  {
    "input": "num = 0",
    "output": "0"
  },
  {
    "input": "num = 9",
    "output": "9"
  },
  {
    "input": "num = 123",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var addDigits = function(num) {\n};\n",
  "python": "class Solution:\n    def addDigits(self, num: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int addDigits(int num) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int addDigits(int num) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "addDigits",
  "params": [
    {
      "name": "num",
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
        38
      ],
      "expected": 2
    },
    {
      "args": [
        0
      ],
      "expected": 0
    },
    {
      "args": [
        9
      ],
      "expected": 9
    },
    {
      "args": [
        123
      ],
      "expected": 6
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
      10
    ],
    "expected": 1
  },
  {
    "args": [
      99
    ],
    "expected": 9
  },
  {
    "args": [
      100
    ],
    "expected": 1
  },
  {
    "args": [
      999
    ],
    "expected": 9
  },
  {
    "args": [
      456
    ],
    "expected": 6
  },
  {
    "args": [
      2147483647
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1214,
    '找不同',
    '字符串 t 由字符串 s 随机重排，并在随机位置添加一个字母构成。请找出被添加的字母。

提示：
- 0 <= s.length <= 10^4
- t.length == s.length + 1
- s 和 t 只包含小写英文字母',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表', '位运算'],
    $json$[
  {
    "input": "s = \"abcd\", t = \"abcde\"",
    "output": "\"e\""
  },
  {
    "input": "s = \"\", t = \"y\"",
    "output": "\"y\""
  },
  {
    "input": "s = \"a\", t = \"aa\"",
    "output": "\"a\""
  },
  {
    "input": "s = \"ae\", t = \"aea\"",
    "output": "\"a\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abcd\", t = \"abcde\"",
    "output": "\"e\""
  },
  {
    "input": "s = \"\", t = \"y\"",
    "output": "\"y\""
  },
  {
    "input": "s = \"a\", t = \"aa\"",
    "output": "\"a\""
  },
  {
    "input": "s = \"ae\", t = \"aea\"",
    "output": "\"a\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var findTheDifference = function(s, t) {\n};\n",
  "python": "class Solution:\n    def findTheDifference(self, s: str, t: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string findTheDifference(std::string s, std::string t) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String findTheDifference(String s, String t) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findTheDifference",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "t",
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
        "abcd",
        "abcde"
      ],
      "expected": "e"
    },
    {
      "args": [
        "",
        "y"
      ],
      "expected": "y"
    },
    {
      "args": [
        "a",
        "aa"
      ],
      "expected": "a"
    },
    {
      "args": [
        "ae",
        "aea"
      ],
      "expected": "a"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abc",
      "cbad"
    ],
    "expected": "d"
  },
  {
    "args": [
      "x",
      "xy"
    ],
    "expected": "y"
  },
  {
    "args": [
      "hello",
      "oellhh"
    ],
    "expected": "h"
  },
  {
    "args": [
      "zz",
      "zzz"
    ],
    "expected": "z"
  },
  {
    "args": [
      "abcd",
      "edcba"
    ],
    "expected": "e"
  }
]$json$::jsonb,
    'approved'
),
(
    1215,
    '判断回文排列',
    '给定一个字符串，判断其字符重排后能否形成回文串。

提示：
- 1 <= s.length <= 10^4
- s 只包含小写英文字母',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "s = \"code\"",
    "output": "false"
  },
  {
    "input": "s = \"aab\"",
    "output": "true"
  },
  {
    "input": "s = \"carerac\"",
    "output": "true"
  },
  {
    "input": "s = \"abc\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"code\"",
    "output": "false"
  },
  {
    "input": "s = \"aab\"",
    "output": "true"
  },
  {
    "input": "s = \"carerac\"",
    "output": "true"
  },
  {
    "input": "s = \"abc\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canPermutePalindrome = function(s) {\n};\n",
  "python": "class Solution:\n    def canPermutePalindrome(self, s: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canPermutePalindrome(std::string s) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canPermutePalindrome(String s) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canPermutePalindrome",
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
        "code"
      ],
      "expected": false
    },
    {
      "args": [
        "aab"
      ],
      "expected": true
    },
    {
      "args": [
        "carerac"
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
      "aa"
    ],
    "expected": true
  },
  {
    "args": [
      "aabb"
    ],
    "expected": true
  },
  {
    "args": [
      "aabbc"
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
      "abccba"
    ],
    "expected": true
  },
  {
    "args": [
      "xyz"
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1216,
    '压缩字符串',
    '给定一个字符串 s，将连续重复字符压缩为“字符 + 次数”的形式并返回压缩结果。
即使长度为 1 也要写出次数。

提示：
- 0 <= s.length <= 10^4
- s 只包含小写英文字母',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "s = \"aabcccccaaa\"",
    "output": "\"a2b1c5a3\""
  },
  {
    "input": "s = \"abc\"",
    "output": "\"a1b1c1\""
  },
  {
    "input": "s = \"\"",
    "output": "\"\""
  },
  {
    "input": "s = \"aaaa\"",
    "output": "\"a4\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aabcccccaaa\"",
    "output": "\"a2b1c5a3\""
  },
  {
    "input": "s = \"abc\"",
    "output": "\"a1b1c1\""
  },
  {
    "input": "s = \"\"",
    "output": "\"\""
  },
  {
    "input": "s = \"aaaa\"",
    "output": "\"a4\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var compressString = function(s) {\n};\n",
  "python": "class Solution:\n    def compressString(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string compressString(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String compressString(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "compressString",
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
        "aabcccccaaa"
      ],
      "expected": "a2b1c5a3"
    },
    {
      "args": [
        "abc"
      ],
      "expected": "a1b1c1"
    },
    {
      "args": [
        ""
      ],
      "expected": ""
    },
    {
      "args": [
        "aaaa"
      ],
      "expected": "a4"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a"
    ],
    "expected": "a1"
  },
  {
    "args": [
      "abbcccddddeeeee"
    ],
    "expected": "a1b2c3d4e5"
  },
  {
    "args": [
      "zzzzzzzzzz"
    ],
    "expected": "z10"
  },
  {
    "args": [
      "ababab"
    ],
    "expected": "a1b1a1b1a1b1"
  },
  {
    "args": [
      "aaabba"
    ],
    "expected": "a3b2a1"
  }
]$json$::jsonb,
    'approved'
),
(
    1217,
    '字符串相加',
    '给定两个非负整数字符串 num1 和 num2，返回它们的和，结果也用字符串表示。
不能直接将输入转换为整数。

提示：
- 1 <= num1.length, num2.length <= 10^4
- 输入不含前导零，0 本身除外',
    'easy',
    1000,
    256,
    ARRAY['字符串', '数学', '模拟'],
    $json$[
  {
    "input": "num1 = \"11\", num2 = \"123\"",
    "output": "\"134\""
  },
  {
    "input": "num1 = \"456\", num2 = \"77\"",
    "output": "\"533\""
  },
  {
    "input": "num1 = \"0\", num2 = \"0\"",
    "output": "\"0\""
  },
  {
    "input": "num1 = \"999\", num2 = \"1\"",
    "output": "\"1000\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num1 = \"11\", num2 = \"123\"",
    "output": "\"134\""
  },
  {
    "input": "num1 = \"456\", num2 = \"77\"",
    "output": "\"533\""
  },
  {
    "input": "num1 = \"0\", num2 = \"0\"",
    "output": "\"0\""
  },
  {
    "input": "num1 = \"999\", num2 = \"1\"",
    "output": "\"1000\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var addStrings = function(num1, num2) {\n};\n",
  "python": "class Solution:\n    def addStrings(self, num1: str, num2: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string addStrings(std::string num1, std::string num2) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String addStrings(String num1, String num2) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "addStrings",
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
        "11",
        "123"
      ],
      "expected": "134"
    },
    {
      "args": [
        "456",
        "77"
      ],
      "expected": "533"
    },
    {
      "args": [
        "0",
        "0"
      ],
      "expected": "0"
    },
    {
      "args": [
        "999",
        "1"
      ],
      "expected": "1000"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "1",
      "9"
    ],
    "expected": "10"
  },
  {
    "args": [
      "99",
      "1"
    ],
    "expected": "100"
  },
  {
    "args": [
      "123456789",
      "987654321"
    ],
    "expected": "1111111110"
  },
  {
    "args": [
      "0",
      "123"
    ],
    "expected": "123"
  },
  {
    "args": [
      "58",
      "42"
    ],
    "expected": "100"
  }
]$json$::jsonb,
    'approved'
),
(
    1218,
    '验证回文串',
    '给定一个字符串 s，只考虑字母和数字字符，忽略大小写，判断它是否为回文串。

提示：
- 1 <= s.length <= 2 * 10^5
- s 由 ASCII 字符组成',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "s = \"A man, a plan, a canal: Panama\"",
    "output": "true"
  },
  {
    "input": "s = \"race a car\"",
    "output": "false"
  },
  {
    "input": "s = \" \"",
    "output": "true"
  },
  {
    "input": "s = \"0P\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"A man, a plan, a canal: Panama\"",
    "output": "true"
  },
  {
    "input": "s = \"race a car\"",
    "output": "false"
  },
  {
    "input": "s = \" \"",
    "output": "true"
  },
  {
    "input": "s = \"0P\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isPalindromeString = function(s) {\n};\n",
  "python": "class Solution:\n    def isPalindromeString(self, s: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isPalindromeString(std::string s) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isPalindromeString(String s) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isPalindromeString",
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
        "A man, a plan, a canal: Panama"
      ],
      "expected": true
    },
    {
      "args": [
        "race a car"
      ],
      "expected": false
    },
    {
      "args": [
        " "
      ],
      "expected": true
    },
    {
      "args": [
        "0P"
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
    "expected": false
  },
  {
    "args": [
      "aba"
    ],
    "expected": true
  },
  {
    "args": [
      "abba"
    ],
    "expected": true
  },
  {
    "args": [
      "a."
    ],
    "expected": true
  },
  {
    "args": [
      "No 'x' in Nixon"
    ],
    "expected": true
  },
  {
    "args": [
      "12 21"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1219,
    '反转字符串中的元音字母',
    '给定一个字符串 s，反转其中所有元音字母并返回结果。元音字母包括 a、e、i、o、u 及大写形式。

提示：
- 1 <= s.length <= 10^5
- s 由 ASCII 可打印字符组成',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "s = \"hello\"",
    "output": "\"holle\""
  },
  {
    "input": "s = \"leetcode\"",
    "output": "\"leotcede\""
  },
  {
    "input": "s = \"aA\"",
    "output": "\"Aa\""
  },
  {
    "input": "s = \"xyz\"",
    "output": "\"xyz\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"hello\"",
    "output": "\"holle\""
  },
  {
    "input": "s = \"leetcode\"",
    "output": "\"leotcede\""
  },
  {
    "input": "s = \"aA\"",
    "output": "\"Aa\""
  },
  {
    "input": "s = \"xyz\"",
    "output": "\"xyz\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var reverseVowels = function(s) {\n};\n",
  "python": "class Solution:\n    def reverseVowels(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string reverseVowels(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String reverseVowels(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reverseVowels",
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
        "hello"
      ],
      "expected": "holle"
    },
    {
      "args": [
        "leetcode"
      ],
      "expected": "leotcede"
    },
    {
      "args": [
        "aA"
      ],
      "expected": "Aa"
    },
    {
      "args": [
        "xyz"
      ],
      "expected": "xyz"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "aeiou"
    ],
    "expected": "uoiea"
  },
  {
    "args": [
      "hEllO"
    ],
    "expected": "hOllE"
  },
  {
    "args": [
      "racecar"
    ],
    "expected": "racecar"
  },
  {
    "args": [
      "bcdfg"
    ],
    "expected": "bcdfg"
  },
  {
    "args": [
      "AaEeIiOoUu"
    ],
    "expected": "uUoOiIeEaA"
  }
]$json$::jsonb,
    'approved'
),
(
    1220,
    '反转字符串 II',
    '给定字符串 s 和整数 k，从字符串开头算起，每计数至 2k 个字符就反转前 k 个字符。
如果剩余字符少于 k 个，则反转所有剩余字符；如果剩余字符在 k 到 2k 之间，则反转前 k 个字符。

提示：
- 1 <= s.length <= 10^4
- 1 <= k <= 10^4',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "s = \"abcdefg\", k = 2",
    "output": "\"bacdfeg\""
  },
  {
    "input": "s = \"abcd\", k = 2",
    "output": "\"bacd\""
  },
  {
    "input": "s = \"abcdef\", k = 3",
    "output": "\"cbadef\""
  },
  {
    "input": "s = \"a\", k = 1",
    "output": "\"a\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abcdefg\", k = 2",
    "output": "\"bacdfeg\""
  },
  {
    "input": "s = \"abcd\", k = 2",
    "output": "\"bacd\""
  },
  {
    "input": "s = \"abcdef\", k = 3",
    "output": "\"cbadef\""
  },
  {
    "input": "s = \"a\", k = 1",
    "output": "\"a\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var reverseStr = function(s, k) {\n};\n",
  "python": "class Solution:\n    def reverseStr(self, s: str, k: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string reverseStr(std::string s, int k) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String reverseStr(String s, int k) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reverseStr",
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
        "abcdefg",
        2
      ],
      "expected": "bacdfeg"
    },
    {
      "args": [
        "abcd",
        2
      ],
      "expected": "bacd"
    },
    {
      "args": [
        "abcdef",
        3
      ],
      "expected": "cbadef"
    },
    {
      "args": [
        "a",
        1
      ],
      "expected": "a"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abcdefgh",
      3
    ],
    "expected": "cbadefhg"
  },
  {
    "args": [
      "hello",
      4
    ],
    "expected": "lleho"
  },
  {
    "args": [
      "abcdef",
      1
    ],
    "expected": "abcdef"
  },
  {
    "args": [
      "123456789",
      5
    ],
    "expected": "543216789"
  },
  {
    "args": [
      "ab",
      2
    ],
    "expected": "ba"
  }
]$json$::jsonb,
    'approved'
),
(
    1221,
    '学生出勤记录 I',
    '给定一个字符串 s 表示学生出勤记录，判断该记录是否可被奖励。
如果记录中不存在连续三天或以上迟到（L），且缺勤（A）总次数少于 2，则可被奖励。

提示：
- 1 <= s.length <= 10^4
- s 只包含 A、L、P',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "s = \"PPALLP\"",
    "output": "true"
  },
  {
    "input": "s = \"PPALLL\"",
    "output": "false"
  },
  {
    "input": "s = \"P\"",
    "output": "true"
  },
  {
    "input": "s = \"ALL\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"PPALLP\"",
    "output": "true"
  },
  {
    "input": "s = \"PPALLL\"",
    "output": "false"
  },
  {
    "input": "s = \"P\"",
    "output": "true"
  },
  {
    "input": "s = \"ALL\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var checkRecord = function(s) {\n};\n",
  "python": "class Solution:\n    def checkRecord(self, s: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool checkRecord(std::string s) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean checkRecord(String s) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkRecord",
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
        "PPALLP"
      ],
      "expected": true
    },
    {
      "args": [
        "PPALLL"
      ],
      "expected": false
    },
    {
      "args": [
        "P"
      ],
      "expected": true
    },
    {
      "args": [
        "ALL"
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "A"
    ],
    "expected": true
  },
  {
    "args": [
      "AA"
    ],
    "expected": false
  },
  {
    "args": [
      "LLL"
    ],
    "expected": false
  },
  {
    "args": [
      "LL"
    ],
    "expected": true
  },
  {
    "args": [
      "PAL"
    ],
    "expected": true
  },
  {
    "args": [
      "PPPP"
    ],
    "expected": true
  },
  {
    "args": [
      "LALL"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1222,
    '机器人能否返回原点',
    '在二维平面上，机器人从原点 (0, 0) 出发，按移动序列 moves 移动。
U 向上，D 向下，L 向左，R 向右。判断机器人最终能否回到原点。

提示：
- 1 <= moves.length <= 2 * 10^4
- moves 只包含 U、D、L、R',
    'easy',
    1000,
    256,
    ARRAY['字符串', '模拟'],
    $json$[
  {
    "input": "moves = \"UD\"",
    "output": "true"
  },
  {
    "input": "moves = \"LL\"",
    "output": "false"
  },
  {
    "input": "moves = \"RRDD\"",
    "output": "false"
  },
  {
    "input": "moves = \"UUDD\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "moves = \"UD\"",
    "output": "true"
  },
  {
    "input": "moves = \"LL\"",
    "output": "false"
  },
  {
    "input": "moves = \"RRDD\"",
    "output": "false"
  },
  {
    "input": "moves = \"UUDD\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var robotReturnsToOrigin = function(moves) {\n};\n",
  "python": "class Solution:\n    def robotReturnsToOrigin(self, moves: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool robotReturnsToOrigin(std::string moves) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean robotReturnsToOrigin(String moves) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "robotReturnsToOrigin",
  "params": [
    {
      "name": "moves",
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
        "UD"
      ],
      "expected": true
    },
    {
      "args": [
        "LL"
      ],
      "expected": false
    },
    {
      "args": [
        "RRDD"
      ],
      "expected": false
    },
    {
      "args": [
        "UUDD"
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "U"
    ],
    "expected": false
  },
  {
    "args": [
      "D"
    ],
    "expected": false
  },
  {
    "args": [
      "ULDR"
    ],
    "expected": true
  },
  {
    "args": [
      "UUUDDD"
    ],
    "expected": true
  },
  {
    "args": [
      "LRRL"
    ],
    "expected": true
  },
  {
    "args": [
      "UUU"
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1223,
    '转换成小写字母',
    '给定一个字符串 s，将其中的大写字母转换为小写字母并返回。

提示：
- 1 <= s.length <= 10^5
- s 由 ASCII 字符组成',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "s = \"Hello\"",
    "output": "\"hello\""
  },
  {
    "input": "s = \"here\"",
    "output": "\"here\""
  },
  {
    "input": "s = \"LOVELY\"",
    "output": "\"lovely\""
  },
  {
    "input": "s = \"123ABC\"",
    "output": "\"123abc\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"Hello\"",
    "output": "\"hello\""
  },
  {
    "input": "s = \"here\"",
    "output": "\"here\""
  },
  {
    "input": "s = \"LOVELY\"",
    "output": "\"lovely\""
  },
  {
    "input": "s = \"123ABC\"",
    "output": "\"123abc\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var toLowerCase = function(s) {\n};\n",
  "python": "class Solution:\n    def toLowerCase(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string toLowerCase(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String toLowerCase(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "toLowerCase",
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
        "Hello"
      ],
      "expected": "hello"
    },
    {
      "args": [
        "here"
      ],
      "expected": "here"
    },
    {
      "args": [
        "LOVELY"
      ],
      "expected": "lovely"
    },
    {
      "args": [
        "123ABC"
      ],
      "expected": "123abc"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "A"
    ],
    "expected": "a"
  },
  {
    "args": [
      "Z"
    ],
    "expected": "z"
  },
  {
    "args": [
      "AbC"
    ],
    "expected": "abc"
  },
  {
    "args": [
      "Hello World"
    ],
    "expected": "hello world"
  },
  {
    "args": [
      "MiXeD123"
    ],
    "expected": "mixed123"
  }
]$json$::jsonb,
    'approved'
),
(
    1224,
    '数字的补数',
    '给定一个正整数 num，输出它的补数。
补数是将二进制表示中每一位取反后的结果，前导零不参与取反。

提示：
- 1 <= num < 2^31',
    'easy',
    1000,
    256,
    ARRAY['位运算'],
    $json$[
  {
    "input": "num = 5",
    "output": "2"
  },
  {
    "input": "num = 1",
    "output": "0"
  },
  {
    "input": "num = 7",
    "output": "0"
  },
  {
    "input": "num = 10",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 5",
    "output": "2"
  },
  {
    "input": "num = 1",
    "output": "0"
  },
  {
    "input": "num = 7",
    "output": "0"
  },
  {
    "input": "num = 10",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numberComplement = function(num) {\n};\n",
  "python": "class Solution:\n    def numberComplement(self, num: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numberComplement(int num) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numberComplement(int num) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numberComplement",
  "params": [
    {
      "name": "num",
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
        1
      ],
      "expected": 0
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
      15
    ],
    "expected": 0
  },
  {
    "args": [
      16
    ],
    "expected": 15
  },
  {
    "args": [
      1000
    ],
    "expected": 23
  }
]$json$::jsonb,
    'approved'
),
(
    1225,
    '交替位二进制数',
    '给定一个正整数 n，检查其二进制表示中相邻两位是否总是不同。

提示：
- 1 <= n <= 2^31 - 1',
    'easy',
    1000,
    256,
    ARRAY['位运算'],
    $json$[
  {
    "input": "n = 5",
    "output": "true"
  },
  {
    "input": "n = 7",
    "output": "false"
  },
  {
    "input": "n = 11",
    "output": "false"
  },
  {
    "input": "n = 10",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5",
    "output": "true"
  },
  {
    "input": "n = 7",
    "output": "false"
  },
  {
    "input": "n = 11",
    "output": "false"
  },
  {
    "input": "n = 10",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var hasAlternatingBits = function(n) {\n};\n",
  "python": "class Solution:\n    def hasAlternatingBits(self, n: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool hasAlternatingBits(int n) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean hasAlternatingBits(int n) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "hasAlternatingBits",
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
        5
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
        11
      ],
      "expected": false
    },
    {
      "args": [
        10
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
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
  },
  {
    "args": [
      3
    ],
    "expected": false
  },
  {
    "args": [
      4
    ],
    "expected": false
  },
  {
    "args": [
      15
    ],
    "expected": false
  },
  {
    "args": [
      21
    ],
    "expected": true
  },
  {
    "args": [
      22
    ],
    "expected": false
  },
  {
    "args": [
      42
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1226,
    '数字转换为十六进制数',
    '给定一个非负整数 num，返回其十六进制表示字符串，字母使用小写形式。

提示：
- 0 <= num <= 2^31 - 1',
    'easy',
    1000,
    256,
    ARRAY['数学', '位运算', '字符串'],
    $json$[
  {
    "input": "num = 26",
    "output": "\"1a\""
  },
  {
    "input": "num = 31",
    "output": "\"1f\""
  },
  {
    "input": "num = 0",
    "output": "\"0\""
  },
  {
    "input": "num = 255",
    "output": "\"ff\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 26",
    "output": "\"1a\""
  },
  {
    "input": "num = 31",
    "output": "\"1f\""
  },
  {
    "input": "num = 0",
    "output": "\"0\""
  },
  {
    "input": "num = 255",
    "output": "\"ff\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var toHex = function(num) {\n};\n",
  "python": "class Solution:\n    def toHex(self, num: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string toHex(int num) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String toHex(int num) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "toHex",
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
        26
      ],
      "expected": "1a"
    },
    {
      "args": [
        31
      ],
      "expected": "1f"
    },
    {
      "args": [
        0
      ],
      "expected": "0"
    },
    {
      "args": [
        255
      ],
      "expected": "ff"
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
      15
    ],
    "expected": "f"
  },
  {
    "args": [
      16
    ],
    "expected": "10"
  },
  {
    "args": [
      17
    ],
    "expected": "11"
  },
  {
    "args": [
      4096
    ],
    "expected": "1000"
  },
  {
    "args": [
      123456
    ],
    "expected": "1e240"
  },
  {
    "args": [
      2147483647
    ],
    "expected": "7fffffff"
  }
]$json$::jsonb,
    'approved'
),
(
    1227,
    '两个数组的交集',
    '给定两个整数数组 nums1 和 nums2，返回它们的交集。结果中每个元素唯一，按升序排列。

提示：
- 1 <= nums1.length, nums2.length <= 10^4
- 0 <= nums1[i], nums2[i] <= 10^9',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '排序'],
    $json$[
  {
    "input": "nums1 = [1, 2, 2, 1], nums2 = [2, 2]",
    "output": "[2]"
  },
  {
    "input": "nums1 = [4, 9, 5], nums2 = [9, 4, 9, 8, 4]",
    "output": "[4, 9]"
  },
  {
    "input": "nums1 = [1], nums2 = [2]",
    "output": "[]"
  },
  {
    "input": "nums1 = [1, 2], nums2 = [1, 2]",
    "output": "[1, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums1 = [1, 2, 2, 1], nums2 = [2, 2]",
    "output": "[2]"
  },
  {
    "input": "nums1 = [4, 9, 5], nums2 = [9, 4, 9, 8, 4]",
    "output": "[4, 9]"
  },
  {
    "input": "nums1 = [1], nums2 = [2]",
    "output": "[]"
  },
  {
    "input": "nums1 = [1, 2], nums2 = [1, 2]",
    "output": "[1, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var intersection = function(nums1, nums2) {\n};\n",
  "python": "class Solution:\n    def intersection(self, nums1: list[int], nums2: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> intersection(std::vector<int>& nums1, std::vector<int>& nums2) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] intersection(int[] nums1, int[] nums2) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "intersection",
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
          1,
          2,
          2,
          1
        ],
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
          4,
          9,
          5
        ],
        [
          9,
          4,
          9,
          8,
          4
        ]
      ],
      "expected": [
        4,
        9
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
      "expected": []
    },
    {
      "args": [
        [
          1,
          2
        ],
        [
          1,
          2
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
        1,
        1
      ],
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
        3,
        1,
        2
      ],
      [
        2,
        3
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
        0
      ],
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
        -1,
        0,
        1
      ],
      [
        0,
        1,
        2
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
        5,
        5,
        5
      ],
      [
        5
      ]
    ],
    "expected": [
      5
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1228,
    '两个数组的交集 II',
    '给定两个整数数组 nums1 和 nums2，返回它们的交集。结果中每个元素出现次数应与两个数组中该元素出现次数的较小值一致。结果按升序排列。

提示：
- 1 <= nums1.length, nums2.length <= 10^4
- 0 <= nums1[i], nums2[i] <= 10^9',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '排序'],
    $json$[
  {
    "input": "nums1 = [1, 2, 2, 1], nums2 = [2, 2]",
    "output": "[2, 2]"
  },
  {
    "input": "nums1 = [4, 9, 5], nums2 = [9, 4, 9, 8, 4]",
    "output": "[4, 9]"
  },
  {
    "input": "nums1 = [1, 2], nums2 = [1]",
    "output": "[1]"
  },
  {
    "input": "nums1 = [1, 1, 2], nums2 = [1, 2, 2]",
    "output": "[1, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums1 = [1, 2, 2, 1], nums2 = [2, 2]",
    "output": "[2, 2]"
  },
  {
    "input": "nums1 = [4, 9, 5], nums2 = [9, 4, 9, 8, 4]",
    "output": "[4, 9]"
  },
  {
    "input": "nums1 = [1, 2], nums2 = [1]",
    "output": "[1]"
  },
  {
    "input": "nums1 = [1, 1, 2], nums2 = [1, 2, 2]",
    "output": "[1, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var intersectionII = function(nums1, nums2) {\n};\n",
  "python": "class Solution:\n    def intersectionII(self, nums1: list[int], nums2: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> intersectionII(std::vector<int>& nums1, std::vector<int>& nums2) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] intersectionII(int[] nums1, int[] nums2) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "intersectionII",
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
          1,
          2,
          2,
          1
        ],
        [
          2,
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
          4,
          9,
          5
        ],
        [
          9,
          4,
          9,
          8,
          4
        ]
      ],
      "expected": [
        4,
        9
      ]
    },
    {
      "args": [
        [
          1,
          2
        ],
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
          1,
          1,
          2
        ],
        [
          1,
          2,
          2
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
      ],
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
        1,
        2,
        2
      ],
      [
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
        0,
        0,
        0
      ],
      [
        0,
        0
      ]
    ],
    "expected": [
      0,
      0
    ]
  },
  {
    "args": [
      [
        -1,
        1,
        1
      ],
      [
        1,
        -1
      ]
    ],
    "expected": [
      -1,
      1
    ]
  },
  {
    "args": [
      [
        5,
        5,
        3
      ],
      [
        5,
        3,
        5
      ]
    ],
    "expected": [
      3,
      5,
      5
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1229,
    '有效的回旋镖',
    '给定三个点 points，其中 points[i] = [xi, yi]，判断它们是否构成一个面积不为零的三角形。
也就是判断三个点是否不在同一直线上。

提示：
- points.length == 3
- -10^4 <= xi, yi <= 10^4',
    'easy',
    1000,
    256,
    ARRAY['数学', '几何'],
    $json$[
  {
    "input": "points = [[0, 0], [1, 1], [1, 2]]",
    "output": "true"
  },
  {
    "input": "points = [[1, 1], [2, 3], [3, 2]]",
    "output": "true"
  },
  {
    "input": "points = [[0, 0], [1, 1], [2, 2]]",
    "output": "false"
  },
  {
    "input": "points = [[0, 0], [0, 1], [1, 0]]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "points = [[0, 0], [1, 1], [1, 2]]",
    "output": "true"
  },
  {
    "input": "points = [[1, 1], [2, 3], [3, 2]]",
    "output": "true"
  },
  {
    "input": "points = [[0, 0], [1, 1], [2, 2]]",
    "output": "false"
  },
  {
    "input": "points = [[0, 0], [0, 1], [1, 0]]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isBoomerang = function(points) {\n};\n",
  "python": "class Solution:\n    def isBoomerang(self, points: list[list[int]]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isBoomerang(std::vector<std::vector<int>>& points) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isBoomerang(int[][] points) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isBoomerang",
  "params": [
    {
      "name": "points",
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
            0
          ],
          [
            1,
            1
          ],
          [
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
            1
          ],
          [
            2,
            3
          ],
          [
            3,
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
          ],
          [
            1,
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
          0,
          0
        ],
        [
          0,
          0
        ],
        [
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
    "expected": false
  },
  {
    "args": [
      [
        [
          -1,
          0
        ],
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
          2,
          3
        ],
        [
          4,
          6
        ],
        [
          6,
          9
        ]
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1230,
    '三角形的最大周长',
    '给定一个正整数数组 nums，从中选出三个数组成三角形，返回能组成的最大三角形周长。
如果无法组成任何三角形，返回 0。

提示：
- 3 <= nums.length <= 10^4
- 1 <= nums[i] <= 10^6',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序', '贪心'],
    $json$[
  {
    "input": "nums = [2, 1, 2]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2, 1]",
    "output": "0"
  },
  {
    "input": "nums = [3, 6, 2, 3]",
    "output": "8"
  },
  {
    "input": "nums = [2, 3, 4]",
    "output": "9"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 1, 2]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2, 1]",
    "output": "0"
  },
  {
    "input": "nums = [3, 6, 2, 3]",
    "output": "8"
  },
  {
    "input": "nums = [2, 3, 4]",
    "output": "9"
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestPerimeter = function(nums) {\n};\n",
  "python": "class Solution:\n    def largestPerimeter(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int largestPerimeter(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int largestPerimeter(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestPerimeter",
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
          1,
          2
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
      "expected": 0
    },
    {
      "args": [
        [
          3,
          6,
          2,
          3
        ]
      ],
      "expected": 8
    },
    {
      "args": [
        [
          2,
          3,
          4
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
        2,
        3
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        3,
        4,
        5
      ]
    ],
    "expected": 12
  },
  {
    "args": [
      [
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
        10,
        2,
        5,
        6,
        7
      ]
    ],
    "expected": 23
  },
  {
    "args": [
      [
        1,
        1,
        100
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1231,
    '三个数的最大乘积',
    '给定一个整数数组 nums，返回其中三个数的最大乘积。

提示：
- 3 <= nums.length <= 10^4
- -10^3 <= nums[i] <= 10^3',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序', '数学'],
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "6"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "24"
  },
  {
    "input": "nums = [-1, -2, -3]",
    "output": "-6"
  },
  {
    "input": "nums = [-10, -10, 1, 2]",
    "output": "200"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "6"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "24"
  },
  {
    "input": "nums = [-1, -2, -3]",
    "output": "-6"
  },
  {
    "input": "nums = [-10, -10, 1, 2]",
    "output": "200"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumProduct = function(nums) {\n};\n",
  "python": "class Solution:\n    def maximumProduct(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumProduct(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumProduct(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumProduct",
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
      "expected": 6
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
      "expected": 24
    },
    {
      "args": [
        [
          -1,
          -2,
          -3
        ]
      ],
      "expected": -6
    },
    {
      "args": [
        [
          -10,
          -10,
          1,
          2
        ]
      ],
      "expected": 200
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0,
        1,
        2
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        -1,
        2,
        3
      ]
    ],
    "expected": -6
  },
  {
    "args": [
      [
        -5,
        -4,
        -3,
        -2
      ]
    ],
    "expected": -24
  },
  {
    "args": [
      [
        1,
        1,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        10,
        9,
        8,
        1
      ]
    ],
    "expected": 720
  },
  {
    "args": [
      [
        -100,
        -99,
        2,
        3
      ]
    ],
    "expected": 29700
  }
]$json$::jsonb,
    'approved'
),
(
    1232,
    '数组的度',
    '给定一个非空整数数组 nums，数组的度定义为任意元素出现频率的最大值。
返回与 nums 拥有相同度的最短连续子数组的长度。

提示：
- 1 <= nums.length <= 10^5
- -1000 <= nums[i] <= 1000',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "nums = [1, 2, 2, 3, 1]",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 2, 3, 1, 4, 2]",
    "output": "6"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 2, 3, 1]",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 2, 3, 1, 4, 2]",
    "output": "6"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findShortestSubArray = function(nums) {\n};\n",
  "python": "class Solution:\n    def findShortestSubArray(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findShortestSubArray(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findShortestSubArray(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findShortestSubArray",
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
          2,
          3,
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
          2,
          3,
          1,
          4,
          2
        ]
      ],
      "expected": 6
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
          2,
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
        1,
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
        1,
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
        1,
        2
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
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        4,
        4,
        2,
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
        2,
        2,
        1,
        3
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1233,
    '卡牌分组',
    '给定一副牌，每张牌上有一个整数。判断是否可以将这副牌分成一组或多组，使得每组都有 X 张牌，且每组牌上的数字相同。
X 必须大于等于 2。

提示：
- 1 <= deck.length <= 10^4
- 0 <= deck[i] < 10^4',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "deck = [1, 2, 3, 4, 4, 3, 2, 1]",
    "output": "true"
  },
  {
    "input": "deck = [1, 1, 1, 2, 2, 2, 3, 3]",
    "output": "false"
  },
  {
    "input": "deck = [1]",
    "output": "false"
  },
  {
    "input": "deck = [1, 1, 2, 2, 2, 2]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "deck = [1, 2, 3, 4, 4, 3, 2, 1]",
    "output": "true"
  },
  {
    "input": "deck = [1, 1, 1, 2, 2, 2, 3, 3]",
    "output": "false"
  },
  {
    "input": "deck = [1]",
    "output": "false"
  },
  {
    "input": "deck = [1, 1, 2, 2, 2, 2]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canDivideIntoGroups = function(deck) {\n};\n",
  "python": "class Solution:\n    def canDivideIntoGroups(self, deck: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canDivideIntoGroups(std::vector<int>& deck) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canDivideIntoGroups(int[] deck) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canDivideIntoGroups",
  "params": [
    {
      "name": "deck",
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
          4,
          3,
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
          1,
          2,
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
          1
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
        2,
        2
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
    "expected": true
  },
  {
    "args": [
      [
        1,
        1,
        1,
        2,
        2
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1234,
    '唯一摩尔斯密码词',
    '给定一个字符串数组 words，每个单词可以按照摩尔斯密码表转换成对应密码。
返回所有单词对应密码中不同表示的数量。

提示：
- 1 <= words.length <= 100
- 1 <= words[i].length <= 12
- words[i] 只包含小写英文字母',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "words = [\"gin\", \"zen\", \"gig\", \"msg\"]",
    "output": "2"
  },
  {
    "input": "words = [\"a\"]",
    "output": "1"
  },
  {
    "input": "words = [\"abc\", \"abc\"]",
    "output": "1"
  },
  {
    "input": "words = [\"a\", \"b\"]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"gin\", \"zen\", \"gig\", \"msg\"]",
    "output": "2"
  },
  {
    "input": "words = [\"a\"]",
    "output": "1"
  },
  {
    "input": "words = [\"abc\", \"abc\"]",
    "output": "1"
  },
  {
    "input": "words = [\"a\", \"b\"]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var uniqueMorseRepresentations = function(words) {\n};\n",
  "python": "class Solution:\n    def uniqueMorseRepresentations(self, words: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int uniqueMorseRepresentations(std::vector<std::string>& words) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int uniqueMorseRepresentations(String[] words) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "uniqueMorseRepresentations",
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
          "gin",
          "zen",
          "gig",
          "msg"
        ]
      ],
      "expected": 2
    },
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
          "abc",
          "abc"
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          "a",
          "b"
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
        "a",
        "b",
        "c"
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        "aa",
        "bb"
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        "z"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "ab",
        "ba"
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        "hello",
        "world"
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        "same",
        "same",
        "same"
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1235,
    '最长回文子串',
    '给定一个字符串 s，找到 s 中最长的回文子串。如果存在多个长度相同的答案，返回从最左侧开始枚举得到的那个。

提示：
- 1 <= s.length <= 1000
- s 仅由数字和英文字母组成',
    'medium',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "s = \"babad\"",
    "output": "\"bab\""
  },
  {
    "input": "s = \"cbbd\"",
    "output": "\"bb\""
  },
  {
    "input": "s = \"a\"",
    "output": "\"a\""
  },
  {
    "input": "s = \"racecar\"",
    "output": "\"racecar\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"babad\"",
    "output": "\"bab\""
  },
  {
    "input": "s = \"cbbd\"",
    "output": "\"bb\""
  },
  {
    "input": "s = \"a\"",
    "output": "\"a\""
  },
  {
    "input": "s = \"racecar\"",
    "output": "\"racecar\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestPalindrome = function(s) {\n};\n",
  "python": "class Solution:\n    def longestPalindrome(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string longestPalindrome(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String longestPalindrome(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestPalindrome",
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
        "babad"
      ],
      "expected": "bab"
    },
    {
      "args": [
        "cbbd"
      ],
      "expected": "bb"
    },
    {
      "args": [
        "a"
      ],
      "expected": "a"
    },
    {
      "args": [
        "racecar"
      ],
      "expected": "racecar"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "bb"
    ],
    "expected": "bb"
  },
  {
    "args": [
      "abba"
    ],
    "expected": "abba"
  },
  {
    "args": [
      "forgeeksskeegfor"
    ],
    "expected": "geeksskeeg"
  },
  {
    "args": [
      "abc"
    ],
    "expected": "a"
  },
  {
    "args": [
      "aaaa"
    ],
    "expected": "aaaa"
  },
  {
    "args": [
      "abacdfgdcaba"
    ],
    "expected": "aba"
  },
  {
    "args": [
      "noon"
    ],
    "expected": "noon"
  }
]$json$::jsonb,
    'approved'
),
(
    1236,
    '字符串转换整数',
    '实现 myAtoi，将字符串转换为 32 位有符号整数。
忽略前导空格，读取可选正负号与连续数字，遇到非数字字符停止；结果超出范围时截断到 [-2^31, 2^31 - 1]。

提示：
- 0 <= s.length <= 200
- s 由英文字母、数字、空格和符号组成',
    'medium',
    1000,
    256,
    ARRAY['字符串', '模拟'],
    $json$[
  {
    "input": "s = \"42\"",
    "output": "42"
  },
  {
    "input": "s = \"   -42\"",
    "output": "-42"
  },
  {
    "input": "s = \"4193 with words\"",
    "output": "4193"
  },
  {
    "input": "s = \"words and 987\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"42\"",
    "output": "42"
  },
  {
    "input": "s = \"   -42\"",
    "output": "-42"
  },
  {
    "input": "s = \"4193 with words\"",
    "output": "4193"
  },
  {
    "input": "s = \"words and 987\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var myAtoi = function(s) {\n};\n",
  "python": "class Solution:\n    def myAtoi(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int myAtoi(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int myAtoi(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "myAtoi",
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
        "42"
      ],
      "expected": 42
    },
    {
      "args": [
        "   -42"
      ],
      "expected": -42
    },
    {
      "args": [
        "4193 with words"
      ],
      "expected": 4193
    },
    {
      "args": [
        "words and 987"
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      ""
    ],
    "expected": 0
  },
  {
    "args": [
      "+"
    ],
    "expected": 0
  },
  {
    "args": [
      "-"
    ],
    "expected": 0
  },
  {
    "args": [
      "  +12"
    ],
    "expected": 12
  },
  {
    "args": [
      "-91283472332"
    ],
    "expected": -2147483648
  },
  {
    "args": [
      "2147483648"
    ],
    "expected": 2147483647
  },
  {
    "args": [
      "00012"
    ],
    "expected": 12
  },
  {
    "args": [
      "3.14"
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1237,
    '整数转罗马数字',
    '给定一个整数 num，将其转换为罗马数字。

提示：
- 1 <= num <= 3999',
    'medium',
    1000,
    256,
    ARRAY['数学', '字符串'],
    $json$[
  {
    "input": "num = 3",
    "output": "\"III\""
  },
  {
    "input": "num = 4",
    "output": "\"IV\""
  },
  {
    "input": "num = 9",
    "output": "\"IX\""
  },
  {
    "input": "num = 58",
    "output": "\"LVIII\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 3",
    "output": "\"III\""
  },
  {
    "input": "num = 4",
    "output": "\"IV\""
  },
  {
    "input": "num = 9",
    "output": "\"IX\""
  },
  {
    "input": "num = 58",
    "output": "\"LVIII\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var intToRoman = function(num) {\n};\n",
  "python": "class Solution:\n    def intToRoman(self, num: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string intToRoman(int num) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String intToRoman(int num) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "intToRoman",
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
        3
      ],
      "expected": "III"
    },
    {
      "args": [
        4
      ],
      "expected": "IV"
    },
    {
      "args": [
        9
      ],
      "expected": "IX"
    },
    {
      "args": [
        58
      ],
      "expected": "LVIII"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1
    ],
    "expected": "I"
  },
  {
    "args": [
      40
    ],
    "expected": "XL"
  },
  {
    "args": [
      90
    ],
    "expected": "XC"
  },
  {
    "args": [
      400
    ],
    "expected": "CD"
  },
  {
    "args": [
      1994
    ],
    "expected": "MCMXCIV"
  },
  {
    "args": [
      3999
    ],
    "expected": "MMMCMXCIX"
  },
  {
    "args": [
      2024
    ],
    "expected": "MMXXIV"
  }
]$json$::jsonb,
    'approved'
),
(
    1238,
    '三数之和',
    '给定一个整数数组 nums，找出所有和为 0 且不重复的三元组。
答案中的三元组按升序排列，整个答案按三元组字典序排列。

提示：
- 3 <= nums.length <= 3000
- -10^5 <= nums[i] <= 10^5',
    'medium',
    1000,
    256,
    ARRAY['数组', '双指针', '排序'],
    $json$[
  {
    "input": "nums = [-1, 0, 1, 2, -1, -4]",
    "output": "[[-1, -1, 2], [-1, 0, 1]]"
  },
  {
    "input": "nums = [0, 1, 1]",
    "output": "[]"
  },
  {
    "input": "nums = [0, 0, 0]",
    "output": "[[0, 0, 0]]"
  },
  {
    "input": "nums = [1, 2, -2, -1]",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [-1, 0, 1, 2, -1, -4]",
    "output": "[[-1, -1, 2], [-1, 0, 1]]"
  },
  {
    "input": "nums = [0, 1, 1]",
    "output": "[]"
  },
  {
    "input": "nums = [0, 0, 0]",
    "output": "[[0, 0, 0]]"
  },
  {
    "input": "nums = [1, 2, -2, -1]",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var threeSum = function(nums) {\n};\n",
  "python": "class Solution:\n    def threeSum(self, nums: list[int]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> threeSum(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] threeSum(int[] nums) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "threeSum",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
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
          -1,
          0,
          1,
          2,
          -1,
          -4
        ]
      ],
      "expected": [
        [
          -1,
          -1,
          2
        ],
        [
          -1,
          0,
          1
        ]
      ]
    },
    {
      "args": [
        [
          0,
          1,
          1
        ]
      ],
      "expected": []
    },
    {
      "args": [
        [
          0,
          0,
          0
        ]
      ],
      "expected": [
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
          1,
          2,
          -2,
          -1
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
        -2,
        0,
        1,
        1,
        2
      ]
    ],
    "expected": [
      [
        -2,
        0,
        2
      ],
      [
        -2,
        1,
        1
      ]
    ]
  },
  {
    "args": [
      [
        -1,
        0,
        1,
        0
      ]
    ],
    "expected": [
      [
        -1,
        0,
        1
      ]
    ]
  },
  {
    "args": [
      [
        3,
        0,
        -2,
        -1,
        1,
        2
      ]
    ],
    "expected": [
      [
        -2,
        -1,
        3
      ],
      [
        -2,
        0,
        2
      ],
      [
        -1,
        0,
        1
      ]
    ]
  },
  {
    "args": [
      [
        0,
        0,
        0,
        0
      ]
    ],
    "expected": [
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
        1,
        -1,
        -1,
        2,
        -2
      ]
    ],
    "expected": [
      [
        -1,
        -1,
        2
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1239,
    '最接近的三数之和',
    '给定一个整数数组 nums 和一个目标值 target，选出三个整数使它们的和与 target 最接近，返回这个和。

提示：
- 3 <= nums.length <= 1000
- -1000 <= nums[i], target <= 1000',
    'medium',
    1000,
    256,
    ARRAY['数组', '双指针', '排序'],
    $json$[
  {
    "input": "nums = [-1, 2, 1, -4], target = 1",
    "output": "2"
  },
  {
    "input": "nums = [0, 0, 0], target = 1",
    "output": "0"
  },
  {
    "input": "nums = [1, 1, 1, 1], target = 0",
    "output": "3"
  },
  {
    "input": "nums = [4, 0, 5, -5, 3, 3, 0, -4, -5], target = -2",
    "output": "-2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [-1, 2, 1, -4], target = 1",
    "output": "2"
  },
  {
    "input": "nums = [0, 0, 0], target = 1",
    "output": "0"
  },
  {
    "input": "nums = [1, 1, 1, 1], target = 0",
    "output": "3"
  },
  {
    "input": "nums = [4, 0, 5, -5, 3, 3, 0, -4, -5], target = -2",
    "output": "-2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var threeSumClosest = function(nums, target) {\n};\n",
  "python": "class Solution:\n    def threeSumClosest(self, nums: list[int], target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int threeSumClosest(std::vector<int>& nums, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int threeSumClosest(int[] nums, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "threeSumClosest",
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
          2,
          1,
          -4
        ],
        1
      ],
      "expected": 2
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
        0
      ],
      "expected": 3
    },
    {
      "args": [
        [
          4,
          0,
          5,
          -5,
          3,
          3,
          0,
          -4,
          -5
        ],
        -2
      ],
      "expected": -2
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
      6
    ],
    "expected": 6
  },
  {
    "args": [
      [
        -1,
        -2,
        -3
      ],
      -6
    ],
    "expected": -6
  },
  {
    "args": [
      [
        1,
        2,
        4,
        8,
        16,
        32,
        64,
        128
      ],
      82
    ],
    "expected": 82
  },
  {
    "args": [
      [
        0,
        1,
        2
      ],
      0
    ],
    "expected": 3
  },
  {
    "args": [
      [
        -5,
        -4,
        -3,
        -2,
        -1
      ],
      -10
    ],
    "expected": -10
  }
]$json$::jsonb,
    'approved'
),
(
    1240,
    '电话号码的字母组合',
    '给定一个仅包含数字 2-9 的字符串 digits，返回它能表示的所有字母组合。答案按字典序排列。

提示：
- 1 <= digits.length <= 4
- digits[i] 是 2-9 的数字',
    'medium',
    1000,
    256,
    ARRAY['字符串', '回溯', '哈希表'],
    $json$[
  {
    "input": "digits = \"23\"",
    "output": "[\"ad\", \"ae\", \"af\", \"bd\", \"be\", \"bf\", \"cd\", \"ce\", \"cf\"]"
  },
  {
    "input": "digits = \"2\"",
    "output": "[\"a\", \"b\", \"c\"]"
  },
  {
    "input": "digits = \"79\"",
    "output": "[\"pw\", \"px\", \"py\", \"pz\", \"qw\", \"qx\", \"qy\", \"qz\", \"rw\", \"rx\", \"ry\", \"rz\", \"sw\", \"sx\", \"sy\", \"sz\"]"
  },
  {
    "input": "digits = \"234\"",
    "output": "[\"adg\", \"adh\", \"adi\", \"aeg\", \"aeh\", \"aei\", \"afg\", \"afh\", \"afi\", \"bdg\", \"bdh\", \"bdi\", \"beg\", \"beh\", \"bei\", \"bfg\", \"bfh\", \"bfi\", \"cdg\", \"cdh\", \"cdi\", \"ceg\", \"ceh\", \"cei\", \"cfg\", \"cfh\", \"cfi\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "digits = \"23\"",
    "output": "[\"ad\", \"ae\", \"af\", \"bd\", \"be\", \"bf\", \"cd\", \"ce\", \"cf\"]"
  },
  {
    "input": "digits = \"2\"",
    "output": "[\"a\", \"b\", \"c\"]"
  },
  {
    "input": "digits = \"79\"",
    "output": "[\"pw\", \"px\", \"py\", \"pz\", \"qw\", \"qx\", \"qy\", \"qz\", \"rw\", \"rx\", \"ry\", \"rz\", \"sw\", \"sx\", \"sy\", \"sz\"]"
  },
  {
    "input": "digits = \"234\"",
    "output": "[\"adg\", \"adh\", \"adi\", \"aeg\", \"aeh\", \"aei\", \"afg\", \"afh\", \"afi\", \"bdg\", \"bdh\", \"bdi\", \"beg\", \"beh\", \"bei\", \"bfg\", \"bfh\", \"bfi\", \"cdg\", \"cdh\", \"cdi\", \"ceg\", \"ceh\", \"cei\", \"cfg\", \"cfh\", \"cfi\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var letterCombinations = function(digits) {\n};\n",
  "python": "class Solution:\n    def letterCombinations(self, digits: str) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> letterCombinations(std::string digits) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] letterCombinations(String digits) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "letterCombinations",
  "params": [
    {
      "name": "digits",
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
        "23"
      ],
      "expected": [
        "ad",
        "ae",
        "af",
        "bd",
        "be",
        "bf",
        "cd",
        "ce",
        "cf"
      ]
    },
    {
      "args": [
        "2"
      ],
      "expected": [
        "a",
        "b",
        "c"
      ]
    },
    {
      "args": [
        "79"
      ],
      "expected": [
        "pw",
        "px",
        "py",
        "pz",
        "qw",
        "qx",
        "qy",
        "qz",
        "rw",
        "rx",
        "ry",
        "rz",
        "sw",
        "sx",
        "sy",
        "sz"
      ]
    },
    {
      "args": [
        "234"
      ],
      "expected": [
        "adg",
        "adh",
        "adi",
        "aeg",
        "aeh",
        "aei",
        "afg",
        "afh",
        "afi",
        "bdg",
        "bdh",
        "bdi",
        "beg",
        "beh",
        "bei",
        "bfg",
        "bfh",
        "bfi",
        "cdg",
        "cdh",
        "cdi",
        "ceg",
        "ceh",
        "cei",
        "cfg",
        "cfh",
        "cfi"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "9"
    ],
    "expected": [
      "w",
      "x",
      "y",
      "z"
    ]
  },
  {
    "args": [
      "22"
    ],
    "expected": [
      "aa",
      "ab",
      "ac",
      "ba",
      "bb",
      "bc",
      "ca",
      "cb",
      "cc"
    ]
  },
  {
    "args": [
      "567"
    ],
    "expected": [
      "jmp",
      "jmq",
      "jmr",
      "jms",
      "jnp",
      "jnq",
      "jnr",
      "jns",
      "jop",
      "joq",
      "jor",
      "jos",
      "kmp",
      "kmq",
      "kmr",
      "kms",
      "knp",
      "knq",
      "knr",
      "kns",
      "kop",
      "koq",
      "kor",
      "kos",
      "lmp",
      "lmq",
      "lmr",
      "lms",
      "lnp",
      "lnq",
      "lnr",
      "lns",
      "lop",
      "loq",
      "lor",
      "los"
    ]
  },
  {
    "args": [
      "89"
    ],
    "expected": [
      "tw",
      "tx",
      "ty",
      "tz",
      "uw",
      "ux",
      "uy",
      "uz",
      "vw",
      "vx",
      "vy",
      "vz"
    ]
  },
  {
    "args": [
      "2345"
    ],
    "expected": [
      "adgj",
      "adgk",
      "adgl",
      "adhj",
      "adhk",
      "adhl",
      "adij",
      "adik",
      "adil",
      "aegj",
      "aegk",
      "aegl",
      "aehj",
      "aehk",
      "aehl",
      "aeij",
      "aeik",
      "aeil",
      "afgj",
      "afgk",
      "afgl",
      "afhj",
      "afhk",
      "afhl",
      "afij",
      "afik",
      "afil",
      "bdgj",
      "bdgk",
      "bdgl",
      "bdhj",
      "bdhk",
      "bdhl",
      "bdij",
      "bdik",
      "bdil",
      "begj",
      "begk",
      "begl",
      "behj",
      "behk",
      "behl",
      "beij",
      "beik",
      "beil",
      "bfgj",
      "bfgk",
      "bfgl",
      "bfhj",
      "bfhk",
      "bfhl",
      "bfij",
      "bfik",
      "bfil",
      "cdgj",
      "cdgk",
      "cdgl",
      "cdhj",
      "cdhk",
      "cdhl",
      "cdij",
      "cdik",
      "cdil",
      "cegj",
      "cegk",
      "cegl",
      "cehj",
      "cehk",
      "cehl",
      "ceij",
      "ceik",
      "ceil",
      "cfgj",
      "cfgk",
      "cfgl",
      "cfhj",
      "cfhk",
      "cfhl",
      "cfij",
      "cfik",
      "cfil"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1241,
    '括号生成',
    '给定数字 n，生成所有由 n 对括号组成的有效括号组合。答案按回溯生成顺序返回。

提示：
- 1 <= n <= 8',
    'medium',
    1000,
    256,
    ARRAY['字符串', '回溯'],
    $json$[
  {
    "input": "n = 1",
    "output": "[\"()\"]"
  },
  {
    "input": "n = 2",
    "output": "[\"(())\", \"()()\"]"
  },
  {
    "input": "n = 3",
    "output": "[\"((()))\", \"(()())\", \"(())()\", \"()(())\", \"()()()\"]"
  },
  {
    "input": "n = 4",
    "output": "[\"(((())))\", \"((()()))\", \"((())())\", \"((()))()\", \"(()(()))\", \"(()()())\", \"(()())()\", \"(())(())\", \"(())()()\", \"()((()))\", \"()(()())\", \"()(())()\", \"()()(())\", \"()()()()\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 1",
    "output": "[\"()\"]"
  },
  {
    "input": "n = 2",
    "output": "[\"(())\", \"()()\"]"
  },
  {
    "input": "n = 3",
    "output": "[\"((()))\", \"(()())\", \"(())()\", \"()(())\", \"()()()\"]"
  },
  {
    "input": "n = 4",
    "output": "[\"(((())))\", \"((()()))\", \"((())())\", \"((()))()\", \"(()(()))\", \"(()()())\", \"(()())()\", \"(())(())\", \"(())()()\", \"()((()))\", \"()(()())\", \"()(())()\", \"()()(())\", \"()()()()\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var generateParentheses = function(n) {\n};\n",
  "python": "class Solution:\n    def generateParentheses(self, n: int) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> generateParentheses(int n) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] generateParentheses(int n) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "generateParentheses",
  "params": [
    {
      "name": "n",
      "type": "int"
    }
  ],
  "return_type": "string[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        1
      ],
      "expected": [
        "()"
      ]
    },
    {
      "args": [
        2
      ],
      "expected": [
        "(())",
        "()()"
      ]
    },
    {
      "args": [
        3
      ],
      "expected": [
        "((()))",
        "(()())",
        "(())()",
        "()(())",
        "()()()"
      ]
    },
    {
      "args": [
        4
      ],
      "expected": [
        "(((())))",
        "((()()))",
        "((())())",
        "((()))()",
        "(()(()))",
        "(()()())",
        "(()())()",
        "(())(())",
        "(())()()",
        "()((()))",
        "()(()())",
        "()(())()",
        "()()(())",
        "()()()()"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      5
    ],
    "expected": [
      "((((()))))",
      "(((()())))",
      "(((())()))",
      "(((()))())",
      "(((())))()",
      "((()(())))",
      "((()()()))",
      "((()())())",
      "((()()))()",
      "((())(()))",
      "((())()())",
      "((())())()",
      "((()))(())",
      "((()))()()",
      "(()((())))",
      "(()(()()))",
      "(()(())())",
      "(()(()))()",
      "(()()(()))",
      "(()()()())",
      "(()()())()",
      "(()())(())",
      "(()())()()",
      "(())((()))",
      "(())(()())",
      "(())(())()",
      "(())()(())",
      "(())()()()",
      "()(((())))",
      "()((()()))",
      "()((())())",
      "()((()))()",
      "()(()(()))",
      "()(()()())",
      "()(()())()",
      "()(())(())",
      "()(())()()",
      "()()((()))",
      "()()(()())",
      "()()(())()",
      "()()()(())",
      "()()()()()"
    ]
  },
  {
    "args": [
      6
    ],
    "expected": [
      "(((((())))))",
      "((((()()))))",
      "((((())())))",
      "((((()))()))",
      "((((())))())",
      "((((()))))()",
      "(((()(()))))",
      "(((()()())))",
      "(((()())()))",
      "(((()()))())",
      "(((()())))()",
      "(((())(())))",
      "(((())()()))",
      "(((())())())",
      "(((())()))()",
      "(((()))(()))",
      "(((()))()())",
      "(((()))())()",
      "(((())))(())",
      "(((())))()()",
      "((()((()))))",
      "((()(()())))",
      "((()(())()))",
      "((()(()))())",
      "((()(())))()",
      "((()()(())))",
      "((()()()()))",
      "((()()())())",
      "((()()()))()",
      "((()())(()))",
      "((()())()())",
      "((()())())()",
      "((()()))(())",
      "((()()))()()",
      "((())((())))",
      "((())(()()))",
      "((())(())())",
      "((())(()))()",
      "((())()(()))",
      "((())()()())",
      "((())()())()",
      "((())())(())",
      "((())())()()",
      "((()))((()))",
      "((()))(()())",
      "((()))(())()",
      "((()))()(())",
      "((()))()()()",
      "(()(((()))))",
      "(()((()())))",
      "(()((())()))",
      "(()((()))())",
      "(()((())))()",
      "(()(()(())))",
      "(()(()()()))",
      "(()(()())())",
      "(()(()()))()",
      "(()(())(()))",
      "(()(())()())",
      "(()(())())()",
      "(()(()))(())",
      "(()(()))()()",
      "(()()((())))",
      "(()()(()()))",
      "(()()(())())",
      "(()()(()))()",
      "(()()()(()))",
      "(()()()()())",
      "(()()()())()",
      "(()()())(())",
      "(()()())()()",
      "(()())((()))",
      "(()())(()())",
      "(()())(())()",
      "(()())()(())",
      "(()())()()()",
      "(())(((())))",
      "(())((()()))",
      "(())((())())",
      "(())((()))()",
      "(())(()(()))",
      "(())(()()())",
      "(())(()())()",
      "(())(())(())",
      "(())(())()()",
      "(())()((()))",
      "(())()(()())",
      "(())()(())()",
      "(())()()(())",
      "(())()()()()",
      "()((((()))))",
      "()(((()())))",
      "()(((())()))",
      "()(((()))())",
      "()(((())))()",
      "()((()(())))",
      "()((()()()))",
      "()((()())())",
      "()((()()))()",
      "()((())(()))",
      "()((())()())",
      "()((())())()",
      "()((()))(())",
      "()((()))()()",
      "()(()((())))",
      "()(()(()()))",
      "()(()(())())",
      "()(()(()))()",
      "()(()()(()))",
      "()(()()()())",
      "()(()()())()",
      "()(()())(())",
      "()(()())()()",
      "()(())((()))",
      "()(())(()())",
      "()(())(())()",
      "()(())()(())",
      "()(())()()()",
      "()()(((())))",
      "()()((()()))",
      "()()((())())",
      "()()((()))()",
      "()()(()(()))",
      "()()(()()())",
      "()()(()())()",
      "()()(())(())",
      "()()(())()()",
      "()()()((()))",
      "()()()(()())",
      "()()()(())()",
      "()()()()(())",
      "()()()()()()"
    ]
  },
  {
    "args": [
      7
    ],
    "expected": [
      "((((((()))))))",
      "(((((()())))))",
      "(((((())()))))",
      "(((((()))())))",
      "(((((())))()))",
      "(((((()))))())",
      "(((((())))))()",
      "((((()(())))))",
      "((((()()()))))",
      "((((()())())))",
      "((((()()))()))",
      "((((()())))())",
      "((((()()))))()",
      "((((())(()))))",
      "((((())()())))",
      "((((())())()))",
      "((((())()))())",
      "((((())())))()",
      "((((()))(())))",
      "((((()))()()))",
      "((((()))())())",
      "((((()))()))()",
      "((((())))(()))",
      "((((())))()())",
      "((((())))())()",
      "((((()))))(())",
      "((((()))))()()",
      "(((()((())))))",
      "(((()(()()))))",
      "(((()(())())))",
      "(((()(()))()))",
      "(((()(())))())",
      "(((()(()))))()",
      "(((()()(()))))",
      "(((()()()())))",
      "(((()()())()))",
      "(((()()()))())",
      "(((()()())))()",
      "(((()())(())))",
      "(((()())()()))",
      "(((()())())())",
      "(((()())()))()",
      "(((()()))(()))",
      "(((()()))()())",
      "(((()()))())()",
      "(((()())))(())",
      "(((()())))()()",
      "(((())((()))))",
      "(((())(()())))",
      "(((())(())()))",
      "(((())(()))())",
      "(((())(())))()",
      "(((())()(())))",
      "(((())()()()))",
      "(((())()())())",
      "(((())()()))()",
      "(((())())(()))",
      "(((())())()())",
      "(((())())())()",
      "(((())()))(())",
      "(((())()))()()",
      "(((()))((())))",
      "(((()))(()()))",
      "(((()))(())())",
      "(((()))(()))()",
      "(((()))()(()))",
      "(((()))()()())",
      "(((()))()())()",
      "(((()))())(())",
      "(((()))())()()",
      "(((())))((()))",
      "(((())))(()())",
      "(((())))(())()",
      "(((())))()(())",
      "(((())))()()()",
      "((()(((())))))",
      "((()((()()))))",
      "((()((())())))",
      "((()((()))()))",
      "((()((())))())",
      "((()((()))))()",
      "((()(()(()))))",
      "((()(()()())))",
      "((()(()())()))",
      "((()(()()))())",
      "((()(()())))()",
      "((()(())(())))",
      "((()(())()()))",
      "((()(())())())",
      "((()(())()))()",
      "((()(()))(()))",
      "((()(()))()())",
      "((()(()))())()",
      "((()(())))(())",
      "((()(())))()()",
      "((()()((()))))",
      "((()()(()())))",
      "((()()(())()))",
      "((()()(()))())",
      "((()()(())))()",
      "((()()()(())))",
      "((()()()()()))",
      "((()()()())())",
      "((()()()()))()",
      "((()()())(()))",
      "((()()())()())",
      "((()()())())()",
      "((()()()))(())",
      "((()()()))()()",
      "((()())((())))",
      "((()())(()()))",
      "((()())(())())",
      "((()())(()))()",
      "((()())()(()))",
      "((()())()()())",
      "((()())()())()",
      "((()())())(())",
      "((()())())()()",
      "((()()))((()))",
      "((()()))(()())",
      "((()()))(())()",
      "((()()))()(())",
      "((()()))()()()",
      "((())(((()))))",
      "((())((()())))",
      "((())((())()))",
      "((())((()))())",
      "((())((())))()",
      "((())(()(())))",
      "((())(()()()))",
      "((())(()())())",
      "((())(()()))()",
      "((())(())(()))",
      "((())(())()())",
      "((())(())())()",
      "((())(()))(())",
      "((())(()))()()",
      "((())()((())))",
      "((())()(()()))",
      "((())()(())())",
      "((())()(()))()",
      "((())()()(()))",
      "((())()()()())",
      "((())()()())()",
      "((())()())(())",
      "((())()())()()",
      "((())())((()))",
      "((())())(()())",
      "((())())(())()",
      "((())())()(())",
      "((())())()()()",
      "((()))(((())))",
      "((()))((()()))",
      "((()))((())())",
      "((()))((()))()",
      "((()))(()(()))",
      "((()))(()()())",
      "((()))(()())()",
      "((()))(())(())",
      "((()))(())()()",
      "((()))()((()))",
      "((()))()(()())",
      "((()))()(())()",
      "((()))()()(())",
      "((()))()()()()",
      "(()((((())))))",
      "(()(((()()))))",
      "(()(((())())))",
      "(()(((()))()))",
      "(()(((())))())",
      "(()(((()))))()",
      "(()((()(()))))",
      "(()((()()())))",
      "(()((()())()))",
      "(()((()()))())",
      "(()((()())))()",
      "(()((())(())))",
      "(()((())()()))",
      "(()((())())())",
      "(()((())()))()",
      "(()((()))(()))",
      "(()((()))()())",
      "(()((()))())()",
      "(()((())))(())",
      "(()((())))()()",
      "(()(()((()))))",
      "(()(()(()())))",
      "(()(()(())()))",
      "(()(()(()))())",
      "(()(()(())))()",
      "(()(()()(())))",
      "(()(()()()()))",
      "(()(()()())())",
      "(()(()()()))()",
      "(()(()())(()))",
      "(()(()())()())",
      "(()(()())())()",
      "(()(()()))(())",
      "(()(()()))()()",
      "(()(())((())))",
      "(()(())(()()))",
      "(()(())(())())",
      "(()(())(()))()",
      "(()(())()(()))",
      "(()(())()()())",
      "(()(())()())()",
      "(()(())())(())",
      "(()(())())()()",
      "(()(()))((()))",
      "(()(()))(()())",
      "(()(()))(())()",
      "(()(()))()(())",
      "(()(()))()()()",
      "(()()(((()))))",
      "(()()((()())))",
      "(()()((())()))",
      "(()()((()))())",
      "(()()((())))()",
      "(()()(()(())))",
      "(()()(()()()))",
      "(()()(()())())",
      "(()()(()()))()",
      "(()()(())(()))",
      "(()()(())()())",
      "(()()(())())()",
      "(()()(()))(())",
      "(()()(()))()()",
      "(()()()((())))",
      "(()()()(()()))",
      "(()()()(())())",
      "(()()()(()))()",
      "(()()()()(()))",
      "(()()()()()())",
      "(()()()()())()",
      "(()()()())(())",
      "(()()()())()()",
      "(()()())((()))",
      "(()()())(()())",
      "(()()())(())()",
      "(()()())()(())",
      "(()()())()()()",
      "(()())(((())))",
      "(()())((()()))",
      "(()())((())())",
      "(()())((()))()",
      "(()())(()(()))",
      "(()())(()()())",
      "(()())(()())()",
      "(()())(())(())",
      "(()())(())()()",
      "(()())()((()))",
      "(()())()(()())",
      "(()())()(())()",
      "(()())()()(())",
      "(()())()()()()",
      "(())((((()))))",
      "(())(((()())))",
      "(())(((())()))",
      "(())(((()))())",
      "(())(((())))()",
      "(())((()(())))",
      "(())((()()()))",
      "(())((()())())",
      "(())((()()))()",
      "(())((())(()))",
      "(())((())()())",
      "(())((())())()",
      "(())((()))(())",
      "(())((()))()()",
      "(())(()((())))",
      "(())(()(()()))",
      "(())(()(())())",
      "(())(()(()))()",
      "(())(()()(()))",
      "(())(()()()())",
      "(())(()()())()",
      "(())(()())(())",
      "(())(()())()()",
      "(())(())((()))",
      "(())(())(()())",
      "(())(())(())()",
      "(())(())()(())",
      "(())(())()()()",
      "(())()(((())))",
      "(())()((()()))",
      "(())()((())())",
      "(())()((()))()",
      "(())()(()(()))",
      "(())()(()()())",
      "(())()(()())()",
      "(())()(())(())",
      "(())()(())()()",
      "(())()()((()))",
      "(())()()(()())",
      "(())()()(())()",
      "(())()()()(())",
      "(())()()()()()",
      "()(((((())))))",
      "()((((()()))))",
      "()((((())())))",
      "()((((()))()))",
      "()((((())))())",
      "()((((()))))()",
      "()(((()(()))))",
      "()(((()()())))",
      "()(((()())()))",
      "()(((()()))())",
      "()(((()())))()",
      "()(((())(())))",
      "()(((())()()))",
      "()(((())())())",
      "()(((())()))()",
      "()(((()))(()))",
      "()(((()))()())",
      "()(((()))())()",
      "()(((())))(())",
      "()(((())))()()",
      "()((()((()))))",
      "()((()(()())))",
      "()((()(())()))",
      "()((()(()))())",
      "()((()(())))()",
      "()((()()(())))",
      "()((()()()()))",
      "()((()()())())",
      "()((()()()))()",
      "()((()())(()))",
      "()((()())()())",
      "()((()())())()",
      "()((()()))(())",
      "()((()()))()()",
      "()((())((())))",
      "()((())(()()))",
      "()((())(())())",
      "()((())(()))()",
      "()((())()(()))",
      "()((())()()())",
      "()((())()())()",
      "()((())())(())",
      "()((())())()()",
      "()((()))((()))",
      "()((()))(()())",
      "()((()))(())()",
      "()((()))()(())",
      "()((()))()()()",
      "()(()(((()))))",
      "()(()((()())))",
      "()(()((())()))",
      "()(()((()))())",
      "()(()((())))()",
      "()(()(()(())))",
      "()(()(()()()))",
      "()(()(()())())",
      "()(()(()()))()",
      "()(()(())(()))",
      "()(()(())()())",
      "()(()(())())()",
      "()(()(()))(())",
      "()(()(()))()()",
      "()(()()((())))",
      "()(()()(()()))",
      "()(()()(())())",
      "()(()()(()))()",
      "()(()()()(()))",
      "()(()()()()())",
      "()(()()()())()",
      "()(()()())(())",
      "()(()()())()()",
      "()(()())((()))",
      "()(()())(()())",
      "()(()())(())()",
      "()(()())()(())",
      "()(()())()()()",
      "()(())(((())))",
      "()(())((()()))",
      "()(())((())())",
      "()(())((()))()",
      "()(())(()(()))",
      "()(())(()()())",
      "()(())(()())()",
      "()(())(())(())",
      "()(())(())()()",
      "()(())()((()))",
      "()(())()(()())",
      "()(())()(())()",
      "()(())()()(())",
      "()(())()()()()",
      "()()((((()))))",
      "()()(((()())))",
      "()()(((())()))",
      "()()(((()))())",
      "()()(((())))()",
      "()()((()(())))",
      "()()((()()()))",
      "()()((()())())",
      "()()((()()))()",
      "()()((())(()))",
      "()()((())()())",
      "()()((())())()",
      "()()((()))(())",
      "()()((()))()()",
      "()()(()((())))",
      "()()(()(()()))",
      "()()(()(())())",
      "()()(()(()))()",
      "()()(()()(()))",
      "()()(()()()())",
      "()()(()()())()",
      "()()(()())(())",
      "()()(()())()()",
      "()()(())((()))",
      "()()(())(()())",
      "()()(())(())()",
      "()()(())()(())",
      "()()(())()()()",
      "()()()(((())))",
      "()()()((()()))",
      "()()()((())())",
      "()()()((()))()",
      "()()()(()(()))",
      "()()()(()()())",
      "()()()(()())()",
      "()()()(())(())",
      "()()()(())()()",
      "()()()()((()))",
      "()()()()(()())",
      "()()()()(())()",
      "()()()()()(())",
      "()()()()()()()"
    ]
  },
  {
    "args": [
      8
    ],
    "expected": [
      "(((((((())))))))",
      "((((((()()))))))",
      "((((((())())))))",
      "((((((()))()))))",
      "((((((())))())))",
      "((((((()))))()))",
      "((((((())))))())",
      "((((((()))))))()",
      "(((((()(()))))))",
      "(((((()()())))))",
      "(((((()())()))))",
      "(((((()()))())))",
      "(((((()())))()))",
      "(((((()()))))())",
      "(((((()())))))()",
      "(((((())(())))))",
      "(((((())()()))))",
      "(((((())())())))",
      "(((((())()))()))",
      "(((((())())))())",
      "(((((())()))))()",
      "(((((()))(()))))",
      "(((((()))()())))",
      "(((((()))())()))",
      "(((((()))()))())",
      "(((((()))())))()",
      "(((((())))(())))",
      "(((((())))()()))",
      "(((((())))())())",
      "(((((())))()))()",
      "(((((()))))(()))",
      "(((((()))))()())",
      "(((((()))))())()",
      "(((((())))))(())",
      "(((((())))))()()",
      "((((()((()))))))",
      "((((()(()())))))",
      "((((()(())()))))",
      "((((()(()))())))",
      "((((()(())))()))",
      "((((()(()))))())",
      "((((()(())))))()",
      "((((()()(())))))",
      "((((()()()()))))",
      "((((()()())())))",
      "((((()()()))()))",
      "((((()()())))())",
      "((((()()()))))()",
      "((((()())(()))))",
      "((((()())()())))",
      "((((()())())()))",
      "((((()())()))())",
      "((((()())())))()",
      "((((()()))(())))",
      "((((()()))()()))",
      "((((()()))())())",
      "((((()()))()))()",
      "((((()())))(()))",
      "((((()())))()())",
      "((((()())))())()",
      "((((()()))))(())",
      "((((()()))))()()",
      "((((())((())))))",
      "((((())(()()))))",
      "((((())(())())))",
      "((((())(()))()))",
      "((((())(())))())",
      "((((())(()))))()",
      "((((())()(()))))",
      "((((())()()())))",
      "((((())()())()))",
      "((((())()()))())",
      "((((())()())))()",
      "((((())())(())))",
      "((((())())()()))",
      "((((())())())())",
      "((((())())()))()",
      "((((())()))(()))",
      "((((())()))()())",
      "((((())()))())()",
      "((((())())))(())",
      "((((())())))()()",
      "((((()))((()))))",
      "((((()))(()())))",
      "((((()))(())()))",
      "((((()))(()))())",
      "((((()))(())))()",
      "((((()))()(())))",
      "((((()))()()()))",
      "((((()))()())())",
      "((((()))()()))()",
      "((((()))())(()))",
      "((((()))())()())",
      "((((()))())())()",
      "((((()))()))(())",
      "((((()))()))()()",
      "((((())))((())))",
      "((((())))(()()))",
      "((((())))(())())",
      "((((())))(()))()",
      "((((())))()(()))",
      "((((())))()()())",
      "((((())))()())()",
      "((((())))())(())",
      "((((())))())()()",
      "((((()))))((()))",
      "((((()))))(()())",
      "((((()))))(())()",
      "((((()))))()(())",
      "((((()))))()()()",
      "(((()(((()))))))",
      "(((()((()())))))",
      "(((()((())()))))",
      "(((()((()))())))",
      "(((()((())))()))",
      "(((()((()))))())",
      "(((()((())))))()",
      "(((()(()(())))))",
      "(((()(()()()))))",
      "(((()(()())())))",
      "(((()(()()))()))",
      "(((()(()())))())",
      "(((()(()()))))()",
      "(((()(())(()))))",
      "(((()(())()())))",
      "(((()(())())()))",
      "(((()(())()))())",
      "(((()(())())))()",
      "(((()(()))(())))",
      "(((()(()))()()))",
      "(((()(()))())())",
      "(((()(()))()))()",
      "(((()(())))(()))",
      "(((()(())))()())",
      "(((()(())))())()",
      "(((()(()))))(())",
      "(((()(()))))()()",
      "(((()()((())))))",
      "(((()()(()()))))",
      "(((()()(())())))",
      "(((()()(()))()))",
      "(((()()(())))())",
      "(((()()(()))))()",
      "(((()()()(()))))",
      "(((()()()()())))",
      "(((()()()())()))",
      "(((()()()()))())",
      "(((()()()())))()",
      "(((()()())(())))",
      "(((()()())()()))",
      "(((()()())())())",
      "(((()()())()))()",
      "(((()()()))(()))",
      "(((()()()))()())",
      "(((()()()))())()",
      "(((()()())))(())",
      "(((()()())))()()",
      "(((()())((()))))",
      "(((()())(()())))",
      "(((()())(())()))",
      "(((()())(()))())",
      "(((()())(())))()",
      "(((()())()(())))",
      "(((()())()()()))",
      "(((()())()())())",
      "(((()())()()))()",
      "(((()())())(()))",
      "(((()())())()())",
      "(((()())())())()",
      "(((()())()))(())",
      "(((()())()))()()",
      "(((()()))((())))",
      "(((()()))(()()))",
      "(((()()))(())())",
      "(((()()))(()))()",
      "(((()()))()(()))",
      "(((()()))()()())",
      "(((()()))()())()",
      "(((()()))())(())",
      "(((()()))())()()",
      "(((()())))((()))",
      "(((()())))(()())",
      "(((()())))(())()",
      "(((()())))()(())",
      "(((()())))()()()",
      "(((())(((())))))",
      "(((())((()()))))",
      "(((())((())())))",
      "(((())((()))()))",
      "(((())((())))())",
      "(((())((()))))()",
      "(((())(()(()))))",
      "(((())(()()())))",
      "(((())(()())()))",
      "(((())(()()))())",
      "(((())(()())))()",
      "(((())(())(())))",
      "(((())(())()()))",
      "(((())(())())())",
      "(((())(())()))()",
      "(((())(()))(()))",
      "(((())(()))()())",
      "(((())(()))())()",
      "(((())(())))(())",
      "(((())(())))()()",
      "(((())()((()))))",
      "(((())()(()())))",
      "(((())()(())()))",
      "(((())()(()))())",
      "(((())()(())))()",
      "(((())()()(())))",
      "(((())()()()()))",
      "(((())()()())())",
      "(((())()()()))()",
      "(((())()())(()))",
      "(((())()())()())",
      "(((())()())())()",
      "(((())()()))(())",
      "(((())()()))()()",
      "(((())())((())))",
      "(((())())(()()))",
      "(((())())(())())",
      "(((())())(()))()",
      "(((())())()(()))",
      "(((())())()()())",
      "(((())())()())()",
      "(((())())())(())",
      "(((())())())()()",
      "(((())()))((()))",
      "(((())()))(()())",
      "(((())()))(())()",
      "(((())()))()(())",
      "(((())()))()()()",
      "(((()))(((()))))",
      "(((()))((()())))",
      "(((()))((())()))",
      "(((()))((()))())",
      "(((()))((())))()",
      "(((()))(()(())))",
      "(((()))(()()()))",
      "(((()))(()())())",
      "(((()))(()()))()",
      "(((()))(())(()))",
      "(((()))(())()())",
      "(((()))(())())()",
      "(((()))(()))(())",
      "(((()))(()))()()",
      "(((()))()((())))",
      "(((()))()(()()))",
      "(((()))()(())())",
      "(((()))()(()))()",
      "(((()))()()(()))",
      "(((()))()()()())",
      "(((()))()()())()",
      "(((()))()())(())",
      "(((()))()())()()",
      "(((()))())((()))",
      "(((()))())(()())",
      "(((()))())(())()",
      "(((()))())()(())",
      "(((()))())()()()",
      "(((())))(((())))",
      "(((())))((()()))",
      "(((())))((())())",
      "(((())))((()))()",
      "(((())))(()(()))",
      "(((())))(()()())",
      "(((())))(()())()",
      "(((())))(())(())",
      "(((())))(())()()",
      "(((())))()((()))",
      "(((())))()(()())",
      "(((())))()(())()",
      "(((())))()()(())",
      "(((())))()()()()",
      "((()((((()))))))",
      "((()(((()())))))",
      "((()(((())()))))",
      "((()(((()))())))",
      "((()(((())))()))",
      "((()(((()))))())",
      "((()(((())))))()",
      "((()((()(())))))",
      "((()((()()()))))",
      "((()((()())())))",
      "((()((()()))()))",
      "((()((()())))())",
      "((()((()()))))()",
      "((()((())(()))))",
      "((()((())()())))",
      "((()((())())()))",
      "((()((())()))())",
      "((()((())())))()",
      "((()((()))(())))",
      "((()((()))()()))",
      "((()((()))())())",
      "((()((()))()))()",
      "((()((())))(()))",
      "((()((())))()())",
      "((()((())))())()",
      "((()((()))))(())",
      "((()((()))))()()",
      "((()(()((())))))",
      "((()(()(()()))))",
      "((()(()(())())))",
      "((()(()(()))()))",
      "((()(()(())))())",
      "((()(()(()))))()",
      "((()(()()(()))))",
      "((()(()()()())))",
      "((()(()()())()))",
      "((()(()()()))())",
      "((()(()()())))()",
      "((()(()())(())))",
      "((()(()())()()))",
      "((()(()())())())",
      "((()(()())()))()",
      "((()(()()))(()))",
      "((()(()()))()())",
      "((()(()()))())()",
      "((()(()())))(())",
      "((()(()())))()()",
      "((()(())((()))))",
      "((()(())(()())))",
      "((()(())(())()))",
      "((()(())(()))())",
      "((()(())(())))()",
      "((()(())()(())))",
      "((()(())()()()))",
      "((()(())()())())",
      "((()(())()()))()",
      "((()(())())(()))",
      "((()(())())()())",
      "((()(())())())()",
      "((()(())()))(())",
      "((()(())()))()()",
      "((()(()))((())))",
      "((()(()))(()()))",
      "((()(()))(())())",
      "((()(()))(()))()",
      "((()(()))()(()))",
      "((()(()))()()())",
      "((()(()))()())()",
      "((()(()))())(())",
      "((()(()))())()()",
      "((()(())))((()))",
      "((()(())))(()())",
      "((()(())))(())()",
      "((()(())))()(())",
      "((()(())))()()()",
      "((()()(((())))))",
      "((()()((()()))))",
      "((()()((())())))",
      "((()()((()))()))",
      "((()()((())))())",
      "((()()((()))))()",
      "((()()(()(()))))",
      "((()()(()()())))",
      "((()()(()())()))",
      "((()()(()()))())",
      "((()()(()())))()",
      "((()()(())(())))",
      "((()()(())()()))",
      "((()()(())())())",
      "((()()(())()))()",
      "((()()(()))(()))",
      "((()()(()))()())",
      "((()()(()))())()",
      "((()()(())))(())",
      "((()()(())))()()",
      "((()()()((()))))",
      "((()()()(()())))",
      "((()()()(())()))",
      "((()()()(()))())",
      "((()()()(())))()",
      "((()()()()(())))",
      "((()()()()()()))",
      "((()()()()())())",
      "((()()()()()))()",
      "((()()()())(()))",
      "((()()()())()())",
      "((()()()())())()",
      "((()()()()))(())",
      "((()()()()))()()",
      "((()()())((())))",
      "((()()())(()()))",
      "((()()())(())())",
      "((()()())(()))()",
      "((()()())()(()))",
      "((()()())()()())",
      "((()()())()())()",
      "((()()())())(())",
      "((()()())())()()",
      "((()()()))((()))",
      "((()()()))(()())",
      "((()()()))(())()",
      "((()()()))()(())",
      "((()()()))()()()",
      "((()())(((()))))",
      "((()())((()())))",
      "((()())((())()))",
      "((()())((()))())",
      "((()())((())))()",
      "((()())(()(())))",
      "((()())(()()()))",
      "((()())(()())())",
      "((()())(()()))()",
      "((()())(())(()))",
      "((()())(())()())",
      "((()())(())())()",
      "((()())(()))(())",
      "((()())(()))()()",
      "((()())()((())))",
      "((()())()(()()))",
      "((()())()(())())",
      "((()())()(()))()",
      "((()())()()(()))",
      "((()())()()()())",
      "((()())()()())()",
      "((()())()())(())",
      "((()())()())()()",
      "((()())())((()))",
      "((()())())(()())",
      "((()())())(())()",
      "((()())())()(())",
      "((()())())()()()",
      "((()()))(((())))",
      "((()()))((()()))",
      "((()()))((())())",
      "((()()))((()))()",
      "((()()))(()(()))",
      "((()()))(()()())",
      "((()()))(()())()",
      "((()()))(())(())",
      "((()()))(())()()",
      "((()()))()((()))",
      "((()()))()(()())",
      "((()()))()(())()",
      "((()()))()()(())",
      "((()()))()()()()",
      "((())((((())))))",
      "((())(((()()))))",
      "((())(((())())))",
      "((())(((()))()))",
      "((())(((())))())",
      "((())(((()))))()",
      "((())((()(()))))",
      "((())((()()())))",
      "((())((()())()))",
      "((())((()()))())",
      "((())((()())))()",
      "((())((())(())))",
      "((())((())()()))",
      "((())((())())())",
      "((())((())()))()",
      "((())((()))(()))",
      "((())((()))()())",
      "((())((()))())()",
      "((())((())))(())",
      "((())((())))()()",
      "((())(()((()))))",
      "((())(()(()())))",
      "((())(()(())()))",
      "((())(()(()))())",
      "((())(()(())))()",
      "((())(()()(())))",
      "((())(()()()()))",
      "((())(()()())())",
      "((())(()()()))()",
      "((())(()())(()))",
      "((())(()())()())",
      "((())(()())())()",
      "((())(()()))(())",
      "((())(()()))()()",
      "((())(())((())))",
      "((())(())(()()))",
      "((())(())(())())",
      "((())(())(()))()",
      "((())(())()(()))",
      "((())(())()()())",
      "((())(())()())()",
      "((())(())())(())",
      "((())(())())()()",
      "((())(()))((()))",
      "((())(()))(()())",
      "((())(()))(())()",
      "((())(()))()(())",
      "((())(()))()()()",
      "((())()(((()))))",
      "((())()((()())))",
      "((())()((())()))",
      "((())()((()))())",
      "((())()((())))()",
      "((())()(()(())))",
      "((())()(()()()))",
      "((())()(()())())",
      "((())()(()()))()",
      "((())()(())(()))",
      "((())()(())()())",
      "((())()(())())()",
      "((())()(()))(())",
      "((())()(()))()()",
      "((())()()((())))",
      "((())()()(()()))",
      "((())()()(())())",
      "((())()()(()))()",
      "((())()()()(()))",
      "((())()()()()())",
      "((())()()()())()",
      "((())()()())(())",
      "((())()()())()()",
      "((())()())((()))",
      "((())()())(()())",
      "((())()())(())()",
      "((())()())()(())",
      "((())()())()()()",
      "((())())(((())))",
      "((())())((()()))",
      "((())())((())())",
      "((())())((()))()",
      "((())())(()(()))",
      "((())())(()()())",
      "((())())(()())()",
      "((())())(())(())",
      "((())())(())()()",
      "((())())()((()))",
      "((())())()(()())",
      "((())())()(())()",
      "((())())()()(())",
      "((())())()()()()",
      "((()))((((()))))",
      "((()))(((()())))",
      "((()))(((())()))",
      "((()))(((()))())",
      "((()))(((())))()",
      "((()))((()(())))",
      "((()))((()()()))",
      "((()))((()())())",
      "((()))((()()))()",
      "((()))((())(()))",
      "((()))((())()())",
      "((()))((())())()",
      "((()))((()))(())",
      "((()))((()))()()",
      "((()))(()((())))",
      "((()))(()(()()))",
      "((()))(()(())())",
      "((()))(()(()))()",
      "((()))(()()(()))",
      "((()))(()()()())",
      "((()))(()()())()",
      "((()))(()())(())",
      "((()))(()())()()",
      "((()))(())((()))",
      "((()))(())(()())",
      "((()))(())(())()",
      "((()))(())()(())",
      "((()))(())()()()",
      "((()))()(((())))",
      "((()))()((()()))",
      "((()))()((())())",
      "((()))()((()))()",
      "((()))()(()(()))",
      "((()))()(()()())",
      "((()))()(()())()",
      "((()))()(())(())",
      "((()))()(())()()",
      "((()))()()((()))",
      "((()))()()(()())",
      "((()))()()(())()",
      "((()))()()()(())",
      "((()))()()()()()",
      "(()(((((()))))))",
      "(()((((()())))))",
      "(()((((())()))))",
      "(()((((()))())))",
      "(()((((())))()))",
      "(()((((()))))())",
      "(()((((())))))()",
      "(()(((()(())))))",
      "(()(((()()()))))",
      "(()(((()())())))",
      "(()(((()()))()))",
      "(()(((()())))())",
      "(()(((()()))))()",
      "(()(((())(()))))",
      "(()(((())()())))",
      "(()(((())())()))",
      "(()(((())()))())",
      "(()(((())())))()",
      "(()(((()))(())))",
      "(()(((()))()()))",
      "(()(((()))())())",
      "(()(((()))()))()",
      "(()(((())))(()))",
      "(()(((())))()())",
      "(()(((())))())()",
      "(()(((()))))(())",
      "(()(((()))))()()",
      "(()((()((())))))",
      "(()((()(()()))))",
      "(()((()(())())))",
      "(()((()(()))()))",
      "(()((()(())))())",
      "(()((()(()))))()",
      "(()((()()(()))))",
      "(()((()()()())))",
      "(()((()()())()))",
      "(()((()()()))())",
      "(()((()()())))()",
      "(()((()())(())))",
      "(()((()())()()))",
      "(()((()())())())",
      "(()((()())()))()",
      "(()((()()))(()))",
      "(()((()()))()())",
      "(()((()()))())()",
      "(()((()())))(())",
      "(()((()())))()()",
      "(()((())((()))))",
      "(()((())(()())))",
      "(()((())(())()))",
      "(()((())(()))())",
      "(()((())(())))()",
      "(()((())()(())))",
      "(()((())()()()))",
      "(()((())()())())",
      "(()((())()()))()",
      "(()((())())(()))",
      "(()((())())()())",
      "(()((())())())()",
      "(()((())()))(())",
      "(()((())()))()()",
      "(()((()))((())))",
      "(()((()))(()()))",
      "(()((()))(())())",
      "(()((()))(()))()",
      "(()((()))()(()))",
      "(()((()))()()())",
      "(()((()))()())()",
      "(()((()))())(())",
      "(()((()))())()()",
      "(()((())))((()))",
      "(()((())))(()())",
      "(()((())))(())()",
      "(()((())))()(())",
      "(()((())))()()()",
      "(()(()(((())))))",
      "(()(()((()()))))",
      "(()(()((())())))",
      "(()(()((()))()))",
      "(()(()((())))())",
      "(()(()((()))))()",
      "(()(()(()(()))))",
      "(()(()(()()())))",
      "(()(()(()())()))",
      "(()(()(()()))())",
      "(()(()(()())))()",
      "(()(()(())(())))",
      "(()(()(())()()))",
      "(()(()(())())())",
      "(()(()(())()))()",
      "(()(()(()))(()))",
      "(()(()(()))()())",
      "(()(()(()))())()",
      "(()(()(())))(())",
      "(()(()(())))()()",
      "(()(()()((()))))",
      "(()(()()(()())))",
      "(()(()()(())()))",
      "(()(()()(()))())",
      "(()(()()(())))()",
      "(()(()()()(())))",
      "(()(()()()()()))",
      "(()(()()()())())",
      "(()(()()()()))()",
      "(()(()()())(()))",
      "(()(()()())()())",
      "(()(()()())())()",
      "(()(()()()))(())",
      "(()(()()()))()()",
      "(()(()())((())))",
      "(()(()())(()()))",
      "(()(()())(())())",
      "(()(()())(()))()",
      "(()(()())()(()))",
      "(()(()())()()())",
      "(()(()())()())()",
      "(()(()())())(())",
      "(()(()())())()()",
      "(()(()()))((()))",
      "(()(()()))(()())",
      "(()(()()))(())()",
      "(()(()()))()(())",
      "(()(()()))()()()",
      "(()(())(((()))))",
      "(()(())((()())))",
      "(()(())((())()))",
      "(()(())((()))())",
      "(()(())((())))()",
      "(()(())(()(())))",
      "(()(())(()()()))",
      "(()(())(()())())",
      "(()(())(()()))()",
      "(()(())(())(()))",
      "(()(())(())()())",
      "(()(())(())())()",
      "(()(())(()))(())",
      "(()(())(()))()()",
      "(()(())()((())))",
      "(()(())()(()()))",
      "(()(())()(())())",
      "(()(())()(()))()",
      "(()(())()()(()))",
      "(()(())()()()())",
      "(()(())()()())()",
      "(()(())()())(())",
      "(()(())()())()()",
      "(()(())())((()))",
      "(()(())())(()())",
      "(()(())())(())()",
      "(()(())())()(())",
      "(()(())())()()()",
      "(()(()))(((())))",
      "(()(()))((()()))",
      "(()(()))((())())",
      "(()(()))((()))()",
      "(()(()))(()(()))",
      "(()(()))(()()())",
      "(()(()))(()())()",
      "(()(()))(())(())",
      "(()(()))(())()()",
      "(()(()))()((()))",
      "(()(()))()(()())",
      "(()(()))()(())()",
      "(()(()))()()(())",
      "(()(()))()()()()",
      "(()()((((())))))",
      "(()()(((()()))))",
      "(()()(((())())))",
      "(()()(((()))()))",
      "(()()(((())))())",
      "(()()(((()))))()",
      "(()()((()(()))))",
      "(()()((()()())))",
      "(()()((()())()))",
      "(()()((()()))())",
      "(()()((()())))()",
      "(()()((())(())))",
      "(()()((())()()))",
      "(()()((())())())",
      "(()()((())()))()",
      "(()()((()))(()))",
      "(()()((()))()())",
      "(()()((()))())()",
      "(()()((())))(())",
      "(()()((())))()()",
      "(()()(()((()))))",
      "(()()(()(()())))",
      "(()()(()(())()))",
      "(()()(()(()))())",
      "(()()(()(())))()",
      "(()()(()()(())))",
      "(()()(()()()()))",
      "(()()(()()())())",
      "(()()(()()()))()",
      "(()()(()())(()))",
      "(()()(()())()())",
      "(()()(()())())()",
      "(()()(()()))(())",
      "(()()(()()))()()",
      "(()()(())((())))",
      "(()()(())(()()))",
      "(()()(())(())())",
      "(()()(())(()))()",
      "(()()(())()(()))",
      "(()()(())()()())",
      "(()()(())()())()",
      "(()()(())())(())",
      "(()()(())())()()",
      "(()()(()))((()))",
      "(()()(()))(()())",
      "(()()(()))(())()",
      "(()()(()))()(())",
      "(()()(()))()()()",
      "(()()()(((()))))",
      "(()()()((()())))",
      "(()()()((())()))",
      "(()()()((()))())",
      "(()()()((())))()",
      "(()()()(()(())))",
      "(()()()(()()()))",
      "(()()()(()())())",
      "(()()()(()()))()",
      "(()()()(())(()))",
      "(()()()(())()())",
      "(()()()(())())()",
      "(()()()(()))(())",
      "(()()()(()))()()",
      "(()()()()((())))",
      "(()()()()(()()))",
      "(()()()()(())())",
      "(()()()()(()))()",
      "(()()()()()(()))",
      "(()()()()()()())",
      "(()()()()()())()",
      "(()()()()())(())",
      "(()()()()())()()",
      "(()()()())((()))",
      "(()()()())(()())",
      "(()()()())(())()",
      "(()()()())()(())",
      "(()()()())()()()",
      "(()()())(((())))",
      "(()()())((()()))",
      "(()()())((())())",
      "(()()())((()))()",
      "(()()())(()(()))",
      "(()()())(()()())",
      "(()()())(()())()",
      "(()()())(())(())",
      "(()()())(())()()",
      "(()()())()((()))",
      "(()()())()(()())",
      "(()()())()(())()",
      "(()()())()()(())",
      "(()()())()()()()",
      "(()())((((()))))",
      "(()())(((()())))",
      "(()())(((())()))",
      "(()())(((()))())",
      "(()())(((())))()",
      "(()())((()(())))",
      "(()())((()()()))",
      "(()())((()())())",
      "(()())((()()))()",
      "(()())((())(()))",
      "(()())((())()())",
      "(()())((())())()",
      "(()())((()))(())",
      "(()())((()))()()",
      "(()())(()((())))",
      "(()())(()(()()))",
      "(()())(()(())())",
      "(()())(()(()))()",
      "(()())(()()(()))",
      "(()())(()()()())",
      "(()())(()()())()",
      "(()())(()())(())",
      "(()())(()())()()",
      "(()())(())((()))",
      "(()())(())(()())",
      "(()())(())(())()",
      "(()())(())()(())",
      "(()())(())()()()",
      "(()())()(((())))",
      "(()())()((()()))",
      "(()())()((())())",
      "(()())()((()))()",
      "(()())()(()(()))",
      "(()())()(()()())",
      "(()())()(()())()",
      "(()())()(())(())",
      "(()())()(())()()",
      "(()())()()((()))",
      "(()())()()(()())",
      "(()())()()(())()",
      "(()())()()()(())",
      "(()())()()()()()",
      "(())(((((())))))",
      "(())((((()()))))",
      "(())((((())())))",
      "(())((((()))()))",
      "(())((((())))())",
      "(())((((()))))()",
      "(())(((()(()))))",
      "(())(((()()())))",
      "(())(((()())()))",
      "(())(((()()))())",
      "(())(((()())))()",
      "(())(((())(())))",
      "(())(((())()()))",
      "(())(((())())())",
      "(())(((())()))()",
      "(())(((()))(()))",
      "(())(((()))()())",
      "(())(((()))())()",
      "(())(((())))(())",
      "(())(((())))()()",
      "(())((()((()))))",
      "(())((()(()())))",
      "(())((()(())()))",
      "(())((()(()))())",
      "(())((()(())))()",
      "(())((()()(())))",
      "(())((()()()()))",
      "(())((()()())())",
      "(())((()()()))()",
      "(())((()())(()))",
      "(())((()())()())",
      "(())((()())())()",
      "(())((()()))(())",
      "(())((()()))()()",
      "(())((())((())))",
      "(())((())(()()))",
      "(())((())(())())",
      "(())((())(()))()",
      "(())((())()(()))",
      "(())((())()()())",
      "(())((())()())()",
      "(())((())())(())",
      "(())((())())()()",
      "(())((()))((()))",
      "(())((()))(()())",
      "(())((()))(())()",
      "(())((()))()(())",
      "(())((()))()()()",
      "(())(()(((()))))",
      "(())(()((()())))",
      "(())(()((())()))",
      "(())(()((()))())",
      "(())(()((())))()",
      "(())(()(()(())))",
      "(())(()(()()()))",
      "(())(()(()())())",
      "(())(()(()()))()",
      "(())(()(())(()))",
      "(())(()(())()())",
      "(())(()(())())()",
      "(())(()(()))(())",
      "(())(()(()))()()",
      "(())(()()((())))",
      "(())(()()(()()))",
      "(())(()()(())())",
      "(())(()()(()))()",
      "(())(()()()(()))",
      "(())(()()()()())",
      "(())(()()()())()",
      "(())(()()())(())",
      "(())(()()())()()",
      "(())(()())((()))",
      "(())(()())(()())",
      "(())(()())(())()",
      "(())(()())()(())",
      "(())(()())()()()",
      "(())(())(((())))",
      "(())(())((()()))",
      "(())(())((())())",
      "(())(())((()))()",
      "(())(())(()(()))",
      "(())(())(()()())",
      "(())(())(()())()",
      "(())(())(())(())",
      "(())(())(())()()",
      "(())(())()((()))",
      "(())(())()(()())",
      "(())(())()(())()",
      "(())(())()()(())",
      "(())(())()()()()",
      "(())()((((()))))",
      "(())()(((()())))",
      "(())()(((())()))",
      "(())()(((()))())",
      "(())()(((())))()",
      "(())()((()(())))",
      "(())()((()()()))",
      "(())()((()())())",
      "(())()((()()))()",
      "(())()((())(()))",
      "(())()((())()())",
      "(())()((())())()",
      "(())()((()))(())",
      "(())()((()))()()",
      "(())()(()((())))",
      "(())()(()(()()))",
      "(())()(()(())())",
      "(())()(()(()))()",
      "(())()(()()(()))",
      "(())()(()()()())",
      "(())()(()()())()",
      "(())()(()())(())",
      "(())()(()())()()",
      "(())()(())((()))",
      "(())()(())(()())",
      "(())()(())(())()",
      "(())()(())()(())",
      "(())()(())()()()",
      "(())()()(((())))",
      "(())()()((()()))",
      "(())()()((())())",
      "(())()()((()))()",
      "(())()()(()(()))",
      "(())()()(()()())",
      "(())()()(()())()",
      "(())()()(())(())",
      "(())()()(())()()",
      "(())()()()((()))",
      "(())()()()(()())",
      "(())()()()(())()",
      "(())()()()()(())",
      "(())()()()()()()",
      "()((((((()))))))",
      "()(((((()())))))",
      "()(((((())()))))",
      "()(((((()))())))",
      "()(((((())))()))",
      "()(((((()))))())",
      "()(((((())))))()",
      "()((((()(())))))",
      "()((((()()()))))",
      "()((((()())())))",
      "()((((()()))()))",
      "()((((()())))())",
      "()((((()()))))()",
      "()((((())(()))))",
      "()((((())()())))",
      "()((((())())()))",
      "()((((())()))())",
      "()((((())())))()",
      "()((((()))(())))",
      "()((((()))()()))",
      "()((((()))())())",
      "()((((()))()))()",
      "()((((())))(()))",
      "()((((())))()())",
      "()((((())))())()",
      "()((((()))))(())",
      "()((((()))))()()",
      "()(((()((())))))",
      "()(((()(()()))))",
      "()(((()(())())))",
      "()(((()(()))()))",
      "()(((()(())))())",
      "()(((()(()))))()",
      "()(((()()(()))))",
      "()(((()()()())))",
      "()(((()()())()))",
      "()(((()()()))())",
      "()(((()()())))()",
      "()(((()())(())))",
      "()(((()())()()))",
      "()(((()())())())",
      "()(((()())()))()",
      "()(((()()))(()))",
      "()(((()()))()())",
      "()(((()()))())()",
      "()(((()())))(())",
      "()(((()())))()()",
      "()(((())((()))))",
      "()(((())(()())))",
      "()(((())(())()))",
      "()(((())(()))())",
      "()(((())(())))()",
      "()(((())()(())))",
      "()(((())()()()))",
      "()(((())()())())",
      "()(((())()()))()",
      "()(((())())(()))",
      "()(((())())()())",
      "()(((())())())()",
      "()(((())()))(())",
      "()(((())()))()()",
      "()(((()))((())))",
      "()(((()))(()()))",
      "()(((()))(())())",
      "()(((()))(()))()",
      "()(((()))()(()))",
      "()(((()))()()())",
      "()(((()))()())()",
      "()(((()))())(())",
      "()(((()))())()()",
      "()(((())))((()))",
      "()(((())))(()())",
      "()(((())))(())()",
      "()(((())))()(())",
      "()(((())))()()()",
      "()((()(((())))))",
      "()((()((()()))))",
      "()((()((())())))",
      "()((()((()))()))",
      "()((()((())))())",
      "()((()((()))))()",
      "()((()(()(()))))",
      "()((()(()()())))",
      "()((()(()())()))",
      "()((()(()()))())",
      "()((()(()())))()",
      "()((()(())(())))",
      "()((()(())()()))",
      "()((()(())())())",
      "()((()(())()))()",
      "()((()(()))(()))",
      "()((()(()))()())",
      "()((()(()))())()",
      "()((()(())))(())",
      "()((()(())))()()",
      "()((()()((()))))",
      "()((()()(()())))",
      "()((()()(())()))",
      "()((()()(()))())",
      "()((()()(())))()",
      "()((()()()(())))",
      "()((()()()()()))",
      "()((()()()())())",
      "()((()()()()))()",
      "()((()()())(()))",
      "()((()()())()())",
      "()((()()())())()",
      "()((()()()))(())",
      "()((()()()))()()",
      "()((()())((())))",
      "()((()())(()()))",
      "()((()())(())())",
      "()((()())(()))()",
      "()((()())()(()))",
      "()((()())()()())",
      "()((()())()())()",
      "()((()())())(())",
      "()((()())())()()",
      "()((()()))((()))",
      "()((()()))(()())",
      "()((()()))(())()",
      "()((()()))()(())",
      "()((()()))()()()",
      "()((())(((()))))",
      "()((())((()())))",
      "()((())((())()))",
      "()((())((()))())",
      "()((())((())))()",
      "()((())(()(())))",
      "()((())(()()()))",
      "()((())(()())())",
      "()((())(()()))()",
      "()((())(())(()))",
      "()((())(())()())",
      "()((())(())())()",
      "()((())(()))(())",
      "()((())(()))()()",
      "()((())()((())))",
      "()((())()(()()))",
      "()((())()(())())",
      "()((())()(()))()",
      "()((())()()(()))",
      "()((())()()()())",
      "()((())()()())()",
      "()((())()())(())",
      "()((())()())()()",
      "()((())())((()))",
      "()((())())(()())",
      "()((())())(())()",
      "()((())())()(())",
      "()((())())()()()",
      "()((()))(((())))",
      "()((()))((()()))",
      "()((()))((())())",
      "()((()))((()))()",
      "()((()))(()(()))",
      "()((()))(()()())",
      "()((()))(()())()",
      "()((()))(())(())",
      "()((()))(())()()",
      "()((()))()((()))",
      "()((()))()(()())",
      "()((()))()(())()",
      "()((()))()()(())",
      "()((()))()()()()",
      "()(()((((())))))",
      "()(()(((()()))))",
      "()(()(((())())))",
      "()(()(((()))()))",
      "()(()(((())))())",
      "()(()(((()))))()",
      "()(()((()(()))))",
      "()(()((()()())))",
      "()(()((()())()))",
      "()(()((()()))())",
      "()(()((()())))()",
      "()(()((())(())))",
      "()(()((())()()))",
      "()(()((())())())",
      "()(()((())()))()",
      "()(()((()))(()))",
      "()(()((()))()())",
      "()(()((()))())()",
      "()(()((())))(())",
      "()(()((())))()()",
      "()(()(()((()))))",
      "()(()(()(()())))",
      "()(()(()(())()))",
      "()(()(()(()))())",
      "()(()(()(())))()",
      "()(()(()()(())))",
      "()(()(()()()()))",
      "()(()(()()())())",
      "()(()(()()()))()",
      "()(()(()())(()))",
      "()(()(()())()())",
      "()(()(()())())()",
      "()(()(()()))(())",
      "()(()(()()))()()",
      "()(()(())((())))",
      "()(()(())(()()))",
      "()(()(())(())())",
      "()(()(())(()))()",
      "()(()(())()(()))",
      "()(()(())()()())",
      "()(()(())()())()",
      "()(()(())())(())",
      "()(()(())())()()",
      "()(()(()))((()))",
      "()(()(()))(()())",
      "()(()(()))(())()",
      "()(()(()))()(())",
      "()(()(()))()()()",
      "()(()()(((()))))",
      "()(()()((()())))",
      "()(()()((())()))",
      "()(()()((()))())",
      "()(()()((())))()",
      "()(()()(()(())))",
      "()(()()(()()()))",
      "()(()()(()())())",
      "()(()()(()()))()",
      "()(()()(())(()))",
      "()(()()(())()())",
      "()(()()(())())()",
      "()(()()(()))(())",
      "()(()()(()))()()",
      "()(()()()((())))",
      "()(()()()(()()))",
      "()(()()()(())())",
      "()(()()()(()))()",
      "()(()()()()(()))",
      "()(()()()()()())",
      "()(()()()()())()",
      "()(()()()())(())",
      "()(()()()())()()",
      "()(()()())((()))",
      "()(()()())(()())",
      "()(()()())(())()",
      "()(()()())()(())",
      "()(()()())()()()",
      "()(()())(((())))",
      "()(()())((()()))",
      "()(()())((())())",
      "()(()())((()))()",
      "()(()())(()(()))",
      "()(()())(()()())",
      "()(()())(()())()",
      "()(()())(())(())",
      "()(()())(())()()",
      "()(()())()((()))",
      "()(()())()(()())",
      "()(()())()(())()",
      "()(()())()()(())",
      "()(()())()()()()",
      "()(())((((()))))",
      "()(())(((()())))",
      "()(())(((())()))",
      "()(())(((()))())",
      "()(())(((())))()",
      "()(())((()(())))",
      "()(())((()()()))",
      "()(())((()())())",
      "()(())((()()))()",
      "()(())((())(()))",
      "()(())((())()())",
      "()(())((())())()",
      "()(())((()))(())",
      "()(())((()))()()",
      "()(())(()((())))",
      "()(())(()(()()))",
      "()(())(()(())())",
      "()(())(()(()))()",
      "()(())(()()(()))",
      "()(())(()()()())",
      "()(())(()()())()",
      "()(())(()())(())",
      "()(())(()())()()",
      "()(())(())((()))",
      "()(())(())(()())",
      "()(())(())(())()",
      "()(())(())()(())",
      "()(())(())()()()",
      "()(())()(((())))",
      "()(())()((()()))",
      "()(())()((())())",
      "()(())()((()))()",
      "()(())()(()(()))",
      "()(())()(()()())",
      "()(())()(()())()",
      "()(())()(())(())",
      "()(())()(())()()",
      "()(())()()((()))",
      "()(())()()(()())",
      "()(())()()(())()",
      "()(())()()()(())",
      "()(())()()()()()",
      "()()(((((())))))",
      "()()((((()()))))",
      "()()((((())())))",
      "()()((((()))()))",
      "()()((((())))())",
      "()()((((()))))()",
      "()()(((()(()))))",
      "()()(((()()())))",
      "()()(((()())()))",
      "()()(((()()))())",
      "()()(((()())))()",
      "()()(((())(())))",
      "()()(((())()()))",
      "()()(((())())())",
      "()()(((())()))()",
      "()()(((()))(()))",
      "()()(((()))()())",
      "()()(((()))())()",
      "()()(((())))(())",
      "()()(((())))()()",
      "()()((()((()))))",
      "()()((()(()())))",
      "()()((()(())()))",
      "()()((()(()))())",
      "()()((()(())))()",
      "()()((()()(())))",
      "()()((()()()()))",
      "()()((()()())())",
      "()()((()()()))()",
      "()()((()())(()))",
      "()()((()())()())",
      "()()((()())())()",
      "()()((()()))(())",
      "()()((()()))()()",
      "()()((())((())))",
      "()()((())(()()))",
      "()()((())(())())",
      "()()((())(()))()",
      "()()((())()(()))",
      "()()((())()()())",
      "()()((())()())()",
      "()()((())())(())",
      "()()((())())()()",
      "()()((()))((()))",
      "()()((()))(()())",
      "()()((()))(())()",
      "()()((()))()(())",
      "()()((()))()()()",
      "()()(()(((()))))",
      "()()(()((()())))",
      "()()(()((())()))",
      "()()(()((()))())",
      "()()(()((())))()",
      "()()(()(()(())))",
      "()()(()(()()()))",
      "()()(()(()())())",
      "()()(()(()()))()",
      "()()(()(())(()))",
      "()()(()(())()())",
      "()()(()(())())()",
      "()()(()(()))(())",
      "()()(()(()))()()",
      "()()(()()((())))",
      "()()(()()(()()))",
      "()()(()()(())())",
      "()()(()()(()))()",
      "()()(()()()(()))",
      "()()(()()()()())",
      "()()(()()()())()",
      "()()(()()())(())",
      "()()(()()())()()",
      "()()(()())((()))",
      "()()(()())(()())",
      "()()(()())(())()",
      "()()(()())()(())",
      "()()(()())()()()",
      "()()(())(((())))",
      "()()(())((()()))",
      "()()(())((())())",
      "()()(())((()))()",
      "()()(())(()(()))",
      "()()(())(()()())",
      "()()(())(()())()",
      "()()(())(())(())",
      "()()(())(())()()",
      "()()(())()((()))",
      "()()(())()(()())",
      "()()(())()(())()",
      "()()(())()()(())",
      "()()(())()()()()",
      "()()()((((()))))",
      "()()()(((()())))",
      "()()()(((())()))",
      "()()()(((()))())",
      "()()()(((())))()",
      "()()()((()(())))",
      "()()()((()()()))",
      "()()()((()())())",
      "()()()((()()))()",
      "()()()((())(()))",
      "()()()((())()())",
      "()()()((())())()",
      "()()()((()))(())",
      "()()()((()))()()",
      "()()()(()((())))",
      "()()()(()(()()))",
      "()()()(()(())())",
      "()()()(()(()))()",
      "()()()(()()(()))",
      "()()()(()()()())",
      "()()()(()()())()",
      "()()()(()())(())",
      "()()()(()())()()",
      "()()()(())((()))",
      "()()()(())(()())",
      "()()()(())(())()",
      "()()()(())()(())",
      "()()()(())()()()",
      "()()()()(((())))",
      "()()()()((()()))",
      "()()()()((())())",
      "()()()()((()))()",
      "()()()()(()(()))",
      "()()()()(()()())",
      "()()()()(()())()",
      "()()()()(())(())",
      "()()()()(())()()",
      "()()()()()((()))",
      "()()()()()(()())",
      "()()()()()(())()",
      "()()()()()()(())",
      "()()()()()()()()"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1242,
    '下一个排列',
    '给定一个整数数组 nums，将其重新排列为字典序中的下一个更大排列；如果不存在更大排列，则重排为最小排列。

提示：
- 1 <= nums.length <= 100
- 0 <= nums[i] <= 100',
    'medium',
    1000,
    256,
    ARRAY['数组', '双指针'],
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "[1, 3, 2]"
  },
  {
    "input": "nums = [3, 2, 1]",
    "output": "[1, 2, 3]"
  },
  {
    "input": "nums = [1, 1, 5]",
    "output": "[1, 5, 1]"
  },
  {
    "input": "nums = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "[1, 3, 2]"
  },
  {
    "input": "nums = [3, 2, 1]",
    "output": "[1, 2, 3]"
  },
  {
    "input": "nums = [1, 1, 5]",
    "output": "[1, 5, 1]"
  },
  {
    "input": "nums = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var nextPermutation = function(nums) {\n};\n",
  "python": "class Solution:\n    def nextPermutation(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> nextPermutation(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] nextPermutation(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "nextPermutation",
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
          3
        ]
      ],
      "expected": [
        1,
        3,
        2
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
        1,
        2,
        3
      ]
    },
    {
      "args": [
        [
          1,
          1,
          5
        ]
      ],
      "expected": [
        1,
        5,
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
        1,
        3,
        2
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
        2,
        3,
        1
      ]
    ],
    "expected": [
      3,
      1,
      2
    ]
  },
  {
    "args": [
      [
        5,
        1,
        1
      ]
    ],
    "expected": [
      1,
      1,
      5
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
        2,
        1,
        3
      ]
    ],
    "expected": [
      2,
      3,
      1
    ]
  },
  {
    "args": [
      [
        4,
        2,
        0,
        2,
        3,
        2,
        0
      ]
    ],
    "expected": [
      4,
      2,
      0,
      3,
      0,
      2,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1243,
    '旋转排序数组中的最小值',
    '给定一个长度为 n 的升序数组经过若干次旋转后的结果 nums，返回数组中的最小元素。
数组中的值互不相同，旋转后可能仍保持升序。

提示：
- 1 <= nums.length <= 5000
- -5000 <= nums[i] <= 5000',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "nums = [3, 4, 5, 1, 2]",
    "output": "1"
  },
  {
    "input": "nums = [4, 5, 6, 7, 0, 1, 2]",
    "output": "0"
  },
  {
    "input": "nums = [11, 13, 15, 17]",
    "output": "11"
  },
  {
    "input": "nums = [2, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 4, 5, 1, 2]",
    "output": "1"
  },
  {
    "input": "nums = [4, 5, 6, 7, 0, 1, 2]",
    "output": "0"
  },
  {
    "input": "nums = [11, 13, 15, 17]",
    "output": "11"
  },
  {
    "input": "nums = [2, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findMinRotated = function(nums) {\n};\n",
  "python": "class Solution:\n    def findMinRotated(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findMinRotated(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findMinRotated(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findMinRotated",
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
          5,
          1,
          2
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          4,
          5,
          6,
          7,
          0,
          1,
          2
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          11,
          13,
          15,
          17
        ]
      ],
      "expected": 11
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
        5,
        1,
        3
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        6,
        7,
        0,
        1,
        2,
        4,
        5
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
        5,
        1
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1244,
    '全排列',
    '给定一个不含重复数字的数组 nums，返回其所有可能的全排列。答案按字典序排列。

提示：
- 1 <= nums.length <= 6
- -10 <= nums[i] <= 10',
    'medium',
    1000,
    256,
    ARRAY['数组', '回溯'],
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "[[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]"
  },
  {
    "input": "nums = [0, 1]",
    "output": "[[0, 1], [1, 0]]"
  },
  {
    "input": "nums = [1]",
    "output": "[[1]]"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "[[1, 2, 3, 4], [1, 2, 4, 3], [1, 3, 2, 4], [1, 3, 4, 2], [1, 4, 2, 3], [1, 4, 3, 2], [2, 1, 3, 4], [2, 1, 4, 3], [2, 3, 1, 4], [2, 3, 4, 1], [2, 4, 1, 3], [2, 4, 3, 1], [3, 1, 2, 4], [3, 1, 4, 2], [3, 2, 1, 4], [3, 2, 4, 1], [3, 4, 1, 2], [3, 4, 2, 1], [4, 1, 2, 3], [4, 1, 3, 2], [4, 2, 1, 3], [4, 2, 3, 1], [4, 3, 1, 2], [4, 3, 2, 1]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "[[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]"
  },
  {
    "input": "nums = [0, 1]",
    "output": "[[0, 1], [1, 0]]"
  },
  {
    "input": "nums = [1]",
    "output": "[[1]]"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "[[1, 2, 3, 4], [1, 2, 4, 3], [1, 3, 2, 4], [1, 3, 4, 2], [1, 4, 2, 3], [1, 4, 3, 2], [2, 1, 3, 4], [2, 1, 4, 3], [2, 3, 1, 4], [2, 3, 4, 1], [2, 4, 1, 3], [2, 4, 3, 1], [3, 1, 2, 4], [3, 1, 4, 2], [3, 2, 1, 4], [3, 2, 4, 1], [3, 4, 1, 2], [3, 4, 2, 1], [4, 1, 2, 3], [4, 1, 3, 2], [4, 2, 1, 3], [4, 2, 3, 1], [4, 3, 1, 2], [4, 3, 2, 1]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var permutations = function(nums) {\n};\n",
  "python": "class Solution:\n    def permutations(self, nums: list[int]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> permutations(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] permutations(int[] nums) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "permutations",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
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
          3
        ]
      ],
      "expected": [
        [
          1,
          2,
          3
        ],
        [
          1,
          3,
          2
        ],
        [
          2,
          1,
          3
        ],
        [
          2,
          3,
          1
        ],
        [
          3,
          1,
          2
        ],
        [
          3,
          2,
          1
        ]
      ]
    },
    {
      "args": [
        [
          0,
          1
        ]
      ],
      "expected": [
        [
          0,
          1
        ],
        [
          1,
          0
        ]
      ]
    },
    {
      "args": [
        [
          1
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
          1,
          2,
          3,
          4
        ]
      ],
      "expected": [
        [
          1,
          2,
          3,
          4
        ],
        [
          1,
          2,
          4,
          3
        ],
        [
          1,
          3,
          2,
          4
        ],
        [
          1,
          3,
          4,
          2
        ],
        [
          1,
          4,
          2,
          3
        ],
        [
          1,
          4,
          3,
          2
        ],
        [
          2,
          1,
          3,
          4
        ],
        [
          2,
          1,
          4,
          3
        ],
        [
          2,
          3,
          1,
          4
        ],
        [
          2,
          3,
          4,
          1
        ],
        [
          2,
          4,
          1,
          3
        ],
        [
          2,
          4,
          3,
          1
        ],
        [
          3,
          1,
          2,
          4
        ],
        [
          3,
          1,
          4,
          2
        ],
        [
          3,
          2,
          1,
          4
        ],
        [
          3,
          2,
          4,
          1
        ],
        [
          3,
          4,
          1,
          2
        ],
        [
          3,
          4,
          2,
          1
        ],
        [
          4,
          1,
          2,
          3
        ],
        [
          4,
          1,
          3,
          2
        ],
        [
          4,
          2,
          1,
          3
        ],
        [
          4,
          2,
          3,
          1
        ],
        [
          4,
          3,
          1,
          2
        ],
        [
          4,
          3,
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
        -1,
        0,
        1
      ]
    ],
    "expected": [
      [
        -1,
        0,
        1
      ],
      [
        -1,
        1,
        0
      ],
      [
        0,
        -1,
        1
      ],
      [
        0,
        1,
        -1
      ],
      [
        1,
        -1,
        0
      ],
      [
        1,
        0,
        -1
      ]
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
      [
        2,
        3
      ],
      [
        3,
        2
      ]
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
      [
        3,
        2,
        1
      ],
      [
        3,
        1,
        2
      ],
      [
        2,
        3,
        1
      ],
      [
        2,
        1,
        3
      ],
      [
        1,
        3,
        2
      ],
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
        0,
        1,
        2,
        3
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
        3,
        2
      ],
      [
        0,
        2,
        1,
        3
      ],
      [
        0,
        2,
        3,
        1
      ],
      [
        0,
        3,
        1,
        2
      ],
      [
        0,
        3,
        2,
        1
      ],
      [
        1,
        0,
        2,
        3
      ],
      [
        1,
        0,
        3,
        2
      ],
      [
        1,
        2,
        0,
        3
      ],
      [
        1,
        2,
        3,
        0
      ],
      [
        1,
        3,
        0,
        2
      ],
      [
        1,
        3,
        2,
        0
      ],
      [
        2,
        0,
        1,
        3
      ],
      [
        2,
        0,
        3,
        1
      ],
      [
        2,
        1,
        0,
        3
      ],
      [
        2,
        1,
        3,
        0
      ],
      [
        2,
        3,
        0,
        1
      ],
      [
        2,
        3,
        1,
        0
      ],
      [
        3,
        0,
        1,
        2
      ],
      [
        3,
        0,
        2,
        1
      ],
      [
        3,
        1,
        0,
        2
      ],
      [
        3,
        1,
        2,
        0
      ],
      [
        3,
        2,
        0,
        1
      ],
      [
        3,
        2,
        1,
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
        5
      ]
    ],
    "expected": [
      [
        1,
        2,
        3,
        4,
        5
      ],
      [
        1,
        2,
        3,
        5,
        4
      ],
      [
        1,
        2,
        4,
        3,
        5
      ],
      [
        1,
        2,
        4,
        5,
        3
      ],
      [
        1,
        2,
        5,
        3,
        4
      ],
      [
        1,
        2,
        5,
        4,
        3
      ],
      [
        1,
        3,
        2,
        4,
        5
      ],
      [
        1,
        3,
        2,
        5,
        4
      ],
      [
        1,
        3,
        4,
        2,
        5
      ],
      [
        1,
        3,
        4,
        5,
        2
      ],
      [
        1,
        3,
        5,
        2,
        4
      ],
      [
        1,
        3,
        5,
        4,
        2
      ],
      [
        1,
        4,
        2,
        3,
        5
      ],
      [
        1,
        4,
        2,
        5,
        3
      ],
      [
        1,
        4,
        3,
        2,
        5
      ],
      [
        1,
        4,
        3,
        5,
        2
      ],
      [
        1,
        4,
        5,
        2,
        3
      ],
      [
        1,
        4,
        5,
        3,
        2
      ],
      [
        1,
        5,
        2,
        3,
        4
      ],
      [
        1,
        5,
        2,
        4,
        3
      ],
      [
        1,
        5,
        3,
        2,
        4
      ],
      [
        1,
        5,
        3,
        4,
        2
      ],
      [
        1,
        5,
        4,
        2,
        3
      ],
      [
        1,
        5,
        4,
        3,
        2
      ],
      [
        2,
        1,
        3,
        4,
        5
      ],
      [
        2,
        1,
        3,
        5,
        4
      ],
      [
        2,
        1,
        4,
        3,
        5
      ],
      [
        2,
        1,
        4,
        5,
        3
      ],
      [
        2,
        1,
        5,
        3,
        4
      ],
      [
        2,
        1,
        5,
        4,
        3
      ],
      [
        2,
        3,
        1,
        4,
        5
      ],
      [
        2,
        3,
        1,
        5,
        4
      ],
      [
        2,
        3,
        4,
        1,
        5
      ],
      [
        2,
        3,
        4,
        5,
        1
      ],
      [
        2,
        3,
        5,
        1,
        4
      ],
      [
        2,
        3,
        5,
        4,
        1
      ],
      [
        2,
        4,
        1,
        3,
        5
      ],
      [
        2,
        4,
        1,
        5,
        3
      ],
      [
        2,
        4,
        3,
        1,
        5
      ],
      [
        2,
        4,
        3,
        5,
        1
      ],
      [
        2,
        4,
        5,
        1,
        3
      ],
      [
        2,
        4,
        5,
        3,
        1
      ],
      [
        2,
        5,
        1,
        3,
        4
      ],
      [
        2,
        5,
        1,
        4,
        3
      ],
      [
        2,
        5,
        3,
        1,
        4
      ],
      [
        2,
        5,
        3,
        4,
        1
      ],
      [
        2,
        5,
        4,
        1,
        3
      ],
      [
        2,
        5,
        4,
        3,
        1
      ],
      [
        3,
        1,
        2,
        4,
        5
      ],
      [
        3,
        1,
        2,
        5,
        4
      ],
      [
        3,
        1,
        4,
        2,
        5
      ],
      [
        3,
        1,
        4,
        5,
        2
      ],
      [
        3,
        1,
        5,
        2,
        4
      ],
      [
        3,
        1,
        5,
        4,
        2
      ],
      [
        3,
        2,
        1,
        4,
        5
      ],
      [
        3,
        2,
        1,
        5,
        4
      ],
      [
        3,
        2,
        4,
        1,
        5
      ],
      [
        3,
        2,
        4,
        5,
        1
      ],
      [
        3,
        2,
        5,
        1,
        4
      ],
      [
        3,
        2,
        5,
        4,
        1
      ],
      [
        3,
        4,
        1,
        2,
        5
      ],
      [
        3,
        4,
        1,
        5,
        2
      ],
      [
        3,
        4,
        2,
        1,
        5
      ],
      [
        3,
        4,
        2,
        5,
        1
      ],
      [
        3,
        4,
        5,
        1,
        2
      ],
      [
        3,
        4,
        5,
        2,
        1
      ],
      [
        3,
        5,
        1,
        2,
        4
      ],
      [
        3,
        5,
        1,
        4,
        2
      ],
      [
        3,
        5,
        2,
        1,
        4
      ],
      [
        3,
        5,
        2,
        4,
        1
      ],
      [
        3,
        5,
        4,
        1,
        2
      ],
      [
        3,
        5,
        4,
        2,
        1
      ],
      [
        4,
        1,
        2,
        3,
        5
      ],
      [
        4,
        1,
        2,
        5,
        3
      ],
      [
        4,
        1,
        3,
        2,
        5
      ],
      [
        4,
        1,
        3,
        5,
        2
      ],
      [
        4,
        1,
        5,
        2,
        3
      ],
      [
        4,
        1,
        5,
        3,
        2
      ],
      [
        4,
        2,
        1,
        3,
        5
      ],
      [
        4,
        2,
        1,
        5,
        3
      ],
      [
        4,
        2,
        3,
        1,
        5
      ],
      [
        4,
        2,
        3,
        5,
        1
      ],
      [
        4,
        2,
        5,
        1,
        3
      ],
      [
        4,
        2,
        5,
        3,
        1
      ],
      [
        4,
        3,
        1,
        2,
        5
      ],
      [
        4,
        3,
        1,
        5,
        2
      ],
      [
        4,
        3,
        2,
        1,
        5
      ],
      [
        4,
        3,
        2,
        5,
        1
      ],
      [
        4,
        3,
        5,
        1,
        2
      ],
      [
        4,
        3,
        5,
        2,
        1
      ],
      [
        4,
        5,
        1,
        2,
        3
      ],
      [
        4,
        5,
        1,
        3,
        2
      ],
      [
        4,
        5,
        2,
        1,
        3
      ],
      [
        4,
        5,
        2,
        3,
        1
      ],
      [
        4,
        5,
        3,
        1,
        2
      ],
      [
        4,
        5,
        3,
        2,
        1
      ],
      [
        5,
        1,
        2,
        3,
        4
      ],
      [
        5,
        1,
        2,
        4,
        3
      ],
      [
        5,
        1,
        3,
        2,
        4
      ],
      [
        5,
        1,
        3,
        4,
        2
      ],
      [
        5,
        1,
        4,
        2,
        3
      ],
      [
        5,
        1,
        4,
        3,
        2
      ],
      [
        5,
        2,
        1,
        3,
        4
      ],
      [
        5,
        2,
        1,
        4,
        3
      ],
      [
        5,
        2,
        3,
        1,
        4
      ],
      [
        5,
        2,
        3,
        4,
        1
      ],
      [
        5,
        2,
        4,
        1,
        3
      ],
      [
        5,
        2,
        4,
        3,
        1
      ],
      [
        5,
        3,
        1,
        2,
        4
      ],
      [
        5,
        3,
        1,
        4,
        2
      ],
      [
        5,
        3,
        2,
        1,
        4
      ],
      [
        5,
        3,
        2,
        4,
        1
      ],
      [
        5,
        3,
        4,
        1,
        2
      ],
      [
        5,
        3,
        4,
        2,
        1
      ],
      [
        5,
        4,
        1,
        2,
        3
      ],
      [
        5,
        4,
        1,
        3,
        2
      ],
      [
        5,
        4,
        2,
        1,
        3
      ],
      [
        5,
        4,
        2,
        3,
        1
      ],
      [
        5,
        4,
        3,
        1,
        2
      ],
      [
        5,
        4,
        3,
        2,
        1
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1245,
    '组合总和',
    '给定一个无重复元素的整数数组 candidates 和一个目标整数 target，找出所有和为 target 的组合。
同一个数字可以无重复限制地被选取。答案按组合字典序排列。

提示：
- 1 <= candidates.length <= 30
- 1 <= candidates[i] <= 50
- 1 <= target <= 50',
    'medium',
    1000,
    256,
    ARRAY['数组', '回溯'],
    $json$[
  {
    "input": "candidates = [2, 3, 6, 7], target = 7",
    "output": "[[2, 2, 3], [7]]"
  },
  {
    "input": "candidates = [2, 3, 5], target = 8",
    "output": "[[2, 2, 2, 2], [2, 3, 3], [3, 5]]"
  },
  {
    "input": "candidates = [2], target = 1",
    "output": "[]"
  },
  {
    "input": "candidates = [1], target = 2",
    "output": "[[1, 1]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "candidates = [2, 3, 6, 7], target = 7",
    "output": "[[2, 2, 3], [7]]"
  },
  {
    "input": "candidates = [2, 3, 5], target = 8",
    "output": "[[2, 2, 2, 2], [2, 3, 3], [3, 5]]"
  },
  {
    "input": "candidates = [2], target = 1",
    "output": "[]"
  },
  {
    "input": "candidates = [1], target = 2",
    "output": "[[1, 1]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var combinationSum = function(candidates, target) {\n};\n",
  "python": "class Solution:\n    def combinationSum(self, candidates: list[int], target: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> combinationSum(std::vector<int>& candidates, int target) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] combinationSum(int[] candidates, int target) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "combinationSum",
  "params": [
    {
      "name": "candidates",
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
          2,
          3,
          6,
          7
        ],
        7
      ],
      "expected": [
        [
          2,
          2,
          3
        ],
        [
          7
        ]
      ]
    },
    {
      "args": [
        [
          2,
          3,
          5
        ],
        8
      ],
      "expected": [
        [
          2,
          2,
          2,
          2
        ],
        [
          2,
          3,
          3
        ],
        [
          3,
          5
        ]
      ]
    },
    {
      "args": [
        [
          2
        ],
        1
      ],
      "expected": []
    },
    {
      "args": [
        [
          1
        ],
        2
      ],
      "expected": [
        [
          1,
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
        3,
        5
      ],
      8
    ],
    "expected": [
      [
        3,
        5
      ]
    ]
  },
  {
    "args": [
      [
        2,
        4
      ],
      6
    ],
    "expected": [
      [
        2,
        2,
        2
      ],
      [
        2,
        4
      ]
    ]
  },
  {
    "args": [
      [
        7
      ],
      7
    ],
    "expected": [
      [
        7
      ]
    ]
  },
  {
    "args": [
      [
        1,
        2
      ],
      4
    ],
    "expected": [
      [
        1,
        1,
        1,
        1
      ],
      [
        1,
        1,
        2
      ],
      [
        2,
        2
      ]
    ]
  },
  {
    "args": [
      [
        8,
        3,
        5
      ],
      11
    ],
    "expected": [
      [
        3,
        3,
        5
      ],
      [
        3,
        8
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1246,
    '旋转图像',
    '给定一个 n × n 的二维矩阵 matrix，将其顺时针旋转 90 度并返回旋转后的矩阵。

提示：
- 1 <= n <= 20
- -1000 <= matrix[i][j] <= 1000',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵'],
    $json$[
  {
    "input": "matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]",
    "output": "[[7, 4, 1], [8, 5, 2], [9, 6, 3]]"
  },
  {
    "input": "matrix = [[5, 1, 9, 11], [2, 4, 8, 10], [13, 3, 6, 7], [15, 14, 12, 16]]",
    "output": "[[15, 13, 2, 5], [14, 3, 4, 1], [12, 6, 8, 9], [16, 7, 10, 11]]"
  },
  {
    "input": "matrix = [[1]]",
    "output": "[[1]]"
  },
  {
    "input": "matrix = [[1, 2], [3, 4]]",
    "output": "[[3, 1], [4, 2]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]",
    "output": "[[7, 4, 1], [8, 5, 2], [9, 6, 3]]"
  },
  {
    "input": "matrix = [[5, 1, 9, 11], [2, 4, 8, 10], [13, 3, 6, 7], [15, 14, 12, 16]]",
    "output": "[[15, 13, 2, 5], [14, 3, 4, 1], [12, 6, 8, 9], [16, 7, 10, 11]]"
  },
  {
    "input": "matrix = [[1]]",
    "output": "[[1]]"
  },
  {
    "input": "matrix = [[1, 2], [3, 4]]",
    "output": "[[3, 1], [4, 2]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var rotateImage = function(matrix) {\n};\n",
  "python": "class Solution:\n    def rotateImage(self, matrix: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> rotateImage(std::vector<std::vector<int>>& matrix) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] rotateImage(int[][] matrix) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "rotateImage",
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
          7,
          4,
          1
        ],
        [
          8,
          5,
          2
        ],
        [
          9,
          6,
          3
        ]
      ]
    },
    {
      "args": [
        [
          [
            5,
            1,
            9,
            11
          ],
          [
            2,
            4,
            8,
            10
          ],
          [
            13,
            3,
            6,
            7
          ],
          [
            15,
            14,
            12,
            16
          ]
        ]
      ],
      "expected": [
        [
          15,
          13,
          2,
          5
        ],
        [
          14,
          3,
          4,
          1
        ],
        [
          12,
          6,
          8,
          9
        ],
        [
          16,
          7,
          10,
          11
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
      "expected": [
        [
          3,
          1
        ],
        [
          4,
          2
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
        7,
        4,
        1
      ],
      [
        8,
        5,
        2
      ],
      [
        9,
        6,
        3
      ]
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
      ]
    ],
    "expected": [
      [
        0,
        0
      ],
      [
        0,
        0
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
          3,
          4
        ]
      ]
    ],
    "expected": [
      [
        3,
        1
      ],
      [
        4,
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
          3,
          4
        ],
        [
          5,
          6,
          7,
          8
        ],
        [
          9,
          10,
          11,
          12
        ],
        [
          13,
          14,
          15,
          16
        ]
      ]
    ],
    "expected": [
      [
        13,
        9,
        5,
        1
      ],
      [
        14,
        10,
        6,
        2
      ],
      [
        15,
        11,
        7,
        3
      ],
      [
        16,
        12,
        8,
        4
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1247,
    '螺旋矩阵 II',
    '给定一个正整数 n，生成一个 n × n 矩阵，按顺时针螺旋顺序填入 1 到 n^2，并返回该矩阵。

提示：
- 1 <= n <= 20',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '模拟'],
    $json$[
  {
    "input": "n = 3",
    "output": "[[1, 2, 3], [8, 9, 4], [7, 6, 5]]"
  },
  {
    "input": "n = 1",
    "output": "[[1]]"
  },
  {
    "input": "n = 2",
    "output": "[[1, 2], [4, 3]]"
  },
  {
    "input": "n = 4",
    "output": "[[1, 2, 3, 4], [12, 13, 14, 5], [11, 16, 15, 6], [10, 9, 8, 7]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3",
    "output": "[[1, 2, 3], [8, 9, 4], [7, 6, 5]]"
  },
  {
    "input": "n = 1",
    "output": "[[1]]"
  },
  {
    "input": "n = 2",
    "output": "[[1, 2], [4, 3]]"
  },
  {
    "input": "n = 4",
    "output": "[[1, 2, 3, 4], [12, 13, 14, 5], [11, 16, 15, 6], [10, 9, 8, 7]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var generateMatrix = function(n) {\n};\n",
  "python": "class Solution:\n    def generateMatrix(self, n: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> generateMatrix(int n) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] generateMatrix(int n) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "generateMatrix",
  "params": [
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
        3
      ],
      "expected": [
        [
          1,
          2,
          3
        ],
        [
          8,
          9,
          4
        ],
        [
          7,
          6,
          5
        ]
      ]
    },
    {
      "args": [
        1
      ],
      "expected": [
        [
          1
        ]
      ]
    },
    {
      "args": [
        2
      ],
      "expected": [
        [
          1,
          2
        ],
        [
          4,
          3
        ]
      ]
    },
    {
      "args": [
        4
      ],
      "expected": [
        [
          1,
          2,
          3,
          4
        ],
        [
          12,
          13,
          14,
          5
        ],
        [
          11,
          16,
          15,
          6
        ],
        [
          10,
          9,
          8,
          7
        ]
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      5
    ],
    "expected": [
      [
        1,
        2,
        3,
        4,
        5
      ],
      [
        16,
        17,
        18,
        19,
        6
      ],
      [
        15,
        24,
        25,
        20,
        7
      ],
      [
        14,
        23,
        22,
        21,
        8
      ],
      [
        13,
        12,
        11,
        10,
        9
      ]
    ]
  },
  {
    "args": [
      6
    ],
    "expected": [
      [
        1,
        2,
        3,
        4,
        5,
        6
      ],
      [
        20,
        21,
        22,
        23,
        24,
        7
      ],
      [
        19,
        32,
        33,
        34,
        25,
        8
      ],
      [
        18,
        31,
        36,
        35,
        26,
        9
      ],
      [
        17,
        30,
        29,
        28,
        27,
        10
      ],
      [
        16,
        15,
        14,
        13,
        12,
        11
      ]
    ]
  },
  {
    "args": [
      7
    ],
    "expected": [
      [
        1,
        2,
        3,
        4,
        5,
        6,
        7
      ],
      [
        24,
        25,
        26,
        27,
        28,
        29,
        8
      ],
      [
        23,
        40,
        41,
        42,
        43,
        30,
        9
      ],
      [
        22,
        39,
        48,
        49,
        44,
        31,
        10
      ],
      [
        21,
        38,
        47,
        46,
        45,
        32,
        11
      ],
      [
        20,
        37,
        36,
        35,
        34,
        33,
        12
      ],
      [
        19,
        18,
        17,
        16,
        15,
        14,
        13
      ]
    ]
  },
  {
    "args": [
      8
    ],
    "expected": [
      [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8
      ],
      [
        28,
        29,
        30,
        31,
        32,
        33,
        34,
        9
      ],
      [
        27,
        48,
        49,
        50,
        51,
        52,
        35,
        10
      ],
      [
        26,
        47,
        60,
        61,
        62,
        53,
        36,
        11
      ],
      [
        25,
        46,
        59,
        64,
        63,
        54,
        37,
        12
      ],
      [
        24,
        45,
        58,
        57,
        56,
        55,
        38,
        13
      ],
      [
        23,
        44,
        43,
        42,
        41,
        40,
        39,
        14
      ],
      [
        22,
        21,
        20,
        19,
        18,
        17,
        16,
        15
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1248,
    '跳跃游戏',
    '给定一个非负整数数组 nums，最初位于第一个下标。每个元素表示在该位置可以跳跃的最大长度。
判断是否能够到达最后一个下标。

提示：
- 1 <= nums.length <= 10^4
- 0 <= nums[i] <= 10^5',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心'],
    $json$[
  {
    "input": "nums = [2, 3, 1, 1, 4]",
    "output": "true"
  },
  {
    "input": "nums = [3, 2, 1, 0, 4]",
    "output": "false"
  },
  {
    "input": "nums = [0]",
    "output": "true"
  },
  {
    "input": "nums = [2, 0, 0]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 3, 1, 1, 4]",
    "output": "true"
  },
  {
    "input": "nums = [3, 2, 1, 0, 4]",
    "output": "false"
  },
  {
    "input": "nums = [0]",
    "output": "true"
  },
  {
    "input": "nums = [2, 0, 0]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canJump = function(nums) {\n};\n",
  "python": "class Solution:\n    def canJump(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canJump(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canJump(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canJump",
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
          3,
          1,
          1,
          4
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          3,
          2,
          1,
          0,
          4
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
    },
    {
      "args": [
        [
          2,
          0,
          0
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
        1
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        0,
        1
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        5,
        0,
        0,
        0,
        0
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        2,
        0,
        1,
        0,
        4
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
]$json$::jsonb,
    'approved'
),
(
    1249,
    '跳跃游戏 II',
    '给定一个长度为 n 的非负整数数组 nums，每个元素表示从该位置可以跳跃的最大长度。
假设总能到达最后一个下标，返回到达最后一个下标所需的最少跳跃次数。

提示：
- 1 <= nums.length <= 10^4
- 0 <= nums[i] <= 10^5',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心'],
    $json$[
  {
    "input": "nums = [2, 3, 1, 1, 4]",
    "output": "2"
  },
  {
    "input": "nums = [2, 3, 0, 1, 4]",
    "output": "2"
  },
  {
    "input": "nums = [1, 1, 1, 1]",
    "output": "3"
  },
  {
    "input": "nums = [0]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 3, 1, 1, 4]",
    "output": "2"
  },
  {
    "input": "nums = [2, 3, 0, 1, 4]",
    "output": "2"
  },
  {
    "input": "nums = [1, 1, 1, 1]",
    "output": "3"
  },
  {
    "input": "nums = [0]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minJumps = function(nums) {\n};\n",
  "python": "class Solution:\n    def minJumps(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minJumps(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minJumps(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minJumps",
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
          3,
          1,
          1,
          4
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          2,
          3,
          0,
          1,
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
      "expected": 3
    },
    {
      "args": [
        [
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
        2,
        0,
        2,
        0,
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        10,
        0,
        0,
        0,
        1
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1250,
    '不同路径 II',
    '一个机器人位于 m × n 网格的左上角，每次只能向下或向右移动一步。
网格中的障碍物用 1 表示，空位置用 0 表示。求到达右下角的不同路径数。

提示：
- 1 <= m, n <= 100
- grid[i][j] 为 0 或 1',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '矩阵'],
    $json$[
  {
    "input": "grid = [[0, 0, 0], [0, 1, 0], [0, 0, 0]]",
    "output": "2"
  },
  {
    "input": "grid = [[0, 1], [0, 0]]",
    "output": "1"
  },
  {
    "input": "grid = [[1]]",
    "output": "0"
  },
  {
    "input": "grid = [[0]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[0, 0, 0], [0, 1, 0], [0, 0, 0]]",
    "output": "2"
  },
  {
    "input": "grid = [[0, 1], [0, 0]]",
    "output": "1"
  },
  {
    "input": "grid = [[1]]",
    "output": "0"
  },
  {
    "input": "grid = [[0]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var uniquePathsWithObstacles = function(grid) {\n};\n",
  "python": "class Solution:\n    def uniquePathsWithObstacles(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int uniquePathsWithObstacles(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int uniquePathsWithObstacles(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "uniquePathsWithObstacles",
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
            0,
            0
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
      "expected": 2
    },
    {
      "args": [
        [
          [
            0,
            1
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
            0
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
          0,
          0
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
          0,
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
          0
        ],
        [
          0
        ],
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
          0
        ],
        [
          0,
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
          0,
          0
        ],
        [
          1,
          1
        ],
        [
          0,
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
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1251,
    '三角形最小路径和',
    '给定一个三角形数组 triangle，返回自顶向下的最小路径和。
每一步只能移动到下一行中相邻的节点。

提示：
- 1 <= triangle.length <= 200
- -10^4 <= triangle[i][j] <= 10^4',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "triangle = [[2], [3, 4], [6, 5, 7], [4, 1, 8, 3]]",
    "output": "11"
  },
  {
    "input": "triangle = [[-10]]",
    "output": "-10"
  },
  {
    "input": "triangle = [[1], [2, 3]]",
    "output": "3"
  },
  {
    "input": "triangle = [[1], [2, 3], [4, 5, 6]]",
    "output": "7"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "triangle = [[2], [3, 4], [6, 5, 7], [4, 1, 8, 3]]",
    "output": "11"
  },
  {
    "input": "triangle = [[-10]]",
    "output": "-10"
  },
  {
    "input": "triangle = [[1], [2, 3]]",
    "output": "3"
  },
  {
    "input": "triangle = [[1], [2, 3], [4, 5, 6]]",
    "output": "7"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minTrianglePath = function(triangle) {\n};\n",
  "python": "class Solution:\n    def minTrianglePath(self, triangle: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minTrianglePath(std::vector<std::vector<int>>& triangle) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minTrianglePath(int[][] triangle) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minTrianglePath",
  "params": [
    {
      "name": "triangle",
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
            2
          ],
          [
            3,
            4
          ],
          [
            6,
            5,
            7
          ],
          [
            4,
            1,
            8,
            3
          ]
        ]
      ],
      "expected": 11
    },
    {
      "args": [
        [
          [
            -10
          ]
        ]
      ],
      "expected": -10
    },
    {
      "args": [
        [
          [
            1
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
        [
          [
            1
          ],
          [
            2,
            3
          ],
          [
            4,
            5,
            6
          ]
        ]
      ],
      "expected": 7
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
          2,
          3
        ],
        [
          1,
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
          -1
        ],
        [
          -2,
          -3
        ]
      ]
    ],
    "expected": -4
  },
  {
    "args": [
      [
        [
          3
        ],
        [
          4,
          5
        ],
        [
          1,
          2,
          3
        ]
      ]
    ],
    "expected": 8
  },
  {
    "args": [
      [
        [
          0
        ],
        [
          1,
          2
        ],
        [
          3,
          4,
          5
        ]
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1252,
    '分割回文串',
    '给定一个字符串 s，将 s 分割成若干回文子串，返回所有可能的分割方案。

提示：
- 1 <= s.length <= 16
- s 仅由小写英文字母组成',
    'medium',
    1000,
    256,
    ARRAY['字符串', '回溯'],
    $json$[
  {
    "input": "s = \"aab\"",
    "output": "[[\"a\", \"a\", \"b\"], [\"aa\", \"b\"]]"
  },
  {
    "input": "s = \"a\"",
    "output": "[[\"a\"]]"
  },
  {
    "input": "s = \"ab\"",
    "output": "[[\"a\", \"b\"]]"
  },
  {
    "input": "s = \"aabb\"",
    "output": "[[\"a\", \"a\", \"b\", \"b\"], [\"a\", \"a\", \"bb\"], [\"aa\", \"b\", \"b\"], [\"aa\", \"bb\"]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aab\"",
    "output": "[[\"a\", \"a\", \"b\"], [\"aa\", \"b\"]]"
  },
  {
    "input": "s = \"a\"",
    "output": "[[\"a\"]]"
  },
  {
    "input": "s = \"ab\"",
    "output": "[[\"a\", \"b\"]]"
  },
  {
    "input": "s = \"aabb\"",
    "output": "[[\"a\", \"a\", \"b\", \"b\"], [\"a\", \"a\", \"bb\"], [\"aa\", \"b\", \"b\"], [\"aa\", \"bb\"]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var partitionPalindrome = function(s) {\n};\n",
  "python": "class Solution:\n    def partitionPalindrome(self, s: str) -> list[list[str]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<std::string>> partitionPalindrome(std::string s) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[][] partitionPalindrome(String s) {\n        return new String[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "partitionPalindrome",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "string[][]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "aab"
      ],
      "expected": [
        [
          "a",
          "a",
          "b"
        ],
        [
          "aa",
          "b"
        ]
      ]
    },
    {
      "args": [
        "a"
      ],
      "expected": [
        [
          "a"
        ]
      ]
    },
    {
      "args": [
        "ab"
      ],
      "expected": [
        [
          "a",
          "b"
        ]
      ]
    },
    {
      "args": [
        "aabb"
      ],
      "expected": [
        [
          "a",
          "a",
          "b",
          "b"
        ],
        [
          "a",
          "a",
          "bb"
        ],
        [
          "aa",
          "b",
          "b"
        ],
        [
          "aa",
          "bb"
        ]
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "aa"
    ],
    "expected": [
      [
        "a",
        "a"
      ],
      [
        "aa"
      ]
    ]
  },
  {
    "args": [
      "aba"
    ],
    "expected": [
      [
        "a",
        "b",
        "a"
      ],
      [
        "aba"
      ]
    ]
  },
  {
    "args": [
      "abcba"
    ],
    "expected": [
      [
        "a",
        "b",
        "c",
        "b",
        "a"
      ],
      [
        "a",
        "bcb",
        "a"
      ],
      [
        "abcba"
      ]
    ]
  },
  {
    "args": [
      "abab"
    ],
    "expected": [
      [
        "a",
        "b",
        "a",
        "b"
      ],
      [
        "a",
        "bab"
      ],
      [
        "aba",
        "b"
      ]
    ]
  },
  {
    "args": [
      "aabc"
    ],
    "expected": [
      [
        "a",
        "a",
        "b",
        "c"
      ],
      [
        "aa",
        "b",
        "c"
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1253,
    '奇偶链表',
    '给定单链表的头节点 head，将所有奇数位置节点和偶数位置节点分别相连后拼接，返回重排后的链表。
节点位置从 1 开始计数。

提示：
- 0 <= head.length <= 10^4
- -1000 <= head[i] <= 1000',
    'medium',
    1000,
    256,
    ARRAY['链表'],
    $json$[
  {
    "input": "head = [1, 2, 3, 4, 5]",
    "output": "[1, 3, 5, 2, 4]"
  },
  {
    "input": "head = [2, 1, 3, 5, 6, 4, 7]",
    "output": "[2, 3, 6, 7, 1, 5, 4]"
  },
  {
    "input": "head = [1]",
    "output": "[1]"
  },
  {
    "input": "head = []",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 2, 3, 4, 5]",
    "output": "[1, 3, 5, 2, 4]"
  },
  {
    "input": "head = [2, 1, 3, 5, 6, 4, 7]",
    "output": "[2, 3, 6, 7, 1, 5, 4]"
  },
  {
    "input": "head = [1]",
    "output": "[1]"
  },
  {
    "input": "head = []",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar oddEvenList = function(head) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def oddEvenList(self, head: ListNode | None) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* oddEvenList(ListNode* head) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode oddEvenList(ListNode head) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "oddEvenList",
  "params": [
    {
      "name": "head",
      "type": "ListNode"
    }
  ],
  "return_type": "ListNode",
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
      "expected": [
        1,
        3,
        5,
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
          5,
          6,
          4,
          7
        ]
      ],
      "expected": [
        2,
        3,
        6,
        7,
        1,
        5,
        4
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
    },
    {
      "args": [
        []
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
        1,
        2,
        3
      ]
    ],
    "expected": [
      1,
      3,
      2
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
      1,
      3,
      2,
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
      5,
      3,
      1,
      4,
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
      ]
    ],
    "expected": [
      1,
      3,
      5,
      2,
      4,
      6
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1254,
    '两两交换链表中的节点',
    '给定一个链表，两两交换其中相邻的节点，并返回交换后链表的头节点。
不能只交换节点内部的值。

提示：
- 0 <= head.length <= 100
- 0 <= head[i] <= 100',
    'medium',
    1000,
    256,
    ARRAY['链表', '递归'],
    $json$[
  {
    "input": "head = [1, 2, 3, 4]",
    "output": "[2, 1, 4, 3]"
  },
  {
    "input": "head = [1]",
    "output": "[1]"
  },
  {
    "input": "head = []",
    "output": "[]"
  },
  {
    "input": "head = [1, 2, 3, 4, 5]",
    "output": "[2, 1, 4, 3, 5]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 2, 3, 4]",
    "output": "[2, 1, 4, 3]"
  },
  {
    "input": "head = [1]",
    "output": "[1]"
  },
  {
    "input": "head = []",
    "output": "[]"
  },
  {
    "input": "head = [1, 2, 3, 4, 5]",
    "output": "[2, 1, 4, 3, 5]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar swapPairs = function(head) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def swapPairs(self, head: ListNode | None) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* swapPairs(ListNode* head) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode swapPairs(ListNode head) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "swapPairs",
  "params": [
    {
      "name": "head",
      "type": "ListNode"
    }
  ],
  "return_type": "ListNode",
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
        2,
        1,
        4,
        3
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
    },
    {
      "args": [
        []
      ],
      "expected": []
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
        2,
        1,
        4,
        3,
        5
      ]
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
    "expected": [
      2,
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
    "expected": [
      2,
      1,
      3
    ]
  },
  {
    "args": [
      [
        5,
        6,
        7,
        8
      ]
    ],
    "expected": [
      6,
      5,
      8,
      7
    ]
  },
  {
    "args": [
      [
        0,
        1
      ]
    ],
    "expected": [
      1,
      0
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
      ]
    ],
    "expected": [
      2,
      1,
      4,
      3,
      6,
      5
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1255,
    '分隔链表',
    '给定一个链表和一个特定值 x，对链表进行分隔，使所有小于 x 的节点都在大于或等于 x 的节点之前。
保持每个分区内节点的相对顺序。

提示：
- 0 <= head.length <= 200
- -100 <= head[i], x <= 100',
    'medium',
    1000,
    256,
    ARRAY['链表', '双指针'],
    $json$[
  {
    "input": "head = [1, 4, 3, 2, 5, 2], x = 3",
    "output": "[1, 2, 2, 4, 3, 5]"
  },
  {
    "input": "head = [2, 1], x = 2",
    "output": "[1, 2]"
  },
  {
    "input": "head = [1], x = 0",
    "output": "[1]"
  },
  {
    "input": "head = [1, 2, 3], x = 4",
    "output": "[1, 2, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 4, 3, 2, 5, 2], x = 3",
    "output": "[1, 2, 2, 4, 3, 5]"
  },
  {
    "input": "head = [2, 1], x = 2",
    "output": "[1, 2]"
  },
  {
    "input": "head = [1], x = 0",
    "output": "[1]"
  },
  {
    "input": "head = [1, 2, 3], x = 4",
    "output": "[1, 2, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar partitionList = function(head, x) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def partitionList(self, head: ListNode | None, x: int) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* partitionList(ListNode* head, int x) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode partitionList(ListNode head, int x) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "partitionList",
  "params": [
    {
      "name": "head",
      "type": "ListNode"
    },
    {
      "name": "x",
      "type": "int"
    }
  ],
  "return_type": "ListNode",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          1,
          4,
          3,
          2,
          5,
          2
        ],
        3
      ],
      "expected": [
        1,
        2,
        2,
        4,
        3,
        5
      ]
    },
    {
      "args": [
        [
          2,
          1
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
          1
        ],
        0
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
        ],
        4
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
        3,
        1,
        2
      ],
      3
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
        2,
        3
      ],
      2
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
        2,
        3
      ],
      1
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
        5,
        4,
        3
      ],
      3
    ],
    "expected": [
      5,
      4,
      3
    ]
  },
  {
    "args": [
      [
        1,
        1,
        1
      ],
      1
    ],
    "expected": [
      1,
      1,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1256,
    '旋转链表',
    '给定一个链表头节点 head 和一个整数 k，将链表每个节点向右移动 k 个位置，返回旋转后的链表。

提示：
- 0 <= head.length <= 500
- -100 <= head[i] <= 100
- 0 <= k <= 2 * 10^9',
    'medium',
    1000,
    256,
    ARRAY['链表', '双指针'],
    $json$[
  {
    "input": "head = [1, 2, 3, 4, 5], k = 2",
    "output": "[4, 5, 1, 2, 3]"
  },
  {
    "input": "head = [0, 1, 2], k = 4",
    "output": "[2, 0, 1]"
  },
  {
    "input": "head = [], k = 1",
    "output": "[]"
  },
  {
    "input": "head = [1], k = 0",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 2, 3, 4, 5], k = 2",
    "output": "[4, 5, 1, 2, 3]"
  },
  {
    "input": "head = [0, 1, 2], k = 4",
    "output": "[2, 0, 1]"
  },
  {
    "input": "head = [], k = 1",
    "output": "[]"
  },
  {
    "input": "head = [1], k = 0",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar rotateRight = function(head, k) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def rotateRight(self, head: ListNode | None, k: int) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* rotateRight(ListNode* head, int k) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode rotateRight(ListNode head, int k) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "rotateRight",
  "params": [
    {
      "name": "head",
      "type": "ListNode"
    },
    {
      "name": "k",
      "type": "int"
    }
  ],
  "return_type": "ListNode",
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
        ],
        2
      ],
      "expected": [
        4,
        5,
        1,
        2,
        3
      ]
    },
    {
      "args": [
        [
          0,
          1,
          2
        ],
        4
      ],
      "expected": [
        2,
        0,
        1
      ]
    },
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
          1
        ],
        0
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
        1,
        2
      ],
      1
    ],
    "expected": [
      2,
      1
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3
      ],
      1
    ],
    "expected": [
      3,
      1,
      2
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3
      ],
      3
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
        2,
        3,
        4
      ],
      5
    ],
    "expected": [
      4,
      1,
      2,
      3
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
      ],
      7
    ],
    "expected": [
      2,
      1,
      5,
      4,
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1257,
    '二叉树的右视图',
    '给定一棵二叉树，想象自己站在树的右侧，按从顶部到底部的顺序返回能看到的节点值。

提示：
- 0 <= root.length <= 100
- -100 <= Node.val <= 100',
    'medium',
    1000,
    256,
    ARRAY['树', '广度优先搜索'],
    $json$[
  {
    "input": "root = [1, 2, 3, null, 5, null, 4]",
    "output": "[1, 3, 4]"
  },
  {
    "input": "root = [1, null, 3]",
    "output": "[1, 3]"
  },
  {
    "input": "root = [1, 2]",
    "output": "[1, 2]"
  },
  {
    "input": "root = []",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3, null, 5, null, 4]",
    "output": "[1, 3, 4]"
  },
  {
    "input": "root = [1, null, 3]",
    "output": "[1, 3]"
  },
  {
    "input": "root = [1, 2]",
    "output": "[1, 2]"
  },
  {
    "input": "root = []",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar rightSideView = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def rightSideView(self, root: TreeNode | None) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::vector<int> rightSideView(TreeNode* root) {\n        return {};\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int[] rightSideView(TreeNode root) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "rightSideView",
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
          2,
          3,
          null,
          5,
          null,
          4
        ]
      ],
      "expected": [
        1,
        3,
        4
      ]
    },
    {
      "args": [
        [
          1,
          null,
          3
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
          1,
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
        []
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
        4
      ]
    ],
    "expected": [
      1,
      3,
      4
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3,
        null,
        5
      ]
    ],
    "expected": [
      1,
      3,
      5
    ]
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
        2,
        3,
        4,
        5,
        6,
        7
      ]
    ],
    "expected": [
      1,
      3,
      7
    ]
  },
  {
    "args": [
      [
        5,
        4,
        6,
        3,
        null,
        7
      ]
    ],
    "expected": [
      5,
      6,
      7
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1258,
    '二叉树展开为链表',
    '给定一棵二叉树，将其展开为一个只有右子节点的单链表，展开顺序为前序遍历顺序。

提示：
- 0 <= root.length <= 1000
- -100 <= Node.val <= 100',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '链表'],
    $json$[
  {
    "input": "root = [1, 2, 5, 3, 4, null, 6]",
    "output": "[1, null, 2, null, 3, null, 4, null, 5, null, 6]"
  },
  {
    "input": "root = []",
    "output": "[]"
  },
  {
    "input": "root = [1, 2]",
    "output": "[1, null, 2]"
  },
  {
    "input": "root = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 5, 3, 4, null, 6]",
    "output": "[1, null, 2, null, 3, null, 4, null, 5, null, 6]"
  },
  {
    "input": "root = []",
    "output": "[]"
  },
  {
    "input": "root = [1, 2]",
    "output": "[1, null, 2]"
  },
  {
    "input": "root = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar flattenTree = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def flattenTree(self, root: TreeNode | None) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* flattenTree(TreeNode* root) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode flattenTree(TreeNode root) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "flattenTree",
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
          2,
          5,
          3,
          4,
          null,
          6
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
        5,
        null,
        6
      ]
    },
    {
      "args": [
        []
      ],
      "expected": []
    },
    {
      "args": [
        [
          1,
          2
        ]
      ],
      "expected": [
        1,
        null,
        2
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
        1,
        2,
        3
      ]
    ],
    "expected": [
      1,
      null,
      2,
      null,
      3
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
      1,
      null,
      2,
      null,
      4,
      null,
      3
    ]
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
    "expected": [
      1,
      null,
      2,
      null,
      3
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
      2,
      null,
      1,
      null,
      3
    ]
  },
  {
    "args": [
      [
        1,
        2,
        5,
        3,
        4,
        null,
        6
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
      5,
      null,
      6
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1259,
    '从前序与中序遍历序列构造二叉树',
    '给定一棵二叉树的前序遍历 preorder 和中序遍历 inorder，构造并返回这棵二叉树。
树中节点值互不相同。

提示：
- 1 <= preorder.length <= 100
- inorder.length == preorder.length',
    'medium',
    1000,
    256,
    ARRAY['树', '数组', '哈希表', '分治'],
    $json$[
  {
    "input": "preorder = [3, 9, 20, 15, 7], inorder = [9, 3, 15, 20, 7]",
    "output": "[3, 9, 20, null, null, 15, 7]"
  },
  {
    "input": "preorder = [-1], inorder = [-1]",
    "output": "[-1]"
  },
  {
    "input": "preorder = [1, 2], inorder = [2, 1]",
    "output": "[1, 2]"
  },
  {
    "input": "preorder = [1, 2, 3], inorder = [2, 1, 3]",
    "output": "[1, 2, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "preorder = [3, 9, 20, 15, 7], inorder = [9, 3, 15, 20, 7]",
    "output": "[3, 9, 20, null, null, 15, 7]"
  },
  {
    "input": "preorder = [-1], inorder = [-1]",
    "output": "[-1]"
  },
  {
    "input": "preorder = [1, 2], inorder = [2, 1]",
    "output": "[1, 2]"
  },
  {
    "input": "preorder = [1, 2, 3], inorder = [2, 1, 3]",
    "output": "[1, 2, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar buildTree = function(preorder, inorder) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def buildTree(self, preorder: list[int], inorder: list[int]) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* buildTree(std::vector<int>& preorder, std::vector<int>& inorder) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode buildTree(int[] preorder, int[] inorder) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "buildTree",
  "params": [
    {
      "name": "preorder",
      "type": "int[]"
    },
    {
      "name": "inorder",
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
          9,
          20,
          15,
          7
        ],
        [
          9,
          3,
          15,
          20,
          7
        ]
      ],
      "expected": [
        3,
        9,
        20,
        null,
        null,
        15,
        7
      ]
    },
    {
      "args": [
        [
          -1
        ],
        [
          -1
        ]
      ],
      "expected": [
        -1
      ]
    },
    {
      "args": [
        [
          1,
          2
        ],
        [
          2,
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
          1,
          2,
          3
        ],
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
        2,
        4,
        5,
        3
      ],
      [
        4,
        2,
        5,
        1,
        3
      ]
    ],
    "expected": [
      1,
      2,
      3,
      4,
      5
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
        1,
        2,
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
      1,
      null,
      2,
      null,
      3,
      null,
      4
    ]
  },
  {
    "args": [
      [
        5,
        3,
        2,
        4,
        7,
        6,
        8
      ],
      [
        2,
        3,
        4,
        5,
        6,
        7,
        8
      ]
    ],
    "expected": [
      5,
      3,
      7,
      2,
      4,
      6,
      8
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1260,
    '路径总和 II',
    '给定二叉树根节点 root 和一个整数目标和 targetSum，找出所有从根节点到叶子节点且节点值之和等于 targetSum 的路径。

提示：
- 0 <= root.length <= 5000
- -1000 <= Node.val, targetSum <= 1000',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '回溯'],
    $json$[
  {
    "input": "root = [5, 4, 8, 11, null, 13, 4, 7, 2, null, null, 5, 1], targetSum = 22",
    "output": "[[5, 4, 11, 2], [5, 8, 4, 5]]"
  },
  {
    "input": "root = [1, 2, 3], targetSum = 5",
    "output": "[]"
  },
  {
    "input": "root = [1, 2], targetSum = 0",
    "output": "[]"
  },
  {
    "input": "root = [], targetSum = 0",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [5, 4, 8, 11, null, 13, 4, 7, 2, null, null, 5, 1], targetSum = 22",
    "output": "[[5, 4, 11, 2], [5, 8, 4, 5]]"
  },
  {
    "input": "root = [1, 2, 3], targetSum = 5",
    "output": "[]"
  },
  {
    "input": "root = [1, 2], targetSum = 0",
    "output": "[]"
  },
  {
    "input": "root = [], targetSum = 0",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar pathSumII = function(root, targetSum) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def pathSumII(self, root: TreeNode | None, targetSum: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> pathSumII(TreeNode* root, int targetSum) {\n        return {};\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int[][] pathSumII(TreeNode root, int targetSum) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "pathSumII",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    },
    {
      "name": "targetSum",
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
          5,
          1
        ],
        22
      ],
      "expected": [
        [
          5,
          4,
          11,
          2
        ],
        [
          5,
          8,
          4,
          5
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
        5
      ],
      "expected": []
    },
    {
      "args": [
        [
          1,
          2
        ],
        0
      ],
      "expected": []
    },
    {
      "args": [
        [],
        0
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
        3
      ],
      4
    ],
    "expected": [
      [
        1,
        3
      ]
    ]
  },
  {
    "args": [
      [
        1
      ],
      1
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
        1,
        2,
        null,
        3
      ],
      4
    ],
    "expected": []
  },
  {
    "args": [
      [
        0,
        1,
        1
      ],
      1
    ],
    "expected": [
      [
        0,
        1
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
        -2,
        null,
        -3
      ],
      -5
    ],
    "expected": [
      [
        -2,
        -3
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1261,
    '根到叶数字之和',
    '给定一棵二叉树，每个节点存储 0-9 的数字。每条从根到叶子的路径都表示一个数字。
返回所有根到叶数字之和。

提示：
- 1 <= root.length <= 1000
- 0 <= Node.val <= 9',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [1, 2, 3]",
    "output": "25"
  },
  {
    "input": "root = [4, 9, 0, 5, 1]",
    "output": "1026"
  },
  {
    "input": "root = [1]",
    "output": "1"
  },
  {
    "input": "root = [0, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3]",
    "output": "25"
  },
  {
    "input": "root = [4, 9, 0, 5, 1]",
    "output": "1026"
  },
  {
    "input": "root = [1]",
    "output": "1"
  },
  {
    "input": "root = [0, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar sumRootToLeaf = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def sumRootToLeaf(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int sumRootToLeaf(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int sumRootToLeaf(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumRootToLeaf",
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
      "expected": 25
    },
    {
      "args": [
        [
          4,
          9,
          0,
          5,
          1
        ]
      ],
      "expected": 1026
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
          0,
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
        2
      ]
    ],
    "expected": 12
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
    "expected": 137
  },
  {
    "args": [
      [
        9,
        9,
        9
      ]
    ],
    "expected": 198
  },
  {
    "args": [
      [
        1,
        null,
        2
      ]
    ],
    "expected": 12
  },
  {
    "args": [
      [
        5,
        3,
        8,
        1,
        4
      ]
    ],
    "expected": 1123
  }
]$json$::jsonb,
    'approved'
),
(
    1262,
    '二叉树的最近公共祖先',
    '给定一棵二叉树和两个节点值 p、q，返回它们的最近公共祖先节点值。
树中所有节点值互不相同。

提示：
- 2 <= root.length <= 10^5
- p 和 q 均存在于树中',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [3, 5, 1, 6, 2, 0, 8, null, null, 7, 4], p = 5, q = 1",
    "output": "3"
  },
  {
    "input": "root = [3, 5, 1, 6, 2, 0, 8, null, null, 7, 4], p = 5, q = 4",
    "output": "5"
  },
  {
    "input": "root = [1, 2], p = 1, q = 2",
    "output": "1"
  },
  {
    "input": "root = [3, 1, 4, null, 2], p = 2, q = 4",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 5, 1, 6, 2, 0, 8, null, null, 7, 4], p = 5, q = 1",
    "output": "3"
  },
  {
    "input": "root = [3, 5, 1, 6, 2, 0, 8, null, null, 7, 4], p = 5, q = 4",
    "output": "5"
  },
  {
    "input": "root = [1, 2], p = 1, q = 2",
    "output": "1"
  },
  {
    "input": "root = [3, 1, 4, null, 2], p = 2, q = 4",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar lowestCommonAncestor = function(root, p, q) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def lowestCommonAncestor(self, root: TreeNode | None, p: int, q: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int lowestCommonAncestor(TreeNode* root, int p, int q) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int lowestCommonAncestor(TreeNode root, int p, int q) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "lowestCommonAncestor",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    },
    {
      "name": "p",
      "type": "int"
    },
    {
      "name": "q",
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
          5,
          1,
          6,
          2,
          0,
          8,
          null,
          null,
          7,
          4
        ],
        5,
        1
      ],
      "expected": 3
    },
    {
      "args": [
        [
          3,
          5,
          1,
          6,
          2,
          0,
          8,
          null,
          null,
          7,
          4
        ],
        5,
        4
      ],
      "expected": 5
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
      "expected": 1
    },
    {
      "args": [
        [
          3,
          1,
          4,
          null,
          2
        ],
        2,
        4
      ],
      "expected": 3
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
      2,
      3
    ],
    "expected": 1
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
        3,
        5
      ],
      3,
      5
    ],
    "expected": 4
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
    "expected": 2
  },
  {
    "args": [
      [
        5,
        4,
        6
      ],
      4,
      6
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1263,
    '二叉搜索树中的插入操作',
    '给定一棵二叉搜索树和要插入的值 val，将 val 插入树中并返回插入后的二叉搜索树。
如果树为空，新节点成为根节点。

提示：
- 0 <= root.length <= 10^4
- -10^8 <= Node.val, val <= 10^8',
    'medium',
    1000,
    256,
    ARRAY['树', '二叉搜索树'],
    $json$[
  {
    "input": "root = [4, 2, 7, 1, 3], val = 5",
    "output": "[4, 2, 7, 1, 3, 5]"
  },
  {
    "input": "root = [40, 20, 60, 10, 30, 50, 70], val = 25",
    "output": "[40, 20, 60, 10, 30, 50, 70, null, null, 25]"
  },
  {
    "input": "root = [], val = 5",
    "output": "[5]"
  },
  {
    "input": "root = [1], val = 2",
    "output": "[1, null, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [4, 2, 7, 1, 3], val = 5",
    "output": "[4, 2, 7, 1, 3, 5]"
  },
  {
    "input": "root = [40, 20, 60, 10, 30, 50, 70], val = 25",
    "output": "[40, 20, 60, 10, 30, 50, 70, null, null, 25]"
  },
  {
    "input": "root = [], val = 5",
    "output": "[5]"
  },
  {
    "input": "root = [1], val = 2",
    "output": "[1, null, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar insertIntoBST = function(root, val) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def insertIntoBST(self, root: TreeNode | None, val: int) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* insertIntoBST(TreeNode* root, int val) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode insertIntoBST(TreeNode root, int val) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "insertIntoBST",
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
        5
      ],
      "expected": [
        4,
        2,
        7,
        1,
        3,
        5
      ]
    },
    {
      "args": [
        [
          40,
          20,
          60,
          10,
          30,
          50,
          70
        ],
        25
      ],
      "expected": [
        40,
        20,
        60,
        10,
        30,
        50,
        70,
        null,
        null,
        25
      ]
    },
    {
      "args": [
        [],
        5
      ],
      "expected": [
        5
      ]
    },
    {
      "args": [
        [
          1
        ],
        2
      ],
      "expected": [
        1,
        null,
        2
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
      ],
      4
    ],
    "expected": [
      2,
      1,
      3,
      null,
      null,
      null,
      4
    ]
  },
  {
    "args": [
      [
        5,
        3,
        8
      ],
      0
    ],
    "expected": [
      5,
      3,
      8,
      0
    ]
  },
  {
    "args": [
      [
        5,
        3,
        8
      ],
      6
    ],
    "expected": [
      5,
      3,
      8,
      null,
      null,
      6
    ]
  },
  {
    "args": [
      [
        1,
        2,
        3
      ],
      0
    ],
    "expected": [
      1,
      2,
      3,
      0
    ]
  },
  {
    "args": [
      [
        10,
        5,
        15
      ],
      12
    ],
    "expected": [
      10,
      5,
      15,
      null,
      null,
      12
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1264,
    '删除二叉搜索树中的节点',
    '给定一棵二叉搜索树的根节点和一个 key，删除树中值为 key 的节点并返回新的根节点。
若存在多个可用的替换节点，使用中序后继。

提示：
- 0 <= root.length <= 10^4
- -10^8 <= Node.val, key <= 10^8',
    'medium',
    1000,
    256,
    ARRAY['树', '二叉搜索树'],
    $json$[
  {
    "input": "root = [5, 3, 6, 2, 4, null, 7], key = 3",
    "output": "[5, 4, 6, 2, null, null, 7]"
  },
  {
    "input": "root = [5, 3, 6, 2, 4, null, 7], key = 0",
    "output": "[5, 3, 6, 2, 4, null, 7]"
  },
  {
    "input": "root = [], key = 0",
    "output": "[]"
  },
  {
    "input": "root = [0], key = 0",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [5, 3, 6, 2, 4, null, 7], key = 3",
    "output": "[5, 4, 6, 2, null, null, 7]"
  },
  {
    "input": "root = [5, 3, 6, 2, 4, null, 7], key = 0",
    "output": "[5, 3, 6, 2, 4, null, 7]"
  },
  {
    "input": "root = [], key = 0",
    "output": "[]"
  },
  {
    "input": "root = [0], key = 0",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar deleteNode = function(root, key) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def deleteNode(self, root: TreeNode | None, key: int) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* deleteNode(TreeNode* root, int key) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode deleteNode(TreeNode root, int key) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "deleteNode",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    },
    {
      "name": "key",
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
          5,
          3,
          6,
          2,
          4,
          null,
          7
        ],
        3
      ],
      "expected": [
        5,
        4,
        6,
        2,
        null,
        null,
        7
      ]
    },
    {
      "args": [
        [
          5,
          3,
          6,
          2,
          4,
          null,
          7
        ],
        0
      ],
      "expected": [
        5,
        3,
        6,
        2,
        4,
        null,
        7
      ]
    },
    {
      "args": [
        [],
        0
      ],
      "expected": []
    },
    {
      "args": [
        [
          0
        ],
        0
      ],
      "expected": []
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        5,
        3,
        6,
        2,
        4,
        null,
        7
      ],
      5
    ],
    "expected": [
      6,
      3,
      7,
      2,
      4
    ]
  },
  {
    "args": [
      [
        1,
        null,
        2
      ],
      1
    ],
    "expected": [
      2
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
      ],
      2
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
        2,
        1
      ],
      1
    ],
    "expected": [
      2
    ]
  },
  {
    "args": [
      [
        5,
        4,
        6
      ],
      6
    ],
    "expected": [
      5,
      4
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1265,
    '岛屿的最大面积',
    '给定一个由 0 和 1 组成的二维网格 grid，1 表示陆地，0 表示水域。
岛屿由上下左右相邻的陆地连接而成；如果不存在岛屿，返回 0。求所有岛屿中的最大面积。

提示：
- 1 <= m, n <= 300
- grid[i][j] 为 0 或 1',
    'medium',
    1000,
    256,
    ARRAY['数组', '广度优先搜索', '深度优先搜索'],
    $json$[
  {
    "input": "grid = [[1, 1, 1, 1, 0], [1, 1, 0, 1, 0], [1, 1, 0, 0, 0], [0, 0, 0, 0, 0]]",
    "output": "9"
  },
  {
    "input": "grid = [[1, 1, 0, 0, 0], [1, 1, 0, 0, 0], [0, 0, 1, 0, 0], [0, 0, 0, 1, 1]]",
    "output": "4"
  },
  {
    "input": "grid = [[1]]",
    "output": "1"
  },
  {
    "input": "grid = [[0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[1, 1, 1, 1, 0], [1, 1, 0, 1, 0], [1, 1, 0, 0, 0], [0, 0, 0, 0, 0]]",
    "output": "9"
  },
  {
    "input": "grid = [[1, 1, 0, 0, 0], [1, 1, 0, 0, 0], [0, 0, 1, 0, 0], [0, 0, 0, 1, 1]]",
    "output": "4"
  },
  {
    "input": "grid = [[1]]",
    "output": "1"
  },
  {
    "input": "grid = [[0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxAreaOfIsland = function(grid) {\n};\n",
  "python": "class Solution:\n    def maxAreaOfIsland(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxAreaOfIsland(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxAreaOfIsland(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxAreaOfIsland",
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
            1,
            0
          ],
          [
            1,
            1,
            0,
            1,
            0
          ],
          [
            1,
            1,
            0,
            0,
            0
          ],
          [
            0,
            0,
            0,
            0,
            0
          ]
        ]
      ],
      "expected": 9
    },
    {
      "args": [
        [
          [
            1,
            1,
            0,
            0,
            0
          ],
          [
            1,
            1,
            0,
            0,
            0
          ],
          [
            0,
            0,
            1,
            0,
            0
          ],
          [
            0,
            0,
            0,
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
  },
  {
    "args": [
      [
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
  },
  {
    "args": [
      [
        [
          1,
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
          1
        ],
        [
          0
        ],
        [
          1
        ]
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1266,
    '被围绕的区域',
    '给定一个 m × n 的字符矩阵 board，由 ''X'' 和 ''O'' 组成。将被 ''X'' 完全围绕的 ''O'' 替换为 ''X''。
边界上的 ''O'' 及其连通的 ''O'' 不应被替换。返回处理后的矩阵。

提示：
- 1 <= m, n <= 200
- board[i][j] 为 ''X'' 或 ''O''',
    'medium',
    1000,
    256,
    ARRAY['数组', '深度优先搜索', '矩阵'],
    $json$[
  {
    "input": "board = [[\"X\", \"X\", \"X\", \"X\"], [\"X\", \"O\", \"O\", \"X\"], [\"X\", \"X\", \"O\", \"X\"], [\"X\", \"O\", \"X\", \"X\"]]",
    "output": "[[\"X\", \"X\", \"X\", \"X\"], [\"X\", \"X\", \"X\", \"X\"], [\"X\", \"X\", \"X\", \"X\"], [\"X\", \"O\", \"X\", \"X\"]]"
  },
  {
    "input": "board = [[\"X\"]]",
    "output": "[[\"X\"]]"
  },
  {
    "input": "board = [[\"O\"]]",
    "output": "[[\"O\"]]"
  },
  {
    "input": "board = [[\"X\", \"O\"], [\"O\", \"X\"]]",
    "output": "[[\"X\", \"O\"], [\"O\", \"X\"]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "board = [[\"X\", \"X\", \"X\", \"X\"], [\"X\", \"O\", \"O\", \"X\"], [\"X\", \"X\", \"O\", \"X\"], [\"X\", \"O\", \"X\", \"X\"]]",
    "output": "[[\"X\", \"X\", \"X\", \"X\"], [\"X\", \"X\", \"X\", \"X\"], [\"X\", \"X\", \"X\", \"X\"], [\"X\", \"O\", \"X\", \"X\"]]"
  },
  {
    "input": "board = [[\"X\"]]",
    "output": "[[\"X\"]]"
  },
  {
    "input": "board = [[\"O\"]]",
    "output": "[[\"O\"]]"
  },
  {
    "input": "board = [[\"X\", \"O\"], [\"O\", \"X\"]]",
    "output": "[[\"X\", \"O\"], [\"O\", \"X\"]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var surroundedRegions = function(board) {\n};\n",
  "python": "class Solution:\n    def surroundedRegions(self, board: list[list[str]]) -> list[list[str]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<std::string>> surroundedRegions(std::vector<std::vector<std::string>>& board) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[][] surroundedRegions(String[][] board) {\n        return new String[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "surroundedRegions",
  "params": [
    {
      "name": "board",
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
            "X",
            "X",
            "X",
            "X"
          ],
          [
            "X",
            "O",
            "O",
            "X"
          ],
          [
            "X",
            "X",
            "O",
            "X"
          ],
          [
            "X",
            "O",
            "X",
            "X"
          ]
        ]
      ],
      "expected": [
        [
          "X",
          "X",
          "X",
          "X"
        ],
        [
          "X",
          "X",
          "X",
          "X"
        ],
        [
          "X",
          "X",
          "X",
          "X"
        ],
        [
          "X",
          "O",
          "X",
          "X"
        ]
      ]
    },
    {
      "args": [
        [
          [
            "X"
          ]
        ]
      ],
      "expected": [
        [
          "X"
        ]
      ]
    },
    {
      "args": [
        [
          [
            "O"
          ]
        ]
      ],
      "expected": [
        [
          "O"
        ]
      ]
    },
    {
      "args": [
        [
          [
            "X",
            "O"
          ],
          [
            "O",
            "X"
          ]
        ]
      ],
      "expected": [
        [
          "X",
          "O"
        ],
        [
          "O",
          "X"
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
          "O",
          "O",
          "O"
        ],
        [
          "O",
          "O",
          "O"
        ],
        [
          "O",
          "O",
          "O"
        ]
      ]
    ],
    "expected": [
      [
        "O",
        "O",
        "O"
      ],
      [
        "O",
        "O",
        "O"
      ],
      [
        "O",
        "O",
        "O"
      ]
    ]
  },
  {
    "args": [
      [
        [
          "X",
          "X"
        ],
        [
          "X",
          "O"
        ]
      ]
    ],
    "expected": [
      [
        "X",
        "X"
      ],
      [
        "X",
        "O"
      ]
    ]
  },
  {
    "args": [
      [
        [
          "O",
          "X"
        ],
        [
          "X",
          "O"
        ]
      ]
    ],
    "expected": [
      [
        "O",
        "X"
      ],
      [
        "X",
        "O"
      ]
    ]
  },
  {
    "args": [
      [
        [
          "X",
          "X",
          "X"
        ],
        [
          "X",
          "O",
          "X"
        ],
        [
          "X",
          "X",
          "X"
        ]
      ]
    ],
    "expected": [
      [
        "X",
        "X",
        "X"
      ],
      [
        "X",
        "X",
        "X"
      ],
      [
        "X",
        "X",
        "X"
      ]
    ]
  },
  {
    "args": [
      [
        [
          "X",
          "O",
          "X"
        ],
        [
          "O",
          "O",
          "O"
        ],
        [
          "X",
          "O",
          "X"
        ]
      ]
    ],
    "expected": [
      [
        "X",
        "O",
        "X"
      ],
      [
        "O",
        "O",
        "O"
      ],
      [
        "X",
        "O",
        "X"
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1267,
    '课程表 II',
    '给定课程总数 numCourses 和先修课程列表 prerequisites，返回学习所有课程的一种顺序。
prerequisites[i] = [a, b] 表示学习课程 a 前必须先完成课程 b。如果不可能完成，返回空数组。

提示：
- 1 <= numCourses <= 2000
- 0 <= prerequisites.length <= numCourses * (numCourses - 1)',
    'medium',
    1000,
    256,
    ARRAY['图', '拓扑排序', '广度优先搜索'],
    $json$[
  {
    "input": "numCourses = 2, prerequisites = [[1, 0]]",
    "output": "[0, 1]"
  },
  {
    "input": "numCourses = 4, prerequisites = [[1, 0], [2, 0], [3, 1], [3, 2]]",
    "output": "[0, 1, 2, 3]"
  },
  {
    "input": "numCourses = 1, prerequisites = []",
    "output": "[0]"
  },
  {
    "input": "numCourses = 2, prerequisites = [[0, 1], [1, 0]]",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "numCourses = 2, prerequisites = [[1, 0]]",
    "output": "[0, 1]"
  },
  {
    "input": "numCourses = 4, prerequisites = [[1, 0], [2, 0], [3, 1], [3, 2]]",
    "output": "[0, 1, 2, 3]"
  },
  {
    "input": "numCourses = 1, prerequisites = []",
    "output": "[0]"
  },
  {
    "input": "numCourses = 2, prerequisites = [[0, 1], [1, 0]]",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var courseScheduleII = function(numCourses, prerequisites) {\n};\n",
  "python": "class Solution:\n    def courseScheduleII(self, numCourses: int, prerequisites: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> courseScheduleII(int numCourses, std::vector<std::vector<int>>& prerequisites) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] courseScheduleII(int numCourses, int[][] prerequisites) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "courseScheduleII",
  "params": [
    {
      "name": "numCourses",
      "type": "int"
    },
    {
      "name": "prerequisites",
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
        2,
        [
          [
            1,
            0
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
          ],
          [
            1,
            0
          ]
        ]
      ],
      "expected": []
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
          0
        ],
        [
          2,
          1
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
      2,
      1,
      0
    ]
  },
  {
    "args": [
      4,
      [
        [
          2,
          0
        ],
        [
          3,
          1
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
      5,
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
          4,
          2
        ]
      ]
    ],
    "expected": [
      0,
      1,
      2,
      3,
      4
    ]
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
          1
        ],
        [
          0,
          2
        ]
      ]
    ],
    "expected": []
  }
]$json$::jsonb,
    'approved'
),
(
    1268,
    '打家劫舍 III',
    '房屋形成一棵二叉树，每个节点的值表示该房屋的金额。
如果两个直接相连的房屋在同一晚上被偷，系统会自动报警。返回不触动警报的情况下能偷到的最高金额。

提示：
- 1 <= root.length <= 10^4
- 0 <= Node.val <= 10^4',
    'medium',
    1000,
    256,
    ARRAY['树', '动态规划', '深度优先搜索'],
    $json$[
  {
    "input": "root = [3, 2, 3, null, 3, null, 1]",
    "output": "7"
  },
  {
    "input": "root = [3, 4, 5, 1, 3, null, 1]",
    "output": "9"
  },
  {
    "input": "root = [1]",
    "output": "1"
  },
  {
    "input": "root = [5, 1, 7]",
    "output": "8"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 2, 3, null, 3, null, 1]",
    "output": "7"
  },
  {
    "input": "root = [3, 4, 5, 1, 3, null, 1]",
    "output": "9"
  },
  {
    "input": "root = [1]",
    "output": "1"
  },
  {
    "input": "root = [5, 1, 7]",
    "output": "8"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar robTree = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def robTree(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int robTree(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int robTree(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "robTree",
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
          2,
          3,
          null,
          3,
          null,
          1
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        [
          3,
          4,
          5,
          1,
          3,
          null,
          1
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
      "expected": 1
    },
    {
      "args": [
        [
          5,
          1,
          7
        ]
      ],
      "expected": 8
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
    "expected": 4
  },
  {
    "args": [
      [
        4,
        1,
        null,
        2,
        null,
        3
      ]
    ],
    "expected": 7
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
        6,
        4,
        5,
        1,
        3
      ]
    ],
    "expected": 10
  },
  {
    "args": [
      [
        10,
        5,
        15,
        2,
        7
      ]
    ],
    "expected": 24
  }
]$json$::jsonb,
    'approved'
),
(
    1269,
    '零钱兑换 II',
    '给定不同面额的硬币 coins 和一个总金额 amount，返回可以凑成总金额的硬币组合数。
假设每种面额的硬币有无限个。

提示：
- 1 <= coins.length <= 300
- 1 <= coins[i] <= 5000
- 0 <= amount <= 5000',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "amount = 5, coins = [1, 2, 5]",
    "output": "4"
  },
  {
    "input": "amount = 3, coins = [2]",
    "output": "0"
  },
  {
    "input": "amount = 10, coins = [10]",
    "output": "1"
  },
  {
    "input": "amount = 0, coins = [7]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "amount = 5, coins = [1, 2, 5]",
    "output": "4"
  },
  {
    "input": "amount = 3, coins = [2]",
    "output": "0"
  },
  {
    "input": "amount = 10, coins = [10]",
    "output": "1"
  },
  {
    "input": "amount = 0, coins = [7]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var coinChangeII = function(amount, coins) {\n};\n",
  "python": "class Solution:\n    def coinChangeII(self, amount: int, coins: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int coinChangeII(int amount, std::vector<int>& coins) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int coinChangeII(int amount, int[] coins) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "coinChangeII",
  "params": [
    {
      "name": "amount",
      "type": "int"
    },
    {
      "name": "coins",
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
        5,
        [
          1,
          2,
          5
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        3,
        [
          2
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        10,
        [
          10
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        0,
        [
          7
        ]
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      4,
      [
        1,
        2
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      5,
      [
        1,
        5,
        10
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      7,
      [
        2,
        3,
        5
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      11,
      [
        1,
        2,
        5
      ]
    ],
    "expected": 11
  },
  {
    "args": [
      8,
      [
        3,
        5
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1270,
    '环形子数组的最大和',
    '给定一个整数数组 nums，把它首尾相连看作环形数组，返回非空连续子数组的最大和。
子数组在环形数组中最多绕一圈，不能重复选取同一段。

提示：
- 1 <= nums.length <= 10^5
- -10^4 <= nums[i] <= 10^4',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '队列'],
    $json$[
  {
    "input": "nums = [1, -2, 3, -2]",
    "output": "3"
  },
  {
    "input": "nums = [5, -3, 5]",
    "output": "10"
  },
  {
    "input": "nums = [-3, -2, -3]",
    "output": "-2"
  },
  {
    "input": "nums = [2, -1, 2]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, -2, 3, -2]",
    "output": "3"
  },
  {
    "input": "nums = [5, -3, 5]",
    "output": "10"
  },
  {
    "input": "nums = [-3, -2, -3]",
    "output": "-2"
  },
  {
    "input": "nums = [2, -1, 2]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxSubarraySumCircular = function(nums) {\n};\n",
  "python": "class Solution:\n    def maxSubarraySumCircular(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxSubarraySumCircular(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxSubarraySumCircular(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxSubarraySumCircular",
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
          -2,
          3,
          -2
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          5,
          -3,
          5
        ]
      ],
      "expected": 10
    },
    {
      "args": [
        [
          -3,
          -2,
          -3
        ]
      ],
      "expected": -2
    },
    {
      "args": [
        [
          2,
          -1,
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
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        -1
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        3,
        -1,
        2,
        -1
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        -2,
        4,
        -5,
        1
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        8,
        -19,
        5,
        -4,
        20
      ]
    ],
    "expected": 29
  },
  {
    "args": [
      [
        -5,
        -2,
        -3
      ]
    ],
    "expected": -2
  }
]$json$::jsonb,
    'approved'
),
(
    1271,
    '颜色分类',
    '给定一个包含红色、白色和蓝色对象的数组 nums，原地排序使相同颜色相邻，并按红、白、蓝顺序排列。
红色、白色、蓝色分别用 0、1、2 表示。返回排序后的数组。

提示：
- 1 <= nums.length <= 300
- nums[i] 为 0、1 或 2',
    'medium',
    1000,
    256,
    ARRAY['数组', '双指针', '排序'],
    $json$[
  {
    "input": "nums = [2, 0, 2, 1, 1, 0]",
    "output": "[0, 0, 1, 1, 2, 2]"
  },
  {
    "input": "nums = [2, 0, 1]",
    "output": "[0, 1, 2]"
  },
  {
    "input": "nums = [0]",
    "output": "[0]"
  },
  {
    "input": "nums = [1, 2, 0]",
    "output": "[0, 1, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 0, 2, 1, 1, 0]",
    "output": "[0, 0, 1, 1, 2, 2]"
  },
  {
    "input": "nums = [2, 0, 1]",
    "output": "[0, 1, 2]"
  },
  {
    "input": "nums = [0]",
    "output": "[0]"
  },
  {
    "input": "nums = [1, 2, 0]",
    "output": "[0, 1, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sortColors = function(nums) {\n};\n",
  "python": "class Solution:\n    def sortColors(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> sortColors(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] sortColors(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sortColors",
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
          2,
          0,
          2,
          1,
          1,
          0
        ]
      ],
      "expected": [
        0,
        0,
        1,
        1,
        2,
        2
      ]
    },
    {
      "args": [
        [
          2,
          0,
          1
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
          2,
          0
        ]
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
        2,
        2,
        1,
        0
      ]
    ],
    "expected": [
      0,
      1,
      2,
      2
    ]
  },
  {
    "args": [
      [
        1,
        0,
        0,
        1
      ]
    ],
    "expected": [
      0,
      0,
      1,
      1
    ]
  },
  {
    "args": [
      [
        2,
        1,
        0
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
        0,
        0,
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
        2,
        2,
        2
      ]
    ],
    "expected": [
      2,
      2,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1272,
    '搜索二维矩阵 II',
    '给定一个 m × n 矩阵 matrix，其每行从左到右升序排列，每列从上到下升序排列。
判断 target 是否存在于矩阵中。

提示：
- 1 <= m, n <= 300
- -10^9 <= matrix[i][j], target <= 10^9',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找', '矩阵'],
    $json$[
  {
    "input": "matrix = [[1, 4, 7, 11, 15], [2, 5, 8, 12, 19], [3, 6, 9, 16, 22], [10, 13, 14, 17, 24], [18, 21, 23, 26, 30]], target = 5",
    "output": "true"
  },
  {
    "input": "matrix = [[1, 4, 7, 11, 15], [2, 5, 8, 12, 19], [3, 6, 9, 16, 22], [10, 13, 14, 17, 24], [18, 21, 23, 26, 30]], target = 20",
    "output": "false"
  },
  {
    "input": "matrix = [[1]], target = 1",
    "output": "true"
  },
  {
    "input": "matrix = [[1]], target = 0",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 4, 7, 11, 15], [2, 5, 8, 12, 19], [3, 6, 9, 16, 22], [10, 13, 14, 17, 24], [18, 21, 23, 26, 30]], target = 5",
    "output": "true"
  },
  {
    "input": "matrix = [[1, 4, 7, 11, 15], [2, 5, 8, 12, 19], [3, 6, 9, 16, 22], [10, 13, 14, 17, 24], [18, 21, 23, 26, 30]], target = 20",
    "output": "false"
  },
  {
    "input": "matrix = [[1]], target = 1",
    "output": "true"
  },
  {
    "input": "matrix = [[1]], target = 0",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var searchMatrixII = function(matrix, target) {\n};\n",
  "python": "class Solution:\n    def searchMatrixII(self, matrix: list[list[int]], target: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool searchMatrixII(std::vector<std::vector<int>>& matrix, int target) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean searchMatrixII(int[][] matrix, int target) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "searchMatrixII",
  "params": [
    {
      "name": "matrix",
      "type": "int[][]"
    },
    {
      "name": "target",
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
          [
            1,
            4,
            7,
            11,
            15
          ],
          [
            2,
            5,
            8,
            12,
            19
          ],
          [
            3,
            6,
            9,
            16,
            22
          ],
          [
            10,
            13,
            14,
            17,
            24
          ],
          [
            18,
            21,
            23,
            26,
            30
          ]
        ],
        5
      ],
      "expected": true
    },
    {
      "args": [
        [
          [
            1,
            4,
            7,
            11,
            15
          ],
          [
            2,
            5,
            8,
            12,
            19
          ],
          [
            3,
            6,
            9,
            16,
            22
          ],
          [
            10,
            13,
            14,
            17,
            24
          ],
          [
            18,
            21,
            23,
            26,
            30
          ]
        ],
        20
      ],
      "expected": false
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
      "expected": true
    },
    {
      "args": [
        [
          [
            1
          ]
        ],
        0
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
          1,
          2
        ],
        [
          3,
          4
        ]
      ],
      3
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
      5
    ],
    "expected": false
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
        ]
      ],
      6
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          1,
          3,
          5
        ],
        [
          2,
          4,
          6
        ]
      ],
      2
    ],
    "expected": true
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
        ]
      ],
      7
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1273,
    '寻找峰值',
    '峰值元素是指其值严格大于左右相邻值的元素。给定一个整数数组 nums，找到任意一个峰值并返回其下标。
可以假设 nums[-1] = nums[n] = -∞，且数组中相邻元素不相等。

提示：
- 1 <= nums.length <= 1000
- -2^31 <= nums[i] <= 2^31 - 1',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 1]",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 1, 3, 5, 6, 4]",
    "output": "5"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  },
  {
    "input": "nums = [2, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 1]",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 1, 3, 5, 6, 4]",
    "output": "5"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  },
  {
    "input": "nums = [2, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findPeakElement = function(nums) {\n};\n",
  "python": "class Solution:\n    def findPeakElement(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findPeakElement(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findPeakElement(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findPeakElement",
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
          1,
          3,
          5,
          6,
          4
        ]
      ],
      "expected": 5
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
    "expected": 0
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
    "expected": 3
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
  }
]$json$::jsonb,
    'approved'
),
(
    1274,
    '寻找重复数',
    '给定一个包含 n + 1 个整数的数组 nums，数字都在 [1, n] 范围内，且至少有一个重复整数。
假设只有一个整数重复多次，返回这个重复数。

提示：
- 1 <= n <= 10^5
- nums.length == n + 1',
    'medium',
    1000,
    256,
    ARRAY['数组', '双指针', '二分查找'],
    $json$[
  {
    "input": "nums = [1, 3, 4, 2, 2]",
    "output": "2"
  },
  {
    "input": "nums = [3, 1, 3, 4, 2]",
    "output": "3"
  },
  {
    "input": "nums = [1, 1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 2]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3, 4, 2, 2]",
    "output": "2"
  },
  {
    "input": "nums = [3, 1, 3, 4, 2]",
    "output": "3"
  },
  {
    "input": "nums = [1, 1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 2]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findDuplicate = function(nums) {\n};\n",
  "python": "class Solution:\n    def findDuplicate(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findDuplicate(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findDuplicate(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findDuplicate",
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
          4,
          2,
          2
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          3,
          1,
          3,
          4,
          2
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
    },
    {
      "args": [
        [
          1,
          2,
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
        2,
        2,
        2,
        2,
        2
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        4,
        3,
        4,
        1,
        2
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        1,
        4,
        4,
        2,
        4
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        3,
        3,
        3,
        3,
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
        1,
        5
      ]
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1275,
    '数组中的第 K 个最大元素',
    '给定一个整数数组 nums 和整数 k，返回数组中第 k 个最大的元素。
注意是排序后的第 k 个最大元素，不是第 k 个不同的元素。

提示：
- 1 <= k <= nums.length <= 10^5
- -10^4 <= nums[i] <= 10^4',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '堆'],
    $json$[
  {
    "input": "nums = [3, 2, 1, 5, 6, 4], k = 2",
    "output": "5"
  },
  {
    "input": "nums = [3, 2, 3, 1, 2, 4, 5, 5, 6], k = 4",
    "output": "4"
  },
  {
    "input": "nums = [1], k = 1",
    "output": "1"
  },
  {
    "input": "nums = [2, 1], k = 1",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 2, 1, 5, 6, 4], k = 2",
    "output": "5"
  },
  {
    "input": "nums = [3, 2, 3, 1, 2, 4, 5, 5, 6], k = 4",
    "output": "4"
  },
  {
    "input": "nums = [1], k = 1",
    "output": "1"
  },
  {
    "input": "nums = [2, 1], k = 1",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findKthLargest = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def findKthLargest(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findKthLargest(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findKthLargest(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findKthLargest",
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
          3,
          2,
          1,
          5,
          6,
          4
        ],
        2
      ],
      "expected": 5
    },
    {
      "args": [
        [
          3,
          2,
          3,
          1,
          2,
          4,
          5,
          5,
          6
        ],
        4
      ],
      "expected": 4
    },
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
          2,
          1
        ],
        1
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
        3
      ],
      3
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
      ],
      3
    ],
    "expected": 3
  },
  {
    "args": [
      [
        -1,
        -2,
        -3
      ],
      1
    ],
    "expected": -1
  },
  {
    "args": [
      [
        0,
        1,
        2
      ],
      2
    ],
    "expected": 1
  },
  {
    "args": [
      [
        7,
        7,
        7
      ],
      2
    ],
    "expected": 7
  }
]$json$::jsonb,
    'approved'
),
(
    1276,
    '前 K 个高频元素',
    '给定一个整数数组 nums 和一个整数 k，返回出现频率前 k 高的元素。
答案按频率降序排列，频率相同按元素值升序排列。

提示：
- 1 <= nums.length <= 10^5
- 1 <= k <= 不同元素数量',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表', '排序'],
    $json$[
  {
    "input": "nums = [1, 1, 1, 2, 2, 3], k = 2",
    "output": "[1, 2]"
  },
  {
    "input": "nums = [1], k = 1",
    "output": "[1]"
  },
  {
    "input": "nums = [1, 2], k = 2",
    "output": "[1, 2]"
  },
  {
    "input": "nums = [4, 4, 4, 3, 3, 2], k = 2",
    "output": "[4, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 1, 2, 2, 3], k = 2",
    "output": "[1, 2]"
  },
  {
    "input": "nums = [1], k = 1",
    "output": "[1]"
  },
  {
    "input": "nums = [1, 2], k = 2",
    "output": "[1, 2]"
  },
  {
    "input": "nums = [4, 4, 4, 3, 3, 2], k = 2",
    "output": "[4, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var topKFrequent = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def topKFrequent(self, nums: list[int], k: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> topKFrequent(std::vector<int>& nums, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] topKFrequent(int[] nums, int k) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "topKFrequent",
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
          1,
          1,
          2,
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
          1,
          2
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
          4,
          4,
          4,
          3,
          3,
          2
        ],
        2
      ],
      "expected": [
        4,
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
        2,
        3,
        1,
        2,
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
        5,
        5,
        4,
        4,
        3
      ],
      2
    ],
    "expected": [
      4,
      5
    ]
  },
  {
    "args": [
      [
        0,
        0,
        1,
        1,
        2
      ],
      3
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
        7,
        7,
        8,
        8,
        9
      ],
      2
    ],
    "expected": [
      7,
      8
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
      3
    ],
    "expected": [
      1,
      2,
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1277,
    '根据字符出现频率排序',
    '给定一个字符串 s，根据字符出现频率降序排列。频率相同的字符按 ASCII 码升序排列。

提示：
- 1 <= s.length <= 10^5
- s 由英文字母、数字和符号组成',
    'medium',
    1000,
    256,
    ARRAY['字符串', '哈希表', '排序'],
    $json$[
  {
    "input": "s = \"tree\"",
    "output": "\"eert\""
  },
  {
    "input": "s = \"cccaaa\"",
    "output": "\"aaaccc\""
  },
  {
    "input": "s = \"Aabb\"",
    "output": "\"bbAa\""
  },
  {
    "input": "s = \"loveleetcode\"",
    "output": "\"eeeelloocdtv\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"tree\"",
    "output": "\"eert\""
  },
  {
    "input": "s = \"cccaaa\"",
    "output": "\"aaaccc\""
  },
  {
    "input": "s = \"Aabb\"",
    "output": "\"bbAa\""
  },
  {
    "input": "s = \"loveleetcode\"",
    "output": "\"eeeelloocdtv\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var frequencySort = function(s) {\n};\n",
  "python": "class Solution:\n    def frequencySort(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string frequencySort(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String frequencySort(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "frequencySort",
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
        "tree"
      ],
      "expected": "eert"
    },
    {
      "args": [
        "cccaaa"
      ],
      "expected": "aaaccc"
    },
    {
      "args": [
        "Aabb"
      ],
      "expected": "bbAa"
    },
    {
      "args": [
        "loveleetcode"
      ],
      "expected": "eeeelloocdtv"
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
      "ab"
    ],
    "expected": "ab"
  },
  {
    "args": [
      "ba"
    ],
    "expected": "ab"
  },
  {
    "args": [
      "abcabc"
    ],
    "expected": "aabbcc"
  },
  {
    "args": [
      "zzzzzz"
    ],
    "expected": "zzzzzz"
  },
  {
    "args": [
      "aabbbcc"
    ],
    "expected": "bbbaacc"
  }
]$json$::jsonb,
    'approved'
),
(
    1278,
    '加油站',
    '一条环路上有 n 个加油站，第 i 个加油站有 gas[i] 升汽油，从第 i 个加油站到第 i+1 个加油站需要消耗 cost[i] 升。
给定 gas 和 cost，返回能绕环路行驶一周的出发加油站编号；如果不存在，返回 -1。

提示：
- 1 <= n <= 10^5
- 0 <= gas[i], cost[i] <= 10^4',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心'],
    $json$[
  {
    "input": "gas = [1, 2, 3, 4, 5], cost = [3, 4, 5, 1, 2]",
    "output": "3"
  },
  {
    "input": "gas = [2, 3, 4], cost = [3, 4, 3]",
    "output": "-1"
  },
  {
    "input": "gas = [5], cost = [4]",
    "output": "0"
  },
  {
    "input": "gas = [2], cost = [2]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "gas = [1, 2, 3, 4, 5], cost = [3, 4, 5, 1, 2]",
    "output": "3"
  },
  {
    "input": "gas = [2, 3, 4], cost = [3, 4, 3]",
    "output": "-1"
  },
  {
    "input": "gas = [5], cost = [4]",
    "output": "0"
  },
  {
    "input": "gas = [2], cost = [2]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canCompleteCircuit = function(gas, cost) {\n};\n",
  "python": "class Solution:\n    def canCompleteCircuit(self, gas: list[int], cost: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int canCompleteCircuit(std::vector<int>& gas, std::vector<int>& cost) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int canCompleteCircuit(int[] gas, int[] cost) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canCompleteCircuit",
  "params": [
    {
      "name": "gas",
      "type": "int[]"
    },
    {
      "name": "cost",
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
          4,
          5
        ],
        [
          3,
          4,
          5,
          1,
          2
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          2,
          3,
          4
        ],
        [
          3,
          4,
          3
        ]
      ],
      "expected": -1
    },
    {
      "args": [
        [
          5
        ],
        [
          4
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          2
        ],
        [
          2
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
        3,
        1,
        1
      ],
      [
        1,
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
        2,
        3
      ],
      [
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
        4,
        5,
        2,
        6,
        5
      ],
      [
        3,
        4,
        5,
        1,
        2
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        2
      ],
      [
        2,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        0,
        0
      ],
      [
        0,
        0
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1279,
    '分发糖果',
    'n 个孩子站成一排，每个孩子有一个评分。老师给每个孩子分发糖果，要求每个孩子至少得到 1 颗糖，相邻孩子中评分更高的必须得到更多糖果。
返回最少需要准备的糖果数。

提示：
- 1 <= ratings.length <= 10^5
- 0 <= ratings[i] <= 10^5',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心'],
    $json$[
  {
    "input": "ratings = [1, 0, 2]",
    "output": "5"
  },
  {
    "input": "ratings = [1, 2, 2]",
    "output": "4"
  },
  {
    "input": "ratings = [1]",
    "output": "1"
  },
  {
    "input": "ratings = [1, 2, 3]",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "ratings = [1, 0, 2]",
    "output": "5"
  },
  {
    "input": "ratings = [1, 2, 2]",
    "output": "4"
  },
  {
    "input": "ratings = [1]",
    "output": "1"
  },
  {
    "input": "ratings = [1, 2, 3]",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var candy = function(ratings) {\n};\n",
  "python": "class Solution:\n    def candy(self, ratings: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int candy(std::vector<int>& ratings) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int candy(int[] ratings) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "candy",
  "params": [
    {
      "name": "ratings",
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
          2
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        [
          1,
          2,
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
      "expected": 6
    }
  ]
}$json$::jsonb,
    $json$[
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
        2,
        1,
        2
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        1,
        3,
        2,
        2,
        1
      ]
    ],
    "expected": 7
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
    "expected": 15
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
    "expected": 15
  },
  {
    "args": [
      [
        0,
        0,
        0
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1280,
    'K 个逆序对数组',
    '给定整数 n 和 k，返回由 1 到 n 组成的排列中恰好含有 k 个逆序对的不同排列数量。
逆序对指满足 i < j 且 nums[i] > nums[j] 的一对下标。结果对 10^9 + 7 取模。

提示：
- 1 <= n <= 1000
- 0 <= k <= 1000',
    'hard',
    1000,
    256,
    ARRAY['动态规划', '滑动窗口', '前缀和'],
    $json$[
  {
    "input": "n = 3, k = 0",
    "output": "1"
  },
  {
    "input": "n = 3, k = 1",
    "output": "2"
  },
  {
    "input": "n = 3, k = 2",
    "output": "2"
  },
  {
    "input": "n = 4, k = 2",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, k = 0",
    "output": "1"
  },
  {
    "input": "n = 3, k = 1",
    "output": "2"
  },
  {
    "input": "n = 3, k = 2",
    "output": "2"
  },
  {
    "input": "n = 4, k = 2",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var kInversePairs = function(n, k) {\n};\n",
  "python": "class Solution:\n    def kInversePairs(self, n: int, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int kInversePairs(int n, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int kInversePairs(int n, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kInversePairs",
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
        0
      ],
      "expected": 1
    },
    {
      "args": [
        3,
        1
      ],
      "expected": 2
    },
    {
      "args": [
        3,
        2
      ],
      "expected": 2
    },
    {
      "args": [
        4,
        2
      ],
      "expected": 5
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      0
    ],
    "expected": 1
  },
  {
    "args": [
      2,
      0
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
      5,
      3
    ],
    "expected": 15
  },
  {
    "args": [
      7,
      10
    ],
    "expected": 573
  },
  {
    "args": [
      10,
      20
    ],
    "expected": 230131
  }
]$json$::jsonb,
    'approved'
),
(
    1281,
    '买卖股票的最佳时机 IV',
    '给定整数 k 和股票价格数组 prices，最多可以完成 k 笔交易，且不能同时参与多笔交易。
返回能获得的最大利润。一次买入和一次卖出构成一笔交易。

提示：
- 1 <= k <= 10^9
- 1 <= prices.length <= 10^5
- 0 <= prices[i] <= 10^5',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "k = 2, prices = [2, 4, 1]",
    "output": "2"
  },
  {
    "input": "k = 2, prices = [3, 2, 6, 5, 0, 3]",
    "output": "7"
  },
  {
    "input": "k = 1, prices = [1, 2, 3, 4, 5]",
    "output": "4"
  },
  {
    "input": "k = 2, prices = [7, 6, 4, 3, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "k = 2, prices = [2, 4, 1]",
    "output": "2"
  },
  {
    "input": "k = 2, prices = [3, 2, 6, 5, 0, 3]",
    "output": "7"
  },
  {
    "input": "k = 1, prices = [1, 2, 3, 4, 5]",
    "output": "4"
  },
  {
    "input": "k = 2, prices = [7, 6, 4, 3, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxProfitIV = function(k, prices) {\n};\n",
  "python": "class Solution:\n    def maxProfitIV(self, k: int, prices: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxProfitIV(int k, std::vector<int>& prices) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxProfitIV(int k, int[] prices) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxProfitIV",
  "params": [
    {
      "name": "k",
      "type": "int"
    },
    {
      "name": "prices",
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
        [
          2,
          4,
          1
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        2,
        [
          3,
          2,
          6,
          5,
          0,
          3
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        1,
        [
          1,
          2,
          3,
          4,
          5
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        2,
        [
          7,
          6,
          4,
          3,
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
      1,
      [
        2,
        1,
        4,
        5,
        2,
        9
      ]
    ],
    "expected": 8
  },
  {
    "args": [
      3,
      [
        1,
        2,
        4,
        2,
        5,
        7,
        2,
        4,
        9,
        0
      ]
    ],
    "expected": 15
  },
  {
    "args": [
      2,
      [
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      1000000000,
      [
        3,
        2,
        6,
        5,
        0,
        3
      ]
    ],
    "expected": 7
  },
  {
    "args": [
      4,
      [
        2,
        1,
        4,
        5,
        2,
        9,
        7
      ]
    ],
    "expected": 11
  }
]$json$::jsonb,
    'approved'
),
(
    1282,
    '最短公共超序列长度',
    '给定两个字符串 str1 和 str2，返回同时以 str1 和 str2 为子序列的最短字符串长度。
字符串的子序列由删除任意字符且保持剩余字符顺序得到。

提示：
- 1 <= str1.length, str2.length <= 1000
- str1 和 str2 由小写英文字母组成',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "str1 = \"abac\", str2 = \"cab\"",
    "output": "5"
  },
  {
    "input": "str1 = \"geek\", str2 = \"eke\"",
    "output": "5"
  },
  {
    "input": "str1 = \"abc\", str2 = \"def\"",
    "output": "6"
  },
  {
    "input": "str1 = \"abc\", str2 = \"abc\"",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "str1 = \"abac\", str2 = \"cab\"",
    "output": "5"
  },
  {
    "input": "str1 = \"geek\", str2 = \"eke\"",
    "output": "5"
  },
  {
    "input": "str1 = \"abc\", str2 = \"def\"",
    "output": "6"
  },
  {
    "input": "str1 = \"abc\", str2 = \"abc\"",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var shortestCommonSupersequenceLength = function(str1, str2) {\n};\n",
  "python": "class Solution:\n    def shortestCommonSupersequenceLength(self, str1: str, str2: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int shortestCommonSupersequenceLength(std::string str1, std::string str2) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int shortestCommonSupersequenceLength(String str1, String str2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "shortestCommonSupersequenceLength",
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
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "abac",
        "cab"
      ],
      "expected": 5
    },
    {
      "args": [
        "geek",
        "eke"
      ],
      "expected": 5
    },
    {
      "args": [
        "abc",
        "def"
      ],
      "expected": 6
    },
    {
      "args": [
        "abc",
        "abc"
      ],
      "expected": 3
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
      "a",
      "b"
    ],
    "expected": 2
  },
  {
    "args": [
      "ab",
      "ba"
    ],
    "expected": 3
  },
  {
    "args": [
      "abcd",
      "acbd"
    ],
    "expected": 5
  },
  {
    "args": [
      "sea",
      "eat"
    ],
    "expected": 4
  },
  {
    "args": [
      "teacher",
      "cheater"
    ],
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1283,
    '文本左右对齐',
    '给定一个单词数组 words 和一个宽度 maxWidth，重新排版单词，使其每行恰好有 maxWidth 个字符。
除最后一行左对齐外，单词之间应尽可能均匀分配空格；若空格不能均匀分配，左侧空格多于右侧。
最后一行单词之间只放一个空格，并在末尾补足空格。

提示：
- 1 <= words.length <= 300
- 1 <= words[i].length <= 20
- words[i] 由小写英文字母组成
- 1 <= maxWidth <= 100',
    'hard',
    1000,
    256,
    ARRAY['字符串', '模拟'],
    $json$[
  {
    "input": "words = [\"This\", \"is\", \"an\", \"example\", \"of\", \"text\", \"justification.\"], maxWidth = 16",
    "output": "[\"This    is    an\", \"example  of text\", \"justification.  \"]"
  },
  {
    "input": "words = [\"What\", \"must\", \"be\", \"acknowledgment\", \"shall\", \"be\"], maxWidth = 16",
    "output": "[\"What   must   be\", \"acknowledgment  \", \"shall be        \"]"
  },
  {
    "input": "words = [\"Science\", \"is\", \"what\", \"we\", \"understand\", \"well\", \"enough\", \"to\", \"explain\", \"to\", \"a\", \"computer.\", \"Art\", \"is\", \"everything\", \"else\", \"we\", \"do\"], maxWidth = 20",
    "output": "[\"Science  is  what we\", \"understand      well\", \"enough to explain to\", \"a  computer.  Art is\", \"everything  else  we\", \"do                  \"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"This\", \"is\", \"an\", \"example\", \"of\", \"text\", \"justification.\"], maxWidth = 16",
    "output": "[\"This    is    an\", \"example  of text\", \"justification.  \"]"
  },
  {
    "input": "words = [\"What\", \"must\", \"be\", \"acknowledgment\", \"shall\", \"be\"], maxWidth = 16",
    "output": "[\"What   must   be\", \"acknowledgment  \", \"shall be        \"]"
  },
  {
    "input": "words = [\"Science\", \"is\", \"what\", \"we\", \"understand\", \"well\", \"enough\", \"to\", \"explain\", \"to\", \"a\", \"computer.\", \"Art\", \"is\", \"everything\", \"else\", \"we\", \"do\"], maxWidth = 20",
    "output": "[\"Science  is  what we\", \"understand      well\", \"enough to explain to\", \"a  computer.  Art is\", \"everything  else  we\", \"do                  \"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var fullJustify = function(words, maxWidth) {\n};\n",
  "python": "class Solution:\n    def fullJustify(self, words: list[str], maxWidth: int) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> fullJustify(std::vector<std::string>& words, int maxWidth) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] fullJustify(String[] words, int maxWidth) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "fullJustify",
  "params": [
    {
      "name": "words",
      "type": "string[]"
    },
    {
      "name": "maxWidth",
      "type": "int"
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
          "This",
          "is",
          "an",
          "example",
          "of",
          "text",
          "justification."
        ],
        16
      ],
      "expected": [
        "This    is    an",
        "example  of text",
        "justification.  "
      ]
    },
    {
      "args": [
        [
          "What",
          "must",
          "be",
          "acknowledgment",
          "shall",
          "be"
        ],
        16
      ],
      "expected": [
        "What   must   be",
        "acknowledgment  ",
        "shall be        "
      ]
    },
    {
      "args": [
        [
          "Science",
          "is",
          "what",
          "we",
          "understand",
          "well",
          "enough",
          "to",
          "explain",
          "to",
          "a",
          "computer.",
          "Art",
          "is",
          "everything",
          "else",
          "we",
          "do"
        ],
        20
      ],
      "expected": [
        "Science  is  what we",
        "understand      well",
        "enough to explain to",
        "a  computer.  Art is",
        "everything  else  we",
        "do                  "
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
      3
    ],
    "expected": [
      "a b",
      "c  "
    ]
  },
  {
    "args": [
      [
        "hello"
      ],
      7
    ],
    "expected": [
      "hello  "
    ]
  },
  {
    "args": [
      [
        "a",
        "bb",
        "ccc"
      ],
      6
    ],
    "expected": [
      "a   bb",
      "ccc   "
    ]
  },
  {
    "args": [
      [
        "one",
        "two",
        "three"
      ],
      10
    ],
    "expected": [
      "one    two",
      "three     "
    ]
  },
  {
    "args": [
      [
        "listen",
        "to",
        "many",
        "speak",
        "to",
        "few"
      ],
      6
    ],
    "expected": [
      "listen",
      "to    ",
      "many  ",
      "speak ",
      "to few"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1284,
    '有效数字',
    '判断字符串 s 是否表示一个有效数字。
有效数字可以包含整数或小数部分、可选指数部分；指数部分必须是整数。正负号只能出现在开头或指数符号之后。

提示：
- 1 <= s.length <= 20
- s 由英文字母、数字、正负号和小数点组成',
    'hard',
    1000,
    256,
    ARRAY['字符串', '有限状态机'],
    $json$[
  {
    "input": "s = \"0\"",
    "output": "true"
  },
  {
    "input": "s = \"e\"",
    "output": "false"
  },
  {
    "input": "s = \".\"",
    "output": "false"
  },
  {
    "input": "s = \"2e10\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"0\"",
    "output": "true"
  },
  {
    "input": "s = \"e\"",
    "output": "false"
  },
  {
    "input": "s = \".\"",
    "output": "false"
  },
  {
    "input": "s = \"2e10\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isNumber = function(s) {\n};\n",
  "python": "class Solution:\n    def isNumber(self, s: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isNumber(std::string s) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isNumber(String s) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isNumber",
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
        "0"
      ],
      "expected": true
    },
    {
      "args": [
        "e"
      ],
      "expected": false
    },
    {
      "args": [
        "."
      ],
      "expected": false
    },
    {
      "args": [
        "2e10"
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "-0.1"
    ],
    "expected": true
  },
  {
    "args": [
      "+.5"
    ],
    "expected": true
  },
  {
    "args": [
      "3."
    ],
    "expected": true
  },
  {
    "args": [
      "1e"
    ],
    "expected": false
  },
  {
    "args": [
      "1e+"
    ],
    "expected": false
  },
  {
    "args": [
      "abc"
    ],
    "expected": false
  },
  {
    "args": [
      "0e0"
    ],
    "expected": true
  },
  {
    "args": [
      "6e-1"
    ],
    "expected": true
  },
  {
    "args": [
      "99e2.5"
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1285,
    '缺失的第一个正数',
    '给定一个未排序的整数数组 nums，返回其中没有出现的最小正整数。
要求答案在 1 到 nums.length + 1 的范围内。

提示：
- 1 <= nums.length <= 10^5
- -2^31 <= nums[i] <= 2^31 - 1',
    'hard',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "nums = [1, 2, 0]",
    "output": "3"
  },
  {
    "input": "nums = [3, 4, -1, 1]",
    "output": "2"
  },
  {
    "input": "nums = [7, 8, 9, 11, 12]",
    "output": "1"
  },
  {
    "input": "nums = [1]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 0]",
    "output": "3"
  },
  {
    "input": "nums = [3, 4, -1, 1]",
    "output": "2"
  },
  {
    "input": "nums = [7, 8, 9, 11, 12]",
    "output": "1"
  },
  {
    "input": "nums = [1]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var firstMissingPositive = function(nums) {\n};\n",
  "python": "class Solution:\n    def firstMissingPositive(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int firstMissingPositive(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int firstMissingPositive(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "firstMissingPositive",
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
          0
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          3,
          4,
          -1,
          1
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          7,
          8,
          9,
          11,
          12
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
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        2
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
    "expected": 1
  },
  {
    "args": [
      [
        -1,
        -2
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
    "expected": 2
  },
  {
    "args": [
      [
        1,
        2,
        3
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        2,
        3,
        4
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        -10,
        1,
        3
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1286,
    '接雨水 II',
    '给定一个 m × n 的二维高度图 heightMap，表示每个单元格的柱子高度。
下雨后，水会向四周低处流动，边界视为无法蓄水。返回整个地形最多能接住多少雨水。

提示：
- 1 <= m, n <= 200
- 0 <= heightMap[i][j] <= 2 * 10^4',
    'hard',
    1000,
    256,
    ARRAY['数组', '广度优先搜索', '堆', '矩阵'],
    $json$[
  {
    "input": "heightMap = [[1, 4, 3, 1, 3, 2], [3, 2, 1, 3, 2, 4], [2, 3, 3, 2, 3, 1]]",
    "output": "4"
  },
  {
    "input": "heightMap = [[3, 3, 3, 3, 3], [3, 2, 2, 2, 3], [3, 2, 1, 2, 3], [3, 2, 2, 2, 3], [3, 3, 3, 3, 3]]",
    "output": "10"
  },
  {
    "input": "heightMap = [[1]]",
    "output": "0"
  },
  {
    "input": "heightMap = [[1, 2], [3, 4]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "heightMap = [[1, 4, 3, 1, 3, 2], [3, 2, 1, 3, 2, 4], [2, 3, 3, 2, 3, 1]]",
    "output": "4"
  },
  {
    "input": "heightMap = [[3, 3, 3, 3, 3], [3, 2, 2, 2, 3], [3, 2, 1, 2, 3], [3, 2, 2, 2, 3], [3, 3, 3, 3, 3]]",
    "output": "10"
  },
  {
    "input": "heightMap = [[1]]",
    "output": "0"
  },
  {
    "input": "heightMap = [[1, 2], [3, 4]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var trapRainWaterII = function(heightMap) {\n};\n",
  "python": "class Solution:\n    def trapRainWaterII(self, heightMap: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int trapRainWaterII(std::vector<std::vector<int>>& heightMap) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int trapRainWaterII(int[][] heightMap) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "trapRainWaterII",
  "params": [
    {
      "name": "heightMap",
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
            4,
            3,
            1,
            3,
            2
          ],
          [
            3,
            2,
            1,
            3,
            2,
            4
          ],
          [
            2,
            3,
            3,
            2,
            3,
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
            3,
            3,
            3,
            3,
            3
          ],
          [
            3,
            2,
            2,
            2,
            3
          ],
          [
            3,
            2,
            1,
            2,
            3
          ],
          [
            3,
            2,
            2,
            2,
            3
          ],
          [
            3,
            3,
            3,
            3,
            3
          ]
        ]
      ],
      "expected": 10
    },
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
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          5,
          5,
          5
        ],
        [
          5,
          1,
          5
        ],
        [
          5,
          5,
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
          2,
          2,
          2
        ],
        [
          2,
          1,
          2
        ],
        [
          2,
          2,
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
          0,
          1
        ],
        [
          0,
          2,
          0
        ],
        [
          1,
          0,
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
          9,
          9,
          9,
          9
        ],
        [
          9,
          1,
          1,
          9
        ],
        [
          9,
          9,
          9,
          9
        ]
      ]
    ],
    "expected": 16
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
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1287,
    '基本计算器',
    '给定一个只包含非负整数、加号、减号、左括号、右括号和空格的字符串表达式 s，计算并返回表达式的值。
表达式中的减号也可以表示一元负号。

提示：
- 1 <= s.length <= 3 * 10^5
- s 由数字、''+''、''-''、''(''、'')'' 和空格组成
- 表达式结果保证在 32 位整数范围内',
    'hard',
    1000,
    256,
    ARRAY['字符串', '栈', '数学'],
    $json$[
  {
    "input": "s = \"1 + 1\"",
    "output": "2"
  },
  {
    "input": "s = \" 2-1 + 2 \"",
    "output": "3"
  },
  {
    "input": "s = \"(1+(4+5+2)-3)+(6+8)\"",
    "output": "23"
  },
  {
    "input": "s = \"1\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"1 + 1\"",
    "output": "2"
  },
  {
    "input": "s = \" 2-1 + 2 \"",
    "output": "3"
  },
  {
    "input": "s = \"(1+(4+5+2)-3)+(6+8)\"",
    "output": "23"
  },
  {
    "input": "s = \"1\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var calculate = function(s) {\n};\n",
  "python": "class Solution:\n    def calculate(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int calculate(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int calculate(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "calculate",
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
        "1 + 1"
      ],
      "expected": 2
    },
    {
      "args": [
        " 2-1 + 2 "
      ],
      "expected": 3
    },
    {
      "args": [
        "(1+(4+5+2)-3)+(6+8)"
      ],
      "expected": 23
    },
    {
      "args": [
        "1"
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "1-(2+3)"
    ],
    "expected": -4
  },
  {
    "args": [
      "-2+1"
    ],
    "expected": -1
  },
  {
    "args": [
      "(1-2)-(3-4)"
    ],
    "expected": 0
  },
  {
    "args": [
      "10- ( 2 + 3 )"
    ],
    "expected": 5
  },
  {
    "args": [
      "1-(-2)"
    ],
    "expected": 3
  },
  {
    "args": [
      "(7)-(0)+(4)"
    ],
    "expected": 11
  }
]$json$::jsonb,
    'approved'
),
(
    1288,
    '天际线问题',
    '给定建筑物的位置和高度 buildings，其中 buildings[i] = [left, right, height]，返回由关键点组成的天际线。
关键点是水平线段的左端点，最后一个关键点高度为 0。

提示：
- 1 <= buildings.length <= 10^4
- 0 <= left < right <= 2^31 - 1
- 1 <= height <= 2^31 - 1',
    'hard',
    1000,
    256,
    ARRAY['数组', '扫描线', '堆', '排序'],
    $json$[
  {
    "input": "buildings = [[2, 9, 10], [3, 7, 15], [5, 12, 12], [15, 20, 10], [19, 24, 8]]",
    "output": "[[2, 10], [3, 15], [7, 12], [12, 0], [15, 10], [20, 8], [24, 0]]"
  },
  {
    "input": "buildings = [[0, 2, 3], [2, 5, 3]]",
    "output": "[[0, 3], [5, 0]]"
  },
  {
    "input": "buildings = [[1, 2, 1]]",
    "output": "[[1, 1], [2, 0]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "buildings = [[2, 9, 10], [3, 7, 15], [5, 12, 12], [15, 20, 10], [19, 24, 8]]",
    "output": "[[2, 10], [3, 15], [7, 12], [12, 0], [15, 10], [20, 8], [24, 0]]"
  },
  {
    "input": "buildings = [[0, 2, 3], [2, 5, 3]]",
    "output": "[[0, 3], [5, 0]]"
  },
  {
    "input": "buildings = [[1, 2, 1]]",
    "output": "[[1, 1], [2, 0]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var skyline = function(buildings) {\n};\n",
  "python": "class Solution:\n    def skyline(self, buildings: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> skyline(std::vector<std::vector<int>>& buildings) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] skyline(int[][] buildings) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "skyline",
  "params": [
    {
      "name": "buildings",
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
            2,
            9,
            10
          ],
          [
            3,
            7,
            15
          ],
          [
            5,
            12,
            12
          ],
          [
            15,
            20,
            10
          ],
          [
            19,
            24,
            8
          ]
        ]
      ],
      "expected": [
        [
          2,
          10
        ],
        [
          3,
          15
        ],
        [
          7,
          12
        ],
        [
          12,
          0
        ],
        [
          15,
          10
        ],
        [
          20,
          8
        ],
        [
          24,
          0
        ]
      ]
    },
    {
      "args": [
        [
          [
            0,
            2,
            3
          ],
          [
            2,
            5,
            3
          ]
        ]
      ],
      "expected": [
        [
          0,
          3
        ],
        [
          5,
          0
        ]
      ]
    },
    {
      "args": [
        [
          [
            1,
            2,
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
          2,
          0
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
          3,
          2
        ],
        [
          2,
          4,
          2
        ]
      ]
    ],
    "expected": [
      [
        1,
        2
      ],
      [
        4,
        0
      ]
    ]
  },
  {
    "args": [
      [
        [
          1,
          5,
          3
        ],
        [
          2,
          4,
          5
        ]
      ]
    ],
    "expected": [
      [
        1,
        3
      ],
      [
        2,
        5
      ],
      [
        4,
        3
      ],
      [
        5,
        0
      ]
    ]
  },
  {
    "args": [
      [
        [
          0,
          10,
          1
        ],
        [
          2,
          6,
          2
        ],
        [
          4,
          8,
          3
        ]
      ]
    ],
    "expected": [
      [
        0,
        1
      ],
      [
        2,
        2
      ],
      [
        4,
        3
      ],
      [
        8,
        1
      ],
      [
        10,
        0
      ]
    ]
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
          2
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
        0
      ]
    ]
  },
  {
    "args": [
      [
        [
          0,
          1,
          3
        ],
        [
          1,
          2,
          1
        ]
      ]
    ],
    "expected": [
      [
        0,
        3
      ],
      [
        1,
        1
      ],
      [
        2,
        0
      ]
    ]
  },
  {
    "args": [
      [
        [
          3,
          10,
          5
        ],
        [
          5,
          8,
          7
        ]
      ]
    ],
    "expected": [
      [
        3,
        5
      ],
      [
        5,
        7
      ],
      [
        8,
        5
      ],
      [
        10,
        0
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1289,
    '合并 K 个升序数组',
    '给定 k 个升序整数数组 lists，将所有元素合并到一个升序数组中并返回。

提示：
- 0 <= k <= 500
- 0 <= lists[i].length <= 500
- -10^4 <= lists[i][j] <= 10^4
- lists[i] 按升序排列',
    'hard',
    1000,
    256,
    ARRAY['数组', '堆', '分治'],
    $json$[
  {
    "input": "lists = [[1, 4, 5], [1, 3, 4], [2, 6]]",
    "output": "[1, 1, 2, 3, 4, 4, 5, 6]"
  },
  {
    "input": "lists = [[]]",
    "output": "[]"
  },
  {
    "input": "lists = []",
    "output": "[]"
  },
  {
    "input": "lists = [[1], [2], [3]]",
    "output": "[1, 2, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "lists = [[1, 4, 5], [1, 3, 4], [2, 6]]",
    "output": "[1, 1, 2, 3, 4, 4, 5, 6]"
  },
  {
    "input": "lists = [[]]",
    "output": "[]"
  },
  {
    "input": "lists = []",
    "output": "[]"
  },
  {
    "input": "lists = [[1], [2], [3]]",
    "output": "[1, 2, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var mergeKArrays = function(lists) {\n};\n",
  "python": "class Solution:\n    def mergeKArrays(self, lists: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> mergeKArrays(std::vector<std::vector<int>>& lists) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] mergeKArrays(int[][] lists) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "mergeKArrays",
  "params": [
    {
      "name": "lists",
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
            4,
            5
          ],
          [
            1,
            3,
            4
          ],
          [
            2,
            6
          ]
        ]
      ],
      "expected": [
        1,
        1,
        2,
        3,
        4,
        4,
        5,
        6
      ]
    },
    {
      "args": [
        [
          []
        ]
      ],
      "expected": []
    },
    {
      "args": [
        []
      ],
      "expected": []
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
        [
          -5,
          -1
        ],
        [],
        [
          0,
          2
        ]
      ]
    ],
    "expected": [
      -5,
      -1,
      0,
      2
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
          2
        ]
      ]
    ],
    "expected": [
      1,
      1,
      2,
      2
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
          2
        ]
      ]
    ],
    "expected": [
      0,
      0,
      1,
      1,
      2
    ]
  },
  {
    "args": [
      [
        [
          1
        ],
        [],
        [
          0
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
          -10,
          -5,
          0
        ],
        [
          1,
          3
        ],
        [
          2
        ]
      ]
    ],
    "expected": [
      -10,
      -5,
      0,
      1,
      2,
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1290,
    '单词拆分 II',
    '给定字符串 s 和单词字典 wordDict，在 s 中增加空格构造所有可能的句子，使每个单词都在字典中。
返回所有句子，并按字典序排列。

提示：
- 1 <= s.length <= 20
- 1 <= wordDict.length <= 100
- 1 <= wordDict[i].length <= 10
- wordDict 中的单词互不相同',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划', '回溯'],
    $json$[
  {
    "input": "s = \"catsanddog\", wordDict = [\"cat\", \"cats\", \"and\", \"sand\", \"dog\"]",
    "output": "[\"cat sand dog\", \"cats and dog\"]"
  },
  {
    "input": "s = \"pineapplepenapple\", wordDict = [\"apple\", \"pen\", \"applepen\", \"pine\", \"pineapple\"]",
    "output": "[\"pine apple pen apple\", \"pine applepen apple\", \"pineapple pen apple\"]"
  },
  {
    "input": "s = \"catsandog\", wordDict = [\"cats\", \"dog\", \"sand\", \"and\", \"cat\"]",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"catsanddog\", wordDict = [\"cat\", \"cats\", \"and\", \"sand\", \"dog\"]",
    "output": "[\"cat sand dog\", \"cats and dog\"]"
  },
  {
    "input": "s = \"pineapplepenapple\", wordDict = [\"apple\", \"pen\", \"applepen\", \"pine\", \"pineapple\"]",
    "output": "[\"pine apple pen apple\", \"pine applepen apple\", \"pineapple pen apple\"]"
  },
  {
    "input": "s = \"catsandog\", wordDict = [\"cats\", \"dog\", \"sand\", \"and\", \"cat\"]",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var wordBreakII = function(s, wordDict) {\n};\n",
  "python": "class Solution:\n    def wordBreakII(self, s: str, wordDict: list[str]) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> wordBreakII(std::string s, std::vector<std::string>& wordDict) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] wordBreakII(String s, String[] wordDict) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "wordBreakII",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "wordDict",
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
        "catsanddog",
        [
          "cat",
          "cats",
          "and",
          "sand",
          "dog"
        ]
      ],
      "expected": [
        "cat sand dog",
        "cats and dog"
      ]
    },
    {
      "args": [
        "pineapplepenapple",
        [
          "apple",
          "pen",
          "applepen",
          "pine",
          "pineapple"
        ]
      ],
      "expected": [
        "pine apple pen apple",
        "pine applepen apple",
        "pineapple pen apple"
      ]
    },
    {
      "args": [
        "catsandog",
        [
          "cats",
          "dog",
          "sand",
          "and",
          "cat"
        ]
      ],
      "expected": []
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
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
      "ab",
      [
        "a",
        "b"
      ]
    ],
    "expected": [
      "a b"
    ]
  },
  {
    "args": [
      "aaa",
      [
        "a",
        "aa"
      ]
    ],
    "expected": [
      "a a a",
      "a aa",
      "aa a"
    ]
  },
  {
    "args": [
      "abcd",
      [
        "a",
        "b",
        "c",
        "d"
      ]
    ],
    "expected": [
      "a b c d"
    ]
  },
  {
    "args": [
      "catsandog",
      [
        "cat",
        "and",
        "dog"
      ]
    ],
    "expected": []
  }
]$json$::jsonb,
    'approved'
),
(
    1291,
    '二叉树中的最大路径和',
    '给定一棵二叉树 root，返回任意节点路径的最大路径和。
路径可以从任意节点开始和结束，但必须沿父子连接连续，且同一节点最多出现一次。

提示：
- 1 <= 节点数 <= 3 * 10^4
- -1000 <= Node.val <= 1000',
    'hard',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '动态规划'],
    $json$[
  {
    "input": "root = [1, 2, 3]",
    "output": "6"
  },
  {
    "input": "root = [-10, 9, 20, null, null, 15, 7]",
    "output": "42"
  },
  {
    "input": "root = [-3]",
    "output": "-3"
  },
  {
    "input": "root = [2, -1]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3]",
    "output": "6"
  },
  {
    "input": "root = [-10, 9, 20, null, null, 15, 7]",
    "output": "42"
  },
  {
    "input": "root = [-3]",
    "output": "-3"
  },
  {
    "input": "root = [2, -1]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar maxPathSum = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def maxPathSum(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int maxPathSum(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int maxPathSum(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxPathSum",
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
      "expected": 6
    },
    {
      "args": [
        [
          -10,
          9,
          20,
          null,
          null,
          15,
          7
        ]
      ],
      "expected": 42
    },
    {
      "args": [
        [
          -3
        ]
      ],
      "expected": -3
    },
    {
      "args": [
        [
          2,
          -1
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
        -2,
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        -2,
        3
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        -1,
        -2,
        -3
      ]
    ],
    "expected": -1
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
        2
      ]
    ],
    "expected": 48
  },
  {
    "args": [
      [
        2,
        -1,
        -2
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        -10,
        -20,
        -30
      ]
    ],
    "expected": -10
  }
]$json$::jsonb,
    'approved'
),
(
    1292,
    '扰乱字符串',
    '给定两个长度相同的字符串 s1 和 s2，判断 s2 是否是 s1 的扰乱字符串。
扰乱字符串可以通过递归交换一个字符串的某个非空子串与其相邻的另一子串得到。

提示：
- 1 <= s1.length, s2.length <= 30
- s1 和 s2 由小写英文字母组成',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划', '记忆化搜索'],
    $json$[
  {
    "input": "s1 = \"great\", s2 = \"rgeat\"",
    "output": "true"
  },
  {
    "input": "s1 = \"abcde\", s2 = \"caebd\"",
    "output": "false"
  },
  {
    "input": "s1 = \"a\", s2 = \"a\"",
    "output": "true"
  },
  {
    "input": "s1 = \"ab\", s2 = \"ba\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s1 = \"great\", s2 = \"rgeat\"",
    "output": "true"
  },
  {
    "input": "s1 = \"abcde\", s2 = \"caebd\"",
    "output": "false"
  },
  {
    "input": "s1 = \"a\", s2 = \"a\"",
    "output": "true"
  },
  {
    "input": "s1 = \"ab\", s2 = \"ba\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isScramble = function(s1, s2) {\n};\n",
  "python": "class Solution:\n    def isScramble(self, s1: str, s2: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isScramble(std::string s1, std::string s2) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isScramble(String s1, String s2) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isScramble",
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
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "great",
        "rgeat"
      ],
      "expected": true
    },
    {
      "args": [
        "abcde",
        "caebd"
      ],
      "expected": false
    },
    {
      "args": [
        "a",
        "a"
      ],
      "expected": true
    },
    {
      "args": [
        "ab",
        "ba"
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abb",
      "bba"
    ],
    "expected": true
  },
  {
    "args": [
      "abc",
      "abc"
    ],
    "expected": true
  },
  {
    "args": [
      "abcd",
      "badc"
    ],
    "expected": true
  },
  {
    "args": [
      "abcdef",
      "fbcdea"
    ],
    "expected": true
  },
  {
    "args": [
      "aab",
      "aba"
    ],
    "expected": true
  },
  {
    "args": [
      "abcd",
      "cdab"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1293,
    '最大间距',
    '给定一个无序整数数组 nums，返回数组在排序之后相邻元素之间的最大差值。
数组至少包含两个元素。

提示：
- 2 <= nums.length <= 10^5
- 0 <= nums[i] <= 10^9',
    'hard',
    1000,
    256,
    ARRAY['数组', '排序', '基数排序'],
    $json$[
  {
    "input": "nums = [3, 6, 9, 1]",
    "output": "3"
  },
  {
    "input": "nums = [10, 20]",
    "output": "10"
  },
  {
    "input": "nums = [1, 10000000]",
    "output": "9999999"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 6, 9, 1]",
    "output": "3"
  },
  {
    "input": "nums = [10, 20]",
    "output": "10"
  },
  {
    "input": "nums = [1, 10000000]",
    "output": "9999999"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumGap = function(nums) {\n};\n",
  "python": "class Solution:\n    def maximumGap(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumGap(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumGap(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumGap",
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
          9,
          1
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          10,
          20
        ]
      ],
      "expected": 10
    },
    {
      "args": [
        [
          1,
          10000000
        ]
      ],
      "expected": 9999999
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
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        3,
        100
      ]
    ],
    "expected": 97
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
    "expected": 0
  },
  {
    "args": [
      [
        100,
        3,
        2,
        1
      ]
    ],
    "expected": 97
  },
  {
    "args": [
      [
        0,
        9,
        3,
        5
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
        8,
        16
      ]
    ],
    "expected": 8
  },
  {
    "args": [
      [
        4,
        2,
        9,
        7
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1294,
    '买卖股票的最佳时机 III',
    '给定一个数组 prices，其中 prices[i] 表示某支股票第 i 天的价格。
最多可以完成两笔交易，且不能同时参与多笔交易，返回能获得的最大利润。

提示：
- 1 <= prices.length <= 10^5
- 0 <= prices[i] <= 10^5',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "prices = [3, 3, 5, 0, 0, 3, 1, 4]",
    "output": "6"
  },
  {
    "input": "prices = [1, 2, 3, 4, 5]",
    "output": "4"
  },
  {
    "input": "prices = [7, 6, 4, 3, 1]",
    "output": "0"
  },
  {
    "input": "prices = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "prices = [3, 3, 5, 0, 0, 3, 1, 4]",
    "output": "6"
  },
  {
    "input": "prices = [1, 2, 3, 4, 5]",
    "output": "4"
  },
  {
    "input": "prices = [7, 6, 4, 3, 1]",
    "output": "0"
  },
  {
    "input": "prices = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxProfitIII = function(prices) {\n};\n",
  "python": "class Solution:\n    def maxProfitIII(self, prices: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxProfitIII(std::vector<int>& prices) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxProfitIII(int[] prices) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxProfitIII",
  "params": [
    {
      "name": "prices",
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
          5,
          0,
          0,
          3,
          1,
          4
        ]
      ],
      "expected": 6
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
    },
    {
      "args": [
        [
          7,
          6,
          4,
          3,
          1
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
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        2,
        1,
        4,
        5,
        2,
        9,
        7
      ]
    ],
    "expected": 11
  },
  {
    "args": [
      [
        3,
        2,
        6,
        5,
        0,
        3
      ]
    ],
    "expected": 7
  },
  {
    "args": [
      [
        1,
        2,
        4,
        2,
        5,
        7,
        2,
        4,
        9,
        0
      ]
    ],
    "expected": 13
  },
  {
    "args": [
      [
        2,
        4,
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        6,
        1,
        3,
        2,
        4,
        7
      ]
    ],
    "expected": 7
  }
]$json$::jsonb,
    'approved'
),
(
    1295,
    '分割数组的最大值',
    '给定一个非负整数数组 nums 和整数 k，将数组分成 k 个非空连续子数组，使这些子数组各自和的最大值最小。
返回这个最小的最大和。

提示：
- 1 <= nums.length <= 10^5
- 0 <= nums[i] <= 10^6
- 1 <= k <= nums.length',
    'hard',
    1000,
    256,
    ARRAY['数组', '二分查找', '动态规划'],
    $json$[
  {
    "input": "nums = [7, 2, 5, 10, 8], k = 2",
    "output": "18"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5], k = 2",
    "output": "9"
  },
  {
    "input": "nums = [1, 4, 4], k = 3",
    "output": "4"
  },
  {
    "input": "nums = [1], k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [7, 2, 5, 10, 8], k = 2",
    "output": "18"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5], k = 2",
    "output": "9"
  },
  {
    "input": "nums = [1, 4, 4], k = 3",
    "output": "4"
  },
  {
    "input": "nums = [1], k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var splitArray = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def splitArray(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long splitArray(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long splitArray(int[] nums, int k) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "splitArray",
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
  "return_type": "long",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          7,
          2,
          5,
          10,
          8
        ],
        2
      ],
      "expected": 18
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
        2
      ],
      "expected": 9
    },
    {
      "args": [
        [
          1,
          4,
          4
        ],
        3
      ],
      "expected": 4
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
        10,
        20,
        30
      ],
      2
    ],
    "expected": 30
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
    "expected": 0
  },
  {
    "args": [
      [
        5,
        5,
        5,
        5
      ],
      4
    ],
    "expected": 5
  },
  {
    "args": [
      [
        2,
        3,
        1,
        2,
        4,
        3
      ],
      5
    ],
    "expected": 4
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
      3
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1296,
    '数字 1 的个数',
    '给定一个整数 n，计算所有小于等于 n 的非负整数中数字 1 出现的总次数。

提示：
- 0 <= n <= 2^31 - 1',
    'hard',
    1000,
    256,
    ARRAY['数学', '动态规划'],
    $json$[
  {
    "input": "n = 13",
    "output": "6"
  },
  {
    "input": "n = 0",
    "output": "0"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 20",
    "output": "12"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 13",
    "output": "6"
  },
  {
    "input": "n = 0",
    "output": "0"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 20",
    "output": "12"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countDigitOne = function(n) {\n};\n",
  "python": "class Solution:\n    def countDigitOne(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long countDigitOne(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long countDigitOne(int n) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countDigitOne",
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
        13
      ],
      "expected": 6
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
      "expected": 1
    },
    {
      "args": [
        20
      ],
      "expected": 12
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      9
    ],
    "expected": 1
  },
  {
    "args": [
      99
    ],
    "expected": 20
  },
  {
    "args": [
      100
    ],
    "expected": 21
  },
  {
    "args": [
      1234
    ],
    "expected": 689
  },
  {
    "args": [
      1000000000
    ],
    "expected": 900000001
  },
  {
    "args": [
      2147483647
    ],
    "expected": 2971027783
  },
  {
    "args": [
      10
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1297,
    '奇怪的打印机',
    '有一台奇怪的打印机，每次可以打印一段连续相同字符，并且新打印的字符会覆盖原有字符。
给定字符串 s，返回打印出 s 所需的最少打印次数。

提示：
- 1 <= s.length <= 100
- s 由小写英文字母组成',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "s = \"aaabbb\"",
    "output": "2"
  },
  {
    "input": "s = \"aba\"",
    "output": "2"
  },
  {
    "input": "s = \"abc\"",
    "output": "3"
  },
  {
    "input": "s = \"a\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aaabbb\"",
    "output": "2"
  },
  {
    "input": "s = \"aba\"",
    "output": "2"
  },
  {
    "input": "s = \"abc\"",
    "output": "3"
  },
  {
    "input": "s = \"a\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var strangePrinter = function(s) {\n};\n",
  "python": "class Solution:\n    def strangePrinter(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int strangePrinter(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int strangePrinter(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "strangePrinter",
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
        "aaabbb"
      ],
      "expected": 2
    },
    {
      "args": [
        "aba"
      ],
      "expected": 2
    },
    {
      "args": [
        "abc"
      ],
      "expected": 3
    },
    {
      "args": [
        "a"
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "aab"
    ],
    "expected": 2
  },
  {
    "args": [
      "abba"
    ],
    "expected": 2
  },
  {
    "args": [
      "abcabc"
    ],
    "expected": 5
  },
  {
    "args": [
      "aaaa"
    ],
    "expected": 1
  },
  {
    "args": [
      "abab"
    ],
    "expected": 3
  },
  {
    "args": [
      "aaabbbccc"
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1298,
    '学生出勤记录 II',
    '可以用长度为 n 的字符串表示学生的出勤记录，每个字符为 A（缺勤）、L（迟到）或 P（到场）。
如果记录中 A 少于 2 个，且不存在连续 3 个或更多 L，则记录有效。
返回长度为 n 的有效记录数量，结果对 10^9 + 7 取模。

提示：
- 1 <= n <= 10^5',
    'hard',
    1000,
    256,
    ARRAY['动态规划'],
    $json$[
  {
    "input": "n = 1",
    "output": "3"
  },
  {
    "input": "n = 2",
    "output": "8"
  },
  {
    "input": "n = 3",
    "output": "19"
  },
  {
    "input": "n = 4",
    "output": "43"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 1",
    "output": "3"
  },
  {
    "input": "n = 2",
    "output": "8"
  },
  {
    "input": "n = 3",
    "output": "19"
  },
  {
    "input": "n = 4",
    "output": "43"
  }
]$json$::jsonb,
    $json${
  "javascript": "var checkRecord = function(n) {\n};\n",
  "python": "class Solution:\n    def checkRecord(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int checkRecord(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int checkRecord(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkRecord",
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
        1
      ],
      "expected": 3
    },
    {
      "args": [
        2
      ],
      "expected": 8
    },
    {
      "args": [
        3
      ],
      "expected": 19
    },
    {
      "args": [
        4
      ],
      "expected": 43
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      5
    ],
    "expected": 94
  },
  {
    "args": [
      6
    ],
    "expected": 200
  },
  {
    "args": [
      10
    ],
    "expected": 3536
  },
  {
    "args": [
      100
    ],
    "expected": 985598218
  },
  {
    "args": [
      1000
    ],
    "expected": 250434094
  },
  {
    "args": [
      100000
    ],
    "expected": 749184020
  }
]$json$::jsonb,
    'approved'
),
(
    1299,
    '统计不同回文子序列',
    '给定一个字符串 s，返回 s 中不同的非空回文子序列数量，结果对 10^9 + 7 取模。
相同字符序列只计一次，即使它们由不同下标子序列形成。

提示：
- 1 <= s.length <= 100
- s 仅包含字符 ''a''、''b''、''c''、''d''',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "s = \"b\"",
    "output": "1"
  },
  {
    "input": "s = \"abc\"",
    "output": "3"
  },
  {
    "input": "s = \"aaa\"",
    "output": "3"
  },
  {
    "input": "s = \"aba\"",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"b\"",
    "output": "1"
  },
  {
    "input": "s = \"abc\"",
    "output": "3"
  },
  {
    "input": "s = \"aaa\"",
    "output": "3"
  },
  {
    "input": "s = \"aba\"",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countPalindromicSubsequences = function(s) {\n};\n",
  "python": "class Solution:\n    def countPalindromicSubsequences(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countPalindromicSubsequences(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countPalindromicSubsequences(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countPalindromicSubsequences",
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
        "b"
      ],
      "expected": 1
    },
    {
      "args": [
        "abc"
      ],
      "expected": 3
    },
    {
      "args": [
        "aaa"
      ],
      "expected": 3
    },
    {
      "args": [
        "aba"
      ],
      "expected": 4
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "aa"
    ],
    "expected": 2
  },
  {
    "args": [
      "abba"
    ],
    "expected": 6
  },
  {
    "args": [
      "abcd"
    ],
    "expected": 4
  },
  {
    "args": [
      "aab"
    ],
    "expected": 3
  },
  {
    "args": [
      "abcba"
    ],
    "expected": 10
  },
  {
    "args": [
      "aaaabbbbccccdddd"
    ],
    "expected": 16
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
    GREATEST((SELECT COALESCE(MAX(id), 1) FROM problems), 1299)
);

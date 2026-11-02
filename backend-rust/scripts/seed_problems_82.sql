-- 仅用于本地/测试环境的题目种子数据。
-- 使用固定 ID 1116-1197，便于通过 clean_dev.sql 安全清理。
-- 82 道函数式题目（run_config + 公开用例 + 隐藏 judge_cases），
-- 与 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）合计 100 题。

INSERT INTO problems (
    id, title, description, difficulty, time_limit, memory_limit, tags,
    examples, test_cases, code_template, run_config, judge_cases, review_status
) VALUES
(
    1116,
    '加一',
    '给定一个由整数组成的非空数组 digits，表示一个非负整数（最高位在数组开头，不含前导零），将这个整数加一。
结果仍以数组形式返回，每个元素只包含一位数字。

提示：
- 1 <= digits.length <= 100
- 0 <= digits[i] <= 9
- 除数字 0 本身外，digits 不包含前导零',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "digits = [1, 2, 3]",
    "output": "[1, 2, 4]"
  },
  {
    "input": "digits = [4, 3, 2, 1]",
    "output": "[4, 3, 2, 2]"
  },
  {
    "input": "digits = [9]",
    "output": "[1, 0]"
  },
  {
    "input": "digits = [9, 9, 9]",
    "output": "[1, 0, 0, 0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "digits = [1, 2, 3]",
    "output": "[1, 2, 4]"
  },
  {
    "input": "digits = [4, 3, 2, 1]",
    "output": "[4, 3, 2, 2]"
  },
  {
    "input": "digits = [9]",
    "output": "[1, 0]"
  },
  {
    "input": "digits = [9, 9, 9]",
    "output": "[1, 0, 0, 0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var plusOne = function(digits) {\n};\n",
  "python": "class Solution:\n    def plusOne(self, digits: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> plusOne(std::vector<int>& digits) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] plusOne(int[] digits) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "plusOne",
  "params": [
    {
      "name": "digits",
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
        2,
        4
      ]
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
      "expected": [
        4,
        3,
        2,
        2
      ]
    },
    {
      "args": [
        [
          9
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
          9,
          9,
          9
        ]
      ],
      "expected": [
        1,
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
        0
      ]
    ],
    "expected": [
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
      2
    ]
  },
  {
    "args": [
      [
        8
      ]
    ],
    "expected": [
      9
    ]
  },
  {
    "args": [
      [
        9,
        9
      ]
    ],
    "expected": [
      1,
      0,
      0
    ]
  },
  {
    "args": [
      [
        1,
        9
      ]
    ],
    "expected": [
      2,
      0
    ]
  },
  {
    "args": [
      [
        2,
        9,
        9
      ]
    ],
    "expected": [
      3,
      0,
      0
    ]
  },
  {
    "args": [
      [
        9,
        8,
        9
      ]
    ],
    "expected": [
      9,
      9,
      0
    ]
  },
  {
    "args": [
      [
        1,
        0,
        0,
        0
      ]
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
      [
        5,
        6,
        7
      ]
    ],
    "expected": [
      5,
      6,
      8
    ]
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
    "expected": [
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
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
        5
      ]
    ],
    "expected": [
      1,
      2,
      3,
      4,
      6
    ]
  },
  {
    "args": [
      [
        9,
        9,
        9,
        9,
        9
      ]
    ],
    "expected": [
      1,
      0,
      0,
      0,
      0,
      0
    ]
  },
  {
    "args": [
      [
        7,
        2,
        9
      ]
    ],
    "expected": [
      7,
      3,
      0
    ]
  },
  {
    "args": [
      [
        3,
        9
      ]
    ],
    "expected": [
      4,
      0
    ]
  },
  {
    "args": [
      [
        1,
        9,
        9,
        9
      ]
    ],
    "expected": [
      2,
      0,
      0,
      0
    ]
  },
  {
    "args": [
      [
        2,
        0,
        4,
        9
      ]
    ],
    "expected": [
      2,
      0,
      5,
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1117,
    '二进制求和',
    '给定两个二进制字符串 a 和 b，以二进制字符串的形式返回它们的和。
字符串只包含字符 0 和 1，且不含前导零（数字 0 本身除外）。

提示：
- 1 <= a.length, b.length <= 10^4
- a 和 b 仅由 0 或 1 组成',
    'easy',
    1000,
    256,
    ARRAY['字符串', '数学', '模拟'],
    $json$[
  {
    "input": "a = \"11\", b = \"1\"",
    "output": "\"100\""
  },
  {
    "input": "a = \"1010\", b = \"1011\"",
    "output": "\"10101\""
  },
  {
    "input": "a = \"0\", b = \"0\"",
    "output": "\"0\""
  },
  {
    "input": "a = \"1\", b = \"1\"",
    "output": "\"10\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "a = \"11\", b = \"1\"",
    "output": "\"100\""
  },
  {
    "input": "a = \"1010\", b = \"1011\"",
    "output": "\"10101\""
  },
  {
    "input": "a = \"0\", b = \"0\"",
    "output": "\"0\""
  },
  {
    "input": "a = \"1\", b = \"1\"",
    "output": "\"10\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var addBinary = function(a, b) {\n};\n",
  "python": "class Solution:\n    def addBinary(self, a: str, b: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string addBinary(std::string a, std::string b) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String addBinary(String a, String b) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "addBinary",
  "params": [
    {
      "name": "a",
      "type": "string"
    },
    {
      "name": "b",
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
        "1"
      ],
      "expected": "100"
    },
    {
      "args": [
        "1010",
        "1011"
      ],
      "expected": "10101"
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
        "1",
        "1"
      ],
      "expected": "10"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "0",
      "1"
    ],
    "expected": "1"
  },
  {
    "args": [
      "1",
      "0"
    ],
    "expected": "1"
  },
  {
    "args": [
      "1111",
      "1"
    ],
    "expected": "10000"
  },
  {
    "args": [
      "100",
      "110010"
    ],
    "expected": "110110"
  },
  {
    "args": [
      "101",
      "101"
    ],
    "expected": "1010"
  },
  {
    "args": [
      "1101",
      "1011"
    ],
    "expected": "11000"
  },
  {
    "args": [
      "11111111111111111111",
      "1"
    ],
    "expected": "100000000000000000000"
  },
  {
    "args": [
      "1001",
      "100"
    ],
    "expected": "1101"
  },
  {
    "args": [
      "111",
      "111"
    ],
    "expected": "1110"
  },
  {
    "args": [
      "0",
      "1010"
    ],
    "expected": "1010"
  },
  {
    "args": [
      "1010101",
      "101"
    ],
    "expected": "1011010"
  },
  {
    "args": [
      "11",
      "11"
    ],
    "expected": "110"
  },
  {
    "args": [
      "10000",
      "10000"
    ],
    "expected": "100000"
  },
  {
    "args": [
      "1",
      "111111"
    ],
    "expected": "1000000"
  },
  {
    "args": [
      "1000000000",
      "1"
    ],
    "expected": "1000000001"
  }
]$json$::jsonb,
    'approved'
),
(
    1118,
    '移除元素',
    '给定整数数组 nums 和整数 val，原地移除所有等于 val 的元素。
元素顺序可以改变，返回移除后数组的新长度。
不需要处理新长度之外的元素。

提示：
- 0 <= nums.length <= 100
- 0 <= nums[i], val <= 50',
    'easy',
    1000,
    256,
    ARRAY['数组', '双指针'],
    $json$[
  {
    "input": "nums = [3, 2, 2, 3], val = 3",
    "output": "2"
  },
  {
    "input": "nums = [0, 1, 2, 2, 3, 0, 4, 2], val = 2",
    "output": "5"
  },
  {
    "input": "nums = [1], val = 1",
    "output": "0"
  },
  {
    "input": "nums = [1], val = 2",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 2, 2, 3], val = 3",
    "output": "2"
  },
  {
    "input": "nums = [0, 1, 2, 2, 3, 0, 4, 2], val = 2",
    "output": "5"
  },
  {
    "input": "nums = [1], val = 1",
    "output": "0"
  },
  {
    "input": "nums = [1], val = 2",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeElement = function(nums, val) {\n};\n",
  "python": "class Solution:\n    def removeElement(self, nums: list[int], val: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int removeElement(std::vector<int>& nums, int val) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int removeElement(int[] nums, int val) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeElement",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "val",
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
          2,
          3
        ],
        3
      ],
      "expected": 2
    },
    {
      "args": [
        [
          0,
          1,
          2,
          2,
          3,
          0,
          4,
          2
        ],
        2
      ],
      "expected": 5
    },
    {
      "args": [
        [
          1
        ],
        1
      ],
      "expected": 0
    },
    {
      "args": [
        [
          1
        ],
        2
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [],
      0
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
      4
    ],
    "expected": 3
  },
  {
    "args": [
      [
        4,
        4,
        4
      ],
      4
    ],
    "expected": 0
  },
  {
    "args": [
      [
        -1,
        -1,
        2
      ],
      -1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        2,
        2,
        2,
        3
      ],
      2
    ],
    "expected": 1
  },
  {
    "args": [
      [
        0,
        0
      ],
      1
    ],
    "expected": 2
  },
  {
    "args": [
      [
        5
      ],
      5
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
      3
    ],
    "expected": 4
  },
  {
    "args": [
      [
        -3,
        -2,
        -1
      ],
      -2
    ],
    "expected": 2
  },
  {
    "args": [
      [
        7,
        7,
        7,
        7
      ],
      8
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
      1
    ],
    "expected": 3
  },
  {
    "args": [
      [
        0,
        1,
        2,
        3,
        4
      ],
      0
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1119,
    '删除有序数组中的重复项',
    '给定一个升序排列的整数数组 nums，原地删除重复出现的元素，使每个元素只出现一次，返回删除后数组的新长度。
元素的相对顺序应保持一致。

提示：
- 0 <= nums.length <= 3 * 10^4
- -100 <= nums[i] <= 100
- nums 已按升序排列',
    'easy',
    1000,
    256,
    ARRAY['数组', '双指针'],
    $json$[
  {
    "input": "nums = [1, 1, 2]",
    "output": "2"
  },
  {
    "input": "nums = [0, 0, 1, 1, 1, 2, 2, 3, 3, 4]",
    "output": "5"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = []",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 2]",
    "output": "2"
  },
  {
    "input": "nums = [0, 0, 1, 1, 1, 2, 2, 3, 3, 4]",
    "output": "5"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = []",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeDuplicates = function(nums) {\n};\n",
  "python": "class Solution:\n    def removeDuplicates(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int removeDuplicates(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int removeDuplicates(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeDuplicates",
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
          1,
          1,
          2,
          2,
          3,
          3,
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
      "expected": 1
    },
    {
      "args": [
        []
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
        3
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        -1,
        -1,
        0,
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
        5,
        5
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        -100,
        0,
        0,
        100
      ]
    ],
    "expected": 3
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
        1,
        2,
        2,
        3
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
    "expected": 1
  },
  {
    "args": [
      [
        -3,
        -2,
        -1
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
        3,
        3,
        4,
        5
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        2,
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
    1120,
    '搜索插入位置',
    '给定一个升序排列且无重复元素的整数数组 nums 和一个目标值 target，在数组中找到目标值并返回其下标。
如果目标值不存在，返回它将会被按顺序插入的位置。

提示：
- 1 <= nums.length <= 10^4
- -10^4 <= nums[i], target <= 10^4
- nums 无重复元素并升序排列',
    'easy',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "nums = [1, 3, 5, 6], target = 5",
    "output": "2"
  },
  {
    "input": "nums = [1, 3, 5, 6], target = 2",
    "output": "1"
  },
  {
    "input": "nums = [1, 3, 5, 6], target = 7",
    "output": "4"
  },
  {
    "input": "nums = [1, 3, 5, 6], target = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3, 5, 6], target = 5",
    "output": "2"
  },
  {
    "input": "nums = [1, 3, 5, 6], target = 2",
    "output": "1"
  },
  {
    "input": "nums = [1, 3, 5, 6], target = 7",
    "output": "4"
  },
  {
    "input": "nums = [1, 3, 5, 6], target = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var searchInsert = function(nums, target) {\n};\n",
  "python": "class Solution:\n    def searchInsert(self, nums: list[int], target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int searchInsert(std::vector<int>& nums, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int searchInsert(int[] nums, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "searchInsert",
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
          1,
          3,
          5,
          6
        ],
        5
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1,
          3,
          5,
          6
        ],
        2
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          3,
          5,
          6
        ],
        7
      ],
      "expected": 4
    },
    {
      "args": [
        [
          1,
          3,
          5,
          6
        ],
        0
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [],
      5
    ],
    "expected": 0
  },
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
        1
      ],
      1
    ],
    "expected": 0
  },
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
        -5,
        -3,
        0,
        2
      ],
      -4
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
      25
    ],
    "expected": 2
  },
  {
    "args": [
      [
        10,
        20,
        30
      ],
      10
    ],
    "expected": 0
  },
  {
    "args": [
      [
        10,
        20,
        30
      ],
      30
    ],
    "expected": 2
  },
  {
    "args": [
      [
        10,
        20,
        30
      ],
      31
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        2,
        4,
        5,
        6
      ],
      3
    ],
    "expected": 2
  },
  {
    "args": [
      [
        -10,
        -5,
        0,
        3,
        9
      ],
      -11
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1121,
    '外观数列',
    '外观数列是一个整数序列，从数字 1 开始，序列中的每一项都是对前一项的描述。
前五项如下：
1.     1
2.     11
3.     21
4.     1211
5.     111221
给定正整数 n，返回外观数列的第 n 项。

提示：
- 1 <= n <= 30',
    'easy',
    1000,
    256,
    ARRAY['字符串', '模拟'],
    $json$[
  {
    "input": "n = 1",
    "output": "\"1\""
  },
  {
    "input": "n = 4",
    "output": "\"1211\""
  },
  {
    "input": "n = 5",
    "output": "\"111221\""
  },
  {
    "input": "n = 6",
    "output": "\"312211\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 1",
    "output": "\"1\""
  },
  {
    "input": "n = 4",
    "output": "\"1211\""
  },
  {
    "input": "n = 5",
    "output": "\"111221\""
  },
  {
    "input": "n = 6",
    "output": "\"312211\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var countAndSay = function(n) {\n};\n",
  "python": "class Solution:\n    def countAndSay(self, n: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string countAndSay(int n) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String countAndSay(int n) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countAndSay",
  "params": [
    {
      "name": "n",
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
      "expected": "1"
    },
    {
      "args": [
        4
      ],
      "expected": "1211"
    },
    {
      "args": [
        5
      ],
      "expected": "111221"
    },
    {
      "args": [
        6
      ],
      "expected": "312211"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2
    ],
    "expected": "11"
  },
  {
    "args": [
      3
    ],
    "expected": "21"
  },
  {
    "args": [
      7
    ],
    "expected": "13112221"
  },
  {
    "args": [
      8
    ],
    "expected": "1113213211"
  },
  {
    "args": [
      9
    ],
    "expected": "31131211131221"
  },
  {
    "args": [
      10
    ],
    "expected": "13211311123113112211"
  },
  {
    "args": [
      11
    ],
    "expected": "11131221133112132113212221"
  },
  {
    "args": [
      12
    ],
    "expected": "3113112221232112111312211312113211"
  },
  {
    "args": [
      13
    ],
    "expected": "1321132132111213122112311311222113111221131221"
  },
  {
    "args": [
      14
    ],
    "expected": "11131221131211131231121113112221121321132132211331222113112211"
  },
  {
    "args": [
      15
    ],
    "expected": "311311222113111231131112132112311321322112111312211312111322212311322113212221"
  },
  {
    "args": [
      16
    ],
    "expected": "132113213221133112132113311211131221121321131211132221123113112221131112311332111213211322211312113211"
  },
  {
    "args": [
      17
    ],
    "expected": "11131221131211132221232112111312212321123113112221121113122113111231133221121321132132211331121321231231121113122113322113111221131221"
  },
  {
    "args": [
      18
    ],
    "expected": "31131122211311123113321112131221123113112211121312211213211321322112311311222113311213212322211211131221131211132221232112111312111213111213211231131122212322211331222113112211"
  },
  {
    "args": [
      20
    ],
    "expected": "11131221131211132221232112111312111213111213211231132132211211131221131211221321123113213221123113112221131112311332211211131221131211132211121312211231131112311211232221121321132132211331121321231231121113112221121321133112132112312321123113112221121113122113121113123112112322111213211322211312113211"
  },
  {
    "args": [
      30
    ],
    "expected": "3113112221131112311332111213122112311311123112111331121113122112132113121113222112311311221112131221123113112221121113311211131122211211131221131211132221121321132132212321121113121112133221123113112221131112212211131221121321131211132221123113112221131112311332211211133112111311222112111312211311123113322112111312211312111322212321121113121112133221121321132132211331121321132213211231132132211211131221232112111312212221121123222112311311222113111231133211121321321122111312211312111322211213211321322123211211131211121332211231131122211311123113321112131221123113111231121123222112111331121113112221121113122113111231133221121113122113121113221112131221123113111231121123222112111312211312111322212321121113121112131112132112311321322112111312212321121113122122211211232221121321132132211331121321231231121113112221121321132132211322132113213221123113112221133112132123222112111312211312112213211231132132211211131221131211322113321132211221121332211231131122211311123113321112131221123113111231121113311211131221121321131211132221123113112211121312211231131122211211133112111311222112111312211312111322211213211321223112111311222112132113213221133122211311221122111312211312111322212321121113121112131112132112311321322112111312212321121113122122211211232221121321132132211331121321231231121113112221121321132132211322132113213221123113112221133112132123222112111312211312112213211231132132211211131221131211322113321132211221121332211213211321322113311213212312311211131122211213211331121321123123211231131122211211131221131112311332211213211321223112111311222112132113213221123123211231132132211231131122211311123113322112111312211312111322111213122112311311123112112322211213211321322113312211223113112221121113122113111231133221121321132132211331222113321112131122211332113221122112133221123113112221131112311332111213122112311311123112111331121113122112132113121113222112311311221112131221123113112221121113311211131122211211131221131211132221121321132132212321121113121112133221123113112221131112311332111213122112311311123112112322211322311311222113111231133211121312211231131112311211232221121113122113121113222123211211131221132211131221121321131211132221123113112211121312211231131122113221122112133221121321132132211331121321231231121113121113122122311311222113111231133221121113122113121113221112131221123113111231121123222112132113213221133112132123123112111312211322311211133112111312211213211311123113223112111321322123122113222122211211232221121113122113121113222123211211131211121311121321123113213221121113122123211211131221121311121312211213211321322112311311222113311213212322211211131221131211221321123113213221121113122113121113222112131112131221121321131211132221121321132132211331121321232221123113112221131112311322311211131122211213211331121321122112133221121113122113121113222123112221221321132132211231131122211331121321232221121113122113121113222123211211131211121332211213111213122112132113121113222112132113213221232112111312111213322112132113213221133112132123123112111311222112132113311213211221121332211231131122211311123113321112131221123113112221132231131122211211131221131112311332211213211321223112111311222112132113212221132221222112112322211211131221131211132221232112111312111213111213211231131112311311221122132113213221133112132123222112311311222113111231132231121113112221121321133112132112211213322112111312211312111322212321121113121112131112132112311321322112111312212321121113122122211211232221121311121312211213211312111322211213211321322123211211131211121332211213211321322113311213211322132112311321322112111312212321121113122122211211232221121321132132211331121321231231121113112221121321133112132112312321123113112221121113122113111231133221121321132122311211131122211213211321222113222122211211232221123113112221131112311332111213122112311311123112111331121113122112132113121113222112311311221112131221123113112221121113311211131122211211131221131211132221121321132132212321121113121112133221123113112221131112311332111213213211221113122113121113222112132113213221232112111312111213322112132113213221133112132123123112111312211322311211133112111312212221121123222112132113213221133112132123222113223113112221131112311332111213122112311311123112112322211211131221131211132221232112111312111213111213211231132132211211131221131211221321123113213221123113112221131112211322212322211231131122211322111312211312111322211213211321322113311213211331121113122122211211132213211231131122212322211331222113112211"
  }
]$json$::jsonb,
    'approved'
),
(
    1122,
    '最大连续 1 的个数',
    '给定一个二进制数组 nums，返回其中最大连续 1 的个数。

提示：
- 1 <= nums.length <= 10^5
- nums[i] 为 0 或 1',
    'easy',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "nums = [1, 1, 0, 1, 1, 1]",
    "output": "3"
  },
  {
    "input": "nums = [1, 0, 1, 1, 0, 1]",
    "output": "2"
  },
  {
    "input": "nums = [0]",
    "output": "0"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 0, 1, 1, 1]",
    "output": "3"
  },
  {
    "input": "nums = [1, 0, 1, 1, 0, 1]",
    "output": "2"
  },
  {
    "input": "nums = [0]",
    "output": "0"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findMaxConsecutiveOnes = function(nums) {\n};\n",
  "python": "class Solution:\n    def findMaxConsecutiveOnes(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findMaxConsecutiveOnes(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findMaxConsecutiveOnes(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findMaxConsecutiveOnes",
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
          0,
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
          0,
          1,
          1,
          0,
          1
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
        1,
        1,
        0,
        1
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
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1
      ]
    ],
    "expected": 50
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
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
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
        0,
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
        0,
        1,
        1,
        0,
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
        0,
        0,
        1,
        0,
        0
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        0,
        1,
        0,
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
        1,
        0,
        0,
        0,
        1,
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
        1,
        1,
        1,
        0
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        1,
        0,
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
        0,
        1,
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
    1123,
    '第三大的数',
    '给定一个非空整数数组 nums，返回其中第三大的数。
如果不存在第三大的数，返回最大的数。
要求答案中的数是去重后的第三大，而不是排序后数组的第 3 个元素。

提示：
- 1 <= nums.length <= 10^4
- -2^31 <= nums[i] <= 2^31 - 1',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "nums = [3, 2, 1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2]",
    "output": "2"
  },
  {
    "input": "nums = [2, 2, 3, 1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 1, 2]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 2, 1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2]",
    "output": "2"
  },
  {
    "input": "nums = [2, 2, 3, 1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 1, 2]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var thirdMax = function(nums) {\n};\n",
  "python": "class Solution:\n    def thirdMax(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int thirdMax(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int thirdMax(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "thirdMax",
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
          2
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          2,
          2,
          3,
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
  },
  {
    "args": [
      [
        3,
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
        -1,
        -2,
        -3
      ]
    ],
    "expected": -3
  },
  {
    "args": [
      [
        1,
        2,
        -2147483648
      ]
    ],
    "expected": -2147483648
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
    "expected": 3
  },
  {
    "args": [
      [
        2,
        2,
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
        2,
        3,
        3
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        10,
        20,
        30,
        40
      ]
    ],
    "expected": 20
  }
]$json$::jsonb,
    'approved'
),
(
    1124,
    '数组拆分',
    '给定长度为 2n 的整数数组 nums，将这些数分成 n 对，例如 (a1, b1), (a2, b2), ..., (an, bn)。
返回所有 min(ai, bi) 之和的最大值。

提示：
- 1 <= n <= 10^4
- nums.length == 2 * n
- -10^4 <= nums[i] <= 10^4',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序', '贪心'],
    $json$[
  {
    "input": "nums = [1, 4, 3, 2]",
    "output": "4"
  },
  {
    "input": "nums = [6, 2, 6, 5, 1, 2]",
    "output": "9"
  },
  {
    "input": "nums = [1, 2]",
    "output": "1"
  },
  {
    "input": "nums = [0, 0]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 4, 3, 2]",
    "output": "4"
  },
  {
    "input": "nums = [6, 2, 6, 5, 1, 2]",
    "output": "9"
  },
  {
    "input": "nums = [1, 2]",
    "output": "1"
  },
  {
    "input": "nums = [0, 0]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var arrayPairSum = function(nums) {\n};\n",
  "python": "class Solution:\n    def arrayPairSum(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int arrayPairSum(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int arrayPairSum(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "arrayPairSum",
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
          4,
          3,
          2
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          6,
          2,
          6,
          5,
          1,
          2
        ]
      ],
      "expected": 9
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
        -1,
        -2
      ]
    ],
    "expected": -2
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
    "expected": 2
  },
  {
    "args": [
      [
        -10000,
        10000,
        0,
        0
      ]
    ],
    "expected": -10000
  },
  {
    "args": [
      [
        9,
        8,
        7,
        6
      ]
    ],
    "expected": 14
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
    "expected": -8
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
    "expected": 4
  },
  {
    "args": [
      [
        10,
        9,
        8,
        7,
        6,
        5
      ]
    ],
    "expected": 21
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
    "expected": 2
  },
  {
    "args": [
      [
        -10,
        10,
        -20,
        20
      ]
    ],
    "expected": -10
  },
  {
    "args": [
      [
        2,
        3,
        1,
        4,
        6,
        5
      ]
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1125,
    '分发饼干',
    '假设你是一位家长，想给孩子们分发饼干。每个孩子 i 有一个胃口值 g[i]，每块饼干 j 有一个尺寸 s[j]。
如果 s[j] >= g[i]，可以满足第 i 个孩子。每个孩子最多只能拿一块饼干。
返回最多可以满足的孩子数量。

提示：
- 1 <= g.length <= 3 * 10^4
- 0 <= s.length <= 3 * 10^4
- 1 <= g[i], s[j] <= 2^31 - 1',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序', '贪心', '双指针'],
    $json$[
  {
    "input": "g = [1, 2, 3], s = [1, 1]",
    "output": "1"
  },
  {
    "input": "g = [1, 2], s = [1, 2, 3]",
    "output": "2"
  },
  {
    "input": "g = [1, 2, 3], s = [3]",
    "output": "1"
  },
  {
    "input": "g = [], s = [1, 2]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "g = [1, 2, 3], s = [1, 1]",
    "output": "1"
  },
  {
    "input": "g = [1, 2], s = [1, 2, 3]",
    "output": "2"
  },
  {
    "input": "g = [1, 2, 3], s = [3]",
    "output": "1"
  },
  {
    "input": "g = [], s = [1, 2]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findContentChildren = function(g, s) {\n};\n",
  "python": "class Solution:\n    def findContentChildren(self, g: list[int], s: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findContentChildren(std::vector<int>& g, std::vector<int>& s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findContentChildren(int[] g, int[] s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findContentChildren",
  "params": [
    {
      "name": "g",
      "type": "int[]"
    },
    {
      "name": "s",
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
          2
        ],
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
          2,
          3
        ],
        [
          3
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [],
        [
          1,
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
        1
      ],
      [
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1
      ],
      [
        0
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        10,
        9,
        8,
        7
      ],
      [
        5,
        6,
        7,
        8
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
      ],
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
      ],
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
      ],
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
        5,
        10,
        2,
        9,
        15,
        9
      ],
      [
        6,
        1,
        20,
        3,
        8
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
        1
      ]
    ],
    "expected": 1
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
    "expected": 1
  },
  {
    "args": [
      [
        3,
        4,
        5
      ],
      [
        1,
        2
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
        2
      ],
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
        10,
        9,
        8
      ],
      [
        10,
        9,
        8
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [],
      []
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1126,
    '判断子序列',
    '给定字符串 s 和 t，判断 s 是否为 t 的子序列。
子序列是原始字符串删除一些（也可以不删除）字符而不改变剩余字符相对位置形成的新字符串。

提示：
- 0 <= s.length <= 100
- 0 <= t.length <= 10^4
- 两个字符串都只由小写英文字母组成',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针', '动态规划'],
    $json$[
  {
    "input": "s = \"abc\", t = \"ahbgdc\"",
    "output": "true"
  },
  {
    "input": "s = \"axc\", t = \"ahbgdc\"",
    "output": "false"
  },
  {
    "input": "s = \"\", t = \"\"",
    "output": "true"
  },
  {
    "input": "s = \"abc\", t = \"\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abc\", t = \"ahbgdc\"",
    "output": "true"
  },
  {
    "input": "s = \"axc\", t = \"ahbgdc\"",
    "output": "false"
  },
  {
    "input": "s = \"\", t = \"\"",
    "output": "true"
  },
  {
    "input": "s = \"abc\", t = \"\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isSubsequence = function(s, t) {\n};\n",
  "python": "class Solution:\n    def isSubsequence(self, s: str, t: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isSubsequence(std::string s, std::string t) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isSubsequence(String s, String t) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isSubsequence",
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
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "abc",
        "ahbgdc"
      ],
      "expected": true
    },
    {
      "args": [
        "axc",
        "ahbgdc"
      ],
      "expected": false
    },
    {
      "args": [
        "",
        ""
      ],
      "expected": true
    },
    {
      "args": [
        "abc",
        ""
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "",
      "ahbgdc"
    ],
    "expected": true
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
      "b",
      "a"
    ],
    "expected": false
  },
  {
    "args": [
      "aaaaaa",
      "bbaaaa"
    ],
    "expected": false
  },
  {
    "args": [
      "aaaaaa",
      "aaa"
    ],
    "expected": false
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
      "acb",
      "ahbgdc"
    ],
    "expected": false
  },
  {
    "args": [
      "ab",
      "baab"
    ],
    "expected": true
  },
  {
    "args": [
      "axc",
      "abc"
    ],
    "expected": false
  },
  {
    "args": [
      "aec",
      "abcde"
    ],
    "expected": false
  },
  {
    "args": [
      "leeeeetcode",
      "yyyyylyeeeeeeeeetcode"
    ],
    "expected": true
  },
  {
    "args": [
      "abcdef",
      "abcdef"
    ],
    "expected": true
  },
  {
    "args": [
      "z",
      "abc"
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1127,
    '同构字符串',
    '给定两个字符串 s 和 t，判断它们是否是同构的。
如果 s 中的字符可以按某种映射关系替换得到 t，那么两个字符串是同构的。
每个字符都应映射到另一个字符，且没有两个字符映射到同一个字符。

提示：
- 1 <= s.length <= 5 * 10^4
- t.length == s.length',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "s = \"egg\", t = \"add\"",
    "output": "true"
  },
  {
    "input": "s = \"foo\", t = \"bar\"",
    "output": "false"
  },
  {
    "input": "s = \"paper\", t = \"title\"",
    "output": "true"
  },
  {
    "input": "s = \"badc\", t = \"baba\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"egg\", t = \"add\"",
    "output": "true"
  },
  {
    "input": "s = \"foo\", t = \"bar\"",
    "output": "false"
  },
  {
    "input": "s = \"paper\", t = \"title\"",
    "output": "true"
  },
  {
    "input": "s = \"badc\", t = \"baba\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isIsomorphic = function(s, t) {\n};\n",
  "python": "class Solution:\n    def isIsomorphic(self, s: str, t: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isIsomorphic(std::string s, std::string t) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isIsomorphic(String s, String t) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isIsomorphic",
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
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "egg",
        "add"
      ],
      "expected": true
    },
    {
      "args": [
        "foo",
        "bar"
      ],
      "expected": false
    },
    {
      "args": [
        "paper",
        "title"
      ],
      "expected": true
    },
    {
      "args": [
        "badc",
        "baba"
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
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
      "aa"
    ],
    "expected": false
  },
  {
    "args": [
      "aa",
      "ab"
    ],
    "expected": false
  },
  {
    "args": [
      "abc",
      "xyz"
    ],
    "expected": true
  },
  {
    "args": [
      "13",
      "42"
    ],
    "expected": true
  },
  {
    "args": [
      "ab",
      "ca"
    ],
    "expected": true
  },
  {
    "args": [
      "abcd",
      "abcc"
    ],
    "expected": false
  },
  {
    "args": [
      "aba",
      "baa"
    ],
    "expected": false
  },
  {
    "args": [
      "aabb",
      "ccdd"
    ],
    "expected": true
  },
  {
    "args": [
      "xyz",
      "abc"
    ],
    "expected": true
  },
  {
    "args": [
      "abcd",
      "wxyz"
    ],
    "expected": true
  },
  {
    "args": [
      "abcdefghijklmnopqrstuvwxyz",
      "abcdefghijklmnopqrstuvwxyz"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1128,
    '单词规律',
    '给定一种规律 pattern 和一个字符串 s，判断 s 是否遵循相同的规律。
这里的遵循指完全匹配：pattern 中的每个字母和字符串 s 中的每个非空单词之间存在双向对应关系。

提示：
- 1 <= pattern.length <= 300
- pattern 只包含小写英文字母
- 1 <= s.length <= 3000
- s 只包含小写英文字母和空格，单词之间用一个空格分隔',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "pattern = \"abba\", s = \"dog cat cat dog\"",
    "output": "true"
  },
  {
    "input": "pattern = \"abba\", s = \"dog cat cat fish\"",
    "output": "false"
  },
  {
    "input": "pattern = \"aaaa\", s = \"dog cat cat dog\"",
    "output": "false"
  },
  {
    "input": "pattern = \"abba\", s = \"dog dog dog dog\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "pattern = \"abba\", s = \"dog cat cat dog\"",
    "output": "true"
  },
  {
    "input": "pattern = \"abba\", s = \"dog cat cat fish\"",
    "output": "false"
  },
  {
    "input": "pattern = \"aaaa\", s = \"dog cat cat dog\"",
    "output": "false"
  },
  {
    "input": "pattern = \"abba\", s = \"dog dog dog dog\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var wordPattern = function(pattern, s) {\n};\n",
  "python": "class Solution:\n    def wordPattern(self, pattern: str, s: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool wordPattern(std::string pattern, std::string s) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean wordPattern(String pattern, String s) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "wordPattern",
  "params": [
    {
      "name": "pattern",
      "type": "string"
    },
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
        "abba",
        "dog cat cat dog"
      ],
      "expected": true
    },
    {
      "args": [
        "abba",
        "dog cat cat fish"
      ],
      "expected": false
    },
    {
      "args": [
        "aaaa",
        "dog cat cat dog"
      ],
      "expected": false
    },
    {
      "args": [
        "abba",
        "dog dog dog dog"
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      "dog"
    ],
    "expected": true
  },
  {
    "args": [
      "ab",
      "dog"
    ],
    "expected": false
  },
  {
    "args": [
      "abc",
      "b c a"
    ],
    "expected": true
  },
  {
    "args": [
      "aaa",
      "aa aa aa"
    ],
    "expected": true
  },
  {
    "args": [
      "abb",
      "dog cat cat"
    ],
    "expected": true
  },
  {
    "args": [
      "abb",
      "dog cat fish"
    ],
    "expected": false
  },
  {
    "args": [
      "abc",
      "dog dog dog"
    ],
    "expected": false
  },
  {
    "args": [
      "ab",
      "dog dog"
    ],
    "expected": false
  },
  {
    "args": [
      "abcd",
      "a b c d"
    ],
    "expected": true
  },
  {
    "args": [
      "aaaaa",
      "a b c d e"
    ],
    "expected": false
  },
  {
    "args": [
      "abab",
      "dog cat dog cat"
    ],
    "expected": true
  },
  {
    "args": [
      "aba",
      "cat dog cat"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1129,
    '字符串中的第一个唯一字符',
    '给定一个字符串 s，找到它的第一个不重复的字符，并返回它的索引。
如果不存在，返回 -1。

提示：
- 1 <= s.length <= 10^5
- s 只包含小写字母',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表', '队列'],
    $json$[
  {
    "input": "s = \"leetcode\"",
    "output": "0"
  },
  {
    "input": "s = \"loveleetcode\"",
    "output": "2"
  },
  {
    "input": "s = \"aabb\"",
    "output": "-1"
  },
  {
    "input": "s = \"z\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"leetcode\"",
    "output": "0"
  },
  {
    "input": "s = \"loveleetcode\"",
    "output": "2"
  },
  {
    "input": "s = \"aabb\"",
    "output": "-1"
  },
  {
    "input": "s = \"z\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var firstUniqChar = function(s) {\n};\n",
  "python": "class Solution:\n    def firstUniqChar(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int firstUniqChar(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int firstUniqChar(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "firstUniqChar",
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
        "leetcode"
      ],
      "expected": 0
    },
    {
      "args": [
        "loveleetcode"
      ],
      "expected": 2
    },
    {
      "args": [
        "aabb"
      ],
      "expected": -1
    },
    {
      "args": [
        "z"
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
    "expected": -1
  },
  {
    "args": [
      "a"
    ],
    "expected": 0
  },
  {
    "args": [
      "aa"
    ],
    "expected": -1
  },
  {
    "args": [
      "abcabd"
    ],
    "expected": 2
  },
  {
    "args": [
      "abcabc"
    ],
    "expected": -1
  },
  {
    "args": [
      "aabbcc"
    ],
    "expected": -1
  },
  {
    "args": [
      "abacabad"
    ],
    "expected": 3
  },
  {
    "args": [
      "eee"
    ],
    "expected": -1
  },
  {
    "args": [
      "abcde"
    ],
    "expected": 0
  },
  {
    "args": [
      "aabbc"
    ],
    "expected": 4
  },
  {
    "args": [
      "thequickbrownfox"
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1130,
    '有效的字母异位词',
    '给定两个字符串 s 和 t，判断 t 是否是 s 的字母异位词。
字母异位词指两个字符串中每个字符出现的次数都相同。

提示：
- 1 <= s.length, t.length <= 5 * 10^4
- s 和 t 仅包含小写字母',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表', '排序'],
    $json$[
  {
    "input": "s = \"anagram\", t = \"nagaram\"",
    "output": "true"
  },
  {
    "input": "s = \"rat\", t = \"car\"",
    "output": "false"
  },
  {
    "input": "s = \"a\", t = \"a\"",
    "output": "true"
  },
  {
    "input": "s = \"ab\", t = \"a\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"anagram\", t = \"nagaram\"",
    "output": "true"
  },
  {
    "input": "s = \"rat\", t = \"car\"",
    "output": "false"
  },
  {
    "input": "s = \"a\", t = \"a\"",
    "output": "true"
  },
  {
    "input": "s = \"ab\", t = \"a\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isAnagram = function(s, t) {\n};\n",
  "python": "class Solution:\n    def isAnagram(self, s: str, t: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isAnagram(std::string s, std::string t) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isAnagram(String s, String t) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isAnagram",
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
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "anagram",
        "nagaram"
      ],
      "expected": true
    },
    {
      "args": [
        "rat",
        "car"
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
        "a"
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "",
      ""
    ],
    "expected": true
  },
  {
    "args": [
      "a",
      ""
    ],
    "expected": false
  },
  {
    "args": [
      "abc",
      "cba"
    ],
    "expected": true
  },
  {
    "args": [
      "aacc",
      "ccac"
    ],
    "expected": false
  },
  {
    "args": [
      "listen",
      "silent"
    ],
    "expected": true
  },
  {
    "args": [
      "你好",
      "好你"
    ],
    "expected": true
  },
  {
    "args": [
      "abc",
      "ab"
    ],
    "expected": false
  },
  {
    "args": [
      "aaab",
      "abaa"
    ],
    "expected": true
  },
  {
    "args": [
      "abcde",
      "edcba"
    ],
    "expected": true
  },
  {
    "args": [
      "aab",
      "abb"
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1131,
    '赎金信',
    '给定两个字符串 ransomNote 和 magazine，判断 ransomNote 能否由 magazine 中的字母构成。
magazine 中的每个字母只能在 ransomNote 中使用一次。

提示：
- 1 <= ransomNote.length, magazine.length <= 10^5
- 两个字符串均由小写英文字母组成',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表', '计数'],
    $json$[
  {
    "input": "ransomNote = \"a\", magazine = \"b\"",
    "output": "false"
  },
  {
    "input": "ransomNote = \"aa\", magazine = \"ab\"",
    "output": "false"
  },
  {
    "input": "ransomNote = \"aa\", magazine = \"aab\"",
    "output": "true"
  },
  {
    "input": "ransomNote = \"abc\", magazine = \"ab\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "ransomNote = \"a\", magazine = \"b\"",
    "output": "false"
  },
  {
    "input": "ransomNote = \"aa\", magazine = \"ab\"",
    "output": "false"
  },
  {
    "input": "ransomNote = \"aa\", magazine = \"aab\"",
    "output": "true"
  },
  {
    "input": "ransomNote = \"abc\", magazine = \"ab\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canConstruct = function(ransomNote, magazine) {\n};\n",
  "python": "class Solution:\n    def canConstruct(self, ransomNote: str, magazine: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canConstruct(std::string ransomNote, std::string magazine) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canConstruct(String ransomNote, String magazine) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canConstruct",
  "params": [
    {
      "name": "ransomNote",
      "type": "string"
    },
    {
      "name": "magazine",
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
        "a",
        "b"
      ],
      "expected": false
    },
    {
      "args": [
        "aa",
        "ab"
      ],
      "expected": false
    },
    {
      "args": [
        "aa",
        "aab"
      ],
      "expected": true
    },
    {
      "args": [
        "abc",
        "ab"
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "",
      ""
    ],
    "expected": true
  },
  {
    "args": [
      "",
      "a"
    ],
    "expected": true
  },
  {
    "args": [
      "a",
      ""
    ],
    "expected": false
  },
  {
    "args": [
      "aa",
      "aa"
    ],
    "expected": true
  },
  {
    "args": [
      "aab",
      "baa"
    ],
    "expected": true
  },
  {
    "args": [
      "abcdef",
      "fedcba"
    ],
    "expected": true
  },
  {
    "args": [
      "aabb",
      "ababab"
    ],
    "expected": true
  },
  {
    "args": [
      "helloworld",
      "hello"
    ],
    "expected": false
  },
  {
    "args": [
      "xyz",
      "zyx"
    ],
    "expected": true
  },
  {
    "args": [
      "aaa",
      "aaaa"
    ],
    "expected": true
  },
  {
    "args": [
      "aa",
      "aaa"
    ],
    "expected": true
  },
  {
    "args": [
      "abc",
      "abcabc"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1132,
    '最长回文串',
    '给定一个包含大写字母和小写字母的字符串 s，返回由这些字母能构成的最长回文串的长度。
字母区分大小写。

提示：
- 1 <= s.length <= 2000
- s 只包含大小写英文字母',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表', '贪心'],
    $json$[
  {
    "input": "s = \"abccccdd\"",
    "output": "7"
  },
  {
    "input": "s = \"a\"",
    "output": "1"
  },
  {
    "input": "s = \"bb\"",
    "output": "2"
  },
  {
    "input": "s = \"ab\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abccccdd\"",
    "output": "7"
  },
  {
    "input": "s = \"a\"",
    "output": "1"
  },
  {
    "input": "s = \"bb\"",
    "output": "2"
  },
  {
    "input": "s = \"ab\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestPalindrome = function(s) {\n};\n",
  "python": "class Solution:\n    def longestPalindrome(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestPalindrome(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestPalindrome(String s) {\n        return 0;\n    }\n}\n"
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
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "abccccdd"
      ],
      "expected": 7
    },
    {
      "args": [
        "a"
      ],
      "expected": 1
    },
    {
      "args": [
        "bb"
      ],
      "expected": 2
    },
    {
      "args": [
        "ab"
      ],
      "expected": 1
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
      "ccc"
    ],
    "expected": 3
  },
  {
    "args": [
      "AaA"
    ],
    "expected": 3
  },
  {
    "args": [
      "aaaa"
    ],
    "expected": 4
  },
  {
    "args": [
      "aabbcc"
    ],
    "expected": 6
  },
  {
    "args": [
      "abababab"
    ],
    "expected": 8
  },
  {
    "args": [
      "bananas"
    ],
    "expected": 5
  },
  {
    "args": [
      "racecar"
    ],
    "expected": 7
  },
  {
    "args": [
      "abcde"
    ],
    "expected": 1
  },
  {
    "args": [
      "aaabbbccc"
    ],
    "expected": 7
  }
]$json$::jsonb,
    'approved'
),
(
    1133,
    '斐波那契数',
    '斐波那契数通常用 F(n) 表示，形成的数列满足 F(0) = 0，F(1) = 1，F(n) = F(n - 1) + F(n - 2)（n > 1）。
给定 n，计算 F(n)。

提示：
- 0 <= n <= 30',
    'easy',
    1000,
    256,
    ARRAY['数学', '动态规划', '递归'],
    $json$[
  {
    "input": "n = 2",
    "output": "1"
  },
  {
    "input": "n = 3",
    "output": "2"
  },
  {
    "input": "n = 4",
    "output": "3"
  },
  {
    "input": "n = 10",
    "output": "55"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 2",
    "output": "1"
  },
  {
    "input": "n = 3",
    "output": "2"
  },
  {
    "input": "n = 4",
    "output": "3"
  },
  {
    "input": "n = 10",
    "output": "55"
  }
]$json$::jsonb,
    $json${
  "javascript": "var fib = function(n) {\n};\n",
  "python": "class Solution:\n    def fib(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int fib(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int fib(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "fib",
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
        4
      ],
      "expected": 3
    },
    {
      "args": [
        10
      ],
      "expected": 55
    }
  ]
}$json$::jsonb,
    $json$[
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
      5
    ],
    "expected": 5
  },
  {
    "args": [
      6
    ],
    "expected": 8
  },
  {
    "args": [
      7
    ],
    "expected": 13
  },
  {
    "args": [
      8
    ],
    "expected": 21
  },
  {
    "args": [
      15
    ],
    "expected": 610
  },
  {
    "args": [
      20
    ],
    "expected": 6765
  },
  {
    "args": [
      25
    ],
    "expected": 75025
  },
  {
    "args": [
      30
    ],
    "expected": 832040
  }
]$json$::jsonb,
    'approved'
),
(
    1134,
    '爬楼梯',
    '假设你正在爬楼梯，需要 n 阶才能到达楼顶。
每次可以爬 1 或 2 个台阶，有多少种不同的方法可以爬到楼顶？

提示：
- 1 <= n <= 45',
    'easy',
    1000,
    256,
    ARRAY['数学', '动态规划', '记忆化搜索'],
    $json$[
  {
    "input": "n = 2",
    "output": "2"
  },
  {
    "input": "n = 3",
    "output": "3"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 5",
    "output": "8"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 2",
    "output": "2"
  },
  {
    "input": "n = 3",
    "output": "3"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 5",
    "output": "8"
  }
]$json$::jsonb,
    $json${
  "javascript": "var climbStairs = function(n) {\n};\n",
  "python": "class Solution:\n    def climbStairs(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int climbStairs(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int climbStairs(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "climbStairs",
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
        2
      ],
      "expected": 2
    },
    {
      "args": [
        3
      ],
      "expected": 3
    },
    {
      "args": [
        1
      ],
      "expected": 1
    },
    {
      "args": [
        5
      ],
      "expected": 8
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      4
    ],
    "expected": 5
  },
  {
    "args": [
      6
    ],
    "expected": 13
  },
  {
    "args": [
      10
    ],
    "expected": 89
  },
  {
    "args": [
      12
    ],
    "expected": 233
  },
  {
    "args": [
      15
    ],
    "expected": 987
  },
  {
    "args": [
      20
    ],
    "expected": 10946
  },
  {
    "args": [
      25
    ],
    "expected": 121393
  },
  {
    "args": [
      30
    ],
    "expected": 1346269
  },
  {
    "args": [
      40
    ],
    "expected": 165580141
  },
  {
    "args": [
      45
    ],
    "expected": 1836311903
  }
]$json$::jsonb,
    'approved'
),
(
    1135,
    '使用最小花费爬楼梯',
    '给定一个整数数组 cost，其中 cost[i] 是从楼梯第 i 个台阶向上爬需要支付的费用。
一旦支付费用，就可以选择向上爬一个或两个台阶。
可以从下标 0 或下标 1 的台阶开始，返回达到楼梯顶部的最低花费。

提示：
- 2 <= cost.length <= 1000
- 0 <= cost[i] <= 999',
    'easy',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "cost = [10, 15, 20]",
    "output": "15"
  },
  {
    "input": "cost = [1, 100, 1, 1, 1, 100, 1, 1, 100, 1]",
    "output": "6"
  },
  {
    "input": "cost = [0, 0]",
    "output": "0"
  },
  {
    "input": "cost = [10, 15, 20, 25]",
    "output": "30"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "cost = [10, 15, 20]",
    "output": "15"
  },
  {
    "input": "cost = [1, 100, 1, 1, 1, 100, 1, 1, 100, 1]",
    "output": "6"
  },
  {
    "input": "cost = [0, 0]",
    "output": "0"
  },
  {
    "input": "cost = [10, 15, 20, 25]",
    "output": "30"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minCostClimbingStairs = function(cost) {\n};\n",
  "python": "class Solution:\n    def minCostClimbingStairs(self, cost: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minCostClimbingStairs(std::vector<int>& cost) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minCostClimbingStairs(int[] cost) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minCostClimbingStairs",
  "params": [
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
          10,
          15,
          20
        ]
      ],
      "expected": 15
    },
    {
      "args": [
        [
          1,
          100,
          1,
          1,
          1,
          100,
          1,
          1,
          100,
          1
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          0,
          0
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          10,
          15,
          20,
          25
        ]
      ],
      "expected": 30
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        100
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
    "expected": 4
  },
  {
    "args": [
      [
        5,
        5
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        0,
        5,
        0
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        999,
        0,
        999
      ]
    ],
    "expected": 0
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
        2,
        3,
        4,
        5,
        6
      ]
    ],
    "expected": 8
  },
  {
    "args": [
      [
        10,
        1,
        10,
        1,
        10
      ]
    ],
    "expected": 2
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
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1136,
    '买卖股票的最佳时机',
    '给定一个数组 prices，它的第 i 个元素表示第 i 天的股票价格。
只能选择某一天买入并在未来的某一天卖出，返回能获取的最大利润。
如果无法获取利润，返回 0。

提示：
- 1 <= prices.length <= 10^5
- 0 <= prices[i] <= 10^4',
    'easy',
    1000,
    256,
    ARRAY['数组', '动态规划', '贪心'],
    $json$[
  {
    "input": "prices = [7, 1, 5, 3, 6, 4]",
    "output": "5"
  },
  {
    "input": "prices = [7, 6, 4, 3, 1]",
    "output": "0"
  },
  {
    "input": "prices = [1]",
    "output": "0"
  },
  {
    "input": "prices = [2, 4, 1]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "prices = [7, 1, 5, 3, 6, 4]",
    "output": "5"
  },
  {
    "input": "prices = [7, 6, 4, 3, 1]",
    "output": "0"
  },
  {
    "input": "prices = [1]",
    "output": "0"
  },
  {
    "input": "prices = [2, 4, 1]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxProfit = function(prices) {\n};\n",
  "python": "class Solution:\n    def maxProfit(self, prices: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxProfit(std::vector<int>& prices) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxProfit(int[] prices) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxProfit",
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
          7,
          1,
          5,
          3,
          6,
          4
        ]
      ],
      "expected": 5
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
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      []
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
      ]
    ],
    "expected": 4
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
        2,
        1,
        2,
        0,
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
    "expected": 8
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
    "expected": 6
  },
  {
    "args": [
      [
        10,
        9,
        8,
        7,
        6,
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
        2,
        4,
        1,
        7,
        3,
        8
      ]
    ],
    "expected": 7
  }
]$json$::jsonb,
    'approved'
),
(
    1137,
    '杨辉三角',
    '给定一个非负整数 numRows，生成杨辉三角的前 numRows 行。
每个数是它左上方和右上方的数之和，边界数字为 1。

提示：
- 1 <= numRows <= 30',
    'easy',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "numRows = 5",
    "output": "[[1], [1, 1], [1, 2, 1], [1, 3, 3, 1], [1, 4, 6, 4, 1]]"
  },
  {
    "input": "numRows = 1",
    "output": "[[1]]"
  },
  {
    "input": "numRows = 3",
    "output": "[[1], [1, 1], [1, 2, 1]]"
  },
  {
    "input": "numRows = 6",
    "output": "[[1], [1, 1], [1, 2, 1], [1, 3, 3, 1], [1, 4, 6, 4, 1], [1, 5, 10, 10, 5, 1]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "numRows = 5",
    "output": "[[1], [1, 1], [1, 2, 1], [1, 3, 3, 1], [1, 4, 6, 4, 1]]"
  },
  {
    "input": "numRows = 1",
    "output": "[[1]]"
  },
  {
    "input": "numRows = 3",
    "output": "[[1], [1, 1], [1, 2, 1]]"
  },
  {
    "input": "numRows = 6",
    "output": "[[1], [1, 1], [1, 2, 1], [1, 3, 3, 1], [1, 4, 6, 4, 1], [1, 5, 10, 10, 5, 1]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var generate = function(numRows) {\n};\n",
  "python": "class Solution:\n    def generate(self, numRows: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> generate(int numRows) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] generate(int numRows) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "generate",
  "params": [
    {
      "name": "numRows",
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
        5
      ],
      "expected": [
        [
          1
        ],
        [
          1,
          1
        ],
        [
          1,
          2,
          1
        ],
        [
          1,
          3,
          3,
          1
        ],
        [
          1,
          4,
          6,
          4,
          1
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
        3
      ],
      "expected": [
        [
          1
        ],
        [
          1,
          1
        ],
        [
          1,
          2,
          1
        ]
      ]
    },
    {
      "args": [
        6
      ],
      "expected": [
        [
          1
        ],
        [
          1,
          1
        ],
        [
          1,
          2,
          1
        ],
        [
          1,
          3,
          3,
          1
        ],
        [
          1,
          4,
          6,
          4,
          1
        ],
        [
          1,
          5,
          10,
          10,
          5,
          1
        ]
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
      [
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
      4
    ],
    "expected": [
      [
        1
      ],
      [
        1,
        1
      ],
      [
        1,
        2,
        1
      ],
      [
        1,
        3,
        3,
        1
      ]
    ]
  },
  {
    "args": [
      7
    ],
    "expected": [
      [
        1
      ],
      [
        1,
        1
      ],
      [
        1,
        2,
        1
      ],
      [
        1,
        3,
        3,
        1
      ],
      [
        1,
        4,
        6,
        4,
        1
      ],
      [
        1,
        5,
        10,
        10,
        5,
        1
      ],
      [
        1,
        6,
        15,
        20,
        15,
        6,
        1
      ]
    ]
  },
  {
    "args": [
      8
    ],
    "expected": [
      [
        1
      ],
      [
        1,
        1
      ],
      [
        1,
        2,
        1
      ],
      [
        1,
        3,
        3,
        1
      ],
      [
        1,
        4,
        6,
        4,
        1
      ],
      [
        1,
        5,
        10,
        10,
        5,
        1
      ],
      [
        1,
        6,
        15,
        20,
        15,
        6,
        1
      ],
      [
        1,
        7,
        21,
        35,
        35,
        21,
        7,
        1
      ]
    ]
  },
  {
    "args": [
      9
    ],
    "expected": [
      [
        1
      ],
      [
        1,
        1
      ],
      [
        1,
        2,
        1
      ],
      [
        1,
        3,
        3,
        1
      ],
      [
        1,
        4,
        6,
        4,
        1
      ],
      [
        1,
        5,
        10,
        10,
        5,
        1
      ],
      [
        1,
        6,
        15,
        20,
        15,
        6,
        1
      ],
      [
        1,
        7,
        21,
        35,
        35,
        21,
        7,
        1
      ],
      [
        1,
        8,
        28,
        56,
        70,
        56,
        28,
        8,
        1
      ]
    ]
  },
  {
    "args": [
      10
    ],
    "expected": [
      [
        1
      ],
      [
        1,
        1
      ],
      [
        1,
        2,
        1
      ],
      [
        1,
        3,
        3,
        1
      ],
      [
        1,
        4,
        6,
        4,
        1
      ],
      [
        1,
        5,
        10,
        10,
        5,
        1
      ],
      [
        1,
        6,
        15,
        20,
        15,
        6,
        1
      ],
      [
        1,
        7,
        21,
        35,
        35,
        21,
        7,
        1
      ],
      [
        1,
        8,
        28,
        56,
        70,
        56,
        28,
        8,
        1
      ],
      [
        1,
        9,
        36,
        84,
        126,
        126,
        84,
        36,
        9,
        1
      ]
    ]
  },
  {
    "args": [
      12
    ],
    "expected": [
      [
        1
      ],
      [
        1,
        1
      ],
      [
        1,
        2,
        1
      ],
      [
        1,
        3,
        3,
        1
      ],
      [
        1,
        4,
        6,
        4,
        1
      ],
      [
        1,
        5,
        10,
        10,
        5,
        1
      ],
      [
        1,
        6,
        15,
        20,
        15,
        6,
        1
      ],
      [
        1,
        7,
        21,
        35,
        35,
        21,
        7,
        1
      ],
      [
        1,
        8,
        28,
        56,
        70,
        56,
        28,
        8,
        1
      ],
      [
        1,
        9,
        36,
        84,
        126,
        126,
        84,
        36,
        9,
        1
      ],
      [
        1,
        10,
        45,
        120,
        210,
        252,
        210,
        120,
        45,
        10,
        1
      ],
      [
        1,
        11,
        55,
        165,
        330,
        462,
        462,
        330,
        165,
        55,
        11,
        1
      ]
    ]
  },
  {
    "args": [
      15
    ],
    "expected": [
      [
        1
      ],
      [
        1,
        1
      ],
      [
        1,
        2,
        1
      ],
      [
        1,
        3,
        3,
        1
      ],
      [
        1,
        4,
        6,
        4,
        1
      ],
      [
        1,
        5,
        10,
        10,
        5,
        1
      ],
      [
        1,
        6,
        15,
        20,
        15,
        6,
        1
      ],
      [
        1,
        7,
        21,
        35,
        35,
        21,
        7,
        1
      ],
      [
        1,
        8,
        28,
        56,
        70,
        56,
        28,
        8,
        1
      ],
      [
        1,
        9,
        36,
        84,
        126,
        126,
        84,
        36,
        9,
        1
      ],
      [
        1,
        10,
        45,
        120,
        210,
        252,
        210,
        120,
        45,
        10,
        1
      ],
      [
        1,
        11,
        55,
        165,
        330,
        462,
        462,
        330,
        165,
        55,
        11,
        1
      ],
      [
        1,
        12,
        66,
        220,
        495,
        792,
        924,
        792,
        495,
        220,
        66,
        12,
        1
      ],
      [
        1,
        13,
        78,
        286,
        715,
        1287,
        1716,
        1716,
        1287,
        715,
        286,
        78,
        13,
        1
      ],
      [
        1,
        14,
        91,
        364,
        1001,
        2002,
        3003,
        3432,
        3003,
        2002,
        1001,
        364,
        91,
        14,
        1
      ]
    ]
  },
  {
    "args": [
      20
    ],
    "expected": [
      [
        1
      ],
      [
        1,
        1
      ],
      [
        1,
        2,
        1
      ],
      [
        1,
        3,
        3,
        1
      ],
      [
        1,
        4,
        6,
        4,
        1
      ],
      [
        1,
        5,
        10,
        10,
        5,
        1
      ],
      [
        1,
        6,
        15,
        20,
        15,
        6,
        1
      ],
      [
        1,
        7,
        21,
        35,
        35,
        21,
        7,
        1
      ],
      [
        1,
        8,
        28,
        56,
        70,
        56,
        28,
        8,
        1
      ],
      [
        1,
        9,
        36,
        84,
        126,
        126,
        84,
        36,
        9,
        1
      ],
      [
        1,
        10,
        45,
        120,
        210,
        252,
        210,
        120,
        45,
        10,
        1
      ],
      [
        1,
        11,
        55,
        165,
        330,
        462,
        462,
        330,
        165,
        55,
        11,
        1
      ],
      [
        1,
        12,
        66,
        220,
        495,
        792,
        924,
        792,
        495,
        220,
        66,
        12,
        1
      ],
      [
        1,
        13,
        78,
        286,
        715,
        1287,
        1716,
        1716,
        1287,
        715,
        286,
        78,
        13,
        1
      ],
      [
        1,
        14,
        91,
        364,
        1001,
        2002,
        3003,
        3432,
        3003,
        2002,
        1001,
        364,
        91,
        14,
        1
      ],
      [
        1,
        15,
        105,
        455,
        1365,
        3003,
        5005,
        6435,
        6435,
        5005,
        3003,
        1365,
        455,
        105,
        15,
        1
      ],
      [
        1,
        16,
        120,
        560,
        1820,
        4368,
        8008,
        11440,
        12870,
        11440,
        8008,
        4368,
        1820,
        560,
        120,
        16,
        1
      ],
      [
        1,
        17,
        136,
        680,
        2380,
        6188,
        12376,
        19448,
        24310,
        24310,
        19448,
        12376,
        6188,
        2380,
        680,
        136,
        17,
        1
      ],
      [
        1,
        18,
        153,
        816,
        3060,
        8568,
        18564,
        31824,
        43758,
        48620,
        43758,
        31824,
        18564,
        8568,
        3060,
        816,
        153,
        18,
        1
      ],
      [
        1,
        19,
        171,
        969,
        3876,
        11628,
        27132,
        50388,
        75582,
        92378,
        92378,
        75582,
        50388,
        27132,
        11628,
        3876,
        969,
        171,
        19,
        1
      ]
    ]
  },
  {
    "args": [
      25
    ],
    "expected": [
      [
        1
      ],
      [
        1,
        1
      ],
      [
        1,
        2,
        1
      ],
      [
        1,
        3,
        3,
        1
      ],
      [
        1,
        4,
        6,
        4,
        1
      ],
      [
        1,
        5,
        10,
        10,
        5,
        1
      ],
      [
        1,
        6,
        15,
        20,
        15,
        6,
        1
      ],
      [
        1,
        7,
        21,
        35,
        35,
        21,
        7,
        1
      ],
      [
        1,
        8,
        28,
        56,
        70,
        56,
        28,
        8,
        1
      ],
      [
        1,
        9,
        36,
        84,
        126,
        126,
        84,
        36,
        9,
        1
      ],
      [
        1,
        10,
        45,
        120,
        210,
        252,
        210,
        120,
        45,
        10,
        1
      ],
      [
        1,
        11,
        55,
        165,
        330,
        462,
        462,
        330,
        165,
        55,
        11,
        1
      ],
      [
        1,
        12,
        66,
        220,
        495,
        792,
        924,
        792,
        495,
        220,
        66,
        12,
        1
      ],
      [
        1,
        13,
        78,
        286,
        715,
        1287,
        1716,
        1716,
        1287,
        715,
        286,
        78,
        13,
        1
      ],
      [
        1,
        14,
        91,
        364,
        1001,
        2002,
        3003,
        3432,
        3003,
        2002,
        1001,
        364,
        91,
        14,
        1
      ],
      [
        1,
        15,
        105,
        455,
        1365,
        3003,
        5005,
        6435,
        6435,
        5005,
        3003,
        1365,
        455,
        105,
        15,
        1
      ],
      [
        1,
        16,
        120,
        560,
        1820,
        4368,
        8008,
        11440,
        12870,
        11440,
        8008,
        4368,
        1820,
        560,
        120,
        16,
        1
      ],
      [
        1,
        17,
        136,
        680,
        2380,
        6188,
        12376,
        19448,
        24310,
        24310,
        19448,
        12376,
        6188,
        2380,
        680,
        136,
        17,
        1
      ],
      [
        1,
        18,
        153,
        816,
        3060,
        8568,
        18564,
        31824,
        43758,
        48620,
        43758,
        31824,
        18564,
        8568,
        3060,
        816,
        153,
        18,
        1
      ],
      [
        1,
        19,
        171,
        969,
        3876,
        11628,
        27132,
        50388,
        75582,
        92378,
        92378,
        75582,
        50388,
        27132,
        11628,
        3876,
        969,
        171,
        19,
        1
      ],
      [
        1,
        20,
        190,
        1140,
        4845,
        15504,
        38760,
        77520,
        125970,
        167960,
        184756,
        167960,
        125970,
        77520,
        38760,
        15504,
        4845,
        1140,
        190,
        20,
        1
      ],
      [
        1,
        21,
        210,
        1330,
        5985,
        20349,
        54264,
        116280,
        203490,
        293930,
        352716,
        352716,
        293930,
        203490,
        116280,
        54264,
        20349,
        5985,
        1330,
        210,
        21,
        1
      ],
      [
        1,
        22,
        231,
        1540,
        7315,
        26334,
        74613,
        170544,
        319770,
        497420,
        646646,
        705432,
        646646,
        497420,
        319770,
        170544,
        74613,
        26334,
        7315,
        1540,
        231,
        22,
        1
      ],
      [
        1,
        23,
        253,
        1771,
        8855,
        33649,
        100947,
        245157,
        490314,
        817190,
        1144066,
        1352078,
        1352078,
        1144066,
        817190,
        490314,
        245157,
        100947,
        33649,
        8855,
        1771,
        253,
        23,
        1
      ],
      [
        1,
        24,
        276,
        2024,
        10626,
        42504,
        134596,
        346104,
        735471,
        1307504,
        1961256,
        2496144,
        2704156,
        2496144,
        1961256,
        1307504,
        735471,
        346104,
        134596,
        42504,
        10626,
        2024,
        276,
        24,
        1
      ]
    ]
  },
  {
    "args": [
      30
    ],
    "expected": [
      [
        1
      ],
      [
        1,
        1
      ],
      [
        1,
        2,
        1
      ],
      [
        1,
        3,
        3,
        1
      ],
      [
        1,
        4,
        6,
        4,
        1
      ],
      [
        1,
        5,
        10,
        10,
        5,
        1
      ],
      [
        1,
        6,
        15,
        20,
        15,
        6,
        1
      ],
      [
        1,
        7,
        21,
        35,
        35,
        21,
        7,
        1
      ],
      [
        1,
        8,
        28,
        56,
        70,
        56,
        28,
        8,
        1
      ],
      [
        1,
        9,
        36,
        84,
        126,
        126,
        84,
        36,
        9,
        1
      ],
      [
        1,
        10,
        45,
        120,
        210,
        252,
        210,
        120,
        45,
        10,
        1
      ],
      [
        1,
        11,
        55,
        165,
        330,
        462,
        462,
        330,
        165,
        55,
        11,
        1
      ],
      [
        1,
        12,
        66,
        220,
        495,
        792,
        924,
        792,
        495,
        220,
        66,
        12,
        1
      ],
      [
        1,
        13,
        78,
        286,
        715,
        1287,
        1716,
        1716,
        1287,
        715,
        286,
        78,
        13,
        1
      ],
      [
        1,
        14,
        91,
        364,
        1001,
        2002,
        3003,
        3432,
        3003,
        2002,
        1001,
        364,
        91,
        14,
        1
      ],
      [
        1,
        15,
        105,
        455,
        1365,
        3003,
        5005,
        6435,
        6435,
        5005,
        3003,
        1365,
        455,
        105,
        15,
        1
      ],
      [
        1,
        16,
        120,
        560,
        1820,
        4368,
        8008,
        11440,
        12870,
        11440,
        8008,
        4368,
        1820,
        560,
        120,
        16,
        1
      ],
      [
        1,
        17,
        136,
        680,
        2380,
        6188,
        12376,
        19448,
        24310,
        24310,
        19448,
        12376,
        6188,
        2380,
        680,
        136,
        17,
        1
      ],
      [
        1,
        18,
        153,
        816,
        3060,
        8568,
        18564,
        31824,
        43758,
        48620,
        43758,
        31824,
        18564,
        8568,
        3060,
        816,
        153,
        18,
        1
      ],
      [
        1,
        19,
        171,
        969,
        3876,
        11628,
        27132,
        50388,
        75582,
        92378,
        92378,
        75582,
        50388,
        27132,
        11628,
        3876,
        969,
        171,
        19,
        1
      ],
      [
        1,
        20,
        190,
        1140,
        4845,
        15504,
        38760,
        77520,
        125970,
        167960,
        184756,
        167960,
        125970,
        77520,
        38760,
        15504,
        4845,
        1140,
        190,
        20,
        1
      ],
      [
        1,
        21,
        210,
        1330,
        5985,
        20349,
        54264,
        116280,
        203490,
        293930,
        352716,
        352716,
        293930,
        203490,
        116280,
        54264,
        20349,
        5985,
        1330,
        210,
        21,
        1
      ],
      [
        1,
        22,
        231,
        1540,
        7315,
        26334,
        74613,
        170544,
        319770,
        497420,
        646646,
        705432,
        646646,
        497420,
        319770,
        170544,
        74613,
        26334,
        7315,
        1540,
        231,
        22,
        1
      ],
      [
        1,
        23,
        253,
        1771,
        8855,
        33649,
        100947,
        245157,
        490314,
        817190,
        1144066,
        1352078,
        1352078,
        1144066,
        817190,
        490314,
        245157,
        100947,
        33649,
        8855,
        1771,
        253,
        23,
        1
      ],
      [
        1,
        24,
        276,
        2024,
        10626,
        42504,
        134596,
        346104,
        735471,
        1307504,
        1961256,
        2496144,
        2704156,
        2496144,
        1961256,
        1307504,
        735471,
        346104,
        134596,
        42504,
        10626,
        2024,
        276,
        24,
        1
      ],
      [
        1,
        25,
        300,
        2300,
        12650,
        53130,
        177100,
        480700,
        1081575,
        2042975,
        3268760,
        4457400,
        5200300,
        5200300,
        4457400,
        3268760,
        2042975,
        1081575,
        480700,
        177100,
        53130,
        12650,
        2300,
        300,
        25,
        1
      ],
      [
        1,
        26,
        325,
        2600,
        14950,
        65780,
        230230,
        657800,
        1562275,
        3124550,
        5311735,
        7726160,
        9657700,
        10400600,
        9657700,
        7726160,
        5311735,
        3124550,
        1562275,
        657800,
        230230,
        65780,
        14950,
        2600,
        325,
        26,
        1
      ],
      [
        1,
        27,
        351,
        2925,
        17550,
        80730,
        296010,
        888030,
        2220075,
        4686825,
        8436285,
        13037895,
        17383860,
        20058300,
        20058300,
        17383860,
        13037895,
        8436285,
        4686825,
        2220075,
        888030,
        296010,
        80730,
        17550,
        2925,
        351,
        27,
        1
      ],
      [
        1,
        28,
        378,
        3276,
        20475,
        98280,
        376740,
        1184040,
        3108105,
        6906900,
        13123110,
        21474180,
        30421755,
        37442160,
        40116600,
        37442160,
        30421755,
        21474180,
        13123110,
        6906900,
        3108105,
        1184040,
        376740,
        98280,
        20475,
        3276,
        378,
        28,
        1
      ],
      [
        1,
        29,
        406,
        3654,
        23751,
        118755,
        475020,
        1560780,
        4292145,
        10015005,
        20030010,
        34597290,
        51895935,
        67863915,
        77558760,
        77558760,
        67863915,
        51895935,
        34597290,
        20030010,
        10015005,
        4292145,
        1560780,
        475020,
        118755,
        23751,
        3654,
        406,
        29,
        1
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1138,
    '矩阵对角线元素的和',
    '给定一个 n x n 的整数矩阵 mat，返回 mat 的主对角线和副对角线上的元素之和。
主对角线是从左上到右下，副对角线是从右上到左下。两条对角线相交的元素只计算一次。

提示：
- 1 <= mat.length <= 100
- mat[i].length == mat.length',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵'],
    $json$[
  {
    "input": "mat = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]",
    "output": "25"
  },
  {
    "input": "mat = [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]]",
    "output": "8"
  },
  {
    "input": "mat = [[1]]",
    "output": "1"
  },
  {
    "input": "mat = [[5, 6], [7, 8]]",
    "output": "26"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mat = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]",
    "output": "25"
  },
  {
    "input": "mat = [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]]",
    "output": "8"
  },
  {
    "input": "mat = [[1]]",
    "output": "1"
  },
  {
    "input": "mat = [[5, 6], [7, 8]]",
    "output": "26"
  }
]$json$::jsonb,
    $json${
  "javascript": "var diagonalSum = function(mat) {\n};\n",
  "python": "class Solution:\n    def diagonalSum(self, mat: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int diagonalSum(std::vector<std::vector<int>>& mat) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int diagonalSum(int[][] mat) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "diagonalSum",
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
      "expected": 25
    },
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
            1,
            1,
            1,
            1
          ],
          [
            1,
            1,
            1,
            1
          ],
          [
            1,
            1,
            1,
            1
          ]
        ]
      ],
      "expected": 8
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
            5,
            6
          ],
          [
            7,
            8
          ]
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
  },
  {
    "args": [
      [
        [
          2,
          0,
          0,
          0
        ],
        [
          0,
          3,
          0,
          0
        ],
        [
          0,
          0,
          4,
          0
        ],
        [
          0,
          0,
          0,
          5
        ]
      ]
    ],
    "expected": 14
  },
  {
    "args": [
      [
        [
          10,
          20,
          30,
          40,
          50
        ],
        [
          1,
          2,
          3,
          4,
          5
        ],
        [
          5,
          4,
          3,
          2,
          1
        ],
        [
          9,
          8,
          7,
          6,
          5
        ],
        [
          2,
          4,
          6,
          8,
          10
        ]
      ]
    ],
    "expected": 95
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
          -1
        ]
      ]
    ],
    "expected": -1
  }
]$json$::jsonb,
    'approved'
),
(
    1139,
    '转置矩阵',
    '给定一个 m x n 的二维整数数组 matrix，返回它的转置矩阵。
转置矩阵是将原矩阵的行和列互换得到的矩阵。

提示：
- 1 <= m, n <= 1000
- 1 <= m * n <= 10^5',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵', '模拟'],
    $json$[
  {
    "input": "matrix = [[1, 2, 3], [4, 5, 6]]",
    "output": "[[1, 4], [2, 5], [3, 6]]"
  },
  {
    "input": "matrix = [[1, 2], [3, 4]]",
    "output": "[[1, 3], [2, 4]]"
  },
  {
    "input": "matrix = [[1]]",
    "output": "[[1]]"
  },
  {
    "input": "matrix = [[1, 2, 3]]",
    "output": "[[1], [2], [3]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 2, 3], [4, 5, 6]]",
    "output": "[[1, 4], [2, 5], [3, 6]]"
  },
  {
    "input": "matrix = [[1, 2], [3, 4]]",
    "output": "[[1, 3], [2, 4]]"
  },
  {
    "input": "matrix = [[1]]",
    "output": "[[1]]"
  },
  {
    "input": "matrix = [[1, 2, 3]]",
    "output": "[[1], [2], [3]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var transpose = function(matrix) {\n};\n",
  "python": "class Solution:\n    def transpose(self, matrix: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> transpose(std::vector<std::vector<int>>& matrix) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] transpose(int[][] matrix) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "transpose",
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
          ]
        ]
      ],
      "expected": [
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
          6
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
          1,
          3
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
            2,
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
          3
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
          -1,
          -2
        ],
        [
          -3,
          -4
        ],
        [
          -5,
          -6
        ]
      ]
    ],
    "expected": [
      [
        -1,
        -3,
        -5
      ],
      [
        -2,
        -4,
        -6
      ]
    ]
  },
  {
    "args": [
      [
        [
          0,
          1,
          2,
          3
        ],
        [
          4,
          5,
          6,
          7
        ]
      ]
    ],
    "expected": [
      [
        0,
        4
      ],
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
  },
  {
    "args": [
      [
        [
          10,
          20
        ],
        [
          30,
          40
        ],
        [
          50,
          60
        ],
        [
          70,
          80
        ]
      ]
    ],
    "expected": [
      [
        10,
        30,
        50,
        70
      ],
      [
        20,
        40,
        60,
        80
      ]
    ]
  },
  {
    "args": [
      [
        [
          7
        ]
      ]
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
        ]
      ]
    ],
    "expected": [
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
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1140,
    '重塑矩阵',
    '给定一个 m x n 的二维整数数组 mat 和两个整数 r、c，返回重塑后的 r x c 矩阵。
重塑后的矩阵需要以相同的行优先顺序包含原矩阵的所有元素。
如果重塑操作不可行，返回原矩阵。

提示：
- 1 <= m, n <= 100
- -1000 <= mat[i][j] <= 1000
- 1 <= r, c <= 300',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵', '模拟'],
    $json$[
  {
    "input": "mat = [[1, 2], [3, 4]], r = 1, c = 4",
    "output": "[[1, 2, 3, 4]]"
  },
  {
    "input": "mat = [[1, 2], [3, 4]], r = 2, c = 4",
    "output": "[[1, 2], [3, 4]]"
  },
  {
    "input": "mat = [[1, 2, 3, 4]], r = 2, c = 2",
    "output": "[[1, 2], [3, 4]]"
  },
  {
    "input": "mat = [[1, 2], [3, 4]], r = 4, c = 1",
    "output": "[[1], [2], [3], [4]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mat = [[1, 2], [3, 4]], r = 1, c = 4",
    "output": "[[1, 2, 3, 4]]"
  },
  {
    "input": "mat = [[1, 2], [3, 4]], r = 2, c = 4",
    "output": "[[1, 2], [3, 4]]"
  },
  {
    "input": "mat = [[1, 2, 3, 4]], r = 2, c = 2",
    "output": "[[1, 2], [3, 4]]"
  },
  {
    "input": "mat = [[1, 2], [3, 4]], r = 4, c = 1",
    "output": "[[1], [2], [3], [4]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var matrixReshape = function(mat, r, c) {\n};\n",
  "python": "class Solution:\n    def matrixReshape(self, mat: list[list[int]], r: int, c: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> matrixReshape(std::vector<std::vector<int>>& mat, int r, int c) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] matrixReshape(int[][] mat, int r, int c) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "matrixReshape",
  "params": [
    {
      "name": "mat",
      "type": "int[][]"
    },
    {
      "name": "r",
      "type": "int"
    },
    {
      "name": "c",
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
          [
            1,
            2
          ],
          [
            3,
            4
          ]
        ],
        2,
        4
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
          [
            1,
            2,
            3,
            4
          ]
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
          [
            1,
            2
          ],
          [
            3,
            4
          ]
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
      3,
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
      ],
      [
        5,
        6
      ]
    ]
  },
  {
    "args": [
      [
        [
          1
        ]
      ],
      1,
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
        [
          1,
          2
        ]
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
      3
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
        [
          1,
          2,
          3,
          4,
          5,
          6
        ]
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
        [
          1,
          2,
          3,
          4,
          5,
          6
        ]
      ],
      3,
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
      ],
      [
        5,
        6
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
        ],
        [
          5,
          6
        ]
      ],
      1,
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
        ],
        [
          5,
          6
        ]
      ],
      6,
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
      ],
      [
        5
      ],
      [
        6
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1141,
    '找到所有数组中消失的数字',
    '给定一个长度为 n 的整数数组 nums，其中 nums[i] 在区间 [1, n] 内。
找出所有在 [1, n] 范围内但没有出现在 nums 中的数字，并以升序数组返回。

提示：
- n == nums.length
- 1 <= n <= 10^5
- 1 <= nums[i] <= n',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "nums = [4, 3, 2, 7, 8, 2, 3, 1]",
    "output": "[5, 6]"
  },
  {
    "input": "nums = [1, 1]",
    "output": "[2]"
  },
  {
    "input": "nums = [2, 2]",
    "output": "[1]"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [4, 3, 2, 7, 8, 2, 3, 1]",
    "output": "[5, 6]"
  },
  {
    "input": "nums = [1, 1]",
    "output": "[2]"
  },
  {
    "input": "nums = [2, 2]",
    "output": "[1]"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findDisappearedNumbers = function(nums) {\n};\n",
  "python": "class Solution:\n    def findDisappearedNumbers(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findDisappearedNumbers(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findDisappearedNumbers(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findDisappearedNumbers",
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
        5,
        6
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
        1,
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
        2,
        3,
        4,
        1
      ]
    ],
    "expected": []
  },
  {
    "args": [
      [
        3,
        3,
        3,
        3
      ]
    ],
    "expected": [
      1,
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
    "expected": []
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
    "expected": [
      3,
      4
    ]
  },
  {
    "args": [
      [
        6,
        5,
        4,
        3,
        2,
        1
      ]
    ],
    "expected": []
  },
  {
    "args": [
      [
        1,
        2,
        4,
        4
      ]
    ],
    "expected": [
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
      3,
      4
    ]
  },
  {
    "args": [
      [
        4,
        4,
        4,
        4
      ]
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
    1142,
    '多数元素',
    '给定一个大小为 n 的整数数组 nums，返回其中的多数元素。
多数元素是指在数组中出现次数大于 n / 2 的元素。
可以假设数组是非空的，并且给定的数组总是存在多数元素。

提示：
- n == nums.length
- 1 <= n <= 5 * 10^4
- -10^9 <= nums[i] <= 10^9',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '分治', '计数'],
    $json$[
  {
    "input": "nums = [3, 2, 3]",
    "output": "3"
  },
  {
    "input": "nums = [2, 2, 1, 1, 1, 2, 2]",
    "output": "2"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 1, 2]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 2, 3]",
    "output": "3"
  },
  {
    "input": "nums = [2, 2, 1, 1, 1, 2, 2]",
    "output": "2"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 1, 2]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var majorityElement = function(nums) {\n};\n",
  "python": "class Solution:\n    def majorityElement(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int majorityElement(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int majorityElement(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "majorityElement",
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
          2,
          3
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          2,
          2,
          1,
          1,
          1,
          2,
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
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        5,
        5,
        5,
        1,
        2
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        -1,
        -1,
        2
      ]
    ],
    "expected": -1
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
    "expected": 1
  },
  {
    "args": [
      [
        7,
        7,
        7,
        7
      ]
    ],
    "expected": 7
  },
  {
    "args": [
      [
        0,
        0,
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        2,
        2,
        1,
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
        1,
        2,
        3,
        1,
        1
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
        9,
        2
      ]
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1143,
    '单调数列',
    '如果数组是单调递增或单调递减的，返回 true，否则返回 false。
单调递增指数组中每个相邻元素 nums[i] <= nums[i + 1]；单调递减指数组中每个相邻元素 nums[i] >= nums[i + 1]。

提示：
- 1 <= nums.length <= 5 * 10^4
- -10^5 <= nums[i] <= 10^5',
    'easy',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "nums = [1, 2, 2, 3]",
    "output": "true"
  },
  {
    "input": "nums = [6, 5, 4, 4]",
    "output": "true"
  },
  {
    "input": "nums = [1, 3, 2]",
    "output": "false"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 2, 3]",
    "output": "true"
  },
  {
    "input": "nums = [6, 5, 4, 4]",
    "output": "true"
  },
  {
    "input": "nums = [1, 3, 2]",
    "output": "false"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isMonotonic = function(nums) {\n};\n",
  "python": "class Solution:\n    def isMonotonic(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isMonotonic(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isMonotonic(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isMonotonic",
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
          2,
          3
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          6,
          5,
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
          3,
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
        1
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
        2,
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
        2,
        2,
        3
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        5,
        5,
        4,
        5
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        -1,
        -2,
        -3
      ]
    ],
    "expected": true
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
    "expected": false
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
    "expected": true
  },
  {
    "args": [
      [
        2,
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
    1144,
    '有序数组的平方',
    '给定一个按非递减顺序排序的整数数组 nums，返回每个数字的平方组成的新数组，要求也按非递减顺序排序。

提示：
- 1 <= nums.length <= 10^4
- -10^4 <= nums[i] <= 10^4
- nums 已按非递减顺序排序',
    'easy',
    1000,
    256,
    ARRAY['数组', '双指针', '排序'],
    $json$[
  {
    "input": "nums = [-4, -1, 0, 3, 10]",
    "output": "[0, 1, 9, 16, 100]"
  },
  {
    "input": "nums = [-7, -3, 2, 3, 11]",
    "output": "[4, 9, 9, 49, 121]"
  },
  {
    "input": "nums = [1]",
    "output": "[1]"
  },
  {
    "input": "nums = [-1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [-4, -1, 0, 3, 10]",
    "output": "[0, 1, 9, 16, 100]"
  },
  {
    "input": "nums = [-7, -3, 2, 3, 11]",
    "output": "[4, 9, 9, 49, 121]"
  },
  {
    "input": "nums = [1]",
    "output": "[1]"
  },
  {
    "input": "nums = [-1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sortedSquares = function(nums) {\n};\n",
  "python": "class Solution:\n    def sortedSquares(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> sortedSquares(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] sortedSquares(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sortedSquares",
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
          -4,
          -1,
          0,
          3,
          10
        ]
      ],
      "expected": [
        0,
        1,
        9,
        16,
        100
      ]
    },
    {
      "args": [
        [
          -7,
          -3,
          2,
          3,
          11
        ]
      ],
      "expected": [
        4,
        9,
        9,
        49,
        121
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
          -1
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
      []
    ],
    "expected": []
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
        -2,
        -1
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
        1,
        2
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
        -5,
        5
      ]
    ],
    "expected": [
      25,
      25
    ]
  },
  {
    "args": [
      [
        -3,
        -2,
        -1,
        0
      ]
    ],
    "expected": [
      0,
      1,
      4,
      9
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
      0,
      1,
      4,
      9
    ]
  },
  {
    "args": [
      [
        -10000,
        10000
      ]
    ],
    "expected": [
      100000000,
      100000000
    ]
  },
  {
    "args": [
      [
        -10,
        -5,
        0,
        5,
        10
      ]
    ],
    "expected": [
      0,
      25,
      25,
      100,
      100
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1145,
    '检测大写字母',
    '给定一个单词 word，判断其大写字母的用法是否正确。
以下情况为正确：
- 全部字母都是大写，如 "USA"
- 全部字母都是小写，如 "leetcode"
- 只有首字母大写，如 "Google"
否则返回 false。

提示：
- 1 <= word.length <= 100
- word 由英文字母组成',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "word = \"USA\"",
    "output": "true"
  },
  {
    "input": "word = \"FlaG\"",
    "output": "false"
  },
  {
    "input": "word = \"Google\"",
    "output": "true"
  },
  {
    "input": "word = \"leetcode\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "word = \"USA\"",
    "output": "true"
  },
  {
    "input": "word = \"FlaG\"",
    "output": "false"
  },
  {
    "input": "word = \"Google\"",
    "output": "true"
  },
  {
    "input": "word = \"leetcode\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var detectCapitalUse = function(word) {\n};\n",
  "python": "class Solution:\n    def detectCapitalUse(self, word: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool detectCapitalUse(std::string word) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean detectCapitalUse(String word) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "detectCapitalUse",
  "params": [
    {
      "name": "word",
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
        "USA"
      ],
      "expected": true
    },
    {
      "args": [
        "FlaG"
      ],
      "expected": false
    },
    {
      "args": [
        "Google"
      ],
      "expected": true
    },
    {
      "args": [
        "leetcode"
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
      "a"
    ],
    "expected": true
  },
  {
    "args": [
      "Aa"
    ],
    "expected": true
  },
  {
    "args": [
      "aA"
    ],
    "expected": false
  },
  {
    "args": [
      "AA"
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
      "AaA"
    ],
    "expected": false
  },
  {
    "args": [
      "googlE"
    ],
    "expected": false
  },
  {
    "args": [
      "FFFFFFFFFFFFFFFFFFFFf"
    ],
    "expected": false
  },
  {
    "args": [
      "AbCd"
    ],
    "expected": false
  },
  {
    "args": [
      "zZ"
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1146,
    '字符串相乘',
    '给定两个以字符串形式表示的非负整数 num1 和 num2，返回它们的乘积，也用字符串表示。
不能使用任何内置的大整数库，也不能直接将输入转换为整数。

提示：
- 1 <= num1.length, num2.length <= 200
- num1 和 num2 只包含数字，且不含前导零（"0" 除外）',
    'medium',
    1000,
    256,
    ARRAY['字符串', '数学', '模拟'],
    $json$[
  {
    "input": "num1 = \"2\", num2 = \"3\"",
    "output": "\"6\""
  },
  {
    "input": "num1 = \"123\", num2 = \"456\"",
    "output": "\"56088\""
  },
  {
    "input": "num1 = \"0\", num2 = \"0\"",
    "output": "\"0\""
  },
  {
    "input": "num1 = \"9\", num2 = \"9\"",
    "output": "\"81\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num1 = \"2\", num2 = \"3\"",
    "output": "\"6\""
  },
  {
    "input": "num1 = \"123\", num2 = \"456\"",
    "output": "\"56088\""
  },
  {
    "input": "num1 = \"0\", num2 = \"0\"",
    "output": "\"0\""
  },
  {
    "input": "num1 = \"9\", num2 = \"9\"",
    "output": "\"81\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var multiply = function(num1, num2) {\n};\n",
  "python": "class Solution:\n    def multiply(self, num1: str, num2: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string multiply(std::string num1, std::string num2) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String multiply(String num1, String num2) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "multiply",
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
        "2",
        "3"
      ],
      "expected": "6"
    },
    {
      "args": [
        "123",
        "456"
      ],
      "expected": "56088"
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
        "9",
        "9"
      ],
      "expected": "81"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "0",
      "123"
    ],
    "expected": "0"
  },
  {
    "args": [
      "123",
      "0"
    ],
    "expected": "0"
  },
  {
    "args": [
      "10",
      "10"
    ],
    "expected": "100"
  },
  {
    "args": [
      "99",
      "99"
    ],
    "expected": "9801"
  },
  {
    "args": [
      "1",
      "1"
    ],
    "expected": "1"
  },
  {
    "args": [
      "999",
      "999"
    ],
    "expected": "998001"
  },
  {
    "args": [
      "123456789",
      "987654321"
    ],
    "expected": "121932631112635269"
  },
  {
    "args": [
      "100",
      "200"
    ],
    "expected": "20000"
  },
  {
    "args": [
      "5",
      "12"
    ],
    "expected": "60"
  },
  {
    "args": [
      "111",
      "111"
    ],
    "expected": "12321"
  },
  {
    "args": [
      "2",
      "0"
    ],
    "expected": "0"
  },
  {
    "args": [
      "12",
      "34"
    ],
    "expected": "408"
  }
]$json$::jsonb,
    'approved'
),
(
    1147,
    '两数相加',
    '给定两个非空链表，表示两个非负整数。数字按逆序存储，每个节点只存储一位数字。
将两数相加并以相同形式返回一个表示和的链表。
可以假设除了数字 0 之外，这两个数都不会以 0 开头。

提示：
- 每个链表中的节点数在 1 到 100 之间
- 0 <= Node.val <= 9',
    'medium',
    1000,
    256,
    ARRAY['链表', '数学', '递归'],
    $json$[
  {
    "input": "l1 = [2, 4, 3], l2 = [5, 6, 4]",
    "output": "[7, 0, 8]"
  },
  {
    "input": "l1 = [0], l2 = [0]",
    "output": "[0]"
  },
  {
    "input": "l1 = [9, 9, 9, 9, 9, 9, 9], l2 = [9, 9, 9, 9]",
    "output": "[8, 9, 9, 9, 0, 0, 0, 1]"
  },
  {
    "input": "l1 = [1], l2 = [9, 9]",
    "output": "[0, 0, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "l1 = [2, 4, 3], l2 = [5, 6, 4]",
    "output": "[7, 0, 8]"
  },
  {
    "input": "l1 = [0], l2 = [0]",
    "output": "[0]"
  },
  {
    "input": "l1 = [9, 9, 9, 9, 9, 9, 9], l2 = [9, 9, 9, 9]",
    "output": "[8, 9, 9, 9, 0, 0, 0, 1]"
  },
  {
    "input": "l1 = [1], l2 = [9, 9]",
    "output": "[0, 0, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar addTwoNumbers = function(l1, l2) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def addTwoNumbers(self, l1: ListNode | None, l2: ListNode | None) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "addTwoNumbers",
  "params": [
    {
      "name": "l1",
      "type": "ListNode"
    },
    {
      "name": "l2",
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
          2,
          4,
          3
        ],
        [
          5,
          6,
          4
        ]
      ],
      "expected": [
        7,
        0,
        8
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
          9,
          9,
          9,
          9,
          9,
          9,
          9
        ],
        [
          9,
          9,
          9,
          9
        ]
      ],
      "expected": [
        8,
        9,
        9,
        9,
        0,
        0,
        0,
        1
      ]
    },
    {
      "args": [
        [
          1
        ],
        [
          9,
          9
        ]
      ],
      "expected": [
        0,
        0,
        1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        5
      ],
      [
        5
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
        1,
        8
      ],
      [
        0
      ]
    ],
    "expected": [
      1,
      8
    ]
  },
  {
    "args": [
      [
        9
      ],
      [
        1
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
        2,
        4
      ],
      [
        5,
        6
      ]
    ],
    "expected": [
      7,
      0,
      1
    ]
  },
  {
    "args": [
      [
        0
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
        9,
        9
      ],
      [
        9,
        9
      ]
    ],
    "expected": [
      8,
      9,
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
      [
        4,
        5,
        6
      ]
    ],
    "expected": [
      5,
      7,
      9
    ]
  },
  {
    "args": [
      [
        1
      ],
      [
        9
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
        9,
        9,
        9
      ],
      [
        1
      ]
    ],
    "expected": [
      0,
      0,
      0,
      1
    ]
  },
  {
    "args": [
      [
        5
      ],
      [
        5,
        5,
        5
      ]
    ],
    "expected": [
      0,
      6,
      5
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1148,
    '合并两个有序链表',
    '将两个升序链表合并为一个新的升序链表并返回。新链表由拼接给定两个链表的所有节点组成。

提示：
- 两个链表的节点数目范围是 [0, 50]
- -100 <= Node.val <= 100
- 两个链表均按非递减顺序排列',
    'medium',
    1000,
    256,
    ARRAY['链表', '递归'],
    $json$[
  {
    "input": "list1 = [1, 2, 4], list2 = [1, 3, 4]",
    "output": "[1, 1, 2, 3, 4, 4]"
  },
  {
    "input": "list1 = [], list2 = []",
    "output": "[]"
  },
  {
    "input": "list1 = [], list2 = [0]",
    "output": "[0]"
  },
  {
    "input": "list1 = [1], list2 = [2]",
    "output": "[1, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "list1 = [1, 2, 4], list2 = [1, 3, 4]",
    "output": "[1, 1, 2, 3, 4, 4]"
  },
  {
    "input": "list1 = [], list2 = []",
    "output": "[]"
  },
  {
    "input": "list1 = [], list2 = [0]",
    "output": "[0]"
  },
  {
    "input": "list1 = [1], list2 = [2]",
    "output": "[1, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar mergeTwoLists = function(list1, list2) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def mergeTwoLists(self, list1: ListNode | None, list2: ListNode | None) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* mergeTwoLists(ListNode* list1, ListNode* list2) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode mergeTwoLists(ListNode list1, ListNode list2) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "mergeTwoLists",
  "params": [
    {
      "name": "list1",
      "type": "ListNode"
    },
    {
      "name": "list2",
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
          4
        ],
        [
          1,
          3,
          4
        ]
      ],
      "expected": [
        1,
        1,
        2,
        3,
        4,
        4
      ]
    },
    {
      "args": [
        [],
        []
      ],
      "expected": []
    },
    {
      "args": [
        [],
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
          1
        ],
        [
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
        -3,
        -1
      ],
      [
        -2,
        4
      ]
    ],
    "expected": [
      -3,
      -2,
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
      []
    ],
    "expected": [
      1,
      2,
      3
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
        1,
        1,
        1
      ],
      [
        1,
        1
      ]
    ],
    "expected": [
      1,
      1,
      1,
      1,
      1
    ]
  },
  {
    "args": [
      [
        -10,
        10
      ],
      [
        -5,
        5
      ]
    ],
    "expected": [
      -10,
      -5,
      5,
      10
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
      ]
    ],
    "expected": [
      1,
      2,
      3,
      4,
      5,
      6
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
      0,
      0
    ]
  },
  {
    "args": [
      [
        -1
      ],
      [
        -2
      ]
    ],
    "expected": [
      -2,
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
        3,
        4
      ]
    ],
    "expected": [
      1,
      2,
      3,
      4
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1149,
    '删除链表的倒数第 N 个结点',
    '给定一个链表的头节点 head 和一个整数 n，删除链表的倒数第 n 个节点，并返回链表的头节点。

提示：
- 链表中节点数目为 sz
- 1 <= sz <= 30
- 0 <= Node.val <= 100
- 1 <= n <= sz',
    'medium',
    1000,
    256,
    ARRAY['链表', '双指针'],
    $json$[
  {
    "input": "head = [1, 2, 3, 4, 5], n = 2",
    "output": "[1, 2, 3, 5]"
  },
  {
    "input": "head = [1], n = 1",
    "output": "[]"
  },
  {
    "input": "head = [1, 2], n = 1",
    "output": "[1]"
  },
  {
    "input": "head = [1, 2], n = 2",
    "output": "[2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 2, 3, 4, 5], n = 2",
    "output": "[1, 2, 3, 5]"
  },
  {
    "input": "head = [1], n = 1",
    "output": "[]"
  },
  {
    "input": "head = [1, 2], n = 1",
    "output": "[1]"
  },
  {
    "input": "head = [1, 2], n = 2",
    "output": "[2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar removeNthFromEnd = function(head, n) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def removeNthFromEnd(self, head: ListNode | None, n: int) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* removeNthFromEnd(ListNode* head, int n) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode removeNthFromEnd(ListNode head, int n) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeNthFromEnd",
  "params": [
    {
      "name": "head",
      "type": "ListNode"
    },
    {
      "name": "n",
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
        1,
        2,
        3,
        5
      ]
    },
    {
      "args": [
        [
          1
        ],
        1
      ],
      "expected": []
    },
    {
      "args": [
        [
          1,
          2
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
        3
      ],
      1
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
      3
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
        2,
        3,
        4
      ],
      2
    ],
    "expected": [
      1,
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
        5
      ],
      5
    ],
    "expected": [
      2,
      3,
      4,
      5
    ]
  },
  {
    "args": [
      [
        0,
        1
      ],
      2
    ],
    "expected": [
      1
    ]
  },
  {
    "args": [
      [
        5,
        6,
        7,
        8
      ],
      3
    ],
    "expected": [
      5,
      7,
      8
    ]
  },
  {
    "args": [
      [
        9
      ],
      1
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
        5,
        6
      ],
      3
    ],
    "expected": [
      1,
      2,
      3,
      5,
      6
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1150,
    '链表的中间结点',
    '给定一个头节点为 head 的非空单链表，返回链表的中间节点。
如果有两个中间节点，则返回第二个中间节点。

提示：
- 链表中节点数目在 [1, 100] 范围内
- 1 <= Node.val <= 100',
    'medium',
    1000,
    256,
    ARRAY['链表', '双指针'],
    $json$[
  {
    "input": "head = [1, 2, 3, 4, 5]",
    "output": "[3, 4, 5]"
  },
  {
    "input": "head = [1, 2, 3, 4, 5, 6]",
    "output": "[4, 5, 6]"
  },
  {
    "input": "head = [1]",
    "output": "[1]"
  },
  {
    "input": "head = [1, 2]",
    "output": "[2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 2, 3, 4, 5]",
    "output": "[3, 4, 5]"
  },
  {
    "input": "head = [1, 2, 3, 4, 5, 6]",
    "output": "[4, 5, 6]"
  },
  {
    "input": "head = [1]",
    "output": "[1]"
  },
  {
    "input": "head = [1, 2]",
    "output": "[2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar middleNode = function(head) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def middleNode(self, head: ListNode | None) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* middleNode(ListNode* head) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode middleNode(ListNode head) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "middleNode",
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
        3,
        4,
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
          6
        ]
      ],
      "expected": [
        4,
        5,
        6
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
          2
        ]
      ],
      "expected": [
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
        1,
        2,
        3,
        4
      ]
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
        2,
        3,
        4,
        5,
        6,
        7
      ]
    ],
    "expected": [
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
      6,
      7,
      8
    ]
  },
  {
    "args": [
      [
        -1,
        -2
      ]
    ],
    "expected": [
      -2
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
        7,
        8,
        9
      ]
    ],
    "expected": [
      5,
      6,
      7,
      8,
      9
    ]
  },
  {
    "args": [
      [
        10,
        20
      ]
    ],
    "expected": [
      20
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
        7,
        8,
        9,
        10
      ]
    ],
    "expected": [
      6,
      7,
      8,
      9,
      10
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1151,
    '删除排序链表中的重复元素',
    '给定一个已排序的链表的头节点 head，删除所有重复的元素，使每个元素只出现一次。
返回已排序的链表。

提示：
- 链表中节点数目在 [0, 300] 范围内
- -100 <= Node.val <= 100
- 链表已按升序排列',
    'medium',
    1000,
    256,
    ARRAY['链表'],
    $json$[
  {
    "input": "head = [1, 1, 2]",
    "output": "[1, 2]"
  },
  {
    "input": "head = [1, 1, 2, 3, 3]",
    "output": "[1, 2, 3]"
  },
  {
    "input": "head = []",
    "output": "[]"
  },
  {
    "input": "head = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 1, 2]",
    "output": "[1, 2]"
  },
  {
    "input": "head = [1, 1, 2, 3, 3]",
    "output": "[1, 2, 3]"
  },
  {
    "input": "head = []",
    "output": "[]"
  },
  {
    "input": "head = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar deleteDuplicates = function(head) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def deleteDuplicates(self, head: ListNode | None) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* deleteDuplicates(ListNode* head) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode deleteDuplicates(ListNode head) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "deleteDuplicates",
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
          1,
          2,
          3,
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
        []
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
    "expected": [
      0,
      1
    ]
  },
  {
    "args": [
      [
        -3,
        -3,
        -2
      ]
    ],
    "expected": [
      -3,
      -2
    ]
  },
  {
    "args": [
      [
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
      2,
      3
    ]
  },
  {
    "args": [
      [
        5,
        5
      ]
    ],
    "expected": [
      5
    ]
  },
  {
    "args": [
      [
        -1,
        0,
        0,
        1
      ]
    ],
    "expected": [
      -1,
      0,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1152,
    '回文链表',
    '给定一个单链表的头节点 head，判断该链表是否为回文链表。
如果是，返回 true；否则返回 false。

提示：
- 链表中节点数目在 [1, 10^5] 范围内
- 0 <= Node.val <= 9',
    'medium',
    1000,
    256,
    ARRAY['链表', '双指针', '栈', '递归'],
    $json$[
  {
    "input": "head = [1, 2, 2, 1]",
    "output": "true"
  },
  {
    "input": "head = [1, 2]",
    "output": "false"
  },
  {
    "input": "head = [1]",
    "output": "true"
  },
  {
    "input": "head = []",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 2, 2, 1]",
    "output": "true"
  },
  {
    "input": "head = [1, 2]",
    "output": "false"
  },
  {
    "input": "head = [1]",
    "output": "true"
  },
  {
    "input": "head = []",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar isPalindromeList = function(head) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def isPalindromeList(self, head: ListNode | None) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool isPalindromeList(ListNode* head) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean isPalindromeList(ListNode head) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isPalindromeList",
  "params": [
    {
      "name": "head",
      "type": "ListNode"
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
          1
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
          1
        ]
      ],
      "expected": true
    },
    {
      "args": [
        []
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
        2,
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
        0
      ]
    ],
    "expected": true
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
        1,
        2,
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
        2,
        3,
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
        2,
        3,
        1
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1153,
    '二叉树的最大深度',
    '给定一个二叉树的根节点 root，返回它的最大深度。
最大深度是指从根节点到最远叶子节点的最长路径上的节点数。

提示：
- 树中节点的数目在 [0, 10^4] 范围内
- -100 <= Node.val <= 100',
    'medium',
    1000,
    256,
    ARRAY['二叉树', '深度优先搜索', '广度优先搜索'],
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "3"
  },
  {
    "input": "root = []",
    "output": "0"
  },
  {
    "input": "root = [1]",
    "output": "1"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "3"
  },
  {
    "input": "root = []",
    "output": "0"
  },
  {
    "input": "root = [1]",
    "output": "1"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar maxDepth = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def maxDepth(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int maxDepth(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int maxDepth(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxDepth",
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
          9,
          20,
          null,
          null,
          15,
          7
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        []
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
        1,
        2,
        null,
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
        3,
        4,
        5,
        6,
        7
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
        4
      ]
    ],
    "expected": 3
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
    "expected": 3
  },
  {
    "args": [
      [
        1,
        2,
        null,
        3,
        null,
        4
      ]
    ],
    "expected": 4
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
        1,
        null,
        2,
        3
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1154,
    '对称二叉树',
    '给定一个二叉树的根节点 root，检查它是否轴对称。

提示：
- 树中节点数目在 [1, 1000] 范围内
- -100 <= Node.val <= 100',
    'medium',
    1000,
    256,
    ARRAY['二叉树', '深度优先搜索', '广度优先搜索', '递归'],
    $json$[
  {
    "input": "root = [1, 2, 2, 3, 4, 4, 3]",
    "output": "true"
  },
  {
    "input": "root = [1, 2, 2, null, 3, null, 3]",
    "output": "false"
  },
  {
    "input": "root = [1]",
    "output": "true"
  },
  {
    "input": "root = []",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 2, 3, 4, 4, 3]",
    "output": "true"
  },
  {
    "input": "root = [1, 2, 2, null, 3, null, 3]",
    "output": "false"
  },
  {
    "input": "root = [1]",
    "output": "true"
  },
  {
    "input": "root = []",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar isSymmetric = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def isSymmetric(self, root: TreeNode | None) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool isSymmetric(TreeNode* root) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean isSymmetric(TreeNode root) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isSymmetric",
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
          2,
          3,
          4,
          4,
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
          2,
          null,
          3,
          null,
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
      "expected": true
    },
    {
      "args": [
        []
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
        2,
        2,
        null,
        3,
        3,
        null
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        2,
        3,
        null,
        null,
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
        2,
        3,
        4,
        4,
        3,
        5,
        6,
        7,
        8,
        8,
        7,
        6,
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
        2,
        3,
        4,
        4,
        3,
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
        2,
        null,
        null,
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
    1155,
    '二叉树的直径',
    '给定一棵二叉树的根节点 root，返回该树的直径。
二叉树的直径是指任意两个节点之间最长路径的长度，这条路径可能经过也可能不经过根节点。
两个节点之间路径的长度由它们之间的边数表示。

提示：
- 树中节点数目在 [1, 10^4] 范围内
- -100 <= Node.val <= 100',
    'medium',
    1000,
    256,
    ARRAY['二叉树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [1, 2, 3, 4, 5]",
    "output": "3"
  },
  {
    "input": "root = [1, 2]",
    "output": "1"
  },
  {
    "input": "root = [1]",
    "output": "0"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3, 4, 5]",
    "output": "3"
  },
  {
    "input": "root = [1, 2]",
    "output": "1"
  },
  {
    "input": "root = [1]",
    "output": "0"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar diameterOfBinaryTree = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def diameterOfBinaryTree(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int diameterOfBinaryTree(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int diameterOfBinaryTree(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "diameterOfBinaryTree",
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
          3,
          4,
          5
        ]
      ],
      "expected": 3
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
          3
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
        4,
        5,
        null,
        null
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
        6,
        7
      ]
    ],
    "expected": 4
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
    "expected": 2
  },
  {
    "args": [
      [
        1,
        2,
        null,
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
        2,
        3,
        null,
        4,
        null,
        5
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
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1156,
    '路径总和',
    '给定二叉树的根节点 root 和一个整数 targetSum，判断该树中是否存在根节点到叶子节点的路径，使这条路径上所有节点值之和等于 targetSum。
叶子节点是指没有子节点的节点。

提示：
- 树中节点的数目在 [0, 5000] 范围内
- -1000 <= Node.val, targetSum <= 1000',
    'medium',
    1000,
    256,
    ARRAY['二叉树', '深度优先搜索', '广度优先搜索'],
    $json$[
  {
    "input": "root = [5, 4, 8, 11, null, 13, 4, 7, 2, null, null, null, 1], targetSum = 22",
    "output": "true"
  },
  {
    "input": "root = [], targetSum = 0",
    "output": "false"
  },
  {
    "input": "root = [1, 2, 3], targetSum = 5",
    "output": "false"
  },
  {
    "input": "root = [1, 2], targetSum = 3",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [5, 4, 8, 11, null, 13, 4, 7, 2, null, null, null, 1], targetSum = 22",
    "output": "true"
  },
  {
    "input": "root = [], targetSum = 0",
    "output": "false"
  },
  {
    "input": "root = [1, 2, 3], targetSum = 5",
    "output": "false"
  },
  {
    "input": "root = [1, 2], targetSum = 3",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar hasPathSum = function(root, targetSum) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def hasPathSum(self, root: TreeNode | None, targetSum: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool hasPathSum(TreeNode* root, int targetSum) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean hasPathSum(TreeNode root, int targetSum) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "hasPathSum",
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
  "return_type": "bool",
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
          null,
          1
        ],
        22
      ],
      "expected": true
    },
    {
      "args": [
        [],
        0
      ],
      "expected": false
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
      "expected": false
    },
    {
      "args": [
        [
          1,
          2
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
        1
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
    "expected": false
  },
  {
    "args": [
      [
        1,
        -2,
        -3,
        1,
        3,
        -2,
        null,
        -1
      ],
      -1
    ],
    "expected": true
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
    "expected": true
  },
  {
    "args": [
      [
        0,
        1,
        1
      ],
      0
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        2,
        null,
        3
      ],
      6
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
      ],
      5
    ],
    "expected": false
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
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1157,
    '翻转二叉树',
    '给定一棵二叉树的根节点 root，翻转这棵树，并返回其根节点。
翻转是指交换每个节点的左右子树。

提示：
- 树中节点数目在 [0, 100] 范围内
- -100 <= Node.val <= 100',
    'medium',
    1000,
    256,
    ARRAY['二叉树', '深度优先搜索', '广度优先搜索'],
    $json$[
  {
    "input": "root = [4, 2, 7, 1, 3, 6, 9]",
    "output": "[4, 7, 2, 9, 6, 3, 1]"
  },
  {
    "input": "root = [2, 1, 3]",
    "output": "[2, 3, 1]"
  },
  {
    "input": "root = []",
    "output": "[]"
  },
  {
    "input": "root = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [4, 2, 7, 1, 3, 6, 9]",
    "output": "[4, 7, 2, 9, 6, 3, 1]"
  },
  {
    "input": "root = [2, 1, 3]",
    "output": "[2, 3, 1]"
  },
  {
    "input": "root = []",
    "output": "[]"
  },
  {
    "input": "root = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar invertTree = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def invertTree(self, root: TreeNode | None) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* invertTree(TreeNode* root) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode invertTree(TreeNode root) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "invertTree",
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
          2,
          7,
          1,
          3,
          6,
          9
        ]
      ],
      "expected": [
        4,
        7,
        2,
        9,
        6,
        3,
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
        []
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
      null,
      2
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
      null,
      null,
      null,
      4
    ]
  },
  {
    "args": [
      [
        3,
        1,
        2
      ]
    ],
    "expected": [
      3,
      2,
      1
    ]
  },
  {
    "args": [
      [
        5,
        4,
        6,
        2,
        null,
        11,
        null
      ]
    ],
    "expected": [
      5,
      6,
      4,
      null,
      11,
      null,
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
        6,
        7
      ]
    ],
    "expected": [
      1,
      3,
      2,
      7,
      6,
      5,
      4
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1158,
    '二叉树的层序遍历',
    '给定二叉树的根节点 root，返回其节点值的层序遍历结果。
层序遍历指逐层地、从左到右访问所有节点，结果用二维数组表示。

提示：
- 树中节点数目在 [0, 2000] 范围内
- -1000 <= Node.val <= 1000',
    'medium',
    1000,
    256,
    ARRAY['二叉树', '广度优先搜索'],
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "[[3], [9, 20], [15, 7]]"
  },
  {
    "input": "root = []",
    "output": "[]"
  },
  {
    "input": "root = [1]",
    "output": "[[1]]"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "[[1], [2, 3]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "[[3], [9, 20], [15, 7]]"
  },
  {
    "input": "root = []",
    "output": "[]"
  },
  {
    "input": "root = [1]",
    "output": "[[1]]"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "[[1], [2, 3]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar levelOrder = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def levelOrder(self, root: TreeNode | None) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> levelOrder(TreeNode* root) {\n        return {};\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int[][] levelOrder(TreeNode root) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "levelOrder",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
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
          3,
          9,
          20,
          null,
          null,
          15,
          7
        ]
      ],
      "expected": [
        [
          3
        ],
        [
          9,
          20
        ],
        [
          15,
          7
        ]
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
          3
        ]
      ],
      "expected": [
        [
          1
        ],
        [
          2,
          3
        ]
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
        4,
        5,
        6,
        7
      ]
    ],
    "expected": [
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
        6,
        7
      ]
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
      [
        1
      ],
      [
        2
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
        3
      ]
    ]
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
    "expected": [
      [
        1
      ],
      [
        2,
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
        0,
        -1,
        1
      ]
    ],
    "expected": [
      [
        0
      ],
      [
        -1,
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
        4,
        5,
        null,
        6
      ]
    ],
    "expected": [
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
  }
]$json$::jsonb,
    'approved'
),
(
    1159,
    '二叉树的中序遍历',
    '给定二叉树的根节点 root，返回它的中序遍历结果。
中序遍历的顺序是：左子树、根节点、右子树。

提示：
- 树中节点数目在 [0, 100] 范围内
- -100 <= Node.val <= 100',
    'medium',
    1000,
    256,
    ARRAY['栈', '树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [1, null, 2, 3]",
    "output": "[1, 3, 2]"
  },
  {
    "input": "root = []",
    "output": "[]"
  },
  {
    "input": "root = [1]",
    "output": "[1]"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "[2, 1, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, null, 2, 3]",
    "output": "[1, 3, 2]"
  },
  {
    "input": "root = []",
    "output": "[]"
  },
  {
    "input": "root = [1]",
    "output": "[1]"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "[2, 1, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar inorderTraversal = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def inorderTraversal(self, root: TreeNode | None) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::vector<int> inorderTraversal(TreeNode* root) {\n        return {};\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int[] inorderTraversal(TreeNode root) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "inorderTraversal",
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
        []
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
    "expected": [
      4,
      2,
      5,
      1,
      3
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
        1,
        2,
        null,
        3
      ]
    ],
    "expected": [
      3,
      2,
      1
    ]
  },
  {
    "args": [
      [
        -1,
        -2,
        -3
      ]
    ],
    "expected": [
      -2,
      -1,
      -3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1160,
    '验证二叉搜索树',
    '给定一个二叉树的根节点 root，判断它是否是一个有效的二叉搜索树。
有效二叉搜索树满足：
- 节点的左子树只包含小于当前节点值的节点
- 节点的右子树只包含大于当前节点值的节点
- 所有左子树和右子树自身也必须是二叉搜索树

提示：
- 树中节点数目在 [1, 10^4] 范围内
- -2^31 <= Node.val <= 2^31 - 1',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '二叉搜索树'],
    $json$[
  {
    "input": "root = [2, 1, 3]",
    "output": "true"
  },
  {
    "input": "root = [5, 1, 4, null, null, 3, 6]",
    "output": "false"
  },
  {
    "input": "root = [1]",
    "output": "true"
  },
  {
    "input": "root = []",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [2, 1, 3]",
    "output": "true"
  },
  {
    "input": "root = [5, 1, 4, null, null, 3, 6]",
    "output": "false"
  },
  {
    "input": "root = [1]",
    "output": "true"
  },
  {
    "input": "root = []",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar isValidBST = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def isValidBST(self, root: TreeNode | None) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool isValidBST(TreeNode* root) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean isValidBST(TreeNode root) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isValidBST",
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
          5,
          1,
          4,
          null,
          null,
          3,
          6
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
    },
    {
      "args": [
        []
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
    "expected": false
  },
  {
    "args": [
      [
        5,
        4,
        6,
        null,
        null,
        3,
        7
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
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
        10,
        5,
        15,
        null,
        null,
        6,
        20
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        3,
        1,
        5,
        0,
        2,
        4,
        6
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        -2147483648
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        2147483647
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        null,
        2
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        2,
        null,
        3
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
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
    1161,
    '二叉搜索树中第 K 小的元素',
    '给定一个二叉搜索树的根节点 root 和一个整数 k，返回树中第 k 小的元素。
树中节点数为 n，且 1 <= k <= n。

提示：
- 树中节点数目为 n
- 1 <= k <= n <= 10^4
- 0 <= Node.val <= 10^4',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '二叉搜索树'],
    $json$[
  {
    "input": "root = [3, 1, 4, null, 2], k = 1",
    "output": "1"
  },
  {
    "input": "root = [5, 3, 6, 2, 4, null, null, 1], k = 3",
    "output": "3"
  },
  {
    "input": "root = [1], k = 1",
    "output": "1"
  },
  {
    "input": "root = [2, 1, 3], k = 2",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 1, 4, null, 2], k = 1",
    "output": "1"
  },
  {
    "input": "root = [5, 3, 6, 2, 4, null, null, 1], k = 3",
    "output": "3"
  },
  {
    "input": "root = [1], k = 1",
    "output": "1"
  },
  {
    "input": "root = [2, 1, 3], k = 2",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar kthSmallest = function(root, k) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def kthSmallest(self, root: TreeNode | None, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int kthSmallest(TreeNode* root, int k) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int kthSmallest(TreeNode root, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kthSmallest",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
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
          1,
          4,
          null,
          2
        ],
        1
      ],
      "expected": 1
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
          null,
          1
        ],
        3
      ],
      "expected": 3
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
          1,
          3
        ],
        2
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
        1,
        4,
        null,
        2
      ],
      2
    ],
    "expected": 2
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
      3
    ],
    "expected": 3
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
      4
    ],
    "expected": 4
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
        null,
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
        3,
        6,
        2,
        4,
        null,
        null,
        1
      ],
      6
    ],
    "expected": 6
  },
  {
    "args": [
      [
        -1,
        -2
      ],
      1
    ],
    "expected": -2
  }
]$json$::jsonb,
    'approved'
),
(
    1162,
    '岛屿的周长',
    '给定一个 row x col 的二维网格 grid，其中 grid[i][j] = 1 表示陆地，0 表示水域。
岛屿由水平或垂直方向相邻的陆地连接而成，网格四周被水包围。
返回岛屿的周长。

提示：
- row == grid.length
- col == grid[i].length
- 1 <= row, col <= 100
- grid[i][j] 为 0 或 1
- 网格中只有一个岛屿（也可能没有）',
    'medium',
    1000,
    256,
    ARRAY['深度优先搜索', '广度优先搜索', '数组', '矩阵'],
    $json$[
  {
    "input": "grid = [[0, 1, 0, 0], [1, 1, 1, 0], [0, 1, 0, 0], [1, 1, 0, 0]]",
    "output": "16"
  },
  {
    "input": "grid = [[1]]",
    "output": "4"
  },
  {
    "input": "grid = [[1, 0]]",
    "output": "4"
  },
  {
    "input": "grid = [[0, 0], [0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[0, 1, 0, 0], [1, 1, 1, 0], [0, 1, 0, 0], [1, 1, 0, 0]]",
    "output": "16"
  },
  {
    "input": "grid = [[1]]",
    "output": "4"
  },
  {
    "input": "grid = [[1, 0]]",
    "output": "4"
  },
  {
    "input": "grid = [[0, 0], [0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var islandPerimeter = function(grid) {\n};\n",
  "python": "class Solution:\n    def islandPerimeter(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int islandPerimeter(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int islandPerimeter(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "islandPerimeter",
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
            0,
            0
          ],
          [
            1,
            1,
            1,
            0
          ],
          [
            0,
            1,
            0,
            0
          ],
          [
            1,
            1,
            0,
            0
          ]
        ]
      ],
      "expected": 16
    },
    {
      "args": [
        [
          [
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
          1
        ],
        [
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
          1,
          1
        ],
        [
          1,
          1
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
          1,
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
    ],
    "expected": 12
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
          1,
          0
        ]
      ]
    ],
    "expected": 8
  },
  {
    "args": [
      [
        [
          1,
          0,
          1
        ]
      ]
    ],
    "expected": 8
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
        ]
      ]
    ],
    "expected": 12
  }
]$json$::jsonb,
    'approved'
),
(
    1163,
    '最大正方形',
    '在一个由 0 和 1 组成的二维矩阵内，找到只包含 1 的最大正方形，并返回其面积。

提示：
- m == matrix.length
- n == matrix[i].length
- 1 <= m, n <= 300
- matrix[i][j] 为 0 或 1',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '矩阵'],
    $json$[
  {
    "input": "matrix = [[1, 0, 1, 0, 0], [1, 0, 1, 1, 1], [1, 1, 1, 1, 1], [1, 0, 0, 1, 0]]",
    "output": "4"
  },
  {
    "input": "matrix = [[0, 1], [1, 0]]",
    "output": "1"
  },
  {
    "input": "matrix = [[0]]",
    "output": "0"
  },
  {
    "input": "matrix = [[1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 0, 1, 0, 0], [1, 0, 1, 1, 1], [1, 1, 1, 1, 1], [1, 0, 0, 1, 0]]",
    "output": "4"
  },
  {
    "input": "matrix = [[0, 1], [1, 0]]",
    "output": "1"
  },
  {
    "input": "matrix = [[0]]",
    "output": "0"
  },
  {
    "input": "matrix = [[1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximalSquare = function(matrix) {\n};\n",
  "python": "class Solution:\n    def maximalSquare(self, matrix: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximalSquare(std::vector<std::vector<int>>& matrix) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximalSquare(int[][] matrix) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximalSquare",
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
            1,
            0,
            1,
            0,
            0
          ],
          [
            1,
            0,
            1,
            1,
            1
          ],
          [
            1,
            1,
            1,
            1,
            1
          ],
          [
            1,
            0,
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
            0,
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
    "expected": 9
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
          1,
          1,
          1
        ],
        [
          1,
          1,
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
    1164,
    '零钱兑换',
    '给定不同面额的硬币 coins 和一个总金额 amount，计算凑成总金额所需的最少硬币个数。
如果没有任何组合能凑成总金额，返回 -1。
可以认为每种硬币的数量是无限的。

提示：
- 1 <= coins.length <= 12
- 1 <= coins[i] <= 2^31 - 1
- 0 <= amount <= 10^4',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '广度优先搜索'],
    $json$[
  {
    "input": "coins = [1, 2, 5], amount = 11",
    "output": "3"
  },
  {
    "input": "coins = [2], amount = 3",
    "output": "-1"
  },
  {
    "input": "coins = [1], amount = 0",
    "output": "0"
  },
  {
    "input": "coins = [1], amount = 2",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "coins = [1, 2, 5], amount = 11",
    "output": "3"
  },
  {
    "input": "coins = [2], amount = 3",
    "output": "-1"
  },
  {
    "input": "coins = [1], amount = 0",
    "output": "0"
  },
  {
    "input": "coins = [1], amount = 2",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var coinChange = function(coins, amount) {\n};\n",
  "python": "class Solution:\n    def coinChange(self, coins: list[int], amount: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int coinChange(std::vector<int>& coins, int amount) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int coinChange(int[] coins, int amount) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "coinChange",
  "params": [
    {
      "name": "coins",
      "type": "int[]"
    },
    {
      "name": "amount",
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
          2,
          5
        ],
        11
      ],
      "expected": 3
    },
    {
      "args": [
        [
          2
        ],
        3
      ],
      "expected": -1
    },
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
          1
        ],
        2
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
      ],
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        2
      ],
      1
    ],
    "expected": -1
  },
  {
    "args": [
      [
        1,
        2,
        5
      ],
      0
    ],
    "expected": 0
  },
  {
    "args": [
      [
        2,
        5,
        10,
        1
      ],
      27
    ],
    "expected": 4
  },
  {
    "args": [
      [
        186,
        419,
        83,
        408
      ],
      6249
    ],
    "expected": 20
  },
  {
    "args": [
      [
        3,
        7
      ],
      5
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
    "expected": 1
  },
  {
    "args": [
      [
        1,
        5,
        10
      ],
      12
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1165,
    '完全平方数',
    '给定一个整数 n，返回和为 n 的完全平方数的最少数量。
完全平方数是一个整数，其值等于另一个整数的平方，例如 1、4、9、16 等。

提示：
- 1 <= n <= 10^4',
    'medium',
    1000,
    256,
    ARRAY['数学', '动态规划', '广度优先搜索'],
    $json$[
  {
    "input": "n = 12",
    "output": "3"
  },
  {
    "input": "n = 13",
    "output": "2"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 4",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 12",
    "output": "3"
  },
  {
    "input": "n = 13",
    "output": "2"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 4",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numSquares = function(n) {\n};\n",
  "python": "class Solution:\n    def numSquares(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numSquares(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numSquares(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numSquares",
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
        12
      ],
      "expected": 3
    },
    {
      "args": [
        13
      ],
      "expected": 2
    },
    {
      "args": [
        1
      ],
      "expected": 1
    },
    {
      "args": [
        4
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2
    ],
    "expected": 2
  },
  {
    "args": [
      3
    ],
    "expected": 3
  },
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
    "expected": 4
  },
  {
    "args": [
      9
    ],
    "expected": 1
  },
  {
    "args": [
      10
    ],
    "expected": 2
  },
  {
    "args": [
      11
    ],
    "expected": 3
  },
  {
    "args": [
      43
    ],
    "expected": 3
  },
  {
    "args": [
      100
    ],
    "expected": 1
  },
  {
    "args": [
      101
    ],
    "expected": 2
  },
  {
    "args": [
      9999
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1166,
    '最长递增子序列',
    '给定一个整数数组 nums，找到其中最长严格递增子序列的长度。
子序列是由数组派生而来的序列，删除（或不删除）数组中的元素而不改变其余元素的顺序。

提示：
- 1 <= nums.length <= 2500
- -10^4 <= nums[i] <= 10^4',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '二分查找'],
    $json$[
  {
    "input": "nums = [10, 9, 2, 5, 3, 7, 101, 18]",
    "output": "4"
  },
  {
    "input": "nums = [0, 1, 0, 3, 2, 3]",
    "output": "4"
  },
  {
    "input": "nums = [7, 7, 7]",
    "output": "1"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [10, 9, 2, 5, 3, 7, 101, 18]",
    "output": "4"
  },
  {
    "input": "nums = [0, 1, 0, 3, 2, 3]",
    "output": "4"
  },
  {
    "input": "nums = [7, 7, 7]",
    "output": "1"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var lengthOfLIS = function(nums) {\n};\n",
  "python": "class Solution:\n    def lengthOfLIS(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int lengthOfLIS(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int lengthOfLIS(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "lengthOfLIS",
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
          10,
          9,
          2,
          5,
          3,
          7,
          101,
          18
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          0,
          1,
          0,
          3,
          2,
          3
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
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
      []
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
      ]
    ],
    "expected": 5
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
        1,
        3,
        6,
        7,
        9,
        4,
        10,
        5,
        6
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        -1,
        -2,
        0,
        1
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
    "expected": 1
  },
  {
    "args": [
      [
        3,
        1,
        4,
        1,
        5,
        9,
        2,
        6
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1167,
    '最长公共子序列',
    '给定两个字符串 text1 和 text2，返回它们的最长公共子序列的长度。
如果不存在公共子序列，返回 0。
子序列是指从字符串中删除某些字符（也可以不删除）后得到的新字符串，不改变剩余字符的相对顺序。

提示：
- 1 <= text1.length, text2.length <= 1000
- 两个字符串仅由小写英文字符组成',
    'medium',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "text1 = \"abcde\", text2 = \"ace\"",
    "output": "3"
  },
  {
    "input": "text1 = \"abc\", text2 = \"abc\"",
    "output": "3"
  },
  {
    "input": "text1 = \"abc\", text2 = \"def\"",
    "output": "0"
  },
  {
    "input": "text1 = \"\", text2 = \"abc\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "text1 = \"abcde\", text2 = \"ace\"",
    "output": "3"
  },
  {
    "input": "text1 = \"abc\", text2 = \"abc\"",
    "output": "3"
  },
  {
    "input": "text1 = \"abc\", text2 = \"def\"",
    "output": "0"
  },
  {
    "input": "text1 = \"\", text2 = \"abc\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestCommonSubsequence = function(text1, text2) {\n};\n",
  "python": "class Solution:\n    def longestCommonSubsequence(self, text1: str, text2: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestCommonSubsequence(std::string text1, std::string text2) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestCommonSubsequence(String text1, String text2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestCommonSubsequence",
  "params": [
    {
      "name": "text1",
      "type": "string"
    },
    {
      "name": "text2",
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
        "abcde",
        "ace"
      ],
      "expected": 3
    },
    {
      "args": [
        "abc",
        "abc"
      ],
      "expected": 3
    },
    {
      "args": [
        "abc",
        "def"
      ],
      "expected": 0
    },
    {
      "args": [
        "",
        "abc"
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "",
      ""
    ],
    "expected": 0
  },
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
    "expected": 0
  },
  {
    "args": [
      "bsbininm",
      "jmjkbkjkv"
    ],
    "expected": 1
  },
  {
    "args": [
      "abcba",
      "abcbcba"
    ],
    "expected": 5
  },
  {
    "args": [
      "abcd",
      "abcd"
    ],
    "expected": 4
  },
  {
    "args": [
      "oxcpqrsvwf",
      "shmtulqrypy"
    ],
    "expected": 2
  },
  {
    "args": [
      "ezupkr",
      "ubmrapg"
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1168,
    '打家劫舍',
    '你是一个专业的小偷，计划偷窃沿街的房屋。每间房内都藏有一定的现金。
相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被闯入，系统会自动报警。
给定一个代表每个房屋存放金额的非负整数数组 nums，返回不触动警报装置的情况下能偷窃到的最高金额。

提示：
- 1 <= nums.length <= 100
- 0 <= nums[i] <= 400',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 1]",
    "output": "4"
  },
  {
    "input": "nums = [2, 7, 9, 3, 1]",
    "output": "12"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = [2, 1]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 1]",
    "output": "4"
  },
  {
    "input": "nums = [2, 7, 9, 3, 1]",
    "output": "12"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = [2, 1]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var rob = function(nums) {\n};\n",
  "python": "class Solution:\n    def rob(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int rob(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int rob(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "rob",
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
      "expected": 4
    },
    {
      "args": [
        [
          2,
          7,
          9,
          3,
          1
        ]
      ],
      "expected": 12
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
          2,
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
      []
    ],
    "expected": 0
  },
  {
    "args": [
      [
        5
      ]
    ],
    "expected": 5
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
    "expected": 4
  },
  {
    "args": [
      [
        1,
        3,
        1,
        3,
        100
      ]
    ],
    "expected": 103
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
        10,
        1,
        1,
        10
      ]
    ],
    "expected": 20
  }
]$json$::jsonb,
    'approved'
),
(
    1169,
    '买卖股票的最佳时机含冷冻期',
    '给定一个整数数组 prices，其中第 i 个元素表示第 i 天的股票价格。
设计一个算法计算出最大利润。在满足以下约束条件下，可以尽可能多地完成交易：
- 卖出股票后，无法在第二天买入股票（即冷冻期为 1 天）

提示：
- 1 <= prices.length <= 5000
- 0 <= prices[i] <= 1000',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "prices = [1, 2, 3, 0, 2]",
    "output": "3"
  },
  {
    "input": "prices = [1]",
    "output": "0"
  },
  {
    "input": "prices = [2, 1]",
    "output": "0"
  },
  {
    "input": "prices = [1, 2, 4]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "prices = [1, 2, 3, 0, 2]",
    "output": "3"
  },
  {
    "input": "prices = [1]",
    "output": "0"
  },
  {
    "input": "prices = [2, 1]",
    "output": "0"
  },
  {
    "input": "prices = [1, 2, 4]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxProfitCooldown = function(prices) {\n};\n",
  "python": "class Solution:\n    def maxProfitCooldown(self, prices: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxProfitCooldown(std::vector<int>& prices) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxProfitCooldown(int[] prices) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxProfitCooldown",
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
          1,
          2,
          3,
          0,
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
    },
    {
      "args": [
        [
          1,
          2,
          4
        ]
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      []
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
    "expected": 0
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
    "expected": 6
  },
  {
    "args": [
      [
        2,
        1,
        4
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        4,
        2,
        7
      ]
    ],
    "expected": 6
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
]$json$::jsonb,
    'approved'
),
(
    1170,
    '乘积最大子数组',
    '给定一个整数数组 nums，找出乘积最大的非空连续子数组，并返回该子数组对应的乘积。

提示：
- 1 <= nums.length <= 15
- -5 <= nums[i] <= 5',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "nums = [2, 3, -2, 4]",
    "output": "6"
  },
  {
    "input": "nums = [-2, 0, -1]",
    "output": "0"
  },
  {
    "input": "nums = [2]",
    "output": "2"
  },
  {
    "input": "nums = [-2, 3, -4]",
    "output": "24"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 3, -2, 4]",
    "output": "6"
  },
  {
    "input": "nums = [-2, 0, -1]",
    "output": "0"
  },
  {
    "input": "nums = [2]",
    "output": "2"
  },
  {
    "input": "nums = [-2, 3, -4]",
    "output": "24"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxProduct = function(nums) {\n};\n",
  "python": "class Solution:\n    def maxProduct(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxProduct(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxProduct(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxProduct",
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
          -2,
          4
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          -2,
          0,
          -1
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          2
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          -2,
          3,
          -4
        ]
      ],
      "expected": 24
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        -2
      ]
    ],
    "expected": -2
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
        0,
        2
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        -2,
        0
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        2,
        -5,
        -2,
        -4,
        3
      ]
    ],
    "expected": 24
  },
  {
    "args": [
      [
        1,
        -2,
        3,
        4
      ]
    ],
    "expected": 12
  },
  {
    "args": [
      [
        -1,
        -2,
        -3
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        3,
        -1,
        4
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1171,
    '分割等和子集',
    '给定一个只包含正整数的非空数组 nums，判断是否可以将这个数组分割成两个子集，使两个子集的元素和相等。

提示：
- 1 <= nums.length <= 200
- 1 <= nums[i] <= 100',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "nums = [1, 5, 11, 5]",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3, 5]",
    "output": "false"
  },
  {
    "input": "nums = [1, 1]",
    "output": "true"
  },
  {
    "input": "nums = [1]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 5, 11, 5]",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3, 5]",
    "output": "false"
  },
  {
    "input": "nums = [1, 1]",
    "output": "true"
  },
  {
    "input": "nums = [1]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canPartition = function(nums) {\n};\n",
  "python": "class Solution:\n    def canPartition(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canPartition(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canPartition(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canPartition",
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
          5,
          11,
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
          5
        ]
      ],
      "expected": false
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
        2,
        2,
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
        2,
        5
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        3,
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
        2,
        2,
        3,
        5
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
        100,
        100
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
        7
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1172,
    '单词拆分',
    '给定一个字符串 s 和一个字符串列表 wordDict 作为字典，判断 s 是否可以被空格拆分为一个或多个字典中出现的单词。
字典中的单词可以重复使用。

提示：
- 1 <= s.length <= 300
- 1 <= wordDict.length <= 1000
- 1 <= wordDict[i].length <= 20
- 两个字符串仅由小写英文字母组成',
    'medium',
    1000,
    256,
    ARRAY['字符串', '动态规划', '哈希表'],
    $json$[
  {
    "input": "s = \"leetcode\", wordDict = [\"leet\", \"code\"]",
    "output": "true"
  },
  {
    "input": "s = \"applepenapple\", wordDict = [\"apple\", \"pen\"]",
    "output": "true"
  },
  {
    "input": "s = \"catsandog\", wordDict = [\"cats\", \"dog\", \"sand\", \"and\", \"cat\"]",
    "output": "false"
  },
  {
    "input": "s = \"a\", wordDict = [\"a\"]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"leetcode\", wordDict = [\"leet\", \"code\"]",
    "output": "true"
  },
  {
    "input": "s = \"applepenapple\", wordDict = [\"apple\", \"pen\"]",
    "output": "true"
  },
  {
    "input": "s = \"catsandog\", wordDict = [\"cats\", \"dog\", \"sand\", \"and\", \"cat\"]",
    "output": "false"
  },
  {
    "input": "s = \"a\", wordDict = [\"a\"]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var wordBreak = function(s, wordDict) {\n};\n",
  "python": "class Solution:\n    def wordBreak(self, s: str, wordDict: list[str]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool wordBreak(std::string s, std::vector<std::string>& wordDict) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean wordBreak(String s, String[] wordDict) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "wordBreak",
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
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "leetcode",
        [
          "leet",
          "code"
        ]
      ],
      "expected": true
    },
    {
      "args": [
        "applepenapple",
        [
          "apple",
          "pen"
        ]
      ],
      "expected": true
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
      "expected": false
    },
    {
      "args": [
        "a",
        [
          "a"
        ]
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      []
    ],
    "expected": false
  },
  {
    "args": [
      "aaaaaaa",
      [
        "aaaa",
        "aaa"
      ]
    ],
    "expected": true
  },
  {
    "args": [
      "ab",
      [
        "a",
        "b"
      ]
    ],
    "expected": true
  },
  {
    "args": [
      "abc",
      [
        "ab",
        "c"
      ]
    ],
    "expected": true
  },
  {
    "args": [
      "abcd",
      [
        "a",
        "abc"
      ]
    ],
    "expected": false
  },
  {
    "args": [
      "cars",
      [
        "car",
        "ca",
        "rs"
      ]
    ],
    "expected": true
  },
  {
    "args": [
      "bb",
      [
        "a",
        "b",
        "bbb",
        "bbbb"
      ]
    ],
    "expected": true
  },
  {
    "args": [
      "a",
      [
        "b"
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1173,
    '不同路径',
    '一个机器人位于一个 m x n 网格的左上角，每次只能向下或向右移动一步。
机器人试图到达网格的右下角，总共有多少条不同的路径？

提示：
- 1 <= m, n <= 10',
    'medium',
    1000,
    256,
    ARRAY['数学', '动态规划', '组合数学'],
    $json$[
  {
    "input": "m = 3, n = 7",
    "output": "28"
  },
  {
    "input": "m = 3, n = 2",
    "output": "3"
  },
  {
    "input": "m = 1, n = 1",
    "output": "1"
  },
  {
    "input": "m = 10, n = 10",
    "output": "48620"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "m = 3, n = 7",
    "output": "28"
  },
  {
    "input": "m = 3, n = 2",
    "output": "3"
  },
  {
    "input": "m = 1, n = 1",
    "output": "1"
  },
  {
    "input": "m = 10, n = 10",
    "output": "48620"
  }
]$json$::jsonb,
    $json${
  "javascript": "var uniquePaths = function(m, n) {\n};\n",
  "python": "class Solution:\n    def uniquePaths(self, m: int, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int uniquePaths(int m, int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int uniquePaths(int m, int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "uniquePaths",
  "params": [
    {
      "name": "m",
      "type": "int"
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
        3,
        7
      ],
      "expected": 28
    },
    {
      "args": [
        3,
        2
      ],
      "expected": 3
    },
    {
      "args": [
        1,
        1
      ],
      "expected": 1
    },
    {
      "args": [
        10,
        10
      ],
      "expected": 48620
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      2
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
    "expected": 2
  },
  {
    "args": [
      3,
      3
    ],
    "expected": 6
  },
  {
    "args": [
      5,
      5
    ],
    "expected": 70
  },
  {
    "args": [
      7,
      3
    ],
    "expected": 28
  },
  {
    "args": [
      10,
      1
    ],
    "expected": 1
  },
  {
    "args": [
      9,
      8
    ],
    "expected": 6435
  }
]$json$::jsonb,
    'approved'
),
(
    1174,
    '最小路径和',
    '给定一个包含非负整数的 m x n 网格 grid，请找出一条从左上角到右下角的路径，使路径上的数字总和最小。
每次只能向下或向右移动一步。

提示：
- m == grid.length
- n == grid[i].length
- 1 <= m, n <= 200
- 0 <= grid[i][j] <= 200',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '矩阵'],
    $json$[
  {
    "input": "grid = [[1, 3, 1], [1, 5, 1], [4, 2, 1]]",
    "output": "7"
  },
  {
    "input": "grid = [[1, 2, 3], [4, 5, 6]]",
    "output": "12"
  },
  {
    "input": "grid = [[1]]",
    "output": "1"
  },
  {
    "input": "grid = [[1, 2], [1, 1]]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[1, 3, 1], [1, 5, 1], [4, 2, 1]]",
    "output": "7"
  },
  {
    "input": "grid = [[1, 2, 3], [4, 5, 6]]",
    "output": "12"
  },
  {
    "input": "grid = [[1]]",
    "output": "1"
  },
  {
    "input": "grid = [[1, 2], [1, 1]]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minPathSum = function(grid) {\n};\n",
  "python": "class Solution:\n    def minPathSum(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minPathSum(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minPathSum(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minPathSum",
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
            3,
            1
          ],
          [
            1,
            5,
            1
          ],
          [
            4,
            2,
            1
          ]
        ]
      ],
      "expected": 7
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
        ]
      ],
      "expected": 12
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
            1,
            2
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
      [
        [
          5
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
          2,
          5
        ],
        [
          3,
          2,
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
          1,
          3
        ],
        [
          1,
          5
        ]
      ]
    ],
    "expected": 7
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
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1175,
    '解码方法',
    '一条包含字母 A-Z 的消息通过以下映射进行了编码：
''A'' -> "1", ''B'' -> "2", ..., ''Z'' -> "26"
给定一个只包含数字的非空字符串 s，请计算并返回解码方法的总数。

提示：
- 1 <= s.length <= 100
- s 只包含数字，可能包含前导零',
    'medium',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "s = \"12\"",
    "output": "2"
  },
  {
    "input": "s = \"226\"",
    "output": "3"
  },
  {
    "input": "s = \"06\"",
    "output": "0"
  },
  {
    "input": "s = \"10\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"12\"",
    "output": "2"
  },
  {
    "input": "s = \"226\"",
    "output": "3"
  },
  {
    "input": "s = \"06\"",
    "output": "0"
  },
  {
    "input": "s = \"10\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numDecodings = function(s) {\n};\n",
  "python": "class Solution:\n    def numDecodings(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numDecodings(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numDecodings(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numDecodings",
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
        "12"
      ],
      "expected": 2
    },
    {
      "args": [
        "226"
      ],
      "expected": 3
    },
    {
      "args": [
        "06"
      ],
      "expected": 0
    },
    {
      "args": [
        "10"
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "0"
    ],
    "expected": 0
  },
  {
    "args": [
      "1"
    ],
    "expected": 1
  },
  {
    "args": [
      "27"
    ],
    "expected": 1
  },
  {
    "args": [
      "2101"
    ],
    "expected": 1
  },
  {
    "args": [
      "100"
    ],
    "expected": 0
  },
  {
    "args": [
      "11106"
    ],
    "expected": 2
  },
  {
    "args": [
      "12345"
    ],
    "expected": 3
  },
  {
    "args": [
      "1201234"
    ],
    "expected": 3
  },
  {
    "args": [
      "999"
    ],
    "expected": 1
  },
  {
    "args": [
      "101"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1176,
    '打家劫舍 II',
    '你是一个专业的小偷，计划偷窃沿街的房屋。这个地方的所有房屋都围成一圈，这意味着第一间房屋和最后一间房屋是相邻的。
相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被闯入，系统会自动报警。
给定一个代表每个房屋存放金额的非负整数数组 nums，返回不触动警报装置的情况下能偷窃到的最高金额。

提示：
- 1 <= nums.length <= 100
- 0 <= nums[i] <= 1000',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "nums = [2, 3, 2]",
    "output": "3"
  },
  {
    "input": "nums = [1, 2, 3, 1]",
    "output": "4"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 3, 2]",
    "output": "3"
  },
  {
    "input": "nums = [1, 2, 3, 1]",
    "output": "4"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var robCircle = function(nums) {\n};\n",
  "python": "class Solution:\n    def robCircle(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int robCircle(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int robCircle(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "robCircle",
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
          3,
          1
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
        2
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
    "expected": 3
  },
  {
    "args": [
      [
        4,
        1,
        2,
        7,
        5,
        3,
        1
      ]
    ],
    "expected": 14
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
        0,
        0
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        3,
        1,
        3,
        100
      ]
    ],
    "expected": 103
  }
]$json$::jsonb,
    'approved'
),
(
    1177,
    '买卖股票的最佳时机含手续费',
    '给定一个整数数组 prices，其中 prices[i] 表示第 i 天的股票价格，以及一个表示交易手续费的整数 fee。
可以尽可能多地完成交易，但每笔交易都需要支付手续费。
卖出股票后不能再在当天买入股票，但可以在卖出后的第二天买入。
返回能获得的最大利润。

提示：
- 1 <= prices.length <= 5 * 10^4
- 1 <= prices[i] < 5 * 10^4
- 0 <= fee < 5 * 10^4',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '贪心'],
    $json$[
  {
    "input": "prices = [1, 3, 2, 8, 4, 9], fee = 2",
    "output": "8"
  },
  {
    "input": "prices = [1, 3, 7, 5, 10, 3], fee = 3",
    "output": "6"
  },
  {
    "input": "prices = [1], fee = 0",
    "output": "0"
  },
  {
    "input": "prices = [1, 2], fee = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "prices = [1, 3, 2, 8, 4, 9], fee = 2",
    "output": "8"
  },
  {
    "input": "prices = [1, 3, 7, 5, 10, 3], fee = 3",
    "output": "6"
  },
  {
    "input": "prices = [1], fee = 0",
    "output": "0"
  },
  {
    "input": "prices = [1, 2], fee = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxProfitFee = function(prices, fee) {\n};\n",
  "python": "class Solution:\n    def maxProfitFee(self, prices: list[int], fee: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxProfitFee(std::vector<int>& prices, int fee) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxProfitFee(int[] prices, int fee) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxProfitFee",
  "params": [
    {
      "name": "prices",
      "type": "int[]"
    },
    {
      "name": "fee",
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
          3,
          2,
          8,
          4,
          9
        ],
        2
      ],
      "expected": 8
    },
    {
      "args": [
        [
          1,
          3,
          7,
          5,
          10,
          3
        ],
        3
      ],
      "expected": 6
    },
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
          1,
          2
        ],
        0
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [],
      0
    ],
    "expected": 0
  },
  {
    "args": [
      [
        5,
        4,
        3
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
      1
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        3,
        2,
        8,
        4,
        9
      ],
      3
    ],
    "expected": 6
  },
  {
    "args": [
      [
        2,
        2,
        2
      ],
      0
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        4
      ],
      2
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1178,
    '搜索二维矩阵',
    '给定一个 m x n 的矩阵 matrix 和一个整数 target。
该矩阵具有以下特性：
- 每行中的整数从左到右按升序排列
- 每行的第一个整数大于前一行的最后一个整数
判断 matrix 中是否存在 target。

提示：
- m == matrix.length
- n == matrix[i].length
- 1 <= m, n <= 100
- -10^4 <= matrix[i][j], target <= 10^4',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找', '矩阵'],
    $json$[
  {
    "input": "matrix = [[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], target = 3",
    "output": "true"
  },
  {
    "input": "matrix = [[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], target = 13",
    "output": "false"
  },
  {
    "input": "matrix = [[1]], target = 1",
    "output": "true"
  },
  {
    "input": "matrix = [[1]], target = 2",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], target = 3",
    "output": "true"
  },
  {
    "input": "matrix = [[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], target = 13",
    "output": "false"
  },
  {
    "input": "matrix = [[1]], target = 1",
    "output": "true"
  },
  {
    "input": "matrix = [[1]], target = 2",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var searchMatrix = function(matrix, target) {\n};\n",
  "python": "class Solution:\n    def searchMatrix(self, matrix: list[list[int]], target: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool searchMatrix(std::vector<std::vector<int>>& matrix, int target) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean searchMatrix(int[][] matrix, int target) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "searchMatrix",
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
            3,
            5,
            7
          ],
          [
            10,
            11,
            16,
            20
          ],
          [
            23,
            30,
            34,
            60
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
            3,
            5,
            7
          ],
          [
            10,
            11,
            16,
            20
          ],
          [
            23,
            30,
            34,
            60
          ]
        ],
        13
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
        [
          1,
          3,
          5,
          7
        ],
        [
          10,
          11,
          16,
          20
        ],
        [
          23,
          30,
          34,
          60
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
          1,
          3,
          5,
          7
        ],
        [
          10,
          11,
          16,
          20
        ],
        [
          23,
          30,
          34,
          60
        ]
      ],
      60
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          1,
          3,
          5,
          7
        ],
        [
          10,
          11,
          16,
          20
        ],
        [
          23,
          30,
          34,
          60
        ]
      ],
      0
    ],
    "expected": false
  },
  {
    "args": [
      [
        [
          1,
          3,
          5,
          7
        ],
        [
          10,
          11,
          16,
          20
        ],
        [
          23,
          30,
          34,
          60
        ]
      ],
      61
    ],
    "expected": false
  },
  {
    "args": [
      [
        [
          1,
          3,
          5,
          7
        ],
        [
          10,
          11,
          16,
          20
        ],
        [
          23,
          30,
          34,
          60
        ]
      ],
      20
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          1,
          3,
          5,
          7
        ],
        [
          10,
          11,
          16,
          20
        ],
        [
          23,
          30,
          34,
          60
        ]
      ],
      22
    ],
    "expected": false
  },
  {
    "args": [
      [
        [
          1,
          3,
          5,
          7
        ],
        [
          10,
          11,
          16,
          20
        ],
        [
          23,
          30,
          34,
          60
        ]
      ],
      23
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          1,
          3,
          5,
          7
        ],
        [
          10,
          11,
          16,
          20
        ],
        [
          23,
          30,
          34,
          60
        ]
      ],
      7
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1179,
    '在排序数组中查找元素的第一个和最后一个位置',
    '给定一个按照非递减顺序排列的整数数组 nums 和一个目标值 target，找出 target 在数组中的开始位置和结束位置。
如果数组中不存在目标值，返回 [-1, -1]。算法的时间复杂度应为 O(log n)。

提示：
- 0 <= nums.length <= 10^5
- -10^5 <= nums[i], target <= 10^5
- nums 是一个非递减数组',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "nums = [5, 7, 7, 8, 8, 10], target = 8",
    "output": "[3, 4]"
  },
  {
    "input": "nums = [5, 7, 7, 8, 8, 10], target = 6",
    "output": "[-1, -1]"
  },
  {
    "input": "nums = [], target = 0",
    "output": "[-1, -1]"
  },
  {
    "input": "nums = [1], target = 1",
    "output": "[0, 0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [5, 7, 7, 8, 8, 10], target = 8",
    "output": "[3, 4]"
  },
  {
    "input": "nums = [5, 7, 7, 8, 8, 10], target = 6",
    "output": "[-1, -1]"
  },
  {
    "input": "nums = [], target = 0",
    "output": "[-1, -1]"
  },
  {
    "input": "nums = [1], target = 1",
    "output": "[0, 0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var searchRange = function(nums, target) {\n};\n",
  "python": "class Solution:\n    def searchRange(self, nums: list[int], target: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> searchRange(std::vector<int>& nums, int target) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] searchRange(int[] nums, int target) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "searchRange",
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
          5,
          7,
          7,
          8,
          8,
          10
        ],
        8
      ],
      "expected": [
        3,
        4
      ]
    },
    {
      "args": [
        [
          5,
          7,
          7,
          8,
          8,
          10
        ],
        6
      ],
      "expected": [
        -1,
        -1
      ]
    },
    {
      "args": [
        [],
        0
      ],
      "expected": [
        -1,
        -1
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
        5,
        7,
        7,
        8,
        8,
        10
      ],
      5
    ],
    "expected": [
      0,
      0
    ]
  },
  {
    "args": [
      [
        5,
        7,
        7,
        8,
        8,
        10
      ],
      10
    ],
    "expected": [
      5,
      5
    ]
  },
  {
    "args": [
      [
        5,
        7,
        7,
        8,
        8,
        10
      ],
      7
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
      4
    ],
    "expected": [
      -1,
      -1
    ]
  },
  {
    "args": [
      [
        2,
        2,
        2
      ],
      2
    ],
    "expected": [
      0,
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
      -1,
      -1
    ]
  },
  {
    "args": [
      [
        1,
        3,
        3,
        5
      ],
      3
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
    1180,
    '柱状图中最大的矩形',
    '给定 n 个非负整数，用来表示柱状图中各个柱子的高度，每个柱子彼此相邻，且宽度为 1。
求在该柱状图中，能够勾勒出来的矩形的最大面积。

提示：
- 1 <= heights.length <= 10^5
- 0 <= heights[i] <= 10^4',
    'hard',
    1000,
    256,
    ARRAY['栈', '数组', '单调栈'],
    $json$[
  {
    "input": "heights = [2, 1, 5, 6, 2, 3]",
    "output": "10"
  },
  {
    "input": "heights = [2, 4]",
    "output": "4"
  },
  {
    "input": "heights = [1]",
    "output": "1"
  },
  {
    "input": "heights = [0]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "heights = [2, 1, 5, 6, 2, 3]",
    "output": "10"
  },
  {
    "input": "heights = [2, 4]",
    "output": "4"
  },
  {
    "input": "heights = [1]",
    "output": "1"
  },
  {
    "input": "heights = [0]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestRectangleArea = function(heights) {\n};\n",
  "python": "class Solution:\n    def largestRectangleArea(self, heights: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int largestRectangleArea(std::vector<int>& heights) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int largestRectangleArea(int[] heights) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestRectangleArea",
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
          2,
          1,
          5,
          6,
          2,
          3
        ]
      ],
      "expected": 10
    },
    {
      "args": [
        [
          2,
          4
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
    "expected": 1
  },
  {
    "args": [
      [
        2,
        1,
        2
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        3,
        1,
        3,
        2,
        2
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        4,
        2,
        0,
        3,
        2,
        5
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
    "expected": 9
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
  }
]$json$::jsonb,
    'approved'
),
(
    1181,
    '滑动窗口最大值',
    '给定一个整数数组 nums 和一个大小为 k 的滑动窗口，窗口从数组的最左侧移动到数组的最右侧。
窗口每次只向右移动一位，返回每个窗口中的最大值。

提示：
- 1 <= nums.length <= 10^5
- -10^4 <= nums[i] <= 10^4
- 1 <= k <= nums.length',
    'hard',
    1000,
    256,
    ARRAY['队列', '数组', '滑动窗口', '单调队列'],
    $json$[
  {
    "input": "nums = [1, 3, -1, -3, 5, 3, 6, 7], k = 3",
    "output": "[3, 3, 5, 5, 6, 7]"
  },
  {
    "input": "nums = [1], k = 1",
    "output": "[1]"
  },
  {
    "input": "nums = [1, -1], k = 1",
    "output": "[1, -1]"
  },
  {
    "input": "nums = [4, 3, 2], k = 2",
    "output": "[4, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3, -1, -3, 5, 3, 6, 7], k = 3",
    "output": "[3, 3, 5, 5, 6, 7]"
  },
  {
    "input": "nums = [1], k = 1",
    "output": "[1]"
  },
  {
    "input": "nums = [1, -1], k = 1",
    "output": "[1, -1]"
  },
  {
    "input": "nums = [4, 3, 2], k = 2",
    "output": "[4, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxSlidingWindow = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def maxSlidingWindow(self, nums: list[int], k: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> maxSlidingWindow(std::vector<int>& nums, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] maxSlidingWindow(int[] nums, int k) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxSlidingWindow",
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
          3,
          -1,
          -3,
          5,
          3,
          6,
          7
        ],
        3
      ],
      "expected": [
        3,
        3,
        5,
        5,
        6,
        7
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
          -1
        ],
        1
      ],
      "expected": [
        1,
        -1
      ]
    },
    {
      "args": [
        [
          4,
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
        3,
        1,
        2,
        0,
        5
      ],
      3
    ],
    "expected": [
      3,
      3,
      2,
      5
    ]
  },
  {
    "args": [
      [
        9,
        8,
        7,
        6,
        5
      ],
      3
    ],
    "expected": [
      9,
      8,
      7
    ]
  },
  {
    "args": [
      [
        0,
        0
      ],
      2
    ],
    "expected": [
      0
    ]
  },
  {
    "args": [
      [
        -1,
        -2,
        -3
      ],
      2
    ],
    "expected": [
      -1,
      -2
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
      4
    ],
    "expected": [
      4
    ]
  },
  {
    "args": [
      [
        7,
        2,
        4
      ],
      2
    ],
    "expected": [
      7,
      4
    ]
  },
  {
    "args": [
      [
        5,
        1,
        2
      ],
      1
    ],
    "expected": [
      5,
      1,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1182,
    '最小覆盖子串',
    '给定两个字符串 s 和 t，返回 s 中涵盖 t 所有字符的最小子串。
如果 s 中不存在涵盖 t 所有字符的子串，返回空字符串 ""。
如果存在多个符合条件的子串，返回其中最靠左的一个。

提示：
- 1 <= s.length, t.length <= 10^5
- s 和 t 由英文字母组成',
    'hard',
    1000,
    256,
    ARRAY['字符串', '哈希表', '滑动窗口'],
    $json$[
  {
    "input": "s = \"ADOBECODEBANC\", t = \"ABC\"",
    "output": "\"BANC\""
  },
  {
    "input": "s = \"a\", t = \"a\"",
    "output": "\"a\""
  },
  {
    "input": "s = \"a\", t = \"aa\"",
    "output": "\"\""
  },
  {
    "input": "s = \"aa\", t = \"aa\"",
    "output": "\"aa\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"ADOBECODEBANC\", t = \"ABC\"",
    "output": "\"BANC\""
  },
  {
    "input": "s = \"a\", t = \"a\"",
    "output": "\"a\""
  },
  {
    "input": "s = \"a\", t = \"aa\"",
    "output": "\"\""
  },
  {
    "input": "s = \"aa\", t = \"aa\"",
    "output": "\"aa\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var minWindow = function(s, t) {\n};\n",
  "python": "class Solution:\n    def minWindow(self, s: str, t: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string minWindow(std::string s, std::string t) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String minWindow(String s, String t) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minWindow",
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
        "ADOBECODEBANC",
        "ABC"
      ],
      "expected": "BANC"
    },
    {
      "args": [
        "a",
        "a"
      ],
      "expected": "a"
    },
    {
      "args": [
        "a",
        "aa"
      ],
      "expected": ""
    },
    {
      "args": [
        "aa",
        "aa"
      ],
      "expected": "aa"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "ab",
      "b"
    ],
    "expected": "b"
  },
  {
    "args": [
      "abc",
      "c"
    ],
    "expected": "c"
  },
  {
    "args": [
      "abc",
      "d"
    ],
    "expected": ""
  },
  {
    "args": [
      "aaflslflsldkalskaaa",
      "aaa"
    ],
    "expected": "aaa"
  },
  {
    "args": [
      "cabwefgewcwaefgcf",
      "cae"
    ],
    "expected": "cwae"
  },
  {
    "args": [
      "a",
      "b"
    ],
    "expected": ""
  },
  {
    "args": [
      "bba",
      "ab"
    ],
    "expected": "ba"
  },
  {
    "args": [
      "abcabc",
      "bc"
    ],
    "expected": "bc"
  }
]$json$::jsonb,
    'approved'
),
(
    1183,
    '正则表达式匹配',
    '给定一个字符串 s 和一个字符规律 p，实现支持 ''.'' 和 ''*'' 的正则表达式匹配。
''.'' 匹配任意单个字符。
''*'' 匹配零个或多个前面的那一个元素。
匹配必须覆盖整个字符串 s，而不是部分字符串。

提示：
- 1 <= s.length <= 20
- 1 <= p.length <= 20
- s 只包含小写英文字母
- p 只包含小写英文字母以及字符 ''.'' 和 ''*''
- 保证每次出现字符 ''*'' 时，前面都匹配到有效的字符',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划', '递归'],
    $json$[
  {
    "input": "s = \"aa\", p = \"a\"",
    "output": "false"
  },
  {
    "input": "s = \"aa\", p = \"a*\"",
    "output": "true"
  },
  {
    "input": "s = \"ab\", p = \".*\"",
    "output": "true"
  },
  {
    "input": "s = \"aab\", p = \"c*a*b\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aa\", p = \"a\"",
    "output": "false"
  },
  {
    "input": "s = \"aa\", p = \"a*\"",
    "output": "true"
  },
  {
    "input": "s = \"ab\", p = \".*\"",
    "output": "true"
  },
  {
    "input": "s = \"aab\", p = \"c*a*b\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isMatch = function(s, p) {\n};\n",
  "python": "class Solution:\n    def isMatch(self, s: str, p: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isMatch(std::string s, std::string p) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isMatch(String s, String p) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isMatch",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "p",
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
        "aa",
        "a"
      ],
      "expected": false
    },
    {
      "args": [
        "aa",
        "a*"
      ],
      "expected": true
    },
    {
      "args": [
        "ab",
        ".*"
      ],
      "expected": true
    },
    {
      "args": [
        "aab",
        "c*a*b"
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "",
      ""
    ],
    "expected": true
  },
  {
    "args": [
      "a",
      ""
    ],
    "expected": false
  },
  {
    "args": [
      "",
      "a*"
    ],
    "expected": true
  },
  {
    "args": [
      "",
      "c*"
    ],
    "expected": true
  },
  {
    "args": [
      "mississippi",
      "mis*is*p*."
    ],
    "expected": false
  },
  {
    "args": [
      "ab",
      ".*c"
    ],
    "expected": false
  },
  {
    "args": [
      "aaa",
      "a*a"
    ],
    "expected": true
  },
  {
    "args": [
      "aaa",
      "aaaa"
    ],
    "expected": false
  },
  {
    "args": [
      "abc",
      ".*"
    ],
    "expected": true
  },
  {
    "args": [
      "a",
      ".*.."
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1184,
    '通配符匹配',
    '给定一个输入字符串 s 和一个字符模式 p，实现通配符匹配，支持 ''?'' 和 ''*''：
- ''?'' 可以匹配任何单个字符
- ''*'' 可以匹配任意字符序列（包括空序列）
匹配必须覆盖整个字符串 s。

提示：
- 1 <= s.length, p.length <= 2000
- s 只包含小写英文字母
- p 只包含小写英文字母、''?'' 或 ''*''',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划', '贪心', '递归'],
    $json$[
  {
    "input": "s = \"aa\", p = \"a\"",
    "output": "false"
  },
  {
    "input": "s = \"aa\", p = \"*\"",
    "output": "true"
  },
  {
    "input": "s = \"cb\", p = \"?a\"",
    "output": "false"
  },
  {
    "input": "s = \"adceb\", p = \"*a*b\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aa\", p = \"a\"",
    "output": "false"
  },
  {
    "input": "s = \"aa\", p = \"*\"",
    "output": "true"
  },
  {
    "input": "s = \"cb\", p = \"?a\"",
    "output": "false"
  },
  {
    "input": "s = \"adceb\", p = \"*a*b\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isWildcardMatch = function(s, p) {\n};\n",
  "python": "class Solution:\n    def isWildcardMatch(self, s: str, p: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isWildcardMatch(std::string s, std::string p) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isWildcardMatch(String s, String p) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isWildcardMatch",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "p",
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
        "aa",
        "a"
      ],
      "expected": false
    },
    {
      "args": [
        "aa",
        "*"
      ],
      "expected": true
    },
    {
      "args": [
        "cb",
        "?a"
      ],
      "expected": false
    },
    {
      "args": [
        "adceb",
        "*a*b"
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "",
      ""
    ],
    "expected": true
  },
  {
    "args": [
      "",
      "*"
    ],
    "expected": true
  },
  {
    "args": [
      "",
      "?"
    ],
    "expected": false
  },
  {
    "args": [
      "a",
      "?"
    ],
    "expected": true
  },
  {
    "args": [
      "abc",
      "a*c"
    ],
    "expected": true
  },
  {
    "args": [
      "acdcb",
      "a*c?b"
    ],
    "expected": false
  },
  {
    "args": [
      "aab",
      "c*a*b"
    ],
    "expected": false
  },
  {
    "args": [
      "abcabczzzde",
      "*abc???de*"
    ],
    "expected": true
  },
  {
    "args": [
      "abc",
      "***"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1185,
    '最大矩形',
    '给定一个仅包含 0 和 1 的 rows x cols 二维二进制矩阵，找出只包含 1 的最大矩形，并返回其面积。

提示：
- rows == matrix.length
- cols == matrix[i].length
- 1 <= rows, cols <= 200
- matrix[i][j] 为 0 或 1',
    'hard',
    1000,
    256,
    ARRAY['栈', '数组', '动态规划', '矩阵', '单调栈'],
    $json$[
  {
    "input": "matrix = [[1, 0, 1, 0, 0], [1, 0, 1, 1, 1], [1, 1, 1, 1, 1], [1, 0, 0, 1, 0]]",
    "output": "6"
  },
  {
    "input": "matrix = [[0]]",
    "output": "0"
  },
  {
    "input": "matrix = [[1]]",
    "output": "1"
  },
  {
    "input": "matrix = [[1, 1], [1, 1]]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 0, 1, 0, 0], [1, 0, 1, 1, 1], [1, 1, 1, 1, 1], [1, 0, 0, 1, 0]]",
    "output": "6"
  },
  {
    "input": "matrix = [[0]]",
    "output": "0"
  },
  {
    "input": "matrix = [[1]]",
    "output": "1"
  },
  {
    "input": "matrix = [[1, 1], [1, 1]]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximalRectangle = function(matrix) {\n};\n",
  "python": "class Solution:\n    def maximalRectangle(self, matrix: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximalRectangle(std::vector<std::vector<int>>& matrix) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximalRectangle(int[][] matrix) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximalRectangle",
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
            1,
            0,
            1,
            0,
            0
          ],
          [
            1,
            0,
            1,
            1,
            1
          ],
          [
            1,
            1,
            1,
            1,
            1
          ],
          [
            1,
            0,
            0,
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
          1,
          1,
          0
        ],
        [
          1,
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
          0,
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
    "expected": 6
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
    "expected": 6
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
          0,
          0,
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
    1186,
    '课程表',
    '你需要选修 numCourses 门课程，记为 0 到 numCourses - 1。
先修课程按数组 prerequisites 给出，其中 prerequisites[i] = [ai, bi] 表示如果要学习课程 ai，则必须先学习课程 bi。
判断是否可能完成所有课程的学习。

提示：
- 1 <= numCourses <= 2000
- 0 <= prerequisites.length <= 5000
- prerequisites[i].length == 2
- 0 <= ai, bi < numCourses
- 所有先修条件对互不相同',
    'hard',
    1000,
    256,
    ARRAY['深度优先搜索', '广度优先搜索', '图', '拓扑排序'],
    $json$[
  {
    "input": "numCourses = 2, prerequisites = [[1, 0]]",
    "output": "true"
  },
  {
    "input": "numCourses = 2, prerequisites = [[1, 0], [0, 1]]",
    "output": "false"
  },
  {
    "input": "numCourses = 1, prerequisites = []",
    "output": "true"
  },
  {
    "input": "numCourses = 3, prerequisites = [[0, 1], [1, 2]]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "numCourses = 2, prerequisites = [[1, 0]]",
    "output": "true"
  },
  {
    "input": "numCourses = 2, prerequisites = [[1, 0], [0, 1]]",
    "output": "false"
  },
  {
    "input": "numCourses = 1, prerequisites = []",
    "output": "true"
  },
  {
    "input": "numCourses = 3, prerequisites = [[0, 1], [1, 2]]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canFinish = function(numCourses, prerequisites) {\n};\n",
  "python": "class Solution:\n    def canFinish(self, numCourses: int, prerequisites: list[list[int]]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canFinish(int numCourses, std::vector<std::vector<int>>& prerequisites) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canFinish(int numCourses, int[][] prerequisites) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canFinish",
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
  "return_type": "bool",
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
      "expected": true
    },
    {
      "args": [
        2,
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
        1,
        []
      ],
      "expected": true
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
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
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
    "expected": true
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
    "expected": true
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
          1,
          2
        ],
        [
          2,
          0
        ]
      ]
    ],
    "expected": false
  },
  {
    "args": [
      5,
      []
    ],
    "expected": true
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
      2,
      []
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1187,
    '腐烂的橘子',
    '在给定的 m x n 网格 grid 中，每个单元格可以是：
- 0 表示空单元格
- 1 表示新鲜橘子
- 2 表示腐烂的橘子
每分钟，腐烂橘子会使其上下左右相邻的新鲜橘子腐烂。返回直到网格中没有新鲜橘子所需的最少分钟数。
如果不可能，返回 -1。

提示：
- m == grid.length
- n == grid[i].length
- 1 <= m, n <= 10
- grid[i][j] 为 0、1 或 2',
    'hard',
    1000,
    256,
    ARRAY['广度优先搜索', '数组', '矩阵'],
    $json$[
  {
    "input": "grid = [[2, 1, 1], [1, 1, 0], [0, 1, 1]]",
    "output": "4"
  },
  {
    "input": "grid = [[2, 1, 1], [0, 1, 1], [1, 0, 1]]",
    "output": "-1"
  },
  {
    "input": "grid = [[0, 2]]",
    "output": "0"
  },
  {
    "input": "grid = [[0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[2, 1, 1], [1, 1, 0], [0, 1, 1]]",
    "output": "4"
  },
  {
    "input": "grid = [[2, 1, 1], [0, 1, 1], [1, 0, 1]]",
    "output": "-1"
  },
  {
    "input": "grid = [[0, 2]]",
    "output": "0"
  },
  {
    "input": "grid = [[0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var orangesRotting = function(grid) {\n};\n",
  "python": "class Solution:\n    def orangesRotting(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int orangesRotting(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int orangesRotting(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "orangesRotting",
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
            2,
            1,
            1
          ],
          [
            1,
            1,
            0
          ],
          [
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
            2,
            1,
            1
          ],
          [
            0,
            1,
            1
          ],
          [
            1,
            0,
            1
          ]
        ]
      ],
      "expected": -1
    },
    {
      "args": [
        [
          [
            0,
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
          1
        ]
      ]
    ],
    "expected": -1
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
          0,
          1
        ]
      ]
    ],
    "expected": -1
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
          2,
          0
        ],
        [
          0,
          1
        ]
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        [
          2,
          1,
          1
        ],
        [
          1,
          1,
          1
        ],
        [
          0,
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
    1188,
    '单词接龙',
    '给定两个单词 beginWord 和 endWord，以及一个单词列表 wordList。
一次转换只能改变一个字母，且转换后的单词必须存在于 wordList 中。
返回从 beginWord 到 endWord 的最短转换序列中的单词数目。如果不存在这样的转换序列，返回 0。

提示：
- 1 <= beginWord.length <= 10
- endWord.length == beginWord.length
- 1 <= wordList.length <= 5000
- wordList[i].length == beginWord.length
- beginWord、endWord 和 wordList[i] 仅由小写英文字母组成
- wordList 中的所有单词互不相同',
    'hard',
    1000,
    256,
    ARRAY['广度优先搜索', '哈希表', '字符串'],
    $json$[
  {
    "input": "beginWord = \"hit\", endWord = \"cog\", wordList = [\"hot\", \"dot\", \"dog\", \"lot\", \"log\", \"cog\"]",
    "output": "5"
  },
  {
    "input": "beginWord = \"hit\", endWord = \"cog\", wordList = [\"hot\", \"dot\", \"dog\", \"lot\", \"log\"]",
    "output": "0"
  },
  {
    "input": "beginWord = \"a\", endWord = \"c\", wordList = [\"a\", \"b\", \"c\"]",
    "output": "2"
  },
  {
    "input": "beginWord = \"hit\", endWord = \"hot\", wordList = [\"hot\"]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "beginWord = \"hit\", endWord = \"cog\", wordList = [\"hot\", \"dot\", \"dog\", \"lot\", \"log\", \"cog\"]",
    "output": "5"
  },
  {
    "input": "beginWord = \"hit\", endWord = \"cog\", wordList = [\"hot\", \"dot\", \"dog\", \"lot\", \"log\"]",
    "output": "0"
  },
  {
    "input": "beginWord = \"a\", endWord = \"c\", wordList = [\"a\", \"b\", \"c\"]",
    "output": "2"
  },
  {
    "input": "beginWord = \"hit\", endWord = \"hot\", wordList = [\"hot\"]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var ladderLength = function(beginWord, endWord, wordList) {\n};\n",
  "python": "class Solution:\n    def ladderLength(self, beginWord: str, endWord: str, wordList: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int ladderLength(std::string beginWord, std::string endWord, std::vector<std::string>& wordList) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int ladderLength(String beginWord, String endWord, String[] wordList) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "ladderLength",
  "params": [
    {
      "name": "beginWord",
      "type": "string"
    },
    {
      "name": "endWord",
      "type": "string"
    },
    {
      "name": "wordList",
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
        "hit",
        "cog",
        [
          "hot",
          "dot",
          "dog",
          "lot",
          "log",
          "cog"
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        "hit",
        "cog",
        [
          "hot",
          "dot",
          "dog",
          "lot",
          "log"
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        "a",
        "c",
        [
          "a",
          "b",
          "c"
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        "hit",
        "hot",
        [
          "hot"
        ]
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      "c",
      [
        "b",
        "c"
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      "a",
      "c",
      [
        "c"
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      "a",
      "c",
      [
        "b"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      "hot",
      "dog",
      [
        "hot",
        "dot",
        "dog"
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      "red",
      "tax",
      [
        "ted",
        "tex",
        "red",
        "tax",
        "tad",
        "den",
        "rex",
        "pee"
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1189,
    '戳气球',
    '有 n 个气球，编号为 0 到 n - 1，每个气球上标有一个数字，这些数字用数组 nums 表示。
现在要求戳破所有气球。戳破第 i 个气球可以获得 nums[i - 1] * nums[i] * nums[i + 1] 枚硬币。
这里的 i - 1 和 i + 1 表示和 i 相邻的气球的编号。如果 i - 1 或 i + 1 超出数组边界，则视为数字 1 的气球。
返回戳破所有气球能获得的最多硬币数。

提示：
- 1 <= nums.length <= 20
- 1 <= nums[i] <= 100',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '分治'],
    $json$[
  {
    "input": "nums = [3, 1, 5, 8]",
    "output": "167"
  },
  {
    "input": "nums = [1, 5]",
    "output": "10"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "12"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 1, 5, 8]",
    "output": "167"
  },
  {
    "input": "nums = [1, 5]",
    "output": "10"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "12"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxCoins = function(nums) {\n};\n",
  "python": "class Solution:\n    def maxCoins(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxCoins(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxCoins(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxCoins",
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
          1,
          5,
          8
        ]
      ],
      "expected": 167
    },
    {
      "args": [
        [
          1,
          5
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
          2,
          3
        ]
      ],
      "expected": 12
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
    "expected": 2
  },
  {
    "args": [
      [
        2,
        3
      ]
    ],
    "expected": 9
  },
  {
    "args": [
      [
        2,
        3,
        4
      ]
    ],
    "expected": 36
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
    "expected": 40
  },
  {
    "args": [
      [
        5,
        1,
        2
      ]
    ],
    "expected": 25
  },
  {
    "args": [
      [
        7,
        9,
        8
      ]
    ],
    "expected": 568
  }
]$json$::jsonb,
    'approved'
),
(
    1190,
    '单词搜索',
    '给定一个 m x n 的二维字符网格 board 和一个字符串单词 word，如果 word 存在于网格中，返回 true；否则返回 false。
单词必须按照字母顺序，通过相邻的单元格内的字母构成。相邻单元格是水平或垂直方向上的单元格。
同一个单元格内的字母不允许被重复使用。

提示：
- m == board.length
- n == board[i].length
- 1 <= m, n <= 6
- 1 <= word.length <= 15
- board 和 word 仅由大小写英文字母组成',
    'hard',
    1000,
    256,
    ARRAY['数组', '回溯', '矩阵', '深度优先搜索'],
    $json$[
  {
    "input": "board = [[\"A\", \"B\", \"C\", \"E\"], [\"S\", \"F\", \"C\", \"S\"], [\"A\", \"D\", \"E\", \"E\"]], word = \"ABCCED\"",
    "output": "true"
  },
  {
    "input": "board = [[\"A\", \"B\", \"C\", \"E\"], [\"S\", \"F\", \"C\", \"S\"], [\"A\", \"D\", \"E\", \"E\"]], word = \"SEE\"",
    "output": "true"
  },
  {
    "input": "board = [[\"A\", \"B\", \"C\", \"E\"], [\"S\", \"F\", \"C\", \"S\"], [\"A\", \"D\", \"E\", \"E\"]], word = \"ABCB\"",
    "output": "false"
  },
  {
    "input": "board = [[\"a\"]], word = \"a\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "board = [[\"A\", \"B\", \"C\", \"E\"], [\"S\", \"F\", \"C\", \"S\"], [\"A\", \"D\", \"E\", \"E\"]], word = \"ABCCED\"",
    "output": "true"
  },
  {
    "input": "board = [[\"A\", \"B\", \"C\", \"E\"], [\"S\", \"F\", \"C\", \"S\"], [\"A\", \"D\", \"E\", \"E\"]], word = \"SEE\"",
    "output": "true"
  },
  {
    "input": "board = [[\"A\", \"B\", \"C\", \"E\"], [\"S\", \"F\", \"C\", \"S\"], [\"A\", \"D\", \"E\", \"E\"]], word = \"ABCB\"",
    "output": "false"
  },
  {
    "input": "board = [[\"a\"]], word = \"a\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var exist = function(board, word) {\n};\n",
  "python": "class Solution:\n    def exist(self, board: list[list[str]], word: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool exist(std::vector<std::vector<std::string>>& board, std::string word) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean exist(String[][] board, String word) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "exist",
  "params": [
    {
      "name": "board",
      "type": "string[][]"
    },
    {
      "name": "word",
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
          [
            "A",
            "B",
            "C",
            "E"
          ],
          [
            "S",
            "F",
            "C",
            "S"
          ],
          [
            "A",
            "D",
            "E",
            "E"
          ]
        ],
        "ABCCED"
      ],
      "expected": true
    },
    {
      "args": [
        [
          [
            "A",
            "B",
            "C",
            "E"
          ],
          [
            "S",
            "F",
            "C",
            "S"
          ],
          [
            "A",
            "D",
            "E",
            "E"
          ]
        ],
        "SEE"
      ],
      "expected": true
    },
    {
      "args": [
        [
          [
            "A",
            "B",
            "C",
            "E"
          ],
          [
            "S",
            "F",
            "C",
            "S"
          ],
          [
            "A",
            "D",
            "E",
            "E"
          ]
        ],
        "ABCB"
      ],
      "expected": false
    },
    {
      "args": [
        [
          [
            "a"
          ]
        ],
        "a"
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
          "a"
        ]
      ],
      "b"
    ],
    "expected": false
  },
  {
    "args": [
      [
        [
          "a",
          "b"
        ],
        [
          "c",
          "d"
        ]
      ],
      "abdc"
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          "a",
          "b"
        ],
        [
          "c",
          "d"
        ]
      ],
      "abcd"
    ],
    "expected": false
  },
  {
    "args": [
      [
        [
          "a",
          "a"
        ]
      ],
      "aaa"
    ],
    "expected": false
  },
  {
    "args": [
      [
        [
          "C",
          "A",
          "A"
        ],
        [
          "A",
          "A",
          "A"
        ],
        [
          "B",
          "C",
          "D"
        ]
      ],
      "AAB"
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          "A",
          "B",
          "C",
          "E"
        ],
        [
          "S",
          "F",
          "C",
          "S"
        ],
        [
          "A",
          "D",
          "E",
          "E"
        ]
      ],
      "ABCCEE"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1191,
    'N 皇后',
    'n 皇后问题研究的是如何将 n 个皇后放置在 n x n 的棋盘上，并且使皇后彼此之间不能相互攻击。
给定一个整数 n，返回 n 皇后问题不同的解决方案的数量。

提示：
- 1 <= n <= 9',
    'hard',
    1000,
    256,
    ARRAY['数组', '回溯'],
    $json$[
  {
    "input": "n = 4",
    "output": "2"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 8",
    "output": "92"
  },
  {
    "input": "n = 9",
    "output": "352"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4",
    "output": "2"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 8",
    "output": "92"
  },
  {
    "input": "n = 9",
    "output": "352"
  }
]$json$::jsonb,
    $json${
  "javascript": "var totalNQueens = function(n) {\n};\n",
  "python": "class Solution:\n    def totalNQueens(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int totalNQueens(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int totalNQueens(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "totalNQueens",
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
        4
      ],
      "expected": 2
    },
    {
      "args": [
        1
      ],
      "expected": 1
    },
    {
      "args": [
        8
      ],
      "expected": 92
    },
    {
      "args": [
        9
      ],
      "expected": 352
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
    "expected": 0
  },
  {
    "args": [
      5
    ],
    "expected": 10
  },
  {
    "args": [
      6
    ],
    "expected": 4
  },
  {
    "args": [
      7
    ],
    "expected": 40
  },
  {
    "args": [
      10
    ],
    "expected": 724
  }
]$json$::jsonb,
    'approved'
),
(
    1192,
    '不同的子序列',
    '给定一个字符串 s 和一个字符串 t，统计并返回在 s 的子序列中 t 出现的个数。
题目数据保证答案符合 32 位带符号整数范围。

提示：
- 1 <= s.length, t.length <= 1000
- s 和 t 由英文字母组成',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "s = \"rabbbit\", t = \"rabbit\"",
    "output": "3"
  },
  {
    "input": "s = \"babgbag\", t = \"bag\"",
    "output": "5"
  },
  {
    "input": "s = \"a\", t = \"a\"",
    "output": "1"
  },
  {
    "input": "s = \"a\", t = \"b\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"rabbbit\", t = \"rabbit\"",
    "output": "3"
  },
  {
    "input": "s = \"babgbag\", t = \"bag\"",
    "output": "5"
  },
  {
    "input": "s = \"a\", t = \"a\"",
    "output": "1"
  },
  {
    "input": "s = \"a\", t = \"b\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numDistinct = function(s, t) {\n};\n",
  "python": "class Solution:\n    def numDistinct(self, s: str, t: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numDistinct(std::string s, std::string t) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numDistinct(String s, String t) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numDistinct",
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
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "rabbbit",
        "rabbit"
      ],
      "expected": 3
    },
    {
      "args": [
        "babgbag",
        "bag"
      ],
      "expected": 5
    },
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
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abc",
      ""
    ],
    "expected": 1
  },
  {
    "args": [
      "",
      "a"
    ],
    "expected": 0
  },
  {
    "args": [
      "aaa",
      "a"
    ],
    "expected": 3
  },
  {
    "args": [
      "aaa",
      "aa"
    ],
    "expected": 3
  },
  {
    "args": [
      "abcabc",
      "abc"
    ],
    "expected": 4
  },
  {
    "args": [
      "aabb",
      "ab"
    ],
    "expected": 4
  },
  {
    "args": [
      "abc",
      "abc"
    ],
    "expected": 1
  },
  {
    "args": [
      "aaaa",
      "aa"
    ],
    "expected": 6
  },
  {
    "args": [
      "abab",
      "ab"
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1193,
    '最长回文子序列',
    '给定一个字符串 s，找出其中最长的回文子序列，并返回该序列的长度。
子序列是从字符串中删除某些字符或不删除字符后得到的新字符串，不改变剩余字符的相对顺序。

提示：
- 1 <= s.length <= 1000
- s 仅由小写英文字母组成',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "s = \"bbbab\"",
    "output": "4"
  },
  {
    "input": "s = \"cbbd\"",
    "output": "2"
  },
  {
    "input": "s = \"a\"",
    "output": "1"
  },
  {
    "input": "s = \"\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"bbbab\"",
    "output": "4"
  },
  {
    "input": "s = \"cbbd\"",
    "output": "2"
  },
  {
    "input": "s = \"a\"",
    "output": "1"
  },
  {
    "input": "s = \"\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestPalindromeSubseq = function(s) {\n};\n",
  "python": "class Solution:\n    def longestPalindromeSubseq(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestPalindromeSubseq(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestPalindromeSubseq(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestPalindromeSubseq",
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
        "bbbab"
      ],
      "expected": 4
    },
    {
      "args": [
        "cbbd"
      ],
      "expected": 2
    },
    {
      "args": [
        "a"
      ],
      "expected": 1
    },
    {
      "args": [
        ""
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "aaaa"
    ],
    "expected": 4
  },
  {
    "args": [
      "abcde"
    ],
    "expected": 1
  },
  {
    "args": [
      "aabaa"
    ],
    "expected": 5
  },
  {
    "args": [
      "abacdfgdcaba"
    ],
    "expected": 11
  },
  {
    "args": [
      "racecar"
    ],
    "expected": 7
  },
  {
    "args": [
      "abbc"
    ],
    "expected": 2
  },
  {
    "args": [
      "leetcode"
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1194,
    '计算右侧小于当前元素的个数',
    '给定一个整数数组 nums，按要求返回一个新数组 counts。
数组 counts 有该性质：counts[i] 的值是 nums[i] 右侧小于 nums[i] 的元素的数量。

提示：
- 1 <= nums.length <= 10^5
- -10^4 <= nums[i] <= 10^4',
    'hard',
    1000,
    256,
    ARRAY['数组', '二分查找', '分治', '树状数组'],
    $json$[
  {
    "input": "nums = [5, 2, 6, 1]",
    "output": "[2, 1, 1, 0]"
  },
  {
    "input": "nums = [2, 2, 2]",
    "output": "[0, 0, 0]"
  },
  {
    "input": "nums = [-1]",
    "output": "[0]"
  },
  {
    "input": "nums = [-1, -1]",
    "output": "[0, 0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [5, 2, 6, 1]",
    "output": "[2, 1, 1, 0]"
  },
  {
    "input": "nums = [2, 2, 2]",
    "output": "[0, 0, 0]"
  },
  {
    "input": "nums = [-1]",
    "output": "[0]"
  },
  {
    "input": "nums = [-1, -1]",
    "output": "[0, 0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countSmaller = function(nums) {\n};\n",
  "python": "class Solution:\n    def countSmaller(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> countSmaller(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] countSmaller(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countSmaller",
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
          5,
          2,
          6,
          1
        ]
      ],
      "expected": [
        2,
        1,
        1,
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
        0,
        0,
        0
      ]
    },
    {
      "args": [
        [
          -1
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
          -1
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
        1,
        2,
        3,
        4
      ]
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
      [
        4,
        3,
        2,
        1
      ]
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
      [
        1,
        1,
        1
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
        -1,
        -2
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
        3,
        1,
        2
      ]
    ],
    "expected": [
      2,
      0,
      0
    ]
  },
  {
    "args": [
      [
        5,
        4,
        3,
        2,
        1,
        0
      ]
    ],
    "expected": [
      5,
      4,
      3,
      2,
      1,
      0
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
      2,
      0,
      0
    ]
  },
  {
    "args": [
      [
        1,
        3,
        2,
        4,
        0
      ]
    ],
    "expected": [
      1,
      2,
      1,
      1,
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1195,
    '翻转对',
    '给定一个整数数组 nums，如果 i < j 且 nums[i] > 2 * nums[j]，则将 (i, j) 称为一个翻转对。
返回给定数组中翻转对的数量。

提示：
- 1 <= nums.length <= 5 * 10^4
- -2^31 <= nums[i] <= 2^31 - 1',
    'hard',
    1000,
    256,
    ARRAY['数组', '分治', '归并排序', '树状数组'],
    $json$[
  {
    "input": "nums = [1, 3, 2, 3, 1]",
    "output": "2"
  },
  {
    "input": "nums = [2, 4, 3, 5, 1]",
    "output": "3"
  },
  {
    "input": "nums = []",
    "output": "0"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3, 2, 3, 1]",
    "output": "2"
  },
  {
    "input": "nums = [2, 4, 3, 5, 1]",
    "output": "3"
  },
  {
    "input": "nums = []",
    "output": "0"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var reversePairs = function(nums) {\n};\n",
  "python": "class Solution:\n    def reversePairs(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int reversePairs(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int reversePairs(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reversePairs",
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
          3,
          1
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          2,
          4,
          3,
          5,
          1
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        []
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
        1,
        2,
        3,
        4,
        5
      ]
    ],
    "expected": 0
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
        -5,
        -5
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
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1196,
    '矩阵中的最长递增路径',
    '给定一个 m x n 的整数矩阵 matrix，找出其中最长递增路径的长度。
对于每个单元格，可以往上、下、左、右四个方向移动。不能沿对角线移动，也不能移动到矩阵边界外。
不能在一个递增路径中重复经过同一个单元格。

提示：
- m == matrix.length
- n == matrix[i].length
- 1 <= m, n <= 200
- 0 <= matrix[i][j] <= 2^31 - 1',
    'hard',
    1000,
    256,
    ARRAY['深度优先搜索', '广度优先搜索', '动态规划', '记忆化搜索', '矩阵'],
    $json$[
  {
    "input": "matrix = [[9, 9, 4], [6, 6, 8], [2, 1, 1]]",
    "output": "4"
  },
  {
    "input": "matrix = [[3, 4, 5], [3, 2, 6], [2, 2, 1]]",
    "output": "4"
  },
  {
    "input": "matrix = [[1]]",
    "output": "1"
  },
  {
    "input": "matrix = [[1, 2], [4, 3]]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[9, 9, 4], [6, 6, 8], [2, 1, 1]]",
    "output": "4"
  },
  {
    "input": "matrix = [[3, 4, 5], [3, 2, 6], [2, 2, 1]]",
    "output": "4"
  },
  {
    "input": "matrix = [[1]]",
    "output": "1"
  },
  {
    "input": "matrix = [[1, 2], [4, 3]]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestIncreasingPath = function(matrix) {\n};\n",
  "python": "class Solution:\n    def longestIncreasingPath(self, matrix: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestIncreasingPath(std::vector<std::vector<int>>& matrix) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestIncreasingPath(int[][] matrix) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestIncreasingPath",
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
            9,
            9,
            4
          ],
          [
            6,
            6,
            8
          ],
          [
            2,
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
            3,
            4,
            5
          ],
          [
            3,
            2,
            6
          ],
          [
            2,
            2,
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
            1,
            2
          ],
          [
            4,
            3
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
          1
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
    "expected": 9
  },
  {
    "args": [
      [
        [
          0,
          1,
          2
        ],
        [
          3,
          4,
          5
        ],
        [
          6,
          7,
          8
        ]
      ]
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1197,
    '俄罗斯套娃信封问题',
    '给定一个二维整数数组 envelopes，其中 envelopes[i] = [wi, hi] 表示第 i 个信封的宽度和高度。
当另一个信封的宽度和高度都比这个信封大时，这个信封就可以放进另一个信封里。
请计算最多能组成多少个信封嵌套（不允许旋转信封）。

提示：
- 1 <= envelopes.length <= 5000
- envelopes[i].length == 2
- 1 <= wi, hi <= 10^4',
    'hard',
    1000,
    256,
    ARRAY['数组', '二分查找', '动态规划', '排序'],
    $json$[
  {
    "input": "envelopes = [[5, 4], [6, 4], [6, 7], [2, 3]]",
    "output": "3"
  },
  {
    "input": "envelopes = [[1, 1], [1, 1], [1, 1]]",
    "output": "1"
  },
  {
    "input": "envelopes = [[1, 2]]",
    "output": "1"
  },
  {
    "input": "envelopes = [[2, 3], [3, 4], [4, 5]]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "envelopes = [[5, 4], [6, 4], [6, 7], [2, 3]]",
    "output": "3"
  },
  {
    "input": "envelopes = [[1, 1], [1, 1], [1, 1]]",
    "output": "1"
  },
  {
    "input": "envelopes = [[1, 2]]",
    "output": "1"
  },
  {
    "input": "envelopes = [[2, 3], [3, 4], [4, 5]]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxEnvelopes = function(envelopes) {\n};\n",
  "python": "class Solution:\n    def maxEnvelopes(self, envelopes: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxEnvelopes(std::vector<std::vector<int>>& envelopes) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxEnvelopes(int[][] envelopes) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxEnvelopes",
  "params": [
    {
      "name": "envelopes",
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
            5,
            4
          ],
          [
            6,
            4
          ],
          [
            6,
            7
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
          ],
          [
            4,
            5
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
    "expected": 4
  },
  {
    "args": [
      [
        [
          4,
          5
        ],
        [
          4,
          6
        ],
        [
          6,
          7
        ],
        [
          2,
          3
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
    "expected": 3
  },
  {
    "args": [
      [
        [
          10,
          8
        ],
        [
          9,
          9
        ],
        [
          8,
          10
        ],
        [
          7,
          11
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
          100
        ],
        [
          3,
          200
        ],
        [
          4,
          300
        ],
        [
          5,
          400
        ],
        [
          5,
          500
        ],
        [
          6,
          600
        ]
      ]
    ],
    "expected": 5
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
    GREATEST((SELECT COALESCE(MAX(id), 1) FROM problems), 1197)
);

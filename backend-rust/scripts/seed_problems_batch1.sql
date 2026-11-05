-- 仅用于本地/测试环境的题目种子数据。
-- 使用固定 ID 1300-1499，便于通过 clean_dev.sql 安全清理。
-- 200 道函数式题目（run_config + 公开用例 + 隐藏 judge_cases），
-- 与 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）、seed_problems_82.sql（1116-1197）、seed_problems_100.sql（1200-1299）合计 400 题。

INSERT INTO problems (
    id, title, description, difficulty, time_limit, memory_limit, tags,
    examples, test_cases, code_template, run_config, judge_cases, review_status
) VALUES
(
    1300,
    '按奇偶排序数组',
    '给定一个整数数组 nums，将所有偶数移到数组前面、所有奇数移到数组后面。
要求保持偶数和奇数各自原有的相对顺序，返回处理后的数组。',
    'easy',
    1000,
    256,
    ARRAY['数组', '双指针'],
    $json$[
  {
    "input": "nums = [3, 1, 2, 4]",
    "output": "[2, 4, 3, 1]"
  },
  {
    "input": "nums = [0]",
    "output": "[0]"
  },
  {
    "input": "nums = [1, 3, 5]",
    "output": "[1, 3, 5]"
  },
  {
    "input": "nums = [2, 4, 6]",
    "output": "[2, 4, 6]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 1, 2, 4]",
    "output": "[2, 4, 3, 1]"
  },
  {
    "input": "nums = [0]",
    "output": "[0]"
  },
  {
    "input": "nums = [1, 3, 5]",
    "output": "[1, 3, 5]"
  },
  {
    "input": "nums = [2, 4, 6]",
    "output": "[2, 4, 6]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sortArrayByParity = function(nums) {\n};\n",
  "python": "class Solution:\n    def sortArrayByParity(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> sortArrayByParity(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] sortArrayByParity(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sortArrayByParity",
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
          3,
          1,
          2,
          4
        ]
      ],
      "expected": [
        2,
        4,
        3,
        1
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
          3,
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
          2,
          4,
          6
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
      4,
      6,
      1,
      3,
      5
    ]
  },
  {
    "args": [
      [
        -2,
        -1,
        0,
        1
      ]
    ],
    "expected": [
      -2,
      0,
      -1,
      1
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
      0,
      1
    ]
  },
  {
    "args": [
      [
        7,
        6,
        5,
        4,
        3,
        2,
        1
      ]
    ],
    "expected": [
      6,
      4,
      2,
      7,
      5,
      3,
      1
    ]
  },
  {
    "args": [
      [
        2,
        1,
        4,
        3
      ]
    ],
    "expected": [
      2,
      4,
      1,
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1301,
    '高度检查器',
    '给定数组 heights，返回将其按非递减顺序排序后，与原数组对应位置元素不同的位置数量。',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "heights = [1, 1, 4, 2, 1, 3]",
    "output": "3"
  },
  {
    "input": "heights = [5, 1, 2, 3, 4]",
    "output": "5"
  },
  {
    "input": "heights = [1, 2, 3, 4, 5]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "heights = [1, 1, 4, 2, 1, 3]",
    "output": "3"
  },
  {
    "input": "heights = [5, 1, 2, 3, 4]",
    "output": "5"
  },
  {
    "input": "heights = [1, 2, 3, 4, 5]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var heightChecker = function(heights) {\n};\n",
  "python": "class Solution:\n    def heightChecker(self, heights: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int heightChecker(std::vector<int>& heights) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int heightChecker(int[] heights) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "heightChecker",
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
          1,
          1,
          4,
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
          5,
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
          1,
          2,
          3,
          4,
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
    "expected": 0
  },
  {
    "args": [
      [
        3,
        2,
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        10,
        6,
        6,
        10,
        10,
        9,
        8,
        8,
        3,
        3,
        8,
        2,
        1,
        5,
        9,
        10,
        2,
        4,
        8,
        4
      ]
    ],
    "expected": 18
  }
]$json$::jsonb,
    'approved'
),
(
    1302,
    '将每个元素替换为右侧最大元素',
    '对数组 arr 的每个位置 i，返回 arr[i] 右侧所有元素中的最大值。
最后一个位置右侧没有元素，返回 -1。',
    'easy',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "arr = [17, 18, 5, 4, 6, 1]",
    "output": "[18, 6, 6, 6, 1, -1]"
  },
  {
    "input": "arr = [400]",
    "output": "[-1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [17, 18, 5, 4, 6, 1]",
    "output": "[18, 6, 6, 6, 1, -1]"
  },
  {
    "input": "arr = [400]",
    "output": "[-1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var replaceElements = function(arr) {\n};\n",
  "python": "class Solution:\n    def replaceElements(self, arr: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> replaceElements(std::vector<int>& arr) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] replaceElements(int[] arr) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "replaceElements",
  "params": [
    {
      "name": "arr",
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
          17,
          18,
          5,
          4,
          6,
          1
        ]
      ],
      "expected": [
        18,
        6,
        6,
        6,
        1,
        -1
      ]
    },
    {
      "args": [
        [
          400
        ]
      ],
      "expected": [
        -1
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
      5,
      5,
      5,
      5,
      -1
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
      4,
      3,
      2,
      1,
      -1
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
      1,
      -1
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
      0,
      0,
      -1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1303,
    '复写零',
    '对数组 arr 中的每个 0，在其后复写一个 0，并将后续元素整体右移。
超出原数组长度的元素会被丢弃。返回处理后的数组。',
    'easy',
    1000,
    256,
    ARRAY['数组', '双指针'],
    $json$[
  {
    "input": "arr = [1, 0, 2, 3]",
    "output": "[1, 0, 0, 2]"
  },
  {
    "input": "arr = [0, 0, 0]",
    "output": "[0, 0, 0]"
  },
  {
    "input": "arr = [1, 2, 3]",
    "output": "[1, 2, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [1, 0, 2, 3]",
    "output": "[1, 0, 0, 2]"
  },
  {
    "input": "arr = [0, 0, 0]",
    "output": "[0, 0, 0]"
  },
  {
    "input": "arr = [1, 2, 3]",
    "output": "[1, 2, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var duplicateZeros = function(arr) {\n};\n",
  "python": "class Solution:\n    def duplicateZeros(self, arr: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> duplicateZeros(std::vector<int>& arr) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] duplicateZeros(int[] arr) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "duplicateZeros",
  "params": [
    {
      "name": "arr",
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
          0,
          2,
          3
        ]
      ],
      "expected": [
        1,
        0,
        0,
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
        0,
        0,
        2
      ]
    ],
    "expected": [
      1,
      0,
      0,
      0
    ]
  },
  {
    "args": [
      [
        0,
        1,
        0
      ]
    ],
    "expected": [
      0,
      0,
      1
    ]
  },
  {
    "args": [
      [
        1,
        2,
        0,
        3,
        4
      ]
    ],
    "expected": [
      1,
      2,
      0,
      0,
      3
    ]
  },
  {
    "args": [
      [
        9,
        0,
        8
      ]
    ],
    "expected": [
      9,
      0,
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1304,
    '检查整数及其两倍数是否存在',
    '给定整数数组 arr，判断是否存在两个不同的下标 i 和 j，使得 arr[i] == 2 * arr[j]。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "arr = [10, 2, 5, 3]",
    "output": "true"
  },
  {
    "input": "arr = [3, 1, 7, 11]",
    "output": "false"
  },
  {
    "input": "arr = [7, 1, 14, 11]",
    "output": "true"
  },
  {
    "input": "arr = [0, 0]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [10, 2, 5, 3]",
    "output": "true"
  },
  {
    "input": "arr = [3, 1, 7, 11]",
    "output": "false"
  },
  {
    "input": "arr = [7, 1, 14, 11]",
    "output": "true"
  },
  {
    "input": "arr = [0, 0]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var checkIfExist = function(arr) {\n};\n",
  "python": "class Solution:\n    def checkIfExist(self, arr: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool checkIfExist(std::vector<int>& arr) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean checkIfExist(int[] arr) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkIfExist",
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
          10,
          2,
          5,
          3
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          3,
          1,
          7,
          11
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          7,
          1,
          14,
          11
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
    "expected": false
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
        -2,
        -4
      ]
    ],
    "expected": true
  },
  {
    "args": [
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
        1,
        2
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        0
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1305,
    '仅仅反转字母',
    '给定字符串 s，反转其中所有字母的位置，非字母字符保持原位不变。返回处理后的字符串。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "s = \"ab-cd\"",
    "output": "\"dc-ba\""
  },
  {
    "input": "s = \"a-bC-dEf-ghIj\"",
    "output": "\"j-Ih-gfE-dCba\""
  },
  {
    "input": "s = \"Test1ng-Leet=code-Q!\"",
    "output": "\"Qedo1ct-eeLg=ntse-T!\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"ab-cd\"",
    "output": "\"dc-ba\""
  },
  {
    "input": "s = \"a-bC-dEf-ghIj\"",
    "output": "\"j-Ih-gfE-dCba\""
  },
  {
    "input": "s = \"Test1ng-Leet=code-Q!\"",
    "output": "\"Qedo1ct-eeLg=ntse-T!\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var reverseOnlyLetters = function(s) {\n};\n",
  "python": "class Solution:\n    def reverseOnlyLetters(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string reverseOnlyLetters(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String reverseOnlyLetters(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reverseOnlyLetters",
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
        "ab-cd"
      ],
      "expected": "dc-ba"
    },
    {
      "args": [
        "a-bC-dEf-ghIj"
      ],
      "expected": "j-Ih-gfE-dCba"
    },
    {
      "args": [
        "Test1ng-Leet=code-Q!"
      ],
      "expected": "Qedo1ct-eeLg=ntse-T!"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "-"
    ],
    "expected": "-"
  },
  {
    "args": [
      "a1b2c"
    ],
    "expected": "c1b2a"
  },
  {
    "args": [
      "!A?"
    ],
    "expected": "!A?"
  },
  {
    "args": [
      "ab"
    ],
    "expected": "ba"
  },
  {
    "args": [
      "z"
    ],
    "expected": "z"
  }
]$json$::jsonb,
    'approved'
),
(
    1306,
    '反转单词前缀',
    '给定字符串 s 和整数 k，其中 1 <= k <= s.length。
将 s 的前 k 个字符反转，其余部分保持不变，返回结果。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "s = \"abcdefd\", k = 4",
    "output": "\"dcbaefd\""
  },
  {
    "input": "s = \"xyxz\", k = 2",
    "output": "\"yxxz\""
  },
  {
    "input": "s = \"abcd\", k = 1",
    "output": "\"abcd\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abcdefd\", k = 4",
    "output": "\"dcbaefd\""
  },
  {
    "input": "s = \"xyxz\", k = 2",
    "output": "\"yxxz\""
  },
  {
    "input": "s = \"abcd\", k = 1",
    "output": "\"abcd\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var reversePrefix = function(s, k) {\n};\n",
  "python": "class Solution:\n    def reversePrefix(self, s: str, k: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string reversePrefix(std::string s, int k) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String reversePrefix(String s, int k) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reversePrefix",
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
        "abcdefd",
        4
      ],
      "expected": "dcbaefd"
    },
    {
      "args": [
        "xyxz",
        2
      ],
      "expected": "yxxz"
    },
    {
      "args": [
        "abcd",
        1
      ],
      "expected": "abcd"
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
      "ab",
      2
    ],
    "expected": "ba"
  },
  {
    "args": [
      "abcde",
      5
    ],
    "expected": "edcba"
  },
  {
    "args": [
      "hello",
      3
    ],
    "expected": "lehlo"
  }
]$json$::jsonb,
    'approved'
),
(
    1307,
    '数组中两元素的最大乘积',
    '给定整数数组 nums，选择两个不同下标的元素，返回 (nums[i] - 1) * (nums[j] - 1) 的最大值。
所有元素均为正整数。',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "nums = [3, 4, 5, 2]",
    "output": "12"
  },
  {
    "input": "nums = [1, 5, 4, 5]",
    "output": "16"
  },
  {
    "input": "nums = [3, 7]",
    "output": "12"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 4, 5, 2]",
    "output": "12"
  },
  {
    "input": "nums = [1, 5, 4, 5]",
    "output": "16"
  },
  {
    "input": "nums = [3, 7]",
    "output": "12"
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
          3,
          4,
          5,
          2
        ]
      ],
      "expected": 12
    },
    {
      "args": [
        [
          1,
          5,
          4,
          5
        ]
      ],
      "expected": 16
    },
    {
      "args": [
        [
          3,
          7
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
        1,
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        10,
        2,
        3
      ]
    ],
    "expected": 18
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
        9,
        8,
        7
      ]
    ],
    "expected": 56
  }
]$json$::jsonb,
    'approved'
),
(
    1308,
    '删除字符串两端相同字符后的最短长度',
    '每次可以删除字符串两端相同字符组成的前缀一个字符和后缀一个字符，重复该过程。
返回最终可能得到的最短字符串长度。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "s = \"ca\"",
    "output": "2"
  },
  {
    "input": "s = \"cabaabac\"",
    "output": "0"
  },
  {
    "input": "s = \"aabccabba\"",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"ca\"",
    "output": "2"
  },
  {
    "input": "s = \"cabaabac\"",
    "output": "0"
  },
  {
    "input": "s = \"aabccabba\"",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumLength = function(s) {\n};\n",
  "python": "class Solution:\n    def minimumLength(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumLength(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumLength(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumLength",
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
        "ca"
      ],
      "expected": 2
    },
    {
      "args": [
        "cabaabac"
      ],
      "expected": 0
    },
    {
      "args": [
        "aabccabba"
      ],
      "expected": 3
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
      "ab"
    ],
    "expected": 2
  },
  {
    "args": [
      "aa"
    ],
    "expected": 0
  },
  {
    "args": [
      "abba"
    ],
    "expected": 0
  },
  {
    "args": [
      "abcba"
    ],
    "expected": 1
  },
  {
    "args": [
      "aaaa"
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1309,
    '统计一致字符串的数目',
    '给定只含小写字母的字符串 allowed 和字符串数组 words。
若 word 中的每个字符都在 allowed 中出现，则称 word 是一致的。返回一致字符串的数目。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "allowed = \"ab\", words = [\"ad\", \"bd\", \"aaab\", \"baa\", \"badab\"]",
    "output": "2"
  },
  {
    "input": "allowed = \"abc\", words = [\"a\", \"b\", \"c\", \"ab\", \"ac\", \"bc\", \"abc\"]",
    "output": "7"
  },
  {
    "input": "allowed = \"cad\", words = [\"a\", \"b\", \"c\", \"ab\", \"ac\", \"bc\", \"abc\"]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "allowed = \"ab\", words = [\"ad\", \"bd\", \"aaab\", \"baa\", \"badab\"]",
    "output": "2"
  },
  {
    "input": "allowed = \"abc\", words = [\"a\", \"b\", \"c\", \"ab\", \"ac\", \"bc\", \"abc\"]",
    "output": "7"
  },
  {
    "input": "allowed = \"cad\", words = [\"a\", \"b\", \"c\", \"ab\", \"ac\", \"bc\", \"abc\"]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countConsistentStrings = function(allowed, words) {\n};\n",
  "python": "class Solution:\n    def countConsistentStrings(self, allowed: str, words: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countConsistentStrings(std::string allowed, std::vector<std::string>& words) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countConsistentStrings(String allowed, String[] words) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countConsistentStrings",
  "params": [
    {
      "name": "allowed",
      "type": "string"
    },
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
        "ab",
        [
          "ad",
          "bd",
          "aaab",
          "baa",
          "badab"
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        "abc",
        [
          "a",
          "b",
          "c",
          "ab",
          "ac",
          "bc",
          "abc"
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        "cad",
        [
          "a",
          "b",
          "c",
          "ab",
          "ac",
          "bc",
          "abc"
        ]
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      [
        "a",
        "aa",
        "b"
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      "xyz",
      [
        "x",
        "y",
        "z",
        "xy"
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      "abc",
      [
        "abcd",
        "ab",
        "c"
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1310,
    '商品折扣后的最终价格',
    '对 prices 中的每个元素，找到它右侧第一个小于等于它的价格 prices[j]。
最终价格为 prices[i] - prices[j]；若不存在这样的 j，则不打折。返回最终价格数组。',
    'easy',
    1000,
    256,
    ARRAY['数组', '单调栈'],
    $json$[
  {
    "input": "prices = [8, 4, 6, 2, 3]",
    "output": "[4, 2, 4, 2, 3]"
  },
  {
    "input": "prices = [1, 2, 3, 4, 5]",
    "output": "[1, 2, 3, 4, 5]"
  },
  {
    "input": "prices = [10, 1, 1, 6]",
    "output": "[9, 0, 1, 6]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "prices = [8, 4, 6, 2, 3]",
    "output": "[4, 2, 4, 2, 3]"
  },
  {
    "input": "prices = [1, 2, 3, 4, 5]",
    "output": "[1, 2, 3, 4, 5]"
  },
  {
    "input": "prices = [10, 1, 1, 6]",
    "output": "[9, 0, 1, 6]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var finalPrices = function(prices) {\n};\n",
  "python": "class Solution:\n    def finalPrices(self, prices: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> finalPrices(std::vector<int>& prices) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] finalPrices(int[] prices) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "finalPrices",
  "params": [
    {
      "name": "prices",
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
          8,
          4,
          6,
          2,
          3
        ]
      ],
      "expected": [
        4,
        2,
        4,
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
          5
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
          10,
          1,
          1,
          6
        ]
      ],
      "expected": [
        9,
        0,
        1,
        6
      ]
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
    "expected": [
      5
    ]
  },
  {
    "args": [
      [
        100,
        1
      ]
    ],
    "expected": [
      99,
      1
    ]
  },
  {
    "args": [
      [
        1,
        100
      ]
    ],
    "expected": [
      1,
      100
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
      2
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
      1,
      1,
      1,
      1,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1311,
    '分割平衡字符串',
    '平衡字符串中 ''L'' 和 ''R'' 的数量相等。给定只含 ''L''、''R'' 的字符串 s，
将其分割成尽可能多的平衡字符串，返回最大数量。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '贪心'],
    $json$[
  {
    "input": "s = \"RLRRLLRLRL\"",
    "output": "4"
  },
  {
    "input": "s = \"RLRRRLLRLL\"",
    "output": "2"
  },
  {
    "input": "s = \"LLLLRRRR\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"RLRRLLRLRL\"",
    "output": "4"
  },
  {
    "input": "s = \"RLRRRLLRLL\"",
    "output": "2"
  },
  {
    "input": "s = \"LLLLRRRR\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var balancedStringSplit = function(s) {\n};\n",
  "python": "class Solution:\n    def balancedStringSplit(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int balancedStringSplit(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int balancedStringSplit(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "balancedStringSplit",
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
        "RLRRLLRLRL"
      ],
      "expected": 4
    },
    {
      "args": [
        "RLRRRLLRLL"
      ],
      "expected": 2
    },
    {
      "args": [
        "LLLLRRRR"
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "LR"
    ],
    "expected": 1
  },
  {
    "args": [
      "RL"
    ],
    "expected": 1
  },
  {
    "args": [
      "LLRR"
    ],
    "expected": 1
  },
  {
    "args": [
      "LRLR"
    ],
    "expected": 2
  },
  {
    "args": [
      "RLRLRL"
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1312,
    '比较含退格的字符串',
    '''#'' 表示退格操作，会删除前一个字符。给定字符串 s 和 t，
判断两者处理所有退格后是否相等。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '栈'],
    $json$[
  {
    "input": "s = \"ab#c\", t = \"ad#c\"",
    "output": "true"
  },
  {
    "input": "s = \"ab##\", t = \"c#d#\"",
    "output": "true"
  },
  {
    "input": "s = \"a#c\", t = \"b\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"ab#c\", t = \"ad#c\"",
    "output": "true"
  },
  {
    "input": "s = \"ab##\", t = \"c#d#\"",
    "output": "true"
  },
  {
    "input": "s = \"a#c\", t = \"b\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var backspaceCompare = function(s, t) {\n};\n",
  "python": "class Solution:\n    def backspaceCompare(self, s: str, t: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool backspaceCompare(std::string s, std::string t) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean backspaceCompare(String s, String t) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "backspaceCompare",
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
        "ab#c",
        "ad#c"
      ],
      "expected": true
    },
    {
      "args": [
        "ab##",
        "c#d#"
      ],
      "expected": true
    },
    {
      "args": [
        "a#c",
        "b"
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
      "a#",
      ""
    ],
    "expected": true
  },
  {
    "args": [
      "###",
      "###"
    ],
    "expected": true
  },
  {
    "args": [
      "a##b",
      "b"
    ],
    "expected": true
  },
  {
    "args": [
      "abc#d",
      "abd"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1313,
    '旋转字符串',
    '给定字符串 s 和 goal，判断 goal 是否是 s 经过若干次循环移位得到的字符串。',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "s = \"abcde\", goal = \"cdeab\"",
    "output": "true"
  },
  {
    "input": "s = \"abcde\", goal = \"abced\"",
    "output": "false"
  },
  {
    "input": "s = \"abc\", goal = \"abc\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abcde\", goal = \"cdeab\"",
    "output": "true"
  },
  {
    "input": "s = \"abcde\", goal = \"abced\"",
    "output": "false"
  },
  {
    "input": "s = \"abc\", goal = \"abc\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var rotateString = function(s, goal) {\n};\n",
  "python": "class Solution:\n    def rotateString(self, s: str, goal: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool rotateString(std::string s, std::string goal) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean rotateString(String s, String goal) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "rotateString",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "goal",
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
        "abcde",
        "cdeab"
      ],
      "expected": true
    },
    {
      "args": [
        "abcde",
        "abced"
      ],
      "expected": false
    },
    {
      "args": [
        "abc",
        "abc"
      ],
      "expected": true
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
      "a",
      "b"
    ],
    "expected": false
  },
  {
    "args": [
      "ab",
      "ba"
    ],
    "expected": true
  },
  {
    "args": [
      "abc",
      "cab"
    ],
    "expected": true
  },
  {
    "args": [
      "abc",
      "acb"
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1314,
    '重新排列字符串',
    '给定字符串 s 和长度相同的整数数组 indices，按 indices[i] 指定的位置重建字符串：
result[indices[i]] = s[i]。返回重建后的字符串。',
    'easy',
    1000,
    256,
    ARRAY['数组', '字符串'],
    $json$[
  {
    "input": "s = \"codeleet\", indices = [4, 5, 6, 7, 0, 2, 1, 3]",
    "output": "\"leetcode\""
  },
  {
    "input": "s = \"abc\", indices = [0, 1, 2]",
    "output": "\"abc\""
  },
  {
    "input": "s = \"aiohn\", indices = [3, 1, 4, 2, 0]",
    "output": "\"nihao\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"codeleet\", indices = [4, 5, 6, 7, 0, 2, 1, 3]",
    "output": "\"leetcode\""
  },
  {
    "input": "s = \"abc\", indices = [0, 1, 2]",
    "output": "\"abc\""
  },
  {
    "input": "s = \"aiohn\", indices = [3, 1, 4, 2, 0]",
    "output": "\"nihao\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var restoreString = function(s, indices) {\n};\n",
  "python": "class Solution:\n    def restoreString(self, s: str, indices: list[int]) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string restoreString(std::string s, std::vector<int>& indices) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String restoreString(String s, int[] indices) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "restoreString",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "indices",
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
        "codeleet",
        [
          4,
          5,
          6,
          7,
          0,
          2,
          1,
          3
        ]
      ],
      "expected": "leetcode"
    },
    {
      "args": [
        "abc",
        [
          0,
          1,
          2
        ]
      ],
      "expected": "abc"
    },
    {
      "args": [
        "aiohn",
        [
          3,
          1,
          4,
          2,
          0
        ]
      ],
      "expected": "nihao"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      [
        0
      ]
    ],
    "expected": "a"
  },
  {
    "args": [
      "ab",
      [
        1,
        0
      ]
    ],
    "expected": "ba"
  },
  {
    "args": [
      "xyz",
      [
        2,
        0,
        1
      ]
    ],
    "expected": "yzx"
  }
]$json$::jsonb,
    'approved'
),
(
    1315,
    '拥有最多糖果的孩子',
    '给定 candies 和 extraCandies。对每个孩子，判断把至多 extraCandies 颗糖果全部给他后，
他是否拥有最多的糖果（可以与其他人并列）。返回布尔数组。',
    'easy',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "candies = [2, 3, 5, 1, 3], extraCandies = 3",
    "output": "[true, true, true, false, true]"
  },
  {
    "input": "candies = [4, 2, 1, 1, 2], extraCandies = 1",
    "output": "[true, false, false, false, false]"
  },
  {
    "input": "candies = [12, 1, 12], extraCandies = 10",
    "output": "[true, false, true]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "candies = [2, 3, 5, 1, 3], extraCandies = 3",
    "output": "[true, true, true, false, true]"
  },
  {
    "input": "candies = [4, 2, 1, 1, 2], extraCandies = 1",
    "output": "[true, false, false, false, false]"
  },
  {
    "input": "candies = [12, 1, 12], extraCandies = 10",
    "output": "[true, false, true]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var kidsWithCandies = function(candies, extraCandies) {\n};\n",
  "python": "class Solution:\n    def kidsWithCandies(self, candies: list[int], extraCandies: int) -> list[bool]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<bool> kidsWithCandies(std::vector<int>& candies, int extraCandies) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public boolean[] kidsWithCandies(int[] candies, int extraCandies) {\n        return new boolean[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kidsWithCandies",
  "params": [
    {
      "name": "candies",
      "type": "int[]"
    },
    {
      "name": "extraCandies",
      "type": "int"
    }
  ],
  "return_type": "bool[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          2,
          3,
          5,
          1,
          3
        ],
        3
      ],
      "expected": [
        true,
        true,
        true,
        false,
        true
      ]
    },
    {
      "args": [
        [
          4,
          2,
          1,
          1,
          2
        ],
        1
      ],
      "expected": [
        true,
        false,
        false,
        false,
        false
      ]
    },
    {
      "args": [
        [
          12,
          1,
          12
        ],
        10
      ],
      "expected": [
        true,
        false,
        true
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
      0
    ],
    "expected": [
      true
    ]
  },
  {
    "args": [
      [
        1,
        1
      ],
      0
    ],
    "expected": [
      true,
      true
    ]
  },
  {
    "args": [
      [
        1,
        1
      ],
      1
    ],
    "expected": [
      true,
      true
    ]
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
    "expected": [
      true,
      true,
      true
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1316,
    '数组异或操作',
    '构造数组 nums，其中 nums[i] = start + 2 * i（0 <= i < n）。
返回 nums 中所有元素的按位异或结果。',
    'easy',
    1000,
    256,
    ARRAY['数组', '位运算'],
    $json$[
  {
    "input": "n = 5, start = 0",
    "output": "8"
  },
  {
    "input": "n = 4, start = 3",
    "output": "8"
  },
  {
    "input": "n = 1, start = 7",
    "output": "7"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5, start = 0",
    "output": "8"
  },
  {
    "input": "n = 4, start = 3",
    "output": "8"
  },
  {
    "input": "n = 1, start = 7",
    "output": "7"
  }
]$json$::jsonb,
    $json${
  "javascript": "var xorOperation = function(n, start) {\n};\n",
  "python": "class Solution:\n    def xorOperation(self, n: int, start: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int xorOperation(int n, int start) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int xorOperation(int n, int start) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "xorOperation",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "start",
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
        5,
        0
      ],
      "expected": 8
    },
    {
      "args": [
        4,
        3
      ],
      "expected": 8
    },
    {
      "args": [
        1,
        7
      ],
      "expected": 7
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      0
    ],
    "expected": 0
  },
  {
    "args": [
      2,
      1
    ],
    "expected": 2
  },
  {
    "args": [
      10,
      5
    ],
    "expected": 2
  },
  {
    "args": [
      3,
      8
    ],
    "expected": 14
  }
]$json$::jsonb,
    'approved'
),
(
    1317,
    '生成交替二进制字符串的最少操作数',
    '给定只含 ''0'' 和 ''1'' 的字符串 s。每次操作可以翻转一个字符，
返回使 s 成为交替字符串（相邻字符不同）的最少操作数。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '贪心'],
    $json$[
  {
    "input": "s = \"0100\"",
    "output": "1"
  },
  {
    "input": "s = \"10\"",
    "output": "0"
  },
  {
    "input": "s = \"1111\"",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"0100\"",
    "output": "1"
  },
  {
    "input": "s = \"10\"",
    "output": "0"
  },
  {
    "input": "s = \"1111\"",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minOperations = function(s) {\n};\n",
  "python": "class Solution:\n    def minOperations(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minOperations(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minOperations(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minOperations",
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
        "0100"
      ],
      "expected": 1
    },
    {
      "args": [
        "10"
      ],
      "expected": 0
    },
    {
      "args": [
        "1111"
      ],
      "expected": 2
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
    "expected": 0
  },
  {
    "args": [
      "01"
    ],
    "expected": 0
  },
  {
    "args": [
      "00"
    ],
    "expected": 1
  },
  {
    "args": [
      "1010"
    ],
    "expected": 0
  },
  {
    "args": [
      "010101"
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1318,
    '最小操作次数使数组元素相等',
    '每次操作将数组中恰好 n - 1 个元素各加 1。
返回使所有元素相等所需的最少操作次数。',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "3"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "3"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minMoves = function(nums) {\n};\n",
  "python": "class Solution:\n    def minMoves(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minMoves(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minMoves(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minMoves",
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
      "expected": 3
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
          1,
          2,
          3,
          4
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
        5
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        5
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
        10,
        1,
        1,
        1
      ]
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1319,
    '寻找数组的中心下标',
    '中心下标 i 满足左侧所有元素之和等于右侧所有元素之和。
下标 0 的左侧和为 0，下标 n - 1 的右侧和为 0。返回最左边的中心下标；不存在返回 -1。',
    'easy',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "nums = [1, 7, 3, 6, 5, 6]",
    "output": "3"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "-1"
  },
  {
    "input": "nums = [2, 1, -1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 7, 3, 6, 5, 6]",
    "output": "3"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "-1"
  },
  {
    "input": "nums = [2, 1, -1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var pivotIndex = function(nums) {\n};\n",
  "python": "class Solution:\n    def pivotIndex(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int pivotIndex(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int pivotIndex(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "pivotIndex",
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
          7,
          3,
          6,
          5,
          6
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
      "expected": -1
    },
    {
      "args": [
        [
          2,
          1,
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
        1
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        -1,
        -1,
        -1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        2,
        3,
        -5
      ]
    ],
    "expected": -1
  }
]$json$::jsonb,
    'approved'
),
(
    1320,
    '找到最高海拔',
    '骑行者从海拔 0 出发，gain[i] 表示从第 i 个点到第 i + 1 个点的海拔净变化。
返回骑行过程中到达的最高海拔。',
    'easy',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "gain = [-5, 1, 5, 0, -7]",
    "output": "1"
  },
  {
    "input": "gain = [-4, -3, -2, -1, 4, 3, 2]",
    "output": "0"
  },
  {
    "input": "gain = [0]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "gain = [-5, 1, 5, 0, -7]",
    "output": "1"
  },
  {
    "input": "gain = [-4, -3, -2, -1, 4, 3, 2]",
    "output": "0"
  },
  {
    "input": "gain = [0]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestAltitude = function(gain) {\n};\n",
  "python": "class Solution:\n    def largestAltitude(self, gain: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int largestAltitude(std::vector<int>& gain) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int largestAltitude(int[] gain) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestAltitude",
  "params": [
    {
      "name": "gain",
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
          -5,
          1,
          5,
          0,
          -7
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          -4,
          -3,
          -2,
          -1,
          4,
          3,
          2
        ]
      ],
      "expected": 0
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
    "expected": 0
  },
  {
    "args": [
      [
        5,
        -5
      ]
    ],
    "expected": 5
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
  },
  {
    "args": [
      [
        -5,
        -4,
        -3
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1321,
    '唯一元素的和',
    '返回数组 nums 中所有只出现一次的元素之和。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 2]",
    "output": "4"
  },
  {
    "input": "nums = [1, 1, 1, 1, 1]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5]",
    "output": "15"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 2]",
    "output": "4"
  },
  {
    "input": "nums = [1, 1, 1, 1, 1]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5]",
    "output": "15"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumOfUnique = function(nums) {\n};\n",
  "python": "class Solution:\n    def sumOfUnique(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int sumOfUnique(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int sumOfUnique(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumOfUnique",
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
          2
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
          1,
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
        ]
      ],
      "expected": 15
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
        2
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        -1,
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
    1322,
    '判定字符是否唯一',
    '给定只含小写字母的字符串 astr，判断其中是否有重复字符。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '位运算'],
    $json$[
  {
    "input": "astr = \"leetcode\"",
    "output": "false"
  },
  {
    "input": "astr = \"abc\"",
    "output": "true"
  },
  {
    "input": "astr = \"aab\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "astr = \"leetcode\"",
    "output": "false"
  },
  {
    "input": "astr = \"abc\"",
    "output": "true"
  },
  {
    "input": "astr = \"aab\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isUnique = function(astr) {\n};\n",
  "python": "class Solution:\n    def isUnique(self, astr: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isUnique(std::string astr) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isUnique(String astr) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isUnique",
  "params": [
    {
      "name": "astr",
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
        "leetcode"
      ],
      "expected": false
    },
    {
      "args": [
        "abc"
      ],
      "expected": true
    },
    {
      "args": [
        "aab"
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
    "expected": false
  },
  {
    "args": [
      "abcdefghijklmnopqrstuvwxyz"
    ],
    "expected": true
  },
  {
    "args": [
      "zyx"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1323,
    '配对交换',
    '给定非负整数 num，交换其二进制表示中相邻的奇偶位：
第 0 位与第 1 位交换，第 2 位与第 3 位交换，依此类推。返回交换后的整数。',
    'easy',
    1000,
    256,
    ARRAY['位运算'],
    $json$[
  {
    "input": "num = 2",
    "output": "1"
  },
  {
    "input": "num = 3",
    "output": "3"
  },
  {
    "input": "num = 1",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 2",
    "output": "1"
  },
  {
    "input": "num = 3",
    "output": "3"
  },
  {
    "input": "num = 1",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var exchangeBits = function(num) {\n};\n",
  "python": "class Solution:\n    def exchangeBits(self, num: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int exchangeBits(int num) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int exchangeBits(int num) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "exchangeBits",
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
        2
      ],
      "expected": 1
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
      "expected": 2
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
      5
    ],
    "expected": 10
  },
  {
    "args": [
      10
    ],
    "expected": 5
  },
  {
    "args": [
      7
    ],
    "expected": 11
  },
  {
    "args": [
      1073741823
    ],
    "expected": 1073741823
  }
]$json$::jsonb,
    'approved'
),
(
    1324,
    '独特的电子邮件地址',
    '每个邮箱由本地名和域名组成，用 ''@'' 分隔。
本地名中的 ''.'' 会被忽略，第一个 ''+'' 及其后的内容也会被忽略；域名保持不变。
返回不同实际收件地址的数量。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "emails = [\"test.email+alex@leetcode.com\", \"test.e.mail+bob.cathy@leetcode.com\", \"testemail+david@lee.tcode.com\"]",
    "output": "2"
  },
  {
    "input": "emails = [\"a@b.com\"]",
    "output": "1"
  },
  {
    "input": "emails = [\"a+b@c.com\", \"a@c.com\"]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "emails = [\"test.email+alex@leetcode.com\", \"test.e.mail+bob.cathy@leetcode.com\", \"testemail+david@lee.tcode.com\"]",
    "output": "2"
  },
  {
    "input": "emails = [\"a@b.com\"]",
    "output": "1"
  },
  {
    "input": "emails = [\"a+b@c.com\", \"a@c.com\"]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numUniqueEmails = function(emails) {\n};\n",
  "python": "class Solution:\n    def numUniqueEmails(self, emails: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numUniqueEmails(std::vector<std::string>& emails) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numUniqueEmails(String[] emails) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numUniqueEmails",
  "params": [
    {
      "name": "emails",
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
          "test.email+alex@leetcode.com",
          "test.e.mail+bob.cathy@leetcode.com",
          "testemail+david@lee.tcode.com"
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          "a@b.com"
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          "a+b@c.com",
          "a@c.com"
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
        "a.b@c.com",
        "ab@c.com"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "a+x@d.com",
        "a+y@d.com"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "a@x.com",
        "a@y.com"
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1325,
    '山羊拉丁文',
    '给定由空格分隔单词组成的句子。对第 i 个单词（从 1 开始）：
若以元音字母开头，在末尾加 "ma"；否则把首字母移到末尾再加 "ma"；
最后再加 i 个 ''a''。返回转换后的句子。',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "sentence = \"I speak Goat Latin\"",
    "output": "\"Imaa peaksmaaa oatGmaaaa atinLmaaaaa\""
  },
  {
    "input": "sentence = \"The quick brown fox jumped over the lazy dog\"",
    "output": "\"heTmaa uickqmaaa rownbmaaaa oxfmaaaaa umpedjmaaaaaa overmaaaaaaa hetmaaaaaaaa azylmaaaaaaaaa ogdmaaaaaaaaaa\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "sentence = \"I speak Goat Latin\"",
    "output": "\"Imaa peaksmaaa oatGmaaaa atinLmaaaaa\""
  },
  {
    "input": "sentence = \"The quick brown fox jumped over the lazy dog\"",
    "output": "\"heTmaa uickqmaaa rownbmaaaa oxfmaaaaa umpedjmaaaaaa overmaaaaaaa hetmaaaaaaaa azylmaaaaaaaaa ogdmaaaaaaaaaa\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var toGoatLatin = function(sentence) {\n};\n",
  "python": "class Solution:\n    def toGoatLatin(self, sentence: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string toGoatLatin(std::string sentence) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String toGoatLatin(String sentence) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "toGoatLatin",
  "params": [
    {
      "name": "sentence",
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
        "I speak Goat Latin"
      ],
      "expected": "Imaa peaksmaaa oatGmaaaa atinLmaaaaa"
    },
    {
      "args": [
        "The quick brown fox jumped over the lazy dog"
      ],
      "expected": "heTmaa uickqmaaa rownbmaaaa oxfmaaaaa umpedjmaaaaaa overmaaaaaaa hetmaaaaaaaa azylmaaaaaaaaa ogdmaaaaaaaaaa"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a"
    ],
    "expected": "amaa"
  },
  {
    "args": [
      "z"
    ],
    "expected": "zmaa"
  },
  {
    "args": [
      "apple orange"
    ],
    "expected": "applemaa orangemaaa"
  },
  {
    "args": [
      "Hello World"
    ],
    "expected": "elloHmaa orldWmaaa"
  }
]$json$::jsonb,
    'approved'
),
(
    1326,
    '缀点成线',
    '给定按 x 坐标升序排列的点坐标数组 coordinates，判断所有点是否在同一条直线上。',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "coordinates = [[1, 1], [2, 2], [3, 3]]",
    "output": "true"
  },
  {
    "input": "coordinates = [[1, 1], [2, 2], [3, 4]]",
    "output": "false"
  },
  {
    "input": "coordinates = [[0, 0], [0, 1], [0, 5]]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "coordinates = [[1, 1], [2, 2], [3, 3]]",
    "output": "true"
  },
  {
    "input": "coordinates = [[1, 1], [2, 2], [3, 4]]",
    "output": "false"
  },
  {
    "input": "coordinates = [[0, 0], [0, 1], [0, 5]]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var checkStraightLine = function(coordinates) {\n};\n",
  "python": "class Solution:\n    def checkStraightLine(self, coordinates: list[list[int]]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool checkStraightLine(std::vector<std::vector<int>>& coordinates) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean checkStraightLine(int[][] coordinates) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkStraightLine",
  "params": [
    {
      "name": "coordinates",
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
            0,
            0
          ],
          [
            0,
            1
          ],
          [
            0,
            5
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
          3
        ],
        [
          2,
          5
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
          -2,
          -1
        ],
        [
          0,
          0
        ]
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1327,
    '检查数组是否经排序和轮转得到',
    '给定数组 nums，判断它是否能由非递减数组经过若干次循环右移得到。',
    'easy',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "nums = [3, 4, 5, 1, 2]",
    "output": "true"
  },
  {
    "input": "nums = [2, 1, 3, 4]",
    "output": "false"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "true"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 4, 5, 1, 2]",
    "output": "true"
  },
  {
    "input": "nums = [2, 1, 3, 4]",
    "output": "false"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "true"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var check = function(nums) {\n};\n",
  "python": "class Solution:\n    def check(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool check(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean check(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "check",
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
          3,
          4,
          5,
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
          1,
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
          2,
          3
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
    "expected": true
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
    "expected": true
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
        1,
        3,
        2
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1328,
    'K 进制表示下的各位数字总和',
    '给定整数 n 和进制 k（2 <= k <= 10），返回 n 在 k 进制表示下各位数字之和。',
    'easy',
    1000,
    256,
    ARRAY['数学'],
    $json$[
  {
    "input": "n = 34, k = 6",
    "output": "9"
  },
  {
    "input": "n = 10, k = 10",
    "output": "1"
  },
  {
    "input": "n = 1, k = 2",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 34, k = 6",
    "output": "9"
  },
  {
    "input": "n = 10, k = 10",
    "output": "1"
  },
  {
    "input": "n = 1, k = 2",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumBase = function(n, k) {\n};\n",
  "python": "class Solution:\n    def sumBase(self, n: int, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int sumBase(int n, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int sumBase(int n, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumBase",
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
        34,
        6
      ],
      "expected": 9
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
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      100,
      10
    ],
    "expected": 1
  },
  {
    "args": [
      255,
      2
    ],
    "expected": 8
  },
  {
    "args": [
      999,
      9
    ],
    "expected": 7
  },
  {
    "args": [
      7,
      3
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1329,
    '统计位数为偶数的数字',
    '返回数组 nums 中十进制位数为偶数的元素个数。所有元素均为正整数。',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "nums = [12, 345, 2, 6, 7896]",
    "output": "2"
  },
  {
    "input": "nums = [555, 901, 482, 1771]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [12, 345, 2, 6, 7896]",
    "output": "2"
  },
  {
    "input": "nums = [555, 901, 482, 1771]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findNumbers = function(nums) {\n};\n",
  "python": "class Solution:\n    def findNumbers(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findNumbers(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findNumbers(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findNumbers",
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
          12,
          345,
          2,
          6,
          7896
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          555,
          901,
          482,
          1771
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
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        10
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        9
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        10,
        100,
        1000,
        10000
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        99999,
        100000
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1330,
    '数组序号转换',
    '将 arr 中每个元素替换为它的排名。排名从 1 开始，按元素值升序分配，
相同元素排名相同。返回转换后的数组。',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序', '哈希表'],
    $json$[
  {
    "input": "arr = [40, 10, 20, 30]",
    "output": "[4, 1, 2, 3]"
  },
  {
    "input": "arr = [100, 100, 100]",
    "output": "[1, 1, 1]"
  },
  {
    "input": "arr = [37, 12, 28, 9, 100, 56, 80, 5, 12]",
    "output": "[5, 3, 4, 2, 8, 6, 7, 1, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [40, 10, 20, 30]",
    "output": "[4, 1, 2, 3]"
  },
  {
    "input": "arr = [100, 100, 100]",
    "output": "[1, 1, 1]"
  },
  {
    "input": "arr = [37, 12, 28, 9, 100, 56, 80, 5, 12]",
    "output": "[5, 3, 4, 2, 8, 6, 7, 1, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var arrayRankTransform = function(arr) {\n};\n",
  "python": "class Solution:\n    def arrayRankTransform(self, arr: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> arrayRankTransform(std::vector<int>& arr) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] arrayRankTransform(int[] arr) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "arrayRankTransform",
  "params": [
    {
      "name": "arr",
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
          40,
          10,
          20,
          30
        ]
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
          100,
          100,
          100
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
          37,
          12,
          28,
          9,
          100,
          56,
          80,
          5,
          12
        ]
      ],
      "expected": [
        5,
        3,
        4,
        2,
        8,
        6,
        7,
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
        2,
        1
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
        5,
        5,
        1
      ]
    ],
    "expected": [
      2,
      2,
      1
    ]
  },
  {
    "args": [
      [
        -1,
        0,
        1
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
    1331,
    '差的绝对值为 K 的数对数目',
    '返回满足 i < j 且 |nums[i] - nums[j]| == k 的数对数目。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "nums = [1, 2, 2, 1], k = 1",
    "output": "4"
  },
  {
    "input": "nums = [1, 3], k = 3",
    "output": "0"
  },
  {
    "input": "nums = [3, 2, 1, 5, 4], k = 2",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 2, 1], k = 1",
    "output": "4"
  },
  {
    "input": "nums = [1, 3], k = 3",
    "output": "0"
  },
  {
    "input": "nums = [3, 2, 1, 5, 4], k = 2",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countKDifference = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def countKDifference(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countKDifference(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countKDifference(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countKDifference",
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
          1,
          2,
          2,
          1
        ],
        1
      ],
      "expected": 4
    },
    {
      "args": [
        [
          1,
          3
        ],
        3
      ],
      "expected": 0
    },
    {
      "args": [
        [
          3,
          2,
          1,
          5,
          4
        ],
        2
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
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
        1
      ],
      0
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
      1
    ],
    "expected": 2
  },
  {
    "args": [
      [
        -1,
        -2
      ],
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        1,
        1
      ],
      0
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1332,
    '找出井字棋的获胜者',
    'A 和 B 轮流在 3 x 3 棋盘上落子，A 先手。moves[i] = [row, col] 表示第 i 步的位置。
若有人获胜，返回 "A" 或 "B"；无人获胜且棋盘已满返回 "Draw"；否则返回 "Pending"。',
    'easy',
    1000,
    256,
    ARRAY['数组', '模拟'],
    $json$[
  {
    "input": "moves = [[0, 0], [2, 0], [1, 1], [2, 1], [2, 2]]",
    "output": "\"A\""
  },
  {
    "input": "moves = [[0, 0], [1, 1], [0, 1], [0, 2], [1, 0], [2, 0]]",
    "output": "\"B\""
  },
  {
    "input": "moves = [[0, 0], [1, 1], [2, 0], [1, 0], [1, 2], [2, 1], [0, 1], [2, 2], [0, 2]]",
    "output": "\"A\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "moves = [[0, 0], [2, 0], [1, 1], [2, 1], [2, 2]]",
    "output": "\"A\""
  },
  {
    "input": "moves = [[0, 0], [1, 1], [0, 1], [0, 2], [1, 0], [2, 0]]",
    "output": "\"B\""
  },
  {
    "input": "moves = [[0, 0], [1, 1], [2, 0], [1, 0], [1, 2], [2, 1], [0, 1], [2, 2], [0, 2]]",
    "output": "\"A\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var tictactoe = function(moves) {\n};\n",
  "python": "class Solution:\n    def tictactoe(self, moves: list[list[int]]) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string tictactoe(std::vector<std::vector<int>>& moves) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String tictactoe(int[][] moves) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "tictactoe",
  "params": [
    {
      "name": "moves",
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
        [
          [
            0,
            0
          ],
          [
            2,
            0
          ],
          [
            1,
            1
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
      "expected": "A"
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
            1
          ],
          [
            0,
            2
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
      "expected": "B"
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
            0
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
            0,
            1
          ],
          [
            2,
            2
          ],
          [
            0,
            2
          ]
        ]
      ],
      "expected": "A"
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
          1
        ]
      ]
    ],
    "expected": "Pending"
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
        ]
      ]
    ],
    "expected": "Pending"
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
    "expected": "Pending"
  }
]$json$::jsonb,
    'approved'
),
(
    1333,
    '矩阵中战斗力最弱的 K 行',
    '矩阵 mat 中 1 表示士兵、0 表示平民，行的战斗力为士兵数量。
按战斗力升序返回最弱的 k 行的下标；战斗力相同按下标升序。',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵', '排序'],
    $json$[
  {
    "input": "mat = [[1, 1, 0, 0, 0], [1, 1, 1, 1, 0], [1, 0, 0, 0, 0], [1, 1, 0, 0, 0], [1, 1, 1, 1, 1]], k = 3",
    "output": "[2, 0, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mat = [[1, 1, 0, 0, 0], [1, 1, 1, 1, 0], [1, 0, 0, 0, 0], [1, 1, 0, 0, 0], [1, 1, 1, 1, 1]], k = 3",
    "output": "[2, 0, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var kWeakestRows = function(mat, k) {\n};\n",
  "python": "class Solution:\n    def kWeakestRows(self, mat: list[list[int]], k: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> kWeakestRows(std::vector<std::vector<int>>& mat, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] kWeakestRows(int[][] mat, int k) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kWeakestRows",
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
            1,
            0,
            0,
            0
          ],
          [
            1,
            1,
            1,
            1,
            0
          ],
          [
            1,
            0,
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
            1,
            1,
            1,
            1,
            1
          ]
        ],
        3
      ],
      "expected": [
        2,
        0,
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
          1,
          0,
          0,
          0
        ],
        [
          1,
          1,
          1,
          1
        ],
        [
          1,
          0,
          0,
          0
        ],
        [
          1,
          0,
          0,
          0
        ]
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
        [
          1,
          1
        ],
        [
          1,
          0
        ],
        [
          0,
          0
        ]
      ],
      2
    ],
    "expected": [
      2,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1334,
    '按既定顺序创建目标数组',
    '初始目标数组为空。按顺序处理每个下标 i：将 nums[i] 插入到 index[i] 处。
返回最终的目标数组。',
    'easy',
    1000,
    256,
    ARRAY['数组', '模拟'],
    $json$[
  {
    "input": "nums = [0, 1, 2, 3, 4], index = [0, 1, 2, 2, 1]",
    "output": "[0, 4, 1, 3, 2]"
  },
  {
    "input": "nums = [1, 2, 3, 4, 0], index = [0, 1, 2, 3, 0]",
    "output": "[0, 1, 2, 3, 4]"
  },
  {
    "input": "nums = [1], index = [0]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [0, 1, 2, 3, 4], index = [0, 1, 2, 2, 1]",
    "output": "[0, 4, 1, 3, 2]"
  },
  {
    "input": "nums = [1, 2, 3, 4, 0], index = [0, 1, 2, 3, 0]",
    "output": "[0, 1, 2, 3, 4]"
  },
  {
    "input": "nums = [1], index = [0]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var createTargetArray = function(nums, index) {\n};\n",
  "python": "class Solution:\n    def createTargetArray(self, nums: list[int], index: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> createTargetArray(std::vector<int>& nums, std::vector<int>& index) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] createTargetArray(int[] nums, int[] index) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "createTargetArray",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "index",
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
          2,
          1
        ]
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
        [
          1,
          2,
          3,
          4,
          0
        ],
        [
          0,
          1,
          2,
          3,
          0
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
        [
          1
        ],
        [
          0
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
      ],
      [
        0,
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
        0,
        0,
        0
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
        3
      ],
      [
        2,
        1,
        0
      ]
    ],
    "expected": [
      3,
      5,
      4
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1335,
    '将数字变成 0 的操作次数',
    '若 num 为偶数，将其除以 2；若为奇数，将其减 1。返回将 num 变成 0 所需的最少操作次数。
给定 0 <= num <= 10^6。',
    'easy',
    1000,
    256,
    ARRAY['数学', '位运算'],
    $json$[
  {
    "input": "num = 14",
    "output": "6"
  },
  {
    "input": "num = 8",
    "output": "4"
  },
  {
    "input": "num = 123",
    "output": "12"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 14",
    "output": "6"
  },
  {
    "input": "num = 8",
    "output": "4"
  },
  {
    "input": "num = 123",
    "output": "12"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numberOfSteps = function(num) {\n};\n",
  "python": "class Solution:\n    def numberOfSteps(self, num: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numberOfSteps(int num) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numberOfSteps(int num) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numberOfSteps",
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
        14
      ],
      "expected": 6
    },
    {
      "args": [
        8
      ],
      "expected": 4
    },
    {
      "args": [
        123
      ],
      "expected": 12
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
      1000000
    ],
    "expected": 26
  }
]$json$::jsonb,
    'approved'
),
(
    1336,
    '根据数字二进制下 1 的数目排序',
    '按二进制表示中 1 的个数升序排序数组 arr；个数相同按数值升序。
返回排序后的数组。',
    'easy',
    1000,
    256,
    ARRAY['数组', '位运算', '排序'],
    $json$[
  {
    "input": "arr = [0, 1, 2, 3, 4, 5, 6, 7, 8]",
    "output": "[0, 1, 2, 4, 8, 3, 5, 6, 7]"
  },
  {
    "input": "arr = [1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1]",
    "output": "[1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024]"
  },
  {
    "input": "arr = [10000, 10000]",
    "output": "[10000, 10000]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [0, 1, 2, 3, 4, 5, 6, 7, 8]",
    "output": "[0, 1, 2, 4, 8, 3, 5, 6, 7]"
  },
  {
    "input": "arr = [1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1]",
    "output": "[1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024]"
  },
  {
    "input": "arr = [10000, 10000]",
    "output": "[10000, 10000]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sortByBits = function(arr) {\n};\n",
  "python": "class Solution:\n    def sortByBits(self, arr: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> sortByBits(std::vector<int>& arr) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] sortByBits(int[] arr) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sortByBits",
  "params": [
    {
      "name": "arr",
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
          0,
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
        0,
        1,
        2,
        4,
        8,
        3,
        5,
        6,
        7
      ]
    },
    {
      "args": [
        [
          1024,
          512,
          256,
          128,
          64,
          32,
          16,
          8,
          4,
          2,
          1
        ]
      ],
      "expected": [
        1,
        2,
        4,
        8,
        16,
        32,
        64,
        128,
        256,
        512,
        1024
      ]
    },
    {
      "args": [
        [
          10000,
          10000
        ]
      ],
      "expected": [
        10000,
        10000
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
        7,
        8
      ]
    ],
    "expected": [
      8,
      7
    ]
  },
  {
    "args": [
      [
        0,
        1,
        2
      ]
    ],
    "expected": [
      0,
      1,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1337,
    '最富有客户的资产总量',
    'accounts[i][j] 表示第 i 位客户在第 j 家银行的资产。
返回所有客户中资产总量最大的值。',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵'],
    $json$[
  {
    "input": "accounts = [[1, 2, 3], [3, 2, 1]]",
    "output": "6"
  },
  {
    "input": "accounts = [[1, 5], [7, 3], [3, 5]]",
    "output": "10"
  },
  {
    "input": "accounts = [[2, 8, 7], [7, 1, 3], [1, 9, 5]]",
    "output": "17"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "accounts = [[1, 2, 3], [3, 2, 1]]",
    "output": "6"
  },
  {
    "input": "accounts = [[1, 5], [7, 3], [3, 5]]",
    "output": "10"
  },
  {
    "input": "accounts = [[2, 8, 7], [7, 1, 3], [1, 9, 5]]",
    "output": "17"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumWealth = function(accounts) {\n};\n",
  "python": "class Solution:\n    def maximumWealth(self, accounts: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumWealth(std::vector<std::vector<int>>& accounts) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumWealth(int[][] accounts) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumWealth",
  "params": [
    {
      "name": "accounts",
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
            5
          ],
          [
            7,
            3
          ],
          [
            3,
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
            2,
            8,
            7
          ],
          [
            7,
            1,
            3
          ],
          [
            1,
            9,
            5
          ]
        ]
      ],
      "expected": 17
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
          1,
          2
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": 7
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
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1338,
    '所有奇数长度子数组的和',
    '返回数组 arr 所有奇数长度连续子数组的元素之和的总和。',
    'easy',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "arr = [1, 4, 2, 5, 3]",
    "output": "58"
  },
  {
    "input": "arr = [1, 2]",
    "output": "3"
  },
  {
    "input": "arr = [10, 11, 12]",
    "output": "66"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [1, 4, 2, 5, 3]",
    "output": "58"
  },
  {
    "input": "arr = [1, 2]",
    "output": "3"
  },
  {
    "input": "arr = [10, 11, 12]",
    "output": "66"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumOddLengthSubarrays = function(arr) {\n};\n",
  "python": "class Solution:\n    def sumOddLengthSubarrays(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int sumOddLengthSubarrays(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int sumOddLengthSubarrays(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumOddLengthSubarrays",
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
          4,
          2,
          5,
          3
        ]
      ],
      "expected": 58
    },
    {
      "args": [
        [
          1,
          2
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          10,
          11,
          12
        ]
      ],
      "expected": 66
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
    "expected": 6
  },
  {
    "args": [
      [
        2,
        3,
        4,
        5
      ]
    ],
    "expected": 35
  }
]$json$::jsonb,
    'approved'
),
(
    1339,
    '两个数组间的距离值',
    '返回 arr1 中满足以下条件的元素个数：
对任意 arr2[j]，都有 |arr1[i] - arr2[j]| > d。',
    'easy',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "arr1 = [4, 5, 8], arr2 = [10, 9, 1, 8], d = 2",
    "output": "2"
  },
  {
    "input": "arr1 = [1, 4, 2, 3], arr2 = [-4, -3, 6, 10, 20, 30], d = 3",
    "output": "2"
  },
  {
    "input": "arr1 = [2, 1, 100, 3], arr2 = [-5, -2, 10, -3, 7], d = 6",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr1 = [4, 5, 8], arr2 = [10, 9, 1, 8], d = 2",
    "output": "2"
  },
  {
    "input": "arr1 = [1, 4, 2, 3], arr2 = [-4, -3, 6, 10, 20, 30], d = 3",
    "output": "2"
  },
  {
    "input": "arr1 = [2, 1, 100, 3], arr2 = [-5, -2, 10, -3, 7], d = 6",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findTheDistanceValue = function(arr1, arr2, d) {\n};\n",
  "python": "class Solution:\n    def findTheDistanceValue(self, arr1: list[int], arr2: list[int], d: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findTheDistanceValue(std::vector<int>& arr1, std::vector<int>& arr2, int d) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findTheDistanceValue(int[] arr1, int[] arr2, int d) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findTheDistanceValue",
  "params": [
    {
      "name": "arr1",
      "type": "int[]"
    },
    {
      "name": "arr2",
      "type": "int[]"
    },
    {
      "name": "d",
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
          5,
          8
        ],
        [
          10,
          9,
          1,
          8
        ],
        2
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1,
          4,
          2,
          3
        ],
        [
          -4,
          -3,
          6,
          10,
          20,
          30
        ],
        3
      ],
      "expected": 2
    },
    {
      "args": [
        [
          2,
          1,
          100,
          3
        ],
        [
          -5,
          -2,
          10,
          -3,
          7
        ],
        6
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
        2
      ],
      0
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1
      ],
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
        5,
        6
      ],
      [
        1,
        10
      ],
      3
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1340,
    '魔法索引',
    '给定按非递减顺序排列的整数数组 nums，返回最小的下标 i 使 nums[i] == i。
不存在这样的下标返回 -1。',
    'easy',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "nums = [0, 2, 3, 4, 5]",
    "output": "0"
  },
  {
    "input": "nums = [1, 1, 3]",
    "output": "1"
  },
  {
    "input": "nums = [0, 0, 2]",
    "output": "0"
  },
  {
    "input": "nums = [-1, 0, 1]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [0, 2, 3, 4, 5]",
    "output": "0"
  },
  {
    "input": "nums = [1, 1, 3]",
    "output": "1"
  },
  {
    "input": "nums = [0, 0, 2]",
    "output": "0"
  },
  {
    "input": "nums = [-1, 0, 1]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findMagicIndex = function(nums) {\n};\n",
  "python": "class Solution:\n    def findMagicIndex(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findMagicIndex(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findMagicIndex(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findMagicIndex",
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
          1,
          1,
          3
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          0,
          0,
          2
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          -1,
          0,
          1
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
        2
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
  },
  {
    "args": [
      [
        -2,
        -1,
        0,
        1
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        1,
        2,
        3
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        0,
        1,
        2
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1341,
    '判定是否互为字符重排',
    '给定两个字符串 s1 和 s2，判断 s2 是否由 s1 的字符重新排列得到
（字符种类和数量完全相同）。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表', '排序'],
    $json$[
  {
    "input": "s1 = \"abc\", s2 = \"bca\"",
    "output": "true"
  },
  {
    "input": "s1 = \"abc\", s2 = \"bad\"",
    "output": "false"
  },
  {
    "input": "s1 = \"a\", s2 = \"a\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s1 = \"abc\", s2 = \"bca\"",
    "output": "true"
  },
  {
    "input": "s1 = \"abc\", s2 = \"bad\"",
    "output": "false"
  },
  {
    "input": "s1 = \"a\", s2 = \"a\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var CheckPermutation = function(s1, s2) {\n};\n",
  "python": "class Solution:\n    def CheckPermutation(self, s1: str, s2: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool CheckPermutation(std::string s1, std::string s2) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean CheckPermutation(String s1, String s2) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "CheckPermutation",
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
        "abc",
        "bca"
      ],
      "expected": true
    },
    {
      "args": [
        "abc",
        "bad"
      ],
      "expected": false
    },
    {
      "args": [
        "a",
        "a"
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      "b"
    ],
    "expected": false
  },
  {
    "args": [
      "ab",
      "ba"
    ],
    "expected": true
  },
  {
    "args": [
      "aab",
      "abb"
    ],
    "expected": false
  },
  {
    "args": [
      "",
      ""
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1342,
    'URL 化',
    '给定字符串 s（末尾用空格补足长度）和有效长度 length，
将前 length 个字符中的空格全部替换为 "%20"，返回结果。',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "s = \"Mr John Smith    \", length = 13",
    "output": "\"Mr%20John%20Smith\""
  },
  {
    "input": "s = \"a b\", length = 3",
    "output": "\"a%20b\""
  },
  {
    "input": "s = \"abc\", length = 3",
    "output": "\"abc\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"Mr John Smith    \", length = 13",
    "output": "\"Mr%20John%20Smith\""
  },
  {
    "input": "s = \"a b\", length = 3",
    "output": "\"a%20b\""
  },
  {
    "input": "s = \"abc\", length = 3",
    "output": "\"abc\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var replaceSpaces = function(s, length) {\n};\n",
  "python": "class Solution:\n    def replaceSpaces(self, s: str, length: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string replaceSpaces(std::string s, int length) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String replaceSpaces(String s, int length) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "replaceSpaces",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "length",
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
        "Mr John Smith    ",
        13
      ],
      "expected": "Mr%20John%20Smith"
    },
    {
      "args": [
        "a b",
        3
      ],
      "expected": "a%20b"
    },
    {
      "args": [
        "abc",
        3
      ],
      "expected": "abc"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      " ",
      1
    ],
    "expected": "%20"
  },
  {
    "args": [
      "  ",
      2
    ],
    "expected": "%20%20"
  },
  {
    "args": [
      "a  b    ",
      4
    ],
    "expected": "a%20%20b"
  },
  {
    "args": [
      "hello",
      5
    ],
    "expected": "hello"
  }
]$json$::jsonb,
    'approved'
),
(
    1343,
    '一次编辑',
    '判断两个字符串是否最多经过一次插入、删除或替换操作就能相等。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "first = \"pale\", second = \"ple\"",
    "output": "true"
  },
  {
    "input": "first = \"pales\", second = \"pal\"",
    "output": "false"
  },
  {
    "input": "first = \"pale\", second = \"bale\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "first = \"pale\", second = \"ple\"",
    "output": "true"
  },
  {
    "input": "first = \"pales\", second = \"pal\"",
    "output": "false"
  },
  {
    "input": "first = \"pale\", second = \"bale\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var oneEditAway = function(first, second) {\n};\n",
  "python": "class Solution:\n    def oneEditAway(self, first: str, second: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool oneEditAway(std::string first, std::string second) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean oneEditAway(String first, String second) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "oneEditAway",
  "params": [
    {
      "name": "first",
      "type": "string"
    },
    {
      "name": "second",
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
        "pale",
        "ple"
      ],
      "expected": true
    },
    {
      "args": [
        "pales",
        "pal"
      ],
      "expected": false
    },
    {
      "args": [
        "pale",
        "bale"
      ],
      "expected": true
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
      "a",
      "b"
    ],
    "expected": true
  },
  {
    "args": [
      "ab",
      "ba"
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
      "abc",
      "abcd"
    ],
    "expected": true
  },
  {
    "args": [
      "",
      "a"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1344,
    '统计有序矩阵中的负数',
    '给定按行、列均非递增排列的矩阵 grid，返回其中负数的个数。',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵', '二分查找'],
    $json$[
  {
    "input": "grid = [[4, 3, 2, -1], [3, 2, 1, -1], [1, 1, -1, -2], [-1, -1, -2, -3]]",
    "output": "8"
  },
  {
    "input": "grid = [[3, 2], [1, 0]]",
    "output": "0"
  },
  {
    "input": "grid = [[1, 2, 3]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[4, 3, 2, -1], [3, 2, 1, -1], [1, 1, -1, -2], [-1, -1, -2, -3]]",
    "output": "8"
  },
  {
    "input": "grid = [[3, 2], [1, 0]]",
    "output": "0"
  },
  {
    "input": "grid = [[1, 2, 3]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countNegatives = function(grid) {\n};\n",
  "python": "class Solution:\n    def countNegatives(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countNegatives(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countNegatives(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countNegatives",
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
            4,
            3,
            2,
            -1
          ],
          [
            3,
            2,
            1,
            -1
          ],
          [
            1,
            1,
            -1,
            -2
          ],
          [
            -1,
            -1,
            -2,
            -3
          ]
        ]
      ],
      "expected": 8
    },
    {
      "args": [
        [
          [
            3,
            2
          ],
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
        [
          [
            1,
            2,
            3
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
          -1
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
          -1,
          -2
        ],
        [
          -3,
          -4
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
          4
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
    1345,
    '解码字母到整数映射',
    '''1'' 到 ''9'' 映射到 ''a'' 到 ''i''，''10#'' 到 ''26#'' 映射到 ''j'' 到 ''z''。
给定编码字符串 s，返回解码后的字符串。',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "s = \"10#11#12\"",
    "output": "\"jkab\""
  },
  {
    "input": "s = \"1326#\"",
    "output": "\"acz\""
  },
  {
    "input": "s = \"25#\"",
    "output": "\"y\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"10#11#12\"",
    "output": "\"jkab\""
  },
  {
    "input": "s = \"1326#\"",
    "output": "\"acz\""
  },
  {
    "input": "s = \"25#\"",
    "output": "\"y\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var freqAlphabets = function(s) {\n};\n",
  "python": "class Solution:\n    def freqAlphabets(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string freqAlphabets(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String freqAlphabets(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "freqAlphabets",
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
        "10#11#12"
      ],
      "expected": "jkab"
    },
    {
      "args": [
        "1326#"
      ],
      "expected": "acz"
    },
    {
      "args": [
        "25#"
      ],
      "expected": "y"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "1"
    ],
    "expected": "a"
  },
  {
    "args": [
      "26#"
    ],
    "expected": "z"
  },
  {
    "args": [
      "10#1"
    ],
    "expected": "ja"
  },
  {
    "args": [
      "25#26#"
    ],
    "expected": "yz"
  },
  {
    "args": [
      "12#"
    ],
    "expected": "l"
  }
]$json$::jsonb,
    'approved'
),
(
    1346,
    '旋转数字',
    '好数指旋转 180 度后每位仍是有效数字（0、1、8 不变，2 与 5 互换，6 与 9 互换），
且至少有一位发生变化的数。返回 [1, n] 中好数的个数。',
    'easy',
    1000,
    256,
    ARRAY['数学', '动态规划'],
    $json$[
  {
    "input": "n = 10",
    "output": "4"
  },
  {
    "input": "n = 1",
    "output": "0"
  },
  {
    "input": "n = 2",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 10",
    "output": "4"
  },
  {
    "input": "n = 1",
    "output": "0"
  },
  {
    "input": "n = 2",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var rotatedDigits = function(n) {\n};\n",
  "python": "class Solution:\n    def rotatedDigits(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int rotatedDigits(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int rotatedDigits(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "rotatedDigits",
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
        1
      ],
      "expected": 0
    },
    {
      "args": [
        2
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      20
    ],
    "expected": 9
  },
  {
    "args": [
      100
    ],
    "expected": 40
  },
  {
    "args": [
      857
    ],
    "expected": 247
  },
  {
    "args": [
      5
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1347,
    '最小绝对差',
    '返回数组 arr 中所有具有最小绝对差的元素对 [a, b]（a <= b），按 a 升序排列。',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "arr = [4, 2, 1, 3]",
    "output": "[[1, 2], [2, 3], [3, 4]]"
  },
  {
    "input": "arr = [1, 3, 6, 10, 15]",
    "output": "[[1, 3]]"
  },
  {
    "input": "arr = [3, 8, -10, 23, 19, -4, -14, 27]",
    "output": "[[-14, -10], [19, 23], [23, 27]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [4, 2, 1, 3]",
    "output": "[[1, 2], [2, 3], [3, 4]]"
  },
  {
    "input": "arr = [1, 3, 6, 10, 15]",
    "output": "[[1, 3]]"
  },
  {
    "input": "arr = [3, 8, -10, 23, 19, -4, -14, 27]",
    "output": "[[-14, -10], [19, 23], [23, 27]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumAbsDifference = function(arr) {\n};\n",
  "python": "class Solution:\n    def minimumAbsDifference(self, arr: list[int]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> minimumAbsDifference(std::vector<int>& arr) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] minimumAbsDifference(int[] arr) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumAbsDifference",
  "params": [
    {
      "name": "arr",
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
          4,
          2,
          1,
          3
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
          3,
          6,
          10,
          15
        ]
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
          3,
          8,
          -10,
          23,
          19,
          -4,
          -14,
          27
        ]
      ],
      "expected": [
        [
          -14,
          -10
        ],
        [
          19,
          23
        ],
        [
          23,
          27
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
        2
      ]
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
        1
      ]
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
        5,
        4,
        3
      ]
    ],
    "expected": [
      [
        3,
        4
      ],
      [
        4,
        5
      ]
    ]
  },
  {
    "args": [
      [
        -1,
        -3,
        0
      ]
    ],
    "expected": [
      [
        -1,
        0
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1348,
    '数组形式的整数加法',
    '非负整数 num 以数组形式给出（最高位在前）。返回 num + k 的数组形式。',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "num = [1, 2, 0, 0], k = 34",
    "output": "[1, 2, 3, 4]"
  },
  {
    "input": "num = [2, 7, 4], k = 181",
    "output": "[4, 5, 5]"
  },
  {
    "input": "num = [2, 1, 5], k = 806",
    "output": "[1, 0, 2, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = [1, 2, 0, 0], k = 34",
    "output": "[1, 2, 3, 4]"
  },
  {
    "input": "num = [2, 7, 4], k = 181",
    "output": "[4, 5, 5]"
  },
  {
    "input": "num = [2, 1, 5], k = 806",
    "output": "[1, 0, 2, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var addToArrayForm = function(num, k) {\n};\n",
  "python": "class Solution:\n    def addToArrayForm(self, num: list[int], k: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> addToArrayForm(std::vector<int>& num, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] addToArrayForm(int[] num, int k) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "addToArrayForm",
  "params": [
    {
      "name": "num",
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
          0,
          0
        ],
        34
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
          7,
          4
        ],
        181
      ],
      "expected": [
        4,
        5,
        5
      ]
    },
    {
      "args": [
        [
          2,
          1,
          5
        ],
        806
      ],
      "expected": [
        1,
        0,
        2,
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
      ],
      0
    ],
    "expected": [
      0
    ]
  },
  {
    "args": [
      [
        0
      ],
      23
    ],
    "expected": [
      2,
      3
    ]
  },
  {
    "args": [
      [
        9,
        9,
        9
      ],
      1
    ],
    "expected": [
      1,
      0,
      0,
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
      ],
      1000
    ],
    "expected": [
      2,
      0,
      0,
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1349,
    '可被 5 整除的二进制前缀',
    '给定由 0 和 1 组成的数组 nums。对每个前缀，判断其二进制数值是否能被 5 整除，
返回布尔数组。',
    'easy',
    1000,
    256,
    ARRAY['数组', '位运算'],
    $json$[
  {
    "input": "nums = [0, 1, 1]",
    "output": "[true, false, false]"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "[false, false, false]"
  },
  {
    "input": "nums = [0, 1, 1, 1, 1, 1]",
    "output": "[true, false, false, false, true, false]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [0, 1, 1]",
    "output": "[true, false, false]"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "[false, false, false]"
  },
  {
    "input": "nums = [0, 1, 1, 1, 1, 1]",
    "output": "[true, false, false, false, true, false]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var prefixesDivBy5 = function(nums) {\n};\n",
  "python": "class Solution:\n    def prefixesDivBy5(self, nums: list[int]) -> list[bool]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<bool> prefixesDivBy5(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public boolean[] prefixesDivBy5(int[] nums) {\n        return new boolean[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "prefixesDivBy5",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    }
  ],
  "return_type": "bool[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          0,
          1,
          1
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
        [
          1,
          1,
          1
        ]
      ],
      "expected": [
        false,
        false,
        false
      ]
    },
    {
      "args": [
        [
          0,
          1,
          1,
          1,
          1,
          1
        ]
      ],
      "expected": [
        true,
        false,
        false,
        false,
        true,
        false
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
      true
    ]
  },
  {
    "args": [
      [
        1
      ]
    ],
    "expected": [
      false
    ]
  },
  {
    "args": [
      [
        1,
        0,
        1
      ]
    ],
    "expected": [
      false,
      false,
      true
    ]
  },
  {
    "args": [
      [
        1,
        1,
        0,
        1
      ]
    ],
    "expected": [
      false,
      false,
      false,
      false
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1350,
    '三维形体的表面积',
    '给定 n x n 网格 grid，grid[i][j] 表示该位置叠放的立方体数量。
返回所有立方体暴露在外的总表面积。',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵', '几何'],
    $json$[
  {
    "input": "grid = [[2]]",
    "output": "10"
  },
  {
    "input": "grid = [[1, 2], [3, 4]]",
    "output": "34"
  },
  {
    "input": "grid = [[1, 0], [0, 2]]",
    "output": "16"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[2]]",
    "output": "10"
  },
  {
    "input": "grid = [[1, 2], [3, 4]]",
    "output": "34"
  },
  {
    "input": "grid = [[1, 0], [0, 2]]",
    "output": "16"
  }
]$json$::jsonb,
    $json${
  "javascript": "var surfaceArea = function(grid) {\n};\n",
  "python": "class Solution:\n    def surfaceArea(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int surfaceArea(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int surfaceArea(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "surfaceArea",
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
            2
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
            2
          ],
          [
            3,
            4
          ]
        ]
      ],
      "expected": 34
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
            2
          ]
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
    "expected": 30
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
    "expected": 12
  }
]$json$::jsonb,
    'approved'
),
(
    1351,
    '访问所有点的最小时间',
    '按顺序访问 points 中的所有点。每步可以水平、垂直或对角线移动一个单位。
返回访问所有点的最小总时间。',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "points = [[1, 1], [3, 4], [-1, 0]]",
    "output": "7"
  },
  {
    "input": "points = [[3, 2], [-2, 2]]",
    "output": "5"
  },
  {
    "input": "points = [[0, 0], [1, 1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "points = [[1, 1], [3, 4], [-1, 0]]",
    "output": "7"
  },
  {
    "input": "points = [[3, 2], [-2, 2]]",
    "output": "5"
  },
  {
    "input": "points = [[0, 0], [1, 1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minTimeToVisitAllPoints = function(points) {\n};\n",
  "python": "class Solution:\n    def minTimeToVisitAllPoints(self, points: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minTimeToVisitAllPoints(std::vector<std::vector<int>>& points) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minTimeToVisitAllPoints(int[][] points) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minTimeToVisitAllPoints",
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
            1,
            1
          ],
          [
            3,
            4
          ],
          [
            -1,
            0
          ]
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        [
          [
            3,
            2
          ],
          [
            -2,
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
            1,
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
          0
        ],
        [
          2,
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
          1
        ],
        [
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
    1352,
    '第 N 个泰波那契数',
    'T0 = 0，T1 = 1，T2 = 1，且 Tn = Tn-1 + Tn-2 + Tn-3。
给定 n（0 <= n <= 37），返回 Tn。',
    'easy',
    1000,
    256,
    ARRAY['数学', '动态规划'],
    $json$[
  {
    "input": "n = 4",
    "output": "4"
  },
  {
    "input": "n = 25",
    "output": "1389537"
  },
  {
    "input": "n = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4",
    "output": "4"
  },
  {
    "input": "n = 25",
    "output": "1389537"
  },
  {
    "input": "n = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var tribonacci = function(n) {\n};\n",
  "python": "class Solution:\n    def tribonacci(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int tribonacci(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int tribonacci(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "tribonacci",
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
      "expected": 4
    },
    {
      "args": [
        25
      ],
      "expected": 1389537
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
    "expected": 2
  },
  {
    "args": [
      5
    ],
    "expected": 7
  },
  {
    "args": [
      10
    ],
    "expected": 149
  }
]$json$::jsonb,
    'approved'
),
(
    1353,
    '重新排列数组',
    '给定长度为 2n 的数组 nums，前 n 个元素为 x 部分，后 n 个元素为 y 部分。
返回 [x1, y1, x2, y2, ..., xn, yn]。',
    'easy',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "nums = [2, 5, 1, 3, 4, 7], n = 3",
    "output": "[2, 3, 5, 4, 1, 7]"
  },
  {
    "input": "nums = [1, 2, 3, 4, 4, 3, 2, 1], n = 4",
    "output": "[1, 4, 2, 3, 3, 2, 4, 1]"
  },
  {
    "input": "nums = [1, 1, 2, 2], n = 2",
    "output": "[1, 2, 1, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 5, 1, 3, 4, 7], n = 3",
    "output": "[2, 3, 5, 4, 1, 7]"
  },
  {
    "input": "nums = [1, 2, 3, 4, 4, 3, 2, 1], n = 4",
    "output": "[1, 4, 2, 3, 3, 2, 4, 1]"
  },
  {
    "input": "nums = [1, 1, 2, 2], n = 2",
    "output": "[1, 2, 1, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var shuffle = function(nums, n) {\n};\n",
  "python": "class Solution:\n    def shuffle(self, nums: list[int], n: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> shuffle(std::vector<int>& nums, int n) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] shuffle(int[] nums, int n) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "shuffle",
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
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          2,
          5,
          1,
          3,
          4,
          7
        ],
        3
      ],
      "expected": [
        2,
        3,
        5,
        4,
        1,
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
          4,
          3,
          2,
          1
        ],
        4
      ],
      "expected": [
        1,
        4,
        2,
        3,
        3,
        2,
        4,
        1
      ]
    },
    {
      "args": [
        [
          1,
          1,
          2,
          2
        ],
        2
      ],
      "expected": [
        1,
        2,
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
        2
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
        3,
        4
      ],
      2
    ],
    "expected": [
      1,
      3,
      2,
      4
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1354,
    '一维数组的动态和',
    '返回数组 nums 的动态和：runningSum[i] = sum(nums[0..i])。',
    'easy',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "[1, 3, 6, 10]"
  },
  {
    "input": "nums = [1, 1, 1, 1, 1]",
    "output": "[1, 2, 3, 4, 5]"
  },
  {
    "input": "nums = [3, 1, 2, 10, 1]",
    "output": "[3, 4, 6, 16, 17]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "[1, 3, 6, 10]"
  },
  {
    "input": "nums = [1, 1, 1, 1, 1]",
    "output": "[1, 2, 3, 4, 5]"
  },
  {
    "input": "nums = [3, 1, 2, 10, 1]",
    "output": "[3, 4, 6, 16, 17]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var runningSum = function(nums) {\n};\n",
  "python": "class Solution:\n    def runningSum(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> runningSum(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] runningSum(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "runningSum",
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
        1,
        3,
        6,
        10
      ]
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
          3,
          1,
          2,
          10,
          1
        ]
      ],
      "expected": [
        3,
        4,
        6,
        16,
        17
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
        -2
      ]
    ],
    "expected": [
      -1,
      -3
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
      5,
      10
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1355,
    '将数组分成和相等的三个部分',
    '判断能否将数组 arr 分成三个非空连续部分，使三部分元素和相等。',
    'easy',
    1000,
    256,
    ARRAY['数组', '前缀和', '贪心'],
    $json$[
  {
    "input": "arr = [0, 2, 1, -6, 6, -7, 9, 1, 2, 0, 1]",
    "output": "true"
  },
  {
    "input": "arr = [0, 2, 1, -6, 6, 7, 9, -1, 2, 0, 1]",
    "output": "false"
  },
  {
    "input": "arr = [3, 3, 6, 5, -2, 2, 5, 1, -9, 4]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [0, 2, 1, -6, 6, -7, 9, 1, 2, 0, 1]",
    "output": "true"
  },
  {
    "input": "arr = [0, 2, 1, -6, 6, 7, 9, -1, 2, 0, 1]",
    "output": "false"
  },
  {
    "input": "arr = [3, 3, 6, 5, -2, 2, 5, 1, -9, 4]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canThreePartsEqualSum = function(arr) {\n};\n",
  "python": "class Solution:\n    def canThreePartsEqualSum(self, arr: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canThreePartsEqualSum(std::vector<int>& arr) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canThreePartsEqualSum(int[] arr) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canThreePartsEqualSum",
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
          0,
          2,
          1,
          -6,
          6,
          -7,
          9,
          1,
          2,
          0,
          1
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          0,
          2,
          1,
          -6,
          6,
          7,
          9,
          -1,
          2,
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
          3,
          6,
          5,
          -2,
          2,
          5,
          1,
          -9,
          4
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
        0
      ]
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
        2,
        3,
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
        0,
        1
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1356,
    '找出数组中的幸运数',
    '幸运数指出现次数恰好等于其数值的元素。返回最大的幸运数；不存在返回 -1。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '计数'],
    $json$[
  {
    "input": "arr = [2, 2, 3, 4]",
    "output": "2"
  },
  {
    "input": "arr = [1, 2, 2, 3, 3, 3]",
    "output": "3"
  },
  {
    "input": "arr = [2, 2, 2, 3, 3]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [2, 2, 3, 4]",
    "output": "2"
  },
  {
    "input": "arr = [1, 2, 2, 3, 3, 3]",
    "output": "3"
  },
  {
    "input": "arr = [2, 2, 2, 3, 3]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findLucky = function(arr) {\n};\n",
  "python": "class Solution:\n    def findLucky(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findLucky(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findLucky(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findLucky",
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
          2,
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
          2,
          2,
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
          2,
          2,
          2,
          3,
          3
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
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        1,
        1,
        1
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        5,
        5,
        5,
        5,
        5
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        3,
        3,
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
    1357,
    '整数的各位积和之差',
    '返回整数 n 的各位数字之积减去各位数字之和的结果。',
    'easy',
    1000,
    256,
    ARRAY['数学'],
    $json$[
  {
    "input": "n = 234",
    "output": "15"
  },
  {
    "input": "n = 4421",
    "output": "21"
  },
  {
    "input": "n = 1",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 234",
    "output": "15"
  },
  {
    "input": "n = 4421",
    "output": "21"
  },
  {
    "input": "n = 1",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var subtractProductAndSum = function(n) {\n};\n",
  "python": "class Solution:\n    def subtractProductAndSum(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int subtractProductAndSum(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int subtractProductAndSum(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "subtractProductAndSum",
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
        234
      ],
      "expected": 15
    },
    {
      "args": [
        4421
      ],
      "expected": 21
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
      10
    ],
    "expected": -1
  },
  {
    "args": [
      99
    ],
    "expected": 63
  },
  {
    "args": [
      12345
    ],
    "expected": 105
  },
  {
    "args": [
      11111
    ],
    "expected": -4
  }
]$json$::jsonb,
    'approved'
),
(
    1358,
    '换酒问题',
    '初始有 numBottles 瓶酒。每 numExchange 个空瓶可以换 1 瓶酒。
返回最多能喝到的酒瓶数。',
    'easy',
    1000,
    256,
    ARRAY['数学', '模拟'],
    $json$[
  {
    "input": "numBottles = 9, numExchange = 3",
    "output": "13"
  },
  {
    "input": "numBottles = 15, numExchange = 4",
    "output": "19"
  },
  {
    "input": "numBottles = 5, numExchange = 5",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "numBottles = 9, numExchange = 3",
    "output": "13"
  },
  {
    "input": "numBottles = 15, numExchange = 4",
    "output": "19"
  },
  {
    "input": "numBottles = 5, numExchange = 5",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numWaterBottles = function(numBottles, numExchange) {\n};\n",
  "python": "class Solution:\n    def numWaterBottles(self, numBottles: int, numExchange: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numWaterBottles(int numBottles, int numExchange) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numWaterBottles(int numBottles, int numExchange) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numWaterBottles",
  "params": [
    {
      "name": "numBottles",
      "type": "int"
    },
    {
      "name": "numExchange",
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
        9,
        3
      ],
      "expected": 13
    },
    {
      "args": [
        15,
        4
      ],
      "expected": 19
    },
    {
      "args": [
        5,
        5
      ],
      "expected": 6
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
      2
    ],
    "expected": 3
  },
  {
    "args": [
      10,
      3
    ],
    "expected": 14
  },
  {
    "args": [
      100,
      2
    ],
    "expected": 199
  }
]$json$::jsonb,
    'approved'
),
(
    1359,
    '找出所有子集的异或总和再求和',
    '返回数组 nums 所有子集的异或值之和。',
    'easy',
    1000,
    256,
    ARRAY['数组', '位运算', '数学'],
    $json$[
  {
    "input": "nums = [1, 3]",
    "output": "6"
  },
  {
    "input": "nums = [5, 1, 6]",
    "output": "28"
  },
  {
    "input": "nums = [3, 4, 5, 6, 7, 8]",
    "output": "480"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3]",
    "output": "6"
  },
  {
    "input": "nums = [5, 1, 6]",
    "output": "28"
  },
  {
    "input": "nums = [3, 4, 5, 6, 7, 8]",
    "output": "480"
  }
]$json$::jsonb,
    $json${
  "javascript": "var subsetXORSum = function(nums) {\n};\n",
  "python": "class Solution:\n    def subsetXORSum(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int subsetXORSum(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int subsetXORSum(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "subsetXORSum",
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
          3
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          5,
          1,
          6
        ]
      ],
      "expected": 28
    },
    {
      "args": [
        [
          3,
          4,
          5,
          6,
          7,
          8
        ]
      ],
      "expected": 480
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
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        2,
        3
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
  }
]$json$::jsonb,
    'approved'
),
(
    1360,
    '到目标元素的最小距离',
    '返回数组 nums 中距离 start 最近且值等于 target 的下标与 start 的距离。
保证 target 在 nums 中出现。',
    'easy',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 4, 5], target = 5, start = 3",
    "output": "1"
  },
  {
    "input": "nums = [1], target = 1, start = 0",
    "output": "0"
  },
  {
    "input": "nums = [1, 1, 1, 1, 1], target = 1, start = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 4, 5], target = 5, start = 3",
    "output": "1"
  },
  {
    "input": "nums = [1], target = 1, start = 0",
    "output": "0"
  },
  {
    "input": "nums = [1, 1, 1, 1, 1], target = 1, start = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var getMinDistance = function(nums, target, start) {\n};\n",
  "python": "class Solution:\n    def getMinDistance(self, nums: list[int], target: int, start: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int getMinDistance(std::vector<int>& nums, int target, int start) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int getMinDistance(int[] nums, int target, int start) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getMinDistance",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "target",
      "type": "int"
    },
    {
      "name": "start",
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
          3,
          4,
          5
        ],
        5,
        3
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1
        ],
        1,
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
          1,
          1
        ],
        1,
        0
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
        3,
        4
      ],
      3,
      1
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
      ],
      2,
      0
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        2,
        1
      ],
      1,
      1
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1361,
    '检查单词是否为句中其他单词的前缀',
    '给定句子 sentence 和 searchWord，返回 searchWord 作为句子中某个单词前缀时
该单词的 1 基下标；不存在返回 -1。',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "sentence = \"i love eating burger\", searchWord = \"burg\"",
    "output": "4"
  },
  {
    "input": "sentence = \"this problem is an easy problem\", searchWord = \"pro\"",
    "output": "2"
  },
  {
    "input": "sentence = \"i am tired\", searchWord = \"you\"",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "sentence = \"i love eating burger\", searchWord = \"burg\"",
    "output": "4"
  },
  {
    "input": "sentence = \"this problem is an easy problem\", searchWord = \"pro\"",
    "output": "2"
  },
  {
    "input": "sentence = \"i am tired\", searchWord = \"you\"",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isPrefixOfWord = function(sentence, searchWord) {\n};\n",
  "python": "class Solution:\n    def isPrefixOfWord(self, sentence: str, searchWord: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int isPrefixOfWord(std::string sentence, std::string searchWord) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int isPrefixOfWord(String sentence, String searchWord) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isPrefixOfWord",
  "params": [
    {
      "name": "sentence",
      "type": "string"
    },
    {
      "name": "searchWord",
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
        "i love eating burger",
        "burg"
      ],
      "expected": 4
    },
    {
      "args": [
        "this problem is an easy problem",
        "pro"
      ],
      "expected": 2
    },
    {
      "args": [
        "i am tired",
        "you"
      ],
      "expected": -1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "hello world",
      "hello"
    ],
    "expected": 1
  },
  {
    "args": [
      "a b c",
      "b"
    ],
    "expected": 2
  },
  {
    "args": [
      "abc abd",
      "ab"
    ],
    "expected": 1
  },
  {
    "args": [
      "a",
      "a"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1362,
    '无法吃午餐的学生数量',
    '学生排队，sandwiches 栈顶在前。若队首学生喜欢栈顶三明治，他取走并离开；
否则回到队尾。返回无法吃午餐的学生数量。',
    'easy',
    1000,
    256,
    ARRAY['数组', '队列', '计数'],
    $json$[
  {
    "input": "students = [1, 1, 0, 0], sandwiches = [0, 1, 0, 1]",
    "output": "0"
  },
  {
    "input": "students = [1, 1, 1, 0, 0, 1], sandwiches = [1, 0, 0, 0, 1, 1]",
    "output": "3"
  },
  {
    "input": "students = [1, 0, 1, 0], sandwiches = [0, 1, 0, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "students = [1, 1, 0, 0], sandwiches = [0, 1, 0, 1]",
    "output": "0"
  },
  {
    "input": "students = [1, 1, 1, 0, 0, 1], sandwiches = [1, 0, 0, 0, 1, 1]",
    "output": "3"
  },
  {
    "input": "students = [1, 0, 1, 0], sandwiches = [0, 1, 0, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countStudents = function(students, sandwiches) {\n};\n",
  "python": "class Solution:\n    def countStudents(self, students: list[int], sandwiches: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countStudents(std::vector<int>& students, std::vector<int>& sandwiches) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countStudents(int[] students, int[] sandwiches) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countStudents",
  "params": [
    {
      "name": "students",
      "type": "int[]"
    },
    {
      "name": "sandwiches",
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
          0
        ],
        [
          0,
          1,
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
          1,
          1,
          0,
          0,
          1
        ],
        [
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
          1,
          0,
          1,
          0
        ],
        [
          0,
          1,
          0,
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
        0
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
        1
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
        1
      ],
      [
        0,
        0
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1363,
    '解压缩编码列表',
    'nums 按 [freq, val, freq, val, ...] 排列。
返回解压后的数组：每个 val 重复 freq 次。',
    'easy',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "[2, 4, 4, 4]"
  },
  {
    "input": "nums = [1, 1, 2, 3]",
    "output": "[1, 3, 3]"
  },
  {
    "input": "nums = [1, 2]",
    "output": "[2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "[2, 4, 4, 4]"
  },
  {
    "input": "nums = [1, 1, 2, 3]",
    "output": "[1, 3, 3]"
  },
  {
    "input": "nums = [1, 2]",
    "output": "[2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var decompressRLElist = function(nums) {\n};\n",
  "python": "class Solution:\n    def decompressRLElist(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> decompressRLElist(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] decompressRLElist(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "decompressRLElist",
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
        2,
        4,
        4,
        4
      ]
    },
    {
      "args": [
        [
          1,
          1,
          2,
          3
        ]
      ],
      "expected": [
        1,
        3,
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
        2
      ]
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
    "expected": []
  },
  {
    "args": [
      [
        2,
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
        1,
        5,
        2,
        3
      ]
    ],
    "expected": [
      5,
      3,
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1364,
    '二进制链表转整数',
    '链表每个节点的值为 0 或 1，最高位在头节点。
返回该链表表示的十进制整数。',
    'easy',
    1000,
    256,
    ARRAY['链表', '数学'],
    $json$[
  {
    "input": "head = [1, 0, 1]",
    "output": "5"
  },
  {
    "input": "head = [0]",
    "output": "0"
  },
  {
    "input": "head = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 0, 1]",
    "output": "5"
  },
  {
    "input": "head = [0]",
    "output": "0"
  },
  {
    "input": "head = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar getDecimalValue = function(head) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def getDecimalValue(self, head: ListNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int getDecimalValue(ListNode* head) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int getDecimalValue(ListNode head) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getDecimalValue",
  "params": [
    {
      "name": "head",
      "type": "ListNode"
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
          1
        ]
      ],
      "expected": 5
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
        1,
        1,
        1,
        1
      ]
    ],
    "expected": 15
  },
  {
    "args": [
      [
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
        0,
        0,
        1,
        0,
        0,
        1,
        1,
        1,
        0,
        0,
        0,
        0,
        0,
        0
      ]
    ],
    "expected": 18880
  }
]$json$::jsonb,
    'approved'
),
(
    1365,
    '移除链表元素',
    '删除链表中所有值等于 val 的节点，返回新的头节点。',
    'easy',
    1000,
    256,
    ARRAY['链表'],
    $json$[
  {
    "input": "head = [1, 2, 6, 3, 4, 5, 6], val = 6",
    "output": "[1, 2, 3, 4, 5]"
  },
  {
    "input": "head = [], val = 7",
    "output": "[]"
  },
  {
    "input": "head = [7, 7, 7, 7], val = 7",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 2, 6, 3, 4, 5, 6], val = 6",
    "output": "[1, 2, 3, 4, 5]"
  },
  {
    "input": "head = [], val = 7",
    "output": "[]"
  },
  {
    "input": "head = [7, 7, 7, 7], val = 7",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar removeElements = function(head, val) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def removeElements(self, head: ListNode | None, val: int) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* removeElements(ListNode* head, int val) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode removeElements(ListNode head, int val) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeElements",
  "params": [
    {
      "name": "head",
      "type": "ListNode"
    },
    {
      "name": "val",
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
          6,
          3,
          4,
          5,
          6
        ],
        6
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
        [],
        7
      ],
      "expected": []
    },
    {
      "args": [
        [
          7,
          7,
          7,
          7
        ],
        7
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
      1,
      2,
      3
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
        2,
        1,
        2
      ],
      2
    ],
    "expected": [
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1366,
    '链表中倒数第 k 个节点',
    '返回链表中倒数第 k 个节点，并以该节点为头组成结果链表。
1 <= k <= 链表长度。',
    'easy',
    1000,
    256,
    ARRAY['链表', '双指针'],
    $json$[
  {
    "input": "head = [1, 2, 3, 4, 5], k = 2",
    "output": "[4, 5]"
  },
  {
    "input": "head = [1], k = 1",
    "output": "[1]"
  },
  {
    "input": "head = [1, 2], k = 1",
    "output": "[2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 2, 3, 4, 5], k = 2",
    "output": "[4, 5]"
  },
  {
    "input": "head = [1], k = 1",
    "output": "[1]"
  },
  {
    "input": "head = [1, 2], k = 1",
    "output": "[2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar getKthFromEnd = function(head, k) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def getKthFromEnd(self, head: ListNode | None, k: int) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* getKthFromEnd(ListNode* head, int k) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode getKthFromEnd(ListNode head, int k) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getKthFromEnd",
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
        1
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
      4
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
        5,
        4,
        3,
        2,
        1
      ],
      3
    ],
    "expected": [
      3,
      2,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1367,
    '二叉树的最小深度',
    '最小深度是从根节点到最近叶子节点的节点数。返回二叉树的最小深度。
空树深度为 0。',
    'easy',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '广度优先搜索'],
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "2"
  },
  {
    "input": "root = [2, null, 3, null, 4, null, 5, null, 6]",
    "output": "5"
  },
  {
    "input": "root = []",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "2"
  },
  {
    "input": "root = [2, null, 3, null, 4, null, 5, null, 6]",
    "output": "5"
  },
  {
    "input": "root = []",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar minDepth = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def minDepth(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int minDepth(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int minDepth(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minDepth",
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
      "expected": 2
    },
    {
      "args": [
        [
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
      ],
      "expected": 5
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
        3,
        4,
        null,
        null,
        5
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1368,
    '相同的树',
    '判断两棵二叉树的结构和节点值是否完全相同。',
    'easy',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "p = [1, 2, 3], q = [1, 2, 3]",
    "output": "true"
  },
  {
    "input": "p = [1, 2], q = [1, null, 2]",
    "output": "false"
  },
  {
    "input": "p = [1, 2, 1], q = [1, 1, 2]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "p = [1, 2, 3], q = [1, 2, 3]",
    "output": "true"
  },
  {
    "input": "p = [1, 2], q = [1, null, 2]",
    "output": "false"
  },
  {
    "input": "p = [1, 2, 1], q = [1, 1, 2]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar isSameTree = function(p, q) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def isSameTree(self, p: TreeNode | None, q: TreeNode | None) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool isSameTree(TreeNode* p, TreeNode* q) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean isSameTree(TreeNode p, TreeNode q) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isSameTree",
  "params": [
    {
      "name": "p",
      "type": "TreeNode"
    },
    {
      "name": "q",
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
          3
        ],
        [
          1,
          2,
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
        ],
        [
          1,
          null,
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
          1
        ],
        [
          1,
          1,
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
      [],
      []
    ],
    "expected": true
  },
  {
    "args": [
      [],
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
        2,
        3
      ],
      [
        1,
        2,
        4
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        null,
        2
      ],
      [
        1,
        null,
        2
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1369,
    '平衡二叉树',
    '判断二叉树是否高度平衡：每个节点的左右子树高度差不超过 1。',
    'easy',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "true"
  },
  {
    "input": "root = [1, 2, 2, 3, 3, null, null, 4, 4]",
    "output": "false"
  },
  {
    "input": "root = []",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "true"
  },
  {
    "input": "root = [1, 2, 2, 3, 3, null, null, 4, 4]",
    "output": "false"
  },
  {
    "input": "root = []",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar isBalanced = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def isBalanced(self, root: TreeNode | None) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool isBalanced(TreeNode* root) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean isBalanced(TreeNode root) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isBalanced",
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
          3,
          9,
          20,
          null,
          null,
          15,
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
          2,
          3,
          3,
          null,
          null,
          4,
          4
        ]
      ],
      "expected": false
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
    1370,
    '二叉树的层平均值',
    '返回二叉树每一层节点值的平均值，按从根到叶的顺序。',
    'easy',
    1000,
    256,
    ARRAY['树', '广度优先搜索'],
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "[3.0, 14.5, 11.0]"
  },
  {
    "input": "root = [3, 9, 20, 15, 7]",
    "output": "[3.0, 14.5, 11.0]"
  },
  {
    "input": "root = []",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "[3.0, 14.5, 11.0]"
  },
  {
    "input": "root = [3, 9, 20, 15, 7]",
    "output": "[3.0, 14.5, 11.0]"
  },
  {
    "input": "root = []",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar averageOfLevels = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def averageOfLevels(self, root: TreeNode | None) -> list[float]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::vector<double> averageOfLevels(TreeNode* root) {\n        return {};\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public double[] averageOfLevels(TreeNode root) {\n        return new double[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "averageOfLevels",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    }
  ],
  "return_type": "double[]",
  "compare": {
    "mode": "double"
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
        3.0,
        14.5,
        11.0
      ]
    },
    {
      "args": [
        [
          3,
          9,
          20,
          15,
          7
        ]
      ],
      "expected": [
        3.0,
        14.5,
        11.0
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
        1
      ]
    ],
    "expected": [
      1.0
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
      1.0,
      2.5
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
      1.0,
      2.0
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
      1.0,
      2.0,
      3.0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1371,
    '二叉树的所有路径',
    '返回所有从根节点到叶子节点的路径字符串，按从左到右的叶子顺序。
路径格式为 "a->b->c"。空树返回空数组。',
    'easy',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '回溯'],
    $json$[
  {
    "input": "root = [1, 2, 3, null, 5]",
    "output": "[\"1->2->5\", \"1->3\"]"
  },
  {
    "input": "root = [1]",
    "output": "[\"1\"]"
  },
  {
    "input": "root = []",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3, null, 5]",
    "output": "[\"1->2->5\", \"1->3\"]"
  },
  {
    "input": "root = [1]",
    "output": "[\"1\"]"
  },
  {
    "input": "root = []",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar binaryTreePaths = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def binaryTreePaths(self, root: TreeNode | None) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::vector<std::string> binaryTreePaths(TreeNode* root) {\n        return {};\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public String[] binaryTreePaths(TreeNode root) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "binaryTreePaths",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
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
          1,
          2,
          3,
          null,
          5
        ]
      ],
      "expected": [
        "1->2->5",
        "1->3"
      ]
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": [
        "1"
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
      "1->2"
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
      "1->2"
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
      "1->2->4",
      "1->2->5",
      "1->3->6",
      "1->3->7"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1372,
    '左叶子之和',
    '返回所有左叶子节点值之和。左叶子是某个节点的左孩子，且自身没有孩子。',
    'easy',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "24"
  },
  {
    "input": "root = [1]",
    "output": "0"
  },
  {
    "input": "root = []",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "24"
  },
  {
    "input": "root = [1]",
    "output": "0"
  },
  {
    "input": "root = []",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar sumOfLeftLeaves = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def sumOfLeftLeaves(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int sumOfLeftLeaves(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int sumOfLeftLeaves(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumOfLeftLeaves",
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
      "expected": 24
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
        2
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        null,
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
        3,
        4,
        null,
        null,
        5
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1373,
    '叶子相似的树',
    '判断两棵二叉树的叶子节点值序列（从左到右）是否相同。',
    'easy',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root1 = [3, 5, 1, 6, 2, 9, 8, null, null, 7, 4], root2 = [3, 5, 1, 6, 7, 4, 2, null, null, null, null, null, null, 9, 8]",
    "output": "true"
  },
  {
    "input": "root1 = [1], root2 = [1]",
    "output": "true"
  },
  {
    "input": "root1 = [1], root2 = [2]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root1 = [3, 5, 1, 6, 2, 9, 8, null, null, 7, 4], root2 = [3, 5, 1, 6, 7, 4, 2, null, null, null, null, null, null, 9, 8]",
    "output": "true"
  },
  {
    "input": "root1 = [1], root2 = [1]",
    "output": "true"
  },
  {
    "input": "root1 = [1], root2 = [2]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar leafSimilar = function(root1, root2) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def leafSimilar(self, root1: TreeNode | None, root2: TreeNode | None) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool leafSimilar(TreeNode* root1, TreeNode* root2) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean leafSimilar(TreeNode root1, TreeNode root2) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "leafSimilar",
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
  "return_type": "bool",
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
          9,
          8,
          null,
          null,
          7,
          4
        ],
        [
          3,
          5,
          1,
          6,
          7,
          4,
          2,
          null,
          null,
          null,
          null,
          null,
          null,
          9,
          8
        ]
      ],
      "expected": true
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
          1
        ],
        [
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
      [],
      []
    ],
    "expected": true
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
    "expected": false
  },
  {
    "args": [
      [
        1,
        null,
        2
      ],
      [
        1,
        2
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1374,
    '单值二叉树',
    '判断二叉树的所有节点值是否相同。空树视为单值二叉树。',
    'easy',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [1, 1, 1, 1, 1, null, 1]",
    "output": "true"
  },
  {
    "input": "root = [2, 2, 2, 5, 2]",
    "output": "false"
  },
  {
    "input": "root = []",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 1, 1, 1, 1, null, 1]",
    "output": "true"
  },
  {
    "input": "root = [2, 2, 2, 5, 2]",
    "output": "false"
  },
  {
    "input": "root = []",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar isUnivalTree = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def isUnivalTree(self, root: TreeNode | None) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool isUnivalTree(TreeNode* root) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean isUnivalTree(TreeNode root) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isUnivalTree",
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
          1,
          1,
          1,
          1,
          null,
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
          5,
          2
        ]
      ],
      "expected": false
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
        null,
        1
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1375,
    '最长连续序列',
    '给定未排序的整数数组 nums，返回其中最长的连续数字序列的长度。
要求算法时间复杂度为 O(n)。',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "nums = [100, 4, 200, 1, 3, 2]",
    "output": "4"
  },
  {
    "input": "nums = [0, 3, 7, 2, 5, 8, 4, 6, 0, 1]",
    "output": "9"
  },
  {
    "input": "nums = []",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [100, 4, 200, 1, 3, 2]",
    "output": "4"
  },
  {
    "input": "nums = [0, 3, 7, 2, 5, 8, 4, 6, 0, 1]",
    "output": "9"
  },
  {
    "input": "nums = []",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestConsecutive = function(nums) {\n};\n",
  "python": "class Solution:\n    def longestConsecutive(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestConsecutive(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestConsecutive(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestConsecutive",
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
          100,
          4,
          200,
          1,
          3,
          2
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          0,
          3,
          7,
          2,
          5,
          8,
          4,
          6,
          0,
          1
        ]
      ],
      "expected": 9
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
        9,
        1,
        4,
        7,
        3,
        -1,
        0,
        5,
        8,
        -1,
        6
      ]
    ],
    "expected": 7
  }
]$json$::jsonb,
    'approved'
),
(
    1376,
    '矩阵置零',
    '给定 m x n 矩阵 matrix。若 matrix[i][j] == 0，则将其所在行和列的所有元素置为 0。
返回处理后的矩阵。',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '哈希表'],
    $json$[
  {
    "input": "matrix = [[1, 1, 1], [1, 0, 1], [1, 1, 1]]",
    "output": "[[1, 0, 1], [0, 0, 0], [1, 0, 1]]"
  },
  {
    "input": "matrix = [[0, 1, 2, 0], [3, 4, 5, 2], [1, 3, 1, 5]]",
    "output": "[[0, 0, 0, 0], [0, 4, 5, 0], [0, 3, 1, 0]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 1, 1], [1, 0, 1], [1, 1, 1]]",
    "output": "[[1, 0, 1], [0, 0, 0], [1, 0, 1]]"
  },
  {
    "input": "matrix = [[0, 1, 2, 0], [3, 4, 5, 2], [1, 3, 1, 5]]",
    "output": "[[0, 0, 0, 0], [0, 4, 5, 0], [0, 3, 1, 0]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var setZeroes = function(matrix) {\n};\n",
  "python": "class Solution:\n    def setZeroes(self, matrix: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> setZeroes(std::vector<std::vector<int>>& matrix) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] setZeroes(int[][] matrix) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "setZeroes",
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
    },
    {
      "args": [
        [
          [
            0,
            1,
            2,
            0
          ],
          [
            3,
            4,
            5,
            2
          ],
          [
            1,
            3,
            1,
            5
          ]
        ]
      ],
      "expected": [
        [
          0,
          0,
          0,
          0
        ],
        [
          0,
          4,
          5,
          0
        ],
        [
          0,
          3,
          1,
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
          0
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
          1
        ],
        [
          1,
          0
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
        1,
        2
      ],
      [
        3,
        4
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1377,
    '生命游戏',
    '根据当前状态计算下一状态：活细胞邻居少于 2 个或多于 3 个则死亡，
邻居为 2 或 3 个则存活；死细胞恰好有 3 个活邻居则复活。返回下一状态矩阵。',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '模拟'],
    $json$[
  {
    "input": "board = [[0, 1, 0], [0, 0, 1], [1, 1, 1], [0, 0, 0]]",
    "output": "[[0, 0, 0], [1, 0, 1], [0, 1, 1], [0, 1, 0]]"
  },
  {
    "input": "board = [[1, 1], [1, 0]]",
    "output": "[[1, 1], [1, 1]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "board = [[0, 1, 0], [0, 0, 1], [1, 1, 1], [0, 0, 0]]",
    "output": "[[0, 0, 0], [1, 0, 1], [0, 1, 1], [0, 1, 0]]"
  },
  {
    "input": "board = [[1, 1], [1, 0]]",
    "output": "[[1, 1], [1, 1]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var gameOfLife = function(board) {\n};\n",
  "python": "class Solution:\n    def gameOfLife(self, board: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> gameOfLife(std::vector<std::vector<int>>& board) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] gameOfLife(int[][] board) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "gameOfLife",
  "params": [
    {
      "name": "board",
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
            0,
            1,
            0
          ],
          [
            0,
            0,
            1
          ],
          [
            1,
            1,
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
          0,
          0,
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
            1,
            1
          ],
          [
            1,
            0
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
  }
]$json$::jsonb,
    'approved'
),
(
    1378,
    '插入区间',
    '给定按起点升序排列且互不重叠的区间数组 intervals 和新区间 newInterval。
将 newInterval 插入并合并所有重叠区间，返回结果区间数组。',
    'medium',
    1000,
    256,
    ARRAY['数组', '区间'],
    $json$[
  {
    "input": "intervals = [[1, 3], [6, 9]], newInterval = [2, 5]",
    "output": "[[1, 5], [6, 9]]"
  },
  {
    "input": "intervals = [[1, 2], [3, 5], [6, 7], [8, 10], [12, 16]], newInterval = [4, 8]",
    "output": "[[1, 2], [3, 10], [12, 16]]"
  },
  {
    "input": "intervals = [], newInterval = [5, 7]",
    "output": "[[5, 7]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "intervals = [[1, 3], [6, 9]], newInterval = [2, 5]",
    "output": "[[1, 5], [6, 9]]"
  },
  {
    "input": "intervals = [[1, 2], [3, 5], [6, 7], [8, 10], [12, 16]], newInterval = [4, 8]",
    "output": "[[1, 2], [3, 10], [12, 16]]"
  },
  {
    "input": "intervals = [], newInterval = [5, 7]",
    "output": "[[5, 7]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var insert = function(intervals, newInterval) {\n};\n",
  "python": "class Solution:\n    def insert(self, intervals: list[list[int]], newInterval: list[int]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> insert(std::vector<std::vector<int>>& intervals, std::vector<int>& newInterval) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] insert(int[][] intervals, int[] newInterval) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "insert",
  "params": [
    {
      "name": "intervals",
      "type": "int[][]"
    },
    {
      "name": "newInterval",
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
          [
            1,
            3
          ],
          [
            6,
            9
          ]
        ],
        [
          2,
          5
        ]
      ],
      "expected": [
        [
          1,
          5
        ],
        [
          6,
          9
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
            5
          ],
          [
            6,
            7
          ],
          [
            8,
            10
          ],
          [
            12,
            16
          ]
        ],
        [
          4,
          8
        ]
      ],
      "expected": [
        [
          1,
          2
        ],
        [
          3,
          10
        ],
        [
          12,
          16
        ]
      ]
    },
    {
      "args": [
        [],
        [
          5,
          7
        ]
      ],
      "expected": [
        [
          5,
          7
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
          5
        ]
      ],
      [
        2,
        3
      ]
    ],
    "expected": [
      [
        1,
        5
      ]
    ]
  },
  {
    "args": [
      [
        [
          1,
          5
        ]
      ],
      [
        6,
        8
      ]
    ],
    "expected": [
      [
        1,
        5
      ],
      [
        6,
        8
      ]
    ]
  },
  {
    "args": [
      [
        [
          3,
          5
        ],
        [
          6,
          9
        ]
      ],
      [
        1,
        2
      ]
    ],
    "expected": [
      [
        1,
        2
      ],
      [
        3,
        5
      ],
      [
        6,
        9
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
          5,
          7
        ]
      ],
      [
        3,
        4
      ]
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
        7
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1379,
    '字符串解码',
    '编码规则 k[encoded] 表示方括号内的字符串重复 k 次。
给定编码字符串 s，返回解码后的字符串。输入保证合法。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '栈', '递归'],
    $json$[
  {
    "input": "s = \"3[a]2[bc]\"",
    "output": "\"aaabcbc\""
  },
  {
    "input": "s = \"3[a2[c]]\"",
    "output": "\"accaccacc\""
  },
  {
    "input": "s = \"2[abc]3[cd]ef\"",
    "output": "\"abcabccdcdcdef\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"3[a]2[bc]\"",
    "output": "\"aaabcbc\""
  },
  {
    "input": "s = \"3[a2[c]]\"",
    "output": "\"accaccacc\""
  },
  {
    "input": "s = \"2[abc]3[cd]ef\"",
    "output": "\"abcabccdcdcdef\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var decodeString = function(s) {\n};\n",
  "python": "class Solution:\n    def decodeString(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string decodeString(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String decodeString(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "decodeString",
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
        "3[a]2[bc]"
      ],
      "expected": "aaabcbc"
    },
    {
      "args": [
        "3[a2[c]]"
      ],
      "expected": "accaccacc"
    },
    {
      "args": [
        "2[abc]3[cd]ef"
      ],
      "expected": "abcabccdcdcdef"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abc"
    ],
    "expected": "abc"
  },
  {
    "args": [
      "1[a]"
    ],
    "expected": "a"
  },
  {
    "args": [
      "2[z]"
    ],
    "expected": "zz"
  },
  {
    "args": [
      "10[a]"
    ],
    "expected": "aaaaaaaaaa"
  },
  {
    "args": [
      "2[a2[b]c]"
    ],
    "expected": "abbcabbc"
  }
]$json$::jsonb,
    'approved'
),
(
    1380,
    '每日温度',
    '给定每日温度 temperatures，返回数组 answer。
answer[i] 表示从第 i 天起，下一个更高温度出现在几天后；不存在则为 0。',
    'medium',
    1000,
    256,
    ARRAY['数组', '单调栈'],
    $json$[
  {
    "input": "temperatures = [73, 74, 75, 71, 69, 72, 76, 73]",
    "output": "[1, 1, 4, 2, 1, 1, 0, 0]"
  },
  {
    "input": "temperatures = [30, 40, 50, 60]",
    "output": "[1, 1, 1, 0]"
  },
  {
    "input": "temperatures = [30, 60, 90]",
    "output": "[1, 1, 0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "temperatures = [73, 74, 75, 71, 69, 72, 76, 73]",
    "output": "[1, 1, 4, 2, 1, 1, 0, 0]"
  },
  {
    "input": "temperatures = [30, 40, 50, 60]",
    "output": "[1, 1, 1, 0]"
  },
  {
    "input": "temperatures = [30, 60, 90]",
    "output": "[1, 1, 0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var dailyTemperatures = function(temperatures) {\n};\n",
  "python": "class Solution:\n    def dailyTemperatures(self, temperatures: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> dailyTemperatures(std::vector<int>& temperatures) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] dailyTemperatures(int[] temperatures) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "dailyTemperatures",
  "params": [
    {
      "name": "temperatures",
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
          73,
          74,
          75,
          71,
          69,
          72,
          76,
          73
        ]
      ],
      "expected": [
        1,
        1,
        4,
        2,
        1,
        1,
        0,
        0
      ]
    },
    {
      "args": [
        [
          30,
          40,
          50,
          60
        ]
      ],
      "expected": [
        1,
        1,
        1,
        0
      ]
    },
    {
      "args": [
        [
          30,
          60,
          90
        ]
      ],
      "expected": [
        1,
        1,
        0
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        50
      ]
    ],
    "expected": [
      0
    ]
  },
  {
    "args": [
      [
        50,
        40,
        30
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
        30,
        30,
        30
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
        80,
        70,
        60,
        50,
        40
      ]
    ],
    "expected": [
      0,
      0,
      0,
      0,
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1381,
    '逆波兰表达式求值',
    'tokens 表示一个逆波兰表达式，包含 +、-、*、/ 和整数。
除法向零截断。返回表达式的值。',
    'medium',
    1000,
    256,
    ARRAY['数组', '栈', '数学'],
    $json$[
  {
    "input": "tokens = [\"2\", \"1\", \"+\", \"3\", \"*\"]",
    "output": "9"
  },
  {
    "input": "tokens = [\"4\", \"13\", \"5\", \"/\", \"+\"]",
    "output": "6"
  },
  {
    "input": "tokens = [\"10\", \"6\", \"9\", \"3\", \"+\", \"-11\", \"*\", \"/\", \"*\", \"17\", \"+\", \"5\", \"+\"]",
    "output": "22"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "tokens = [\"2\", \"1\", \"+\", \"3\", \"*\"]",
    "output": "9"
  },
  {
    "input": "tokens = [\"4\", \"13\", \"5\", \"/\", \"+\"]",
    "output": "6"
  },
  {
    "input": "tokens = [\"10\", \"6\", \"9\", \"3\", \"+\", \"-11\", \"*\", \"/\", \"*\", \"17\", \"+\", \"5\", \"+\"]",
    "output": "22"
  }
]$json$::jsonb,
    $json${
  "javascript": "var evalRPN = function(tokens) {\n};\n",
  "python": "class Solution:\n    def evalRPN(self, tokens: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int evalRPN(std::vector<std::string>& tokens) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int evalRPN(String[] tokens) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "evalRPN",
  "params": [
    {
      "name": "tokens",
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
          "2",
          "1",
          "+",
          "3",
          "*"
        ]
      ],
      "expected": 9
    },
    {
      "args": [
        [
          "4",
          "13",
          "5",
          "/",
          "+"
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          "10",
          "6",
          "9",
          "3",
          "+",
          "-11",
          "*",
          "/",
          "*",
          "17",
          "+",
          "5",
          "+"
        ]
      ],
      "expected": 22
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "3"
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        "1",
        "2",
        "+"
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        "5",
        "2",
        "/"
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        "-3",
        "2",
        "/"
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        "4",
        "-2",
        "/"
      ]
    ],
    "expected": -2
  }
]$json$::jsonb,
    'approved'
),
(
    1382,
    '简化路径',
    '将 Unix 风格绝对路径简化：去掉多余斜杠和 "."，处理 ".."。
结果以 "/" 开头，且除根路径外不以 "/" 结尾。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '栈'],
    $json$[
  {
    "input": "path = \"/home/\"",
    "output": "\"/home\""
  },
  {
    "input": "path = \"/../\"",
    "output": "\"/\""
  },
  {
    "input": "path = \"/home//foo/\"",
    "output": "\"/home/foo\""
  },
  {
    "input": "path = \"/a/./b/../../c/\"",
    "output": "\"/c\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "path = \"/home/\"",
    "output": "\"/home\""
  },
  {
    "input": "path = \"/../\"",
    "output": "\"/\""
  },
  {
    "input": "path = \"/home//foo/\"",
    "output": "\"/home/foo\""
  },
  {
    "input": "path = \"/a/./b/../../c/\"",
    "output": "\"/c\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var simplifyPath = function(path) {\n};\n",
  "python": "class Solution:\n    def simplifyPath(self, path: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string simplifyPath(std::string path) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String simplifyPath(String path) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "simplifyPath",
  "params": [
    {
      "name": "path",
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
        "/home/"
      ],
      "expected": "/home"
    },
    {
      "args": [
        "/../"
      ],
      "expected": "/"
    },
    {
      "args": [
        "/home//foo/"
      ],
      "expected": "/home/foo"
    },
    {
      "args": [
        "/a/./b/../../c/"
      ],
      "expected": "/c"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "/"
    ],
    "expected": "/"
  },
  {
    "args": [
      "/a"
    ],
    "expected": "/a"
  },
  {
    "args": [
      "/a/b/../c"
    ],
    "expected": "/a/c"
  },
  {
    "args": [
      "/..."
    ],
    "expected": "/..."
  }
]$json$::jsonb,
    'approved'
),
(
    1383,
    '基本计算器 II',
    '给定包含非负整数、+、-、*、/ 和空格的表达式 s，按整数运算规则计算。
除法向零截断。返回结果。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '栈', '数学'],
    $json$[
  {
    "input": "s = \"3+2*2\"",
    "output": "7"
  },
  {
    "input": "s = \" 3/2 \"",
    "output": "1"
  },
  {
    "input": "s = \" 3+5 / 2 \"",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"3+2*2\"",
    "output": "7"
  },
  {
    "input": "s = \" 3/2 \"",
    "output": "1"
  },
  {
    "input": "s = \" 3+5 / 2 \"",
    "output": "5"
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
        "3+2*2"
      ],
      "expected": 7
    },
    {
      "args": [
        " 3/2 "
      ],
      "expected": 1
    },
    {
      "args": [
        " 3+5 / 2 "
      ],
      "expected": 5
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "1"
    ],
    "expected": 1
  },
  {
    "args": [
      "1+1"
    ],
    "expected": 2
  },
  {
    "args": [
      "2*3+4"
    ],
    "expected": 10
  },
  {
    "args": [
      "14-3/2"
    ],
    "expected": 13
  },
  {
    "args": [
      "1-1+1"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1384,
    '字符串的排列',
    '给定两个字符串 s1 和 s2，判断 s1 的某个排列是否是 s2 的子串。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '哈希表', '滑动窗口'],
    $json$[
  {
    "input": "s1 = \"ab\", s2 = \"eidbaooo\"",
    "output": "true"
  },
  {
    "input": "s1 = \"ab\", s2 = \"eidboaoo\"",
    "output": "false"
  },
  {
    "input": "s1 = \"adc\", s2 = \"dcda\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s1 = \"ab\", s2 = \"eidbaooo\"",
    "output": "true"
  },
  {
    "input": "s1 = \"ab\", s2 = \"eidboaoo\"",
    "output": "false"
  },
  {
    "input": "s1 = \"adc\", s2 = \"dcda\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var checkInclusion = function(s1, s2) {\n};\n",
  "python": "class Solution:\n    def checkInclusion(self, s1: str, s2: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool checkInclusion(std::string s1, std::string s2) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean checkInclusion(String s1, String s2) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkInclusion",
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
        "ab",
        "eidbaooo"
      ],
      "expected": true
    },
    {
      "args": [
        "ab",
        "eidboaoo"
      ],
      "expected": false
    },
    {
      "args": [
        "adc",
        "dcda"
      ],
      "expected": true
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
      "a",
      "b"
    ],
    "expected": false
  },
  {
    "args": [
      "abc",
      "bbbca"
    ],
    "expected": true
  },
  {
    "args": [
      "hello",
      "ooolleoooleh"
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1385,
    '找到字符串中所有字母异位词',
    '返回字符串 s 中所有 p 的字母异位词子串的起始下标，按升序排列。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '哈希表', '滑动窗口'],
    $json$[
  {
    "input": "s = \"cbaebabacd\", p = \"abc\"",
    "output": "[0, 6]"
  },
  {
    "input": "s = \"abab\", p = \"ab\"",
    "output": "[0, 1, 2]"
  },
  {
    "input": "s = \"a\", p = \"a\"",
    "output": "[0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"cbaebabacd\", p = \"abc\"",
    "output": "[0, 6]"
  },
  {
    "input": "s = \"abab\", p = \"ab\"",
    "output": "[0, 1, 2]"
  },
  {
    "input": "s = \"a\", p = \"a\"",
    "output": "[0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findAnagrams = function(s, p) {\n};\n",
  "python": "class Solution:\n    def findAnagrams(self, s: str, p: str) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findAnagrams(std::string s, std::string p) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findAnagrams(String s, String p) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findAnagrams",
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
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "cbaebabacd",
        "abc"
      ],
      "expected": [
        0,
        6
      ]
    },
    {
      "args": [
        "abab",
        "ab"
      ],
      "expected": [
        0,
        1,
        2
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
      "aa",
      "aa"
    ],
    "expected": [
      0
    ]
  },
  {
    "args": [
      "abc",
      "cba"
    ],
    "expected": [
      0
    ]
  },
  {
    "args": [
      "xyz",
      "abc"
    ],
    "expected": []
  },
  {
    "args": [
      "baa",
      "aa"
    ],
    "expected": [
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1386,
    '长度最小的子数组',
    '给定正整数数组 nums 和正整数 target，返回和大于等于 target 的最短连续子数组长度。
不存在这样的子数组返回 0。',
    'medium',
    1000,
    256,
    ARRAY['数组', '滑动窗口'],
    $json$[
  {
    "input": "target = 7, nums = [2, 3, 1, 2, 4, 3]",
    "output": "2"
  },
  {
    "input": "target = 4, nums = [1, 4, 4]",
    "output": "1"
  },
  {
    "input": "target = 11, nums = [1, 1, 1, 1, 1, 1, 1, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "target = 7, nums = [2, 3, 1, 2, 4, 3]",
    "output": "2"
  },
  {
    "input": "target = 4, nums = [1, 4, 4]",
    "output": "1"
  },
  {
    "input": "target = 11, nums = [1, 1, 1, 1, 1, 1, 1, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minSubArrayLen = function(target, nums) {\n};\n",
  "python": "class Solution:\n    def minSubArrayLen(self, target: int, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minSubArrayLen(int target, std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minSubArrayLen(int target, int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minSubArrayLen",
  "params": [
    {
      "name": "target",
      "type": "int"
    },
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
        7,
        [
          2,
          3,
          1,
          2,
          4,
          3
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        4,
        [
          1,
          4,
          4
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        11,
        [
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
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      [
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      3,
      [
        1,
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      5,
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
      100,
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
    1387,
    '最大连续 1 的个数 III',
    '给定二进制数组 nums 和整数 k，最多可以将 k 个 0 翻转为 1。
返回最长的全 1 子数组长度。',
    'medium',
    1000,
    256,
    ARRAY['数组', '滑动窗口'],
    $json$[
  {
    "input": "nums = [1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0], k = 2",
    "output": "6"
  },
  {
    "input": "nums = [0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1], k = 3",
    "output": "10"
  },
  {
    "input": "nums = [1, 1, 1], k = 0",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0], k = 2",
    "output": "6"
  },
  {
    "input": "nums = [0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1], k = 3",
    "output": "10"
  },
  {
    "input": "nums = [1, 1, 1], k = 0",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestOnes = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def longestOnes(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestOnes(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestOnes(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestOnes",
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
          1,
          1,
          1,
          0,
          0,
          0,
          1,
          1,
          1,
          1,
          0
        ],
        2
      ],
      "expected": 6
    },
    {
      "args": [
        [
          0,
          0,
          1,
          1,
          0,
          0,
          1,
          1,
          1,
          0,
          1,
          1,
          0,
          0,
          0,
          1,
          1,
          1,
          1
        ],
        3
      ],
      "expected": 10
    },
    {
      "args": [
        [
          1,
          1,
          1
        ],
        0
      ],
      "expected": 3
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
    "expected": 0
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
        0
      ],
      1
    ],
    "expected": 1
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
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1388,
    '替换后的最长重复字符',
    '给定字符串 s 和整数 k，最多可以将 k 个字符替换为任意字符。
返回替换后最长的相同字符连续子串长度。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '滑动窗口'],
    $json$[
  {
    "input": "s = \"ABAB\", k = 2",
    "output": "4"
  },
  {
    "input": "s = \"AABABBA\", k = 1",
    "output": "4"
  },
  {
    "input": "s = \"AAAA\", k = 0",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"ABAB\", k = 2",
    "output": "4"
  },
  {
    "input": "s = \"AABABBA\", k = 1",
    "output": "4"
  },
  {
    "input": "s = \"AAAA\", k = 0",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var characterReplacement = function(s, k) {\n};\n",
  "python": "class Solution:\n    def characterReplacement(self, s: str, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int characterReplacement(std::string s, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int characterReplacement(String s, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "characterReplacement",
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
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "ABAB",
        2
      ],
      "expected": 4
    },
    {
      "args": [
        "AABABBA",
        1
      ],
      "expected": 4
    },
    {
      "args": [
        "AAAA",
        0
      ],
      "expected": 4
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "A",
      0
    ],
    "expected": 1
  },
  {
    "args": [
      "AB",
      1
    ],
    "expected": 2
  },
  {
    "args": [
      "ABC",
      2
    ],
    "expected": 3
  },
  {
    "args": [
      "AABBB",
      0
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1389,
    '水果成篮',
    '给定水果类型数组 fruits，最多携带两种水果。
返回能摘到的最多水果数量（即最长只含两种元素的连续子数组长度）。',
    'medium',
    1000,
    256,
    ARRAY['数组', '滑动窗口'],
    $json$[
  {
    "input": "fruits = [1, 2, 1]",
    "output": "3"
  },
  {
    "input": "fruits = [0, 1, 2, 2]",
    "output": "3"
  },
  {
    "input": "fruits = [1, 2, 3, 2, 2]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "fruits = [1, 2, 1]",
    "output": "3"
  },
  {
    "input": "fruits = [0, 1, 2, 2]",
    "output": "3"
  },
  {
    "input": "fruits = [1, 2, 3, 2, 2]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var totalFruit = function(fruits) {\n};\n",
  "python": "class Solution:\n    def totalFruit(self, fruits: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int totalFruit(std::vector<int>& fruits) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int totalFruit(int[] fruits) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "totalFruit",
  "params": [
    {
      "name": "fruits",
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
          2,
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
        1,
        2,
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
        3,
        3,
        3,
        1,
        2,
        1,
        1,
        2,
        3,
        3,
        4
      ]
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1390,
    '和为 K 的子数组',
    '返回数组 nums 中和恰好为 k 的连续子数组个数。',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表', '前缀和'],
    $json$[
  {
    "input": "nums = [1, 1, 1], k = 2",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 3], k = 3",
    "output": "2"
  },
  {
    "input": "nums = [1, -1, 0], k = 0",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 1], k = 2",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 3], k = 3",
    "output": "2"
  },
  {
    "input": "nums = [1, -1, 0], k = 0",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var subarraySum = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def subarraySum(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int subarraySum(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int subarraySum(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "subarraySum",
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
          1,
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
          1,
          -1,
          0
        ],
        0
      ],
      "expected": 3
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
        1
      ],
      2
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
      0
    ],
    "expected": 6
  },
  {
    "args": [
      [
        -1,
        -1,
        1
      ],
      0
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1391,
    '区间列表的交集',
    '给定两个闭区间列表 firstList 和 secondList，二者各自按起点升序且互不重叠。
返回它们的交集区间，按起点升序排列。',
    'medium',
    1000,
    256,
    ARRAY['数组', '双指针', '区间'],
    $json$[
  {
    "input": "firstList = [[0, 2], [5, 10], [13, 23], [24, 25]], secondList = [[1, 5], [8, 12], [15, 24], [25, 26]]",
    "output": "[[1, 2], [5, 5], [8, 10], [15, 23], [24, 24], [25, 25]]"
  },
  {
    "input": "firstList = [[1, 3], [5, 9]], secondList = []",
    "output": "[]"
  },
  {
    "input": "firstList = [], secondList = [[4, 8], [10, 12]]",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "firstList = [[0, 2], [5, 10], [13, 23], [24, 25]], secondList = [[1, 5], [8, 12], [15, 24], [25, 26]]",
    "output": "[[1, 2], [5, 5], [8, 10], [15, 23], [24, 24], [25, 25]]"
  },
  {
    "input": "firstList = [[1, 3], [5, 9]], secondList = []",
    "output": "[]"
  },
  {
    "input": "firstList = [], secondList = [[4, 8], [10, 12]]",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var intervalIntersection = function(firstList, secondList) {\n};\n",
  "python": "class Solution:\n    def intervalIntersection(self, firstList: list[list[int]], secondList: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> intervalIntersection(std::vector<std::vector<int>>& firstList, std::vector<std::vector<int>>& secondList) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] intervalIntersection(int[][] firstList, int[][] secondList) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "intervalIntersection",
  "params": [
    {
      "name": "firstList",
      "type": "int[][]"
    },
    {
      "name": "secondList",
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
            0,
            2
          ],
          [
            5,
            10
          ],
          [
            13,
            23
          ],
          [
            24,
            25
          ]
        ],
        [
          [
            1,
            5
          ],
          [
            8,
            12
          ],
          [
            15,
            24
          ],
          [
            25,
            26
          ]
        ]
      ],
      "expected": [
        [
          1,
          2
        ],
        [
          5,
          5
        ],
        [
          8,
          10
        ],
        [
          15,
          23
        ],
        [
          24,
          24
        ],
        [
          25,
          25
        ]
      ]
    },
    {
      "args": [
        [
          [
            1,
            3
          ],
          [
            5,
            9
          ]
        ],
        []
      ],
      "expected": []
    },
    {
      "args": [
        [],
        [
          [
            4,
            8
          ],
          [
            10,
            12
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
      [
        [
          1,
          2
        ]
      ],
      [
        [
          2,
          3
        ]
      ]
    ],
    "expected": [
      [
        2,
        2
      ]
    ]
  },
  {
    "args": [
      [
        [
          1,
          5
        ]
      ],
      [
        [
          2,
          3
        ]
      ]
    ],
    "expected": [
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
          1,
          2
        ]
      ],
      [
        [
          3,
          4
        ]
      ]
    ],
    "expected": []
  }
]$json$::jsonb,
    'approved'
),
(
    1392,
    '寻找旋转排序数组中的最小值 II',
    '给定一个升序数组经过若干次旋转后的结果 nums，数组中可能包含重复元素。
返回数组中的最小元素。',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "nums = [1, 3, 5]",
    "output": "1"
  },
  {
    "input": "nums = [2, 2, 2, 0, 1]",
    "output": "0"
  },
  {
    "input": "nums = [3, 1, 3]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3, 5]",
    "output": "1"
  },
  {
    "input": "nums = [2, 2, 2, 0, 1]",
    "output": "0"
  },
  {
    "input": "nums = [3, 1, 3]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findMin = function(nums) {\n};\n",
  "python": "class Solution:\n    def findMin(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findMin(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findMin(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findMin",
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
          5
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
          0,
          1
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          3,
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
        3
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1393,
    '搜索旋转排序数组 II',
    '给定可能存在重复元素的旋转排序数组 nums 和目标值 target，判断 target 是否在数组中。',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "nums = [2, 5, 6, 0, 0, 1, 2], target = 0",
    "output": "true"
  },
  {
    "input": "nums = [2, 5, 6, 0, 0, 1, 2], target = 3",
    "output": "false"
  },
  {
    "input": "nums = [1, 0, 1, 1, 1], target = 0",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 5, 6, 0, 0, 1, 2], target = 0",
    "output": "true"
  },
  {
    "input": "nums = [2, 5, 6, 0, 0, 1, 2], target = 3",
    "output": "false"
  },
  {
    "input": "nums = [1, 0, 1, 1, 1], target = 0",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var search = function(nums, target) {\n};\n",
  "python": "class Solution:\n    def search(self, nums: list[int], target: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool search(std::vector<int>& nums, int target) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean search(int[] nums, int target) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "search",
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
  "return_type": "bool",
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
          0,
          0,
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
          2,
          5,
          6,
          0,
          0,
          1,
          2
        ],
        3
      ],
      "expected": false
    },
    {
      "args": [
        [
          1,
          0,
          1,
          1,
          1
        ],
        0
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
        1
      ],
      1
    ],
    "expected": true
  },
  {
    "args": [
      [
        3,
        1,
        3
      ],
      3
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1394,
    '找到 K 个最接近的元素',
    '给定升序数组 arr、整数 k 和 x，返回最接近 x 的 k 个元素，按升序排列。
若距离相同，优先选择较小的元素。',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找', '排序'],
    $json$[
  {
    "input": "arr = [1, 2, 3, 4, 5], k = 4, x = 3",
    "output": "[1, 2, 3, 4]"
  },
  {
    "input": "arr = [1, 2, 3, 4, 5], k = 4, x = -1",
    "output": "[1, 2, 3, 4]"
  },
  {
    "input": "arr = [1, 2, 3, 4, 5], k = 4, x = 6",
    "output": "[2, 3, 4, 5]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [1, 2, 3, 4, 5], k = 4, x = 3",
    "output": "[1, 2, 3, 4]"
  },
  {
    "input": "arr = [1, 2, 3, 4, 5], k = 4, x = -1",
    "output": "[1, 2, 3, 4]"
  },
  {
    "input": "arr = [1, 2, 3, 4, 5], k = 4, x = 6",
    "output": "[2, 3, 4, 5]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findClosestElements = function(arr, k, x) {\n};\n",
  "python": "class Solution:\n    def findClosestElements(self, arr: list[int], k: int, x: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findClosestElements(std::vector<int>& arr, int k, int x) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findClosestElements(int[] arr, int k, int x) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findClosestElements",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
    },
    {
      "name": "k",
      "type": "int"
    },
    {
      "name": "x",
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
          3,
          4,
          5
        ],
        4,
        3
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
          3,
          4,
          5
        ],
        4,
        -1
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
          3,
          4,
          5
        ],
        4,
        6
      ],
      "expected": [
        2,
        3,
        4,
        5
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
      1,
      5
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
      1,
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
        2,
        3
      ],
      2,
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
        1,
        5,
        9
      ],
      2,
      6
    ],
    "expected": [
      5,
      9
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1395,
    '有序矩阵中第 K 小的元素',
    '给定 n x n 矩阵 matrix，每行每列均按升序排列。
返回矩阵中第 k 小的元素（重复元素分别计数）。',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '二分查找', '堆'],
    $json$[
  {
    "input": "matrix = [[1, 5, 9], [10, 11, 13], [12, 13, 15]], k = 8",
    "output": "13"
  },
  {
    "input": "matrix = [[-5]], k = 1",
    "output": "-5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 5, 9], [10, 11, 13], [12, 13, 15]], k = 8",
    "output": "13"
  },
  {
    "input": "matrix = [[-5]], k = 1",
    "output": "-5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var kthSmallest = function(matrix, k) {\n};\n",
  "python": "class Solution:\n    def kthSmallest(self, matrix: list[list[int]], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int kthSmallest(std::vector<std::vector<int>>& matrix, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int kthSmallest(int[][] matrix, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kthSmallest",
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
            5,
            9
          ],
          [
            10,
            11,
            13
          ],
          [
            12,
            13,
            15
          ]
        ],
        8
      ],
      "expected": 13
    },
    {
      "args": [
        [
          [
            -5
          ]
        ],
        1
      ],
      "expected": -5
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
      2
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
      ],
      4
    ],
    "expected": 1
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
          6,
          7,
          12
        ],
        [
          11,
          14,
          14
        ]
      ],
      6
    ],
    "expected": 11
  }
]$json$::jsonb,
    'approved'
),
(
    1396,
    '爱吃香蕉的珂珂',
    '有 piles 堆香蕉。珂珂每小时选择一堆，以速度 k 吃香蕉；若该堆不足 k 根则吃完并停止这一小时。
返回在 h 小时内吃完所有香蕉的最小速度 k。',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "piles = [3, 6, 7, 11], h = 8",
    "output": "4"
  },
  {
    "input": "piles = [30, 11, 23, 4, 20], h = 5",
    "output": "30"
  },
  {
    "input": "piles = [30, 11, 23, 4, 20], h = 6",
    "output": "23"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "piles = [3, 6, 7, 11], h = 8",
    "output": "4"
  },
  {
    "input": "piles = [30, 11, 23, 4, 20], h = 5",
    "output": "30"
  },
  {
    "input": "piles = [30, 11, 23, 4, 20], h = 6",
    "output": "23"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minEatingSpeed = function(piles, h) {\n};\n",
  "python": "class Solution:\n    def minEatingSpeed(self, piles: list[int], h: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minEatingSpeed(std::vector<int>& piles, int h) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minEatingSpeed(int[] piles, int h) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minEatingSpeed",
  "params": [
    {
      "name": "piles",
      "type": "int[]"
    },
    {
      "name": "h",
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
          6,
          7,
          11
        ],
        8
      ],
      "expected": 4
    },
    {
      "args": [
        [
          30,
          11,
          23,
          4,
          20
        ],
        5
      ],
      "expected": 30
    },
    {
      "args": [
        [
          30,
          11,
          23,
          4,
          20
        ],
        6
      ],
      "expected": 23
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
        1
      ],
      2
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1000000000
      ],
      2
    ],
    "expected": 500000000
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
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1397,
    '乘法表中第 K 小的数',
    'm x n 乘法表的第 i 行第 j 列元素为 i * j（从 1 开始）。
返回表中第 k 小的数（重复元素分别计数）。',
    'medium',
    1000,
    256,
    ARRAY['数学', '二分查找'],
    $json$[
  {
    "input": "m = 3, n = 3, k = 5",
    "output": "3"
  },
  {
    "input": "m = 2, n = 3, k = 6",
    "output": "6"
  },
  {
    "input": "m = 1, n = 1, k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "m = 3, n = 3, k = 5",
    "output": "3"
  },
  {
    "input": "m = 2, n = 3, k = 6",
    "output": "6"
  },
  {
    "input": "m = 1, n = 1, k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findKthNumber = function(m, n, k) {\n};\n",
  "python": "class Solution:\n    def findKthNumber(self, m: int, n: int, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findKthNumber(int m, int n, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findKthNumber(int m, int n, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findKthNumber",
  "params": [
    {
      "name": "m",
      "type": "int"
    },
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
        3,
        5
      ],
      "expected": 3
    },
    {
      "args": [
        2,
        3,
        6
      ],
      "expected": 6
    },
    {
      "args": [
        1,
        1,
        1
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      2,
      2
    ],
    "expected": 2
  },
  {
    "args": [
      2,
      2,
      4
    ],
    "expected": 4
  },
  {
    "args": [
      10,
      10,
      50
    ],
    "expected": 24
  }
]$json$::jsonb,
    'approved'
),
(
    1398,
    '回文子串',
    '返回字符串 s 中回文子串的个数。不同起止位置的回文子串分别计数。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '动态规划', '中心扩展'],
    $json$[
  {
    "input": "s = \"abc\"",
    "output": "3"
  },
  {
    "input": "s = \"aaa\"",
    "output": "6"
  },
  {
    "input": "s = \"abba\"",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abc\"",
    "output": "3"
  },
  {
    "input": "s = \"aaa\"",
    "output": "6"
  },
  {
    "input": "s = \"abba\"",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countSubstrings = function(s) {\n};\n",
  "python": "class Solution:\n    def countSubstrings(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countSubstrings(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countSubstrings(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countSubstrings",
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
        "abc"
      ],
      "expected": 3
    },
    {
      "args": [
        "aaa"
      ],
      "expected": 6
    },
    {
      "args": [
        "abba"
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
      "aa"
    ],
    "expected": 3
  },
  {
    "args": [
      "aba"
    ],
    "expected": 4
  },
  {
    "args": [
      "abcd"
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1399,
    '01 矩阵',
    '给定只含 0 和 1 的矩阵 mat，返回每个元素到最近的 0 的距离。
相邻元素按上下左右四个方向计算。',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '广度优先搜索'],
    $json$[
  {
    "input": "mat = [[0, 0, 0], [0, 1, 0], [0, 0, 0]]",
    "output": "[[0, 0, 0], [0, 1, 0], [0, 0, 0]]"
  },
  {
    "input": "mat = [[0, 0, 0], [0, 1, 0], [1, 1, 1]]",
    "output": "[[0, 0, 0], [0, 1, 0], [1, 2, 1]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mat = [[0, 0, 0], [0, 1, 0], [0, 0, 0]]",
    "output": "[[0, 0, 0], [0, 1, 0], [0, 0, 0]]"
  },
  {
    "input": "mat = [[0, 0, 0], [0, 1, 0], [1, 1, 1]]",
    "output": "[[0, 0, 0], [0, 1, 0], [1, 2, 1]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var updateMatrix = function(mat) {\n};\n",
  "python": "class Solution:\n    def updateMatrix(self, mat: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> updateMatrix(std::vector<std::vector<int>>& mat) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] updateMatrix(int[][] mat) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "updateMatrix",
  "params": [
    {
      "name": "mat",
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
      "expected": [
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
          1,
          0
        ],
        [
          1,
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
        [
          0
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
    "expected": [
      [
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
          1
        ],
        [
          1,
          0
        ]
      ]
    ],
    "expected": [
      [
        2,
        1
      ],
      [
        1,
        0
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1400,
    '图像渲染',
    '给定图像 image、起始像素 (sr, sc) 和新颜色 color，
将与起始像素颜色相同且四连通的区域全部染成新颜色。返回处理后的图像。',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '广度优先搜索'],
    $json$[
  {
    "input": "image = [[1, 1, 1], [1, 1, 0], [1, 0, 1]], sr = 1, sc = 1, color = 2",
    "output": "[[2, 2, 2], [2, 2, 0], [2, 0, 1]]"
  },
  {
    "input": "image = [[0, 0, 0], [0, 0, 0]], sr = 0, sc = 0, color = 0",
    "output": "[[0, 0, 0], [0, 0, 0]]"
  },
  {
    "input": "image = [[0, 0, 0], [0, 1, 1]], sr = 1, sc = 1, color = 1",
    "output": "[[0, 0, 0], [0, 1, 1]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "image = [[1, 1, 1], [1, 1, 0], [1, 0, 1]], sr = 1, sc = 1, color = 2",
    "output": "[[2, 2, 2], [2, 2, 0], [2, 0, 1]]"
  },
  {
    "input": "image = [[0, 0, 0], [0, 0, 0]], sr = 0, sc = 0, color = 0",
    "output": "[[0, 0, 0], [0, 0, 0]]"
  },
  {
    "input": "image = [[0, 0, 0], [0, 1, 1]], sr = 1, sc = 1, color = 1",
    "output": "[[0, 0, 0], [0, 1, 1]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var floodFill = function(image, sr, sc, color) {\n};\n",
  "python": "class Solution:\n    def floodFill(self, image: list[list[int]], sr: int, sc: int, color: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> floodFill(std::vector<std::vector<int>>& image, int sr, int sc, int color) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] floodFill(int[][] image, int sr, int sc, int color) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "floodFill",
  "params": [
    {
      "name": "image",
      "type": "int[][]"
    },
    {
      "name": "sr",
      "type": "int"
    },
    {
      "name": "sc",
      "type": "int"
    },
    {
      "name": "color",
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
            1,
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
            1
          ]
        ],
        1,
        1,
        2
      ],
      "expected": [
        [
          2,
          2,
          2
        ],
        [
          2,
          2,
          0
        ],
        [
          2,
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
            0
          ],
          [
            0,
            0,
            0
          ]
        ],
        0,
        0,
        0
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
        ]
      ]
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
            1
          ]
        ],
        1,
        1,
        1
      ],
      "expected": [
        [
          0,
          0,
          0
        ],
        [
          0,
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
        [
          1
        ]
      ],
      0,
      0,
      2
    ],
    "expected": [
      [
        2
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
      ],
      0,
      0,
      2
    ],
    "expected": [
      [
        2,
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
      1,
      5
    ],
    "expected": [
      [
        1,
        2
      ],
      [
        3,
        5
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1401,
    '统计封闭岛屿的数目',
    '0 表示陆地，1 表示水。封闭岛屿是完全被水包围、且不接触网格边界的陆地连通块。
返回封闭岛屿的数目。',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '深度优先搜索'],
    $json$[
  {
    "input": "grid = [[1, 1, 1], [1, 0, 1], [1, 1, 1]]",
    "output": "1"
  },
  {
    "input": "grid = [[0, 0, 0], [0, 1, 0], [0, 0, 0]]",
    "output": "0"
  },
  {
    "input": "grid = [[1, 0, 1], [0, 1, 0], [1, 0, 1]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[1, 1, 1], [1, 0, 1], [1, 1, 1]]",
    "output": "1"
  },
  {
    "input": "grid = [[0, 0, 0], [0, 1, 0], [0, 0, 0]]",
    "output": "0"
  },
  {
    "input": "grid = [[1, 0, 1], [0, 1, 0], [1, 0, 1]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var closedIsland = function(grid) {\n};\n",
  "python": "class Solution:\n    def closedIsland(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int closedIsland(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int closedIsland(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "closedIsland",
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
      "expected": 1
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
            0,
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
            1
          ],
          [
            0,
            1,
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
          0,
          1
        ],
        [
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
    1402,
    '飞地的数量',
    '1 表示陆地，0 表示水。飞地指不能通过四连通陆地到达网格边界的陆地格。
返回飞地的数量。',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '深度优先搜索'],
    $json$[
  {
    "input": "grid = [[0, 0, 0, 0], [1, 0, 1, 0], [0, 1, 1, 0], [0, 0, 0, 0]]",
    "output": "3"
  },
  {
    "input": "grid = [[0, 1, 1, 0], [0, 0, 1, 0], [0, 0, 1, 0], [0, 0, 0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[0, 0, 0, 0], [1, 0, 1, 0], [0, 1, 1, 0], [0, 0, 0, 0]]",
    "output": "3"
  },
  {
    "input": "grid = [[0, 1, 1, 0], [0, 0, 1, 0], [0, 0, 1, 0], [0, 0, 0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numEnclaves = function(grid) {\n};\n",
  "python": "class Solution:\n    def numEnclaves(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numEnclaves(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numEnclaves(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numEnclaves",
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
            0,
            0
          ],
          [
            1,
            0,
            1,
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
            1,
            1,
            0
          ],
          [
            0,
            0,
            1,
            0
          ],
          [
            0,
            0,
            1,
            0
          ],
          [
            0,
            0,
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
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1403,
    '地图分析',
    '网格中 0 表示海洋，1 表示陆地。返回每个海洋格到最近陆地的曼哈顿距离的最大值。
若网格中没有陆地或没有海洋，返回 -1。',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '广度优先搜索'],
    $json$[
  {
    "input": "grid = [[1, 0, 1], [0, 0, 0], [1, 0, 1]]",
    "output": "2"
  },
  {
    "input": "grid = [[1, 0, 0], [0, 0, 0], [0, 0, 0]]",
    "output": "4"
  },
  {
    "input": "grid = [[0, 0], [0, 0]]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[1, 0, 1], [0, 0, 0], [1, 0, 1]]",
    "output": "2"
  },
  {
    "input": "grid = [[1, 0, 0], [0, 0, 0], [0, 0, 0]]",
    "output": "4"
  },
  {
    "input": "grid = [[0, 0], [0, 0]]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxDistance = function(grid) {\n};\n",
  "python": "class Solution:\n    def maxDistance(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxDistance(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxDistance(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxDistance",
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
      "expected": 2
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
            0,
            0
          ],
          [
            0,
            0
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
          0
        ]
      ]
    ],
    "expected": -1
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
    "expected": -1
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
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1404,
    '打开转盘锁',
    '转盘有 4 位数字，每次可将一位加 1 或减 1（9 加 1 变 0，0 减 1 变 9）。
从 "0000" 出发，避开 deadends，返回打开 target 的最少步数；无法打开返回 -1。',
    'medium',
    1000,
    256,
    ARRAY['广度优先搜索', '字符串'],
    $json$[
  {
    "input": "deadends = [\"0201\", \"0101\", \"0102\", \"1212\", \"2002\"], target = \"0202\"",
    "output": "6"
  },
  {
    "input": "deadends = [\"8888\"], target = \"0009\"",
    "output": "1"
  },
  {
    "input": "deadends = [\"8887\", \"8889\", \"8878\", \"8898\", \"8788\", \"8988\", \"7888\", \"9888\"], target = \"8888\"",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "deadends = [\"0201\", \"0101\", \"0102\", \"1212\", \"2002\"], target = \"0202\"",
    "output": "6"
  },
  {
    "input": "deadends = [\"8888\"], target = \"0009\"",
    "output": "1"
  },
  {
    "input": "deadends = [\"8887\", \"8889\", \"8878\", \"8898\", \"8788\", \"8988\", \"7888\", \"9888\"], target = \"8888\"",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var openLock = function(deadends, target) {\n};\n",
  "python": "class Solution:\n    def openLock(self, deadends: list[str], target: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int openLock(std::vector<std::string>& deadends, std::string target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int openLock(String[] deadends, String target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "openLock",
  "params": [
    {
      "name": "deadends",
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
          "0201",
          "0101",
          "0102",
          "1212",
          "2002"
        ],
        "0202"
      ],
      "expected": 6
    },
    {
      "args": [
        [
          "8888"
        ],
        "0009"
      ],
      "expected": 1
    },
    {
      "args": [
        [
          "8887",
          "8889",
          "8878",
          "8898",
          "8788",
          "8988",
          "7888",
          "9888"
        ],
        "8888"
      ],
      "expected": -1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [],
      "0000"
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "0000"
      ],
      "8888"
    ],
    "expected": -1
  },
  {
    "args": [
      [
        "1111"
      ],
      "2222"
    ],
    "expected": 8
  },
  {
    "args": [
      [
        "9999"
      ],
      "0001"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1405,
    '01 背包',
    '给定 n 件物品的重量 weights、价值 values 和背包容量 capacity。
每件物品最多选择一次，返回能获得的最大价值。',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '背包'],
    $json$[
  {
    "input": "weights = [1, 3, 4], values = [15, 20, 30], capacity = 4",
    "output": "35"
  },
  {
    "input": "weights = [2, 2, 3], values = [3, 4, 5], capacity = 5",
    "output": "9"
  },
  {
    "input": "weights = [1], values = [1], capacity = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "weights = [1, 3, 4], values = [15, 20, 30], capacity = 4",
    "output": "35"
  },
  {
    "input": "weights = [2, 2, 3], values = [3, 4, 5], capacity = 5",
    "output": "9"
  },
  {
    "input": "weights = [1], values = [1], capacity = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var knapsack01 = function(weights, values, capacity) {\n};\n",
  "python": "class Solution:\n    def knapsack01(self, weights: list[int], values: list[int], capacity: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int knapsack01(std::vector<int>& weights, std::vector<int>& values, int capacity) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int knapsack01(int[] weights, int[] values, int capacity) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "knapsack01",
  "params": [
    {
      "name": "weights",
      "type": "int[]"
    },
    {
      "name": "values",
      "type": "int[]"
    },
    {
      "name": "capacity",
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
          4
        ],
        [
          15,
          20,
          30
        ],
        4
      ],
      "expected": 35
    },
    {
      "args": [
        [
          2,
          2,
          3
        ],
        [
          3,
          4,
          5
        ],
        5
      ],
      "expected": 9
    },
    {
      "args": [
        [
          1
        ],
        [
          1
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
      [],
      10
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1
      ],
      [
        5
      ],
      1
    ],
    "expected": 5
  },
  {
    "args": [
      [
        5
      ],
      [
        10
      ],
      4
    ],
    "expected": 0
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
        5
      ],
      6
    ],
    "expected": 8
  }
]$json$::jsonb,
    'approved'
),
(
    1406,
    '完全背包',
    '给定物品重量 weights、价值 values 和背包容量 capacity。
每种物品可以选择任意多次，返回容量内能获得的最大价值。',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '背包'],
    $json$[
  {
    "input": "weights = [1, 3, 4], values = [15, 20, 30], capacity = 4",
    "output": "60"
  },
  {
    "input": "weights = [2, 3], values = [3, 5], capacity = 7",
    "output": "11"
  },
  {
    "input": "weights = [1], values = [2], capacity = 5",
    "output": "10"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "weights = [1, 3, 4], values = [15, 20, 30], capacity = 4",
    "output": "60"
  },
  {
    "input": "weights = [2, 3], values = [3, 5], capacity = 7",
    "output": "11"
  },
  {
    "input": "weights = [1], values = [2], capacity = 5",
    "output": "10"
  }
]$json$::jsonb,
    $json${
  "javascript": "var completeKnapsack = function(weights, values, capacity) {\n};\n",
  "python": "class Solution:\n    def completeKnapsack(self, weights: list[int], values: list[int], capacity: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int completeKnapsack(std::vector<int>& weights, std::vector<int>& values, int capacity) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int completeKnapsack(int[] weights, int[] values, int capacity) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "completeKnapsack",
  "params": [
    {
      "name": "weights",
      "type": "int[]"
    },
    {
      "name": "values",
      "type": "int[]"
    },
    {
      "name": "capacity",
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
          4
        ],
        [
          15,
          20,
          30
        ],
        4
      ],
      "expected": 60
    },
    {
      "args": [
        [
          2,
          3
        ],
        [
          3,
          5
        ],
        7
      ],
      "expected": 11
    },
    {
      "args": [
        [
          1
        ],
        [
          2
        ],
        5
      ],
      "expected": 10
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [],
      [],
      10
    ],
    "expected": 0
  },
  {
    "args": [
      [
        5
      ],
      [
        10
      ],
      4
    ],
    "expected": 0
  },
  {
    "args": [
      [
        2
      ],
      [
        3
      ],
      7
    ],
    "expected": 9
  },
  {
    "args": [
      [
        3,
        4
      ],
      [
        5,
        6
      ],
      10
    ],
    "expected": 16
  }
]$json$::jsonb,
    'approved'
),
(
    1407,
    '目标和',
    '给定整数数组 nums 和整数 target。给每个 nums[i] 前添加 ''+'' 或 ''-''，
返回使表达式结果等于 target 的方案数。',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '回溯'],
    $json$[
  {
    "input": "nums = [1, 1, 1, 1, 1], target = 3",
    "output": "5"
  },
  {
    "input": "nums = [1], target = 1",
    "output": "1"
  },
  {
    "input": "nums = [1, 0], target = 1",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 1, 1, 1], target = 3",
    "output": "5"
  },
  {
    "input": "nums = [1], target = 1",
    "output": "1"
  },
  {
    "input": "nums = [1, 0], target = 1",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findTargetSumWays = function(nums, target) {\n};\n",
  "python": "class Solution:\n    def findTargetSumWays(self, nums: list[int], target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findTargetSumWays(std::vector<int>& nums, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findTargetSumWays(int[] nums, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findTargetSumWays",
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
          1,
          1,
          1,
          1
        ],
        3
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
      "expected": 1
    },
    {
      "args": [
        [
          1,
          0
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
        0
      ],
      0
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        1
      ],
      0
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
      0
    ],
    "expected": 2
  },
  {
    "args": [
      [
        2,
        2
      ],
      0
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1408,
    '一和零',
    '给定二进制字符串数组 strs 和整数 m、n。
返回最多包含 m 个 0 和 n 个 1 的最大子集大小。',
    'medium',
    1000,
    256,
    ARRAY['数组', '字符串', '动态规划'],
    $json$[
  {
    "input": "strs = [\"10\", \"0001\", \"111001\", \"1\", \"0\"], m = 5, n = 3",
    "output": "4"
  },
  {
    "input": "strs = [\"10\", \"0\", \"1\"], m = 1, n = 1",
    "output": "2"
  },
  {
    "input": "strs = [\"0\"], m = 1, n = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "strs = [\"10\", \"0001\", \"111001\", \"1\", \"0\"], m = 5, n = 3",
    "output": "4"
  },
  {
    "input": "strs = [\"10\", \"0\", \"1\"], m = 1, n = 1",
    "output": "2"
  },
  {
    "input": "strs = [\"0\"], m = 1, n = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findMaxForm = function(strs, m, n) {\n};\n",
  "python": "class Solution:\n    def findMaxForm(self, strs: list[str], m: int, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findMaxForm(std::vector<std::string>& strs, int m, int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findMaxForm(String[] strs, int m, int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findMaxForm",
  "params": [
    {
      "name": "strs",
      "type": "string[]"
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
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          "10",
          "0001",
          "111001",
          "1",
          "0"
        ],
        5,
        3
      ],
      "expected": 4
    },
    {
      "args": [
        [
          "10",
          "0",
          "1"
        ],
        1,
        1
      ],
      "expected": 2
    },
    {
      "args": [
        [
          "0"
        ],
        1,
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
      0,
      0
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "0"
      ],
      1,
      0
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "1"
      ],
      0,
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "00",
        "11"
      ],
      2,
      2
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1409,
    '最后一块石头的重量 II',
    '将石头分成两堆，返回两堆重量差的最小值。',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "stones = [2, 7, 4, 1, 8, 1]",
    "output": "1"
  },
  {
    "input": "stones = [31, 26, 33, 21, 40]",
    "output": "5"
  },
  {
    "input": "stones = [1, 2]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "stones = [2, 7, 4, 1, 8, 1]",
    "output": "1"
  },
  {
    "input": "stones = [31, 26, 33, 21, 40]",
    "output": "5"
  },
  {
    "input": "stones = [1, 2]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var lastStoneWeightII = function(stones) {\n};\n",
  "python": "class Solution:\n    def lastStoneWeightII(self, stones: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int lastStoneWeightII(std::vector<int>& stones) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int lastStoneWeightII(int[] stones) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "lastStoneWeightII",
  "params": [
    {
      "name": "stones",
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
          4,
          1,
          8,
          1
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          31,
          26,
          33,
          21,
          40
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        [
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
  }
]$json$::jsonb,
    'approved'
),
(
    1410,
    '整数拆分',
    '将正整数 n 拆分成至少两个正整数之和，返回这些整数乘积的最大值。
给定 2 <= n <= 58。',
    'medium',
    1000,
    256,
    ARRAY['数学', '动态规划'],
    $json$[
  {
    "input": "n = 2",
    "output": "1"
  },
  {
    "input": "n = 10",
    "output": "36"
  },
  {
    "input": "n = 3",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 2",
    "output": "1"
  },
  {
    "input": "n = 10",
    "output": "36"
  },
  {
    "input": "n = 3",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var integerBreak = function(n) {\n};\n",
  "python": "class Solution:\n    def integerBreak(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int integerBreak(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int integerBreak(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "integerBreak",
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
        10
      ],
      "expected": 36
    },
    {
      "args": [
        3
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      4
    ],
    "expected": 4
  },
  {
    "args": [
      5
    ],
    "expected": 6
  },
  {
    "args": [
      8
    ],
    "expected": 18
  },
  {
    "args": [
      58
    ],
    "expected": 1549681956
  }
]$json$::jsonb,
    'approved'
),
(
    1411,
    '不同的二叉搜索树',
    '给定整数 n，返回由节点值 1 到 n 构成的结构不同的二叉搜索树数量。',
    'medium',
    1000,
    256,
    ARRAY['数学', '动态规划', '树'],
    $json$[
  {
    "input": "n = 3",
    "output": "5"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 19",
    "output": "1767263190"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3",
    "output": "5"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 19",
    "output": "1767263190"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numTrees = function(n) {\n};\n",
  "python": "class Solution:\n    def numTrees(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numTrees(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numTrees(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numTrees",
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
      "expected": 5
    },
    {
      "args": [
        1
      ],
      "expected": 1
    },
    {
      "args": [
        19
      ],
      "expected": 1767263190
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
      5
    ],
    "expected": 42
  },
  {
    "args": [
      10
    ],
    "expected": 16796
  }
]$json$::jsonb,
    'approved'
),
(
    1412,
    '丑数 II',
    '丑数是只含质因子 2、3、5 的正整数。1 是第一个丑数。
返回第 n 个丑数。',
    'medium',
    1000,
    256,
    ARRAY['数学', '动态规划', '堆'],
    $json$[
  {
    "input": "n = 10",
    "output": "12"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 20",
    "output": "36"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 10",
    "output": "12"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 20",
    "output": "36"
  }
]$json$::jsonb,
    $json${
  "javascript": "var nthUglyNumber = function(n) {\n};\n",
  "python": "class Solution:\n    def nthUglyNumber(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int nthUglyNumber(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int nthUglyNumber(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "nthUglyNumber",
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
      "expected": 12
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
      "expected": 36
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
      7
    ],
    "expected": 8
  },
  {
    "args": [
      1690
    ],
    "expected": 2123366400
  }
]$json$::jsonb,
    'approved'
),
(
    1413,
    '超级丑数',
    '超级丑数是所有质因子都在给定数组 primes 中的正整数。1 是第一个超级丑数。
返回第 n 个超级丑数。',
    'medium',
    1000,
    256,
    ARRAY['数学', '动态规划', '堆'],
    $json$[
  {
    "input": "n = 12, primes = [2, 7, 13, 19]",
    "output": "32"
  },
  {
    "input": "n = 1, primes = [2, 3, 5]",
    "output": "1"
  },
  {
    "input": "n = 5, primes = [2, 3, 5]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 12, primes = [2, 7, 13, 19]",
    "output": "32"
  },
  {
    "input": "n = 1, primes = [2, 3, 5]",
    "output": "1"
  },
  {
    "input": "n = 5, primes = [2, 3, 5]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var nthSuperUglyNumber = function(n, primes) {\n};\n",
  "python": "class Solution:\n    def nthSuperUglyNumber(self, n: int, primes: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int nthSuperUglyNumber(int n, std::vector<int>& primes) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int nthSuperUglyNumber(int n, int[] primes) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "nthSuperUglyNumber",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "primes",
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
        12,
        [
          2,
          7,
          13,
          19
        ]
      ],
      "expected": 32
    },
    {
      "args": [
        1,
        [
          2,
          3,
          5
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        5,
        [
          2,
          3,
          5
        ]
      ],
      "expected": 5
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2,
      [
        2
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      3,
      [
        2,
        3
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      10,
      [
        3,
        5,
        7
      ]
    ],
    "expected": 35
  }
]$json$::jsonb,
    'approved'
),
(
    1414,
    '分数到小数',
    '给定分子 numerator 和分母 denominator，返回小数字符串。
若小数部分循环，用括号括起循环部分。',
    'medium',
    1000,
    256,
    ARRAY['数学', '字符串', '哈希表'],
    $json$[
  {
    "input": "numerator = 1, denominator = 2",
    "output": "\"0.5\""
  },
  {
    "input": "numerator = 2, denominator = 1",
    "output": "\"2\""
  },
  {
    "input": "numerator = 4, denominator = 333",
    "output": "\"0.(012)\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "numerator = 1, denominator = 2",
    "output": "\"0.5\""
  },
  {
    "input": "numerator = 2, denominator = 1",
    "output": "\"2\""
  },
  {
    "input": "numerator = 4, denominator = 333",
    "output": "\"0.(012)\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var fractionToDecimal = function(numerator, denominator) {\n};\n",
  "python": "class Solution:\n    def fractionToDecimal(self, numerator: int, denominator: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string fractionToDecimal(int numerator, int denominator) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String fractionToDecimal(int numerator, int denominator) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "fractionToDecimal",
  "params": [
    {
      "name": "numerator",
      "type": "int"
    },
    {
      "name": "denominator",
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
        2
      ],
      "expected": "0.5"
    },
    {
      "args": [
        2,
        1
      ],
      "expected": "2"
    },
    {
      "args": [
        4,
        333
      ],
      "expected": "0.(012)"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      3
    ],
    "expected": "0.(3)"
  },
  {
    "args": [
      -1,
      2
    ],
    "expected": "-0.5"
  },
  {
    "args": [
      2,
      -3
    ],
    "expected": "-0.(6)"
  },
  {
    "args": [
      -50,
      8
    ],
    "expected": "-6.25"
  },
  {
    "args": [
      7,
      12
    ],
    "expected": "0.58(3)"
  }
]$json$::jsonb,
    'approved'
),
(
    1415,
    '两数相除',
    '不使用乘法、除法和取模，计算两个整数相除，结果向零截断。
若结果超出 32 位有符号整数范围，返回 2^31 - 1。',
    'medium',
    1000,
    256,
    ARRAY['数学', '位运算'],
    $json$[
  {
    "input": "dividend = 10, divisor = 3",
    "output": "3"
  },
  {
    "input": "dividend = 7, divisor = -3",
    "output": "-2"
  },
  {
    "input": "dividend = -2147483648, divisor = -1",
    "output": "2147483647"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "dividend = 10, divisor = 3",
    "output": "3"
  },
  {
    "input": "dividend = 7, divisor = -3",
    "output": "-2"
  },
  {
    "input": "dividend = -2147483648, divisor = -1",
    "output": "2147483647"
  }
]$json$::jsonb,
    $json${
  "javascript": "var divide = function(dividend, divisor) {\n};\n",
  "python": "class Solution:\n    def divide(self, dividend: int, divisor: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int divide(int dividend, int divisor) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int divide(int dividend, int divisor) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "divide",
  "params": [
    {
      "name": "dividend",
      "type": "int"
    },
    {
      "name": "divisor",
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
        10,
        3
      ],
      "expected": 3
    },
    {
      "args": [
        7,
        -3
      ],
      "expected": -2
    },
    {
      "args": [
        -2147483648,
        -1
      ],
      "expected": 2147483647
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
      -1,
      1
    ],
    "expected": -1
  },
  {
    "args": [
      0,
      5
    ],
    "expected": 0
  },
  {
    "args": [
      -2147483648,
      1
    ],
    "expected": -2147483648
  },
  {
    "args": [
      2147483647,
      2
    ],
    "expected": 1073741823
  }
]$json$::jsonb,
    'approved'
),
(
    1416,
    '有效的数独',
    '判断 9 x 9 数独棋盘是否有效：每行、每列、每个 3 x 3 宫内，
数字 1 到 9 不能重复。空格用 ''.'' 表示。',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '哈希表'],
    $json$[
  {
    "input": "board = [[\"5\", \"3\", \".\", \".\", \"7\", \".\", \".\", \".\", \".\"], [\"6\", \".\", \".\", \"1\", \"9\", \"5\", \".\", \".\", \".\"], [\".\", \"9\", \"8\", \".\", \".\", \".\", \".\", \"6\", \".\"], [\"8\", \".\", \".\", \".\", \"6\", \".\", \".\", \".\", \"3\"], [\"4\", \".\", \".\", \"8\", \".\", \"3\", \".\", \".\", \"1\"], [\"7\", \".\", \".\", \".\", \"2\", \".\", \".\", \".\", \"6\"], [\".\", \"6\", \".\", \".\", \".\", \".\", \"2\", \"8\", \".\"], [\".\", \".\", \".\", \"4\", \"1\", \"9\", \".\", \".\", \"5\"], [\".\", \".\", \".\", \".\", \"8\", \".\", \".\", \"7\", \"9\"]]",
    "output": "true"
  },
  {
    "input": "board = [[\"5\", \"3\", \"5\", \".\", \"7\", \".\", \".\", \".\", \".\"], [\"6\", \".\", \".\", \"1\", \"9\", \"5\", \".\", \".\", \".\"], [\".\", \"9\", \"8\", \".\", \".\", \".\", \".\", \"6\", \".\"], [\"8\", \".\", \".\", \".\", \"6\", \".\", \".\", \".\", \"3\"], [\"4\", \".\", \".\", \"8\", \".\", \"3\", \".\", \".\", \"1\"], [\"7\", \".\", \".\", \".\", \"2\", \".\", \".\", \".\", \"6\"], [\".\", \"6\", \".\", \".\", \".\", \".\", \"2\", \"8\", \".\"], [\".\", \".\", \".\", \"4\", \"1\", \"9\", \".\", \".\", \"5\"], [\".\", \".\", \".\", \".\", \"8\", \".\", \".\", \"7\", \"9\"]]",
    "output": "false"
  },
  {
    "input": "board = [[\"5\", \"3\", \".\", \".\", \"7\", \".\", \".\", \".\", \".\"], [\"6\", \".\", \".\", \"1\", \"9\", \"5\", \".\", \".\", \".\"], [\"6\", \"9\", \"8\", \".\", \".\", \".\", \".\", \"6\", \".\"], [\"8\", \".\", \".\", \".\", \"6\", \".\", \".\", \".\", \"3\"], [\"4\", \".\", \".\", \"8\", \".\", \"3\", \".\", \".\", \"1\"], [\"7\", \".\", \".\", \".\", \"2\", \".\", \".\", \".\", \"6\"], [\".\", \"6\", \".\", \".\", \".\", \".\", \"2\", \"8\", \".\"], [\".\", \".\", \".\", \"4\", \"1\", \"9\", \".\", \".\", \"5\"], [\".\", \".\", \".\", \".\", \"8\", \".\", \".\", \"7\", \"9\"]]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "board = [[\"5\", \"3\", \".\", \".\", \"7\", \".\", \".\", \".\", \".\"], [\"6\", \".\", \".\", \"1\", \"9\", \"5\", \".\", \".\", \".\"], [\".\", \"9\", \"8\", \".\", \".\", \".\", \".\", \"6\", \".\"], [\"8\", \".\", \".\", \".\", \"6\", \".\", \".\", \".\", \"3\"], [\"4\", \".\", \".\", \"8\", \".\", \"3\", \".\", \".\", \"1\"], [\"7\", \".\", \".\", \".\", \"2\", \".\", \".\", \".\", \"6\"], [\".\", \"6\", \".\", \".\", \".\", \".\", \"2\", \"8\", \".\"], [\".\", \".\", \".\", \"4\", \"1\", \"9\", \".\", \".\", \"5\"], [\".\", \".\", \".\", \".\", \"8\", \".\", \".\", \"7\", \"9\"]]",
    "output": "true"
  },
  {
    "input": "board = [[\"5\", \"3\", \"5\", \".\", \"7\", \".\", \".\", \".\", \".\"], [\"6\", \".\", \".\", \"1\", \"9\", \"5\", \".\", \".\", \".\"], [\".\", \"9\", \"8\", \".\", \".\", \".\", \".\", \"6\", \".\"], [\"8\", \".\", \".\", \".\", \"6\", \".\", \".\", \".\", \"3\"], [\"4\", \".\", \".\", \"8\", \".\", \"3\", \".\", \".\", \"1\"], [\"7\", \".\", \".\", \".\", \"2\", \".\", \".\", \".\", \"6\"], [\".\", \"6\", \".\", \".\", \".\", \".\", \"2\", \"8\", \".\"], [\".\", \".\", \".\", \"4\", \"1\", \"9\", \".\", \".\", \"5\"], [\".\", \".\", \".\", \".\", \"8\", \".\", \".\", \"7\", \"9\"]]",
    "output": "false"
  },
  {
    "input": "board = [[\"5\", \"3\", \".\", \".\", \"7\", \".\", \".\", \".\", \".\"], [\"6\", \".\", \".\", \"1\", \"9\", \"5\", \".\", \".\", \".\"], [\"6\", \"9\", \"8\", \".\", \".\", \".\", \".\", \"6\", \".\"], [\"8\", \".\", \".\", \".\", \"6\", \".\", \".\", \".\", \"3\"], [\"4\", \".\", \".\", \"8\", \".\", \"3\", \".\", \".\", \"1\"], [\"7\", \".\", \".\", \".\", \"2\", \".\", \".\", \".\", \"6\"], [\".\", \"6\", \".\", \".\", \".\", \".\", \"2\", \"8\", \".\"], [\".\", \".\", \".\", \"4\", \"1\", \"9\", \".\", \".\", \"5\"], [\".\", \".\", \".\", \".\", \"8\", \".\", \".\", \"7\", \"9\"]]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isValidSudoku = function(board) {\n};\n",
  "python": "class Solution:\n    def isValidSudoku(self, board: list[list[str]]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isValidSudoku(std::vector<std::vector<std::string>>& board) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isValidSudoku(String[][] board) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isValidSudoku",
  "params": [
    {
      "name": "board",
      "type": "string[][]"
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
            "5",
            "3",
            ".",
            ".",
            "7",
            ".",
            ".",
            ".",
            "."
          ],
          [
            "6",
            ".",
            ".",
            "1",
            "9",
            "5",
            ".",
            ".",
            "."
          ],
          [
            ".",
            "9",
            "8",
            ".",
            ".",
            ".",
            ".",
            "6",
            "."
          ],
          [
            "8",
            ".",
            ".",
            ".",
            "6",
            ".",
            ".",
            ".",
            "3"
          ],
          [
            "4",
            ".",
            ".",
            "8",
            ".",
            "3",
            ".",
            ".",
            "1"
          ],
          [
            "7",
            ".",
            ".",
            ".",
            "2",
            ".",
            ".",
            ".",
            "6"
          ],
          [
            ".",
            "6",
            ".",
            ".",
            ".",
            ".",
            "2",
            "8",
            "."
          ],
          [
            ".",
            ".",
            ".",
            "4",
            "1",
            "9",
            ".",
            ".",
            "5"
          ],
          [
            ".",
            ".",
            ".",
            ".",
            "8",
            ".",
            ".",
            "7",
            "9"
          ]
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          [
            "5",
            "3",
            "5",
            ".",
            "7",
            ".",
            ".",
            ".",
            "."
          ],
          [
            "6",
            ".",
            ".",
            "1",
            "9",
            "5",
            ".",
            ".",
            "."
          ],
          [
            ".",
            "9",
            "8",
            ".",
            ".",
            ".",
            ".",
            "6",
            "."
          ],
          [
            "8",
            ".",
            ".",
            ".",
            "6",
            ".",
            ".",
            ".",
            "3"
          ],
          [
            "4",
            ".",
            ".",
            "8",
            ".",
            "3",
            ".",
            ".",
            "1"
          ],
          [
            "7",
            ".",
            ".",
            ".",
            "2",
            ".",
            ".",
            ".",
            "6"
          ],
          [
            ".",
            "6",
            ".",
            ".",
            ".",
            ".",
            "2",
            "8",
            "."
          ],
          [
            ".",
            ".",
            ".",
            "4",
            "1",
            "9",
            ".",
            ".",
            "5"
          ],
          [
            ".",
            ".",
            ".",
            ".",
            "8",
            ".",
            ".",
            "7",
            "9"
          ]
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          [
            "5",
            "3",
            ".",
            ".",
            "7",
            ".",
            ".",
            ".",
            "."
          ],
          [
            "6",
            ".",
            ".",
            "1",
            "9",
            "5",
            ".",
            ".",
            "."
          ],
          [
            "6",
            "9",
            "8",
            ".",
            ".",
            ".",
            ".",
            "6",
            "."
          ],
          [
            "8",
            ".",
            ".",
            ".",
            "6",
            ".",
            ".",
            ".",
            "3"
          ],
          [
            "4",
            ".",
            ".",
            "8",
            ".",
            "3",
            ".",
            ".",
            "1"
          ],
          [
            "7",
            ".",
            ".",
            ".",
            "2",
            ".",
            ".",
            ".",
            "6"
          ],
          [
            ".",
            "6",
            ".",
            ".",
            ".",
            ".",
            "2",
            "8",
            "."
          ],
          [
            ".",
            ".",
            ".",
            "4",
            "1",
            "9",
            ".",
            ".",
            "5"
          ],
          [
            ".",
            ".",
            ".",
            ".",
            "8",
            ".",
            ".",
            "7",
            "9"
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
          "5",
          "3",
          ".",
          ".",
          "7",
          ".",
          ".",
          ".",
          "."
        ],
        [
          "6",
          ".",
          ".",
          "1",
          "9",
          "5",
          ".",
          ".",
          "."
        ],
        [
          ".",
          "9",
          "8",
          ".",
          ".",
          ".",
          ".",
          "6",
          "."
        ],
        [
          "8",
          ".",
          ".",
          ".",
          "6",
          ".",
          ".",
          ".",
          "3"
        ],
        [
          "4",
          ".",
          ".",
          "8",
          ".",
          "3",
          ".",
          ".",
          "1"
        ],
        [
          "7",
          ".",
          ".",
          ".",
          "2",
          ".",
          ".",
          ".",
          "6"
        ],
        [
          ".",
          "6",
          ".",
          ".",
          ".",
          ".",
          "2",
          "8",
          "."
        ],
        [
          ".",
          ".",
          ".",
          "4",
          "1",
          "9",
          ".",
          ".",
          "5"
        ],
        [
          ".",
          ".",
          ".",
          ".",
          "8",
          ".",
          ".",
          "7",
          "9"
        ]
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        [
          "5",
          "3",
          "5",
          ".",
          "7",
          ".",
          ".",
          ".",
          "."
        ],
        [
          "6",
          ".",
          ".",
          "1",
          "9",
          "5",
          ".",
          ".",
          "."
        ],
        [
          ".",
          "9",
          "8",
          ".",
          ".",
          ".",
          ".",
          "6",
          "."
        ],
        [
          "8",
          ".",
          ".",
          ".",
          "6",
          ".",
          ".",
          ".",
          "3"
        ],
        [
          "4",
          ".",
          ".",
          "8",
          ".",
          "3",
          ".",
          ".",
          "1"
        ],
        [
          "7",
          ".",
          ".",
          ".",
          "2",
          ".",
          ".",
          ".",
          "6"
        ],
        [
          ".",
          "6",
          ".",
          ".",
          ".",
          ".",
          "2",
          "8",
          "."
        ],
        [
          ".",
          ".",
          ".",
          "4",
          "1",
          "9",
          ".",
          ".",
          "5"
        ],
        [
          ".",
          ".",
          ".",
          ".",
          "8",
          ".",
          ".",
          "7",
          "9"
        ]
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1417,
    '对角线遍历',
    '给定 m x n 矩阵 mat，按对角线顺序遍历所有元素：
先向右上，再向左下，交替进行。返回遍历结果数组。',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '模拟'],
    $json$[
  {
    "input": "mat = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]",
    "output": "[1, 2, 4, 7, 5, 3, 6, 8, 9]"
  },
  {
    "input": "mat = [[1, 2], [3, 4]]",
    "output": "[1, 2, 3, 4]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mat = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]",
    "output": "[1, 2, 4, 7, 5, 3, 6, 8, 9]"
  },
  {
    "input": "mat = [[1, 2], [3, 4]]",
    "output": "[1, 2, 3, 4]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findDiagonalOrder = function(mat) {\n};\n",
  "python": "class Solution:\n    def findDiagonalOrder(self, mat: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findDiagonalOrder(std::vector<std::vector<int>>& mat) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findDiagonalOrder(int[][] mat) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findDiagonalOrder",
  "params": [
    {
      "name": "mat",
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
        1,
        2,
        4,
        7,
        5,
        3,
        6,
        8,
        9
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
      [
        [
          1
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
          2,
          3
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
      1,
      2,
      3,
      5,
      4,
      6
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1418,
    '杨辉三角 II',
    '返回杨辉三角的第 rowIndex 行（行号从 0 开始）。',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "rowIndex = 3",
    "output": "[1, 3, 3, 1]"
  },
  {
    "input": "rowIndex = 0",
    "output": "[1]"
  },
  {
    "input": "rowIndex = 1",
    "output": "[1, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "rowIndex = 3",
    "output": "[1, 3, 3, 1]"
  },
  {
    "input": "rowIndex = 0",
    "output": "[1]"
  },
  {
    "input": "rowIndex = 1",
    "output": "[1, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var getRow = function(rowIndex) {\n};\n",
  "python": "class Solution:\n    def getRow(self, rowIndex: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> getRow(int rowIndex) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] getRow(int rowIndex) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getRow",
  "params": [
    {
      "name": "rowIndex",
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
        3
      ],
      "expected": [
        1,
        3,
        3,
        1
      ]
    },
    {
      "args": [
        0
      ],
      "expected": [
        1
      ]
    },
    {
      "args": [
        1
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
      2
    ],
    "expected": [
      1,
      2,
      1
    ]
  },
  {
    "args": [
      4
    ],
    "expected": [
      1,
      4,
      6,
      4,
      1
    ]
  },
  {
    "args": [
      5
    ],
    "expected": [
      1,
      5,
      10,
      10,
      5,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1419,
    'Z 字形变换',
    '将字符串 s 按 Z 字形排列到 numRows 行后，逐行读取，返回结果字符串。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '模拟'],
    $json$[
  {
    "input": "s = \"PAYPALISHIRING\", numRows = 3",
    "output": "\"PAHNAPLSIIGYIR\""
  },
  {
    "input": "s = \"PAYPALISHIRING\", numRows = 4",
    "output": "\"PINALSIGYAHRPI\""
  },
  {
    "input": "s = \"A\", numRows = 1",
    "output": "\"A\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"PAYPALISHIRING\", numRows = 3",
    "output": "\"PAHNAPLSIIGYIR\""
  },
  {
    "input": "s = \"PAYPALISHIRING\", numRows = 4",
    "output": "\"PINALSIGYAHRPI\""
  },
  {
    "input": "s = \"A\", numRows = 1",
    "output": "\"A\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var convert = function(s, numRows) {\n};\n",
  "python": "class Solution:\n    def convert(self, s: str, numRows: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string convert(std::string s, int numRows) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String convert(String s, int numRows) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "convert",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "numRows",
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
        "PAYPALISHIRING",
        3
      ],
      "expected": "PAHNAPLSIIGYIR"
    },
    {
      "args": [
        "PAYPALISHIRING",
        4
      ],
      "expected": "PINALSIGYAHRPI"
    },
    {
      "args": [
        "A",
        1
      ],
      "expected": "A"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "AB",
      1
    ],
    "expected": "AB"
  },
  {
    "args": [
      "ABC",
      2
    ],
    "expected": "ACB"
  },
  {
    "args": [
      "ABCD",
      3
    ],
    "expected": "ABDC"
  },
  {
    "args": [
      "HELLO",
      4
    ],
    "expected": "HELOL"
  }
]$json$::jsonb,
    'approved'
),
(
    1420,
    '最大交换',
    '给定一个非负整数 num，最多交换其中两个数字一次，返回能得到的最大数字。',
    'medium',
    1000,
    256,
    ARRAY['贪心', '数学'],
    $json$[
  {
    "input": "num = 2736",
    "output": "7236"
  },
  {
    "input": "num = 9973",
    "output": "9973"
  },
  {
    "input": "num = 1234",
    "output": "4231"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 2736",
    "output": "7236"
  },
  {
    "input": "num = 9973",
    "output": "9973"
  },
  {
    "input": "num = 1234",
    "output": "4231"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumSwap = function(num) {\n};\n",
  "python": "class Solution:\n    def maximumSwap(self, num: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumSwap(int num) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumSwap(int num) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumSwap",
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
        2736
      ],
      "expected": 7236
    },
    {
      "args": [
        9973
      ],
      "expected": 9973
    },
    {
      "args": [
        1234
      ],
      "expected": 4231
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
      10
    ],
    "expected": 10
  },
  {
    "args": [
      98368
    ],
    "expected": 98863
  },
  {
    "args": [
      1993
    ],
    "expected": 9913
  }
]$json$::jsonb,
    'approved'
),
(
    1421,
    '使括号有效的最少添加',
    '给定只含 ''('' 和 '')'' 的字符串 s，返回使括号字符串有效所需添加的最少括号数。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '栈', '贪心'],
    $json$[
  {
    "input": "s = \"())\"",
    "output": "1"
  },
  {
    "input": "s = \"(((\"",
    "output": "3"
  },
  {
    "input": "s = \"()\"",
    "output": "0"
  },
  {
    "input": "s = \"()))((\"",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"())\"",
    "output": "1"
  },
  {
    "input": "s = \"(((\"",
    "output": "3"
  },
  {
    "input": "s = \"()\"",
    "output": "0"
  },
  {
    "input": "s = \"()))((\"",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minAddToMakeValid = function(s) {\n};\n",
  "python": "class Solution:\n    def minAddToMakeValid(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minAddToMakeValid(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minAddToMakeValid(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minAddToMakeValid",
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
        "())"
      ],
      "expected": 1
    },
    {
      "args": [
        "((("
      ],
      "expected": 3
    },
    {
      "args": [
        "()"
      ],
      "expected": 0
    },
    {
      "args": [
        "()))(("
      ],
      "expected": 4
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
      "("
    ],
    "expected": 1
  },
  {
    "args": [
      ")"
    ],
    "expected": 1
  },
  {
    "args": [
      "()()"
    ],
    "expected": 0
  },
  {
    "args": [
      "((())"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1422,
    '字母大小写全排列',
    '给定字符串 s，返回通过改变每个字母的大小写能得到的所有字符串，按字典序升序排列。
非字母字符保持不变。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '回溯', '位运算'],
    $json$[
  {
    "input": "s = \"a1b2\"",
    "output": "[\"A1B2\", \"A1b2\", \"a1B2\", \"a1b2\"]"
  },
  {
    "input": "s = \"3z4\"",
    "output": "[\"3Z4\", \"3z4\"]"
  },
  {
    "input": "s = \"C\"",
    "output": "[\"C\", \"c\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"a1b2\"",
    "output": "[\"A1B2\", \"A1b2\", \"a1B2\", \"a1b2\"]"
  },
  {
    "input": "s = \"3z4\"",
    "output": "[\"3Z4\", \"3z4\"]"
  },
  {
    "input": "s = \"C\"",
    "output": "[\"C\", \"c\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var letterCasePermutation = function(s) {\n};\n",
  "python": "class Solution:\n    def letterCasePermutation(self, s: str) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> letterCasePermutation(std::string s) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] letterCasePermutation(String s) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "letterCasePermutation",
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
        "a1b2"
      ],
      "expected": [
        "A1B2",
        "A1b2",
        "a1B2",
        "a1b2"
      ]
    },
    {
      "args": [
        "3z4"
      ],
      "expected": [
        "3Z4",
        "3z4"
      ]
    },
    {
      "args": [
        "C"
      ],
      "expected": [
        "C",
        "c"
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
      "A",
      "a"
    ]
  },
  {
    "args": [
      "ab"
    ],
    "expected": [
      "AB",
      "Ab",
      "aB",
      "ab"
    ]
  },
  {
    "args": [
      "1"
    ],
    "expected": [
      "1"
    ]
  },
  {
    "args": [
      "A1"
    ],
    "expected": [
      "A1",
      "a1"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1423,
    '子集',
    '给定不含重复元素的整数数组 nums，返回所有子集。
按子集长度升序排列，长度相同按字典序升序排列。',
    'medium',
    1000,
    256,
    ARRAY['数组', '回溯', '位运算'],
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "[[], [1], [2], [3], [1, 2], [1, 3], [2, 3], [1, 2, 3]]"
  },
  {
    "input": "nums = [0]",
    "output": "[[], [0]]"
  },
  {
    "input": "nums = [1, 2]",
    "output": "[[], [1], [2], [1, 2]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "[[], [1], [2], [3], [1, 2], [1, 3], [2, 3], [1, 2, 3]]"
  },
  {
    "input": "nums = [0]",
    "output": "[[], [0]]"
  },
  {
    "input": "nums = [1, 2]",
    "output": "[[], [1], [2], [1, 2]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var subsets = function(nums) {\n};\n",
  "python": "class Solution:\n    def subsets(self, nums: list[int]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> subsets(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] subsets(int[] nums) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "subsets",
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
        [],
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
          0
        ]
      ],
      "expected": [
        [],
        [
          0
        ]
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
        [],
        [
          1
        ],
        [
          2
        ],
        [
          1,
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
        1
      ]
    ],
    "expected": [
      [],
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
      [],
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
      ],
      [
        2,
        4
      ],
      [
        3,
        4
      ],
      [
        1,
        2,
        3
      ],
      [
        1,
        2,
        4
      ],
      [
        1,
        3,
        4
      ],
      [
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
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1424,
    '子集 II',
    '给定可能包含重复元素的整数数组 nums，返回所有不重复的子集。
按子集长度升序排列，长度相同按字典序升序排列。',
    'medium',
    1000,
    256,
    ARRAY['数组', '回溯', '位运算'],
    $json$[
  {
    "input": "nums = [1, 2, 2]",
    "output": "[[], [1], [2], [1, 2], [2, 2], [1, 2, 2]]"
  },
  {
    "input": "nums = [0]",
    "output": "[[], [0]]"
  },
  {
    "input": "nums = [4, 4, 4, 1, 4]",
    "output": "[[], [1], [4], [1, 4], [4, 1], [4, 4], [4, 1, 4], [4, 4, 1], [4, 4, 4], [4, 4, 1, 4], [4, 4, 4, 1], [4, 4, 4, 4], [4, 4, 4, 1, 4]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 2]",
    "output": "[[], [1], [2], [1, 2], [2, 2], [1, 2, 2]]"
  },
  {
    "input": "nums = [0]",
    "output": "[[], [0]]"
  },
  {
    "input": "nums = [4, 4, 4, 1, 4]",
    "output": "[[], [1], [4], [1, 4], [4, 1], [4, 4], [4, 1, 4], [4, 4, 1], [4, 4, 4], [4, 4, 1, 4], [4, 4, 4, 1], [4, 4, 4, 4], [4, 4, 4, 1, 4]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var subsetsWithDup = function(nums) {\n};\n",
  "python": "class Solution:\n    def subsetsWithDup(self, nums: list[int]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> subsetsWithDup(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] subsetsWithDup(int[] nums) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "subsetsWithDup",
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
          2
        ]
      ],
      "expected": [
        [],
        [
          1
        ],
        [
          2
        ],
        [
          1,
          2
        ],
        [
          2,
          2
        ],
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
          0
        ]
      ],
      "expected": [
        [],
        [
          0
        ]
      ]
    },
    {
      "args": [
        [
          4,
          4,
          4,
          1,
          4
        ]
      ],
      "expected": [
        [],
        [
          1
        ],
        [
          4
        ],
        [
          1,
          4
        ],
        [
          4,
          1
        ],
        [
          4,
          4
        ],
        [
          4,
          1,
          4
        ],
        [
          4,
          4,
          1
        ],
        [
          4,
          4,
          4
        ],
        [
          4,
          4,
          1,
          4
        ],
        [
          4,
          4,
          4,
          1
        ],
        [
          4,
          4,
          4,
          4
        ],
        [
          4,
          4,
          4,
          1,
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
        1,
        1
      ]
    ],
    "expected": [
      [],
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
      [
        1,
        2,
        2,
        3
      ]
    ],
    "expected": [
      [],
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
        1,
        2
      ],
      [
        1,
        3
      ],
      [
        2,
        2
      ],
      [
        2,
        3
      ],
      [
        1,
        2,
        2
      ],
      [
        1,
        2,
        3
      ],
      [
        2,
        2,
        3
      ],
      [
        1,
        2,
        2,
        3
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1425,
    '全排列 II',
    '给定可能包含重复数字的数组 nums，按字典序升序返回所有不重复的全排列。',
    'medium',
    1000,
    256,
    ARRAY['数组', '回溯'],
    $json$[
  {
    "input": "nums = [1, 1, 2]",
    "output": "[[1, 1, 2], [1, 2, 1], [2, 1, 1]]"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "[[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]"
  },
  {
    "input": "nums = [1]",
    "output": "[[1]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 2]",
    "output": "[[1, 1, 2], [1, 2, 1], [2, 1, 1]]"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "[[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]"
  },
  {
    "input": "nums = [1]",
    "output": "[[1]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var permuteUnique = function(nums) {\n};\n",
  "python": "class Solution:\n    def permuteUnique(self, nums: list[int]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> permuteUnique(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] permuteUnique(int[] nums) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "permuteUnique",
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
          1,
          2
        ]
      ],
      "expected": [
        [
          1,
          1,
          2
        ],
        [
          1,
          2,
          1
        ],
        [
          2,
          1,
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
          1
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
        2,
        2
      ]
    ],
    "expected": [
      [
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
        1
      ]
    ],
    "expected": [
      [
        1,
        1,
        2
      ],
      [
        1,
        2,
        1
      ],
      [
        2,
        1,
        1
      ]
    ]
  },
  {
    "args": [
      [
        3,
        3,
        1
      ]
    ],
    "expected": [
      [
        1,
        3,
        3
      ],
      [
        3,
        1,
        3
      ],
      [
        3,
        3,
        1
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1426,
    '组合',
    '返回 1 到 n 中所有包含 k 个数的组合，按字典序升序排列。',
    'medium',
    1000,
    256,
    ARRAY['回溯'],
    $json$[
  {
    "input": "n = 4, k = 2",
    "output": "[[1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]"
  },
  {
    "input": "n = 1, k = 1",
    "output": "[[1]]"
  },
  {
    "input": "n = 3, k = 2",
    "output": "[[1, 2], [1, 3], [2, 3]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4, k = 2",
    "output": "[[1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]"
  },
  {
    "input": "n = 1, k = 1",
    "output": "[[1]]"
  },
  {
    "input": "n = 3, k = 2",
    "output": "[[1, 2], [1, 3], [2, 3]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var combine = function(n, k) {\n};\n",
  "python": "class Solution:\n    def combine(self, n: int, k: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> combine(int n, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] combine(int n, int k) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "combine",
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
  "return_type": "int[][]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        4,
        2
      ],
      "expected": [
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
        ],
        [
          2,
          4
        ],
        [
          3,
          4
        ]
      ]
    },
    {
      "args": [
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
        3,
        2
      ],
      "expected": [
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
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      3,
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
      5,
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
      ]
    ]
  },
  {
    "args": [
      5,
      3
    ],
    "expected": [
      [
        1,
        2,
        3
      ],
      [
        1,
        2,
        4
      ],
      [
        1,
        2,
        5
      ],
      [
        1,
        3,
        4
      ],
      [
        1,
        3,
        5
      ],
      [
        1,
        4,
        5
      ],
      [
        2,
        3,
        4
      ],
      [
        2,
        3,
        5
      ],
      [
        2,
        4,
        5
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
    1427,
    '组合总和 II',
    '给定可能包含重复数字的候选数组 candidates 和目标数 target。
每个数字在每个组合中最多使用一次，返回所有和等于 target 的不重复组合。
组合内按非递减顺序排列，组合间按字典序升序排列。',
    'medium',
    1000,
    256,
    ARRAY['数组', '回溯'],
    $json$[
  {
    "input": "candidates = [10, 1, 2, 7, 6, 1, 5], target = 8",
    "output": "[[1, 1, 6], [1, 2, 5], [1, 7], [2, 6]]"
  },
  {
    "input": "candidates = [2, 5, 2, 1, 2], target = 5",
    "output": "[[1, 2, 2], [5]]"
  },
  {
    "input": "candidates = [2], target = 1",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "candidates = [10, 1, 2, 7, 6, 1, 5], target = 8",
    "output": "[[1, 1, 6], [1, 2, 5], [1, 7], [2, 6]]"
  },
  {
    "input": "candidates = [2, 5, 2, 1, 2], target = 5",
    "output": "[[1, 2, 2], [5]]"
  },
  {
    "input": "candidates = [2], target = 1",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var combinationSum2 = function(candidates, target) {\n};\n",
  "python": "class Solution:\n    def combinationSum2(self, candidates: list[int], target: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> combinationSum2(std::vector<int>& candidates, int target) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] combinationSum2(int[] candidates, int target) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "combinationSum2",
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
          10,
          1,
          2,
          7,
          6,
          1,
          5
        ],
        8
      ],
      "expected": [
        [
          1,
          1,
          6
        ],
        [
          1,
          2,
          5
        ],
        [
          1,
          7
        ],
        [
          2,
          6
        ]
      ]
    },
    {
      "args": [
        [
          2,
          5,
          2,
          1,
          2
        ],
        5
      ],
      "expected": [
        [
          1,
          2,
          2
        ],
        [
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
      2
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
        2,
        3
      ],
      3
    ],
    "expected": [
      [
        1,
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
        1,
        1
      ],
      3
    ],
    "expected": [
      [
        1,
        1,
        1
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1428,
    '组合总和 III',
    '返回 1 到 9 中所有包含 k 个数且和为 n 的组合，按字典序升序排列。',
    'medium',
    1000,
    256,
    ARRAY['回溯'],
    $json$[
  {
    "input": "k = 3, n = 7",
    "output": "[[1, 2, 4]]"
  },
  {
    "input": "k = 3, n = 9",
    "output": "[[1, 2, 6], [1, 3, 5], [2, 3, 4]]"
  },
  {
    "input": "k = 4, n = 1",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "k = 3, n = 7",
    "output": "[[1, 2, 4]]"
  },
  {
    "input": "k = 3, n = 9",
    "output": "[[1, 2, 6], [1, 3, 5], [2, 3, 4]]"
  },
  {
    "input": "k = 4, n = 1",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var combinationSum3 = function(k, n) {\n};\n",
  "python": "class Solution:\n    def combinationSum3(self, k: int, n: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> combinationSum3(int k, int n) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] combinationSum3(int k, int n) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "combinationSum3",
  "params": [
    {
      "name": "k",
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
        3,
        7
      ],
      "expected": [
        [
          1,
          2,
          4
        ]
      ]
    },
    {
      "args": [
        3,
        9
      ],
      "expected": [
        [
          1,
          2,
          6
        ],
        [
          1,
          3,
          5
        ],
        [
          2,
          3,
          4
        ]
      ]
    },
    {
      "args": [
        4,
        1
      ],
      "expected": []
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
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
      2,
      5
    ],
    "expected": [
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
      9,
      45
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
        8,
        9
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1429,
    '组合总和 IV',
    '给定由不同正整数组成的数组 nums 和目标值 target，
返回和为 target 的元素组合个数。顺序不同视为不同组合。',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "nums = [1, 2, 3], target = 4",
    "output": "7"
  },
  {
    "input": "nums = [9], target = 3",
    "output": "0"
  },
  {
    "input": "nums = [1, 2], target = 3",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3], target = 4",
    "output": "7"
  },
  {
    "input": "nums = [9], target = 3",
    "output": "0"
  },
  {
    "input": "nums = [1, 2], target = 3",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var combinationSum4 = function(nums, target) {\n};\n",
  "python": "class Solution:\n    def combinationSum4(self, nums: list[int], target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int combinationSum4(std::vector<int>& nums, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int combinationSum4(int[] nums, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "combinationSum4",
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
          2,
          3
        ],
        4
      ],
      "expected": 7
    },
    {
      "args": [
        [
          9
        ],
        3
      ],
      "expected": 0
    },
    {
      "args": [
        [
          1,
          2
        ],
        3
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
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
        3
      ],
      5
    ],
    "expected": 2
  },
  {
    "args": [
      [
        3,
        4,
        5
      ],
      7
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1430,
    '复原 IP 地址',
    '给定只含数字的字符串 s，返回所有可能的有效 IPv4 地址，按字典序升序排列。
每个地址由四个 0 到 255 的整数组成，且不能有前导零（单个 0 除外）。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '回溯'],
    $json$[
  {
    "input": "s = \"25525511135\"",
    "output": "[\"255.255.11.135\", \"255.255.111.35\"]"
  },
  {
    "input": "s = \"0000\"",
    "output": "[\"0.0.0.0\"]"
  },
  {
    "input": "s = \"101023\"",
    "output": "[\"1.0.10.23\", \"1.0.102.3\", \"10.1.0.23\", \"10.10.2.3\", \"101.0.2.3\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"25525511135\"",
    "output": "[\"255.255.11.135\", \"255.255.111.35\"]"
  },
  {
    "input": "s = \"0000\"",
    "output": "[\"0.0.0.0\"]"
  },
  {
    "input": "s = \"101023\"",
    "output": "[\"1.0.10.23\", \"1.0.102.3\", \"10.1.0.23\", \"10.10.2.3\", \"101.0.2.3\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var restoreIpAddresses = function(s) {\n};\n",
  "python": "class Solution:\n    def restoreIpAddresses(self, s: str) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> restoreIpAddresses(std::string s) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] restoreIpAddresses(String s) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "restoreIpAddresses",
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
        "25525511135"
      ],
      "expected": [
        "255.255.11.135",
        "255.255.111.35"
      ]
    },
    {
      "args": [
        "0000"
      ],
      "expected": [
        "0.0.0.0"
      ]
    },
    {
      "args": [
        "101023"
      ],
      "expected": [
        "1.0.10.23",
        "1.0.102.3",
        "10.1.0.23",
        "10.10.2.3",
        "101.0.2.3"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "1111"
    ],
    "expected": [
      "1.1.1.1"
    ]
  },
  {
    "args": [
      "010010"
    ],
    "expected": [
      "0.10.0.10",
      "0.100.1.0"
    ]
  },
  {
    "args": [
      "1234567890123"
    ],
    "expected": []
  }
]$json$::jsonb,
    'approved'
),
(
    1431,
    '火柴拼正方形',
    '给定火柴长度数组 matchsticks，判断能否用所有火柴拼成一个正方形。',
    'medium',
    1000,
    256,
    ARRAY['数组', '回溯', '位运算'],
    $json$[
  {
    "input": "matchsticks = [1, 1, 2, 2, 2]",
    "output": "true"
  },
  {
    "input": "matchsticks = [3, 3, 3, 3, 4]",
    "output": "false"
  },
  {
    "input": "matchsticks = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matchsticks = [1, 1, 2, 2, 2]",
    "output": "true"
  },
  {
    "input": "matchsticks = [3, 3, 3, 3, 4]",
    "output": "false"
  },
  {
    "input": "matchsticks = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var makesquare = function(matchsticks) {\n};\n",
  "python": "class Solution:\n    def makesquare(self, matchsticks: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool makesquare(std::vector<int>& matchsticks) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean makesquare(int[] matchsticks) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "makesquare",
  "params": [
    {
      "name": "matchsticks",
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
          1,
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
          3,
          3,
          3,
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
    "expected": true
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
    "expected": true
  },
  {
    "args": [
      [
        2,
        2,
        2,
        2,
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
    1432,
    '划分为 k 个相等的子集',
    '给定整数数组 nums 和整数 k，判断能否将数组分成 k 个非空子集，
使每个子集的元素和相等。',
    'medium',
    1000,
    256,
    ARRAY['数组', '回溯', '动态规划'],
    $json$[
  {
    "input": "nums = [4, 3, 2, 3, 5, 2, 1], k = 4",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3, 4], k = 3",
    "output": "false"
  },
  {
    "input": "nums = [2, 2, 2, 2, 3, 4, 5], k = 4",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [4, 3, 2, 3, 5, 2, 1], k = 4",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3, 4], k = 3",
    "output": "false"
  },
  {
    "input": "nums = [2, 2, 2, 2, 3, 4, 5], k = 4",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canPartitionKSubsets = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def canPartitionKSubsets(self, nums: list[int], k: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canPartitionKSubsets(std::vector<int>& nums, int k) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canPartitionKSubsets(int[] nums, int k) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canPartitionKSubsets",
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
          4,
          3,
          2,
          3,
          5,
          2,
          1
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
          4
        ],
        3
      ],
      "expected": false
    },
    {
      "args": [
        [
          2,
          2,
          2,
          2,
          3,
          4,
          5
        ],
        4
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
      2
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
      ],
      2
    ],
    "expected": true
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
      2
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1433,
    'N 皇后 II',
    '返回 n 皇后问题不同解的数量。',
    'medium',
    1000,
    256,
    ARRAY['回溯'],
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
  }
]$json$::jsonb,
    'approved'
),
(
    1434,
    '二进制手表',
    '二进制手表用 4 个 LED 表示小时（0 到 11），6 个 LED 表示分钟（0 到 59）。
给定亮灯数 turnedOn，按时间升序返回所有可能的时间，格式为 "H:MM"。',
    'medium',
    1000,
    256,
    ARRAY['位运算', '回溯'],
    $json$[
  {
    "input": "turnedOn = 1",
    "output": "[\"0:01\", \"0:02\", \"0:04\", \"0:08\", \"0:16\", \"0:32\", \"1:00\", \"2:00\", \"4:00\", \"8:00\"]"
  },
  {
    "input": "turnedOn = 9",
    "output": "[]"
  },
  {
    "input": "turnedOn = 0",
    "output": "[\"0:00\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "turnedOn = 1",
    "output": "[\"0:01\", \"0:02\", \"0:04\", \"0:08\", \"0:16\", \"0:32\", \"1:00\", \"2:00\", \"4:00\", \"8:00\"]"
  },
  {
    "input": "turnedOn = 9",
    "output": "[]"
  },
  {
    "input": "turnedOn = 0",
    "output": "[\"0:00\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var readBinaryWatch = function(turnedOn) {\n};\n",
  "python": "class Solution:\n    def readBinaryWatch(self, turnedOn: int) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> readBinaryWatch(int turnedOn) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] readBinaryWatch(int turnedOn) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "readBinaryWatch",
  "params": [
    {
      "name": "turnedOn",
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
        "0:01",
        "0:02",
        "0:04",
        "0:08",
        "0:16",
        "0:32",
        "1:00",
        "2:00",
        "4:00",
        "8:00"
      ]
    },
    {
      "args": [
        9
      ],
      "expected": []
    },
    {
      "args": [
        0
      ],
      "expected": [
        "0:00"
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
      "0:03",
      "0:05",
      "0:06",
      "0:09",
      "0:10",
      "0:12",
      "0:17",
      "0:18",
      "0:20",
      "0:24",
      "0:33",
      "0:34",
      "0:36",
      "0:40",
      "0:48",
      "1:01",
      "1:02",
      "1:04",
      "1:08",
      "1:16",
      "1:32",
      "2:01",
      "2:02",
      "2:04",
      "2:08",
      "2:16",
      "2:32",
      "3:00",
      "4:01",
      "4:02",
      "4:04",
      "4:08",
      "4:16",
      "4:32",
      "5:00",
      "6:00",
      "8:01",
      "8:02",
      "8:04",
      "8:08",
      "8:16",
      "8:32",
      "9:00",
      "10:00"
    ]
  },
  {
    "args": [
      3
    ],
    "expected": [
      "0:07",
      "0:11",
      "0:13",
      "0:14",
      "0:19",
      "0:21",
      "0:22",
      "0:25",
      "0:26",
      "0:28",
      "0:35",
      "0:37",
      "0:38",
      "0:41",
      "0:42",
      "0:44",
      "0:49",
      "0:50",
      "0:52",
      "0:56",
      "1:03",
      "1:05",
      "1:06",
      "1:09",
      "1:10",
      "1:12",
      "1:17",
      "1:18",
      "1:20",
      "1:24",
      "1:33",
      "1:34",
      "1:36",
      "1:40",
      "1:48",
      "2:03",
      "2:05",
      "2:06",
      "2:09",
      "2:10",
      "2:12",
      "2:17",
      "2:18",
      "2:20",
      "2:24",
      "2:33",
      "2:34",
      "2:36",
      "2:40",
      "2:48",
      "3:01",
      "3:02",
      "3:04",
      "3:08",
      "3:16",
      "3:32",
      "4:03",
      "4:05",
      "4:06",
      "4:09",
      "4:10",
      "4:12",
      "4:17",
      "4:18",
      "4:20",
      "4:24",
      "4:33",
      "4:34",
      "4:36",
      "4:40",
      "4:48",
      "5:01",
      "5:02",
      "5:04",
      "5:08",
      "5:16",
      "5:32",
      "6:01",
      "6:02",
      "6:04",
      "6:08",
      "6:16",
      "6:32",
      "7:00",
      "8:03",
      "8:05",
      "8:06",
      "8:09",
      "8:10",
      "8:12",
      "8:17",
      "8:18",
      "8:20",
      "8:24",
      "8:33",
      "8:34",
      "8:36",
      "8:40",
      "8:48",
      "9:01",
      "9:02",
      "9:04",
      "9:08",
      "9:16",
      "9:32",
      "10:01",
      "10:02",
      "10:04",
      "10:08",
      "10:16",
      "10:32",
      "11:00"
    ]
  },
  {
    "args": [
      8
    ],
    "expected": [
      "7:31",
      "7:47",
      "7:55",
      "7:59",
      "11:31",
      "11:47",
      "11:55",
      "11:59"
    ]
  },
  {
    "args": [
      10
    ],
    "expected": []
  }
]$json$::jsonb,
    'approved'
),
(
    1435,
    '最大单词长度乘积',
    '给定字符串数组 words，返回两个不含公共字母的单词长度乘积的最大值。
不存在这样的两个单词返回 0。',
    'medium',
    1000,
    256,
    ARRAY['数组', '字符串', '位运算'],
    $json$[
  {
    "input": "words = [\"abcw\", \"baz\", \"foo\", \"bar\", \"xtfn\", \"abcdef\"]",
    "output": "16"
  },
  {
    "input": "words = [\"a\", \"ab\", \"abc\", \"d\", \"cd\", \"bcd\", \"abcd\"]",
    "output": "4"
  },
  {
    "input": "words = [\"a\", \"aa\", \"aaa\", \"aaaa\"]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"abcw\", \"baz\", \"foo\", \"bar\", \"xtfn\", \"abcdef\"]",
    "output": "16"
  },
  {
    "input": "words = [\"a\", \"ab\", \"abc\", \"d\", \"cd\", \"bcd\", \"abcd\"]",
    "output": "4"
  },
  {
    "input": "words = [\"a\", \"aa\", \"aaa\", \"aaaa\"]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxProduct = function(words) {\n};\n",
  "python": "class Solution:\n    def maxProduct(self, words: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxProduct(std::vector<std::string>& words) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxProduct(String[] words) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxProduct",
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
          "abcw",
          "baz",
          "foo",
          "bar",
          "xtfn",
          "abcdef"
        ]
      ],
      "expected": 16
    },
    {
      "args": [
        [
          "a",
          "ab",
          "abc",
          "d",
          "cd",
          "bcd",
          "abcd"
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          "a",
          "aa",
          "aaa",
          "aaaa"
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
        "a"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "ab",
        "cd"
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        "abc",
        "def",
        "ghi"
      ]
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1436,
    '字母异位词分组',
    '给定字符串数组 strs，将字母异位词分组。
每组内按字典序升序排列，各组之间按组内第一个字符串的字典序升序排列。',
    'medium',
    1000,
    256,
    ARRAY['数组', '字符串', '哈希表', '排序'],
    $json$[
  {
    "input": "strs = [\"eat\", \"tea\", \"tan\", \"ate\", \"nat\", \"bat\"]",
    "output": "[[\"ate\", \"eat\", \"tea\"], [\"bat\"], [\"nat\", \"tan\"]]"
  },
  {
    "input": "strs = [\"\"]",
    "output": "[[\"\"]]"
  },
  {
    "input": "strs = [\"a\"]",
    "output": "[[\"a\"]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "strs = [\"eat\", \"tea\", \"tan\", \"ate\", \"nat\", \"bat\"]",
    "output": "[[\"ate\", \"eat\", \"tea\"], [\"bat\"], [\"nat\", \"tan\"]]"
  },
  {
    "input": "strs = [\"\"]",
    "output": "[[\"\"]]"
  },
  {
    "input": "strs = [\"a\"]",
    "output": "[[\"a\"]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var groupAnagrams = function(strs) {\n};\n",
  "python": "class Solution:\n    def groupAnagrams(self, strs: list[str]) -> list[list[str]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<std::string>> groupAnagrams(std::vector<std::string>& strs) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[][] groupAnagrams(String[] strs) {\n        return new String[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "groupAnagrams",
  "params": [
    {
      "name": "strs",
      "type": "string[]"
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
          "eat",
          "tea",
          "tan",
          "ate",
          "nat",
          "bat"
        ]
      ],
      "expected": [
        [
          "ate",
          "eat",
          "tea"
        ],
        [
          "bat"
        ],
        [
          "nat",
          "tan"
        ]
      ]
    },
    {
      "args": [
        [
          ""
        ]
      ],
      "expected": [
        [
          ""
        ]
      ]
    },
    {
      "args": [
        [
          "a"
        ]
      ],
      "expected": [
        [
          "a"
        ]
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "ab",
        "ba",
        "abc",
        "cba",
        "bca"
      ]
    ],
    "expected": [
      [
        "ab",
        "ba"
      ],
      [
        "abc",
        "bca",
        "cba"
      ]
    ]
  },
  {
    "args": [
      [
        "",
        ""
      ]
    ],
    "expected": [
      [
        "",
        ""
      ]
    ]
  },
  {
    "args": [
      [
        "abc"
      ]
    ],
    "expected": [
      [
        "abc"
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1437,
    '前 K 个高频单词',
    '返回出现频率最高的 k 个单词，按频率降序排列；频率相同按字典序升序排列。',
    'medium',
    1000,
    256,
    ARRAY['数组', '字符串', '哈希表', '堆', '排序'],
    $json$[
  {
    "input": "words = [\"i\", \"love\", \"leetcode\", \"i\", \"love\", \"coding\"], k = 2",
    "output": "[\"i\", \"love\"]"
  },
  {
    "input": "words = [\"the\", \"day\", \"is\", \"sunny\", \"the\", \"the\", \"the\", \"sunny\", \"is\", \"is\"], k = 4",
    "output": "[\"the\", \"is\", \"sunny\", \"day\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"i\", \"love\", \"leetcode\", \"i\", \"love\", \"coding\"], k = 2",
    "output": "[\"i\", \"love\"]"
  },
  {
    "input": "words = [\"the\", \"day\", \"is\", \"sunny\", \"the\", \"the\", \"the\", \"sunny\", \"is\", \"is\"], k = 4",
    "output": "[\"the\", \"is\", \"sunny\", \"day\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var topKFrequent = function(words, k) {\n};\n",
  "python": "class Solution:\n    def topKFrequent(self, words: list[str], k: int) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> topKFrequent(std::vector<std::string>& words, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] topKFrequent(String[] words, int k) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "topKFrequent",
  "params": [
    {
      "name": "words",
      "type": "string[]"
    },
    {
      "name": "k",
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
          "i",
          "love",
          "leetcode",
          "i",
          "love",
          "coding"
        ],
        2
      ],
      "expected": [
        "i",
        "love"
      ]
    },
    {
      "args": [
        [
          "the",
          "day",
          "is",
          "sunny",
          "the",
          "the",
          "the",
          "sunny",
          "is",
          "is"
        ],
        4
      ],
      "expected": [
        "the",
        "is",
        "sunny",
        "day"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "a"
      ],
      1
    ],
    "expected": [
      "a"
    ]
  },
  {
    "args": [
      [
        "a",
        "b",
        "a"
      ],
      1
    ],
    "expected": [
      "a"
    ]
  },
  {
    "args": [
      [
        "a",
        "b",
        "b",
        "c",
        "c"
      ],
      2
    ],
    "expected": [
      "b",
      "c"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1438,
    '重新安排行程',
    '给定机票列表 tickets，每张票为 [from, to]。
从 "JFK" 出发，使用所有机票并返回字典序最小的行程。保证至少存在一种有效行程。',
    'medium',
    1000,
    256,
    ARRAY['图', '深度优先搜索', '欧拉路径'],
    $json$[
  {
    "input": "tickets = [[\"MUC\", \"LHR\"], [\"JFK\", \"MUC\"], [\"SFO\", \"SJC\"], [\"LHR\", \"SFO\"]]",
    "output": "[\"JFK\", \"MUC\", \"LHR\", \"SFO\", \"SJC\"]"
  },
  {
    "input": "tickets = [[\"JFK\", \"SFO\"], [\"JFK\", \"ATL\"], [\"SFO\", \"ATL\"], [\"ATL\", \"JFK\"], [\"ATL\", \"SFO\"]]",
    "output": "[\"JFK\", \"ATL\", \"JFK\", \"SFO\", \"ATL\", \"SFO\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "tickets = [[\"MUC\", \"LHR\"], [\"JFK\", \"MUC\"], [\"SFO\", \"SJC\"], [\"LHR\", \"SFO\"]]",
    "output": "[\"JFK\", \"MUC\", \"LHR\", \"SFO\", \"SJC\"]"
  },
  {
    "input": "tickets = [[\"JFK\", \"SFO\"], [\"JFK\", \"ATL\"], [\"SFO\", \"ATL\"], [\"ATL\", \"JFK\"], [\"ATL\", \"SFO\"]]",
    "output": "[\"JFK\", \"ATL\", \"JFK\", \"SFO\", \"ATL\", \"SFO\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findItinerary = function(tickets) {\n};\n",
  "python": "class Solution:\n    def findItinerary(self, tickets: list[list[str]]) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> findItinerary(std::vector<std::vector<std::string>>& tickets) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] findItinerary(String[][] tickets) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findItinerary",
  "params": [
    {
      "name": "tickets",
      "type": "string[][]"
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
          [
            "MUC",
            "LHR"
          ],
          [
            "JFK",
            "MUC"
          ],
          [
            "SFO",
            "SJC"
          ],
          [
            "LHR",
            "SFO"
          ]
        ]
      ],
      "expected": [
        "JFK",
        "MUC",
        "LHR",
        "SFO",
        "SJC"
      ]
    },
    {
      "args": [
        [
          [
            "JFK",
            "SFO"
          ],
          [
            "JFK",
            "ATL"
          ],
          [
            "SFO",
            "ATL"
          ],
          [
            "ATL",
            "JFK"
          ],
          [
            "ATL",
            "SFO"
          ]
        ]
      ],
      "expected": [
        "JFK",
        "ATL",
        "JFK",
        "SFO",
        "ATL",
        "SFO"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          "JFK",
          "A"
        ],
        [
          "A",
          "JFK"
        ]
      ]
    ],
    "expected": [
      "JFK",
      "A",
      "JFK"
    ]
  },
  {
    "args": [
      [
        [
          "JFK",
          "K"
        ],
        [
          "JFK",
          "A"
        ],
        [
          "A",
          "JFK"
        ]
      ]
    ],
    "expected": [
      "JFK",
      "A",
      "JFK",
      "K"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1439,
    '等式方程的可满足性',
    '给定字符串数组 equations，每个元素形如 "a==b" 或 "a!=b"。
判断是否存在一组变量赋值使所有等式同时成立。变量为单个小写字母。',
    'medium',
    1000,
    256,
    ARRAY['并查集', '图', '数组'],
    $json$[
  {
    "input": "equations = [\"a==b\", \"b!=a\"]",
    "output": "false"
  },
  {
    "input": "equations = [\"b==a\", \"a==b\"]",
    "output": "true"
  },
  {
    "input": "equations = [\"a==b\", \"b==c\", \"a==c\"]",
    "output": "true"
  },
  {
    "input": "equations = [\"a==b\", \"b!=c\", \"c==a\"]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "equations = [\"a==b\", \"b!=a\"]",
    "output": "false"
  },
  {
    "input": "equations = [\"b==a\", \"a==b\"]",
    "output": "true"
  },
  {
    "input": "equations = [\"a==b\", \"b==c\", \"a==c\"]",
    "output": "true"
  },
  {
    "input": "equations = [\"a==b\", \"b!=c\", \"c==a\"]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var equationsPossible = function(equations) {\n};\n",
  "python": "class Solution:\n    def equationsPossible(self, equations: list[str]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool equationsPossible(std::vector<std::string>& equations) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean equationsPossible(String[] equations) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "equationsPossible",
  "params": [
    {
      "name": "equations",
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
          "a==b",
          "b!=a"
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          "b==a",
          "a==b"
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          "a==b",
          "b==c",
          "a==c"
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          "a==b",
          "b!=c",
          "c==a"
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
        "a!=a"
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        "a==a"
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        "a!=b"
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        "a==b",
        "b==c",
        "c!=a"
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1440,
    '连接所有点的最小费用',
    '给定二维平面上 n 个点的坐标 points，连接所有点的费用为两点间的曼哈顿距离。
返回连接所有点的最小总费用。',
    'medium',
    1000,
    256,
    ARRAY['图', '并查集', '最小生成树'],
    $json$[
  {
    "input": "points = [[0, 0], [2, 2], [3, 10], [5, 2], [7, 0]]",
    "output": "20"
  },
  {
    "input": "points = [[3, 12], [-2, 5], [-4, 1]]",
    "output": "18"
  },
  {
    "input": "points = [[0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "points = [[0, 0], [2, 2], [3, 10], [5, 2], [7, 0]]",
    "output": "20"
  },
  {
    "input": "points = [[3, 12], [-2, 5], [-4, 1]]",
    "output": "18"
  },
  {
    "input": "points = [[0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minCostConnectPoints = function(points) {\n};\n",
  "python": "class Solution:\n    def minCostConnectPoints(self, points: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minCostConnectPoints(std::vector<std::vector<int>>& points) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minCostConnectPoints(int[][] points) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minCostConnectPoints",
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
            2,
            2
          ],
          [
            3,
            10
          ],
          [
            5,
            2
          ],
          [
            7,
            0
          ]
        ]
      ],
      "expected": 20
    },
    {
      "args": [
        [
          [
            3,
            12
          ],
          [
            -2,
            5
          ],
          [
            -4,
            1
          ]
        ]
      ],
      "expected": 18
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
  },
  {
    "args": [
      [
        [
          0,
          0
        ],
        [
          10,
          10
        ]
      ]
    ],
    "expected": 20
  }
]$json$::jsonb,
    'approved'
),
(
    1441,
    '网络延迟时间',
    '给定 n 个节点和有向边 times，times[i] = [u, v, w] 表示从 u 到 v 需要 w 时间。
从节点 k 发出信号，返回所有节点都收到信号的最短时间；无法到达全部节点返回 -1。',
    'medium',
    1000,
    256,
    ARRAY['图', '最短路', '堆'],
    $json$[
  {
    "input": "times = [[2, 1, 1], [2, 3, 1], [3, 4, 1]], n = 4, k = 2",
    "output": "2"
  },
  {
    "input": "times = [[1, 2, 1]], n = 2, k = 1",
    "output": "1"
  },
  {
    "input": "times = [[1, 2, 1]], n = 2, k = 2",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "times = [[2, 1, 1], [2, 3, 1], [3, 4, 1]], n = 4, k = 2",
    "output": "2"
  },
  {
    "input": "times = [[1, 2, 1]], n = 2, k = 1",
    "output": "1"
  },
  {
    "input": "times = [[1, 2, 1]], n = 2, k = 2",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var networkDelayTime = function(times, n, k) {\n};\n",
  "python": "class Solution:\n    def networkDelayTime(self, times: list[list[int]], n: int, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int networkDelayTime(std::vector<std::vector<int>>& times, int n, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int networkDelayTime(int[][] times, int n, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "networkDelayTime",
  "params": [
    {
      "name": "times",
      "type": "int[][]"
    },
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
        [
          [
            2,
            1,
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
        4,
        2
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            1,
            2,
            1
          ]
        ],
        2,
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
            1
          ]
        ],
        2,
        2
      ],
      "expected": -1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [],
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
          2,
          1
        ],
        [
          2,
          3,
          2
        ],
        [
          1,
          3,
          4
        ]
      ],
      3,
      1
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1442,
    'K 站中转内最便宜的航班',
    '给定 n 个城市、航班数组 flights（每个元素为 [from, to, price]）、起点 src、终点 dst
和最多中转次数 k，返回最便宜的价格；无法到达返回 -1。',
    'medium',
    1000,
    256,
    ARRAY['图', '最短路', '动态规划'],
    $json$[
  {
    "input": "n = 3, flights = [[0, 1, 100], [1, 2, 100], [0, 2, 500]], src = 0, dst = 2, k = 1",
    "output": "200"
  },
  {
    "input": "n = 3, flights = [[0, 1, 100], [1, 2, 100], [0, 2, 500]], src = 0, dst = 2, k = 0",
    "output": "500"
  },
  {
    "input": "n = 4, flights = [[0, 1, 1], [0, 2, 5], [1, 2, 1], [2, 3, 1]], src = 0, dst = 3, k = 1",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, flights = [[0, 1, 100], [1, 2, 100], [0, 2, 500]], src = 0, dst = 2, k = 1",
    "output": "200"
  },
  {
    "input": "n = 3, flights = [[0, 1, 100], [1, 2, 100], [0, 2, 500]], src = 0, dst = 2, k = 0",
    "output": "500"
  },
  {
    "input": "n = 4, flights = [[0, 1, 1], [0, 2, 5], [1, 2, 1], [2, 3, 1]], src = 0, dst = 3, k = 1",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findCheapestPrice = function(n, flights, src, dst, k) {\n};\n",
  "python": "class Solution:\n    def findCheapestPrice(self, n: int, flights: list[list[int]], src: int, dst: int, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findCheapestPrice(int n, std::vector<std::vector<int>>& flights, int src, int dst, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findCheapestPrice(int n, int[][] flights, int src, int dst, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findCheapestPrice",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "flights",
      "type": "int[][]"
    },
    {
      "name": "src",
      "type": "int"
    },
    {
      "name": "dst",
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
        [
          [
            0,
            1,
            100
          ],
          [
            1,
            2,
            100
          ],
          [
            0,
            2,
            500
          ]
        ],
        0,
        2,
        1
      ],
      "expected": 200
    },
    {
      "args": [
        3,
        [
          [
            0,
            1,
            100
          ],
          [
            1,
            2,
            100
          ],
          [
            0,
            2,
            500
          ]
        ],
        0,
        2,
        0
      ],
      "expected": 500
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
            0,
            2,
            5
          ],
          [
            1,
            2,
            1
          ],
          [
            2,
            3,
            1
          ]
        ],
        0,
        3,
        1
      ],
      "expected": 6
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2,
      [],
      0,
      1,
      1
    ],
    "expected": -1
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
      0,
      1,
      0
    ],
    "expected": 5
  },
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
          2
        ]
      ],
      0,
      2,
      1
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1443,
    '概率最大的路径',
    '给定无向图 n 个节点，边 edges[i] = [a, b, prob] 表示 a 与 b 之间成功的概率。
返回从 start 到 end 成功概率最大的路径的概率；不可达返回 0。',
    'medium',
    1000,
    256,
    ARRAY['图', '最短路', '堆'],
    $json$[
  {
    "input": "n = 3, edges = [[0, 1, 0.5], [1, 2, 0.5], [0, 2, 0.2]], start = 0, end = 2",
    "output": "0.25"
  },
  {
    "input": "n = 3, edges = [[0, 1, 0.5], [1, 2, 0.5], [0, 2, 0.2]], start = 0, end = 1",
    "output": "0.5"
  },
  {
    "input": "n = 3, edges = [[0, 1, 0.5], [1, 2, 0.5]], start = 0, end = 2",
    "output": "0.25"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, edges = [[0, 1, 0.5], [1, 2, 0.5], [0, 2, 0.2]], start = 0, end = 2",
    "output": "0.25"
  },
  {
    "input": "n = 3, edges = [[0, 1, 0.5], [1, 2, 0.5], [0, 2, 0.2]], start = 0, end = 1",
    "output": "0.5"
  },
  {
    "input": "n = 3, edges = [[0, 1, 0.5], [1, 2, 0.5]], start = 0, end = 2",
    "output": "0.25"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxProbability = function(n, edges, start, end) {\n};\n",
  "python": "class Solution:\n    def maxProbability(self, n: int, edges: list[list[float]], start: int, end: int) -> float:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    double maxProbability(int n, std::vector<std::vector<double>>& edges, int start, int end) {\n        return 0.0;\n    }\n};\n",
  "java": "class Solution {\n    public double maxProbability(int n, double[][] edges, int start, int end) {\n        return 0.0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxProbability",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "edges",
      "type": "double[][]"
    },
    {
      "name": "start",
      "type": "int"
    },
    {
      "name": "end",
      "type": "int"
    }
  ],
  "return_type": "double",
  "compare": {
    "mode": "double"
  },
  "public_cases": [
    {
      "args": [
        3,
        [
          [
            0,
            1,
            0.5
          ],
          [
            1,
            2,
            0.5
          ],
          [
            0,
            2,
            0.2
          ]
        ],
        0,
        2
      ],
      "expected": 0.25
    },
    {
      "args": [
        3,
        [
          [
            0,
            1,
            0.5
          ],
          [
            1,
            2,
            0.5
          ],
          [
            0,
            2,
            0.2
          ]
        ],
        0,
        1
      ],
      "expected": 0.5
    },
    {
      "args": [
        3,
        [
          [
            0,
            1,
            0.5
          ],
          [
            1,
            2,
            0.5
          ]
        ],
        0,
        2
      ],
      "expected": 0.25
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2,
      [],
      0,
      1
    ],
    "expected": 0.0
  },
  {
    "args": [
      2,
      [
        [
          0,
          1,
          1.0
        ]
      ],
      0,
      1
    ],
    "expected": 1.0
  },
  {
    "args": [
      4,
      [
        [
          0,
          1,
          0.9
        ],
        [
          1,
          3,
          0.9
        ],
        [
          0,
          2,
          0.1
        ],
        [
          2,
          3,
          0.1
        ]
      ],
      0,
      3
    ],
    "expected": 0.81
  }
]$json$::jsonb,
    'approved'
),
(
    1444,
    '最小体力消耗路径',
    '给定 heights 矩阵，从左上角走到右下角，每次可上下左右移动。
一条路径的体力消耗为相邻格高度差绝对值的最大值。返回最小体力消耗。',
    'medium',
    1000,
    256,
    ARRAY['图', '二分查找', '堆', '矩阵'],
    $json$[
  {
    "input": "heights = [[1, 2, 2], [3, 8, 2], [5, 3, 5]]",
    "output": "2"
  },
  {
    "input": "heights = [[1, 2, 3], [3, 8, 4], [5, 3, 5]]",
    "output": "1"
  },
  {
    "input": "heights = [[1, 2], [2, 2]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "heights = [[1, 2, 2], [3, 8, 2], [5, 3, 5]]",
    "output": "2"
  },
  {
    "input": "heights = [[1, 2, 3], [3, 8, 4], [5, 3, 5]]",
    "output": "1"
  },
  {
    "input": "heights = [[1, 2], [2, 2]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumEffortPath = function(heights) {\n};\n",
  "python": "class Solution:\n    def minimumEffortPath(self, heights: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumEffortPath(std::vector<std::vector<int>>& heights) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumEffortPath(int[][] heights) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumEffortPath",
  "params": [
    {
      "name": "heights",
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
            2
          ],
          [
            3,
            8,
            2
          ],
          [
            5,
            3,
            5
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
            2,
            3
          ],
          [
            3,
            8,
            4
          ],
          [
            5,
            3,
            5
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
            2,
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
    "expected": 2
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
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1445,
    '二进制矩阵中的最短路径',
    '给定 n x n 的 0/1 矩阵 grid，0 可走，1 阻挡。
从 (0, 0) 到 (n-1, n-1) 可沿 8 个方向移动，返回最短路径长度（经过的格子数）；不可达返回 -1。',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '广度优先搜索'],
    $json$[
  {
    "input": "grid = [[0, 1], [1, 0]]",
    "output": "2"
  },
  {
    "input": "grid = [[0, 0, 0], [1, 1, 0], [1, 1, 0]]",
    "output": "4"
  },
  {
    "input": "grid = [[1, 0, 0], [1, 1, 0], [1, 1, 0]]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[0, 1], [1, 0]]",
    "output": "2"
  },
  {
    "input": "grid = [[0, 0, 0], [1, 1, 0], [1, 1, 0]]",
    "output": "4"
  },
  {
    "input": "grid = [[1, 0, 0], [1, 1, 0], [1, 1, 0]]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var shortestPathBinaryMatrix = function(grid) {\n};\n",
  "python": "class Solution:\n    def shortestPathBinaryMatrix(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int shortestPathBinaryMatrix(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int shortestPathBinaryMatrix(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "shortestPathBinaryMatrix",
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
            0,
            0,
            0
          ],
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
            0
          ],
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
      "expected": -1
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
    "expected": -1
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
      ]
    ],
    "expected": -1
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
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1446,
    '统计全为 1 的正方形子矩阵',
    '给定 m x n 的 0/1 矩阵 matrix，返回其中全为 1 的正方形子矩阵个数。',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '动态规划'],
    $json$[
  {
    "input": "matrix = [[1, 0, 1], [1, 1, 0], [1, 1, 0]]",
    "output": "7"
  },
  {
    "input": "matrix = [[0, 1, 1, 1], [1, 1, 1, 1], [0, 1, 1, 1]]",
    "output": "15"
  },
  {
    "input": "matrix = [[1, 1], [1, 1]]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 0, 1], [1, 1, 0], [1, 1, 0]]",
    "output": "7"
  },
  {
    "input": "matrix = [[0, 1, 1, 1], [1, 1, 1, 1], [0, 1, 1, 1]]",
    "output": "15"
  },
  {
    "input": "matrix = [[1, 1], [1, 1]]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countSquares = function(matrix) {\n};\n",
  "python": "class Solution:\n    def countSquares(self, matrix: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countSquares(std::vector<std::vector<int>>& matrix) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countSquares(int[][] matrix) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countSquares",
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
            1
          ],
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
      "expected": 7
    },
    {
      "args": [
        [
          [
            0,
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
            0,
            1,
            1,
            1
          ]
        ]
      ],
      "expected": 15
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
      "expected": 5
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
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1447,
    '删除一次得到子数组最大和',
    '给定整数数组 arr，可以删除至多一个元素，返回删除后能得到的非空子数组的最大和。',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "arr = [1, -2, 0, 3]",
    "output": "4"
  },
  {
    "input": "arr = [1, -2, -2, 3]",
    "output": "3"
  },
  {
    "input": "arr = [-1, -1, -1, -1]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [1, -2, 0, 3]",
    "output": "4"
  },
  {
    "input": "arr = [1, -2, -2, 3]",
    "output": "3"
  },
  {
    "input": "arr = [-1, -1, -1, -1]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumSum = function(arr) {\n};\n",
  "python": "class Solution:\n    def maximumSum(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumSum(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumSum(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumSum",
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
          -2,
          0,
          3
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          1,
          -2,
          -2,
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
          -1,
          -1
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
        -2,
        1,
        -3,
        4,
        -1,
        2,
        1,
        -5,
        4
      ]
    ],
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1448,
    '最长湍流子数组',
    '给定整数数组 arr，返回最长湍流子数组的长度。
湍流子数组指相邻元素的大小比较符号交替出现。',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '滑动窗口'],
    $json$[
  {
    "input": "arr = [9, 4, 2, 10, 7, 8, 8, 1, 9]",
    "output": "5"
  },
  {
    "input": "arr = [4, 8, 12, 16]",
    "output": "2"
  },
  {
    "input": "arr = [100]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [9, 4, 2, 10, 7, 8, 8, 1, 9]",
    "output": "5"
  },
  {
    "input": "arr = [4, 8, 12, 16]",
    "output": "2"
  },
  {
    "input": "arr = [100]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxTurbulenceSize = function(arr) {\n};\n",
  "python": "class Solution:\n    def maxTurbulenceSize(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxTurbulenceSize(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxTurbulenceSize(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxTurbulenceSize",
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
          9,
          4,
          2,
          10,
          7,
          8,
          8,
          1,
          9
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        [
          4,
          8,
          12,
          16
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          100
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
    "expected": 2
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
        2,
        1,
        3
      ]
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1449,
    '等差数列划分',
    '返回数组 nums 中所有等差连续子数组的个数。等差连续子数组长度至少为 3。',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "3"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6]",
    "output": "10"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "3"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6]",
    "output": "10"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numberOfArithmeticSlices = function(nums) {\n};\n",
  "python": "class Solution:\n    def numberOfArithmeticSlices(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numberOfArithmeticSlices(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numberOfArithmeticSlices(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numberOfArithmeticSlices",
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
          4
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
          1,
          2,
          3,
          4,
          5,
          6
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
        1,
        3,
        5,
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
        4
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1450,
    '摆动序列',
    '返回数组 nums 中最长摆动子序列的长度。
摆动子序列指相邻元素差值正负交替，长度至少为 1。',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心', '动态规划'],
    $json$[
  {
    "input": "nums = [1, 7, 4, 9, 2, 5]",
    "output": "6"
  },
  {
    "input": "nums = [1, 17, 5, 10, 13, 15, 10, 5, 16, 8]",
    "output": "7"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 7, 4, 9, 2, 5]",
    "output": "6"
  },
  {
    "input": "nums = [1, 17, 5, 10, 13, 15, 10, 5, 16, 8]",
    "output": "7"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var wiggleMaxLength = function(nums) {\n};\n",
  "python": "class Solution:\n    def wiggleMaxLength(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int wiggleMaxLength(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int wiggleMaxLength(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "wiggleMaxLength",
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
          7,
          4,
          9,
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
          17,
          5,
          10,
          13,
          15,
          10,
          5,
          16,
          8
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
          5,
          6,
          7,
          8,
          9
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
        2
      ]
    ],
    "expected": 2
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
        3,
        3,
        3,
        2,
        5
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1451,
    '最长递增子序列的个数',
    '给定未排序的整数数组 nums，返回最长严格递增子序列的个数。',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "nums = [1, 3, 5, 4, 7]",
    "output": "2"
  },
  {
    "input": "nums = [2, 2, 2, 2, 2]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3, 5, 4, 7]",
    "output": "2"
  },
  {
    "input": "nums = [2, 2, 2, 2, 2]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findNumberOfLIS = function(nums) {\n};\n",
  "python": "class Solution:\n    def findNumberOfLIS(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findNumberOfLIS(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findNumberOfLIS(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findNumberOfLIS",
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
          5,
          4,
          7
        ]
      ],
      "expected": 2
    },
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
      "expected": 5
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
        2
      ]
    ],
    "expected": 3
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
  }
]$json$::jsonb,
    'approved'
),
(
    1452,
    '无重叠区间',
    '给定区间数组 intervals，返回移除最少区间数，使剩余区间互不重叠。
端点相接不算重叠。',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心', '排序'],
    $json$[
  {
    "input": "intervals = [[1, 2], [2, 3], [3, 4], [1, 3]]",
    "output": "1"
  },
  {
    "input": "intervals = [[1, 2], [1, 2], [1, 2]]",
    "output": "2"
  },
  {
    "input": "intervals = [[1, 2], [2, 3]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "intervals = [[1, 2], [2, 3], [3, 4], [1, 3]]",
    "output": "1"
  },
  {
    "input": "intervals = [[1, 2], [1, 2], [1, 2]]",
    "output": "2"
  },
  {
    "input": "intervals = [[1, 2], [2, 3]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var eraseOverlapIntervals = function(intervals) {\n};\n",
  "python": "class Solution:\n    def eraseOverlapIntervals(self, intervals: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int eraseOverlapIntervals(std::vector<std::vector<int>>& intervals) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int eraseOverlapIntervals(int[][] intervals) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "eraseOverlapIntervals",
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
            2
          ],
          [
            2,
            3
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
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1453,
    '用最少数量的箭引爆气球',
    '气球区间 points[i] = [xstart, xend]。箭从 x 轴垂直射出，可引爆区间包含该点的气球。
返回引爆所有气球的最少箭数。',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心', '排序'],
    $json$[
  {
    "input": "points = [[10, 16], [2, 8], [1, 6], [7, 12]]",
    "output": "2"
  },
  {
    "input": "points = [[1, 2], [3, 4], [5, 6], [7, 8]]",
    "output": "4"
  },
  {
    "input": "points = [[1, 2], [2, 3], [3, 4], [4, 5]]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "points = [[10, 16], [2, 8], [1, 6], [7, 12]]",
    "output": "2"
  },
  {
    "input": "points = [[1, 2], [3, 4], [5, 6], [7, 8]]",
    "output": "4"
  },
  {
    "input": "points = [[1, 2], [2, 3], [3, 4], [4, 5]]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findMinArrowShots = function(points) {\n};\n",
  "python": "class Solution:\n    def findMinArrowShots(self, points: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findMinArrowShots(std::vector<std::vector<int>>& points) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findMinArrowShots(int[][] points) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findMinArrowShots",
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
            10,
            16
          ],
          [
            2,
            8
          ],
          [
            1,
            6
          ],
          [
            7,
            12
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
    "expected": 1
  },
  {
    "args": [
      [
        [
          1,
          10
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
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1454,
    '根据身高重建队列',
    '给定数组 people，people[i] = [height, k] 表示第 i 人的身高和前面身高大于等于他的人数。
返回重建后的队列（保证唯一）。',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心', '排序'],
    $json$[
  {
    "input": "people = [[7, 0], [4, 4], [7, 1], [5, 0], [6, 1], [5, 2]]",
    "output": "[[5, 0], [7, 0], [5, 2], [6, 1], [4, 4], [7, 1]]"
  },
  {
    "input": "people = [[6, 0], [5, 0], [4, 0], [3, 2], [2, 2], [1, 4]]",
    "output": "[[4, 0], [5, 0], [2, 2], [3, 2], [1, 4], [6, 0]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "people = [[7, 0], [4, 4], [7, 1], [5, 0], [6, 1], [5, 2]]",
    "output": "[[5, 0], [7, 0], [5, 2], [6, 1], [4, 4], [7, 1]]"
  },
  {
    "input": "people = [[6, 0], [5, 0], [4, 0], [3, 2], [2, 2], [1, 4]]",
    "output": "[[4, 0], [5, 0], [2, 2], [3, 2], [1, 4], [6, 0]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var reconstructQueue = function(people) {\n};\n",
  "python": "class Solution:\n    def reconstructQueue(self, people: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> reconstructQueue(std::vector<std::vector<int>>& people) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] reconstructQueue(int[][] people) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reconstructQueue",
  "params": [
    {
      "name": "people",
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
            7,
            0
          ],
          [
            4,
            4
          ],
          [
            7,
            1
          ],
          [
            5,
            0
          ],
          [
            6,
            1
          ],
          [
            5,
            2
          ]
        ]
      ],
      "expected": [
        [
          5,
          0
        ],
        [
          7,
          0
        ],
        [
          5,
          2
        ],
        [
          6,
          1
        ],
        [
          4,
          4
        ],
        [
          7,
          1
        ]
      ]
    },
    {
      "args": [
        [
          [
            6,
            0
          ],
          [
            5,
            0
          ],
          [
            4,
            0
          ],
          [
            3,
            2
          ],
          [
            2,
            2
          ],
          [
            1,
            4
          ]
        ]
      ],
      "expected": [
        [
          4,
          0
        ],
        [
          5,
          0
        ],
        [
          2,
          2
        ],
        [
          3,
          2
        ],
        [
          1,
          4
        ],
        [
          6,
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
          0
        ]
      ]
    ],
    "expected": [
      [
        1,
        0
      ]
    ]
  },
  {
    "args": [
      [
        [
          2,
          0
        ],
        [
          1,
          0
        ]
      ]
    ],
    "expected": [
      [
        1,
        0
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
          0
        ],
        [
          2,
          0
        ]
      ]
    ],
    "expected": [
      [
        2,
        0
      ],
      [
        3,
        0
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1455,
    '任务调度器',
    '给定字符数组 tasks 表示任务类型，相同任务之间至少间隔 n 个时间单位。
返回完成所有任务所需的最短时间。',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心', '堆'],
    $json$[
  {
    "input": "tasks = [\"A\", \"A\", \"A\", \"B\", \"B\", \"B\"], n = 2",
    "output": "8"
  },
  {
    "input": "tasks = [\"A\", \"A\", \"A\", \"B\", \"B\", \"B\"], n = 0",
    "output": "6"
  },
  {
    "input": "tasks = [\"A\", \"A\", \"A\", \"A\", \"A\", \"A\", \"B\", \"C\", \"D\", \"E\", \"F\", \"G\"], n = 2",
    "output": "16"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "tasks = [\"A\", \"A\", \"A\", \"B\", \"B\", \"B\"], n = 2",
    "output": "8"
  },
  {
    "input": "tasks = [\"A\", \"A\", \"A\", \"B\", \"B\", \"B\"], n = 0",
    "output": "6"
  },
  {
    "input": "tasks = [\"A\", \"A\", \"A\", \"A\", \"A\", \"A\", \"B\", \"C\", \"D\", \"E\", \"F\", \"G\"], n = 2",
    "output": "16"
  }
]$json$::jsonb,
    $json${
  "javascript": "var leastInterval = function(tasks, n) {\n};\n",
  "python": "class Solution:\n    def leastInterval(self, tasks: list[str], n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int leastInterval(std::vector<std::string>& tasks, int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int leastInterval(String[] tasks, int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "leastInterval",
  "params": [
    {
      "name": "tasks",
      "type": "string[]"
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
          "A",
          "A",
          "A",
          "B",
          "B",
          "B"
        ],
        2
      ],
      "expected": 8
    },
    {
      "args": [
        [
          "A",
          "A",
          "A",
          "B",
          "B",
          "B"
        ],
        0
      ],
      "expected": 6
    },
    {
      "args": [
        [
          "A",
          "A",
          "A",
          "A",
          "A",
          "A",
          "B",
          "C",
          "D",
          "E",
          "F",
          "G"
        ],
        2
      ],
      "expected": 16
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "A"
      ],
      0
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "A",
        "A"
      ],
      2
    ],
    "expected": 4
  },
  {
    "args": [
      [
        "A",
        "B"
      ],
      2
    ],
    "expected": 2
  },
  {
    "args": [
      [
        "A",
        "A",
        "B",
        "B"
      ],
      1
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1456,
    '单调递增的数字',
    '给定非负整数 n，返回小于等于 n 的最大单调递增整数。
单调递增整数指从左到右每位数字非递减。',
    'medium',
    1000,
    256,
    ARRAY['贪心', '数学'],
    $json$[
  {
    "input": "n = 10",
    "output": "9"
  },
  {
    "input": "n = 1234",
    "output": "1234"
  },
  {
    "input": "n = 332",
    "output": "299"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 10",
    "output": "9"
  },
  {
    "input": "n = 1234",
    "output": "1234"
  },
  {
    "input": "n = 332",
    "output": "299"
  }
]$json$::jsonb,
    $json${
  "javascript": "var monotoneIncreasingDigits = function(n) {\n};\n",
  "python": "class Solution:\n    def monotoneIncreasingDigits(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int monotoneIncreasingDigits(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int monotoneIncreasingDigits(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "monotoneIncreasingDigits",
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
      "expected": 9
    },
    {
      "args": [
        1234
      ],
      "expected": 1234
    },
    {
      "args": [
        332
      ],
      "expected": 299
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
      9
    ],
    "expected": 9
  },
  {
    "args": [
      100
    ],
    "expected": 99
  },
  {
    "args": [
      999
    ],
    "expected": 999
  },
  {
    "args": [
      120
    ],
    "expected": 119
  }
]$json$::jsonb,
    'approved'
),
(
    1457,
    '判断二分图',
    '给定无向图的邻接表 graph，判断该图是否为二分图。',
    'medium',
    1000,
    256,
    ARRAY['图', '广度优先搜索', '深度优先搜索'],
    $json$[
  {
    "input": "graph = [[1, 2, 3], [0, 2], [0, 1, 3], [0, 2]]",
    "output": "false"
  },
  {
    "input": "graph = [[1, 3], [0, 2], [1, 3], [0, 2]]",
    "output": "true"
  },
  {
    "input": "graph = [[]]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "graph = [[1, 2, 3], [0, 2], [0, 1, 3], [0, 2]]",
    "output": "false"
  },
  {
    "input": "graph = [[1, 3], [0, 2], [1, 3], [0, 2]]",
    "output": "true"
  },
  {
    "input": "graph = [[]]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isBipartite = function(graph) {\n};\n",
  "python": "class Solution:\n    def isBipartite(self, graph: list[list[int]]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isBipartite(std::vector<std::vector<int>>& graph) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isBipartite(int[][] graph) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isBipartite",
  "params": [
    {
      "name": "graph",
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
            3
          ],
          [
            0,
            2
          ],
          [
            0,
            1,
            3
          ],
          [
            0,
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
            3
          ],
          [
            0,
            2
          ],
          [
            1,
            3
          ],
          [
            0,
            2
          ]
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          []
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
          0,
          2
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
        []
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1458,
    '找到最终的安全状态',
    '有向图 graph[i] 是节点 i 的出边列表。安全节点指从该节点出发的所有路径都终止于终端节点。
返回所有安全节点，按升序排列。',
    'medium',
    1000,
    256,
    ARRAY['图', '深度优先搜索', '拓扑排序'],
    $json$[
  {
    "input": "graph = [[1, 2], [2, 3], [5], [0], [5], [], []]",
    "output": "[2, 4, 5, 6]"
  },
  {
    "input": "graph = [[1, 2, 3, 4], [1, 2], [3, 4], [0, 4], []]",
    "output": "[4]"
  },
  {
    "input": "graph = [[]]",
    "output": "[0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "graph = [[1, 2], [2, 3], [5], [0], [5], [], []]",
    "output": "[2, 4, 5, 6]"
  },
  {
    "input": "graph = [[1, 2, 3, 4], [1, 2], [3, 4], [0, 4], []]",
    "output": "[4]"
  },
  {
    "input": "graph = [[]]",
    "output": "[0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var eventualSafeNodes = function(graph) {\n};\n",
  "python": "class Solution:\n    def eventualSafeNodes(self, graph: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> eventualSafeNodes(std::vector<std::vector<int>>& graph) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] eventualSafeNodes(int[][] graph) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "eventualSafeNodes",
  "params": [
    {
      "name": "graph",
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
            2,
            3
          ],
          [
            5
          ],
          [
            0
          ],
          [
            5
          ],
          [],
          []
        ]
      ],
      "expected": [
        2,
        4,
        5,
        6
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
            1,
            2
          ],
          [
            3,
            4
          ],
          [
            0,
            4
          ],
          []
        ]
      ],
      "expected": [
        4
      ]
    },
    {
      "args": [
        [
          []
        ]
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
      [
        [
          1
        ],
        [
          2
        ],
        []
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
          1,
          2
        ],
        [
          2,
          3
        ],
        [],
        [
          3
        ]
      ]
    ],
    "expected": [
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1459,
    '省份数量',
    '给定 n x n 的邻接矩阵 isConnected，返回省份数量（连通分量数）。',
    'medium',
    1000,
    256,
    ARRAY['图', '并查集', '深度优先搜索'],
    $json$[
  {
    "input": "isConnected = [[1, 1, 0], [1, 1, 0], [0, 0, 1]]",
    "output": "2"
  },
  {
    "input": "isConnected = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]",
    "output": "3"
  },
  {
    "input": "isConnected = [[1, 0, 0, 1], [0, 1, 1, 0], [0, 1, 1, 0], [1, 0, 0, 1]]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "isConnected = [[1, 1, 0], [1, 1, 0], [0, 0, 1]]",
    "output": "2"
  },
  {
    "input": "isConnected = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]",
    "output": "3"
  },
  {
    "input": "isConnected = [[1, 0, 0, 1], [0, 1, 1, 0], [0, 1, 1, 0], [1, 0, 0, 1]]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findCircleNum = function(isConnected) {\n};\n",
  "python": "class Solution:\n    def findCircleNum(self, isConnected: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findCircleNum(std::vector<std::vector<int>>& isConnected) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findCircleNum(int[][] isConnected) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findCircleNum",
  "params": [
    {
      "name": "isConnected",
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
            0
          ],
          [
            1,
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
      "expected": 2
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
      "expected": 3
    },
    {
      "args": [
        [
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
            0
          ],
          [
            0,
            1,
            1,
            0
          ],
          [
            1,
            0,
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
  }
]$json$::jsonb,
    'approved'
),
(
    1460,
    '最大子矩阵',
    '给定一个整数矩阵 matrix，返回其中和最大的子矩阵的元素和。',
    'hard',
    1000,
    256,
    ARRAY['数组', '矩阵', '动态规划', '前缀和'],
    $json$[
  {
    "input": "matrix = [[1, 2, -1], [-3, 4, 5], [1, -2, 3]]",
    "output": "11"
  },
  {
    "input": "matrix = [[1, 2], [3, 4]]",
    "output": "10"
  },
  {
    "input": "matrix = [[-1]]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[1, 2, -1], [-3, 4, 5], [1, -2, 3]]",
    "output": "11"
  },
  {
    "input": "matrix = [[1, 2], [3, 4]]",
    "output": "10"
  },
  {
    "input": "matrix = [[-1]]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxSubMatrixSum = function(matrix) {\n};\n",
  "python": "class Solution:\n    def maxSubMatrixSum(self, matrix: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxSubMatrixSum(std::vector<std::vector<int>>& matrix) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxSubMatrixSum(int[][] matrix) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxSubMatrixSum",
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
            2,
            -1
          ],
          [
            -3,
            4,
            5
          ],
          [
            1,
            -2,
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
            -1
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
          -1,
          -2
        ],
        [
          -3,
          -4
        ]
      ]
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
        ],
        [
          5,
          6
        ]
      ]
    ],
    "expected": 21
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
]$json$::jsonb,
    'approved'
),
(
    1461,
    '最短回文串',
    '给定字符串 s，通过在 s 前面添加字符，将其变成回文串。返回能得到的最短回文串。',
    'hard',
    1000,
    256,
    ARRAY['字符串', '字符串匹配', '哈希函数'],
    $json$[
  {
    "input": "s = \"aacecaaa\"",
    "output": "\"aaacecaaa\""
  },
  {
    "input": "s = \"abcd\"",
    "output": "\"dcbabcd\""
  },
  {
    "input": "s = \"a\"",
    "output": "\"a\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aacecaaa\"",
    "output": "\"aaacecaaa\""
  },
  {
    "input": "s = \"abcd\"",
    "output": "\"dcbabcd\""
  },
  {
    "input": "s = \"a\"",
    "output": "\"a\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var shortestPalindrome = function(s) {\n};\n",
  "python": "class Solution:\n    def shortestPalindrome(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string shortestPalindrome(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String shortestPalindrome(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "shortestPalindrome",
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
        "aacecaaa"
      ],
      "expected": "aaacecaaa"
    },
    {
      "args": [
        "abcd"
      ],
      "expected": "dcbabcd"
    },
    {
      "args": [
        "a"
      ],
      "expected": "a"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      ""
    ],
    "expected": ""
  },
  {
    "args": [
      "aa"
    ],
    "expected": "aa"
  },
  {
    "args": [
      "aba"
    ],
    "expected": "aba"
  },
  {
    "args": [
      "abab"
    ],
    "expected": "babab"
  }
]$json$::jsonb,
    'approved'
),
(
    1462,
    '青蛙过河',
    '一条河被分成若干单元，石头位置由升序数组 stones 给出。
青蛙从第一块石头出发，每次跳跃的距离必须是上一次跳跃距离减一、不变或加一。判断能否到达最后一块石头。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '记忆化搜索'],
    $json$[
  {
    "input": "stones = [0, 1, 3, 5, 6, 8, 12, 17]",
    "output": "true"
  },
  {
    "input": "stones = [0, 1, 2, 3, 4, 8, 9, 11]",
    "output": "false"
  },
  {
    "input": "stones = [0, 2]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "stones = [0, 1, 3, 5, 6, 8, 12, 17]",
    "output": "true"
  },
  {
    "input": "stones = [0, 1, 2, 3, 4, 8, 9, 11]",
    "output": "false"
  },
  {
    "input": "stones = [0, 2]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canCross = function(stones) {\n};\n",
  "python": "class Solution:\n    def canCross(self, stones: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canCross(std::vector<int>& stones) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canCross(int[] stones) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canCross",
  "params": [
    {
      "name": "stones",
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
          1,
          3,
          5,
          6,
          8,
          12,
          17
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
          3,
          4,
          8,
          9,
          11
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          0,
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
        0
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
    "expected": true
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
    "expected": true
  },
  {
    "args": [
      [
        0,
        1,
        3,
        6,
        10,
        15,
        21
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1463,
    '滑动窗口中位数',
    '给定整数数组 nums 和窗口大小 k，窗口从最左侧滑动到最右侧。
返回每个窗口的中位数组成的数组，答案与标准答案误差在 1e-6 以内即视为正确。',
    'hard',
    1000,
    256,
    ARRAY['数组', '哈希表', '滑动窗口', '堆'],
    $json$[
  {
    "input": "nums = [1, 3, -1, -3, 5, 3, 6, 7], k = 3",
    "output": "[1.0, -1.0, -1.0, 3.0, 5.0, 6.0]"
  },
  {
    "input": "nums = [1, 2], k = 1",
    "output": "[1.0, 2.0]"
  },
  {
    "input": "nums = [1, 2, 3, 4], k = 2",
    "output": "[1.5, 2.5, 3.5]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3, -1, -3, 5, 3, 6, 7], k = 3",
    "output": "[1.0, -1.0, -1.0, 3.0, 5.0, 6.0]"
  },
  {
    "input": "nums = [1, 2], k = 1",
    "output": "[1.0, 2.0]"
  },
  {
    "input": "nums = [1, 2, 3, 4], k = 2",
    "output": "[1.5, 2.5, 3.5]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var medianSlidingWindow = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def medianSlidingWindow(self, nums: list[int], k: int) -> list[float]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<double> medianSlidingWindow(std::vector<int>& nums, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public double[] medianSlidingWindow(int[] nums, int k) {\n        return new double[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "medianSlidingWindow",
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
  "return_type": "double[]",
  "compare": {
    "mode": "double"
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
        1.0,
        -1.0,
        -1.0,
        3.0,
        5.0,
        6.0
      ]
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
        1.0,
        2.0
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
        1.5,
        2.5,
        3.5
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
      1
    ],
    "expected": [
      1.0
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
      1.5
    ]
  },
  {
    "args": [
      [
        5,
        2,
        4
      ],
      3
    ],
    "expected": [
      4.0
    ]
  },
  {
    "args": [
      [
        1,
        3,
        2,
        4,
        5
      ],
      3
    ],
    "expected": [
      2.0,
      3.0,
      4.0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1464,
    '最小窗口子序列',
    '给定字符串 s1 和 s2，返回 s1 中最短的子串，使 s2 是这个子串的子序列。
不存在这样的子串返回 -1。',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划', '滑动窗口'],
    $json$[
  {
    "input": "s1 = \"abcdebdde\", s2 = \"bde\"",
    "output": "4"
  },
  {
    "input": "s1 = \"jmeqksfrsdcmsiwvaovxtkwm\", s2 = \"k\"",
    "output": "1"
  },
  {
    "input": "s1 = \"abc\", s2 = \"abc\"",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s1 = \"abcdebdde\", s2 = \"bde\"",
    "output": "4"
  },
  {
    "input": "s1 = \"jmeqksfrsdcmsiwvaovxtkwm\", s2 = \"k\"",
    "output": "1"
  },
  {
    "input": "s1 = \"abc\", s2 = \"abc\"",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minWindowSubsequence = function(s1, s2) {\n};\n",
  "python": "class Solution:\n    def minWindowSubsequence(self, s1: str, s2: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minWindowSubsequence(std::string s1, std::string s2) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minWindowSubsequence(String s1, String s2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minWindowSubsequence",
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
        "abcdebdde",
        "bde"
      ],
      "expected": 4
    },
    {
      "args": [
        "jmeqksfrsdcmsiwvaovxtkwm",
        "k"
      ],
      "expected": 1
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
      "abc",
      "d"
    ],
    "expected": -1
  },
  {
    "args": [
      "ab",
      "a"
    ],
    "expected": 1
  },
  {
    "args": [
      "ab",
      "b"
    ],
    "expected": 1
  },
  {
    "args": [
      "aaaa",
      "aa"
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1465,
    '鸡蛋掉落',
    '有 k 枚相同的鸡蛋和一栋 n 层楼。已知存在楼层 f，从 f 及以下扔鸡蛋不会碎。
每次可以取一枚鸡蛋从任意楼层扔下，返回确定 f 所需的最少操作次数。',
    'hard',
    1000,
    256,
    ARRAY['数学', '二分查找', '动态规划'],
    $json$[
  {
    "input": "k = 1, n = 2",
    "output": "2"
  },
  {
    "input": "k = 2, n = 6",
    "output": "3"
  },
  {
    "input": "k = 3, n = 14",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "k = 1, n = 2",
    "output": "2"
  },
  {
    "input": "k = 2, n = 6",
    "output": "3"
  },
  {
    "input": "k = 3, n = 14",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var superEggDrop = function(k, n) {\n};\n",
  "python": "class Solution:\n    def superEggDrop(self, k: int, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int superEggDrop(int k, int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int superEggDrop(int k, int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "superEggDrop",
  "params": [
    {
      "name": "k",
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
        1,
        2
      ],
      "expected": 2
    },
    {
      "args": [
        2,
        6
      ],
      "expected": 3
    },
    {
      "args": [
        3,
        14
      ],
      "expected": 4
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
      10
    ],
    "expected": 4
  },
  {
    "args": [
      3,
      100
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1466,
    '分割回文串 II',
    '给定字符串 s，返回将 s 分割成若干回文子串所需的最少分割次数。',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "s = \"aab\"",
    "output": "1"
  },
  {
    "input": "s = \"a\"",
    "output": "0"
  },
  {
    "input": "s = \"ab\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aab\"",
    "output": "1"
  },
  {
    "input": "s = \"a\"",
    "output": "0"
  },
  {
    "input": "s = \"ab\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minCut = function(s) {\n};\n",
  "python": "class Solution:\n    def minCut(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minCut(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minCut(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minCut",
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
        "aab"
      ],
      "expected": 1
    },
    {
      "args": [
        "a"
      ],
      "expected": 0
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
      "aa"
    ],
    "expected": 0
  },
  {
    "args": [
      "abc"
    ],
    "expected": 2
  },
  {
    "args": [
      "abba"
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1467,
    '删除无效的括号',
    '给定只含字母和括号的字符串 s，删除最少数量的无效括号，使字符串有效。
返回所有可能的结果，按字典序升序排列。',
    'hard',
    1000,
    256,
    ARRAY['广度优先搜索', '字符串', '回溯'],
    $json$[
  {
    "input": "s = \"()())()\"",
    "output": "[\"(())()\", \"()()()\"]"
  },
  {
    "input": "s = \"(a)())()\"",
    "output": "[\"(a())()\", \"(a)()()\"]"
  },
  {
    "input": "s = \")(\"",
    "output": "[\"\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"()())()\"",
    "output": "[\"(())()\", \"()()()\"]"
  },
  {
    "input": "s = \"(a)())()\"",
    "output": "[\"(a())()\", \"(a)()()\"]"
  },
  {
    "input": "s = \")(\"",
    "output": "[\"\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeInvalidParentheses = function(s) {\n};\n",
  "python": "class Solution:\n    def removeInvalidParentheses(self, s: str) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> removeInvalidParentheses(std::string s) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] removeInvalidParentheses(String s) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeInvalidParentheses",
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
        "()())()"
      ],
      "expected": [
        "(())()",
        "()()()"
      ]
    },
    {
      "args": [
        "(a)())()"
      ],
      "expected": [
        "(a())()",
        "(a)()()"
      ]
    },
    {
      "args": [
        ")("
      ],
      "expected": [
        ""
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      ""
    ],
    "expected": [
      ""
    ]
  },
  {
    "args": [
      "()"
    ],
    "expected": [
      "()"
    ]
  },
  {
    "args": [
      "(("
    ],
    "expected": [
      ""
    ]
  },
  {
    "args": [
      "))"
    ],
    "expected": [
      ""
    ]
  },
  {
    "args": [
      "(a)(b)"
    ],
    "expected": [
      "(a)(b)"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1468,
    '拼接最大数',
    '给定两个整数数组 nums1 和 nums2，以及整数 k。
从两个数组中按原顺序共选出 k 个数字拼接，返回能得到的最大的数。',
    'hard',
    1000,
    256,
    ARRAY['栈', '贪心', '数组', '单调栈'],
    $json$[
  {
    "input": "nums1 = [3, 4, 6, 5], nums2 = [9, 1, 2, 5, 8, 3], k = 5",
    "output": "[9, 8, 6, 5, 3]"
  },
  {
    "input": "nums1 = [6, 7], nums2 = [6, 0, 4], k = 5",
    "output": "[6, 7, 6, 0, 4]"
  },
  {
    "input": "nums1 = [3, 9], nums2 = [8, 9], k = 3",
    "output": "[9, 8, 9]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums1 = [3, 4, 6, 5], nums2 = [9, 1, 2, 5, 8, 3], k = 5",
    "output": "[9, 8, 6, 5, 3]"
  },
  {
    "input": "nums1 = [6, 7], nums2 = [6, 0, 4], k = 5",
    "output": "[6, 7, 6, 0, 4]"
  },
  {
    "input": "nums1 = [3, 9], nums2 = [8, 9], k = 3",
    "output": "[9, 8, 9]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxNumber = function(nums1, nums2, k) {\n};\n",
  "python": "class Solution:\n    def maxNumber(self, nums1: list[int], nums2: list[int], k: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> maxNumber(std::vector<int>& nums1, std::vector<int>& nums2, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] maxNumber(int[] nums1, int[] nums2, int k) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxNumber",
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
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          3,
          4,
          6,
          5
        ],
        [
          9,
          1,
          2,
          5,
          8,
          3
        ],
        5
      ],
      "expected": [
        9,
        8,
        6,
        5,
        3
      ]
    },
    {
      "args": [
        [
          6,
          7
        ],
        [
          6,
          0,
          4
        ],
        5
      ],
      "expected": [
        6,
        7,
        6,
        0,
        4
      ]
    },
    {
      "args": [
        [
          3,
          9
        ],
        [
          8,
          9
        ],
        3
      ],
      "expected": [
        9,
        8,
        9
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
        1
      ],
      [
        2
      ],
      2
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
        2
      ],
      [
        3,
        4
      ],
      2
    ],
    "expected": [
      4,
      2
    ]
  },
  {
    "args": [
      [
        5,
        6
      ],
      [
        7,
        8
      ],
      4
    ],
    "expected": [
      7,
      8,
      5,
      6
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1469,
    '有效的括号字符串',
    '给定只含 ''(''、'')'' 和 ''*'' 的字符串 s，''*'' 可以视为 ''(''、'')'' 或空字符。
判断 s 是否为有效括号字符串。',
    'hard',
    1000,
    256,
    ARRAY['栈', '字符串', '贪心', '动态规划'],
    $json$[
  {
    "input": "s = \"()\"",
    "output": "true"
  },
  {
    "input": "s = \"(*)\"",
    "output": "true"
  },
  {
    "input": "s = \"(*))\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"()\"",
    "output": "true"
  },
  {
    "input": "s = \"(*)\"",
    "output": "true"
  },
  {
    "input": "s = \"(*))\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var checkValidString = function(s) {\n};\n",
  "python": "class Solution:\n    def checkValidString(self, s: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool checkValidString(std::string s) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean checkValidString(String s) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkValidString",
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
        "()"
      ],
      "expected": true
    },
    {
      "args": [
        "(*)"
      ],
      "expected": true
    },
    {
      "args": [
        "(*))"
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      ""
    ],
    "expected": true
  },
  {
    "args": [
      "*"
    ],
    "expected": true
  },
  {
    "args": [
      "("
    ],
    "expected": false
  },
  {
    "args": [
      ")"
    ],
    "expected": false
  },
  {
    "args": [
      "(*"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1470,
    '至少有 K 个重复字符的最长子串',
    '给定字符串 s 和整数 k，返回 s 中最长的子串长度，要求子串中每个字符出现次数都不少于 k。
不存在这样的子串返回 0。',
    'hard',
    1000,
    256,
    ARRAY['哈希表', '字符串', '分治', '滑动窗口'],
    $json$[
  {
    "input": "s = \"aaabb\", k = 3",
    "output": "3"
  },
  {
    "input": "s = \"ababbc\", k = 2",
    "output": "5"
  },
  {
    "input": "s = \"abc\", k = 2",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aaabb\", k = 3",
    "output": "3"
  },
  {
    "input": "s = \"ababbc\", k = 2",
    "output": "5"
  },
  {
    "input": "s = \"abc\", k = 2",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestSubstringK = function(s, k) {\n};\n",
  "python": "class Solution:\n    def longestSubstringK(self, s: str, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestSubstringK(std::string s, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestSubstringK(String s, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestSubstringK",
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
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "aaabb",
        3
      ],
      "expected": 3
    },
    {
      "args": [
        "ababbc",
        2
      ],
      "expected": 5
    },
    {
      "args": [
        "abc",
        2
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      1
    ],
    "expected": 1
  },
  {
    "args": [
      "aa",
      2
    ],
    "expected": 2
  },
  {
    "args": [
      "ab",
      2
    ],
    "expected": 0
  },
  {
    "args": [
      "aaabbb",
      3
    ],
    "expected": 6
  }
]$json$::jsonb,
    'approved'
),
(
    1471,
    '二叉树中的最长交错路径',
    '给定二叉树的根节点 root，返回树中最长交错路径的长度。
交错路径指从某节点出发，先向左再向右、再向左，如此交替的路径。长度按经过的边数计算。',
    'hard',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '动态规划', '二叉树'],
    $json$[
  {
    "input": "root = [1, null, 1, 1, 1, null, null, 1, 1, null, 1, null, null, null, 1]",
    "output": "3"
  },
  {
    "input": "root = [1, 1, 1]",
    "output": "1"
  },
  {
    "input": "root = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, null, 1, 1, 1, null, null, 1, 1, null, 1, null, null, null, 1]",
    "output": "3"
  },
  {
    "input": "root = [1, 1, 1]",
    "output": "1"
  },
  {
    "input": "root = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar longestZigZag = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def longestZigZag(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int longestZigZag(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int longestZigZag(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestZigZag",
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
          null,
          1,
          1,
          1,
          null,
          null,
          1,
          1,
          null,
          1,
          null,
          null,
          null,
          1
        ]
      ],
      "expected": 3
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
        null,
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
        null,
        1
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1472,
    '单词搜索 II',
    '给定 m x n 字符矩阵 board 和单词列表 words，返回所有同时在矩阵中的单词。
单词必须由相邻格子的字母按顺序连接，同一格子不能重复使用。结果按字典序升序排列。',
    'hard',
    1000,
    256,
    ARRAY['字典树', '数组', '字符串', '回溯', '矩阵'],
    $json$[
  {
    "input": "board = [[\"o\", \"a\", \"a\", \"n\"], [\"e\", \"t\", \"a\", \"e\"], [\"i\", \"h\", \"k\", \"r\"], [\"i\", \"f\", \"l\", \"v\"]], words = [\"oath\", \"pea\", \"eat\", \"rain\"]",
    "output": "[\"eat\", \"oath\"]"
  },
  {
    "input": "board = [[\"a\", \"b\"], [\"c\", \"d\"]], words = [\"abcb\"]",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "board = [[\"o\", \"a\", \"a\", \"n\"], [\"e\", \"t\", \"a\", \"e\"], [\"i\", \"h\", \"k\", \"r\"], [\"i\", \"f\", \"l\", \"v\"]], words = [\"oath\", \"pea\", \"eat\", \"rain\"]",
    "output": "[\"eat\", \"oath\"]"
  },
  {
    "input": "board = [[\"a\", \"b\"], [\"c\", \"d\"]], words = [\"abcb\"]",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findWords = function(board, words) {\n};\n",
  "python": "class Solution:\n    def findWords(self, board: list[list[str]], words: list[str]) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> findWords(std::vector<std::vector<std::string>>& board, std::vector<std::string>& words) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] findWords(String[][] board, String[] words) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findWords",
  "params": [
    {
      "name": "board",
      "type": "string[][]"
    },
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
          [
            "o",
            "a",
            "a",
            "n"
          ],
          [
            "e",
            "t",
            "a",
            "e"
          ],
          [
            "i",
            "h",
            "k",
            "r"
          ],
          [
            "i",
            "f",
            "l",
            "v"
          ]
        ],
        [
          "oath",
          "pea",
          "eat",
          "rain"
        ]
      ],
      "expected": [
        "eat",
        "oath"
      ]
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
        [
          "abcb"
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
        [
          "a"
        ]
      ],
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
        [
          "a",
          "b"
        ],
        [
          "c",
          "d"
        ]
      ],
      [
        "ab",
        "cd",
        "ac",
        "bd"
      ]
    ],
    "expected": [
      "ab",
      "ac",
      "bd",
      "cd"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1473,
    '水位上升的泳池中游泳',
    '给定 n x n 的矩阵 grid，grid[i][j] 表示该位置的高度。
从左上角出发，当水位达到时间 t 时，可以移动到高度不超过 t 的相邻格子。返回到达右下角的最早时间。',
    'hard',
    1000,
    256,
    ARRAY['深度优先搜索', '广度优先搜索', '并查集', '堆', '矩阵'],
    $json$[
  {
    "input": "grid = [[0, 2], [1, 3]]",
    "output": "3"
  },
  {
    "input": "grid = [[0, 1, 2, 3, 4], [24, 23, 22, 21, 5], [12, 13, 14, 15, 16], [11, 17, 18, 19, 20], [10, 9, 8, 7, 6]]",
    "output": "16"
  },
  {
    "input": "grid = [[0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[0, 2], [1, 3]]",
    "output": "3"
  },
  {
    "input": "grid = [[0, 1, 2, 3, 4], [24, 23, 22, 21, 5], [12, 13, 14, 15, 16], [11, 17, 18, 19, 20], [10, 9, 8, 7, 6]]",
    "output": "16"
  },
  {
    "input": "grid = [[0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var swimInWater = function(grid) {\n};\n",
  "python": "class Solution:\n    def swimInWater(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int swimInWater(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int swimInWater(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "swimInWater",
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
            2
          ],
          [
            1,
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
            0,
            1,
            2,
            3,
            4
          ],
          [
            24,
            23,
            22,
            21,
            5
          ],
          [
            12,
            13,
            14,
            15,
            16
          ],
          [
            11,
            17,
            18,
            19,
            20
          ],
          [
            10,
            9,
            8,
            7,
            6
          ]
        ]
      ],
      "expected": 16
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
          0,
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
          1
        ],
        [
          3,
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
    1474,
    '区间和的个数',
    '给定整数数组 nums、整数 lower 和 upper，返回和位于 [lower, upper] 之间的子数组个数。',
    'hard',
    1000,
    256,
    ARRAY['数组', '二分查找', '分治', '归并排序', '树状数组'],
    $json$[
  {
    "input": "nums = [-2, 5, -1], lower = -2, upper = 2",
    "output": "3"
  },
  {
    "input": "nums = [0], lower = 0, upper = 0",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3], lower = 3, upper = 6",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [-2, 5, -1], lower = -2, upper = 2",
    "output": "3"
  },
  {
    "input": "nums = [0], lower = 0, upper = 0",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3], lower = 3, upper = 6",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countRangeSum = function(nums, lower, upper) {\n};\n",
  "python": "class Solution:\n    def countRangeSum(self, nums: list[int], lower: int, upper: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countRangeSum(std::vector<int>& nums, int lower, int upper) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countRangeSum(int[] nums, int lower, int upper) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countRangeSum",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "lower",
      "type": "int"
    },
    {
      "name": "upper",
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
          -2,
          5,
          -1
        ],
        -2,
        2
      ],
      "expected": 3
    },
    {
      "args": [
        [
          0
        ],
        0,
        0
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
        3,
        6
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
      0,
      0
    ],
    "expected": 0
  },
  {
    "args": [
      [
        -1
      ],
      -1,
      -1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        -1
      ],
      0,
      0
    ],
    "expected": 1
  },
  {
    "args": [
      [
        2,
        1
      ],
      1,
      3
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1475,
    '回文对',
    '给定互不相同的字符串数组 words，返回所有下标对 (i, j)，使 words[i] + words[j] 是回文串。
结果按字典序升序排列。',
    'hard',
    1000,
    256,
    ARRAY['字典树', '数组', '哈希表', '字符串'],
    $json$[
  {
    "input": "words = [\"abcd\", \"dcba\", \"lls\", \"s\", \"sssll\"]",
    "output": "[[0, 1], [1, 0], [2, 4], [3, 2]]"
  },
  {
    "input": "words = [\"bat\", \"tab\", \"cat\"]",
    "output": "[[0, 1], [1, 0]]"
  },
  {
    "input": "words = [\"a\", \"\"]",
    "output": "[[0, 1], [1, 0]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"abcd\", \"dcba\", \"lls\", \"s\", \"sssll\"]",
    "output": "[[0, 1], [1, 0], [2, 4], [3, 2]]"
  },
  {
    "input": "words = [\"bat\", \"tab\", \"cat\"]",
    "output": "[[0, 1], [1, 0]]"
  },
  {
    "input": "words = [\"a\", \"\"]",
    "output": "[[0, 1], [1, 0]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var palindromePairs = function(words) {\n};\n",
  "python": "class Solution:\n    def palindromePairs(self, words: list[str]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> palindromePairs(std::vector<std::string>& words) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] palindromePairs(String[] words) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "palindromePairs",
  "params": [
    {
      "name": "words",
      "type": "string[]"
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
          "abcd",
          "dcba",
          "lls",
          "s",
          "sssll"
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
        ],
        [
          2,
          4
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
          "bat",
          "tab",
          "cat"
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
          "a",
          ""
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
        "",
        ""
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
        "ab",
        "ba"
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
        "abc",
        "cba",
        "bca"
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
  }
]$json$::jsonb,
    'approved'
),
(
    1476,
    '跳跃游戏 IV',
    '给定整数数组 arr，从下标 0 出发，每次可以移动到相邻下标，或跳到任意值与当前元素相同的位置。
返回到达最后一个下标的最少跳跃次数。',
    'hard',
    1000,
    256,
    ARRAY['广度优先搜索', '数组', '哈希表'],
    $json$[
  {
    "input": "arr = [100, -23, -23, 404, 100, 23, 23, 23, 3, 404]",
    "output": "3"
  },
  {
    "input": "arr = [7]",
    "output": "0"
  },
  {
    "input": "arr = [7, 6, 9, 6, 9, 6, 9, 7]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [100, -23, -23, 404, 100, 23, 23, 23, 3, 404]",
    "output": "3"
  },
  {
    "input": "arr = [7]",
    "output": "0"
  },
  {
    "input": "arr = [7, 6, 9, 6, 9, 6, 9, 7]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minJumpsIV = function(arr) {\n};\n",
  "python": "class Solution:\n    def minJumpsIV(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minJumpsIV(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minJumpsIV(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minJumpsIV",
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
          100,
          -23,
          -23,
          404,
          100,
          23,
          23,
          23,
          3,
          404
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          7
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          7,
          6,
          9,
          6,
          9,
          6,
          9,
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
        3
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1477,
    '并行课程 III',
    '给定 n 门课程、先修关系 relations 和每门课程所需时间 time。
同一时间可以并行学习多门课程，返回完成所有课程的最短时间。',
    'hard',
    1000,
    256,
    ARRAY['图', '拓扑排序', '动态规划'],
    $json$[
  {
    "input": "n = 3, relations = [[1, 3], [2, 3]], time = [3, 2, 5]",
    "output": "8"
  },
  {
    "input": "n = 5, relations = [[1, 5], [2, 5], [3, 5], [3, 4], [4, 5]], time = [1, 2, 3, 4, 5]",
    "output": "12"
  },
  {
    "input": "n = 1, relations = [], time = [5]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, relations = [[1, 3], [2, 3]], time = [3, 2, 5]",
    "output": "8"
  },
  {
    "input": "n = 5, relations = [[1, 5], [2, 5], [3, 5], [3, 4], [4, 5]], time = [1, 2, 3, 4, 5]",
    "output": "12"
  },
  {
    "input": "n = 1, relations = [], time = [5]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumTime = function(n, relations, time) {\n};\n",
  "python": "class Solution:\n    def minimumTime(self, n: int, relations: list[list[int]], time: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumTime(int n, std::vector<std::vector<int>>& relations, std::vector<int>& time) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumTime(int n, int[][] relations, int[] time) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumTime",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "relations",
      "type": "int[][]"
    },
    {
      "name": "time",
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
        ],
        [
          3,
          2,
          5
        ]
      ],
      "expected": 8
    },
    {
      "args": [
        5,
        [
          [
            1,
            5
          ],
          [
            2,
            5
          ],
          [
            3,
            5
          ],
          [
            3,
            4
          ],
          [
            4,
            5
          ]
        ],
        [
          1,
          2,
          3,
          4,
          5
        ]
      ],
      "expected": 12
    },
    {
      "args": [
        1,
        [],
        [
          5
        ]
      ],
      "expected": 5
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
          2
        ]
      ],
      [
        3,
        4
      ]
    ],
    "expected": 7
  },
  {
    "args": [
      2,
      [],
      [
        1,
        2
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
          2
        ],
        [
          2,
          3
        ]
      ],
      [
        1,
        2,
        3
      ]
    ],
    "expected": 6
  }
]$json$::jsonb,
    'approved'
),
(
    1478,
    'K 个一组翻转链表',
    '给定链表头节点 head 和整数 k，每 k 个节点一组进行翻转。
如果最后剩余节点不足 k 个，则保持原顺序。返回翻转后的链表。',
    'hard',
    1000,
    256,
    ARRAY['链表', '递归'],
    $json$[
  {
    "input": "head = [1, 2, 3, 4, 5], k = 2",
    "output": "[2, 1, 4, 3, 5]"
  },
  {
    "input": "head = [1, 2, 3, 4, 5], k = 3",
    "output": "[3, 2, 1, 4, 5]"
  },
  {
    "input": "head = [1], k = 1",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 2, 3, 4, 5], k = 2",
    "output": "[2, 1, 4, 3, 5]"
  },
  {
    "input": "head = [1, 2, 3, 4, 5], k = 3",
    "output": "[3, 2, 1, 4, 5]"
  },
  {
    "input": "head = [1], k = 1",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar reverseKGroup = function(head, k) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def reverseKGroup(self, head: ListNode | None, k: int) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* reverseKGroup(ListNode* head, int k) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode reverseKGroup(ListNode head, int k) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reverseKGroup",
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
        2,
        1,
        4,
        3,
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
          5
        ],
        3
      ],
      "expected": [
        3,
        2,
        1,
        4,
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
      1,
      2
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
        1,
        2,
        3,
        4
      ],
      2
    ],
    "expected": [
      2,
      1,
      4,
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1479,
    '形成三的最大倍数',
    '给定整数数组 digits，重新排列其中的数字，组成 3 的倍数的最大整数。
结果以字符串形式返回；无法组成返回空字符串。',
    'hard',
    1000,
    256,
    ARRAY['贪心', '数组', '数学', '动态规划'],
    $json$[
  {
    "input": "digits = [8, 1, 9]",
    "output": "\"981\""
  },
  {
    "input": "digits = [8, 6, 7, 1, 0]",
    "output": "\"8760\""
  },
  {
    "input": "digits = [1]",
    "output": "\"0\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "digits = [8, 1, 9]",
    "output": "\"981\""
  },
  {
    "input": "digits = [8, 6, 7, 1, 0]",
    "output": "\"8760\""
  },
  {
    "input": "digits = [1]",
    "output": "\"0\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestMultipleOfThree = function(digits) {\n};\n",
  "python": "class Solution:\n    def largestMultipleOfThree(self, digits: list[int]) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string largestMultipleOfThree(std::vector<int>& digits) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String largestMultipleOfThree(int[] digits) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestMultipleOfThree",
  "params": [
    {
      "name": "digits",
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
          8,
          1,
          9
        ]
      ],
      "expected": "981"
    },
    {
      "args": [
        [
          8,
          6,
          7,
          1,
          0
        ]
      ],
      "expected": "8760"
    },
    {
      "args": [
        [
          1
        ]
      ],
      "expected": "0"
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
    "expected": "0"
  },
  {
    "args": [
      [
        1,
        1,
        1
      ]
    ],
    "expected": "111"
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
    "expected": "111"
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
        1
      ]
    ],
    "expected": "987654321"
  }
]$json$::jsonb,
    'approved'
),
(
    1480,
    '访问所有节点的最短路径',
    '给定无向连通图 graph，节点编号为 0 到 n-1。
返回从任意节点出发、访问所有节点所需的最短路径长度，节点和边可以重复经过。',
    'hard',
    1000,
    256,
    ARRAY['位运算', '广度优先搜索', '图', '动态规划'],
    $json$[
  {
    "input": "graph = [[1, 2, 3], [0], [0], [0]]",
    "output": "4"
  },
  {
    "input": "graph = [[1], [0, 2], [1, 3], [2]]",
    "output": "3"
  },
  {
    "input": "graph = [[1], [0, 2, 4], [1, 3, 4], [2], [1, 2]]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "graph = [[1, 2, 3], [0], [0], [0]]",
    "output": "4"
  },
  {
    "input": "graph = [[1], [0, 2], [1, 3], [2]]",
    "output": "3"
  },
  {
    "input": "graph = [[1], [0, 2, 4], [1, 3, 4], [2], [1, 2]]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var shortestPathAllNodes = function(graph) {\n};\n",
  "python": "class Solution:\n    def shortestPathAllNodes(self, graph: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int shortestPathAllNodes(std::vector<std::vector<int>>& graph) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int shortestPathAllNodes(int[][] graph) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "shortestPathAllNodes",
  "params": [
    {
      "name": "graph",
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
      "expected": 4
    },
    {
      "args": [
        [
          [
            1
          ],
          [
            0,
            2
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
      "expected": 3
    },
    {
      "args": [
        [
          [
            1
          ],
          [
            0,
            2,
            4
          ],
          [
            1,
            3,
            4
          ],
          [
            2
          ],
          [
            1,
            2
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
    "expected": 0
  },
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
          0
        ],
        [
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
          1
        ],
        [
          0,
          2
        ],
        [
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
    1481,
    '数组中的逆序对',
    '给定整数数组 nums，返回数组中逆序对的总数。
逆序对指满足 i < j 且 nums[i] > nums[j] 的下标对。',
    'hard',
    1000,
    256,
    ARRAY['数组', '归并排序', '分治'],
    $json$[
  {
    "input": "nums = [7, 5, 6, 4]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6, 7, 0]",
    "output": "7"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [7, 5, 6, 4]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6, 7, 0]",
    "output": "7"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countInversions = function(nums) {\n};\n",
  "python": "class Solution:\n    def countInversions(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countInversions(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countInversions(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countInversions",
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
          7,
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
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          0
        ]
      ],
      "expected": 7
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
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1482,
    '等差数列划分 II - 子序列',
    '给定整数数组 nums，返回所有等差子序列的个数。
等差子序列长度至少为 3，子序列按下标选择，不要求连续。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "nums = [2, 4, 6, 8, 10]",
    "output": "7"
  },
  {
    "input": "nums = [7, 7, 7, 7, 7]",
    "output": "16"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 4, 6, 8, 10]",
    "output": "7"
  },
  {
    "input": "nums = [7, 7, 7, 7, 7]",
    "output": "16"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numberOfArithmeticSlicesII = function(nums) {\n};\n",
  "python": "class Solution:\n    def numberOfArithmeticSlicesII(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numberOfArithmeticSlicesII(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numberOfArithmeticSlicesII(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numberOfArithmeticSlicesII",
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
          4,
          6,
          8,
          10
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        [
          7,
          7,
          7,
          7,
          7
        ]
      ],
      "expected": 16
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
        5
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
        3,
        4
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1483,
    '赛车',
    '赛车从位置 0、速度 1 出发，目标是到达位置 target。
指令 A：位置增加当前速度，速度翻倍；指令 R：速度变为相反方向。
返回到达目标位置的最少指令数。',
    'hard',
    1000,
    256,
    ARRAY['动态规划', '最短路', '堆'],
    $json$[
  {
    "input": "target = 3",
    "output": "2"
  },
  {
    "input": "target = 6",
    "output": "5"
  },
  {
    "input": "target = 5",
    "output": "7"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "target = 3",
    "output": "2"
  },
  {
    "input": "target = 6",
    "output": "5"
  },
  {
    "input": "target = 5",
    "output": "7"
  }
]$json$::jsonb,
    $json${
  "javascript": "var raceCar = function(target) {\n};\n",
  "python": "class Solution:\n    def raceCar(self, target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int raceCar(int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int raceCar(int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "raceCar",
  "params": [
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
        3
      ],
      "expected": 2
    },
    {
      "args": [
        6
      ],
      "expected": 5
    },
    {
      "args": [
        5
      ],
      "expected": 7
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
    "expected": 4
  },
  {
    "args": [
      4
    ],
    "expected": 5
  },
  {
    "args": [
      10
    ],
    "expected": 7
  }
]$json$::jsonb,
    'approved'
),
(
    1484,
    '猜数字大小 II',
    '在 1 到 n 之间选择一个数字，每次猜一个数字，会被告知偏大、偏小或正确。
无论答案是什么数字，返回确保获胜所需的最小现金数（每次猜测支付猜测数字的金额）。',
    'hard',
    1000,
    256,
    ARRAY['数学', '动态规划', '博弈'],
    $json$[
  {
    "input": "n = 10",
    "output": "16"
  },
  {
    "input": "n = 1",
    "output": "0"
  },
  {
    "input": "n = 2",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 10",
    "output": "16"
  },
  {
    "input": "n = 1",
    "output": "0"
  },
  {
    "input": "n = 2",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var getMoneyAmount = function(n) {\n};\n",
  "python": "class Solution:\n    def getMoneyAmount(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int getMoneyAmount(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int getMoneyAmount(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getMoneyAmount",
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
      "expected": 16
    },
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
    }
  ]
}$json$::jsonb,
    $json$[
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
    "expected": 4
  },
  {
    "args": [
      5
    ],
    "expected": 6
  },
  {
    "args": [
      20
    ],
    "expected": 49
  }
]$json$::jsonb,
    'approved'
),
(
    1485,
    '课程表 III',
    '给定课程数组 courses，courses[i] = [duration, lastDay]。
每门课需要连续学习 duration 天，且必须在 lastDay 当天或之前完成。返回最多可以修完的课程数。',
    'hard',
    1000,
    256,
    ARRAY['贪心', '数组', '堆', '排序'],
    $json$[
  {
    "input": "courses = [[100, 200], [200, 1300], [1000, 1250], [2000, 3200]]",
    "output": "3"
  },
  {
    "input": "courses = [[1, 2]]",
    "output": "1"
  },
  {
    "input": "courses = [[3, 2], [4, 3]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "courses = [[100, 200], [200, 1300], [1000, 1250], [2000, 3200]]",
    "output": "3"
  },
  {
    "input": "courses = [[1, 2]]",
    "output": "1"
  },
  {
    "input": "courses = [[3, 2], [4, 3]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var scheduleCourse = function(courses) {\n};\n",
  "python": "class Solution:\n    def scheduleCourse(self, courses: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int scheduleCourse(std::vector<std::vector<int>>& courses) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int scheduleCourse(int[][] courses) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "scheduleCourse",
  "params": [
    {
      "name": "courses",
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
            100,
            200
          ],
          [
            200,
            1300
          ],
          [
            1000,
            1250
          ],
          [
            2000,
            3200
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
            2
          ],
          [
            4,
            3
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
          5
        ],
        [
          4,
          6
        ],
        [
          2,
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
    1486,
    '带限制的子序列和',
    '给定整数数组 nums 和整数 k，返回非空子序列的最大和。
子序列中相邻元素的下标差不能超过 k。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '队列', '滑动窗口', '单调队列'],
    $json$[
  {
    "input": "nums = [10, 2, -10, 5, 20], k = 2",
    "output": "37"
  },
  {
    "input": "nums = [-1, -2, -3], k = 1",
    "output": "-1"
  },
  {
    "input": "nums = [10, -2, -10, -5, 20], k = 2",
    "output": "23"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [10, 2, -10, 5, 20], k = 2",
    "output": "37"
  },
  {
    "input": "nums = [-1, -2, -3], k = 1",
    "output": "-1"
  },
  {
    "input": "nums = [10, -2, -10, -5, 20], k = 2",
    "output": "23"
  }
]$json$::jsonb,
    $json${
  "javascript": "var constrainedSubsetSum = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def constrainedSubsetSum(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int constrainedSubsetSum(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int constrainedSubsetSum(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "constrainedSubsetSum",
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
          10,
          2,
          -10,
          5,
          20
        ],
        2
      ],
      "expected": 37
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
          10,
          -2,
          -10,
          -5,
          20
        ],
        2
      ],
      "expected": 23
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
        -1
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
        3
      ],
      2
    ],
    "expected": 6
  },
  {
    "args": [
      [
        -2,
        1,
        -3,
        4,
        -1,
        2,
        1,
        -5,
        4
      ],
      2
    ],
    "expected": 12
  }
]$json$::jsonb,
    'approved'
),
(
    1487,
    '打砖块',
    '给定 m x n 的 0/1 矩阵 grid 和打击位置数组 hits。
每次打击会移除命中位置的砖块，若某砖块与顶部不再连通则掉落。
返回每次打击后掉落的砖块数（不含被打击的砖块）。',
    'hard',
    1000,
    256,
    ARRAY['并查集', '数组', '矩阵'],
    $json$[
  {
    "input": "grid = [[1, 0, 0, 0], [1, 1, 1, 0]], hits = [[1, 0]]",
    "output": "[2]"
  },
  {
    "input": "grid = [[1, 0, 0, 0], [1, 1, 0, 0]], hits = [[1, 1], [1, 0]]",
    "output": "[0, 0]"
  },
  {
    "input": "grid = [[1, 0, 0, 0], [1, 1, 1, 0]], hits = [[1, 0], [0, 1]]",
    "output": "[2, 0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[1, 0, 0, 0], [1, 1, 1, 0]], hits = [[1, 0]]",
    "output": "[2]"
  },
  {
    "input": "grid = [[1, 0, 0, 0], [1, 1, 0, 0]], hits = [[1, 1], [1, 0]]",
    "output": "[0, 0]"
  },
  {
    "input": "grid = [[1, 0, 0, 0], [1, 1, 1, 0]], hits = [[1, 0], [0, 1]]",
    "output": "[2, 0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var hitBricks = function(grid, hits) {\n};\n",
  "python": "class Solution:\n    def hitBricks(self, grid: list[list[int]], hits: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> hitBricks(std::vector<std::vector<int>>& grid, std::vector<std::vector<int>>& hits) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] hitBricks(int[][] grid, int[][] hits) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "hitBricks",
  "params": [
    {
      "name": "grid",
      "type": "int[][]"
    },
    {
      "name": "hits",
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
            0,
            0,
            0
          ],
          [
            1,
            1,
            1,
            0
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
        2
      ]
    },
    {
      "args": [
        [
          [
            1,
            0,
            0,
            0
          ],
          [
            1,
            1,
            0,
            0
          ]
        ],
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
      "expected": [
        0,
        0
      ]
    },
    {
      "args": [
        [
          [
            1,
            0,
            0,
            0
          ],
          [
            1,
            1,
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
      "expected": [
        2,
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
          1
        ]
      ],
      [
        [
          0,
          0
        ]
      ]
    ],
    "expected": [
      0
    ]
  },
  {
    "args": [
      [
        [
          0
        ]
      ],
      [
        [
          0,
          0
        ]
      ]
    ],
    "expected": [
      0
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
      ],
      [
        [
          0,
          0
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
    1488,
    '掉落的方块',
    '在二维平面中依次掉落正方形方块 positions[i] = [left, sideLength]。
方块从高处垂直落下，落在已有方块或地面上。返回每次掉落后最高的方块顶部高度。',
    'hard',
    1000,
    256,
    ARRAY['数组', '线段树', '有序集合'],
    $json$[
  {
    "input": "positions = [[1, 2], [2, 3], [6, 1]]",
    "output": "[2, 5, 5]"
  },
  {
    "input": "positions = [[100, 100], [200, 100]]",
    "output": "[100, 100]"
  },
  {
    "input": "positions = [[1, 2], [1, 2]]",
    "output": "[2, 4]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "positions = [[1, 2], [2, 3], [6, 1]]",
    "output": "[2, 5, 5]"
  },
  {
    "input": "positions = [[100, 100], [200, 100]]",
    "output": "[100, 100]"
  },
  {
    "input": "positions = [[1, 2], [1, 2]]",
    "output": "[2, 4]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var fallingSquares = function(positions) {\n};\n",
  "python": "class Solution:\n    def fallingSquares(self, positions: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> fallingSquares(std::vector<std::vector<int>>& positions) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] fallingSquares(int[][] positions) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "fallingSquares",
  "params": [
    {
      "name": "positions",
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
            2,
            3
          ],
          [
            6,
            1
          ]
        ]
      ],
      "expected": [
        2,
        5,
        5
      ]
    },
    {
      "args": [
        [
          [
            100,
            100
          ],
          [
            200,
            100
          ]
        ]
      ],
      "expected": [
        100,
        100
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
        [
          1,
          1
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
          1
        ],
        [
          2,
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
          3
        ],
        [
          3,
          3
        ],
        [
          2,
          1
        ]
      ]
    ],
    "expected": [
      3,
      6,
      6
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1489,
    '段式回文',
    '给定字符串 text，将其分解成若干段，使第一段与最后一段相同、第二段与倒数第二段相同，依此类推。
返回能分解出的最大段数。',
    'hard',
    1000,
    256,
    ARRAY['贪心', '双指针', '字符串', '动态规划'],
    $json$[
  {
    "input": "text = \"ghiabcdefhelloadamhelloabcdefghi\"",
    "output": "7"
  },
  {
    "input": "text = \"merchant\"",
    "output": "1"
  },
  {
    "input": "text = \"antaprezatepzapreanta\"",
    "output": "11"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "text = \"ghiabcdefhelloadamhelloabcdefghi\"",
    "output": "7"
  },
  {
    "input": "text = \"merchant\"",
    "output": "1"
  },
  {
    "input": "text = \"antaprezatepzapreanta\"",
    "output": "11"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestDecomposition = function(text) {\n};\n",
  "python": "class Solution:\n    def longestDecomposition(self, text: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestDecomposition(std::string text) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestDecomposition(String text) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestDecomposition",
  "params": [
    {
      "name": "text",
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
        "ghiabcdefhelloadamhelloabcdefghi"
      ],
      "expected": 7
    },
    {
      "args": [
        "merchant"
      ],
      "expected": 1
    },
    {
      "args": [
        "antaprezatepzapreanta"
      ],
      "expected": 11
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
      "aa"
    ],
    "expected": 2
  },
  {
    "args": [
      "ab"
    ],
    "expected": 1
  },
  {
    "args": [
      "aba"
    ],
    "expected": 3
  },
  {
    "args": [
      "aaaa"
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1490,
    '生成数组',
    '生成一个长度为 n 的数组，每个元素在 1 到 m 之间。
定义搜索代价为从左到右记录严格最大值的次数（最大值变化时加一）。
返回搜索代价恰好为 k 的不同数组个数，模 1e9+7。',
    'hard',
    1000,
    256,
    ARRAY['动态规划', '前缀和'],
    $json$[
  {
    "input": "n = 2, m = 3, k = 1",
    "output": "6"
  },
  {
    "input": "n = 3, m = 3, k = 2",
    "output": "12"
  },
  {
    "input": "n = 2, m = 3, k = 2",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 2, m = 3, k = 1",
    "output": "6"
  },
  {
    "input": "n = 3, m = 3, k = 2",
    "output": "12"
  },
  {
    "input": "n = 2, m = 3, k = 2",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numOfArrays = function(n, m, k) {\n};\n",
  "python": "class Solution:\n    def numOfArrays(self, n: int, m: int, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numOfArrays(int n, int m, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numOfArrays(int n, int m, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numOfArrays",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "m",
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
        2,
        3,
        1
      ],
      "expected": 6
    },
    {
      "args": [
        3,
        3,
        2
      ],
      "expected": 12
    },
    {
      "args": [
        2,
        3,
        2
      ],
      "expected": 3
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
    "expected": 1
  },
  {
    "args": [
      1,
      5,
      1
    ],
    "expected": 5
  },
  {
    "args": [
      3,
      2,
      1
    ],
    "expected": 5
  },
  {
    "args": [
      3,
      3,
      1
    ],
    "expected": 14
  }
]$json$::jsonb,
    'approved'
),
(
    1491,
    '移除盒子',
    '给定整数数组 boxes，每次可以移除连续且颜色相同的 k 个盒子，获得 k * k 分。
返回能获得的最大积分。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '记忆化搜索'],
    $json$[
  {
    "input": "boxes = [1, 3, 2, 2, 2, 3, 4, 3, 1]",
    "output": "23"
  },
  {
    "input": "boxes = [1, 1, 1]",
    "output": "9"
  },
  {
    "input": "boxes = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "boxes = [1, 3, 2, 2, 2, 3, 4, 3, 1]",
    "output": "23"
  },
  {
    "input": "boxes = [1, 1, 1]",
    "output": "9"
  },
  {
    "input": "boxes = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeBoxes = function(boxes) {\n};\n",
  "python": "class Solution:\n    def removeBoxes(self, boxes: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int removeBoxes(std::vector<int>& boxes) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int removeBoxes(int[] boxes) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeBoxes",
  "params": [
    {
      "name": "boxes",
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
          2,
          3,
          4,
          3,
          1
        ]
      ],
      "expected": 23
    },
    {
      "args": [
        [
          1,
          1,
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
        1,
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
        2,
        2,
        2
      ]
    ],
    "expected": 16
  }
]$json$::jsonb,
    'approved'
),
(
    1492,
    '最小不兼容性',
    '给定整数数组 nums 和整数 k，将 nums 分成 k 个大小相同的子集。
一个子集的不兼容性为子集内最大值与最小值的差。
返回所有子集不兼容性之和的最小值；无法分割返回 -1。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '位运算'],
    $json$[
  {
    "input": "nums = [1, 2, 1, 4], k = 2",
    "output": "2"
  },
  {
    "input": "nums = [6, 3, 8, 1, 3, 1, 2, 2], k = 4",
    "output": "2"
  },
  {
    "input": "nums = [5, 3, 3, 6, 3, 3], k = 3",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 1, 4], k = 2",
    "output": "2"
  },
  {
    "input": "nums = [6, 3, 8, 1, 3, 1, 2, 2], k = 4",
    "output": "2"
  },
  {
    "input": "nums = [5, 3, 3, 6, 3, 3], k = 3",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumIncompatibility = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def minimumIncompatibility(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumIncompatibility(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumIncompatibility(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumIncompatibility",
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
          1,
          2,
          1,
          4
        ],
        2
      ],
      "expected": 2
    },
    {
      "args": [
        [
          6,
          3,
          8,
          1,
          3,
          1,
          2,
          2
        ],
        4
      ],
      "expected": 2
    },
    {
      "args": [
        [
          5,
          3,
          3,
          6,
          3,
          3
        ],
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
        1
      ],
      1
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        2
      ],
      2
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
      ],
      2
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        1,
        2,
        2
      ],
      2
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1493,
    '最长快乐前缀',
    '「快乐前缀」指既是原字符串的某个真前缀、又是某个真后缀的字符串。
返回字符串 s 的最长快乐前缀；不存在返回空字符串。',
    'hard',
    1000,
    256,
    ARRAY['字符串', '字符串匹配', '哈希函数'],
    $json$[
  {
    "input": "s = \"level\"",
    "output": "\"l\""
  },
  {
    "input": "s = \"ababab\"",
    "output": "\"abab\""
  },
  {
    "input": "s = \"leetcodeleet\"",
    "output": "\"leet\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"level\"",
    "output": "\"l\""
  },
  {
    "input": "s = \"ababab\"",
    "output": "\"abab\""
  },
  {
    "input": "s = \"leetcodeleet\"",
    "output": "\"leet\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestPrefix = function(s) {\n};\n",
  "python": "class Solution:\n    def longestPrefix(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string longestPrefix(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String longestPrefix(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestPrefix",
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
        "level"
      ],
      "expected": "l"
    },
    {
      "args": [
        "ababab"
      ],
      "expected": "abab"
    },
    {
      "args": [
        "leetcodeleet"
      ],
      "expected": "leet"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a"
    ],
    "expected": ""
  },
  {
    "args": [
      "aa"
    ],
    "expected": "a"
  },
  {
    "args": [
      "ab"
    ],
    "expected": ""
  },
  {
    "args": [
      "abcabc"
    ],
    "expected": "abc"
  },
  {
    "args": [
      "aaaa"
    ],
    "expected": "aaa"
  }
]$json$::jsonb,
    'approved'
),
(
    1494,
    '最大为 N 的数字组合',
    '给定非递减的数字数组 digits（元素为 0 到 9 且互不相同），返回用这些数字组成的小于等于 n 的正整数个数。
数字可以重复使用。',
    'hard',
    1000,
    256,
    ARRAY['数组', '数学', '二分查找', '动态规划'],
    $json$[
  {
    "input": "digits = [1, 3, 5, 7], n = 100",
    "output": "20"
  },
  {
    "input": "digits = [1, 4, 9], n = 1000000000",
    "output": "29523"
  },
  {
    "input": "digits = [7], n = 8",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "digits = [1, 3, 5, 7], n = 100",
    "output": "20"
  },
  {
    "input": "digits = [1, 4, 9], n = 1000000000",
    "output": "29523"
  },
  {
    "input": "digits = [7], n = 8",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var atMostNGivenDigitSet = function(digits, n) {\n};\n",
  "python": "class Solution:\n    def atMostNGivenDigitSet(self, digits: list[int], n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int atMostNGivenDigitSet(std::vector<int>& digits, int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int atMostNGivenDigitSet(int[] digits, int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "atMostNGivenDigitSet",
  "params": [
    {
      "name": "digits",
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
          3,
          5,
          7
        ],
        100
      ],
      "expected": 20
    },
    {
      "args": [
        [
          1,
          4,
          9
        ],
        1000000000
      ],
      "expected": 29523
    },
    {
      "args": [
        [
          7
        ],
        8
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
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1
      ],
      9
    ],
    "expected": 1
  },
  {
    "args": [
      [
        9
      ],
      10
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2
      ],
      20
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1495,
    '统计特殊整数',
    '如果一个正整数的每个数位都互不相同，则称为特殊整数。
给定 n，返回区间 [1, n] 内特殊整数的个数。',
    'hard',
    1000,
    256,
    ARRAY['数学', '动态规划', '位运算'],
    $json$[
  {
    "input": "n = 20",
    "output": "19"
  },
  {
    "input": "n = 5",
    "output": "5"
  },
  {
    "input": "n = 135",
    "output": "110"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 20",
    "output": "19"
  },
  {
    "input": "n = 5",
    "output": "5"
  },
  {
    "input": "n = 135",
    "output": "110"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countSpecialNumbers = function(n) {\n};\n",
  "python": "class Solution:\n    def countSpecialNumbers(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countSpecialNumbers(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countSpecialNumbers(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countSpecialNumbers",
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
        20
      ],
      "expected": 19
    },
    {
      "args": [
        5
      ],
      "expected": 5
    },
    {
      "args": [
        135
      ],
      "expected": 110
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
    "expected": 10
  },
  {
    "args": [
      100
    ],
    "expected": 90
  },
  {
    "args": [
      999
    ],
    "expected": 738
  }
]$json$::jsonb,
    'approved'
),
(
    1496,
    '不同的子序列 II',
    '给定字符串 s，返回 s 的不同非空子序列的个数，模 1e9+7。
子序列由删除部分字符（可以不删除）得到。',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "s = \"abc\"",
    "output": "7"
  },
  {
    "input": "s = \"aba\"",
    "output": "6"
  },
  {
    "input": "s = \"aaa\"",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abc\"",
    "output": "7"
  },
  {
    "input": "s = \"aba\"",
    "output": "6"
  },
  {
    "input": "s = \"aaa\"",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var distinctSubseqII = function(s) {\n};\n",
  "python": "class Solution:\n    def distinctSubseqII(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int distinctSubseqII(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int distinctSubseqII(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "distinctSubseqII",
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
        "abc"
      ],
      "expected": 7
    },
    {
      "args": [
        "aba"
      ],
      "expected": 6
    },
    {
      "args": [
        "aaa"
      ],
      "expected": 3
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
      "ab"
    ],
    "expected": 3
  },
  {
    "args": [
      "aa"
    ],
    "expected": 2
  },
  {
    "args": [
      "abab"
    ],
    "expected": 11
  }
]$json$::jsonb,
    'approved'
),
(
    1497,
    '检查「好数组」',
    '给定正整数数组 nums，如果存在一个非空子集，其元素的最大公约数为 1，则该数组是「好数组」。
返回 nums 是否为好数组。',
    'hard',
    1000,
    256,
    ARRAY['数组', '数学', '数论'],
    $json$[
  {
    "input": "nums = [12, 5, 7, 23]",
    "output": "true"
  },
  {
    "input": "nums = [29, 6, 10]",
    "output": "true"
  },
  {
    "input": "nums = [3, 6]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [12, 5, 7, 23]",
    "output": "true"
  },
  {
    "input": "nums = [29, 6, 10]",
    "output": "true"
  },
  {
    "input": "nums = [3, 6]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isGoodArray = function(nums) {\n};\n",
  "python": "class Solution:\n    def isGoodArray(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isGoodArray(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isGoodArray(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isGoodArray",
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
          12,
          5,
          7,
          23
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          29,
          6,
          10
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          3,
          6
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
        2
      ]
    ],
    "expected": false
  },
  {
    "args": [
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
        6,
        10,
        15
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1498,
    '使数组严格递增',
    '给定整数数组 arr1 和 arr2，可以将 arr1 中的任意元素替换为 arr2 中的任意元素。
每次替换计一次操作。返回使 arr1 严格递增的最少操作数；无法做到返回 -1。',
    'hard',
    1000,
    256,
    ARRAY['数组', '二分查找', '动态规划', '排序'],
    $json$[
  {
    "input": "arr1 = [1, 5, 3, 6, 7], arr2 = [1, 3, 2, 4]",
    "output": "1"
  },
  {
    "input": "arr1 = [1, 5, 3, 6, 7], arr2 = [4, 3, 1]",
    "output": "2"
  },
  {
    "input": "arr1 = [1, 5, 3, 6, 7], arr2 = [1, 6, 3, 3]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr1 = [1, 5, 3, 6, 7], arr2 = [1, 3, 2, 4]",
    "output": "1"
  },
  {
    "input": "arr1 = [1, 5, 3, 6, 7], arr2 = [4, 3, 1]",
    "output": "2"
  },
  {
    "input": "arr1 = [1, 5, 3, 6, 7], arr2 = [1, 6, 3, 3]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var makeArrayIncreasing = function(arr1, arr2) {\n};\n",
  "python": "class Solution:\n    def makeArrayIncreasing(self, arr1: list[int], arr2: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int makeArrayIncreasing(std::vector<int>& arr1, std::vector<int>& arr2) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int makeArrayIncreasing(int[] arr1, int[] arr2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "makeArrayIncreasing",
  "params": [
    {
      "name": "arr1",
      "type": "int[]"
    },
    {
      "name": "arr2",
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
          5,
          3,
          6,
          7
        ],
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
          1,
          5,
          3,
          6,
          7
        ],
        [
          4,
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
          5,
          3,
          6,
          7
        ],
        [
          1,
          6,
          3,
          3
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
        2,
        1
      ],
      [
        1,
        2
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        5,
        4,
        3
      ],
      [
        1,
        2,
        3
      ]
    ],
    "expected": -1
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
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1499,
    '或值至少为 K 的最短子数组 II',
    '给定整数数组 nums 和整数 k，返回按位或值至少为 k 的最短非空子数组长度。
不存在这样的子数组返回 -1。',
    'hard',
    1000,
    256,
    ARRAY['数组', '位运算', '滑动窗口'],
    $json$[
  {
    "input": "nums = [1, 2, 3], k = 2",
    "output": "1"
  },
  {
    "input": "nums = [2, 1, 8], k = 10",
    "output": "3"
  },
  {
    "input": "nums = [1, 2], k = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3], k = 2",
    "output": "1"
  },
  {
    "input": "nums = [2, 1, 8], k = 10",
    "output": "3"
  },
  {
    "input": "nums = [1, 2], k = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumSubarrayOR = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def minimumSubarrayOR(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumSubarrayOR(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumSubarrayOR(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumSubarrayOR",
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
          1,
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
          2,
          1,
          8
        ],
        10
      ],
      "expected": 3
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
        1
      ],
      2
    ],
    "expected": -1
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
    "expected": 1
  },
  {
    "args": [
      [
        3,
        1,
        2
      ],
      4
    ],
    "expected": -1
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
    GREATEST((SELECT COALESCE(MAX(id), 1) FROM problems), 1499)
);

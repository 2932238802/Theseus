-- 仅用于本地/测试环境的题目种子数据。
-- 使用固定 ID 1700-1899，便于通过 clean_dev.sql 安全清理。
-- 200 道函数式题目（run_config + 公开用例 + 隐藏 judge_cases），
-- 与 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）、seed_problems_82.sql（1116-1197）、seed_problems_100.sql（1200-1299）、seed_problems_batch1.sql（1300-1499）、seed_problems_batch2.sql（1500-1699）合计 800 题。

INSERT INTO problems (
    id, title, description, difficulty, time_limit, memory_limit, tags,
    examples, test_cases, code_template, run_config, judge_cases, review_status
) VALUES
(
    1700,
    '按奇偶排序数组 II',
    '给定一个长度为偶数且恰好一半是偶数、一半是奇数的整数数组 nums。
重排数组，使所有偶数位于偶数下标，所有奇数位于奇数下标，下标从 0 开始。
偶数之间保持它们在原数组中出现的先后顺序，奇数之间也保持原出现顺序。
2 <= nums.length <= 2 * 10^4，-10^3 <= nums[i] <= 10^3。',
    'easy',
    1000,
    256,
    ARRAY['数组', '双指针', '排序'],
    $json$[
  {
    "input": "nums = [4, 2, 5, 7]",
    "output": "[4, 5, 2, 7]"
  },
  {
    "input": "nums = [2, 3]",
    "output": "[2, 3]"
  },
  {
    "input": "nums = [2, 1, 4, 3]",
    "output": "[2, 1, 4, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [4, 2, 5, 7]",
    "output": "[4, 5, 2, 7]"
  },
  {
    "input": "nums = [2, 3]",
    "output": "[2, 3]"
  },
  {
    "input": "nums = [2, 1, 4, 3]",
    "output": "[2, 1, 4, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sortArrayByParityII = function(nums) {\n};\n",
  "python": "class Solution:\n    def sortArrayByParityII(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> sortArrayByParityII(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] sortArrayByParityII(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sortArrayByParityII",
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
          2,
          5,
          7
        ]
      ],
      "expected": [
        4,
        5,
        2,
        7
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
          2,
          1,
          4,
          3
        ]
      ],
      "expected": [
        2,
        1,
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
        4
      ]
    ],
    "expected": [
      4,
      3
    ]
  },
  {
    "args": [
      [
        2,
        1,
        4,
        3,
        6,
        5
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
      2,
      3
    ]
  },
  {
    "args": [
      [
        8,
        7,
        6,
        5,
        4,
        3
      ]
    ],
    "expected": [
      8,
      7,
      6,
      5,
      4,
      3
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
      -2,
      -1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1701,
    '长按键入',
    '你在键盘上输入名字 name，某些按键可能被长按，导致一个字符在 typed 中出现一次或多次。
给定字符串 name 和实际输入的字符串 typed，判断 typed 是否可能由输入 name 时长按某些按键得到。
长按只会在同一字符上产生连续的重复，不会产生新的字符。
1 <= name.length <= 1000，1 <= typed.length <= 1000，两个字符串都只包含小写英文字母。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "name = \"alex\", typed = \"aaleex\"",
    "output": "true"
  },
  {
    "input": "name = \"saeed\", typed = \"ssaaedd\"",
    "output": "false"
  },
  {
    "input": "name = \"leelee\", typed = \"lleeelee\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "name = \"alex\", typed = \"aaleex\"",
    "output": "true"
  },
  {
    "input": "name = \"saeed\", typed = \"ssaaedd\"",
    "output": "false"
  },
  {
    "input": "name = \"leelee\", typed = \"lleeelee\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isLongPressedName = function(name, typed) {\n};\n",
  "python": "class Solution:\n    def isLongPressedName(self, name: str, typed: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isLongPressedName(std::string name, std::string typed) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isLongPressedName(String name, String typed) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isLongPressedName",
  "params": [
    {
      "name": "name",
      "type": "string"
    },
    {
      "name": "typed",
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
        "alex",
        "aaleex"
      ],
      "expected": true
    },
    {
      "args": [
        "saeed",
        "ssaaedd"
      ],
      "expected": false
    },
    {
      "args": [
        "leelee",
        "lleeelee"
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
      "aa"
    ],
    "expected": true
  },
  {
    "args": [
      "a",
      "ab"
    ],
    "expected": false
  },
  {
    "args": [
      "ab",
      "a"
    ],
    "expected": false
  },
  {
    "args": [
      "alex",
      "alexx"
    ],
    "expected": true
  },
  {
    "args": [
      "kikcxmvzi",
      "kiikcxxmmvvzzii"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1702,
    '在既定时间做作业的学生人数',
    '给定两个长度相同的整数数组 startTime 和 endTime，以及整数 queryTime。
第 i 个学生在 startTime[i] 时刻开始做作业，在 endTime[i] 时刻结束，时间区间两端都包含。
返回在 queryTime 时刻正在做作业的学生人数。
1 <= startTime.length == endTime.length <= 100，1 <= startTime[i] <= endTime[i] <= 1000，1 <= queryTime <= 1000。',
    'easy',
    1000,
    256,
    ARRAY['数组', '模拟'],
    $json$[
  {
    "input": "startTime = [1, 2, 3], endTime = [3, 2, 7], queryTime = 4",
    "output": "1"
  },
  {
    "input": "startTime = [4], endTime = [4], queryTime = 4",
    "output": "1"
  },
  {
    "input": "startTime = [1, 1, 1, 1], endTime = [1, 3, 2, 4], queryTime = 7",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "startTime = [1, 2, 3], endTime = [3, 2, 7], queryTime = 4",
    "output": "1"
  },
  {
    "input": "startTime = [4], endTime = [4], queryTime = 4",
    "output": "1"
  },
  {
    "input": "startTime = [1, 1, 1, 1], endTime = [1, 3, 2, 4], queryTime = 7",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var busyStudent = function(startTime, endTime, queryTime) {\n};\n",
  "python": "class Solution:\n    def busyStudent(self, startTime: list[int], endTime: list[int], queryTime: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int busyStudent(std::vector<int>& startTime, std::vector<int>& endTime, int queryTime) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int busyStudent(int[] startTime, int[] endTime, int queryTime) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "busyStudent",
  "params": [
    {
      "name": "startTime",
      "type": "int[]"
    },
    {
      "name": "endTime",
      "type": "int[]"
    },
    {
      "name": "queryTime",
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
        [
          3,
          2,
          7
        ],
        4
      ],
      "expected": 1
    },
    {
      "args": [
        [
          4
        ],
        [
          4
        ],
        4
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          1,
          1,
          1
        ],
        [
          1,
          3,
          2,
          4
        ],
        7
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
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
      ],
      [
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
      5
    ],
    "expected": 5
  },
  {
    "args": [
      [
        1
      ],
      [
        2
      ],
      3
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
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2
      ],
      [
        2,
        3
      ],
      2
    ],
    "expected": 2
  },
  {
    "args": [
      [
        5,
        6
      ],
      [
        5,
        6
      ],
      5
    ],
    "expected": 1
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
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1703,
    '重新排列日志文件',
    '给定日志数组 logs，每条日志是 "标识符 内容" 的形式，标识符由字母和数字组成，内容中不含空格以外的空白。
日志分为两类：内容以数字开头的为数字日志，其余为字母日志。
按以下规则排序：字母日志排在数字日志之前；字母日志按内容字典序升序排列，内容相同时按标识符字典序升序排列；
数字日志保持它们在原数组中的相对顺序。返回排序后的日志数组。
1 <= logs.length <= 100，3 <= logs[i].length <= 100。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '排序'],
    $json$[
  {
    "input": "logs = [\"dig1 8 1 5 1\", \"let1 art can\", \"dig2 3 6\", \"let2 own kit dig\", \"let3 art zero\"]",
    "output": "[\"let1 art can\", \"let3 art zero\", \"let2 own kit dig\", \"dig1 8 1 5 1\", \"dig2 3 6\"]"
  },
  {
    "input": "logs = [\"a1 9 2 3 1\", \"g1 act car\", \"zo4 4 7\", \"ab1 off key dog\", \"a8 act zoo\"]",
    "output": "[\"g1 act car\", \"a8 act zoo\", \"ab1 off key dog\", \"a1 9 2 3 1\", \"zo4 4 7\"]"
  },
  {
    "input": "logs = [\"let1 art\", \"dig1 1 2\"]",
    "output": "[\"let1 art\", \"dig1 1 2\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "logs = [\"dig1 8 1 5 1\", \"let1 art can\", \"dig2 3 6\", \"let2 own kit dig\", \"let3 art zero\"]",
    "output": "[\"let1 art can\", \"let3 art zero\", \"let2 own kit dig\", \"dig1 8 1 5 1\", \"dig2 3 6\"]"
  },
  {
    "input": "logs = [\"a1 9 2 3 1\", \"g1 act car\", \"zo4 4 7\", \"ab1 off key dog\", \"a8 act zoo\"]",
    "output": "[\"g1 act car\", \"a8 act zoo\", \"ab1 off key dog\", \"a1 9 2 3 1\", \"zo4 4 7\"]"
  },
  {
    "input": "logs = [\"let1 art\", \"dig1 1 2\"]",
    "output": "[\"let1 art\", \"dig1 1 2\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var reorderLogFiles = function(logs) {\n};\n",
  "python": "class Solution:\n    def reorderLogFiles(self, logs: list[str]) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> reorderLogFiles(std::vector<std::string>& logs) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] reorderLogFiles(String[] logs) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reorderLogFiles",
  "params": [
    {
      "name": "logs",
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
          "dig1 8 1 5 1",
          "let1 art can",
          "dig2 3 6",
          "let2 own kit dig",
          "let3 art zero"
        ]
      ],
      "expected": [
        "let1 art can",
        "let3 art zero",
        "let2 own kit dig",
        "dig1 8 1 5 1",
        "dig2 3 6"
      ]
    },
    {
      "args": [
        [
          "a1 9 2 3 1",
          "g1 act car",
          "zo4 4 7",
          "ab1 off key dog",
          "a8 act zoo"
        ]
      ],
      "expected": [
        "g1 act car",
        "a8 act zoo",
        "ab1 off key dog",
        "a1 9 2 3 1",
        "zo4 4 7"
      ]
    },
    {
      "args": [
        [
          "let1 art",
          "dig1 1 2"
        ]
      ],
      "expected": [
        "let1 art",
        "dig1 1 2"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "a1 1 2",
        "a2 3 4"
      ]
    ],
    "expected": [
      "a1 1 2",
      "a2 3 4"
    ]
  },
  {
    "args": [
      [
        "a1 z",
        "a2 y"
      ]
    ],
    "expected": [
      "a2 y",
      "a1 z"
    ]
  },
  {
    "args": [
      [
        "b2 x y",
        "a1 x y"
      ]
    ],
    "expected": [
      "a1 x y",
      "b2 x y"
    ]
  },
  {
    "args": [
      [
        "d1 0",
        "l1 hello world"
      ]
    ],
    "expected": [
      "l1 hello world",
      "d1 0"
    ]
  },
  {
    "args": [
      [
        "l2 abc def",
        "l1 abc def",
        "d9 9 9"
      ]
    ],
    "expected": [
      "l1 abc def",
      "l2 abc def",
      "d9 9 9"
    ]
  },
  {
    "args": [
      [
        "z9 1",
        "z8 2",
        "m1 a b"
      ]
    ],
    "expected": [
      "m1 a b",
      "z9 1",
      "z8 2"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1704,
    '删列造序',
    '给定由 n 个长度相同的字符串组成的数组 strs，这些字符串按行排列成一个字符矩阵。
若某一列中的字符不是按字典序非递减排列的，则需要删除该列。
返回需要删除的列数。
n == strs.length，1 <= n <= 100，1 <= strs[i].length <= 1000，所有字符串长度相同，只包含小写英文字母。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '数组', '模拟'],
    $json$[
  {
    "input": "strs = [\"cba\", \"daf\", \"ghi\"]",
    "output": "1"
  },
  {
    "input": "strs = [\"a\", \"b\"]",
    "output": "0"
  },
  {
    "input": "strs = [\"zyx\", \"wvu\", \"tsr\"]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "strs = [\"cba\", \"daf\", \"ghi\"]",
    "output": "1"
  },
  {
    "input": "strs = [\"a\", \"b\"]",
    "output": "0"
  },
  {
    "input": "strs = [\"zyx\", \"wvu\", \"tsr\"]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minDeletionSize = function(strs) {\n};\n",
  "python": "class Solution:\n    def minDeletionSize(self, strs: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minDeletionSize(std::vector<std::string>& strs) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minDeletionSize(String[] strs) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minDeletionSize",
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
          "cba",
          "daf",
          "ghi"
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
      "expected": 0
    },
    {
      "args": [
        [
          "zyx",
          "wvu",
          "tsr"
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
        "abc"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "a",
        "b",
        "c"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "ab",
        "ba"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "zzz",
        "aaa"
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        "abcdef",
        "bcdefg",
        "cdefgh"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "c",
        "b",
        "a"
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1705,
    '查询后的偶数和',
    '给定整数数组 nums 和查询数组 queries，每个查询是 [value, index]。
依次处理每个查询：执行 nums[index] += value，然后计算当前 nums 中所有偶数元素之和，记录该和。
返回由每次查询后的偶数和组成的数组。
1 <= nums.length <= 10^4，1 <= queries.length <= 10^4，-10^4 <= value <= 10^4，0 <= index < nums.length。',
    'easy',
    1000,
    256,
    ARRAY['数组', '模拟'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 4], queries = [[1, 0], [-3, 1], [-4, 0], [2, 3]]",
    "output": "[8, 6, 2, 4]"
  },
  {
    "input": "nums = [1], queries = [[4, 0]]",
    "output": "[0]"
  },
  {
    "input": "nums = [2, 2], queries = [[1, 0], [2, 1]]",
    "output": "[2, 4]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 4], queries = [[1, 0], [-3, 1], [-4, 0], [2, 3]]",
    "output": "[8, 6, 2, 4]"
  },
  {
    "input": "nums = [1], queries = [[4, 0]]",
    "output": "[0]"
  },
  {
    "input": "nums = [2, 2], queries = [[1, 0], [2, 1]]",
    "output": "[2, 4]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumEvenAfterQueries = function(nums, queries) {\n};\n",
  "python": "class Solution:\n    def sumEvenAfterQueries(self, nums: list[int], queries: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> sumEvenAfterQueries(std::vector<int>& nums, std::vector<std::vector<int>>& queries) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] sumEvenAfterQueries(int[] nums, int[][] queries) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumEvenAfterQueries",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
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
          1,
          2,
          3,
          4
        ],
        [
          [
            1,
            0
          ],
          [
            -3,
            1
          ],
          [
            -4,
            0
          ],
          [
            2,
            3
          ]
        ]
      ],
      "expected": [
        8,
        6,
        2,
        4
      ]
    },
    {
      "args": [
        [
          1
        ],
        [
          [
            4,
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
          2,
          2
        ],
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
        1,
        2,
        3,
        4
      ],
      [
        [
          1,
          0
        ]
      ]
    ],
    "expected": [
      8
    ]
  },
  {
    "args": [
      [
        0
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
        -1,
        -1
      ],
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
    "expected": [
      0,
      0
    ]
  },
  {
    "args": [
      [
        1,
        1
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
        2,
        -2
      ],
      [
        [
          -2,
          0
        ],
        [
          2,
          1
        ]
      ]
    ],
    "expected": [
      -2,
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1706,
    '第 k 个缺失的正整数',
    '给定一个严格递增的正整数数组 arr 和整数 k。请找出第 k 个缺失的正整数。
缺失的正整数指所有正整数中未出现在 arr 里的数。返回第 k 个缺失的正整数。
1 <= arr.length <= 1000，1 <= arr[i] <= 1000，1 <= k <= 1000，arr 严格递增。',
    'easy',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "arr = [2, 3, 4, 7, 11], k = 5",
    "output": "9"
  },
  {
    "input": "arr = [1, 2, 3, 4], k = 2",
    "output": "6"
  },
  {
    "input": "arr = [1, 2, 3, 4], k = 1",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [2, 3, 4, 7, 11], k = 5",
    "output": "9"
  },
  {
    "input": "arr = [1, 2, 3, 4], k = 2",
    "output": "6"
  },
  {
    "input": "arr = [1, 2, 3, 4], k = 1",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findKthPositive = function(arr, k) {\n};\n",
  "python": "class Solution:\n    def findKthPositive(self, arr: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findKthPositive(std::vector<int>& arr, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findKthPositive(int[] arr, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findKthPositive",
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
          2,
          3,
          4,
          7,
          11
        ],
        5
      ],
      "expected": 9
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
      "expected": 6
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4
        ],
        1
      ],
      "expected": 5
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
    "expected": 2
  },
  {
    "args": [
      [
        2
      ],
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
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
        5,
        6,
        7
      ],
      3
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        3
      ],
      2
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
        6,
        7,
        8
      ],
      5
    ],
    "expected": 13
  }
]$json$::jsonb,
    'approved'
),
(
    1707,
    '除数博弈',
    '黑板上有一个数字 n。两名玩家轮流操作，每名玩家在自己的回合选择一个满足 1 <= x < n 且 n % x == 0 的 x，
把黑板上的数字 n 替换为 n - x。无法操作的玩家输掉游戏。
Alice 先手，双方都采取最优策略，返回 Alice 是否必胜。
1 <= n <= 1000。',
    'easy',
    1000,
    256,
    ARRAY['数学', '博弈'],
    $json$[
  {
    "input": "n = 2",
    "output": "true"
  },
  {
    "input": "n = 3",
    "output": "false"
  },
  {
    "input": "n = 4",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 2",
    "output": "true"
  },
  {
    "input": "n = 3",
    "output": "false"
  },
  {
    "input": "n = 4",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var divisorGame = function(n) {\n};\n",
  "python": "class Solution:\n    def divisorGame(self, n: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool divisorGame(int n) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean divisorGame(int n) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "divisorGame",
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
      "expected": true
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
      7
    ],
    "expected": false
  },
  {
    "args": [
      8
    ],
    "expected": true
  },
  {
    "args": [
      100
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1708,
    '距离顺序排列矩阵单元格',
    '给定矩阵的行数 rows、列数 cols，以及一个中心坐标 (rCenter, cCenter)，单元格坐标为 (r, c)。
按每个单元格到中心单元格的曼哈顿距离 |r - rCenter| + |c - cCenter| 升序排列所有单元格。
距离相同时，按行坐标升序排列；行坐标也相同时，按列坐标升序排列。
返回排好序的单元格坐标数组，每个元素为 [r, c]。1 <= rows, cols <= 100，0 <= rCenter < rows，0 <= cCenter < cols。',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序', '矩阵'],
    $json$[
  {
    "input": "rows = 1, cols = 2, rCenter = 0, cCenter = 0",
    "output": "[[0, 0], [0, 1]]"
  },
  {
    "input": "rows = 2, cols = 2, rCenter = 0, cCenter = 1",
    "output": "[[0, 1], [0, 0], [1, 1], [1, 0]]"
  },
  {
    "input": "rows = 2, cols = 3, rCenter = 1, cCenter = 2",
    "output": "[[1, 2], [0, 2], [1, 1], [0, 1], [1, 0], [0, 0]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "rows = 1, cols = 2, rCenter = 0, cCenter = 0",
    "output": "[[0, 0], [0, 1]]"
  },
  {
    "input": "rows = 2, cols = 2, rCenter = 0, cCenter = 1",
    "output": "[[0, 1], [0, 0], [1, 1], [1, 0]]"
  },
  {
    "input": "rows = 2, cols = 3, rCenter = 1, cCenter = 2",
    "output": "[[1, 2], [0, 2], [1, 1], [0, 1], [1, 0], [0, 0]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var allCellsDistOrder = function(rows, cols, rCenter, cCenter) {\n};\n",
  "python": "class Solution:\n    def allCellsDistOrder(self, rows: int, cols: int, rCenter: int, cCenter: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> allCellsDistOrder(int rows, int cols, int rCenter, int cCenter) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] allCellsDistOrder(int rows, int cols, int rCenter, int cCenter) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "allCellsDistOrder",
  "params": [
    {
      "name": "rows",
      "type": "int"
    },
    {
      "name": "cols",
      "type": "int"
    },
    {
      "name": "rCenter",
      "type": "int"
    },
    {
      "name": "cCenter",
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
        1,
        2,
        0,
        0
      ],
      "expected": [
        [
          0,
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
        2,
        2,
        0,
        1
      ],
      "expected": [
        [
          0,
          1
        ],
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
          0
        ]
      ]
    },
    {
      "args": [
        2,
        3,
        1,
        2
      ],
      "expected": [
        [
          1,
          2
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
          0,
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
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      1,
      0,
      0
    ],
    "expected": [
      [
        0,
        0
      ]
    ]
  },
  {
    "args": [
      2,
      2,
      1,
      1
    ],
    "expected": [
      [
        1,
        1
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
        0,
        0
      ]
    ]
  },
  {
    "args": [
      3,
      1,
      1,
      0
    ],
    "expected": [
      [
        1,
        0
      ],
      [
        0,
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
      1,
      3,
      0,
      1
    ],
    "expected": [
      [
        0,
        1
      ],
      [
        0,
        0
      ],
      [
        0,
        2
      ]
    ]
  },
  {
    "args": [
      2,
      2,
      0,
      0
    ],
    "expected": [
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
        1
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1709,
    '最后一块石头的重量',
    '有一堆石头，每块石头的重量为正整数。每次选出最重的两块石头 x 和 y（x <= y）并让它们相撞：
如果 x == y，两块石头都碎掉；如果 x < y，重量为 x 的石头碎掉，剩下重量为 y - x 的石头。
重复该过程直到最多只剩一块石头。返回最后剩下的石头的重量；如果没有石头剩下则返回 0。
1 <= stones.length <= 30，1 <= stones[i] <= 1000。',
    'easy',
    1000,
    256,
    ARRAY['数组', '堆', '模拟'],
    $json$[
  {
    "input": "stones = [2, 7, 4, 1, 8, 1]",
    "output": "1"
  },
  {
    "input": "stones = [1]",
    "output": "1"
  },
  {
    "input": "stones = [2, 2]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "stones = [2, 7, 4, 1, 8, 1]",
    "output": "1"
  },
  {
    "input": "stones = [1]",
    "output": "1"
  },
  {
    "input": "stones = [2, 2]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var lastStoneWeight = function(stones) {\n};\n",
  "python": "class Solution:\n    def lastStoneWeight(self, stones: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int lastStoneWeight(std::vector<int>& stones) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int lastStoneWeight(int[] stones) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "lastStoneWeight",
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
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        3
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        10,
        4,
        2,
        10
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        3,
        7,
        2
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
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
        9,
        3,
        2,
        10
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1710,
    'Bigram 分词',
    '给定字符串 text 和两个单词 first、second。把 text 按空格拆分成单词数组。
找出所有满足条件的单词：该单词紧跟在一个等于 first 的单词和紧接着一个等于 second 的单词之后，
即存在下标 i，使 words[i] == first、words[i+1] == second，则 words[i+2] 是答案。
返回按出现顺序排列的答案单词数组；没有答案时返回空数组。匹配区分大小写。
1 <= text.length <= 1000，text 由小写英文字母和空格组成，1 <= first.length, second.length <= 10。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '数组'],
    $json$[
  {
    "input": "text = \"alice is a good girl she is a good student\", first = \"a\", second = \"good\"",
    "output": "[\"girl\", \"student\"]"
  },
  {
    "input": "text = \"we will we will rock you\", first = \"we\", second = \"will\"",
    "output": "[\"we\", \"rock\"]"
  },
  {
    "input": "text = \"we will we will rock you\", first = \"will\", second = \"we\"",
    "output": "[\"will\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "text = \"alice is a good girl she is a good student\", first = \"a\", second = \"good\"",
    "output": "[\"girl\", \"student\"]"
  },
  {
    "input": "text = \"we will we will rock you\", first = \"we\", second = \"will\"",
    "output": "[\"we\", \"rock\"]"
  },
  {
    "input": "text = \"we will we will rock you\", first = \"will\", second = \"we\"",
    "output": "[\"will\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findOcurrences = function(text, first, second) {\n};\n",
  "python": "class Solution:\n    def findOcurrences(self, text: str, first: str, second: str) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> findOcurrences(std::string text, std::string first, std::string second) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] findOcurrences(String text, String first, String second) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findOcurrences",
  "params": [
    {
      "name": "text",
      "type": "string"
    },
    {
      "name": "first",
      "type": "string"
    },
    {
      "name": "second",
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
        "alice is a good girl she is a good student",
        "a",
        "good"
      ],
      "expected": [
        "girl",
        "student"
      ]
    },
    {
      "args": [
        "we will we will rock you",
        "we",
        "will"
      ],
      "expected": [
        "we",
        "rock"
      ]
    },
    {
      "args": [
        "we will we will rock you",
        "will",
        "we"
      ],
      "expected": [
        "will"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a b c",
      "a",
      "b"
    ],
    "expected": [
      "c"
    ]
  },
  {
    "args": [
      "a a a",
      "a",
      "a"
    ],
    "expected": [
      "a"
    ]
  },
  {
    "args": [
      "a b",
      "a",
      "b"
    ],
    "expected": []
  },
  {
    "args": [
      "x y z x y",
      "x",
      "y"
    ],
    "expected": [
      "z"
    ]
  },
  {
    "args": [
      "a b c a b c",
      "a",
      "b"
    ],
    "expected": [
      "c",
      "c"
    ]
  },
  {
    "args": [
      "hello world",
      "hello",
      "world"
    ],
    "expected": []
  }
]$json$::jsonb,
    'approved'
),
(
    1711,
    '分糖果 II',
    '有 candies 颗糖果，要分给 num_people 个人。第一个人拿 1 颗，第二个人拿 2 颗，依此类推，
直到每个人拿到一轮。然后回到第一个人，他拿 num_people + 1 颗，第二个人拿 num_people + 2 颗，继续递增。
当剩余糖果不足当前应拿的数量时，把剩余的全部给当前这个人。
返回长度为 num_people 的数组，表示每个人最终得到的糖果数。
0 <= candies <= 10^9，1 <= num_people <= 1000。',
    'easy',
    1000,
    256,
    ARRAY['数组', '模拟', '数学'],
    $json$[
  {
    "input": "candies = 7, num_people = 4",
    "output": "[1, 2, 3, 1]"
  },
  {
    "input": "candies = 10, num_people = 3",
    "output": "[5, 2, 3]"
  },
  {
    "input": "candies = 1, num_people = 1",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "candies = 7, num_people = 4",
    "output": "[1, 2, 3, 1]"
  },
  {
    "input": "candies = 10, num_people = 3",
    "output": "[5, 2, 3]"
  },
  {
    "input": "candies = 1, num_people = 1",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var distributeCandies = function(candies, num_people) {\n};\n",
  "python": "class Solution:\n    def distributeCandies(self, candies: int, num_people: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> distributeCandies(int candies, int num_people) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] distributeCandies(int candies, int num_people) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "distributeCandies",
  "params": [
    {
      "name": "candies",
      "type": "int"
    },
    {
      "name": "num_people",
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
        7,
        4
      ],
      "expected": [
        1,
        2,
        3,
        1
      ]
    },
    {
      "args": [
        10,
        3
      ],
      "expected": [
        5,
        2,
        3
      ]
    },
    {
      "args": [
        1,
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
      2,
      2
    ],
    "expected": [
      1,
      1
    ]
  },
  {
    "args": [
      3,
      2
    ],
    "expected": [
      1,
      2
    ]
  },
  {
    "args": [
      4,
      3
    ],
    "expected": [
      1,
      2,
      1
    ]
  },
  {
    "args": [
      6,
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
      0,
      5
    ],
    "expected": [
      0,
      0,
      0,
      0,
      0
    ]
  },
  {
    "args": [
      11,
      3
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
    1712,
    '数组的相对排序',
    '给定两个数组 arr1 和 arr2。arr2 中的元素互不相同，且都出现在 arr1 中。
按以下规则对 arr1 的元素排序：arr2 中出现的元素按其首次出现的顺序排在前面（arr2 中每个元素对应的 arr1 元素全部排在一起），
arr1 中未出现在 arr2 中的元素按升序排在后面。返回排序后的数组。
1 <= arr1.length, arr2.length <= 1000，0 <= arr1[i], arr2[i] <= 1000。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '排序'],
    $json$[
  {
    "input": "arr1 = [2, 3, 1, 3, 2, 4, 6, 7, 9, 2, 19], arr2 = [2, 1, 4, 3, 9, 6]",
    "output": "[2, 2, 2, 1, 4, 3, 3, 9, 6, 7, 19]"
  },
  {
    "input": "arr1 = [28, 6, 22, 8, 44, 17], arr2 = [22, 28, 8, 6]",
    "output": "[22, 28, 8, 6, 17, 44]"
  },
  {
    "input": "arr1 = [1, 2, 3], arr2 = [3, 2, 1]",
    "output": "[3, 2, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr1 = [2, 3, 1, 3, 2, 4, 6, 7, 9, 2, 19], arr2 = [2, 1, 4, 3, 9, 6]",
    "output": "[2, 2, 2, 1, 4, 3, 3, 9, 6, 7, 19]"
  },
  {
    "input": "arr1 = [28, 6, 22, 8, 44, 17], arr2 = [22, 28, 8, 6]",
    "output": "[22, 28, 8, 6, 17, 44]"
  },
  {
    "input": "arr1 = [1, 2, 3], arr2 = [3, 2, 1]",
    "output": "[3, 2, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var relativeSortArray = function(arr1, arr2) {\n};\n",
  "python": "class Solution:\n    def relativeSortArray(self, arr1: list[int], arr2: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> relativeSortArray(std::vector<int>& arr1, std::vector<int>& arr2) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] relativeSortArray(int[] arr1, int[] arr2) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "relativeSortArray",
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
  "return_type": "int[]",
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
          3,
          2,
          4,
          6,
          7,
          9,
          2,
          19
        ],
        [
          2,
          1,
          4,
          3,
          9,
          6
        ]
      ],
      "expected": [
        2,
        2,
        2,
        1,
        4,
        3,
        3,
        9,
        6,
        7,
        19
      ]
    },
    {
      "args": [
        [
          28,
          6,
          22,
          8,
          44,
          17
        ],
        [
          22,
          28,
          8,
          6
        ]
      ],
      "expected": [
        22,
        28,
        8,
        6,
        17,
        44
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
          3,
          2,
          1
        ]
      ],
      "expected": [
        3,
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
        5,
        5,
        5
      ],
      [
        5
      ]
    ],
    "expected": [
      5,
      5,
      5
    ]
  },
  {
    "args": [
      [
        1,
        2
      ],
      [
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
        2
      ],
      [
        1,
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
        7,
        7,
        8,
        8
      ],
      [
        8
      ]
    ],
    "expected": [
      8,
      8,
      7,
      7
    ]
  },
  {
    "args": [
      [
        0,
        -1,
        2
      ],
      [
        2,
        0
      ]
    ],
    "expected": [
      2,
      0,
      -1
    ]
  },
  {
    "args": [
      [
        4,
        4
      ],
      [
        4
      ]
    ],
    "expected": [
      4,
      4
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1713,
    '拼写单词',
    '给定字符串数组 words 和一个字符串 chars（其中每类字符只能使用一次）。
如果拼写某个单词所需的字符都能从 chars 中取得（每个字符使用次数不能超过它在 chars 中出现的次数），
则该单词可以被拼写。返回所有可拼写单词的长度之和。
1 <= words.length <= 1000，1 <= words[i].length, chars.length <= 100，均为小写英文字母。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '字符串'],
    $json$[
  {
    "input": "words = [\"cat\", \"bt\", \"hat\", \"tree\"], chars = \"atach\"",
    "output": "6"
  },
  {
    "input": "words = [\"hello\", \"world\", \"leetcode\"], chars = \"welldonehoneyr\"",
    "output": "10"
  },
  {
    "input": "words = [\"a\"], chars = \"a\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"cat\", \"bt\", \"hat\", \"tree\"], chars = \"atach\"",
    "output": "6"
  },
  {
    "input": "words = [\"hello\", \"world\", \"leetcode\"], chars = \"welldonehoneyr\"",
    "output": "10"
  },
  {
    "input": "words = [\"a\"], chars = \"a\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countCharacters = function(words, chars) {\n};\n",
  "python": "class Solution:\n    def countCharacters(self, words: list[str], chars: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countCharacters(std::vector<std::string>& words, std::string chars) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countCharacters(String[] words, String chars) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countCharacters",
  "params": [
    {
      "name": "words",
      "type": "string[]"
    },
    {
      "name": "chars",
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
          "cat",
          "bt",
          "hat",
          "tree"
        ],
        "atach"
      ],
      "expected": 6
    },
    {
      "args": [
        [
          "hello",
          "world",
          "leetcode"
        ],
        "welldonehoneyr"
      ],
      "expected": 10
    },
    {
      "args": [
        [
          "a"
        ],
        "a"
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "ab"
      ],
      "a"
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "ab"
      ],
      "ab"
    ],
    "expected": 2
  },
  {
    "args": [
      [
        "a",
        "b",
        "c"
      ],
      "abc"
    ],
    "expected": 3
  },
  {
    "args": [
      [
        "aa",
        "bb"
      ],
      "ab"
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "xyz"
      ],
      "zyx"
    ],
    "expected": 3
  },
  {
    "args": [
      [
        "aabb"
      ],
      "ab"
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1714,
    '质数排列',
    '给定整数 n，构造 1 到 n 的一个排列。若排列中每个质数都位于质数下标（下标从 1 开始），
则称该排列为合法排列。返回合法排列的数目，答案对 10^9 + 7 取模。
1 <= n <= 100。',
    'easy',
    1000,
    256,
    ARRAY['数学', '排列组合'],
    $json$[
  {
    "input": "n = 5",
    "output": "12"
  },
  {
    "input": "n = 100",
    "output": "682289015"
  },
  {
    "input": "n = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5",
    "output": "12"
  },
  {
    "input": "n = 100",
    "output": "682289015"
  },
  {
    "input": "n = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numPrimeArrangements = function(n) {\n};\n",
  "python": "class Solution:\n    def numPrimeArrangements(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numPrimeArrangements(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numPrimeArrangements(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numPrimeArrangements",
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
      "expected": 12
    },
    {
      "args": [
        100
      ],
      "expected": 682289015
    },
    {
      "args": [
        1
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
    "expected": 4
  },
  {
    "args": [
      10
    ],
    "expected": 17280
  },
  {
    "args": [
      20
    ],
    "expected": 344376809
  },
  {
    "args": [
      50
    ],
    "expected": 451768713
  }
]$json$::jsonb,
    'approved'
),
(
    1715,
    '公交站间的距离',
    '环形公交线路有 n 个站点，编号 0 到 n-1。distance[i] 表示站点 i 到站点 (i + 1) % n 的距离。
给定起点 start 和终点 destination，你可以顺时针或逆时针沿线路行驶，
返回从 start 到 destination 的最短距离。
1 <= distance.length <= 10^4，1 <= distance[i] <= 10^4，0 <= start, destination < n。',
    'easy',
    1000,
    256,
    ARRAY['数组', '模拟'],
    $json$[
  {
    "input": "distance = [1, 2, 3, 4], start = 0, destination = 1",
    "output": "1"
  },
  {
    "input": "distance = [1, 2, 3, 4], start = 0, destination = 2",
    "output": "3"
  },
  {
    "input": "distance = [1, 2, 3, 4], start = 0, destination = 3",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "distance = [1, 2, 3, 4], start = 0, destination = 1",
    "output": "1"
  },
  {
    "input": "distance = [1, 2, 3, 4], start = 0, destination = 2",
    "output": "3"
  },
  {
    "input": "distance = [1, 2, 3, 4], start = 0, destination = 3",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var distanceBetweenBusStops = function(distance, start, destination) {\n};\n",
  "python": "class Solution:\n    def distanceBetweenBusStops(self, distance: list[int], start: int, destination: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int distanceBetweenBusStops(std::vector<int>& distance, int start, int destination) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int distanceBetweenBusStops(int[] distance, int start, int destination) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "distanceBetweenBusStops",
  "params": [
    {
      "name": "distance",
      "type": "int[]"
    },
    {
      "name": "start",
      "type": "int"
    },
    {
      "name": "destination",
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
          4
        ],
        0,
        1
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
        0,
        2
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
        ],
        0,
        3
      ],
      "expected": 4
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        7,
        10,
        1,
        12,
        11,
        14,
        5,
        0
      ],
      7,
      2
    ],
    "expected": 17
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
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2
      ],
      1,
      0
    ],
    "expected": 1
  },
  {
    "args": [
      [
        5,
        1,
        4
      ],
      2,
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        3,
        6,
        2
      ],
      0,
      2
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
      ],
      3,
      0
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1716,
    '一周中的第几天',
    '给定日期中的日 day、月 month、年 year，返回这一天是星期几。
返回值必须是以下英文名称之一："Monday"、"Tuesday"、"Wednesday"、"Thursday"、"Friday"、"Saturday"、"Sunday"。
输入日期是 1971 年到 2100 年之间的合法日期。',
    'easy',
    1000,
    256,
    ARRAY['数学', '日期'],
    $json$[
  {
    "input": "day = 31, month = 8, year = 2019",
    "output": "\"Saturday\""
  },
  {
    "input": "day = 18, month = 7, year = 1999",
    "output": "\"Sunday\""
  },
  {
    "input": "day = 15, month = 8, year = 1993",
    "output": "\"Sunday\""
  },
  {
    "input": "day = 1, month = 1, year = 1971",
    "output": "\"Friday\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "day = 31, month = 8, year = 2019",
    "output": "\"Saturday\""
  },
  {
    "input": "day = 18, month = 7, year = 1999",
    "output": "\"Sunday\""
  },
  {
    "input": "day = 15, month = 8, year = 1993",
    "output": "\"Sunday\""
  },
  {
    "input": "day = 1, month = 1, year = 1971",
    "output": "\"Friday\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var dayOfTheWeek = function(day, month, year) {\n};\n",
  "python": "class Solution:\n    def dayOfTheWeek(self, day: int, month: int, year: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string dayOfTheWeek(int day, int month, int year) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String dayOfTheWeek(int day, int month, int year) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "dayOfTheWeek",
  "params": [
    {
      "name": "day",
      "type": "int"
    },
    {
      "name": "month",
      "type": "int"
    },
    {
      "name": "year",
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
        31,
        8,
        2019
      ],
      "expected": "Saturday"
    },
    {
      "args": [
        18,
        7,
        1999
      ],
      "expected": "Sunday"
    },
    {
      "args": [
        15,
        8,
        1993
      ],
      "expected": "Sunday"
    },
    {
      "args": [
        1,
        1,
        1971
      ],
      "expected": "Friday"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      1,
      2000
    ],
    "expected": "Saturday"
  },
  {
    "args": [
      29,
      2,
      2020
    ],
    "expected": "Saturday"
  },
  {
    "args": [
      31,
      12,
      1999
    ],
    "expected": "Friday"
  },
  {
    "args": [
      1,
      3,
      2024
    ],
    "expected": "Friday"
  },
  {
    "args": [
      25,
      12,
      2025
    ],
    "expected": "Thursday"
  },
  {
    "args": [
      1,
      1,
      2100
    ],
    "expected": "Friday"
  }
]$json$::jsonb,
    'approved'
),
(
    1717,
    '“气球” 的最大数量',
    '给定字符串 text，其中只包含小写英文字母。使用 text 中的字符（每个字符最多使用一次）拼出尽可能多的单词 "balloon"。
返回最多能拼出的 "balloon" 的个数。
1 <= text.length <= 10^4。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表', '计数'],
    $json$[
  {
    "input": "text = \"nlaebolko\"",
    "output": "1"
  },
  {
    "input": "text = \"loonbalxballpoon\"",
    "output": "2"
  },
  {
    "input": "text = \"leetcode\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "text = \"nlaebolko\"",
    "output": "1"
  },
  {
    "input": "text = \"loonbalxballpoon\"",
    "output": "2"
  },
  {
    "input": "text = \"leetcode\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxNumberOfBalloons = function(text) {\n};\n",
  "python": "class Solution:\n    def maxNumberOfBalloons(self, text: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxNumberOfBalloons(std::string text) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxNumberOfBalloons(String text) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxNumberOfBalloons",
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
        "nlaebolko"
      ],
      "expected": 1
    },
    {
      "args": [
        "loonbalxballpoon"
      ],
      "expected": 2
    },
    {
      "args": [
        "leetcode"
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "balloon"
    ],
    "expected": 1
  },
  {
    "args": [
      "balloonballoon"
    ],
    "expected": 2
  },
  {
    "args": [
      "balon"
    ],
    "expected": 0
  },
  {
    "args": [
      "b"
    ],
    "expected": 0
  },
  {
    "args": [
      "llooonnnbbaa"
    ],
    "expected": 1
  },
  {
    "args": [
      "Balloon"
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1718,
    '奇数值单元格的数目',
    '给定 m 行 n 列的矩阵，初始时所有单元格的值都是 0。另给一个二维索引数组 indices，
其中每个元素 [row, column] 表示对第 row 行的所有单元格加 1，并对第 column 列的所有单元格加 1。
依次执行所有操作后，返回矩阵中值为奇数的单元格数目。
1 <= m, n <= 50，0 <= indices.length <= 100，0 <= indices[i][0] < m，0 <= indices[i][1] < n。',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵', '模拟'],
    $json$[
  {
    "input": "m = 2, n = 3, indices = [[0, 1], [1, 1]]",
    "output": "6"
  },
  {
    "input": "m = 2, n = 2, indices = [[1, 1], [0, 0]]",
    "output": "0"
  },
  {
    "input": "m = 1, n = 1, indices = [[0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "m = 2, n = 3, indices = [[0, 1], [1, 1]]",
    "output": "6"
  },
  {
    "input": "m = 2, n = 2, indices = [[1, 1], [0, 0]]",
    "output": "0"
  },
  {
    "input": "m = 1, n = 1, indices = [[0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var oddCells = function(m, n, indices) {\n};\n",
  "python": "class Solution:\n    def oddCells(self, m: int, n: int, indices: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int oddCells(int m, int n, std::vector<std::vector<int>>& indices) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int oddCells(int m, int n, int[][] indices) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "oddCells",
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
      "name": "indices",
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
        3,
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
      "expected": 6
    },
    {
      "args": [
        2,
        2,
        [
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
        1,
        1,
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
      1,
      1,
      []
    ],
    "expected": 0
  },
  {
    "args": [
      2,
      2,
      []
    ],
    "expected": 0
  },
  {
    "args": [
      3,
      3,
      [
        [
          0,
          0
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      2,
      3,
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
    "expected": 3
  },
  {
    "args": [
      1,
      5,
      [
        [
          0,
          2
        ]
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1719,
    '二维网格迁移',
    '给定 m 行 n 列的二维整数网格 grid 和整数 k。每次迁移操作把每个元素向右移动一个位置，
移出右边界的元素回到下一行的第一个位置，最后一行的最后一个元素回到第一行第一个位置。
返回恰好执行 k 次迁移后的网格。
1 <= m, n <= 50，0 <= k <= 10^9，-1000 <= grid[i][j] <= 1000。',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵', '模拟'],
    $json$[
  {
    "input": "grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9]], k = 1",
    "output": "[[9, 1, 2], [3, 4, 5], [6, 7, 8]]"
  },
  {
    "input": "grid = [[3, 8, 1, 9], [19, 7, 2, 5], [4, 6, 11, 10], [12, 0, 21, 13]], k = 4",
    "output": "[[12, 0, 21, 13], [3, 8, 1, 9], [19, 7, 2, 5], [4, 6, 11, 10]]"
  },
  {
    "input": "grid = [[1, 2], [3, 4]], k = 2",
    "output": "[[3, 4], [1, 2]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9]], k = 1",
    "output": "[[9, 1, 2], [3, 4, 5], [6, 7, 8]]"
  },
  {
    "input": "grid = [[3, 8, 1, 9], [19, 7, 2, 5], [4, 6, 11, 10], [12, 0, 21, 13]], k = 4",
    "output": "[[12, 0, 21, 13], [3, 8, 1, 9], [19, 7, 2, 5], [4, 6, 11, 10]]"
  },
  {
    "input": "grid = [[1, 2], [3, 4]], k = 2",
    "output": "[[3, 4], [1, 2]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var shiftGrid = function(grid, k) {\n};\n",
  "python": "class Solution:\n    def shiftGrid(self, grid: list[list[int]], k: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> shiftGrid(std::vector<std::vector<int>>& grid, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] shiftGrid(int[][] grid, int k) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "shiftGrid",
  "params": [
    {
      "name": "grid",
      "type": "int[][]"
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
        ],
        1
      ],
      "expected": [
        [
          9,
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
    },
    {
      "args": [
        [
          [
            3,
            8,
            1,
            9
          ],
          [
            19,
            7,
            2,
            5
          ],
          [
            4,
            6,
            11,
            10
          ],
          [
            12,
            0,
            21,
            13
          ]
        ],
        4
      ],
      "expected": [
        [
          12,
          0,
          21,
          13
        ],
        [
          3,
          8,
          1,
          9
        ],
        [
          19,
          7,
          2,
          5
        ],
        [
          4,
          6,
          11,
          10
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
        2
      ],
      "expected": [
        [
          3,
          4
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
        [
          1
        ]
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
        [
          1,
          2
        ],
        [
          3,
          4
        ]
      ],
      0
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
          3
        ]
      ],
      1
    ],
    "expected": [
      [
        3,
        1,
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
      ],
      1
    ],
    "expected": [
      [
        3
      ],
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
    "expected": [
      [
        6,
        1,
        2
      ],
      [
        3,
        4,
        5
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
      1000
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
    1720,
    '有序数组中出现次数超过25%的元素',
    '给定一个按非递减顺序排列的整数数组 arr，已知恰好存在一个整数，它在数组中出现的次数严格超过数组长度的 25%。
返回该整数。
1 <= arr.length <= 10^4，0 <= arr[i] <= 10^5。',
    'easy',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "arr = [1, 2, 2, 6, 6, 6, 6, 7, 10]",
    "output": "6"
  },
  {
    "input": "arr = [1, 1]",
    "output": "1"
  },
  {
    "input": "arr = [1, 2, 3, 3]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [1, 2, 2, 6, 6, 6, 6, 7, 10]",
    "output": "6"
  },
  {
    "input": "arr = [1, 1]",
    "output": "1"
  },
  {
    "input": "arr = [1, 2, 3, 3]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findSpecialInteger = function(arr) {\n};\n",
  "python": "class Solution:\n    def findSpecialInteger(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findSpecialInteger(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findSpecialInteger(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findSpecialInteger",
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
          2,
          2,
          6,
          6,
          6,
          6,
          7,
          10
        ]
      ],
      "expected": 6
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
          3,
          3
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
        2,
        3,
        4,
        5,
        6
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        4,
        4,
        4,
        4,
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
        1,
        1,
        2,
        2,
        3,
        3,
        4
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
        1,
        1,
        2,
        2,
        2,
        3,
        3,
        3,
        4,
        4,
        4,
        5,
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
        2,
        3,
        4,
        5,
        6,
        7,
        8
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1721,
    '将整数转换为两个无零整数之和',
    '给定整数 n，返回两个整数 a 和 b，满足 a + b == n，且 a 和 b 的十进制表示中都不含数字 0。
要求 a <= b，并在所有满足条件的数对中选择 a 最小的那一对。返回数组 [a, b]。
2 <= n <= 10^4，题目保证至少存在一组解。',
    'easy',
    1000,
    256,
    ARRAY['数学'],
    $json$[
  {
    "input": "n = 2",
    "output": "[1, 1]"
  },
  {
    "input": "n = 11",
    "output": "[2, 9]"
  },
  {
    "input": "n = 19",
    "output": "[1, 18]"
  },
  {
    "input": "n = 10000",
    "output": "[1, 9999]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 2",
    "output": "[1, 1]"
  },
  {
    "input": "n = 11",
    "output": "[2, 9]"
  },
  {
    "input": "n = 19",
    "output": "[1, 18]"
  },
  {
    "input": "n = 10000",
    "output": "[1, 9999]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var getNoZeroIntegers = function(n) {\n};\n",
  "python": "class Solution:\n    def getNoZeroIntegers(self, n: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> getNoZeroIntegers(int n) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] getNoZeroIntegers(int n) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getNoZeroIntegers",
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
        1,
        1
      ]
    },
    {
      "args": [
        11
      ],
      "expected": [
        2,
        9
      ]
    },
    {
      "args": [
        19
      ],
      "expected": [
        1,
        18
      ]
    },
    {
      "args": [
        10000
      ],
      "expected": [
        1,
        9999
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
      1,
      2
    ]
  },
  {
    "args": [
      8
    ],
    "expected": [
      1,
      7
    ]
  },
  {
    "args": [
      10
    ],
    "expected": [
      1,
      9
    ]
  },
  {
    "args": [
      69
    ],
    "expected": [
      1,
      68
    ]
  },
  {
    "args": [
      101
    ],
    "expected": [
      2,
      99
    ]
  },
  {
    "args": [
      9999
    ],
    "expected": [
      1,
      9998
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1722,
    '6 和 9 组成的最大数字',
    '给定一个只由数字 6 和 9 组成的正整数 num，最多可以将其中一位数字从 6 翻转成 9（也可以不翻转）。
返回能得到的最大数字。
1 <= num <= 10^4。',
    'easy',
    1000,
    256,
    ARRAY['数学', '贪心'],
    $json$[
  {
    "input": "num = 9669",
    "output": "9969"
  },
  {
    "input": "num = 9996",
    "output": "9999"
  },
  {
    "input": "num = 9999",
    "output": "9999"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 9669",
    "output": "9969"
  },
  {
    "input": "num = 9996",
    "output": "9999"
  },
  {
    "input": "num = 9999",
    "output": "9999"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximum69Number = function(num) {\n};\n",
  "python": "class Solution:\n    def maximum69Number(self, num: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximum69Number(int num) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximum69Number(int num) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximum69Number",
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
        9669
      ],
      "expected": 9969
    },
    {
      "args": [
        9996
      ],
      "expected": 9999
    },
    {
      "args": [
        9999
      ],
      "expected": 9999
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      6
    ],
    "expected": 9
  },
  {
    "args": [
      9
    ],
    "expected": 9
  },
  {
    "args": [
      66
    ],
    "expected": 96
  },
  {
    "args": [
      69
    ],
    "expected": 99
  },
  {
    "args": [
      966
    ],
    "expected": 996
  },
  {
    "args": [
      6969
    ],
    "expected": 9969
  }
]$json$::jsonb,
    'approved'
),
(
    1723,
    '删除回文子序列',
    '给定一个只包含字母 ''a'' 和 ''b'' 的字符串 s。每次操作可以删除 s 中的一个非空回文子序列。
返回删除整个字符串所需的最少操作次数。空字符串视为已删除。
1 <= s.length <= 1000。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "s = \"ababa\"",
    "output": "1"
  },
  {
    "input": "s = \"abb\"",
    "output": "2"
  },
  {
    "input": "s = \"baabb\"",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"ababa\"",
    "output": "1"
  },
  {
    "input": "s = \"abb\"",
    "output": "2"
  },
  {
    "input": "s = \"baabb\"",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var removePalindromeSub = function(s) {\n};\n",
  "python": "class Solution:\n    def removePalindromeSub(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int removePalindromeSub(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int removePalindromeSub(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removePalindromeSub",
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
        "ababa"
      ],
      "expected": 1
    },
    {
      "args": [
        "abb"
      ],
      "expected": 2
    },
    {
      "args": [
        "baabb"
      ],
      "expected": 2
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
    "expected": 1
  },
  {
    "args": [
      "aba"
    ],
    "expected": 1
  },
  {
    "args": [
      "abca"
    ],
    "expected": 2
  },
  {
    "args": [
      "abcba"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1724,
    '日期之间隔几天',
    '给定两个日期字符串 date1 和 date2，格式均为 "YYYY-MM-DD"。
返回这两个日期之间相差的天数（取绝对值）。
两个日期都是 1971 年到 2100 年之间的合法日期。',
    'easy',
    1000,
    256,
    ARRAY['数学', '日期'],
    $json$[
  {
    "input": "date1 = \"2019-06-29\", date2 = \"2019-06-30\"",
    "output": "1"
  },
  {
    "input": "date1 = \"2020-01-15\", date2 = \"2019-12-31\"",
    "output": "15"
  },
  {
    "input": "date1 = \"1971-01-01\", date2 = \"1971-01-01\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "date1 = \"2019-06-29\", date2 = \"2019-06-30\"",
    "output": "1"
  },
  {
    "input": "date1 = \"2020-01-15\", date2 = \"2019-12-31\"",
    "output": "15"
  },
  {
    "input": "date1 = \"1971-01-01\", date2 = \"1971-01-01\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var daysBetweenDates = function(date1, date2) {\n};\n",
  "python": "class Solution:\n    def daysBetweenDates(self, date1: str, date2: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int daysBetweenDates(std::string date1, std::string date2) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int daysBetweenDates(String date1, String date2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "daysBetweenDates",
  "params": [
    {
      "name": "date1",
      "type": "string"
    },
    {
      "name": "date2",
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
        "2019-06-29",
        "2019-06-30"
      ],
      "expected": 1
    },
    {
      "args": [
        "2020-01-15",
        "2019-12-31"
      ],
      "expected": 15
    },
    {
      "args": [
        "1971-01-01",
        "1971-01-01"
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "2000-01-01",
      "2000-01-02"
    ],
    "expected": 1
  },
  {
    "args": [
      "2020-02-28",
      "2020-03-01"
    ],
    "expected": 2
  },
  {
    "args": [
      "2019-02-28",
      "2019-03-01"
    ],
    "expected": 1
  },
  {
    "args": [
      "1971-01-01",
      "2100-01-01"
    ],
    "expected": 47117
  },
  {
    "args": [
      "2024-12-31",
      "2025-01-01"
    ],
    "expected": 1
  },
  {
    "args": [
      "2000-02-28",
      "2000-03-01"
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1725,
    '有多少小于当前数字的数字',
    '给定数组 nums，对每个元素 nums[i]，统计数组中严格小于它的元素个数。
返回与 nums 等长的数组作为答案。
1 <= nums.length <= 500，0 <= nums[i] <= 100。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '排序'],
    $json$[
  {
    "input": "nums = [8, 1, 2, 2, 3]",
    "output": "[4, 0, 1, 1, 3]"
  },
  {
    "input": "nums = [6, 5, 4, 8]",
    "output": "[2, 1, 0, 3]"
  },
  {
    "input": "nums = [7, 7, 7, 7]",
    "output": "[0, 0, 0, 0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [8, 1, 2, 2, 3]",
    "output": "[4, 0, 1, 1, 3]"
  },
  {
    "input": "nums = [6, 5, 4, 8]",
    "output": "[2, 1, 0, 3]"
  },
  {
    "input": "nums = [7, 7, 7, 7]",
    "output": "[0, 0, 0, 0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallerNumbersThanCurrent = function(nums) {\n};\n",
  "python": "class Solution:\n    def smallerNumbersThanCurrent(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> smallerNumbersThanCurrent(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] smallerNumbersThanCurrent(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallerNumbersThanCurrent",
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
          8,
          1,
          2,
          2,
          3
        ]
      ],
      "expected": [
        4,
        0,
        1,
        1,
        3
      ]
    },
    {
      "args": [
        [
          6,
          5,
          4,
          8
        ]
      ],
      "expected": [
        2,
        1,
        0,
        3
      ]
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
      "expected": [
        0,
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
        1
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
        2,
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
        3,
        3,
        3
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
      0
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
      0,
      0,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1726,
    '上升下降字符串',
    '给定字符串 s，按以下算法重新排列字符：
从剩余字符中选出最小字符并追加；然后不断选出比上一个追加字符大的最小剩余字符并追加，直到无法继续；
接着选出最大字符并追加，再不断选出比上一个追加字符小的最大剩余字符并追加，直到无法继续；
重复上述上升、下降过程，直到所有字符都被使用。返回重排后的字符串。
1 <= s.length <= 500，s 只包含小写英文字母。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表', '计数'],
    $json$[
  {
    "input": "s = \"aaaabbbbcccc\"",
    "output": "\"abccbaabccba\""
  },
  {
    "input": "s = \"rat\"",
    "output": "\"art\""
  },
  {
    "input": "s = \"leetcode\"",
    "output": "\"cdelotee\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aaaabbbbcccc\"",
    "output": "\"abccbaabccba\""
  },
  {
    "input": "s = \"rat\"",
    "output": "\"art\""
  },
  {
    "input": "s = \"leetcode\"",
    "output": "\"cdelotee\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var sortString = function(s) {\n};\n",
  "python": "class Solution:\n    def sortString(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string sortString(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String sortString(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sortString",
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
        "aaaabbbbcccc"
      ],
      "expected": "abccbaabccba"
    },
    {
      "args": [
        "rat"
      ],
      "expected": "art"
    },
    {
      "args": [
        "leetcode"
      ],
      "expected": "cdelotee"
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
      "abc"
    ],
    "expected": "abc"
  },
  {
    "args": [
      "aab"
    ],
    "expected": "aba"
  },
  {
    "args": [
      "mississippi"
    ],
    "expected": "impsspiissi"
  },
  {
    "args": [
      "zzzzzz"
    ],
    "expected": "zzzzzz"
  }
]$json$::jsonb,
    'approved'
),
(
    1727,
    '生成每种字符都是奇数个的字符串',
    '给定整数 n，返回一个长度为 n 的字符串，使其中每种出现的字符都恰好出现奇数次。
要求：当 n 为奇数时返回 n 个 ''a''；当 n 为偶数时返回 n-1 个 ''a'' 后接 1 个 ''b''。
1 <= n <= 500。',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "n = 1",
    "output": "\"a\""
  },
  {
    "input": "n = 2",
    "output": "\"ab\""
  },
  {
    "input": "n = 3",
    "output": "\"aaa\""
  },
  {
    "input": "n = 4",
    "output": "\"aaab\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 1",
    "output": "\"a\""
  },
  {
    "input": "n = 2",
    "output": "\"ab\""
  },
  {
    "input": "n = 3",
    "output": "\"aaa\""
  },
  {
    "input": "n = 4",
    "output": "\"aaab\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var generateTheString = function(n) {\n};\n",
  "python": "class Solution:\n    def generateTheString(self, n: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string generateTheString(int n) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String generateTheString(int n) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "generateTheString",
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
      "expected": "a"
    },
    {
      "args": [
        2
      ],
      "expected": "ab"
    },
    {
      "args": [
        3
      ],
      "expected": "aaa"
    },
    {
      "args": [
        4
      ],
      "expected": "aaab"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      5
    ],
    "expected": "aaaaa"
  },
  {
    "args": [
      6
    ],
    "expected": "aaaaab"
  },
  {
    "args": [
      7
    ],
    "expected": "aaaaaaa"
  },
  {
    "args": [
      10
    ],
    "expected": "aaaaaaaaab"
  },
  {
    "args": [
      11
    ],
    "expected": "aaaaaaaaaaa"
  },
  {
    "args": [
      100
    ],
    "expected": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab"
  }
]$json$::jsonb,
    'approved'
),
(
    1728,
    '矩阵中的幸运数',
    '给定一个 m 行 n 列的矩阵，矩阵中的数字互不相同。
如果一个元素同时是所在行的最小值且是所在列的最大值，则称它为幸运数。
按升序返回矩阵中所有幸运数组成的数组；没有幸运数时返回空数组。
1 <= m, n <= 50，1 <= matrix[i][j] <= 10^5，矩阵中所有元素互不相同。',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵'],
    $json$[
  {
    "input": "matrix = [[3, 7, 8], [9, 11, 13], [15, 16, 17]]",
    "output": "[15]"
  },
  {
    "input": "matrix = [[1, 10, 4, 2], [9, 3, 8, 7], [15, 16, 17, 12]]",
    "output": "[12]"
  },
  {
    "input": "matrix = [[7, 8], [1, 2]]",
    "output": "[7]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[3, 7, 8], [9, 11, 13], [15, 16, 17]]",
    "output": "[15]"
  },
  {
    "input": "matrix = [[1, 10, 4, 2], [9, 3, 8, 7], [15, 16, 17, 12]]",
    "output": "[12]"
  },
  {
    "input": "matrix = [[7, 8], [1, 2]]",
    "output": "[7]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var luckyNumbers = function(matrix) {\n};\n",
  "python": "class Solution:\n    def luckyNumbers(self, matrix: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> luckyNumbers(std::vector<std::vector<int>>& matrix) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] luckyNumbers(int[][] matrix) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "luckyNumbers",
  "params": [
    {
      "name": "matrix",
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
            7,
            8
          ],
          [
            9,
            11,
            13
          ],
          [
            15,
            16,
            17
          ]
        ]
      ],
      "expected": [
        15
      ]
    },
    {
      "args": [
        [
          [
            1,
            10,
            4,
            2
          ],
          [
            9,
            3,
            8,
            7
          ],
          [
            15,
            16,
            17,
            12
          ]
        ]
      ],
      "expected": [
        12
      ]
    },
    {
      "args": [
        [
          [
            7,
            8
          ],
          [
            1,
            2
          ]
        ]
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
          2
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": [
      3
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
          7,
          8
        ]
      ]
    ],
    "expected": [
      7
    ]
  },
  {
    "args": [
      [
        [
          3,
          6
        ],
        [
          7,
          9
        ]
      ]
    ],
    "expected": [
      7
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
      7
    ]
  },
  {
    "args": [
      [
        [
          9,
          8
        ],
        [
          7,
          6
        ]
      ]
    ],
    "expected": [
      8
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1729,
    '统计最大组的数目',
    '把 1 到 n 的每个整数按其十进制各位数字之和分组。
返回元素个数最多的那些组的组数（若多个组的元素个数并列最多，统计这些组的数量）。
1 <= n <= 10^4。',
    'easy',
    1000,
    256,
    ARRAY['哈希表', '数学'],
    $json$[
  {
    "input": "n = 13",
    "output": "4"
  },
  {
    "input": "n = 2",
    "output": "2"
  },
  {
    "input": "n = 24",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 13",
    "output": "4"
  },
  {
    "input": "n = 2",
    "output": "2"
  },
  {
    "input": "n = 24",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countLargestGroup = function(n) {\n};\n",
  "python": "class Solution:\n    def countLargestGroup(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countLargestGroup(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countLargestGroup(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countLargestGroup",
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
        13
      ],
      "expected": 4
    },
    {
      "args": [
        2
      ],
      "expected": 2
    },
    {
      "args": [
        24
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
      11
    ],
    "expected": 2
  },
  {
    "args": [
      100
    ],
    "expected": 1
  },
  {
    "args": [
      1000
    ],
    "expected": 2
  },
  {
    "args": [
      10000
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1730,
    '非递增顺序的最小子序列',
    '给定数组 nums，从中选出一个子序列，使该子序列的元素之和严格大于剩余元素之和。
在所有满足条件的子序列中，选择长度最短的；若长度相同，选择和最大的。
返回该子序列，按非递增顺序排列。
1 <= nums.length <= 500，1 <= nums[i] <= 100。',
    'easy',
    1000,
    256,
    ARRAY['数组', '贪心', '排序'],
    $json$[
  {
    "input": "nums = [4, 3, 10, 9, 8]",
    "output": "[10, 9]"
  },
  {
    "input": "nums = [4, 4, 7, 6, 7]",
    "output": "[7, 7, 6]"
  },
  {
    "input": "nums = [6]",
    "output": "[6]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [4, 3, 10, 9, 8]",
    "output": "[10, 9]"
  },
  {
    "input": "nums = [4, 4, 7, 6, 7]",
    "output": "[7, 7, 6]"
  },
  {
    "input": "nums = [6]",
    "output": "[6]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minSubsequence = function(nums) {\n};\n",
  "python": "class Solution:\n    def minSubsequence(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> minSubsequence(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] minSubsequence(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minSubsequence",
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
          10,
          9,
          8
        ]
      ],
      "expected": [
        10,
        9
      ]
    },
    {
      "args": [
        [
          4,
          4,
          7,
          6,
          7
        ]
      ],
      "expected": [
        7,
        7,
        6
      ]
    },
    {
      "args": [
        [
          6
        ]
      ],
      "expected": [
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
        1,
        2,
        3,
        4,
        5
      ]
    ],
    "expected": [
      5,
      4
    ]
  },
  {
    "args": [
      [
        2,
        3,
        4
      ]
    ],
    "expected": [
      4,
      3
    ]
  },
  {
    "args": [
      [
        10,
        1
      ]
    ],
    "expected": [
      10
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
      5,
      4
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
      3,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1731,
    '数组中的字符串匹配',
    '给定字符串数组 words，其中所有字符串互不相同。若某个字符串是数组中另一个字符串的子串，
则称它为可匹配字符串。返回所有可匹配字符串，按长度升序排列，长度相同时按字典序升序排列。
1 <= words.length <= 100，1 <= words[i].length <= 30，words[i] 只包含小写英文字母且互不相同。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '数组'],
    $json$[
  {
    "input": "words = [\"mass\", \"as\", \"hero\", \"superhero\"]",
    "output": "[\"as\", \"hero\"]"
  },
  {
    "input": "words = [\"leetcode\", \"et\", \"code\"]",
    "output": "[\"et\", \"code\"]"
  },
  {
    "input": "words = [\"blue\", \"green\", \"bu\"]",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"mass\", \"as\", \"hero\", \"superhero\"]",
    "output": "[\"as\", \"hero\"]"
  },
  {
    "input": "words = [\"leetcode\", \"et\", \"code\"]",
    "output": "[\"et\", \"code\"]"
  },
  {
    "input": "words = [\"blue\", \"green\", \"bu\"]",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var stringMatching = function(words) {\n};\n",
  "python": "class Solution:\n    def stringMatching(self, words: list[str]) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> stringMatching(std::vector<std::string>& words) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] stringMatching(String[] words) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "stringMatching",
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
          "mass",
          "as",
          "hero",
          "superhero"
        ]
      ],
      "expected": [
        "as",
        "hero"
      ]
    },
    {
      "args": [
        [
          "leetcode",
          "et",
          "code"
        ]
      ],
      "expected": [
        "et",
        "code"
      ]
    },
    {
      "args": [
        [
          "blue",
          "green",
          "bu"
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
        "a",
        "ab",
        "abc"
      ]
    ],
    "expected": [
      "a",
      "ab"
    ]
  },
  {
    "args": [
      [
        "xyz",
        "xy",
        "x"
      ]
    ],
    "expected": [
      "x",
      "xy"
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
    "expected": []
  },
  {
    "args": [
      [
        "mass",
        "as",
        "hero",
        "superhero",
        "super"
      ]
    ],
    "expected": [
      "as",
      "hero",
      "super"
    ]
  },
  {
    "args": [
      [
        "aaa",
        "aa",
        "a"
      ]
    ],
    "expected": [
      "a",
      "aa"
    ]
  },
  {
    "args": [
      [
        "abc",
        "bc",
        "c",
        "abcd"
      ]
    ],
    "expected": [
      "c",
      "bc",
      "abc"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1732,
    '逐步求和得到正数的最小值',
    '给定整数数组 nums。选择一个正数 startValue 作为初始值。
从左到右累加 nums 中的元素，要求任意时刻的累加和都大于等于 1。
返回满足条件的最小正整数 startValue。
1 <= nums.length <= 100，-100 <= nums[i] <= 100。',
    'easy',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "nums = [-3, 2, -3, 4, 2]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2]",
    "output": "1"
  },
  {
    "input": "nums = [1, -2, -3]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [-3, 2, -3, 4, 2]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2]",
    "output": "1"
  },
  {
    "input": "nums = [1, -2, -3]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minStartValue = function(nums) {\n};\n",
  "python": "class Solution:\n    def minStartValue(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minStartValue(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minStartValue(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minStartValue",
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
          -3,
          2,
          -3,
          4,
          2
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
    },
    {
      "args": [
        [
          1,
          -2,
          -3
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
        -3
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        2,
        3
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
        -1
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        5,
        -10,
        4
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        2,
        -1,
        2
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1733,
    '重新格式化字符串',
    '给定一个由小写英文字母和数字组成的字符串 s（可能包含两者或只包含其中一种）。
重排字符，使任意两个相邻字符都不是同一类型（字母与数字交替）。
若无法做到则返回空字符串。可以做到时，按以下规则给出唯一结果：
字母数不少于数字数时以字母开头，否则以数字开头；同一类型内部保持字符在原字符串中的相对顺序。
1 <= s.length <= 500。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "s = \"a0b1c2\"",
    "output": "\"a0b1c2\""
  },
  {
    "input": "s = \"leetcode\"",
    "output": "\"\""
  },
  {
    "input": "s = \"1229857369\"",
    "output": "\"\""
  },
  {
    "input": "s = \"covid2019\"",
    "output": "\"c2o0v1i9d\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"a0b1c2\"",
    "output": "\"a0b1c2\""
  },
  {
    "input": "s = \"leetcode\"",
    "output": "\"\""
  },
  {
    "input": "s = \"1229857369\"",
    "output": "\"\""
  },
  {
    "input": "s = \"covid2019\"",
    "output": "\"c2o0v1i9d\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var reformat = function(s) {\n};\n",
  "python": "class Solution:\n    def reformat(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string reformat(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String reformat(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reformat",
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
        "a0b1c2"
      ],
      "expected": "a0b1c2"
    },
    {
      "args": [
        "leetcode"
      ],
      "expected": ""
    },
    {
      "args": [
        "1229857369"
      ],
      "expected": ""
    },
    {
      "args": [
        "covid2019"
      ],
      "expected": "c2o0v1i9d"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "ab123"
    ],
    "expected": "1a2b3"
  },
  {
    "args": [
      "a1"
    ],
    "expected": "a1"
  },
  {
    "args": [
      "1a"
    ],
    "expected": "a1"
  },
  {
    "args": [
      "abc12"
    ],
    "expected": "a1b2c"
  },
  {
    "args": [
      "a0"
    ],
    "expected": "a0"
  },
  {
    "args": [
      "aa00"
    ],
    "expected": "a0a0"
  }
]$json$::jsonb,
    'approved'
),
(
    1734,
    '分割字符串的最大得分',
    '给定一个由 ''0'' 和 ''1'' 组成的字符串 s，把 s 在下标 i 处分割成两个非空子串，
左子串为 s[0..i]，右子串为 s[i+1..n-1]。
得分为左子串中 ''0'' 的个数加上右子串中 ''1'' 的个数。返回所有分割方式中的最大得分。
2 <= s.length <= 500。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '前缀和'],
    $json$[
  {
    "input": "s = \"011101\"",
    "output": "5"
  },
  {
    "input": "s = \"00111\"",
    "output": "5"
  },
  {
    "input": "s = \"1111\"",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"011101\"",
    "output": "5"
  },
  {
    "input": "s = \"00111\"",
    "output": "5"
  },
  {
    "input": "s = \"1111\"",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxScore = function(s) {\n};\n",
  "python": "class Solution:\n    def maxScore(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxScore(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxScore(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxScore",
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
        "011101"
      ],
      "expected": 5
    },
    {
      "args": [
        "00111"
      ],
      "expected": 5
    },
    {
      "args": [
        "1111"
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "01"
    ],
    "expected": 2
  },
  {
    "args": [
      "10"
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
      "0000"
    ],
    "expected": 3
  },
  {
    "args": [
      "0100"
    ],
    "expected": 2
  },
  {
    "args": [
      "101101"
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1735,
    '旅行终点站',
    '给定旅行路线数组 paths，其中每条路线是 [出发城市, 到达城市]。
所有城市用字符串表示，路线构成一条从某个起点城市出发、最终到达某个终点城市的链，不会形成环。
终点城市是只作为到达城市出现、从不作为出发城市出现的城市。返回终点城市。
1 <= paths.length <= 100，路径构成唯一的链。',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表', '图'],
    $json$[
  {
    "input": "paths = [[\"London\", \"New York\"], [\"New York\", \"Lima\"], [\"Lima\", \"Sao Paulo\"]]",
    "output": "\"Sao Paulo\""
  },
  {
    "input": "paths = [[\"B\", \"C\"], [\"D\", \"B\"], [\"C\", \"A\"]]",
    "output": "\"A\""
  },
  {
    "input": "paths = [[\"A\", \"Z\"]]",
    "output": "\"Z\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "paths = [[\"London\", \"New York\"], [\"New York\", \"Lima\"], [\"Lima\", \"Sao Paulo\"]]",
    "output": "\"Sao Paulo\""
  },
  {
    "input": "paths = [[\"B\", \"C\"], [\"D\", \"B\"], [\"C\", \"A\"]]",
    "output": "\"A\""
  },
  {
    "input": "paths = [[\"A\", \"Z\"]]",
    "output": "\"Z\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var destCity = function(paths) {\n};\n",
  "python": "class Solution:\n    def destCity(self, paths: list[list[str]]) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string destCity(std::vector<std::vector<std::string>>& paths) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String destCity(String[][] paths) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "destCity",
  "params": [
    {
      "name": "paths",
      "type": "string[][]"
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
            "London",
            "New York"
          ],
          [
            "New York",
            "Lima"
          ],
          [
            "Lima",
            "Sao Paulo"
          ]
        ]
      ],
      "expected": "Sao Paulo"
    },
    {
      "args": [
        [
          [
            "B",
            "C"
          ],
          [
            "D",
            "B"
          ],
          [
            "C",
            "A"
          ]
        ]
      ],
      "expected": "A"
    },
    {
      "args": [
        [
          [
            "A",
            "Z"
          ]
        ]
      ],
      "expected": "Z"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          "A",
          "B"
        ],
        [
          "B",
          "C"
        ],
        [
          "C",
          "D"
        ]
      ]
    ],
    "expected": "D"
  },
  {
    "args": [
      [
        [
          "X",
          "Y"
        ]
      ]
    ],
    "expected": "Y"
  },
  {
    "args": [
      [
        [
          "P",
          "Q"
        ],
        [
          "R",
          "P"
        ],
        [
          "Q",
          "S"
        ]
      ]
    ],
    "expected": "S"
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
        ],
        [
          "b",
          "c"
        ]
      ]
    ],
    "expected": "d"
  },
  {
    "args": [
      [
        [
          "A",
          "B"
        ],
        [
          "C",
          "D"
        ],
        [
          "B",
          "C"
        ],
        [
          "E",
          "A"
        ]
      ]
    ],
    "expected": "D"
  },
  {
    "args": [
      [
        [
          "M",
          "N"
        ]
      ]
    ],
    "expected": "N"
  }
]$json$::jsonb,
    'approved'
),
(
    1736,
    '去掉最低工资和最高工资后的工资平均值',
    '给定整数数组 salary，其中每个元素表示一个人的工资。去掉一个最低工资和一个最高工资后，
计算剩余工资的平均值。返回该平均值，结果与标准答案的误差在 10^-5 以内均视为正确。
3 <= salary.length <= 100，1000 <= salary[i] <= 10^6，salary 中所有元素互不相同。',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "salary = [4000, 3000, 1000, 2000]",
    "output": "2500.0"
  },
  {
    "input": "salary = [1000, 2000, 3000]",
    "output": "2000.0"
  },
  {
    "input": "salary = [6000, 5000, 4000, 3000, 2000, 1000]",
    "output": "3500.0"
  },
  {
    "input": "salary = [8000, 9000, 2000, 3000, 6000, 1000]",
    "output": "4750.0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "salary = [4000, 3000, 1000, 2000]",
    "output": "2500.0"
  },
  {
    "input": "salary = [1000, 2000, 3000]",
    "output": "2000.0"
  },
  {
    "input": "salary = [6000, 5000, 4000, 3000, 2000, 1000]",
    "output": "3500.0"
  },
  {
    "input": "salary = [8000, 9000, 2000, 3000, 6000, 1000]",
    "output": "4750.0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var average = function(salary) {\n};\n",
  "python": "class Solution:\n    def average(self, salary: list[int]) -> float:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    double average(std::vector<int>& salary) {\n        return 0.0;\n    }\n};\n",
  "java": "class Solution {\n    public double average(int[] salary) {\n        return 0.0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "average",
  "params": [
    {
      "name": "salary",
      "type": "int[]"
    }
  ],
  "return_type": "double",
  "compare": {
    "mode": "double"
  },
  "public_cases": [
    {
      "args": [
        [
          4000,
          3000,
          1000,
          2000
        ]
      ],
      "expected": 2500.0
    },
    {
      "args": [
        [
          1000,
          2000,
          3000
        ]
      ],
      "expected": 2000.0
    },
    {
      "args": [
        [
          6000,
          5000,
          4000,
          3000,
          2000,
          1000
        ]
      ],
      "expected": 3500.0
    },
    {
      "args": [
        [
          8000,
          9000,
          2000,
          3000,
          6000,
          1000
        ]
      ],
      "expected": 4750.0
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
    "expected": 2.0
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
    "expected": 25.0
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
    "expected": 3.0
  },
  {
    "args": [
      [
        1,
        1000,
        100000
      ]
    ],
    "expected": 1000.0
  },
  {
    "args": [
      [
        100,
        200,
        300,
        400,
        500
      ]
    ],
    "expected": 300.0
  },
  {
    "args": [
      [
        2000,
        4000,
        6000,
        8000,
        10000
      ]
    ],
    "expected": 6000.0
  }
]$json$::jsonb,
    'approved'
),
(
    1737,
    '判断路径是否相交',
    '从二维平面上的原点 (0, 0) 出发，按字符串 path 中的字符依次移动：
''N'' 表示向北（y 加 1），''S'' 表示向南（y 减 1），''E'' 表示向东（x 加 1），''W'' 表示向西（x 减 1）。
如果路径在任意时刻（包括经过原点）到达之前已经访问过的点，则返回 true，否则返回 false。
1 <= path.length <= 10^4，path 只包含 ''N''、''S''、''E''、''W''。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表', '模拟'],
    $json$[
  {
    "input": "path = \"NES\"",
    "output": "false"
  },
  {
    "input": "path = \"NESWW\"",
    "output": "true"
  },
  {
    "input": "path = \"N\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "path = \"NES\"",
    "output": "false"
  },
  {
    "input": "path = \"NESWW\"",
    "output": "true"
  },
  {
    "input": "path = \"N\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isPathCrossing = function(path) {\n};\n",
  "python": "class Solution:\n    def isPathCrossing(self, path: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isPathCrossing(std::string path) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isPathCrossing(String path) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isPathCrossing",
  "params": [
    {
      "name": "path",
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
        "NES"
      ],
      "expected": false
    },
    {
      "args": [
        "NESWW"
      ],
      "expected": true
    },
    {
      "args": [
        "N"
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "NNS"
    ],
    "expected": true
  },
  {
    "args": [
      "NN"
    ],
    "expected": false
  },
  {
    "args": [
      "SN"
    ],
    "expected": true
  },
  {
    "args": [
      "ENWS"
    ],
    "expected": true
  },
  {
    "args": [
      "SS"
    ],
    "expected": false
  },
  {
    "args": [
      "NSEW"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1738,
    '文件夹操作日志搜集器',
    '你在主文件夹中，日志 logs 按顺序记录每次操作：
"../" 表示返回上一级文件夹，"./" 表示停留在当前文件夹，
其他形如 "x/" 的字符串表示进入名为 x 的子文件夹。
在主文件夹中执行 "../" 仍停留在主文件夹。
返回完成所有操作后，返回主文件夹所需的最少操作次数（即当前文件夹深度）。',
    'easy',
    1000,
    256,
    ARRAY['栈', '数组', '字符串'],
    $json$[
  {
    "input": "logs = [\"d1/\", \"d2/\", \"../\", \"d21/\", \"./\"]",
    "output": "2"
  },
  {
    "input": "logs = [\"d1/\", \"d2/\", \"./\", \"d3/\", \"../\", \"d31/\"]",
    "output": "3"
  },
  {
    "input": "logs = [\"d1/\", \"../\", \"../\", \"../\"]",
    "output": "0"
  },
  {
    "input": "logs = [\"./\"]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "logs = [\"d1/\", \"d2/\", \"../\", \"d21/\", \"./\"]",
    "output": "2"
  },
  {
    "input": "logs = [\"d1/\", \"d2/\", \"./\", \"d3/\", \"../\", \"d31/\"]",
    "output": "3"
  },
  {
    "input": "logs = [\"d1/\", \"../\", \"../\", \"../\"]",
    "output": "0"
  },
  {
    "input": "logs = [\"./\"]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var crawlerLogFolder = function(logs) {\n};\n",
  "python": "class Solution:\n    def crawlerLogFolder(self, logs: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int crawlerLogFolder(std::vector<std::string>& logs) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int crawlerLogFolder(String[] logs) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "crawlerLogFolder",
  "params": [
    {
      "name": "logs",
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
          "d1/",
          "d2/",
          "../",
          "d21/",
          "./"
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          "d1/",
          "d2/",
          "./",
          "d3/",
          "../",
          "d31/"
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          "d1/",
          "../",
          "../",
          "../"
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          "./"
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
        "d1/",
        "d2/",
        "../",
        "../",
        "../"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "./",
        "./"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "a/",
        "b/",
        "c/",
        "../",
        "./",
        "d/"
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        "a/",
        "b/",
        "../",
        "../"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "x/",
        "y/",
        "../",
        "z/",
        "../",
        "../"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "a/"
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1739,
    '括号的最大嵌套深度',
    '给定一个有效括号字符串 s，它可能同时包含数字和运算符。
字符串中任意一对括号都正确配对。
返回 s 中括号的最大嵌套深度；没有括号时返回 0。
嵌套深度指任意位置同时打开的未闭合括号的最大数量。',
    'easy',
    1000,
    256,
    ARRAY['栈', '字符串'],
    $json$[
  {
    "input": "s = \"(1+(2*3)+((8)/4))+1\"",
    "output": "3"
  },
  {
    "input": "s = \"(1)+((2))+(((3)))\"",
    "output": "3"
  },
  {
    "input": "s = \"()()\"",
    "output": "1"
  },
  {
    "input": "s = \"()\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"(1+(2*3)+((8)/4))+1\"",
    "output": "3"
  },
  {
    "input": "s = \"(1)+((2))+(((3)))\"",
    "output": "3"
  },
  {
    "input": "s = \"()()\"",
    "output": "1"
  },
  {
    "input": "s = \"()\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxNestingDepth = function(s) {\n};\n",
  "python": "class Solution:\n    def maxNestingDepth(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxNestingDepth(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxNestingDepth(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxNestingDepth",
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
        "(1+(2*3)+((8)/4))+1"
      ],
      "expected": 3
    },
    {
      "args": [
        "(1)+((2))+(((3)))"
      ],
      "expected": 3
    },
    {
      "args": [
        "()()"
      ],
      "expected": 1
    },
    {
      "args": [
        "()"
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "((()))"
    ],
    "expected": 3
  },
  {
    "args": [
      "(())()"
    ],
    "expected": 2
  },
  {
    "args": [
      "1"
    ],
    "expected": 0
  },
  {
    "args": [
      "1+(2*3)/(2-1)"
    ],
    "expected": 1
  },
  {
    "args": [
      "(((1)))"
    ],
    "expected": 3
  },
  {
    "args": [
      "(1)"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1740,
    '整理字符串',
    '给定由英文字母组成的字符串 s。
如果相邻两个字符是同一个字母的大小写形式（如 "aA" 或 "Bb"），
则删除这两个字符；删除后可能产生新的相邻可删除字符，继续删除。
重复该过程直到无法删除，返回整理后的字符串。
可以证明最终结果与删除顺序无关。',
    'easy',
    1000,
    256,
    ARRAY['栈', '字符串'],
    $json$[
  {
    "input": "s = \"leEeetcode\"",
    "output": "\"leetcode\""
  },
  {
    "input": "s = \"abBAcC\"",
    "output": "\"\""
  },
  {
    "input": "s = \"s\"",
    "output": "\"s\""
  },
  {
    "input": "s = \"Pp\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"leEeetcode\"",
    "output": "\"leetcode\""
  },
  {
    "input": "s = \"abBAcC\"",
    "output": "\"\""
  },
  {
    "input": "s = \"s\"",
    "output": "\"s\""
  },
  {
    "input": "s = \"Pp\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var makeStringGreat = function(s) {\n};\n",
  "python": "class Solution:\n    def makeStringGreat(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string makeStringGreat(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String makeStringGreat(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "makeStringGreat",
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
        "leEeetcode"
      ],
      "expected": "leetcode"
    },
    {
      "args": [
        "abBAcC"
      ],
      "expected": ""
    },
    {
      "args": [
        "s"
      ],
      "expected": "s"
    },
    {
      "args": [
        "Pp"
      ],
      "expected": ""
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "AaBbCc"
    ],
    "expected": ""
  },
  {
    "args": [
      "aAbBcC"
    ],
    "expected": ""
  },
  {
    "args": [
      "abcCBA"
    ],
    "expected": ""
  },
  {
    "args": [
      "abBA"
    ],
    "expected": ""
  },
  {
    "args": [
      "aBa"
    ],
    "expected": "aBa"
  },
  {
    "args": [
      "mC"
    ],
    "expected": "mC"
  },
  {
    "args": [
      "abc"
    ],
    "expected": "abc"
  }
]$json$::jsonb,
    'approved'
),
(
    1741,
    '自除数',
    '自除数指可以被其每一位数字整除的正整数，且其中不含数字 0。
例如 128 是自除数，因为 128 能被 1、2、8 整除；
10 不是自除数，因为它含有数字 0。
给定两个正整数 left 和 right，返回闭区间 [left, right] 内所有自除数，
按升序排列。',
    'easy',
    1000,
    256,
    ARRAY['数学', '枚举'],
    $json$[
  {
    "input": "left = 1, right = 22",
    "output": "[1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 15, 22]"
  },
  {
    "input": "left = 47, right = 85",
    "output": "[48, 55, 66, 77]"
  },
  {
    "input": "left = 1, right = 1",
    "output": "[1]"
  },
  {
    "input": "left = 10, right = 12",
    "output": "[11, 12]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "left = 1, right = 22",
    "output": "[1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 15, 22]"
  },
  {
    "input": "left = 47, right = 85",
    "output": "[48, 55, 66, 77]"
  },
  {
    "input": "left = 1, right = 1",
    "output": "[1]"
  },
  {
    "input": "left = 10, right = 12",
    "output": "[11, 12]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var selfDividingNumbers = function(left, right) {\n};\n",
  "python": "class Solution:\n    def selfDividingNumbers(self, left: int, right: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> selfDividingNumbers(int left, int right) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] selfDividingNumbers(int left, int right) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "selfDividingNumbers",
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
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        1,
        22
      ],
      "expected": [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        11,
        12,
        15,
        22
      ]
    },
    {
      "args": [
        47,
        85
      ],
      "expected": [
        48,
        55,
        66,
        77
      ]
    },
    {
      "args": [
        1,
        1
      ],
      "expected": [
        1
      ]
    },
    {
      "args": [
        10,
        12
      ],
      "expected": [
        11,
        12
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      10
    ],
    "expected": [
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
  },
  {
    "args": [
      22,
      22
    ],
    "expected": [
      22
    ]
  },
  {
    "args": [
      100,
      100
    ],
    "expected": []
  },
  {
    "args": [
      128,
      128
    ],
    "expected": [
      128
    ]
  },
  {
    "args": [
      13,
      15
    ],
    "expected": [
      15
    ]
  },
  {
    "args": [
      99,
      99
    ],
    "expected": [
      99
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1742,
    '删除链表中的节点',
    '给定一个整数数组 head 表示单链表各节点的值，以及整数 val。
链表中恰有一个节点的值为 val，各节点值互不相同，且该节点保证不是尾节点。
你只能访问值为 val 的那个节点本身，不能访问链表头。
删除该节点的方法是：把下一个节点的值复制到当前节点，再删除下一个节点。
返回删除后的链表值数组。',
    'easy',
    1000,
    256,
    ARRAY['链表'],
    $json$[
  {
    "input": "head = [4, 5, 1, 9], val = 5",
    "output": "[4, 1, 9]"
  },
  {
    "input": "head = [4, 5, 1, 9], val = 1",
    "output": "[4, 5, 9]"
  },
  {
    "input": "head = [1, 2], val = 1",
    "output": "[2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [4, 5, 1, 9], val = 5",
    "output": "[4, 1, 9]"
  },
  {
    "input": "head = [4, 5, 1, 9], val = 1",
    "output": "[4, 5, 9]"
  },
  {
    "input": "head = [1, 2], val = 1",
    "output": "[2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var deleteNodeCopy = function(head, val) {\n};\n",
  "python": "class Solution:\n    def deleteNodeCopy(self, head: list[int], val: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> deleteNodeCopy(std::vector<int>& head, int val) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] deleteNodeCopy(int[] head, int val) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "deleteNodeCopy",
  "params": [
    {
      "name": "head",
      "type": "int[]"
    },
    {
      "name": "val",
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
          4,
          5,
          1,
          9
        ],
        5
      ],
      "expected": [
        4,
        1,
        9
      ]
    },
    {
      "args": [
        [
          4,
          5,
          1,
          9
        ],
        1
      ],
      "expected": [
        4,
        5,
        9
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
      2
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
        2,
        3,
        4
      ],
      3
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
        6,
        7
      ],
      5
    ],
    "expected": [
      6,
      7
    ]
  },
  {
    "args": [
      [
        0,
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
        3,
        4,
        5
      ],
      4
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
        7,
        8,
        9
      ],
      8
    ],
    "expected": [
      7,
      9
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1743,
    '移除重复节点',
    '给定一个未排序的整数数组 head 表示单链表各节点的值。
移除所有重复值的节点，只保留每个值第一次出现的节点，并保持剩余节点的原有顺序。
返回处理后的链表值数组。',
    'easy',
    1000,
    256,
    ARRAY['链表', '哈希表'],
    $json$[
  {
    "input": "head = [1, 2, 3, 3, 2, 1]",
    "output": "[1, 2, 3]"
  },
  {
    "input": "head = [1, 1, 1, 1, 2]",
    "output": "[1, 2]"
  },
  {
    "input": "head = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 2, 3, 3, 2, 1]",
    "output": "[1, 2, 3]"
  },
  {
    "input": "head = [1, 1, 1, 1, 2]",
    "output": "[1, 2]"
  },
  {
    "input": "head = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeDuplicateNodes = function(head) {\n};\n",
  "python": "class Solution:\n    def removeDuplicateNodes(self, head: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> removeDuplicateNodes(std::vector<int>& head) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] removeDuplicateNodes(int[] head) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeDuplicateNodes",
  "params": [
    {
      "name": "head",
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
        2,
        3,
        3,
        2,
        1,
        4
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
      4
    ]
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
    "expected": [
      1,
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
      2,
      1
    ]
  },
  {
    "args": [
      [
        7,
        7,
        7,
        8,
        9,
        8,
        9,
        10
      ]
    ],
    "expected": [
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
    1744,
    '从尾到头打印链表',
    '给定一个整数数组 head 表示单链表各节点的值。
返回从链表尾部到头部依次取出的节点值组成的数组。
链表为空时返回空数组。',
    'easy',
    1000,
    256,
    ARRAY['链表', '栈', '递归'],
    $json$[
  {
    "input": "head = [1, 3, 2]",
    "output": "[2, 3, 1]"
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
    "input": "head = [1, 3, 2]",
    "output": "[2, 3, 1]"
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
  "javascript": "var reversePrint = function(head) {\n};\n",
  "python": "class Solution:\n    def reversePrint(self, head: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> reversePrint(std::vector<int>& head) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] reversePrint(int[] head) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reversePrint",
  "params": [
    {
      "name": "head",
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
          3,
          2
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
        2,
        3,
        4,
        5
      ]
    ],
    "expected": [
      5,
      4,
      3,
      2,
      1
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
        4,
        6,
        8,
        10
      ]
    ],
    "expected": [
      10,
      8,
      6,
      4,
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
      9
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1745,
    '二叉树的前序遍历',
    '给定一棵二叉树，以层序数组表示，None 表示空位。
返回其前序遍历的节点值数组，顺序为：根节点、左子树、右子树。
空树返回空数组。',
    'easy',
    1000,
    256,
    ARRAY['二叉树', '深度优先搜索', '栈'],
    $json$[
  {
    "input": "root = [1, null, 2, 3]",
    "output": "[1, 2, 3]"
  },
  {
    "input": "root = [1, 2, 3, 4, 5, null, 6]",
    "output": "[1, 2, 4, 5, 3, 6]"
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
    "input": "root = [1, null, 2, 3]",
    "output": "[1, 2, 3]"
  },
  {
    "input": "root = [1, 2, 3, 4, 5, null, 6]",
    "output": "[1, 2, 4, 5, 3, 6]"
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
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar preorderTraversal = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def preorderTraversal(self, root: TreeNode | None) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::vector<int> preorderTraversal(TreeNode* root) {\n        return {};\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int[] preorderTraversal(TreeNode root) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "preorderTraversal",
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
          null,
          6
        ]
      ],
      "expected": [
        1,
        2,
        4,
        5,
        3,
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
        null,
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
      2,
      4,
      5,
      3,
      6,
      7
    ]
  },
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
      3,
      9,
      20,
      15,
      7
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
      1,
      2,
      4,
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1746,
    '二叉树的后序遍历',
    '给定一棵二叉树，以层序数组表示，None 表示空位。
返回其后序遍历的节点值数组，顺序为：左子树、右子树、根节点。
空树返回空数组。',
    'easy',
    1000,
    256,
    ARRAY['二叉树', '深度优先搜索', '栈'],
    $json$[
  {
    "input": "root = [1, null, 2, 3]",
    "output": "[3, 2, 1]"
  },
  {
    "input": "root = [1, 2, 3, 4, 5, null, 6]",
    "output": "[4, 5, 2, 6, 3, 1]"
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
    "input": "root = [1, null, 2, 3]",
    "output": "[3, 2, 1]"
  },
  {
    "input": "root = [1, 2, 3, 4, 5, null, 6]",
    "output": "[4, 5, 2, 6, 3, 1]"
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
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar postorderTraversal = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def postorderTraversal(self, root: TreeNode | None) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::vector<int> postorderTraversal(TreeNode* root) {\n        return {};\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int[] postorderTraversal(TreeNode root) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "postorderTraversal",
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
        3,
        2,
        1
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
        4,
        5,
        2,
        6,
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
        1,
        null,
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
        1,
        2,
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
      2,
      6,
      7,
      3,
      1
    ]
  },
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
      9,
      15,
      7,
      20,
      3
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
      4,
      2,
      3,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1747,
    '二叉树的层序遍历 II',
    '给定一棵二叉树，以层序数组表示，None 表示空位。
返回自底向上的层序遍历结果：先返回最底层，从左到右；
再返回上一层的从左到右结果，依此类推，直到根节点。
空树返回空数组。',
    'easy',
    1000,
    256,
    ARRAY['二叉树', '广度优先搜索'],
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "[[15, 7], [9, 20], [3]]"
  },
  {
    "input": "root = [1]",
    "output": "[[1]]"
  },
  {
    "input": "root = []",
    "output": "[]"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "[[2, 3], [1]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 9, 20, null, null, 15, 7]",
    "output": "[[15, 7], [9, 20], [3]]"
  },
  {
    "input": "root = [1]",
    "output": "[[1]]"
  },
  {
    "input": "root = []",
    "output": "[]"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "[[2, 3], [1]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar levelOrderBottom = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def levelOrderBottom(self, root: TreeNode | None) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> levelOrderBottom(TreeNode* root) {\n        return {};\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int[][] levelOrderBottom(TreeNode root) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "levelOrderBottom",
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
          15,
          7
        ],
        [
          9,
          20
        ],
        [
          3
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
        []
      ],
      "expected": []
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
          2,
          3
        ],
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
        1,
        2,
        null,
        3
      ]
    ],
    "expected": [
      [
        3
      ],
      [
        2
      ],
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
        4,
        5
      ]
    ],
    "expected": [
      [
        4,
        5
      ],
      [
        2,
        3
      ],
      [
        1
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
        2
      ],
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
        3,
        null,
        4
      ]
    ],
    "expected": [
      [
        4
      ],
      [
        3
      ],
      [
        2
      ],
      [
        1
      ]
    ]
  },
  {
    "args": [
      [
        0,
        2,
        4,
        1,
        null,
        3,
        -1,
        5,
        1,
        null,
        6,
        null,
        8
      ]
    ],
    "expected": [
      [
        5,
        1,
        6,
        8
      ],
      [
        1,
        3,
        -1
      ],
      [
        2,
        4
      ],
      [
        0
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1748,
    '将有序数组转换为二叉搜索树',
    '给定一个严格递增的整数数组 nums。
把它转换为一棵高度平衡的二叉搜索树。
构造规则固定为：对当前区间取中间下标作为根节点，
区间长度为偶数时取偏左的中间下标，然后递归构造左右子树。
返回按层序序列化的结果，None 表示空位，末尾连续的空位省略。',
    'easy',
    1000,
    256,
    ARRAY['二叉树', '二叉搜索树', '分治'],
    $json$[
  {
    "input": "nums = [-10, -3, 0, 5, 9]",
    "output": "[0, -10, 5, null, -3, null, 9]"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "[2, 1, 3]"
  },
  {
    "input": "nums = [1]",
    "output": "[1]"
  },
  {
    "input": "nums = [1, 2]",
    "output": "[1, null, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [-10, -3, 0, 5, 9]",
    "output": "[0, -10, 5, null, -3, null, 9]"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "[2, 1, 3]"
  },
  {
    "input": "nums = [1]",
    "output": "[1]"
  },
  {
    "input": "nums = [1, 2]",
    "output": "[1, null, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar sortedArrayToBST = function(nums) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def sortedArrayToBST(self, nums: list[int]) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* sortedArrayToBST(std::vector<int>& nums) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode sortedArrayToBST(int[] nums) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sortedArrayToBST",
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
          -10,
          -3,
          0,
          5,
          9
        ]
      ],
      "expected": [
        0,
        -10,
        5,
        null,
        -3,
        null,
        9
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
        1,
        2,
        3,
        4
      ]
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
        -1,
        0,
        1,
        2
      ]
    ],
    "expected": [
      0,
      -1,
      1,
      null,
      null,
      null,
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
        5
      ]
    ],
    "expected": [
      2,
      0,
      4,
      null,
      1,
      3,
      5
    ]
  },
  {
    "args": [
      [
        -5,
        -4,
        -3,
        -2,
        -1
      ]
    ],
    "expected": [
      -3,
      -5,
      -2,
      null,
      -4,
      null,
      -1
    ]
  },
  {
    "args": [
      [
        2,
        5,
        8,
        11,
        14,
        17,
        20
      ]
    ],
    "expected": [
      11,
      5,
      17,
      2,
      8,
      14,
      20
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1749,
    '二叉搜索树的最近公共祖先',
    '给定一棵二叉搜索树，以层序数组表示，None 表示空位。
树中节点值互不相同，p 和 q 是两个不同节点的值，且都存在于树中。
返回 p 和 q 的最近公共祖先节点的值。
最近公共祖先指同时是 p、q 祖先且深度最大的节点，节点也可以是自身的祖先。',
    'easy',
    1000,
    256,
    ARRAY['二叉树', '二叉搜索树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [6, 2, 8, 0, 4, 7, 9, null, null, 3, 5], p = 2, q = 8",
    "output": "6"
  },
  {
    "input": "root = [6, 2, 8, 0, 4, 7, 9, null, null, 3, 5], p = 2, q = 4",
    "output": "2"
  },
  {
    "input": "root = [2, 1], p = 2, q = 1",
    "output": "2"
  },
  {
    "input": "root = [2, 1], p = 1, q = 2",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [6, 2, 8, 0, 4, 7, 9, null, null, 3, 5], p = 2, q = 8",
    "output": "6"
  },
  {
    "input": "root = [6, 2, 8, 0, 4, 7, 9, null, null, 3, 5], p = 2, q = 4",
    "output": "2"
  },
  {
    "input": "root = [2, 1], p = 2, q = 1",
    "output": "2"
  },
  {
    "input": "root = [2, 1], p = 1, q = 2",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar lowestCommonAncestorBST = function(root, p, q) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def lowestCommonAncestorBST(self, root: TreeNode | None, p: int, q: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int lowestCommonAncestorBST(TreeNode* root, int p, int q) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int lowestCommonAncestorBST(TreeNode root, int p, int q) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "lowestCommonAncestorBST",
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
        2,
        8
      ],
      "expected": 6
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
        2,
        4
      ],
      "expected": 2
    },
    {
      "args": [
        [
          2,
          1
        ],
        2,
        1
      ],
      "expected": 2
    },
    {
      "args": [
        [
          2,
          1
        ],
        1,
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
      0,
      5
    ],
    "expected": 2
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
      7,
      9
    ],
    "expected": 8
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
      0,
      9
    ],
    "expected": 6
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
      1,
      4
    ],
    "expected": 3
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
      2,
      4
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1750,
    '二叉树中第二小的节点',
    '给定一棵特殊的二叉树，以层序数组表示，None 表示空位。
每个节点的值都等于其子节点中较小的那个值（叶子节点除外），
因此根节点的值是整棵树中的最小值。
返回所有节点值中严格大于最小值的那个最小值，即第二小的值。
如果所有节点值都相同，返回 -1。',
    'easy',
    1000,
    256,
    ARRAY['二叉树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [2, 2, 5, null, null, 5, 7]",
    "output": "5"
  },
  {
    "input": "root = [2, 2, 2]",
    "output": "-1"
  },
  {
    "input": "root = [5, 5, 6]",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [2, 2, 5, null, null, 5, 7]",
    "output": "5"
  },
  {
    "input": "root = [2, 2, 2]",
    "output": "-1"
  },
  {
    "input": "root = [5, 5, 6]",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar findSecondMinimumValue = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def findSecondMinimumValue(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int findSecondMinimumValue(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int findSecondMinimumValue(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findSecondMinimumValue",
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
          2,
          2,
          5,
          null,
          null,
          5,
          7
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        [
          2,
          2,
          2
        ]
      ],
      "expected": -1
    },
    {
      "args": [
        [
          5,
          5,
          6
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
        2,
        null,
        null,
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
        2,
        2,
        2,
        2,
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
        2,
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
        1,
        1,
        1,
        1,
        1,
        1,
        2
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1751,
    '递增顺序搜索树',
    '给定一棵二叉搜索树，以层序数组表示，None 表示空位。
按中序遍历的顺序重新排列所有节点，使新树只有右子节点，
并且每个节点的值都递增。
返回新树的层序序列化结果，None 表示空位，末尾连续空位省略。',
    'easy',
    1000,
    256,
    ARRAY['二叉树', '二叉搜索树', '中序遍历'],
    $json$[
  {
    "input": "root = [5, 3, 6, 2, 4, null, 8, 1, null, null, null, 7, 9]",
    "output": "[1, null, 2, null, 3, null, 4, null, 5, null, 6, null, 7, null, 8, null, 9]"
  },
  {
    "input": "root = [5, 1, 7]",
    "output": "[1, null, 5, null, 7]"
  },
  {
    "input": "root = [1, null, 2]",
    "output": "[1, null, 2]"
  },
  {
    "input": "root = [2, 1, 3]",
    "output": "[1, null, 2, null, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [5, 3, 6, 2, 4, null, 8, 1, null, null, null, 7, 9]",
    "output": "[1, null, 2, null, 3, null, 4, null, 5, null, 6, null, 7, null, 8, null, 9]"
  },
  {
    "input": "root = [5, 1, 7]",
    "output": "[1, null, 5, null, 7]"
  },
  {
    "input": "root = [1, null, 2]",
    "output": "[1, null, 2]"
  },
  {
    "input": "root = [2, 1, 3]",
    "output": "[1, null, 2, null, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar increasingBST = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def increasingBST(self, root: TreeNode | None) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* increasingBST(TreeNode* root) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode increasingBST(TreeNode root) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "increasingBST",
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
          5,
          3,
          6,
          2,
          4,
          null,
          8,
          1,
          null,
          null,
          null,
          7,
          9
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
        6,
        null,
        7,
        null,
        8,
        null,
        9
      ]
    },
    {
      "args": [
        [
          5,
          1,
          7
        ]
      ],
      "expected": [
        1,
        null,
        5,
        null,
        7
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
        null,
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
        null,
        2,
        null,
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
        2,
        4,
        1
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
        10,
        5,
        15
      ]
    ],
    "expected": [
      5,
      null,
      10,
      null,
      15
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
        4,
        2,
        5,
        1,
        3
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
        6,
        4,
        9,
        2,
        5,
        8,
        10
      ]
    ],
    "expected": [
      2,
      null,
      4,
      null,
      5,
      null,
      6,
      null,
      8,
      null,
      9,
      null,
      10
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1752,
    '从根到叶的二进制数之和',
    '给定一棵二叉树，以层序数组表示，None 表示空位。
每个节点的值都是 0 或 1。
每条从根节点到叶节点的路径按从上到下的顺序组成一个二进制数。
返回所有从根到叶路径所表示数值的总和（十进制）。
叶子节点指没有子节点的节点。',
    'easy',
    1000,
    256,
    ARRAY['二叉树', '深度优先搜索', '位运算'],
    $json$[
  {
    "input": "root = [1, 0, 1, 0, 1, 0, 1]",
    "output": "22"
  },
  {
    "input": "root = [0]",
    "output": "0"
  },
  {
    "input": "root = [1]",
    "output": "1"
  },
  {
    "input": "root = [1, 1]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 0, 1, 0, 1, 0, 1]",
    "output": "22"
  },
  {
    "input": "root = [0]",
    "output": "0"
  },
  {
    "input": "root = [1]",
    "output": "1"
  },
  {
    "input": "root = [1, 1]",
    "output": "3"
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
          0,
          1,
          0,
          1,
          0,
          1
        ]
      ],
      "expected": 22
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
    },
    {
      "args": [
        [
          1,
          1
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
        1,
        0
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        1,
        0
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        1,
        null,
        0
      ]
    ],
    "expected": 2
  },
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
        1,
        0,
        0,
        1
      ]
    ],
    "expected": 7
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
    "expected": 12
  }
]$json$::jsonb,
    'approved'
),
(
    1753,
    '二叉树的堂兄弟节点',
    '给定一棵二叉树，以层序数组表示，None 表示空位，节点值互不相同。
再给定两个节点值 x 和 y。
如果两个节点深度相同但父节点不同，则它们是堂兄弟节点，返回 true；
否则返回 false。深度指从根到该节点经过的边数。
x 和 y 保证都存在于树中且不相等。',
    'easy',
    1000,
    256,
    ARRAY['二叉树', '广度优先搜索', '深度优先搜索'],
    $json$[
  {
    "input": "root = [1, 2, 3, 4], x = 4, y = 3",
    "output": "false"
  },
  {
    "input": "root = [1, 2, 3, null, 4, null, 5], x = 5, y = 4",
    "output": "true"
  },
  {
    "input": "root = [1, 2, 3, null, 4], x = 2, y = 3",
    "output": "false"
  },
  {
    "input": "root = [1, 2, 3], x = 2, y = 3",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3, 4], x = 4, y = 3",
    "output": "false"
  },
  {
    "input": "root = [1, 2, 3, null, 4, null, 5], x = 5, y = 4",
    "output": "true"
  },
  {
    "input": "root = [1, 2, 3, null, 4], x = 2, y = 3",
    "output": "false"
  },
  {
    "input": "root = [1, 2, 3], x = 2, y = 3",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar isCousins = function(root, x, y) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def isCousins(self, root: TreeNode | None, x: int, y: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool isCousins(TreeNode* root, int x, int y) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean isCousins(TreeNode root, int x, int y) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isCousins",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    },
    {
      "name": "x",
      "type": "int"
    },
    {
      "name": "y",
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
          4
        ],
        4,
        3
      ],
      "expected": false
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
        ],
        5,
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
          null,
          4
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
          2,
          3
        ],
        2,
        3
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
        4,
        5,
        6,
        7
      ],
      4,
      7
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
      ],
      4,
      5
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
        5,
        6,
        7
      ],
      4,
      6
    ],
    "expected": true
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
      ],
      4,
      5
    ],
    "expected": true
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
    "expected": false
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
      ],
      2,
      3
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1754,
    '计算布尔二叉树的值',
    '给定一棵满二叉树，以层序数组表示，None 表示空位。
叶子节点的值为 0 或 1，表示 false 或 true。
内部节点的值为 2 或 3：2 表示对左右子节点的布尔值做逻辑或，3 表示做逻辑与。
返回根节点所代表的布尔值。',
    'easy',
    1000,
    256,
    ARRAY['二叉树', '深度优先搜索', '递归'],
    $json$[
  {
    "input": "root = [2, 1, 3, null, null, 0, 1]",
    "output": "true"
  },
  {
    "input": "root = [0]",
    "output": "false"
  },
  {
    "input": "root = [1]",
    "output": "true"
  },
  {
    "input": "root = [3, 0, 1]",
    "output": "false"
  },
  {
    "input": "root = [2, 0, 0]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [2, 1, 3, null, null, 0, 1]",
    "output": "true"
  },
  {
    "input": "root = [0]",
    "output": "false"
  },
  {
    "input": "root = [1]",
    "output": "true"
  },
  {
    "input": "root = [3, 0, 1]",
    "output": "false"
  },
  {
    "input": "root = [2, 0, 0]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar evaluateTree = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def evaluateTree(self, root: TreeNode | None) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool evaluateTree(TreeNode* root) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean evaluateTree(TreeNode root) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "evaluateTree",
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
          3,
          null,
          null,
          0,
          1
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
        [
          3,
          0,
          1
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          2,
          0,
          0
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
        3,
        2,
        0,
        1,
        0,
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
        0
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
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
        2,
        1,
        0,
        1
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1755,
    '判断根结点是否等于子结点之和',
    '给定一棵二叉树，以层序数组表示。
该树恰好有三个节点：根节点、左子节点和右子节点。
判断根节点的值是否等于左子节点与右子节点值之和，返回 true 或 false。',
    'easy',
    1000,
    256,
    ARRAY['二叉树'],
    $json$[
  {
    "input": "root = [10, 4, 6]",
    "output": "true"
  },
  {
    "input": "root = [5, 3, 1]",
    "output": "false"
  },
  {
    "input": "root = [2, 1, 1]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [10, 4, 6]",
    "output": "true"
  },
  {
    "input": "root = [5, 3, 1]",
    "output": "false"
  },
  {
    "input": "root = [2, 1, 1]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar checkTree = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def checkTree(self, root: TreeNode | None) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool checkTree(TreeNode* root) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean checkTree(TreeNode root) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkTree",
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
          10,
          4,
          6
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          5,
          3,
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
        -2,
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
        100,
        50,
        50
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        -5,
        -3,
        -2
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1756,
    '汉明距离',
    '给定两个非负整数 x 和 y。
汉明距离指两个数的二进制表示中对应位不同的位置数量。
返回 x 和 y 的汉明距离。',
    'easy',
    1000,
    256,
    ARRAY['位运算'],
    $json$[
  {
    "input": "x = 1, y = 4",
    "output": "2"
  },
  {
    "input": "x = 3, y = 1",
    "output": "1"
  },
  {
    "input": "x = 0, y = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "x = 1, y = 4",
    "output": "2"
  },
  {
    "input": "x = 3, y = 1",
    "output": "1"
  },
  {
    "input": "x = 0, y = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var hammingDistance = function(x, y) {\n};\n",
  "python": "class Solution:\n    def hammingDistance(self, x: int, y: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int hammingDistance(int x, int y) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int hammingDistance(int x, int y) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "hammingDistance",
  "params": [
    {
      "name": "x",
      "type": "int"
    },
    {
      "name": "y",
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
        4
      ],
      "expected": 2
    },
    {
      "args": [
        3,
        1
      ],
      "expected": 1
    },
    {
      "args": [
        0,
        0
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      0,
      2147483647
    ],
    "expected": 31
  },
  {
    "args": [
      7,
      7
    ],
    "expected": 0
  },
  {
    "args": [
      10,
      15
    ],
    "expected": 2
  },
  {
    "args": [
      1,
      2
    ],
    "expected": 2
  },
  {
    "args": [
      123,
      456
    ],
    "expected": 6
  },
  {
    "args": [
      2147483647,
      0
    ],
    "expected": 31
  }
]$json$::jsonb,
    'approved'
),
(
    1757,
    '4 的幂',
    '给定一个整数 n，判断它是否是 4 的幂。
若存在整数 k 使得 n == 4^k，则返回 true，其中 k 为非负整数。
负数、0 以及不是 4 的幂的整数都返回 false。',
    'easy',
    1000,
    256,
    ARRAY['位运算', '数学', '递归'],
    $json$[
  {
    "input": "n = 16",
    "output": "true"
  },
  {
    "input": "n = 5",
    "output": "false"
  },
  {
    "input": "n = 1",
    "output": "true"
  },
  {
    "input": "n = 0",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 16",
    "output": "true"
  },
  {
    "input": "n = 5",
    "output": "false"
  },
  {
    "input": "n = 1",
    "output": "true"
  },
  {
    "input": "n = 0",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isPowerOfFour = function(n) {\n};\n",
  "python": "class Solution:\n    def isPowerOfFour(self, n: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isPowerOfFour(int n) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isPowerOfFour(int n) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isPowerOfFour",
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
        16
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
        1
      ],
      "expected": true
    },
    {
      "args": [
        0
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      4
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
      64
    ],
    "expected": true
  },
  {
    "args": [
      -16
    ],
    "expected": false
  },
  {
    "args": [
      1073741824
    ],
    "expected": true
  },
  {
    "args": [
      8
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1758,
    '3 的幂',
    '给定一个整数 n，判断它是否是 3 的幂。
若存在整数 k 使得 n == 3^k，则返回 true，其中 k 为非负整数。
负数、0 以及不是 3 的幂的整数都返回 false。',
    'easy',
    1000,
    256,
    ARRAY['数学', '递归'],
    $json$[
  {
    "input": "n = 27",
    "output": "true"
  },
  {
    "input": "n = 0",
    "output": "false"
  },
  {
    "input": "n = 9",
    "output": "true"
  },
  {
    "input": "n = 45",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 27",
    "output": "true"
  },
  {
    "input": "n = 0",
    "output": "false"
  },
  {
    "input": "n = 9",
    "output": "true"
  },
  {
    "input": "n = 45",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isPowerOfThree = function(n) {\n};\n",
  "python": "class Solution:\n    def isPowerOfThree(self, n: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isPowerOfThree(int n) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isPowerOfThree(int n) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isPowerOfThree",
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
        27
      ],
      "expected": true
    },
    {
      "args": [
        0
      ],
      "expected": false
    },
    {
      "args": [
        9
      ],
      "expected": true
    },
    {
      "args": [
        45
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
    "expected": true
  },
  {
    "args": [
      3
    ],
    "expected": true
  },
  {
    "args": [
      81
    ],
    "expected": true
  },
  {
    "args": [
      -3
    ],
    "expected": false
  },
  {
    "args": [
      1162261467
    ],
    "expected": true
  },
  {
    "args": [
      2
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1759,
    '解码异或后的数组',
    '有一个长度为 n + 1 的非负整数数组 arr，它经过编码后得到长度为 n 的数组 encoded，
编码规则为 encoded[i] = arr[i] XOR arr[i + 1]，其中 XOR 表示按位异或。
现在给定 encoded 和 arr[0] 的值 first，返回原始数组 arr。',
    'easy',
    1000,
    256,
    ARRAY['位运算', '数组'],
    $json$[
  {
    "input": "encoded = [1, 2, 3], first = 1",
    "output": "[1, 0, 2, 1]"
  },
  {
    "input": "encoded = [6, 2, 7, 3], first = 4",
    "output": "[4, 2, 0, 7, 4]"
  },
  {
    "input": "encoded = [0], first = 0",
    "output": "[0, 0]"
  },
  {
    "input": "encoded = [1], first = 0",
    "output": "[0, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "encoded = [1, 2, 3], first = 1",
    "output": "[1, 0, 2, 1]"
  },
  {
    "input": "encoded = [6, 2, 7, 3], first = 4",
    "output": "[4, 2, 0, 7, 4]"
  },
  {
    "input": "encoded = [0], first = 0",
    "output": "[0, 0]"
  },
  {
    "input": "encoded = [1], first = 0",
    "output": "[0, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var decodeXorArray = function(encoded, first) {\n};\n",
  "python": "class Solution:\n    def decodeXorArray(self, encoded: list[int], first: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> decodeXorArray(std::vector<int>& encoded, int first) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] decodeXorArray(int[] encoded, int first) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "decodeXorArray",
  "params": [
    {
      "name": "encoded",
      "type": "int[]"
    },
    {
      "name": "first",
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
          3
        ],
        1
      ],
      "expected": [
        1,
        0,
        2,
        1
      ]
    },
    {
      "args": [
        [
          6,
          2,
          7,
          3
        ],
        4
      ],
      "expected": [
        4,
        2,
        0,
        7,
        4
      ]
    },
    {
      "args": [
        [
          0
        ],
        0
      ],
      "expected": [
        0,
        0
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
        1,
        2
      ],
      3
    ],
    "expected": [
      3,
      2,
      0
    ]
  },
  {
    "args": [
      [
        0,
        0,
        0
      ],
      5
    ],
    "expected": [
      5,
      5,
      5,
      5
    ]
  },
  {
    "args": [
      [
        5
      ],
      5
    ],
    "expected": [
      5,
      0
    ]
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
    "expected": [
      0,
      1,
      0,
      1,
      0
    ]
  },
  {
    "args": [
      [
        2,
        4,
        6
      ],
      1
    ],
    "expected": [
      1,
      3,
      7,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1760,
    '转换数字的最少位翻转次数',
    '给定两个非负整数 start 和 goal。
每次操作可以翻转 start 的二进制表示中的任意一位（0 变 1，1 变 0）。
返回把 start 变成 goal 所需的最少翻转次数。',
    'easy',
    1000,
    256,
    ARRAY['位运算'],
    $json$[
  {
    "input": "start = 10, goal = 7",
    "output": "3"
  },
  {
    "input": "start = 3, goal = 4",
    "output": "3"
  },
  {
    "input": "start = 0, goal = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "start = 10, goal = 7",
    "output": "3"
  },
  {
    "input": "start = 3, goal = 4",
    "output": "3"
  },
  {
    "input": "start = 0, goal = 0",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minBitFlips = function(start, goal) {\n};\n",
  "python": "class Solution:\n    def minBitFlips(self, start: int, goal: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minBitFlips(int start, int goal) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minBitFlips(int start, int goal) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minBitFlips",
  "params": [
    {
      "name": "start",
      "type": "int"
    },
    {
      "name": "goal",
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
        7
      ],
      "expected": 3
    },
    {
      "args": [
        3,
        4
      ],
      "expected": 3
    },
    {
      "args": [
        0,
        0
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      2
    ],
    "expected": 2
  },
  {
    "args": [
      0,
      1023
    ],
    "expected": 10
  },
  {
    "args": [
      100,
      100
    ],
    "expected": 0
  },
  {
    "args": [
      1024,
      0
    ],
    "expected": 1
  },
  {
    "args": [
      12345,
      67890
    ],
    "expected": 8
  }
]$json$::jsonb,
    'approved'
),
(
    1761,
    '在区间范围内统计奇数数目',
    '给定两个非负整数 low 和 high，且 low <= high。
返回闭区间 [low, high] 中奇数的个数。',
    'easy',
    1000,
    256,
    ARRAY['数学'],
    $json$[
  {
    "input": "low = 3, high = 7",
    "output": "3"
  },
  {
    "input": "low = 8, high = 10",
    "output": "1"
  },
  {
    "input": "low = 0, high = 0",
    "output": "0"
  },
  {
    "input": "low = 1, high = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "low = 3, high = 7",
    "output": "3"
  },
  {
    "input": "low = 8, high = 10",
    "output": "1"
  },
  {
    "input": "low = 0, high = 0",
    "output": "0"
  },
  {
    "input": "low = 1, high = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countOdds = function(low, high) {\n};\n",
  "python": "class Solution:\n    def countOdds(self, low: int, high: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countOdds(int low, int high) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countOdds(int low, int high) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countOdds",
  "params": [
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
        3,
        7
      ],
      "expected": 3
    },
    {
      "args": [
        8,
        10
      ],
      "expected": 1
    },
    {
      "args": [
        0,
        0
      ],
      "expected": 0
    },
    {
      "args": [
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
      0,
      10
    ],
    "expected": 5
  },
  {
    "args": [
      2,
      2
    ],
    "expected": 0
  },
  {
    "args": [
      2,
      3
    ],
    "expected": 1
  },
  {
    "args": [
      10,
      20
    ],
    "expected": 5
  },
  {
    "args": [
      1,
      1000000000
    ],
    "expected": 500000000
  }
]$json$::jsonb,
    'approved'
),
(
    1762,
    '比赛中的配对次数',
    '有 n 支队伍参加比赛，比赛规则如下：
每轮将所有队伍两两配对，每对进行一场比赛，胜者进入下一轮；
如果队伍数为奇数，则有一支队伍轮空直接进入下一轮。
当只剩一支队伍时比赛结束。
返回整个赛程中进行的比赛总场数。',
    'easy',
    1000,
    256,
    ARRAY['数学', '模拟'],
    $json$[
  {
    "input": "n = 7",
    "output": "6"
  },
  {
    "input": "n = 14",
    "output": "13"
  },
  {
    "input": "n = 1",
    "output": "0"
  },
  {
    "input": "n = 3",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 7",
    "output": "6"
  },
  {
    "input": "n = 14",
    "output": "13"
  },
  {
    "input": "n = 1",
    "output": "0"
  },
  {
    "input": "n = 3",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numberOfMatches = function(n) {\n};\n",
  "python": "class Solution:\n    def numberOfMatches(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numberOfMatches(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numberOfMatches(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numberOfMatches",
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
        7
      ],
      "expected": 6
    },
    {
      "args": [
        14
      ],
      "expected": 13
    },
    {
      "args": [
        1
      ],
      "expected": 0
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
      2
    ],
    "expected": 1
  },
  {
    "args": [
      4
    ],
    "expected": 3
  },
  {
    "args": [
      100
    ],
    "expected": 99
  },
  {
    "args": [
      200
    ],
    "expected": 199
  },
  {
    "args": [
      5
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1763,
    '计算力扣银行的钱',
    'Hercy 每天往银行存钱。
第 1 周（第 1 天到第 7 天）每天分别存 1、2、3、4、5、6、7 元；
第 2 周每天分别存 2、3、4、5、6、7、8 元；
依此类推，第 w 周每天分别存 w、w + 1、...、w + 6 元。
给定天数 n，返回第 n 天结束时共存了多少钱。',
    'easy',
    1000,
    256,
    ARRAY['数学', '模拟'],
    $json$[
  {
    "input": "n = 4",
    "output": "10"
  },
  {
    "input": "n = 10",
    "output": "37"
  },
  {
    "input": "n = 20",
    "output": "96"
  },
  {
    "input": "n = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4",
    "output": "10"
  },
  {
    "input": "n = 10",
    "output": "37"
  },
  {
    "input": "n = 20",
    "output": "96"
  },
  {
    "input": "n = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var totalMoney = function(n) {\n};\n",
  "python": "class Solution:\n    def totalMoney(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int totalMoney(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int totalMoney(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "totalMoney",
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
      "expected": 10
    },
    {
      "args": [
        10
      ],
      "expected": 37
    },
    {
      "args": [
        20
      ],
      "expected": 96
    },
    {
      "args": [
        1
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      7
    ],
    "expected": 28
  },
  {
    "args": [
      8
    ],
    "expected": 30
  },
  {
    "args": [
      15
    ],
    "expected": 66
  },
  {
    "args": [
      28
    ],
    "expected": 154
  },
  {
    "args": [
      100
    ],
    "expected": 1060
  }
]$json$::jsonb,
    'approved'
),
(
    1764,
    '三除数',
    '给定一个整数 n。
如果 n 恰好有三个正除数，返回 true，否则返回 false。
正除数指能整除 n 的正整数，包括 1 和 n 本身。',
    'easy',
    1000,
    256,
    ARRAY['数学'],
    $json$[
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
    "input": "n = 9",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
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
    "input": "n = 9",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isThree = function(n) {\n};\n",
  "python": "class Solution:\n    def isThree(self, n: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isThree(int n) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isThree(int n) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isThree",
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
        9
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
    "expected": false
  },
  {
    "args": [
      8
    ],
    "expected": false
  },
  {
    "args": [
      25
    ],
    "expected": true
  },
  {
    "args": [
      49
    ],
    "expected": true
  },
  {
    "args": [
      100
    ],
    "expected": false
  },
  {
    "args": [
      9409
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1765,
    '反转两次的数字',
    '给定一个非负整数 num。
第一次反转：把 num 的十进制数字顺序颠倒，并去掉反转后可能产生的前导零，得到 reversed1。
第二次反转：把 reversed1 的十进制数字顺序颠倒，并去掉前导零，得到 reversed2。
如果 reversed2 等于 num，返回 true，否则返回 false。
注意：末尾带 0 的正整数在第一次反转后会丢失这些 0，因此无法还原。',
    'easy',
    1000,
    256,
    ARRAY['数学', '模拟'],
    $json$[
  {
    "input": "num = 526",
    "output": "true"
  },
  {
    "input": "num = 0",
    "output": "true"
  },
  {
    "input": "num = 1800",
    "output": "false"
  },
  {
    "input": "num = 5",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 526",
    "output": "true"
  },
  {
    "input": "num = 0",
    "output": "true"
  },
  {
    "input": "num = 1800",
    "output": "false"
  },
  {
    "input": "num = 5",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isSameAfterReversals = function(num) {\n};\n",
  "python": "class Solution:\n    def isSameAfterReversals(self, num: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isSameAfterReversals(int num) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isSameAfterReversals(int num) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isSameAfterReversals",
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
        526
      ],
      "expected": true
    },
    {
      "args": [
        0
      ],
      "expected": true
    },
    {
      "args": [
        1800
      ],
      "expected": false
    },
    {
      "args": [
        5
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      10
    ],
    "expected": false
  },
  {
    "args": [
      100
    ],
    "expected": false
  },
  {
    "args": [
      123
    ],
    "expected": true
  },
  {
    "args": [
      120
    ],
    "expected": false
  },
  {
    "args": [
      1000000
    ],
    "expected": false
  },
  {
    "args": [
      7
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1766,
    '统计平方和三元组的数目',
    '给定一个正整数 n。
统计满足 a^2 + b^2 = c^2 且 1 <= a, b, c <= n 的三元组 (a, b, c) 的数量。
三元组是有序的：交换 a 和 b 得到的三元组视为不同的三元组。',
    'easy',
    1000,
    256,
    ARRAY['数学', '枚举'],
    $json$[
  {
    "input": "n = 5",
    "output": "2"
  },
  {
    "input": "n = 10",
    "output": "4"
  },
  {
    "input": "n = 1",
    "output": "0"
  },
  {
    "input": "n = 3",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5",
    "output": "2"
  },
  {
    "input": "n = 10",
    "output": "4"
  },
  {
    "input": "n = 1",
    "output": "0"
  },
  {
    "input": "n = 3",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countTriples = function(n) {\n};\n",
  "python": "class Solution:\n    def countTriples(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countTriples(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countTriples(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countTriples",
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
        3
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      4
    ],
    "expected": 0
  },
  {
    "args": [
      13
    ],
    "expected": 6
  },
  {
    "args": [
      2
    ],
    "expected": 0
  },
  {
    "args": [
      15
    ],
    "expected": 8
  },
  {
    "args": [
      250
    ],
    "expected": 330
  }
]$json$::jsonb,
    'approved'
),
(
    1767,
    '判断国际象棋棋盘中一个格子的颜色',
    '国际象棋棋盘有 8 行 8 列，列用字母 a 到 h 表示，行用数字 1 到 8 表示。
左上角 a1 是深色格子，棋盘相邻格子颜色交替。
给定一个表示格子的字符串 coordinate（如 "a1"），
如果该格子是白色返回 true，是深色返回 false。',
    'easy',
    1000,
    256,
    ARRAY['数学', '字符串'],
    $json$[
  {
    "input": "coordinate = \"a1\"",
    "output": "false"
  },
  {
    "input": "coordinate = \"h3\"",
    "output": "true"
  },
  {
    "input": "coordinate = \"c7\"",
    "output": "false"
  },
  {
    "input": "coordinate = \"d4\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "coordinate = \"a1\"",
    "output": "false"
  },
  {
    "input": "coordinate = \"h3\"",
    "output": "true"
  },
  {
    "input": "coordinate = \"c7\"",
    "output": "false"
  },
  {
    "input": "coordinate = \"d4\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var squareIsWhite = function(coordinate) {\n};\n",
  "python": "class Solution:\n    def squareIsWhite(self, coordinate: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool squareIsWhite(std::string coordinate) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean squareIsWhite(String coordinate) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "squareIsWhite",
  "params": [
    {
      "name": "coordinate",
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
        "a1"
      ],
      "expected": false
    },
    {
      "args": [
        "h3"
      ],
      "expected": true
    },
    {
      "args": [
        "c7"
      ],
      "expected": false
    },
    {
      "args": [
        "d4"
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a2"
    ],
    "expected": true
  },
  {
    "args": [
      "b1"
    ],
    "expected": true
  },
  {
    "args": [
      "h8"
    ],
    "expected": false
  },
  {
    "args": [
      "e5"
    ],
    "expected": false
  },
  {
    "args": [
      "g6"
    ],
    "expected": true
  },
  {
    "args": [
      "h1"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1768,
    '买卖股票的最佳时机 II',
    '给定一个整数数组 prices，其中 prices[i] 表示某支股票第 i 天的价格。
每天你可以决定买入或卖出至多一股股票，也可以什么都不做。
同一天可以先卖出再买入，但任何时刻最多持有 1 股。
初始时没有股票，要求最后也没有股票。
返回能获得的最大利润。',
    'easy',
    1000,
    256,
    ARRAY['贪心', '数组', '动态规划'],
    $json$[
  {
    "input": "prices = [7, 1, 5, 3, 6, 4]",
    "output": "7"
  },
  {
    "input": "prices = [1, 2, 3, 4, 5]",
    "output": "4"
  },
  {
    "input": "prices = [7, 6, 4, 3, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "prices = [7, 1, 5, 3, 6, 4]",
    "output": "7"
  },
  {
    "input": "prices = [1, 2, 3, 4, 5]",
    "output": "4"
  },
  {
    "input": "prices = [7, 6, 4, 3, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxProfitII = function(prices) {\n};\n",
  "python": "class Solution:\n    def maxProfitII(self, prices: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxProfitII(std::vector<int>& prices) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxProfitII(int[] prices) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxProfitII",
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
        1,
        2,
        1,
        2
      ]
    ],
    "expected": 2
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
        1,
        5,
        1,
        5
      ]
    ],
    "expected": 8
  },
  {
    "args": [
      [
        2,
        4,
        1,
        7
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
    "expected": 7
  }
]$json$::jsonb,
    'approved'
),
(
    1769,
    '最长连续递增序列',
    '给定一个整数数组 nums。
返回其中最长的连续递增子数组的长度。
连续递增子数组指下标连续且每个元素都严格大于前一个元素的一段子数组。
子数组长度至少为 1。',
    'easy',
    1000,
    256,
    ARRAY['数组', '贪心'],
    $json$[
  {
    "input": "nums = [1, 3, 5, 4, 7]",
    "output": "3"
  },
  {
    "input": "nums = [2, 2, 2, 2, 2]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5]",
    "output": "5"
  },
  {
    "input": "nums = [5, 4, 3, 2, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3, 5, 4, 7]",
    "output": "3"
  },
  {
    "input": "nums = [2, 2, 2, 2, 2]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5]",
    "output": "5"
  },
  {
    "input": "nums = [5, 4, 3, 2, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findLengthOfLCIS = function(nums) {\n};\n",
  "python": "class Solution:\n    def findLengthOfLCIS(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findLengthOfLCIS(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findLengthOfLCIS(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findLengthOfLCIS",
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
      "expected": 3
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
        3,
        5,
        4,
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
        1,
        2,
        3,
        2,
        4,
        5,
        6,
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
    "expected": 4
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
        1,
        2
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1770,
    '装满杯子需要的最短总时长',
    '有一个水龙头，每秒钟可以选择：
给一个杯子装满水；或同时给两个不同类型（冷、温、热）的杯子各装一部分水。
给定数组 amount，依次表示冷、温、热水杯的数量。
返回装满所有杯子所需的最短秒数。',
    'easy',
    1000,
    256,
    ARRAY['贪心', '数学'],
    $json$[
  {
    "input": "amount = [1, 4, 2]",
    "output": "4"
  },
  {
    "input": "amount = [5, 4, 4]",
    "output": "7"
  },
  {
    "input": "amount = [5, 0, 0]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "amount = [1, 4, 2]",
    "output": "4"
  },
  {
    "input": "amount = [5, 4, 4]",
    "output": "7"
  },
  {
    "input": "amount = [5, 0, 0]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var fillCups = function(amount) {\n};\n",
  "python": "class Solution:\n    def fillCups(self, amount: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int fillCups(std::vector<int>& amount) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int fillCups(int[] amount) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "fillCups",
  "params": [
    {
      "name": "amount",
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
          2
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          5,
          4,
          4
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        [
          5,
          0,
          0
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
    "expected": 3
  },
  {
    "args": [
      [
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
        10,
        0,
        0
      ]
    ],
    "expected": 10
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
  }
]$json$::jsonb,
    'approved'
),
(
    1771,
    '使数组中所有元素都等于零',
    '给定一个非负整数数组 nums。
每次操作选择一个正整数 x，然后把数组中所有等于 x 的元素都减去 x（这些元素变为 0），
其他元素保持不变。
返回使数组中所有元素都等于 0 所需的最少操作次数。',
    'easy',
    1000,
    256,
    ARRAY['贪心', '数组', '哈希表'],
    $json$[
  {
    "input": "nums = [1, 5, 0, 3, 5]",
    "output": "3"
  },
  {
    "input": "nums = [0]",
    "output": "0"
  },
  {
    "input": "nums = [2, 2, 2]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 5, 0, 3, 5]",
    "output": "3"
  },
  {
    "input": "nums = [0]",
    "output": "0"
  },
  {
    "input": "nums = [2, 2, 2]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumOperationsZeroArray = function(nums) {\n};\n",
  "python": "class Solution:\n    def minimumOperationsZeroArray(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumOperationsZeroArray(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumOperationsZeroArray(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumOperationsZeroArray",
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
          5,
          0,
          3,
          5
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
          2,
          3
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
        5,
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
        10,
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        3,
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
        1
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1772,
    '打折购买糖果的最小开销',
    '给定一个正整数数组 cost，表示每种糖果的价格。
商店促销规则：每买两颗糖果，就可以免费拿走一颗价格不超过这两颗中较便宜者的糖果。
免费糖果必须从尚未购买的糖果中选择，且每颗糖果只能购买或免费获得一次。
返回买走所有糖果所需的最小总开销。',
    'easy',
    1000,
    256,
    ARRAY['贪心', '数组', '排序'],
    $json$[
  {
    "input": "cost = [1, 2, 3]",
    "output": "5"
  },
  {
    "input": "cost = [6, 5, 5, 5, 5, 5, 5]",
    "output": "26"
  },
  {
    "input": "cost = [5]",
    "output": "5"
  },
  {
    "input": "cost = [5, 5, 5, 5]",
    "output": "15"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "cost = [1, 2, 3]",
    "output": "5"
  },
  {
    "input": "cost = [6, 5, 5, 5, 5, 5, 5]",
    "output": "26"
  },
  {
    "input": "cost = [5]",
    "output": "5"
  },
  {
    "input": "cost = [5, 5, 5, 5]",
    "output": "15"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumCostCandies = function(cost) {\n};\n",
  "python": "class Solution:\n    def minimumCostCandies(self, cost: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumCostCandies(std::vector<int>& cost) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumCostCandies(int[] cost) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumCostCandies",
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
          1,
          2,
          3
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        [
          6,
          5,
          5,
          5,
          5,
          5,
          5
        ]
      ],
      "expected": 26
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
          5,
          5,
          5,
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
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        10,
        5,
        3
      ]
    ],
    "expected": 15
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
    "expected": 8
  },
  {
    "args": [
      [
        9,
        8,
        7,
        6,
        5,
        4
      ]
    ],
    "expected": 28
  }
]$json$::jsonb,
    'approved'
),
(
    1773,
    '使每位学生都有座位的最少移动次数',
    '给定两个长度相同的整数数组 seats 和 students。
seats[i] 表示第 i 个座位的坐标，students[i] 表示第 i 名学生当前的坐标。
把每名学生安排到一个座位，每个座位恰好安排一名学生。
一名学生移动到座位的代价是两者坐标之差的绝对值。
返回安排所有学生所需的最小总移动次数。',
    'easy',
    1000,
    256,
    ARRAY['贪心', '数组', '排序'],
    $json$[
  {
    "input": "seats = [3, 1, 5], students = [2, 7, 4]",
    "output": "4"
  },
  {
    "input": "seats = [4, 1, 5, 9], students = [1, 3, 2, 6]",
    "output": "7"
  },
  {
    "input": "seats = [2, 2, 6, 6], students = [1, 3, 2, 6]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "seats = [3, 1, 5], students = [2, 7, 4]",
    "output": "4"
  },
  {
    "input": "seats = [4, 1, 5, 9], students = [1, 3, 2, 6]",
    "output": "7"
  },
  {
    "input": "seats = [2, 2, 6, 6], students = [1, 3, 2, 6]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minMovesToSeat = function(seats, students) {\n};\n",
  "python": "class Solution:\n    def minMovesToSeat(self, seats: list[int], students: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minMovesToSeat(std::vector<int>& seats, std::vector<int>& students) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minMovesToSeat(int[] seats, int[] students) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minMovesToSeat",
  "params": [
    {
      "name": "seats",
      "type": "int[]"
    },
    {
      "name": "students",
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
          5
        ],
        [
          2,
          7,
          4
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          4,
          1,
          5,
          9
        ],
        [
          1,
          3,
          2,
          6
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        [
          2,
          2,
          6,
          6
        ],
        [
          1,
          3,
          2,
          6
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
        3
      ],
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
        10,
        20,
        30
      ],
      [
        1,
        2,
        3
      ]
    ],
    "expected": 54
  },
  {
    "args": [
      [
        5,
        5,
        5
      ],
      [
        1,
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
        2,
        2
      ],
      [
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
    1774,
    '移除指定数字得到的最大结果',
    '给定一个表示正整数的字符串 number（不含前导零），以及一个数字字符 digit。
number 中至少出现一次 digit。
必须从中恰好移除一个等于 digit 的字符，得到一个新的整数值。
返回所有可能结果中数值最大的那个，以普通十进制字符串表示，
不保留前导零；如果结果为 0 则输出 "0"。',
    'easy',
    1000,
    256,
    ARRAY['贪心', '字符串', '枚举'],
    $json$[
  {
    "input": "number = \"123\", digit = \"3\"",
    "output": "\"12\""
  },
  {
    "input": "number = \"1231\", digit = \"1\"",
    "output": "\"231\""
  },
  {
    "input": "number = \"551\", digit = \"5\"",
    "output": "\"51\""
  },
  {
    "input": "number = \"102\", digit = \"1\"",
    "output": "\"2\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "number = \"123\", digit = \"3\"",
    "output": "\"12\""
  },
  {
    "input": "number = \"1231\", digit = \"1\"",
    "output": "\"231\""
  },
  {
    "input": "number = \"551\", digit = \"5\"",
    "output": "\"51\""
  },
  {
    "input": "number = \"102\", digit = \"1\"",
    "output": "\"2\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeDigitMax = function(number, digit) {\n};\n",
  "python": "class Solution:\n    def removeDigitMax(self, number: str, digit: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string removeDigitMax(std::string number, std::string digit) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String removeDigitMax(String number, String digit) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeDigitMax",
  "params": [
    {
      "name": "number",
      "type": "string"
    },
    {
      "name": "digit",
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
        "123",
        "3"
      ],
      "expected": "12"
    },
    {
      "args": [
        "1231",
        "1"
      ],
      "expected": "231"
    },
    {
      "args": [
        "551",
        "5"
      ],
      "expected": "51"
    },
    {
      "args": [
        "102",
        "1"
      ],
      "expected": "2"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "10",
      "1"
    ],
    "expected": "0"
  },
  {
    "args": [
      "1001",
      "1"
    ],
    "expected": "100"
  },
  {
    "args": [
      "123",
      "1"
    ],
    "expected": "23"
  },
  {
    "args": [
      "9876",
      "9"
    ],
    "expected": "876"
  },
  {
    "args": [
      "111",
      "1"
    ],
    "expected": "11"
  },
  {
    "args": [
      "4321",
      "4"
    ],
    "expected": "321"
  },
  {
    "args": [
      "555",
      "5"
    ],
    "expected": "55"
  }
]$json$::jsonb,
    'approved'
),
(
    1775,
    '子数组的最小值之和',
    '给定整数数组 arr
返回 arr 的所有非空连续子数组的最小值之和
结果对 10^9 + 7 取模',
    'medium',
    1000,
    256,
    ARRAY['数组', '单调栈'],
    $json$[
  {
    "input": "arr = [3, 1, 2, 4]",
    "output": "17"
  },
  {
    "input": "arr = [11, 81, 94, 43, 3]",
    "output": "444"
  },
  {
    "input": "arr = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [3, 1, 2, 4]",
    "output": "17"
  },
  {
    "input": "arr = [11, 81, 94, 43, 3]",
    "output": "444"
  },
  {
    "input": "arr = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumSubarrayMins = function(arr) {\n};\n",
  "python": "class Solution:\n    def sumSubarrayMins(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int sumSubarrayMins(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int sumSubarrayMins(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumSubarrayMins",
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
          1,
          2,
          4
        ]
      ],
      "expected": 17
    },
    {
      "args": [
        [
          11,
          81,
          94,
          43,
          3
        ]
      ],
      "expected": 444
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
        2,
        3,
        4
      ]
    ],
    "expected": 20
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
    "expected": 35
  },
  {
    "args": [
      [
        2,
        2,
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
        3
      ]
    ],
    "expected": 10
  },
  {
    "args": [
      [
        3,
        3,
        3,
        1,
        2,
        4
      ]
    ],
    "expected": 38
  }
]$json$::jsonb,
    'approved'
),
(
    1776,
    '最小差值 II',
    '给定整数数组 nums 和整数 k
对每个元素必须执行一次操作：加上 k 或者减去 k
返回操作后数组最大值与最小值之差的最小可能值',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序'],
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
    "output": "3"
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
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestRangeII = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def smallestRangeII(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int smallestRangeII(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int smallestRangeII(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestRangeII",
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
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
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
        1,
        1,
        1
      ],
      5
    ],
    "expected": 0
  },
  {
    "args": [
      [
        7,
        8,
        8,
        5
      ],
      4
    ],
    "expected": 3
  },
  {
    "args": [
      [
        0,
        0,
        0
      ],
      10
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        5,
        9,
        13
      ],
      3
    ],
    "expected": 6
  }
]$json$::jsonb,
    'approved'
),
(
    1777,
    '分割数组',
    '给定整数数组 nums
把它分成左右两个非空连续部分
要求左部分的每个元素都不大于右部分的每个元素
返回满足条件时左部分的最小长度
题目保证至少存在一种分割方案',
    'medium',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "nums = [5, 0, 3, 8, 6]",
    "output": "3"
  },
  {
    "input": "nums = [1, 1, 1, 0, 6, 12]",
    "output": "4"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [5, 0, 3, 8, 6]",
    "output": "3"
  },
  {
    "input": "nums = [1, 1, 1, 0, 6, 12]",
    "output": "4"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var partitionDisjoint = function(nums) {\n};\n",
  "python": "class Solution:\n    def partitionDisjoint(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int partitionDisjoint(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int partitionDisjoint(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "partitionDisjoint",
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
          0,
          3,
          8,
          6
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
          0,
          6,
          12
        ]
      ],
      "expected": 4
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
        2,
        3,
        4,
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
        2,
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
        3,
        2,
        4
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1778,
    '三数之和的多种可能',
    '给定整数数组 nums 和目标值 target
统计满足 i < j < k 且 nums[i] + nums[j] + nums[k] == target 的三元组数量
下标三元组按位置区分，数值相同的不同位置算作不同三元组
结果对 10^9 + 7 取模',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '双指针'],
    $json$[
  {
    "input": "nums = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5], target = 8",
    "output": "20"
  },
  {
    "input": "nums = [1, 1, 2, 2, 2, 2], target = 5",
    "output": "12"
  },
  {
    "input": "nums = [2, 1, 3], target = 6",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5], target = 8",
    "output": "20"
  },
  {
    "input": "nums = [1, 1, 2, 2, 2, 2], target = 5",
    "output": "12"
  },
  {
    "input": "nums = [2, 1, 3], target = 6",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var threeSumMulti = function(nums, target) {\n};\n",
  "python": "class Solution:\n    def threeSumMulti(self, nums: list[int], target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int threeSumMulti(std::vector<int>& nums, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int threeSumMulti(int[] nums, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "threeSumMulti",
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
          2,
          2,
          3,
          3,
          4,
          4,
          5,
          5
        ],
        8
      ],
      "expected": 20
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
        ],
        5
      ],
      "expected": 12
    },
    {
      "args": [
        [
          2,
          1,
          3
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
        2,
        2,
        2
      ],
      6
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
      0
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
      ],
      9
    ],
    "expected": 2
  },
  {
    "args": [
      [
        0,
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
        1,
        1,
        1,
        2,
        2
      ],
      5
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1779,
    '和相同的二元子数组',
    '给定只包含 0 和 1 的整数数组 nums 与整数 goal
返回元素和恰好等于 goal 的非空连续子数组数量',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '哈希表'],
    $json$[
  {
    "input": "nums = [1, 0, 1, 0, 1], goal = 2",
    "output": "4"
  },
  {
    "input": "nums = [0, 0, 0, 0, 0], goal = 0",
    "output": "15"
  },
  {
    "input": "nums = [1], goal = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 0, 1, 0, 1], goal = 2",
    "output": "4"
  },
  {
    "input": "nums = [0, 0, 0, 0, 0], goal = 0",
    "output": "15"
  },
  {
    "input": "nums = [1], goal = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numSubarraysWithSum = function(nums, goal) {\n};\n",
  "python": "class Solution:\n    def numSubarraysWithSum(self, nums: list[int], goal: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numSubarraysWithSum(std::vector<int>& nums, int goal) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numSubarraysWithSum(int[] nums, int goal) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numSubarraysWithSum",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "goal",
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
          0,
          1,
          0,
          1
        ],
        2
      ],
      "expected": 4
    },
    {
      "args": [
        [
          0,
          0,
          0,
          0,
          0
        ],
        0
      ],
      "expected": 15
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
        0,
        1
      ],
      1
    ],
    "expected": 4
  },
  {
    "args": [
      [
        0
      ],
      0
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
      2
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
      0
    ],
    "expected": 6
  },
  {
    "args": [
      [
        1,
        0,
        0,
        1
      ],
      2
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1780,
    '最小面积矩形',
    '给定二维整数数组 points，points[i] = [xi, yi] 表示平面上的一个点
所有点互不相同
找出由这些点构成、边与坐标轴平行的矩形的最小面积
矩形的四个顶点都必须是给定点
若不存在这样的矩形则返回 0',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表', '几何'],
    $json$[
  {
    "input": "points = [[1, 1], [1, 3], [3, 1], [3, 3], [2, 2]]",
    "output": "4"
  },
  {
    "input": "points = [[1, 1], [1, 3], [3, 1], [3, 3], [4, 1], [4, 3]]",
    "output": "2"
  },
  {
    "input": "points = [[1, 1], [1, 3], [3, 1], [3, 3]]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "points = [[1, 1], [1, 3], [3, 1], [3, 3], [2, 2]]",
    "output": "4"
  },
  {
    "input": "points = [[1, 1], [1, 3], [3, 1], [3, 3], [4, 1], [4, 3]]",
    "output": "2"
  },
  {
    "input": "points = [[1, 1], [1, 3], [3, 1], [3, 3]]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minAreaRect = function(points) {\n};\n",
  "python": "class Solution:\n    def minAreaRect(self, points: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minAreaRect(std::vector<std::vector<int>>& points) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minAreaRect(int[][] points) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minAreaRect",
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
            1,
            3
          ],
          [
            3,
            1
          ],
          [
            3,
            3
          ],
          [
            2,
            2
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
            3
          ],
          [
            3,
            1
          ],
          [
            3,
            3
          ],
          [
            4,
            1
          ],
          [
            4,
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
            1
          ],
          [
            1,
            3
          ],
          [
            3,
            1
          ],
          [
            3,
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
          2
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
          1,
          1
        ],
        [
          0,
          1
        ],
        [
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
          1
        ],
        [
          1,
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
          2,
          3
        ],
        [
          3,
          1
        ],
        [
          1,
          3
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
    1781,
    '使数组唯一的最小增量',
    '给定整数数组 nums
每次操作可以选择一个元素并将其加 1
返回使数组中所有元素互不相同所需的最少操作次数',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '贪心'],
    $json$[
  {
    "input": "nums = [1, 2, 2]",
    "output": "1"
  },
  {
    "input": "nums = [3, 2, 1, 2, 1, 7]",
    "output": "6"
  },
  {
    "input": "nums = [0, 2, 2]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 2]",
    "output": "1"
  },
  {
    "input": "nums = [3, 2, 1, 2, 1, 7]",
    "output": "6"
  },
  {
    "input": "nums = [0, 2, 2]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minIncrementForUnique = function(nums) {\n};\n",
  "python": "class Solution:\n    def minIncrementForUnique(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minIncrementForUnique(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minIncrementForUnique(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minIncrementForUnique",
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
          1,
          2,
          1,
          7
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          0,
          2,
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
        0
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
        7,
        7,
        7,
        7
      ]
    ],
    "expected": 6
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
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1782,
    '二倍数对数组',
    '给定整数数组 arr
判断能否重新排列 arr，使得对于每个偶数下标 i，都有 arr[i + 1] == 2 * arr[i]
可以按任意顺序配对，返回是否可行',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表', '排序'],
    $json$[
  {
    "input": "arr = [3, 1, 3, 6]",
    "output": "false"
  },
  {
    "input": "arr = [2, 1, 2, 6]",
    "output": "false"
  },
  {
    "input": "arr = [4, -2, 2, -4]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [3, 1, 3, 6]",
    "output": "false"
  },
  {
    "input": "arr = [2, 1, 2, 6]",
    "output": "false"
  },
  {
    "input": "arr = [4, -2, 2, -4]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canReorderDoubled = function(arr) {\n};\n",
  "python": "class Solution:\n    def canReorderDoubled(self, arr: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canReorderDoubled(std::vector<int>& arr) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canReorderDoubled(int[] arr) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canReorderDoubled",
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
          3,
          1,
          3,
          6
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          2,
          1,
          2,
          6
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          4,
          -2,
          2,
          -4
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
        4,
        8
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
        4
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        -1,
        -2,
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
        3,
        4
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1783,
    '最大宽度坡',
    '给定整数数组 nums
坡是一对下标 (i, j)，满足 i < j 且 nums[i] <= nums[j]
坡的宽度为 j - i
返回所有坡中的最大宽度，若不存在坡则返回 0',
    'medium',
    1000,
    256,
    ARRAY['数组', '单调栈'],
    $json$[
  {
    "input": "nums = [6, 0, 8, 2, 1, 5]",
    "output": "4"
  },
  {
    "input": "nums = [9, 8, 1, 0, 1, 9, 4, 0, 4, 1]",
    "output": "7"
  },
  {
    "input": "nums = [1, 0]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [6, 0, 8, 2, 1, 5]",
    "output": "4"
  },
  {
    "input": "nums = [9, 8, 1, 0, 1, 9, 4, 0, 4, 1]",
    "output": "7"
  },
  {
    "input": "nums = [1, 0]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxWidthRamp = function(nums) {\n};\n",
  "python": "class Solution:\n    def maxWidthRamp(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxWidthRamp(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxWidthRamp(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxWidthRamp",
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
          6,
          0,
          8,
          2,
          1,
          5
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          9,
          8,
          1,
          0,
          1,
          9,
          4,
          0,
          4,
          1
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        [
          1,
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
        4
      ]
    ],
    "expected": 3
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
    "expected": 0
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
        2,
        2
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
  }
]$json$::jsonb,
    'approved'
),
(
    1784,
    '交换一次的先前排列',
    '给定整数数组 arr
最多选择一对下标 i < j 并交换 arr[i] 与 arr[j]
返回能得到的、字典序严格小于 arr 的字典序最大的数组
若无法得到更小的排列，则返回原数组',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心'],
    $json$[
  {
    "input": "arr = [3, 2, 1]",
    "output": "[3, 1, 2]"
  },
  {
    "input": "arr = [1, 1, 1]",
    "output": "[1, 1, 1]"
  },
  {
    "input": "arr = [1, 9, 4, 6, 7]",
    "output": "[1, 7, 4, 6, 9]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [3, 2, 1]",
    "output": "[3, 1, 2]"
  },
  {
    "input": "arr = [1, 1, 1]",
    "output": "[1, 1, 1]"
  },
  {
    "input": "arr = [1, 9, 4, 6, 7]",
    "output": "[1, 7, 4, 6, 9]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var prevPermOpt1 = function(arr) {\n};\n",
  "python": "class Solution:\n    def prevPermOpt1(self, arr: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> prevPermOpt1(std::vector<int>& arr) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] prevPermOpt1(int[] arr) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "prevPermOpt1",
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
          3,
          2,
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
          1,
          1,
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
          1,
          9,
          4,
          6,
          7
        ]
      ],
      "expected": [
        1,
        7,
        4,
        6,
        9
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
        1,
        3
      ]
    ],
    "expected": [
      1,
      3,
      1,
      3
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
        5,
        4,
        3,
        2,
        1
      ]
    ],
    "expected": [
      5,
      4,
      3,
      1,
      2
    ]
  },
  {
    "args": [
      [
        2,
        2,
        1
      ]
    ],
    "expected": [
      2,
      1,
      2
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
  }
]$json$::jsonb,
    'approved'
),
(
    1785,
    '最接近原点的 K 个点',
    '给定二维整数数组 points 和整数 k，points[i] = [xi, yi]
返回距离原点最近的 k 个点
距离按欧几里得距离的平方比较
结果按距离升序返回，距离相同时按横坐标升序，再按纵坐标升序',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '堆'],
    $json$[
  {
    "input": "points = [[1, 3], [-2, 2]], k = 1",
    "output": "[[-2, 2]]"
  },
  {
    "input": "points = [[3, 3], [5, -1], [-2, 4]], k = 2",
    "output": "[[3, 3], [-2, 4]]"
  },
  {
    "input": "points = [[0, 0], [1, 1], [2, 2]], k = 3",
    "output": "[[0, 0], [1, 1], [2, 2]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "points = [[1, 3], [-2, 2]], k = 1",
    "output": "[[-2, 2]]"
  },
  {
    "input": "points = [[3, 3], [5, -1], [-2, 4]], k = 2",
    "output": "[[3, 3], [-2, 4]]"
  },
  {
    "input": "points = [[0, 0], [1, 1], [2, 2]], k = 3",
    "output": "[[0, 0], [1, 1], [2, 2]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var kClosestPoints = function(points, k) {\n};\n",
  "python": "class Solution:\n    def kClosestPoints(self, points: list[list[int]], k: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> kClosestPoints(std::vector<std::vector<int>>& points, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] kClosestPoints(int[][] points, int k) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kClosestPoints",
  "params": [
    {
      "name": "points",
      "type": "int[][]"
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
          [
            1,
            3
          ],
          [
            -2,
            2
          ]
        ],
        1
      ],
      "expected": [
        [
          -2,
          2
        ]
      ]
    },
    {
      "args": [
        [
          [
            3,
            3
          ],
          [
            5,
            -1
          ],
          [
            -2,
            4
          ]
        ],
        2
      ],
      "expected": [
        [
          3,
          3
        ],
        [
          -2,
          4
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
            1,
            1
          ],
          [
            2,
            2
          ]
        ],
        3
      ],
      "expected": [
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
          -1,
          0
        ]
      ],
      1
    ],
    "expected": [
      [
        -1,
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
        ],
        [
          1,
          0
        ]
      ],
      2
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
        [
          10,
          10
        ]
      ],
      1
    ],
    "expected": [
      [
        10,
        10
      ]
    ]
  },
  {
    "args": [
      [
        [
          2,
          2
        ],
        [
          -2,
          -2
        ],
        [
          2,
          -2
        ],
        [
          -2,
          2
        ]
      ],
      2
    ],
    "expected": [
      [
        -2,
        -2
      ],
      [
        -2,
        2
      ]
    ]
  },
  {
    "args": [
      [
        [
          -1,
          -1
        ],
        [
          1,
          1
        ],
        [
          0,
          0
        ]
      ],
      2
    ],
    "expected": [
      [
        0,
        0
      ],
      [
        -1,
        -1
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1786,
    '和可被 K 整除的子数组',
    '给定整数数组 nums 和正整数 k
返回元素和能被 k 整除的非空连续子数组数量',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '哈希表'],
    $json$[
  {
    "input": "nums = [4, 5, 0, -2, -3, 1], k = 5",
    "output": "7"
  },
  {
    "input": "nums = [5], k = 9",
    "output": "0"
  },
  {
    "input": "nums = [0, 0], k = 1",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [4, 5, 0, -2, -3, 1], k = 5",
    "output": "7"
  },
  {
    "input": "nums = [5], k = 9",
    "output": "0"
  },
  {
    "input": "nums = [0, 0], k = 1",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var subarraysDivByK = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def subarraysDivByK(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int subarraysDivByK(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int subarraysDivByK(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "subarraysDivByK",
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
          4,
          5,
          0,
          -2,
          -3,
          1
        ],
        5
      ],
      "expected": 7
    },
    {
      "args": [
        [
          5
        ],
        9
      ],
      "expected": 0
    },
    {
      "args": [
        [
          0,
          0
        ],
        1
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        -1,
        2,
        9
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
      2
    ],
    "expected": 2
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
    "expected": 6
  },
  {
    "args": [
      [
        -5,
        3,
        2
      ],
      5
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        -1,
        0
      ],
      3
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1787,
    '坏了的计算器',
    '给定两个整数 startValue 和 target
从 startValue 出发，每次可以执行以下两种操作之一：
1 将当前值减 1
2 将当前值乘以 2
返回把 startValue 变成 target 的最少操作次数',
    'medium',
    1000,
    256,
    ARRAY['数学', '贪心'],
    $json$[
  {
    "input": "startValue = 2, target = 3",
    "output": "2"
  },
  {
    "input": "startValue = 5, target = 8",
    "output": "2"
  },
  {
    "input": "startValue = 3, target = 10",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "startValue = 2, target = 3",
    "output": "2"
  },
  {
    "input": "startValue = 5, target = 8",
    "output": "2"
  },
  {
    "input": "startValue = 3, target = 10",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var brokenCalc = function(startValue, target) {\n};\n",
  "python": "class Solution:\n    def brokenCalc(self, startValue: int, target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int brokenCalc(int startValue, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int brokenCalc(int startValue, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "brokenCalc",
  "params": [
    {
      "name": "startValue",
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
        2,
        3
      ],
      "expected": 2
    },
    {
      "args": [
        5,
        8
      ],
      "expected": 2
    },
    {
      "args": [
        3,
        10
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      1
    ],
    "expected": 0
  },
  {
    "args": [
      10,
      3
    ],
    "expected": 7
  },
  {
    "args": [
      1,
      1000000000
    ],
    "expected": 39
  },
  {
    "args": [
      5,
      2
    ],
    "expected": 3
  },
  {
    "args": [
      4,
      12
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1788,
    'K 连续位的最小翻转次数',
    '给定只包含 0 和 1 的整数数组 nums 与整数 k
每次可以翻转长度为 k 的连续子数组，0 变 1、1 变 0
返回使整个数组都变成 1 的最少翻转次数
若无法做到则返回 -1',
    'medium',
    1000,
    256,
    ARRAY['数组', '滑动窗口', '位运算'],
    $json$[
  {
    "input": "nums = [0, 1, 0], k = 1",
    "output": "2"
  },
  {
    "input": "nums = [1, 1, 0], k = 2",
    "output": "-1"
  },
  {
    "input": "nums = [0, 0, 0, 1, 0, 1, 1, 0], k = 3",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [0, 1, 0], k = 1",
    "output": "2"
  },
  {
    "input": "nums = [1, 1, 0], k = 2",
    "output": "-1"
  },
  {
    "input": "nums = [0, 0, 0, 1, 0, 1, 1, 0], k = 3",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minKBitFlips = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def minKBitFlips(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minKBitFlips(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minKBitFlips(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minKBitFlips",
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
          0,
          1,
          0
        ],
        1
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1,
          1,
          0
        ],
        2
      ],
      "expected": -1
    },
    {
      "args": [
        [
          0,
          0,
          0,
          1,
          0,
          1,
          1,
          0
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
        0,
        0,
        0
      ],
      3
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
      1
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        0,
        1
      ],
      2
    ],
    "expected": -1
  },
  {
    "args": [
      [
        0,
        1,
        0,
        1
      ],
      2
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
      ],
      2
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1789,
    '在 D 天内送达包裹的能力',
    '给定整数数组 weights 表示包裹重量，以及整数 days
包裹必须按给定顺序用船运送，每天可以装载若干包裹
每天装载的包裹总重量不能超过船的载重能力
返回在 days 天内运完所有包裹所需的最小载重能力',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "weights = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], days = 5",
    "output": "15"
  },
  {
    "input": "weights = [3, 2, 2, 4, 1, 4], days = 3",
    "output": "6"
  },
  {
    "input": "weights = [1, 2, 3, 1, 1], days = 4",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "weights = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], days = 5",
    "output": "15"
  },
  {
    "input": "weights = [3, 2, 2, 4, 1, 4], days = 3",
    "output": "6"
  },
  {
    "input": "weights = [1, 2, 3, 1, 1], days = 4",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var shipWithinDays = function(weights, days) {\n};\n",
  "python": "class Solution:\n    def shipWithinDays(self, weights: list[int], days: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int shipWithinDays(std::vector<int>& weights, int days) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int shipWithinDays(int[] weights, int days) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "shipWithinDays",
  "params": [
    {
      "name": "weights",
      "type": "int[]"
    },
    {
      "name": "days",
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
          5,
          6,
          7,
          8,
          9,
          10
        ],
        5
      ],
      "expected": 15
    },
    {
      "args": [
        [
          3,
          2,
          2,
          4,
          1,
          4
        ],
        3
      ],
      "expected": 6
    },
    {
      "args": [
        [
          1,
          2,
          3,
          1,
          1
        ],
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
        1
      ],
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        10,
        10
      ],
      2
    ],
    "expected": 10
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
      1
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
      ],
      5
    ],
    "expected": 5
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
      ],
      3
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1790,
    '最佳观光组合',
    '给定正整数数组 values
选择一对下标 i < j，得分为 values[i] + values[j] + i - j
返回所有下标对中的最高得分',
    'medium',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "values = [8, 1, 5, 2, 6]",
    "output": "11"
  },
  {
    "input": "values = [1, 2]",
    "output": "2"
  },
  {
    "input": "values = [1, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "values = [8, 1, 5, 2, 6]",
    "output": "11"
  },
  {
    "input": "values = [1, 2]",
    "output": "2"
  },
  {
    "input": "values = [1, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxScoreSightseeingPair = function(values) {\n};\n",
  "python": "class Solution:\n    def maxScoreSightseeingPair(self, values: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxScoreSightseeingPair(std::vector<int>& values) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxScoreSightseeingPair(int[] values) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxScoreSightseeingPair",
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
          8,
          1,
          5,
          2,
          6
        ]
      ],
      "expected": 11
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
        7,
        5,
        4,
        3
      ]
    ],
    "expected": 11
  },
  {
    "args": [
      [
        3,
        7,
        2,
        3
      ]
    ],
    "expected": 9
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
        1,
        1,
        1,
        10
      ]
    ],
    "expected": 16
  },
  {
    "args": [
      [
        5,
        6,
        7
      ]
    ],
    "expected": 12
  }
]$json$::jsonb,
    'approved'
),
(
    1791,
    '驼峰式匹配',
    '给定字符串数组 queries 和模式串 pattern
对每个 query，判断能否从 query 中删除若干小写字母后得到 pattern
删除时不能删除任何大写字母
返回整数数组，第 i 项为 1 表示 queries[i] 匹配，为 0 表示不匹配',
    'medium',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "queries = [\"FooBar\", \"FooBarTest\", \"FootBall\", \"FrameBuffer\", \"ForceFeedBack\"], pattern = \"FB\"",
    "output": "[1, 0, 1, 1, 0]"
  },
  {
    "input": "queries = [\"FooBar\", \"FooBarTest\", \"FootBall\", \"FrameBuffer\", \"ForceFeedBack\"], pattern = \"FoBa\"",
    "output": "[1, 0, 1, 0, 0]"
  },
  {
    "input": "queries = [\"FooBar\", \"FooBarTest\", \"FootBall\", \"FrameBuffer\", \"ForceFeedBack\"], pattern = \"FoBaT\"",
    "output": "[0, 1, 0, 0, 0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "queries = [\"FooBar\", \"FooBarTest\", \"FootBall\", \"FrameBuffer\", \"ForceFeedBack\"], pattern = \"FB\"",
    "output": "[1, 0, 1, 1, 0]"
  },
  {
    "input": "queries = [\"FooBar\", \"FooBarTest\", \"FootBall\", \"FrameBuffer\", \"ForceFeedBack\"], pattern = \"FoBa\"",
    "output": "[1, 0, 1, 0, 0]"
  },
  {
    "input": "queries = [\"FooBar\", \"FooBarTest\", \"FootBall\", \"FrameBuffer\", \"ForceFeedBack\"], pattern = \"FoBaT\"",
    "output": "[0, 1, 0, 0, 0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var camelMatch = function(queries, pattern) {\n};\n",
  "python": "class Solution:\n    def camelMatch(self, queries: list[str], pattern: str) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> camelMatch(std::vector<std::string>& queries, std::string pattern) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] camelMatch(String[] queries, String pattern) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "camelMatch",
  "params": [
    {
      "name": "queries",
      "type": "string[]"
    },
    {
      "name": "pattern",
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
          "FooBar",
          "FooBarTest",
          "FootBall",
          "FrameBuffer",
          "ForceFeedBack"
        ],
        "FB"
      ],
      "expected": [
        1,
        0,
        1,
        1,
        0
      ]
    },
    {
      "args": [
        [
          "FooBar",
          "FooBarTest",
          "FootBall",
          "FrameBuffer",
          "ForceFeedBack"
        ],
        "FoBa"
      ],
      "expected": [
        1,
        0,
        1,
        0,
        0
      ]
    },
    {
      "args": [
        [
          "FooBar",
          "FooBarTest",
          "FootBall",
          "FrameBuffer",
          "ForceFeedBack"
        ],
        "FoBaT"
      ],
      "expected": [
        0,
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
        "FooBar"
      ],
      "FB"
    ],
    "expected": [
      1
    ]
  },
  {
    "args": [
      [
        "FooBar",
        "FooBarTest"
      ],
      "FoBaT"
    ],
    "expected": [
      0,
      1
    ]
  },
  {
    "args": [
      [
        "CompetitiveProgramming"
      ],
      "CP"
    ],
    "expected": [
      1
    ]
  },
  {
    "args": [
      [
        "abCde"
      ],
      "ace"
    ],
    "expected": [
      0
    ]
  },
  {
    "args": [
      [
        "AB"
      ],
      "A"
    ],
    "expected": [
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1792,
    '两个非重叠子数组的最大和',
    '给定整数数组 nums 和两个整数 firstLen、secondLen
找出两个不重叠的连续子数组
一个长度为 firstLen，另一个长度为 secondLen，顺序不限
返回这两个子数组元素和的最大值',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '滑动窗口'],
    $json$[
  {
    "input": "nums = [0, 6, 5, 2, 2, 5, 1, 9, 4], firstLen = 1, secondLen = 2",
    "output": "20"
  },
  {
    "input": "nums = [3, 8, 1, 3, 2, 1, 8, 9, 0], firstLen = 3, secondLen = 2",
    "output": "29"
  },
  {
    "input": "nums = [2, 1, 5, 6, 0, 9, 5, 0, 3, 8], firstLen = 4, secondLen = 3",
    "output": "31"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [0, 6, 5, 2, 2, 5, 1, 9, 4], firstLen = 1, secondLen = 2",
    "output": "20"
  },
  {
    "input": "nums = [3, 8, 1, 3, 2, 1, 8, 9, 0], firstLen = 3, secondLen = 2",
    "output": "29"
  },
  {
    "input": "nums = [2, 1, 5, 6, 0, 9, 5, 0, 3, 8], firstLen = 4, secondLen = 3",
    "output": "31"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxSumTwoNoOverlap = function(nums, firstLen, secondLen) {\n};\n",
  "python": "class Solution:\n    def maxSumTwoNoOverlap(self, nums: list[int], firstLen: int, secondLen: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxSumTwoNoOverlap(std::vector<int>& nums, int firstLen, int secondLen) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxSumTwoNoOverlap(int[] nums, int firstLen, int secondLen) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxSumTwoNoOverlap",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "firstLen",
      "type": "int"
    },
    {
      "name": "secondLen",
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
          0,
          6,
          5,
          2,
          2,
          5,
          1,
          9,
          4
        ],
        1,
        2
      ],
      "expected": 20
    },
    {
      "args": [
        [
          3,
          8,
          1,
          3,
          2,
          1,
          8,
          9,
          0
        ],
        3,
        2
      ],
      "expected": 29
    },
    {
      "args": [
        [
          2,
          1,
          5,
          6,
          0,
          9,
          5,
          0,
          3,
          8
        ],
        4,
        3
      ],
      "expected": 31
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
      ],
      1,
      1
    ],
    "expected": 9
  },
  {
    "args": [
      [
        4,
        5,
        6,
        7,
        8
      ],
      2,
      2
    ],
    "expected": 26
  },
  {
    "args": [
      [
        1,
        2,
        3
      ],
      1,
      1
    ],
    "expected": 5
  },
  {
    "args": [
      [
        8,
        1,
        5,
        2,
        6
      ],
      2,
      1
    ],
    "expected": 16
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
      2,
      2
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1793,
    '爱生气的书店老板',
    '给定整数数组 customers 和 grumpy，以及整数 minutes
customers[i] 表示第 i 分钟进入的顾客数量
grumpy[i] 为 1 表示老板第 i 分钟生气，此时顾客不会满意，为 0 时顾客满意
老板可以连续 minutes 分钟不生气，且只能使用一次这个技巧
返回最多能让多少顾客满意',
    'medium',
    1000,
    256,
    ARRAY['数组', '滑动窗口'],
    $json$[
  {
    "input": "customers = [1, 0, 1, 2, 1, 1, 7, 5], grumpy = [0, 1, 0, 1, 0, 1, 0, 1], minutes = 3",
    "output": "16"
  },
  {
    "input": "customers = [1], grumpy = [0], minutes = 1",
    "output": "1"
  },
  {
    "input": "customers = [1], grumpy = [1], minutes = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "customers = [1, 0, 1, 2, 1, 1, 7, 5], grumpy = [0, 1, 0, 1, 0, 1, 0, 1], minutes = 3",
    "output": "16"
  },
  {
    "input": "customers = [1], grumpy = [0], minutes = 1",
    "output": "1"
  },
  {
    "input": "customers = [1], grumpy = [1], minutes = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxSatisfied = function(customers, grumpy, minutes) {\n};\n",
  "python": "class Solution:\n    def maxSatisfied(self, customers: list[int], grumpy: list[int], minutes: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxSatisfied(std::vector<int>& customers, std::vector<int>& grumpy, int minutes) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxSatisfied(int[] customers, int[] grumpy, int minutes) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxSatisfied",
  "params": [
    {
      "name": "customers",
      "type": "int[]"
    },
    {
      "name": "grumpy",
      "type": "int[]"
    },
    {
      "name": "minutes",
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
          0,
          1,
          2,
          1,
          1,
          7,
          5
        ],
        [
          0,
          1,
          0,
          1,
          0,
          1,
          0,
          1
        ],
        3
      ],
      "expected": 16
    },
    {
      "args": [
        [
          1
        ],
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
          1
        ],
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
        2,
        3,
        4,
        5
      ],
      [
        0,
        0,
        0,
        0
      ],
      2
    ],
    "expected": 14
  },
  {
    "args": [
      [
        2,
        3,
        4,
        5
      ],
      [
        1,
        1,
        1,
        1
      ],
      2
    ],
    "expected": 9
  },
  {
    "args": [
      [
        5,
        0,
        5
      ],
      [
        0,
        1,
        0
      ],
      1
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
      ],
      [
        1,
        0,
        1,
        0,
        1
      ],
      2
    ],
    "expected": 11
  },
  {
    "args": [
      [
        3,
        3,
        3
      ],
      [
        0,
        1,
        0
      ],
      2
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1794,
    '通过投票对团队排名',
    '给定字符串数组 votes，每个字符串表示一张选票上的团队排名
第 i 个字符表示该选票上的第 i 名
排名规则：先比较第一名票数，票数多者在前
若相同则比较第二名票数，依此类推
若所有名次票数都相同，则按团队字母升序排列
返回按此规则排好序的团队字符串',
    'medium',
    1000,
    256,
    ARRAY['数组', '字符串', '排序', '哈希表'],
    $json$[
  {
    "input": "votes = [\"ABC\", \"ACB\", \"ABC\", \"ACB\", \"ACB\"]",
    "output": "\"ACB\""
  },
  {
    "input": "votes = [\"WXYZ\", \"XYZW\"]",
    "output": "\"XWYZ\""
  },
  {
    "input": "votes = [\"ZMNAGUEDSJYLBOPHRQICWFXTVK\"]",
    "output": "\"ZMNAGUEDSJYLBOPHRQICWFXTVK\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "votes = [\"ABC\", \"ACB\", \"ABC\", \"ACB\", \"ACB\"]",
    "output": "\"ACB\""
  },
  {
    "input": "votes = [\"WXYZ\", \"XYZW\"]",
    "output": "\"XWYZ\""
  },
  {
    "input": "votes = [\"ZMNAGUEDSJYLBOPHRQICWFXTVK\"]",
    "output": "\"ZMNAGUEDSJYLBOPHRQICWFXTVK\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var rankTeams = function(votes) {\n};\n",
  "python": "class Solution:\n    def rankTeams(self, votes: list[str]) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string rankTeams(std::vector<std::string>& votes) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String rankTeams(String[] votes) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "rankTeams",
  "params": [
    {
      "name": "votes",
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
          "ABC",
          "ACB",
          "ABC",
          "ACB",
          "ACB"
        ]
      ],
      "expected": "ACB"
    },
    {
      "args": [
        [
          "WXYZ",
          "XYZW"
        ]
      ],
      "expected": "XWYZ"
    },
    {
      "args": [
        [
          "ZMNAGUEDSJYLBOPHRQICWFXTVK"
        ]
      ],
      "expected": "ZMNAGUEDSJYLBOPHRQICWFXTVK"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "ABC"
      ]
    ],
    "expected": "ABC"
  },
  {
    "args": [
      [
        "ABC",
        "ABC"
      ]
    ],
    "expected": "ABC"
  },
  {
    "args": [
      [
        "BCA",
        "CAB",
        "CBA"
      ]
    ],
    "expected": "CBA"
  },
  {
    "args": [
      [
        "AB",
        "BA"
      ]
    ],
    "expected": "AB"
  },
  {
    "args": [
      [
        "A",
        "A",
        "A"
      ]
    ],
    "expected": "A"
  }
]$json$::jsonb,
    'approved'
),
(
    1795,
    '不同字符的最小子序列',
    '给定字符串 s
返回 s 的一个子序列，要求 s 中出现的每个不同字符都恰好出现一次
在满足条件的所有子序列中，返回字典序最小的一个',
    'medium',
    1000,
    256,
    ARRAY['字符串', '单调栈', '贪心'],
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
    "input": "s = \"abcd\"",
    "output": "\"abcd\""
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
    "input": "s = \"abcd\"",
    "output": "\"abcd\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestSubsequence = function(s) {\n};\n",
  "python": "class Solution:\n    def smallestSubsequence(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string smallestSubsequence(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String smallestSubsequence(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestSubsequence",
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
        "abcd"
      ],
      "expected": "abcd"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "ecbacba"
    ],
    "expected": "eacb"
  },
  {
    "args": [
      "cba"
    ],
    "expected": "cba"
  },
  {
    "args": [
      "abab"
    ],
    "expected": "ab"
  },
  {
    "args": [
      "bcbcbc"
    ],
    "expected": "bc"
  },
  {
    "args": [
      "acdb"
    ],
    "expected": "acdb"
  }
]$json$::jsonb,
    'approved'
),
(
    1796,
    '受标签影响的最大值',
    '给定整数数组 values、labels，以及整数 numWanted 和 useLimit
从 0 到 n-1 中选择若干下标，选出的元素个数不超过 numWanted
同一个标签最多只能选择 useLimit 个元素
返回所选元素值之和的最大值',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '哈希表', '贪心'],
    $json$[
  {
    "input": "values = [5, 4, 3, 2, 1], labels = [1, 1, 2, 2, 3], numWanted = 3, useLimit = 1",
    "output": "9"
  },
  {
    "input": "values = [5, 4, 3, 2, 1], labels = [1, 3, 3, 3, 2], numWanted = 3, useLimit = 2",
    "output": "12"
  },
  {
    "input": "values = [9, 8, 8, 7, 6], labels = [0, 0, 0, 1, 1], numWanted = 3, useLimit = 1",
    "output": "16"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "values = [5, 4, 3, 2, 1], labels = [1, 1, 2, 2, 3], numWanted = 3, useLimit = 1",
    "output": "9"
  },
  {
    "input": "values = [5, 4, 3, 2, 1], labels = [1, 3, 3, 3, 2], numWanted = 3, useLimit = 2",
    "output": "12"
  },
  {
    "input": "values = [9, 8, 8, 7, 6], labels = [0, 0, 0, 1, 1], numWanted = 3, useLimit = 1",
    "output": "16"
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestValsFromLabels = function(values, labels, numWanted, useLimit) {\n};\n",
  "python": "class Solution:\n    def largestValsFromLabels(self, values: list[int], labels: list[int], numWanted: int, useLimit: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int largestValsFromLabels(std::vector<int>& values, std::vector<int>& labels, int numWanted, int useLimit) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int largestValsFromLabels(int[] values, int[] labels, int numWanted, int useLimit) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestValsFromLabels",
  "params": [
    {
      "name": "values",
      "type": "int[]"
    },
    {
      "name": "labels",
      "type": "int[]"
    },
    {
      "name": "numWanted",
      "type": "int"
    },
    {
      "name": "useLimit",
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
          5,
          4,
          3,
          2,
          1
        ],
        [
          1,
          1,
          2,
          2,
          3
        ],
        3,
        1
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
        ],
        [
          1,
          3,
          3,
          3,
          2
        ],
        3,
        2
      ],
      "expected": 12
    },
    {
      "args": [
        [
          9,
          8,
          8,
          7,
          6
        ],
        [
          0,
          0,
          0,
          1,
          1
        ],
        3,
        1
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
        3
      ],
      [
        0,
        0,
        0
      ],
      2,
      1
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
        0,
        1,
        2
      ],
      3,
      1
    ],
    "expected": 6
  },
  {
    "args": [
      [
        5,
        5,
        5
      ],
      [
        0,
        0,
        0
      ],
      2,
      2
    ],
    "expected": 10
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
        0,
        1,
        0,
        1
      ],
      4,
      1
    ],
    "expected": 19
  },
  {
    "args": [
      [
        1
      ],
      [
        0
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
    1797,
    '拼车',
    '给定二维整数数组 trips 和整数 capacity
trips[i] = [numPassengers, start, end] 表示第 i 次行程有 numPassengers 人
这些乘客从 start 上车，在 end 下车
判断车辆容量为 capacity 时能否完成所有行程
乘客只能在起点上车、在终点下车，且任意时刻车上人数不能超过容量',
    'medium',
    1000,
    256,
    ARRAY['数组', '差分数组', '排序'],
    $json$[
  {
    "input": "trips = [[2, 1, 5], [3, 3, 7]], capacity = 4",
    "output": "false"
  },
  {
    "input": "trips = [[2, 1, 5], [3, 3, 7]], capacity = 5",
    "output": "true"
  },
  {
    "input": "trips = [[2, 1, 5], [3, 5, 7]], capacity = 3",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "trips = [[2, 1, 5], [3, 3, 7]], capacity = 4",
    "output": "false"
  },
  {
    "input": "trips = [[2, 1, 5], [3, 3, 7]], capacity = 5",
    "output": "true"
  },
  {
    "input": "trips = [[2, 1, 5], [3, 5, 7]], capacity = 3",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var carPooling = function(trips, capacity) {\n};\n",
  "python": "class Solution:\n    def carPooling(self, trips: list[list[int]], capacity: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool carPooling(std::vector<std::vector<int>>& trips, int capacity) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean carPooling(int[][] trips, int capacity) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "carPooling",
  "params": [
    {
      "name": "trips",
      "type": "int[][]"
    },
    {
      "name": "capacity",
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
            2,
            1,
            5
          ],
          [
            3,
            3,
            7
          ]
        ],
        4
      ],
      "expected": false
    },
    {
      "args": [
        [
          [
            2,
            1,
            5
          ],
          [
            3,
            3,
            7
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
            2,
            1,
            5
          ],
          [
            3,
            5,
            7
          ]
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
        [
          1,
          0,
          2
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
          2,
          0,
          2
        ],
        [
          1,
          1,
          2
        ]
      ],
      2
    ],
    "expected": false
  },
  {
    "args": [
      [
        [
          3,
          0,
          5
        ]
      ],
      2
    ],
    "expected": false
  },
  {
    "args": [
      [
        [
          2,
          0,
          5
        ],
        [
          2,
          5,
          10
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
          0,
          1
        ],
        [
          1,
          1,
          2
        ],
        [
          1,
          2,
          3
        ]
      ],
      1
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1798,
    '航班预订统计',
    '给定二维整数数组 bookings 和整数 n
bookings[i] = [first, last, seats] 表示从 first 到 last 的每个航班都预订了 seats 个座位
航班编号从 1 到 n
返回长度为 n 的数组，第 i 项表示航班 i 的预订座位总数',
    'medium',
    1000,
    256,
    ARRAY['数组', '差分数组', '前缀和'],
    $json$[
  {
    "input": "bookings = [[1, 2, 10], [2, 3, 20], [2, 5, 25]], n = 5",
    "output": "[10, 55, 45, 25, 25]"
  },
  {
    "input": "bookings = [[1, 2, 10], [2, 2, 15]], n = 2",
    "output": "[10, 25]"
  },
  {
    "input": "bookings = [[1, 1, 1]], n = 1",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "bookings = [[1, 2, 10], [2, 3, 20], [2, 5, 25]], n = 5",
    "output": "[10, 55, 45, 25, 25]"
  },
  {
    "input": "bookings = [[1, 2, 10], [2, 2, 15]], n = 2",
    "output": "[10, 25]"
  },
  {
    "input": "bookings = [[1, 1, 1]], n = 1",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var corpFlightBookings = function(bookings, n) {\n};\n",
  "python": "class Solution:\n    def corpFlightBookings(self, bookings: list[list[int]], n: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> corpFlightBookings(std::vector<std::vector<int>>& bookings, int n) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] corpFlightBookings(int[][] bookings, int n) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "corpFlightBookings",
  "params": [
    {
      "name": "bookings",
      "type": "int[][]"
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
          [
            1,
            2,
            10
          ],
          [
            2,
            3,
            20
          ],
          [
            2,
            5,
            25
          ]
        ],
        5
      ],
      "expected": [
        10,
        55,
        45,
        25,
        25
      ]
    },
    {
      "args": [
        [
          [
            1,
            2,
            10
          ],
          [
            2,
            2,
            15
          ]
        ],
        2
      ],
      "expected": [
        10,
        25
      ]
    },
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
      "expected": [
        1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [],
      3
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
        [
          1,
          3,
          5
        ]
      ],
      3
    ],
    "expected": [
      5,
      5,
      5
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
          2,
          3,
          2
        ],
        [
          1,
          3,
          3
        ]
      ],
      3
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
        [
          2,
          2,
          7
        ]
      ],
      4
    ],
    "expected": [
      0,
      7,
      0,
      0
    ]
  },
  {
    "args": [
      [
        [
          1,
          5,
          2
        ],
        [
          3,
          4,
          3
        ]
      ],
      5
    ],
    "expected": [
      2,
      2,
      5,
      5,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1799,
    '表现良好的最长时间段',
    '给定整数数组 hours
若某天工作小时数大于 8，则这一天为「劳累的一天」，否则为「不劳累的一天」
找出一个连续时间段，使得其中劳累的天数严格多于不劳累的天数
返回满足条件的最长时间段的长度，若不存在则返回 0',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '哈希表'],
    $json$[
  {
    "input": "hours = [9, 9, 6, 0, 6, 6, 9]",
    "output": "3"
  },
  {
    "input": "hours = [6, 6, 6]",
    "output": "0"
  },
  {
    "input": "hours = [6, 9, 9]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "hours = [9, 9, 6, 0, 6, 6, 9]",
    "output": "3"
  },
  {
    "input": "hours = [6, 6, 6]",
    "output": "0"
  },
  {
    "input": "hours = [6, 9, 9]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestWPI = function(hours) {\n};\n",
  "python": "class Solution:\n    def longestWPI(self, hours: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestWPI(std::vector<int>& hours) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestWPI(int[] hours) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestWPI",
  "params": [
    {
      "name": "hours",
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
          9,
          6,
          0,
          6,
          6,
          9
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          6,
          6,
          6
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          6,
          9,
          9
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
        9,
        6,
        6
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        6,
        9,
        6
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        9,
        9,
        9,
        9
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        6,
        6,
        9,
        6,
        6,
        9
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        9,
        6,
        9,
        6,
        9
      ]
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1800,
    '单字符重复子串的最大长度',
    '给定字符串 text
最多交换字符串中的两个字符一次
返回交换后只包含一种字符的最长连续子串的长度',
    'medium',
    1000,
    256,
    ARRAY['字符串', '滑动窗口', '哈希表'],
    $json$[
  {
    "input": "text = \"ababa\"",
    "output": "3"
  },
  {
    "input": "text = \"aaabaaa\"",
    "output": "6"
  },
  {
    "input": "text = \"aaabbb\"",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "text = \"ababa\"",
    "output": "3"
  },
  {
    "input": "text = \"aaabaaa\"",
    "output": "6"
  },
  {
    "input": "text = \"aaabbb\"",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxRepOpt1 = function(text) {\n};\n",
  "python": "class Solution:\n    def maxRepOpt1(self, text: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxRepOpt1(std::string text) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxRepOpt1(String text) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxRepOpt1",
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
        "ababa"
      ],
      "expected": 3
    },
    {
      "args": [
        "aaabaaa"
      ],
      "expected": 6
    },
    {
      "args": [
        "aaabbb"
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
      "aaaa"
    ],
    "expected": 4
  },
  {
    "args": [
      "ab"
    ],
    "expected": 1
  },
  {
    "args": [
      "aabaa"
    ],
    "expected": 4
  },
  {
    "args": [
      "abcdef"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1801,
    '构建回文串检测',
    '给定字符串 s 和二维整数数组 queries
queries[i] = [left, right, k] 表示对子串 s[left..right] 进行检测
可以重新排列子串中的字符，并最多替换其中 k 个字符
判断能否把该子串变成回文串
返回整数数组，第 i 项为 1 表示可以，为 0 表示不可以',
    'medium',
    1000,
    256,
    ARRAY['字符串', '前缀和', '位运算'],
    $json$[
  {
    "input": "s = \"abcda\", queries = [[3, 3, 0], [1, 2, 0], [0, 3, 1], [0, 4, 2]]",
    "output": "[1, 0, 0, 1]"
  },
  {
    "input": "s = \"ab\", queries = [[0, 1, 0]]",
    "output": "[0]"
  },
  {
    "input": "s = \"aa\", queries = [[0, 1, 0]]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abcda\", queries = [[3, 3, 0], [1, 2, 0], [0, 3, 1], [0, 4, 2]]",
    "output": "[1, 0, 0, 1]"
  },
  {
    "input": "s = \"ab\", queries = [[0, 1, 0]]",
    "output": "[0]"
  },
  {
    "input": "s = \"aa\", queries = [[0, 1, 0]]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canMakePaliQueries = function(s, queries) {\n};\n",
  "python": "class Solution:\n    def canMakePaliQueries(self, s: str, queries: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> canMakePaliQueries(std::string s, std::vector<std::vector<int>>& queries) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] canMakePaliQueries(String s, int[][] queries) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canMakePaliQueries",
  "params": [
    {
      "name": "s",
      "type": "string"
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
        "abcda",
        [
          [
            3,
            3,
            0
          ],
          [
            1,
            2,
            0
          ],
          [
            0,
            3,
            1
          ],
          [
            0,
            4,
            2
          ]
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
        "ab",
        [
          [
            0,
            1,
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
        "aa",
        [
          [
            0,
            1,
            0
          ]
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
      "abc",
      [
        [
          0,
          2,
          0
        ],
        [
          0,
          2,
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
      "a",
      [
        [
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
      "abcd",
      [
        [
          0,
          3,
          1
        ],
        [
          0,
          3,
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
      "abba",
      [
        [
          0,
          3,
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
      "abcdef",
      [
        [
          0,
          5,
          2
        ],
        [
          1,
          4,
          1
        ]
      ]
    ],
    "expected": [
      0,
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1802,
    '反转每对括号间的子串',
    '给定字符串 s，其中只包含小写字母和括号
从左到右处理每一对括号，把括号内的子串反转，然后去掉这对括号
括号可能嵌套，按从内到外的顺序处理
返回处理后的最终字符串',
    'medium',
    1000,
    256,
    ARRAY['字符串', '栈'],
    $json$[
  {
    "input": "s = \"(abcd)\"",
    "output": "\"dcba\""
  },
  {
    "input": "s = \"(u(love)i)\"",
    "output": "\"iloveu\""
  },
  {
    "input": "s = \"(ed(et(oc))el)\"",
    "output": "\"leetcode\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"(abcd)\"",
    "output": "\"dcba\""
  },
  {
    "input": "s = \"(u(love)i)\"",
    "output": "\"iloveu\""
  },
  {
    "input": "s = \"(ed(et(oc))el)\"",
    "output": "\"leetcode\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var reverseParentheses = function(s) {\n};\n",
  "python": "class Solution:\n    def reverseParentheses(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string reverseParentheses(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String reverseParentheses(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reverseParentheses",
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
        "(abcd)"
      ],
      "expected": "dcba"
    },
    {
      "args": [
        "(u(love)i)"
      ],
      "expected": "iloveu"
    },
    {
      "args": [
        "(ed(et(oc))el)"
      ],
      "expected": "leetcode"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a(bcdefghijkl(mno)p)q"
    ],
    "expected": "apmnolkjihgfedcbq"
  },
  {
    "args": [
      "()"
    ],
    "expected": ""
  },
  {
    "args": [
      "abc"
    ],
    "expected": "abc"
  },
  {
    "args": [
      "((ab))"
    ],
    "expected": "ab"
  },
  {
    "args": [
      "(ab)(cd)"
    ],
    "expected": "badc"
  }
]$json$::jsonb,
    'approved'
),
(
    1803,
    '尽可能使字符串相等',
    '给定两个长度相同的字符串 s 和 t，以及整数 maxCost
把 s[i] 改成 t[i] 的代价是它们字符编码之差的绝对值
最多可以花费 maxCost
返回能够变成 t 对应子串的 s 的最长连续子串长度',
    'medium',
    1000,
    256,
    ARRAY['字符串', '滑动窗口', '二分查找'],
    $json$[
  {
    "input": "s = \"abcd\", t = \"bcdf\", maxCost = 3",
    "output": "3"
  },
  {
    "input": "s = \"abcd\", t = \"cdef\", maxCost = 3",
    "output": "1"
  },
  {
    "input": "s = \"abcd\", t = \"acde\", maxCost = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abcd\", t = \"bcdf\", maxCost = 3",
    "output": "3"
  },
  {
    "input": "s = \"abcd\", t = \"cdef\", maxCost = 3",
    "output": "1"
  },
  {
    "input": "s = \"abcd\", t = \"acde\", maxCost = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var equalSubstring = function(s, t, maxCost) {\n};\n",
  "python": "class Solution:\n    def equalSubstring(self, s: str, t: str, maxCost: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int equalSubstring(std::string s, std::string t, int maxCost) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int equalSubstring(String s, String t, int maxCost) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "equalSubstring",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "t",
      "type": "string"
    },
    {
      "name": "maxCost",
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
        "abcd",
        "bcdf",
        3
      ],
      "expected": 3
    },
    {
      "args": [
        "abcd",
        "cdef",
        3
      ],
      "expected": 1
    },
    {
      "args": [
        "abcd",
        "acde",
        0
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      "a",
      0
    ],
    "expected": 1
  },
  {
    "args": [
      "abc",
      "xyz",
      100
    ],
    "expected": 3
  },
  {
    "args": [
      "abcd",
      "abcd",
      0
    ],
    "expected": 4
  },
  {
    "args": [
      "krrgw",
      "zjxss",
      19
    ],
    "expected": 2
  },
  {
    "args": [
      "ab",
      "ba",
      2
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1804,
    '删除字符串中的所有相邻重复项 II',
    '给定字符串 s 和整数 k，其中 2 <= k <= 100
反复删除字符串中连续出现 k 次的相同字符
删除后两边的部分会拼接，可能形成新的连续 k 个相同字符，需要继续删除
返回最终字符串
题目保证最终结果唯一',
    'medium',
    1000,
    256,
    ARRAY['字符串', '栈'],
    $json$[
  {
    "input": "s = \"abcd\", k = 2",
    "output": "\"abcd\""
  },
  {
    "input": "s = \"deeedbbcccbdaa\", k = 3",
    "output": "\"aa\""
  },
  {
    "input": "s = \"pbbcggttciiippooaais\", k = 2",
    "output": "\"ps\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abcd\", k = 2",
    "output": "\"abcd\""
  },
  {
    "input": "s = \"deeedbbcccbdaa\", k = 3",
    "output": "\"aa\""
  },
  {
    "input": "s = \"pbbcggttciiippooaais\", k = 2",
    "output": "\"ps\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeDuplicatesII = function(s, k) {\n};\n",
  "python": "class Solution:\n    def removeDuplicatesII(self, s: str, k: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string removeDuplicatesII(std::string s, int k) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String removeDuplicatesII(String s, int k) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeDuplicatesII",
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
        "abcd",
        2
      ],
      "expected": "abcd"
    },
    {
      "args": [
        "deeedbbcccbdaa",
        3
      ],
      "expected": "aa"
    },
    {
      "args": [
        "pbbcggttciiippooaais",
        2
      ],
      "expected": "ps"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      2
    ],
    "expected": "a"
  },
  {
    "args": [
      "aa",
      2
    ],
    "expected": ""
  },
  {
    "args": [
      "aaa",
      2
    ],
    "expected": "a"
  },
  {
    "args": [
      "abbba",
      3
    ],
    "expected": "aa"
  },
  {
    "args": [
      "aabbbac",
      2
    ],
    "expected": "bac"
  }
]$json$::jsonb,
    'approved'
),
(
    1805,
    '删除子文件夹',
    '给定字符串数组 folder，其中每一项都是绝对路径
如果某个文件夹位于另一个文件夹内部，则它应被删除
不同文件夹之间不会因为前缀相同而产生误判，例如 /a/b 不是 /a/bc 的子文件夹
返回删除所有子文件夹后剩余的文件夹，结果按字典序升序排列',
    'medium',
    1000,
    256,
    ARRAY['字符串', '数组', '排序', '哈希表'],
    $json$[
  {
    "input": "folder = [\"/a\", \"/a/b\", \"/c/d\", \"/c/d/e\", \"/c/f\"]",
    "output": "[\"/a\", \"/c/d\", \"/c/f\"]"
  },
  {
    "input": "folder = [\"/a\", \"/a/b/c\", \"/a/b/d\"]",
    "output": "[\"/a\"]"
  },
  {
    "input": "folder = [\"/a/b/c\", \"/a/b/ca\", \"/a/b/d\"]",
    "output": "[\"/a/b/c\", \"/a/b/ca\", \"/a/b/d\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "folder = [\"/a\", \"/a/b\", \"/c/d\", \"/c/d/e\", \"/c/f\"]",
    "output": "[\"/a\", \"/c/d\", \"/c/f\"]"
  },
  {
    "input": "folder = [\"/a\", \"/a/b/c\", \"/a/b/d\"]",
    "output": "[\"/a\"]"
  },
  {
    "input": "folder = [\"/a/b/c\", \"/a/b/ca\", \"/a/b/d\"]",
    "output": "[\"/a/b/c\", \"/a/b/ca\", \"/a/b/d\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeSubfolders = function(folder) {\n};\n",
  "python": "class Solution:\n    def removeSubfolders(self, folder: list[str]) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> removeSubfolders(std::vector<std::string>& folder) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] removeSubfolders(String[] folder) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeSubfolders",
  "params": [
    {
      "name": "folder",
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
          "/a",
          "/a/b",
          "/c/d",
          "/c/d/e",
          "/c/f"
        ]
      ],
      "expected": [
        "/a",
        "/c/d",
        "/c/f"
      ]
    },
    {
      "args": [
        [
          "/a",
          "/a/b/c",
          "/a/b/d"
        ]
      ],
      "expected": [
        "/a"
      ]
    },
    {
      "args": [
        [
          "/a/b/c",
          "/a/b/ca",
          "/a/b/d"
        ]
      ],
      "expected": [
        "/a/b/c",
        "/a/b/ca",
        "/a/b/d"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "/a"
      ]
    ],
    "expected": [
      "/a"
    ]
  },
  {
    "args": [
      [
        "/z/y",
        "/z",
        "/a/b"
      ]
    ],
    "expected": [
      "/a/b",
      "/z"
    ]
  },
  {
    "args": [
      [
        "/a/b",
        "/a/b/c",
        "/a/b/d",
        "/a/b/c/d"
      ]
    ],
    "expected": [
      "/a/b"
    ]
  },
  {
    "args": [
      [
        "/a/b/c",
        "/a/b/ca",
        "/a/b/c/d"
      ]
    ],
    "expected": [
      "/a/b/c",
      "/a/b/ca"
    ]
  },
  {
    "args": [
      [
        "/x1",
        "/x2",
        "/x1/y",
        "/x2/y"
      ]
    ],
    "expected": [
      "/x1",
      "/x2"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1806,
    '替换子串得到平衡字符串',
    '给定长度为 4 的倍数的字符串 s，只包含 Q、W、E、R 四种字符
如果四种字符出现的次数都等于 n / 4，则称 s 是平衡的
可以选一个连续子串，替换成任意长度相同的字符串
返回使 s 变得平衡所需替换子串的最小长度',
    'medium',
    1000,
    256,
    ARRAY['字符串', '滑动窗口', '哈希表'],
    $json$[
  {
    "input": "s = \"QWER\"",
    "output": "0"
  },
  {
    "input": "s = \"QQWE\"",
    "output": "1"
  },
  {
    "input": "s = \"QQQW\"",
    "output": "2"
  },
  {
    "input": "s = \"QQQQ\"",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"QWER\"",
    "output": "0"
  },
  {
    "input": "s = \"QQWE\"",
    "output": "1"
  },
  {
    "input": "s = \"QQQW\"",
    "output": "2"
  },
  {
    "input": "s = \"QQQQ\"",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var balancedString = function(s) {\n};\n",
  "python": "class Solution:\n    def balancedString(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int balancedString(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int balancedString(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "balancedString",
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
        "QWER"
      ],
      "expected": 0
    },
    {
      "args": [
        "QQWE"
      ],
      "expected": 1
    },
    {
      "args": [
        "QQQW"
      ],
      "expected": 2
    },
    {
      "args": [
        "QQQQ"
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "WQWRQQQW"
    ],
    "expected": 3
  },
  {
    "args": [
      "QWERQWER"
    ],
    "expected": 0
  },
  {
    "args": [
      "QQQQWWWW"
    ],
    "expected": 4
  },
  {
    "args": [
      "QQWEQWER"
    ],
    "expected": 1
  },
  {
    "args": [
      "WWEERRQQ"
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1807,
    '统计「优美子数组」',
    '给定整数数组 nums 和整数 k
如果某个连续子数组中恰好有 k 个奇数，则称它为优美子数组
返回优美子数组的数量',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '滑动窗口'],
    $json$[
  {
    "input": "nums = [1, 1, 2, 1, 1], k = 3",
    "output": "2"
  },
  {
    "input": "nums = [2, 4, 6], k = 1",
    "output": "0"
  },
  {
    "input": "nums = [2, 2, 2, 1, 2, 2, 1, 2, 2, 2], k = 2",
    "output": "16"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 2, 1, 1], k = 3",
    "output": "2"
  },
  {
    "input": "nums = [2, 4, 6], k = 1",
    "output": "0"
  },
  {
    "input": "nums = [2, 2, 2, 1, 2, 2, 1, 2, 2, 2], k = 2",
    "output": "16"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numberOfSubarrays = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def numberOfSubarrays(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numberOfSubarrays(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numberOfSubarrays(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numberOfSubarrays",
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
          2,
          1,
          1
        ],
        3
      ],
      "expected": 2
    },
    {
      "args": [
        [
          2,
          4,
          6
        ],
        1
      ],
      "expected": 0
    },
    {
      "args": [
        [
          2,
          2,
          2,
          1,
          2,
          2,
          1,
          2,
          2,
          2
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
    "expected": 0
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
    "expected": 1
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
    "expected": 3
  },
  {
    "args": [
      [
        2,
        2,
        1,
        2,
        2
      ],
      1
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1808,
    '移除无效的括号',
    '给定字符串 s，其中包含小写字母和括号
删除最少数量的左括号或右括号，使剩余括号序列有效
有效的条件是每个右括号都有对应的左括号，且配对顺序正确
返回删除后的字符串，若存在多种删除方式需保证结果字符串唯一
题目数据保证结果唯一',
    'medium',
    1000,
    256,
    ARRAY['字符串', '栈'],
    $json$[
  {
    "input": "s = \"lee(t(c)o)de)\"",
    "output": "\"lee(t(c)o)de\""
  },
  {
    "input": "s = \"a)b(c)d\"",
    "output": "\"ab(c)d\""
  },
  {
    "input": "s = \"))((\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"lee(t(c)o)de)\"",
    "output": "\"lee(t(c)o)de\""
  },
  {
    "input": "s = \"a)b(c)d\"",
    "output": "\"ab(c)d\""
  },
  {
    "input": "s = \"))((\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var minRemoveToMakeValid = function(s) {\n};\n",
  "python": "class Solution:\n    def minRemoveToMakeValid(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string minRemoveToMakeValid(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String minRemoveToMakeValid(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minRemoveToMakeValid",
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
        "lee(t(c)o)de)"
      ],
      "expected": "lee(t(c)o)de"
    },
    {
      "args": [
        "a)b(c)d"
      ],
      "expected": "ab(c)d"
    },
    {
      "args": [
        "))(("
      ],
      "expected": ""
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
      "abc"
    ],
    "expected": "abc"
  },
  {
    "args": [
      "(a(b)c)"
    ],
    "expected": "(a(b)c)"
  },
  {
    "args": [
      "))(a"
    ],
    "expected": "a"
  },
  {
    "args": [
      "a)b(c)d)e"
    ],
    "expected": "ab(c)de"
  }
]$json$::jsonb,
    'approved'
),
(
    1809,
    '制造字母异位词的最小步骤数',
    '给定两个长度相同的字符串 s 和 t
每步可以选择 s 中任意一个字符替换成另一个字符
返回使 t 成为 s 的字母异位词所需的最少步骤数
字母异位词指两个字符串中每种字符出现次数都相同',
    'medium',
    1000,
    256,
    ARRAY['字符串', '哈希表', '计数'],
    $json$[
  {
    "input": "s = \"bab\", t = \"aba\"",
    "output": "1"
  },
  {
    "input": "s = \"leetcode\", t = \"practice\"",
    "output": "5"
  },
  {
    "input": "s = \"anagram\", t = \"mangaar\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"bab\", t = \"aba\"",
    "output": "1"
  },
  {
    "input": "s = \"leetcode\", t = \"practice\"",
    "output": "5"
  },
  {
    "input": "s = \"anagram\", t = \"mangaar\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minSteps = function(s, t) {\n};\n",
  "python": "class Solution:\n    def minSteps(self, s: str, t: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minSteps(std::string s, std::string t) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minSteps(String s, String t) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minSteps",
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
        "bab",
        "aba"
      ],
      "expected": 1
    },
    {
      "args": [
        "leetcode",
        "practice"
      ],
      "expected": 5
    },
    {
      "args": [
        "anagram",
        "mangaar"
      ],
      "expected": 0
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
      "a",
      "b"
    ],
    "expected": 1
  },
  {
    "args": [
      "abc",
      "cba"
    ],
    "expected": 0
  },
  {
    "args": [
      "aaa",
      "bbb"
    ],
    "expected": 3
  },
  {
    "args": [
      "abcde",
      "edcba"
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1810,
    '使结果不超过阈值的最小除数',
    '给定整数数组 nums 和整数 threshold
选择一个正整数 divisor，把每个 nums[i] 除以 divisor 并向上取整后求和
返回使总和不超过 threshold 的最小 divisor',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "nums = [1, 2, 5, 9], threshold = 6",
    "output": "5"
  },
  {
    "input": "nums = [2, 3, 5, 7, 11], threshold = 11",
    "output": "3"
  },
  {
    "input": "nums = [19], threshold = 5",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 5, 9], threshold = 6",
    "output": "5"
  },
  {
    "input": "nums = [2, 3, 5, 7, 11], threshold = 11",
    "output": "3"
  },
  {
    "input": "nums = [19], threshold = 5",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestDivisor = function(nums, threshold) {\n};\n",
  "python": "class Solution:\n    def smallestDivisor(self, nums: list[int], threshold: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int smallestDivisor(std::vector<int>& nums, int threshold) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int smallestDivisor(int[] nums, int threshold) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestDivisor",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "threshold",
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
          5,
          9
        ],
        6
      ],
      "expected": 5
    },
    {
      "args": [
        [
          2,
          3,
          5,
          7,
          11
        ],
        11
      ],
      "expected": 3
    },
    {
      "args": [
        [
          19
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
        2,
        2,
        2
      ],
      3
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
        5,
        9,
        14
      ],
      7
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
      ],
      5
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1811,
    '元素和小于等于阈值的正方形的最大边长',
    '给定 m x n 的非负整数矩阵 mat 和整数 threshold
找出一个正方形子矩阵，使其所有元素之和不超过 threshold
返回满足条件的正方形的最大边长，若不存在则返回 0',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '二分查找', '矩阵'],
    $json$[
  {
    "input": "mat = [[1, 1, 3, 2, 4, 3, 2], [1, 1, 3, 2, 4, 3, 2], [1, 1, 3, 2, 4, 3, 2]], threshold = 4",
    "output": "2"
  },
  {
    "input": "mat = [[2, 2, 2, 2, 2], [2, 2, 2, 2, 2], [2, 2, 2, 2, 2], [2, 2, 2, 2, 2], [2, 2, 2, 2, 2]], threshold = 1",
    "output": "0"
  },
  {
    "input": "mat = [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], threshold = 4",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mat = [[1, 1, 3, 2, 4, 3, 2], [1, 1, 3, 2, 4, 3, 2], [1, 1, 3, 2, 4, 3, 2]], threshold = 4",
    "output": "2"
  },
  {
    "input": "mat = [[2, 2, 2, 2, 2], [2, 2, 2, 2, 2], [2, 2, 2, 2, 2], [2, 2, 2, 2, 2], [2, 2, 2, 2, 2]], threshold = 1",
    "output": "0"
  },
  {
    "input": "mat = [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], threshold = 4",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxSideLength = function(mat, threshold) {\n};\n",
  "python": "class Solution:\n    def maxSideLength(self, mat: list[list[int]], threshold: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxSideLength(std::vector<std::vector<int>>& mat, int threshold) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxSideLength(int[][] mat, int threshold) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxSideLength",
  "params": [
    {
      "name": "mat",
      "type": "int[][]"
    },
    {
      "name": "threshold",
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
            1,
            3,
            2,
            4,
            3,
            2
          ],
          [
            1,
            1,
            3,
            2,
            4,
            3,
            2
          ],
          [
            1,
            1,
            3,
            2,
            4,
            3,
            2
          ]
        ],
        4
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            2,
            2,
            2,
            2,
            2
          ],
          [
            2,
            2,
            2,
            2,
            2
          ],
          [
            2,
            2,
            2,
            2,
            2
          ],
          [
            2,
            2,
            2,
            2,
            2
          ],
          [
            2,
            2,
            2,
            2,
            2
          ]
        ],
        1
      ],
      "expected": 0
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
          1
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
          5,
          5
        ],
        [
          5,
          5
        ]
      ],
      20
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
        ]
      ],
      5
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          3,
          3,
          3
        ],
        [
          3,
          3,
          3
        ],
        [
          3,
          3,
          3
        ]
      ],
      9
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1812,
    '划分数组为连续数字的集合',
    '给定整数数组 nums 和正整数 k
判断能否把数组划分成若干个大小为 k 的集合
每个集合中的数字必须是连续的 k 个整数，且每个元素只能使用一次
返回是否能完成划分',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '哈希表'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 3, 4, 4, 5, 6], k = 4",
    "output": "true"
  },
  {
    "input": "nums = [3, 2, 1, 2, 3, 4, 3, 4, 5, 9, 10, 11], k = 3",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3, 4], k = 3",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 3, 4, 4, 5, 6], k = 4",
    "output": "true"
  },
  {
    "input": "nums = [3, 2, 1, 2, 3, 4, 3, 4, 5, 9, 10, 11], k = 3",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3, 4], k = 3",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isPossibleDivide = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def isPossibleDivide(self, nums: list[int], k: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isPossibleDivide(std::vector<int>& nums, int k) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isPossibleDivide(int[] nums, int k) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isPossibleDivide",
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
          1,
          2,
          3,
          3,
          4,
          4,
          5,
          6
        ],
        4
      ],
      "expected": true
    },
    {
      "args": [
        [
          3,
          2,
          1,
          2,
          3,
          4,
          3,
          4,
          5,
          9,
          10,
          11
        ],
        3
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
    "expected": true
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
    "expected": true
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
    "expected": true
  },
  {
    "args": [
      [
        1,
        2,
        4,
        5
      ],
      2
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
        6
      ],
      2
    ],
    "expected": true
  },
  {
    "args": [
      [
        15,
        16,
        17,
        18
      ],
      4
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1813,
    '转变数组后最接近目标值的数组和',
    '给定整数数组 arr 和目标值 target
选择一个整数 value，把数组中每个大于 value 的元素都变成 value
修改后数组元素和记为 sum
返回使 |sum - target| 最小的 value
若存在多个这样的 value，返回其中最小的一个',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找', '排序'],
    $json$[
  {
    "input": "arr = [4, 9, 3], target = 10",
    "output": "3"
  },
  {
    "input": "arr = [2, 3, 5], target = 10",
    "output": "5"
  },
  {
    "input": "arr = [60864, 25176, 27249, 21296, 20204], target = 56803",
    "output": "11361"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [4, 9, 3], target = 10",
    "output": "3"
  },
  {
    "input": "arr = [2, 3, 5], target = 10",
    "output": "5"
  },
  {
    "input": "arr = [60864, 25176, 27249, 21296, 20204], target = 56803",
    "output": "11361"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findBestValue = function(arr, target) {\n};\n",
  "python": "class Solution:\n    def findBestValue(self, arr: list[int], target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findBestValue(std::vector<int>& arr, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findBestValue(int[] arr, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findBestValue",
  "params": [
    {
      "name": "arr",
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
          4,
          9,
          3
        ],
        10
      ],
      "expected": 3
    },
    {
      "args": [
        [
          2,
          3,
          5
        ],
        10
      ],
      "expected": 5
    },
    {
      "args": [
        [
          60864,
          25176,
          27249,
          21296,
          20204
        ],
        56803
      ],
      "expected": 11361
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
        1,
        2,
        3
      ],
      100
    ],
    "expected": 3
  },
  {
    "args": [
      [
        10,
        10,
        10
      ],
      0
    ],
    "expected": 0
  },
  {
    "args": [
      [
        3,
        5,
        7
      ],
      12
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1814,
    '矩阵区域和',
    '给定 m x n 整数矩阵 mat 和整数 k
返回同样大小的矩阵 answer
answer[i][j] 等于 mat 中以 (i, j) 为中心、上下左右各扩展 k 行或 k 列的区域元素和
超出矩阵边界的部分不参与计算',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '矩阵'],
    $json$[
  {
    "input": "mat = [[1, 2, 3], [4, 5, 6], [7, 8, 9]], k = 1",
    "output": "[[12, 21, 16], [27, 45, 33], [24, 39, 28]]"
  },
  {
    "input": "mat = [[1, 2, 3], [4, 5, 6], [7, 8, 9]], k = 2",
    "output": "[[45, 45, 45], [45, 45, 45], [45, 45, 45]]"
  },
  {
    "input": "mat = [[1, 2, 3], [4, 5, 6], [7, 8, 9]], k = 0",
    "output": "[[1, 2, 3], [4, 5, 6], [7, 8, 9]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mat = [[1, 2, 3], [4, 5, 6], [7, 8, 9]], k = 1",
    "output": "[[12, 21, 16], [27, 45, 33], [24, 39, 28]]"
  },
  {
    "input": "mat = [[1, 2, 3], [4, 5, 6], [7, 8, 9]], k = 2",
    "output": "[[45, 45, 45], [45, 45, 45], [45, 45, 45]]"
  },
  {
    "input": "mat = [[1, 2, 3], [4, 5, 6], [7, 8, 9]], k = 0",
    "output": "[[1, 2, 3], [4, 5, 6], [7, 8, 9]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var matrixBlockSum = function(mat, k) {\n};\n",
  "python": "class Solution:\n    def matrixBlockSum(self, mat: list[list[int]], k: int) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> matrixBlockSum(std::vector<std::vector<int>>& mat, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] matrixBlockSum(int[][] mat, int k) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "matrixBlockSum",
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
        ],
        1
      ],
      "expected": [
        [
          12,
          21,
          16
        ],
        [
          27,
          45,
          33
        ],
        [
          24,
          39,
          28
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
        ],
        2
      ],
      "expected": [
        [
          45,
          45,
          45
        ],
        [
          45,
          45,
          45
        ],
        [
          45,
          45,
          45
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
        ],
        0
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
        ],
        [
          7,
          8,
          9
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
      0
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
          1
        ]
      ],
      5
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
      ],
      1
    ],
    "expected": [
      [
        10,
        10
      ],
      [
        10,
        10
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
      ],
      2
    ],
    "expected": [
      [
        20,
        20
      ],
      [
        20,
        20
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
      1
    ],
    "expected": [
      [
        3,
        6,
        9,
        7
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1815,
    '破坏回文串',
    '给定一个回文字符串 palindrome
必须把其中一个字符替换成另一个小写字母
返回替换后字典序最小的非回文字符串
若无法得到非回文字符串则返回空字符串',
    'medium',
    1000,
    256,
    ARRAY['字符串', '贪心'],
    $json$[
  {
    "input": "palindrome = \"abccba\"",
    "output": "\"aaccba\""
  },
  {
    "input": "palindrome = \"a\"",
    "output": "\"\""
  },
  {
    "input": "palindrome = \"aa\"",
    "output": "\"ab\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "palindrome = \"abccba\"",
    "output": "\"aaccba\""
  },
  {
    "input": "palindrome = \"a\"",
    "output": "\"\""
  },
  {
    "input": "palindrome = \"aa\"",
    "output": "\"ab\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var breakPalindrome = function(palindrome) {\n};\n",
  "python": "class Solution:\n    def breakPalindrome(self, palindrome: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string breakPalindrome(std::string palindrome) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String breakPalindrome(String palindrome) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "breakPalindrome",
  "params": [
    {
      "name": "palindrome",
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
        "abccba"
      ],
      "expected": "aaccba"
    },
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
      "expected": "ab"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "aba"
    ],
    "expected": "abb"
  },
  {
    "args": [
      "abba"
    ],
    "expected": "aaba"
  },
  {
    "args": [
      "aabaa"
    ],
    "expected": "aabab"
  },
  {
    "args": [
      "abcba"
    ],
    "expected": "aacba"
  },
  {
    "args": [
      "aaa"
    ],
    "expected": "aab"
  }
]$json$::jsonb,
    'approved'
),
(
    1816,
    '满足条件的子序列数目',
    '给定整数数组 nums 和目标值 target
统计满足最小值与最大值之和不超过 target 的非空子序列数量
子序列按原数组下标选取，不同下标集合算作不同子序列
结果对 10^9 + 7 取模',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '双指针', '二分查找'],
    $json$[
  {
    "input": "nums = [3, 5, 6, 7], target = 9",
    "output": "4"
  },
  {
    "input": "nums = [3, 3, 6, 8], target = 10",
    "output": "6"
  },
  {
    "input": "nums = [2, 3, 3, 4, 6, 7], target = 12",
    "output": "61"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 5, 6, 7], target = 9",
    "output": "4"
  },
  {
    "input": "nums = [3, 3, 6, 8], target = 10",
    "output": "6"
  },
  {
    "input": "nums = [2, 3, 3, 4, 6, 7], target = 12",
    "output": "61"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numSubseq = function(nums, target) {\n};\n",
  "python": "class Solution:\n    def numSubseq(self, nums: list[int], target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numSubseq(std::vector<int>& nums, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numSubseq(int[] nums, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numSubseq",
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
          3,
          5,
          6,
          7
        ],
        9
      ],
      "expected": 4
    },
    {
      "args": [
        [
          3,
          3,
          6,
          8
        ],
        10
      ],
      "expected": 6
    },
    {
      "args": [
        [
          2,
          3,
          3,
          4,
          6,
          7
        ],
        12
      ],
      "expected": 61
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
        1
      ],
      0
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
      4
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
      5
    ],
    "expected": 10
  },
  {
    "args": [
      [
        4,
        3,
        2,
        1
      ],
      4
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1817,
    '层数最深叶子节点的和',
    '给定一棵二叉树的根节点 root
返回所有最深叶子节点的值之和
叶子节点是没有子节点的节点
最深叶子节点是深度最大的叶子节点',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '广度优先搜索'],
    $json$[
  {
    "input": "root = [1, 2, 3, 4, 5, null, 6, 7, null, null, null, null, 8]",
    "output": "15"
  },
  {
    "input": "root = [6, 7, 8, 2, 7, 1, 3, 9, null, 1, 4, null, null, null, 5]",
    "output": "19"
  },
  {
    "input": "root = [1]",
    "output": "1"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3, 4, 5, null, 6, 7, null, null, null, null, 8]",
    "output": "15"
  },
  {
    "input": "root = [6, 7, 8, 2, 7, 1, 3, 9, null, 1, 4, null, null, null, 5]",
    "output": "19"
  },
  {
    "input": "root = [1]",
    "output": "1"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar deepestLeavesSum = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def deepestLeavesSum(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int deepestLeavesSum(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int deepestLeavesSum(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "deepestLeavesSum",
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
          5,
          null,
          6,
          7,
          null,
          null,
          null,
          null,
          8
        ]
      ],
      "expected": 15
    },
    {
      "args": [
        [
          6,
          7,
          8,
          2,
          7,
          1,
          3,
          9,
          null,
          1,
          4,
          null,
          null,
          null,
          5
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
      "expected": 5
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
        5,
        3,
        8,
        1,
        4,
        7,
        9
      ]
    ],
    "expected": 21
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
  }
]$json$::jsonb,
    'approved'
),
(
    1818,
    '两棵二叉搜索树中的所有元素',
    '给定两棵二叉搜索树的根节点 root1 和 root2
返回一个升序数组，包含两棵树中的所有整数
结果按升序排列
树中可能没有节点，此时用空列表表示',
    'medium',
    1000,
    256,
    ARRAY['树', '二叉搜索树', '归并排序'],
    $json$[
  {
    "input": "root1 = [2, 1, 4], root2 = [1, 0, 3]",
    "output": "[0, 1, 1, 2, 3, 4]"
  },
  {
    "input": "root1 = [1, null, 8], root2 = [8, 1]",
    "output": "[1, 1, 8, 8]"
  },
  {
    "input": "root1 = [], root2 = []",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root1 = [2, 1, 4], root2 = [1, 0, 3]",
    "output": "[0, 1, 1, 2, 3, 4]"
  },
  {
    "input": "root1 = [1, null, 8], root2 = [8, 1]",
    "output": "[1, 1, 8, 8]"
  },
  {
    "input": "root1 = [], root2 = []",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar getAllElements = function(root1, root2) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def getAllElements(self, root1: TreeNode | None, root2: TreeNode | None) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::vector<int> getAllElements(TreeNode* root1, TreeNode* root2) {\n        return {};\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int[] getAllElements(TreeNode root1, TreeNode root2) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getAllElements",
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
  "return_type": "int[]",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          2,
          1,
          4
        ],
        [
          1,
          0,
          3
        ]
      ],
      "expected": [
        0,
        1,
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
          null,
          8
        ],
        [
          8,
          1
        ]
      ],
      "expected": [
        1,
        1,
        8,
        8
      ]
    },
    {
      "args": [
        [],
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
      ],
      [
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
        5,
        3,
        7
      ],
      [
        2,
        4,
        6
      ]
    ],
    "expected": [
      3,
      4,
      2,
      5,
      6,
      7
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
        2,
        null,
        3
      ],
      [
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
        10,
        5,
        15
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
      3,
      5,
      10,
      15
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1819,
    '祖父节点值为偶数的节点和',
    '给定一棵二叉树的根节点 root
返回所有祖父节点值为偶数的节点值之和
节点 x 的祖父节点是 x 的父节点的父节点
若节点没有祖父节点则不计入',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [6, 7, 8, 2, 7, 1, 3, 9, null, 1, 4, null, null, null, 5]",
    "output": "18"
  },
  {
    "input": "root = [1]",
    "output": "0"
  },
  {
    "input": "root = [2, 1, 3]",
    "output": "0"
  },
  {
    "input": "root = [2, null, 4, 6, null, 8]",
    "output": "14"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [6, 7, 8, 2, 7, 1, 3, 9, null, 1, 4, null, null, null, 5]",
    "output": "18"
  },
  {
    "input": "root = [1]",
    "output": "0"
  },
  {
    "input": "root = [2, 1, 3]",
    "output": "0"
  },
  {
    "input": "root = [2, null, 4, 6, null, 8]",
    "output": "14"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar sumEvenGrandparent = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def sumEvenGrandparent(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int sumEvenGrandparent(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int sumEvenGrandparent(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumEvenGrandparent",
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
          6,
          7,
          8,
          2,
          7,
          1,
          3,
          9,
          null,
          1,
          4,
          null,
          null,
          null,
          5
        ]
      ],
      "expected": 18
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
          1,
          3
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          2,
          null,
          4,
          6,
          null,
          8
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
        4,
        1,
        2
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        4,
        2,
        null
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        8,
        4,
        10,
        2,
        6,
        9,
        11
      ]
    ],
    "expected": 28
  },
  {
    "args": [
      [
        2,
        6,
        8,
        4,
        null,
        null,
        10
      ]
    ],
    "expected": 14
  },
  {
    "args": [
      [
        2,
        4,
        6,
        8,
        10,
        12,
        14
      ]
    ],
    "expected": 44
  }
]$json$::jsonb,
    'approved'
),
(
    1820,
    '删除给定值的叶子节点',
    '给定一棵二叉树的根节点 root 和一个整数 target
反复删除所有值为 target 的叶子节点
删除后其父节点可能变成新的叶子节点，也应继续删除
返回最终二叉树的层序表示，若为空树则返回空列表',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [1, 2, 3, 2, null, 2, 4], target = 2",
    "output": "[1, null, 3, null, 4]"
  },
  {
    "input": "root = [1, 3, 3, 3, 2], target = 3",
    "output": "[1, 3, null, null, 2]"
  },
  {
    "input": "root = [1, 2, null, 2, null, 2], target = 2",
    "output": "[1]"
  },
  {
    "input": "root = [1, 1, 1], target = 1",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3, 2, null, 2, 4], target = 2",
    "output": "[1, null, 3, null, 4]"
  },
  {
    "input": "root = [1, 3, 3, 3, 2], target = 3",
    "output": "[1, 3, null, null, 2]"
  },
  {
    "input": "root = [1, 2, null, 2, null, 2], target = 2",
    "output": "[1]"
  },
  {
    "input": "root = [1, 1, 1], target = 1",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar removeLeafNodes = function(root, target) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def removeLeafNodes(self, root: TreeNode | None, target: int) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* removeLeafNodes(TreeNode* root, int target) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode removeLeafNodes(TreeNode root, int target) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeLeafNodes",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    },
    {
      "name": "target",
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
          1,
          2,
          3,
          2,
          null,
          2,
          4
        ],
        2
      ],
      "expected": [
        1,
        null,
        3,
        null,
        4
      ]
    },
    {
      "args": [
        [
          1,
          3,
          3,
          3,
          2
        ],
        3
      ],
      "expected": [
        1,
        3,
        null,
        null,
        2
      ]
    },
    {
      "args": [
        [
          1,
          2,
          null,
          2,
          null,
          2
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
          1,
          1,
          1
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
        2,
        2,
        2
      ],
      2
    ],
    "expected": []
  },
  {
    "args": [
      [
        1,
        null,
        2,
        null,
        3
      ],
      3
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
        2,
        2,
        null,
        null,
        2,
        2
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
        4,
        2,
        3,
        null,
        2
      ],
      2
    ],
    "expected": [
      4,
      null,
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1821,
    '分裂二叉树的最大乘积',
    '给定一棵二叉树的根节点 root
删除一条边，将树分成两棵非空子树
两棵子树节点和之积为本次分裂的得分
返回所有分裂方式中的最大得分，结果对 1e9+7 取余
树至少有两个节点',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [1, 2, 3, 4, 5, 6]",
    "output": "110"
  },
  {
    "input": "root = [1, null, 2, 3, 4, null, null, 5, 6]",
    "output": "90"
  },
  {
    "input": "root = [1, 2]",
    "output": "2"
  },
  {
    "input": "root = [2, 3, 9, 10, 7, 8, 6, 5, 4, 11, 1]",
    "output": "1025"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3, 4, 5, 6]",
    "output": "110"
  },
  {
    "input": "root = [1, null, 2, 3, 4, null, null, 5, 6]",
    "output": "90"
  },
  {
    "input": "root = [1, 2]",
    "output": "2"
  },
  {
    "input": "root = [2, 3, 9, 10, 7, 8, 6, 5, 4, 11, 1]",
    "output": "1025"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar maxProduct = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def maxProduct(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int maxProduct(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int maxProduct(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxProduct",
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
          5,
          6
        ]
      ],
      "expected": 110
    },
    {
      "args": [
        [
          1,
          null,
          2,
          3,
          4,
          null,
          null,
          5,
          6
        ]
      ],
      "expected": 90
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
          3,
          9,
          10,
          7,
          8,
          6,
          5,
          4,
          11,
          1
        ]
      ],
      "expected": 1025
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
    "expected": 9
  },
  {
    "args": [
      [
        10,
        5,
        15
      ]
    ],
    "expected": 225
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
        null
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        3,
        7,
        5,
        1,
        9,
        2
      ]
    ],
    "expected": 170
  }
]$json$::jsonb,
    'approved'
),
(
    1822,
    '将二叉搜索树变平衡',
    '给定一棵二叉搜索树的根节点 root
将其转换为平衡二叉搜索树并返回新树的层序表示
平衡指每个节点左右子树高度差不超过 1
新树的中序遍历必须与原树相同
若存在多种结果，按每次取有序数组中间位置作为根的方式构造',
    'medium',
    1000,
    256,
    ARRAY['树', '二叉搜索树', '分治'],
    $json$[
  {
    "input": "root = [1, null, 2, null, 3, null, 4]",
    "output": "[2, 1, 3, null, null, null, 4]"
  },
  {
    "input": "root = [2, 1, 3]",
    "output": "[2, 1, 3]"
  },
  {
    "input": "root = [1]",
    "output": "[1]"
  },
  {
    "input": "root = [1, null, 2]",
    "output": "[1, null, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, null, 2, null, 3, null, 4]",
    "output": "[2, 1, 3, null, null, null, 4]"
  },
  {
    "input": "root = [2, 1, 3]",
    "output": "[2, 1, 3]"
  },
  {
    "input": "root = [1]",
    "output": "[1]"
  },
  {
    "input": "root = [1, null, 2]",
    "output": "[1, null, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar balanceBST = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def balanceBST(self, root: TreeNode | None) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* balanceBST(TreeNode* root) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode balanceBST(TreeNode root) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "balanceBST",
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
          2,
          null,
          3,
          null,
          4
        ]
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
          null,
          2
        ]
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
        1,
        2,
        3,
        4
      ]
    ],
    "expected": [
      2,
      4,
      1,
      null,
      null,
      null,
      3
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
        null,
        7
      ]
    ],
    "expected": [
      5,
      3,
      6,
      null,
      4,
      null,
      7
    ]
  },
  {
    "args": [
      [
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
    ],
    "expected": [
      3,
      1,
      4,
      null,
      2,
      null,
      5
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
        2,
        1,
        3,
        null,
        null,
        null,
        4
      ]
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
  }
]$json$::jsonb,
    'approved'
),
(
    1823,
    '二叉树中的伪回文路径',
    '给定一棵二叉树的根节点 root，节点值在 1 到 9 之间
一条根到叶子的路径中，若节点值的多重集合可以重新排列成回文，则称为伪回文路径
返回伪回文路径的数量',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '位运算'],
    $json$[
  {
    "input": "root = [2, 3, 1, 3, 1, null, 1]",
    "output": "2"
  },
  {
    "input": "root = [2, 1, 1, 1, 3, null, null, null, null, null, 1]",
    "output": "1"
  },
  {
    "input": "root = [9]",
    "output": "1"
  },
  {
    "input": "root = [1, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [2, 3, 1, 3, 1, null, 1]",
    "output": "2"
  },
  {
    "input": "root = [2, 1, 1, 1, 3, null, null, null, null, null, 1]",
    "output": "1"
  },
  {
    "input": "root = [9]",
    "output": "1"
  },
  {
    "input": "root = [1, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar pseudoPalindromicPaths = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def pseudoPalindromicPaths(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int pseudoPalindromicPaths(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int pseudoPalindromicPaths(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "pseudoPalindromicPaths",
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
          2,
          3,
          1,
          3,
          1,
          null,
          1
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          2,
          1,
          1,
          1,
          3,
          null,
          null,
          null,
          null,
          null,
          1
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
    "expected": 2
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
    "expected": 2
  },
  {
    "args": [
      [
        1,
        2,
        null,
        1,
        null,
        2
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1824,
    '好叶子节点对的数量',
    '给定一棵二叉树的根节点 root 和一个整数 distance
两个叶子节点称为好叶子节点对，当且仅当它们之间的最短路径长度不超过 distance
返回好叶子节点对的数量
叶子节点是没有子节点的节点',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [1, 2, 3, null, 4], distance = 3",
    "output": "1"
  },
  {
    "input": "root = [1, 2, 3, 4, 5, 6, 7], distance = 3",
    "output": "2"
  },
  {
    "input": "root = [7, 1, 4, 6, null, 5, 3, null, null, null, null, null, 2], distance = 3",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 2, 3, null, 4], distance = 3",
    "output": "1"
  },
  {
    "input": "root = [1, 2, 3, 4, 5, 6, 7], distance = 3",
    "output": "2"
  },
  {
    "input": "root = [7, 1, 4, 6, null, 5, 3, null, null, null, null, null, 2], distance = 3",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar countPairs = function(root, distance) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def countPairs(self, root: TreeNode | None, distance: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int countPairs(TreeNode* root, int distance) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int countPairs(TreeNode root, int distance) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countPairs",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    },
    {
      "name": "distance",
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
          null,
          4
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
          3,
          4,
          5,
          6,
          7
        ],
        3
      ],
      "expected": 2
    },
    {
      "args": [
        [
          7,
          1,
          4,
          6,
          null,
          5,
          3,
          null,
          null,
          null,
          null,
          null,
          2
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
        1,
        2,
        3,
        4,
        5,
        6,
        7
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
      3
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
        null,
        null,
        5
      ],
      4
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1825,
    '奇偶树',
    '给定一棵二叉树的根节点 root
若满足以下条件则称为奇偶树
根节点所在层为第 0 层，偶数层所有节点值为奇数且从左到右严格递增
奇数层所有节点值为偶数且从左到右严格递减
判断这棵树是否为奇偶树',
    'medium',
    1000,
    256,
    ARRAY['树', '广度优先搜索'],
    $json$[
  {
    "input": "root = [1, 10, 4, 3, null, 7, 9, 12, 8, 6, null, null, 2]",
    "output": "true"
  },
  {
    "input": "root = [5, 4, 2, 3, 3, 7]",
    "output": "false"
  },
  {
    "input": "root = [5, 9, 1, 3, 5, 7]",
    "output": "false"
  },
  {
    "input": "root = [1]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 10, 4, 3, null, 7, 9, 12, 8, 6, null, null, 2]",
    "output": "true"
  },
  {
    "input": "root = [5, 4, 2, 3, 3, 7]",
    "output": "false"
  },
  {
    "input": "root = [5, 9, 1, 3, 5, 7]",
    "output": "false"
  },
  {
    "input": "root = [1]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar isEvenOddTree = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def isEvenOddTree(self, root: TreeNode | None) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool isEvenOddTree(TreeNode* root) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean isEvenOddTree(TreeNode root) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isEvenOddTree",
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
          10,
          4,
          3,
          null,
          7,
          9,
          12,
          8,
          6,
          null,
          null,
          2
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          5,
          4,
          2,
          3,
          3,
          7
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          5,
          9,
          1,
          3,
          5,
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
        4,
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
        2,
        3
      ]
    ],
    "expected": false
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
        10,
        4,
        3,
        null,
        7,
        9
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        8,
        6,
        2,
        4,
        10,
        12
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1826,
    '阈值距离内邻居最少的城市',
    '有 n 个城市，编号 0 到 n-1
edges 中每条边 [u, v, w] 表示城市 u 与 v 之间有一条距离为 w 的双向边
给定距离阈值 distanceThreshold
统计每个城市在距离不超过阈值时能到达的其他城市数量
返回邻居数量最少的城市，若有多个并列则返回编号最大的城市',
    'medium',
    1000,
    256,
    ARRAY['图', '最短路'],
    $json$[
  {
    "input": "n = 4, edges = [[0, 1, 3], [1, 2, 1], [1, 3, 4], [2, 3, 1]], distanceThreshold = 4",
    "output": "3"
  },
  {
    "input": "n = 5, edges = [[0, 1, 2], [0, 4, 8], [1, 2, 3], [1, 4, 2], [2, 3, 1], [3, 4, 1]], distanceThreshold = 2",
    "output": "0"
  },
  {
    "input": "n = 2, edges = [[0, 1, 1]], distanceThreshold = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4, edges = [[0, 1, 3], [1, 2, 1], [1, 3, 4], [2, 3, 1]], distanceThreshold = 4",
    "output": "3"
  },
  {
    "input": "n = 5, edges = [[0, 1, 2], [0, 4, 8], [1, 2, 3], [1, 4, 2], [2, 3, 1], [3, 4, 1]], distanceThreshold = 2",
    "output": "0"
  },
  {
    "input": "n = 2, edges = [[0, 1, 1]], distanceThreshold = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findTheCity = function(n, edges, distanceThreshold) {\n};\n",
  "python": "class Solution:\n    def findTheCity(self, n: int, edges: list[list[int]], distanceThreshold: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findTheCity(int n, std::vector<std::vector<int>>& edges, int distanceThreshold) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findTheCity(int n, int[][] edges, int distanceThreshold) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findTheCity",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "edges",
      "type": "int[][]"
    },
    {
      "name": "distanceThreshold",
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
        4,
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
          ],
          [
            1,
            3,
            4
          ],
          [
            2,
            3,
            1
          ]
        ],
        4
      ],
      "expected": 3
    },
    {
      "args": [
        5,
        [
          [
            0,
            1,
            2
          ],
          [
            0,
            4,
            8
          ],
          [
            1,
            2,
            3
          ],
          [
            1,
            4,
            2
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
      "expected": 0
    },
    {
      "args": [
        2,
        [
          [
            0,
            1,
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
      3,
      [],
      1
    ],
    "expected": 2
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
      1
    ],
    "expected": 2
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
      2
    ],
    "expected": 3
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
      3
    ],
    "expected": 3
  },
  {
    "args": [
      1,
      [],
      0
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1827,
    '课程表 IV',
    '有 numCourses 门课程，编号 0 到 numCourses-1
prerequisites 中每项 [a, b] 表示课程 a 是课程 b 的直接先修课
queries 中每项 [u, v] 询问课程 u 是否为课程 v 的先修课，直接或间接均可
返回与 queries 等长的数组，第 i 个元素为 1 表示成立，为 0 表示不成立，顺序与查询一致',
    'medium',
    1000,
    256,
    ARRAY['图', '传递闭包'],
    $json$[
  {
    "input": "numCourses = 2, prerequisites = [[1, 0]], queries = [[0, 1], [1, 0]]",
    "output": "[0, 1]"
  },
  {
    "input": "numCourses = 3, prerequisites = [[1, 2], [1, 0], [2, 0]], queries = [[1, 0], [1, 2]]",
    "output": "[1, 1]"
  },
  {
    "input": "numCourses = 2, prerequisites = [], queries = [[0, 1]]",
    "output": "[0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "numCourses = 2, prerequisites = [[1, 0]], queries = [[0, 1], [1, 0]]",
    "output": "[0, 1]"
  },
  {
    "input": "numCourses = 3, prerequisites = [[1, 2], [1, 0], [2, 0]], queries = [[1, 0], [1, 2]]",
    "output": "[1, 1]"
  },
  {
    "input": "numCourses = 2, prerequisites = [], queries = [[0, 1]]",
    "output": "[0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var checkIfPrerequisite = function(numCourses, prerequisites, queries) {\n};\n",
  "python": "class Solution:\n    def checkIfPrerequisite(self, numCourses: int, prerequisites: list[list[int]], queries: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> checkIfPrerequisite(int numCourses, std::vector<std::vector<int>>& prerequisites, std::vector<std::vector<int>>& queries) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] checkIfPrerequisite(int numCourses, int[][] prerequisites, int[][] queries) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkIfPrerequisite",
  "params": [
    {
      "name": "numCourses",
      "type": "int"
    },
    {
      "name": "prerequisites",
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
        2,
        [
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
      "expected": [
        0,
        1
      ]
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
            1,
            0
          ],
          [
            2,
            0
          ]
        ],
        [
          [
            1,
            0
          ],
          [
            1,
            2
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
        2,
        [],
        [
          [
            0,
            1
          ]
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
          3
        ]
      ],
      [
        [
          0,
          3
        ],
        [
          3,
          0
        ],
        [
          0,
          2
        ]
      ]
    ],
    "expected": [
      1,
      0,
      1
    ]
  },
  {
    "args": [
      3,
      [],
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
    "expected": [
      0,
      0,
      0
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
          2,
          3
        ]
      ],
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
          3,
          2
        ]
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
      4,
      [
        [
          3,
          0
        ],
        [
          0,
          2
        ],
        [
          2,
          1
        ]
      ],
      [
        [
          3,
          1
        ],
        [
          1,
          3
        ],
        [
          3,
          2
        ]
      ]
    ],
    "expected": [
      1,
      0,
      1
    ]
  },
  {
    "args": [
      1,
      [],
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
    1828,
    '到达目的地的方案数',
    '有 n 个城市，编号 0 到 n-1
roads 中每条边 [u, v, w] 表示城市 u 与 v 之间有一条耗时为 w 的双向道路
从城市 0 出发前往城市 n-1，只沿最短路径移动
返回不同最短路径的数量，结果对 1e9+7 取余',
    'medium',
    1000,
    256,
    ARRAY['图', '最短路', '动态规划'],
    $json$[
  {
    "input": "n = 7, roads = [[0, 6, 7], [0, 1, 2], [1, 2, 3], [2, 3, 3], [5, 6, 2], [0, 4, 3], [4, 5, 1], [3, 4, 1]]",
    "output": "1"
  },
  {
    "input": "n = 2, roads = [[1, 0, 1]]",
    "output": "1"
  },
  {
    "input": "n = 3, roads = [[0, 1, 1], [1, 2, 1], [0, 2, 2]]",
    "output": "2"
  },
  {
    "input": "n = 4, roads = [[0, 1, 1], [0, 2, 1], [1, 3, 1], [2, 3, 1]]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 7, roads = [[0, 6, 7], [0, 1, 2], [1, 2, 3], [2, 3, 3], [5, 6, 2], [0, 4, 3], [4, 5, 1], [3, 4, 1]]",
    "output": "1"
  },
  {
    "input": "n = 2, roads = [[1, 0, 1]]",
    "output": "1"
  },
  {
    "input": "n = 3, roads = [[0, 1, 1], [1, 2, 1], [0, 2, 2]]",
    "output": "2"
  },
  {
    "input": "n = 4, roads = [[0, 1, 1], [0, 2, 1], [1, 3, 1], [2, 3, 1]]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countPaths = function(n, roads) {\n};\n",
  "python": "class Solution:\n    def countPaths(self, n: int, roads: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countPaths(int n, std::vector<std::vector<int>>& roads) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countPaths(int n, int[][] roads) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countPaths",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "roads",
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
        7,
        [
          [
            0,
            6,
            7
          ],
          [
            0,
            1,
            2
          ],
          [
            1,
            2,
            3
          ],
          [
            2,
            3,
            3
          ],
          [
            5,
            6,
            2
          ],
          [
            0,
            4,
            3
          ],
          [
            4,
            5,
            1
          ],
          [
            3,
            4,
            1
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
          ],
          [
            0,
            2,
            2
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
            0,
            1,
            1
          ],
          [
            0,
            2,
            1
          ],
          [
            1,
            3,
            1
          ],
          [
            2,
            3,
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
      1,
      []
    ],
    "expected": 1
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
      ]
    ],
    "expected": 1
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
          0,
          3,
          5
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      3,
      [
        [
          0,
          2,
          2
        ],
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
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      5,
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
          3,
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
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1829,
    '可以到达所有点的最少点数目',
    '给定一个有 n 个节点的有向无环图，节点编号 0 到 n-1
edges 中每项 [from, to] 表示一条从 from 指向 to 的有向边
选择最少的起点集合，使得从这些点出发可以到达图中所有节点
返回该集合中的节点编号，按升序排列',
    'medium',
    1000,
    256,
    ARRAY['图', '入度'],
    $json$[
  {
    "input": "n = 6, edges = [[0, 1], [0, 2], [2, 5], [3, 4], [4, 2]]",
    "output": "[0, 3]"
  },
  {
    "input": "n = 5, edges = [[0, 1], [2, 1], [3, 1], [1, 4], [2, 4]]",
    "output": "[0, 2, 3]"
  },
  {
    "input": "n = 1, edges = []",
    "output": "[0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 6, edges = [[0, 1], [0, 2], [2, 5], [3, 4], [4, 2]]",
    "output": "[0, 3]"
  },
  {
    "input": "n = 5, edges = [[0, 1], [2, 1], [3, 1], [1, 4], [2, 4]]",
    "output": "[0, 2, 3]"
  },
  {
    "input": "n = 1, edges = []",
    "output": "[0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findSmallestSetOfVertices = function(n, edges) {\n};\n",
  "python": "class Solution:\n    def findSmallestSetOfVertices(self, n: int, edges: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findSmallestSetOfVertices(int n, std::vector<std::vector<int>>& edges) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findSmallestSetOfVertices(int n, int[][] edges) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findSmallestSetOfVertices",
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
            5
          ],
          [
            3,
            4
          ],
          [
            4,
            2
          ]
        ]
      ],
      "expected": [
        0,
        3
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
            2,
            1
          ],
          [
            3,
            1
          ],
          [
            1,
            4
          ],
          [
            2,
            4
          ]
        ]
      ],
      "expected": [
        0,
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
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      3,
      []
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
      ]
    ],
    "expected": [
      0
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
          1,
          2
        ],
        [
          2,
          0
        ],
        [
          2,
          3
        ]
      ]
    ],
    "expected": []
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
          0,
          2
        ],
        [
          0,
          3
        ],
        [
          0,
          4
        ]
      ]
    ],
    "expected": [
      0
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
          0
        ]
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
    1830,
    '最大网络秩',
    '有 n 个城市，编号 0 到 n-1
roads 中每项 [u, v] 表示城市 u 与 v 之间有一条双向道路，道路互不相同
两个不同城市的网络秩定义为与这两个城市直接相连的道路总数
若这两个城市之间有一条道路，该道路只计算一次
返回任意两个不同城市网络秩的最大值',
    'medium',
    1000,
    256,
    ARRAY['图'],
    $json$[
  {
    "input": "n = 4, roads = [[0, 1], [0, 3], [1, 2], [1, 3]]",
    "output": "4"
  },
  {
    "input": "n = 5, roads = [[0, 1], [0, 3], [1, 2], [1, 3], [2, 3], [2, 4]]",
    "output": "5"
  },
  {
    "input": "n = 2, roads = [[0, 1]]",
    "output": "1"
  },
  {
    "input": "n = 3, roads = []",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4, roads = [[0, 1], [0, 3], [1, 2], [1, 3]]",
    "output": "4"
  },
  {
    "input": "n = 5, roads = [[0, 1], [0, 3], [1, 2], [1, 3], [2, 3], [2, 4]]",
    "output": "5"
  },
  {
    "input": "n = 2, roads = [[0, 1]]",
    "output": "1"
  },
  {
    "input": "n = 3, roads = []",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximalNetworkRank = function(n, roads) {\n};\n",
  "python": "class Solution:\n    def maximalNetworkRank(self, n: int, roads: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximalNetworkRank(int n, std::vector<std::vector<int>>& roads) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximalNetworkRank(int n, int[][] roads) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximalNetworkRank",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "roads",
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
            0,
            1
          ],
          [
            0,
            3
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
      "expected": 4
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
            0,
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
            2,
            4
          ]
        ]
      ],
      "expected": 5
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
      "expected": 1
    },
    {
      "args": [
        3,
        []
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2,
      []
    ],
    "expected": 0
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
    "expected": 2
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
    "expected": 3
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
        ],
        [
          4,
          0
        ]
      ]
    ],
    "expected": 4
  },
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
          1,
          2
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
    1831,
    '寻找图中是否存在路径',
    '有一个 n 个节点的双向图，节点编号 0 到 n-1
edges 中每项 [u, v] 表示节点 u 与 v 之间有一条边
给定起点 source 和终点 destination
判断是否存在从 source 到 destination 的路径',
    'medium',
    1000,
    256,
    ARRAY['图', '并查集', '广度优先搜索'],
    $json$[
  {
    "input": "n = 3, edges = [[0, 1], [1, 2], [2, 0]], source = 0, destination = 2",
    "output": "true"
  },
  {
    "input": "n = 6, edges = [[0, 1], [0, 2], [3, 5], [5, 4], [4, 3]], source = 0, destination = 5",
    "output": "false"
  },
  {
    "input": "n = 1, edges = [], source = 0, destination = 0",
    "output": "true"
  },
  {
    "input": "n = 4, edges = [[0, 1], [2, 3]], source = 1, destination = 3",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, edges = [[0, 1], [1, 2], [2, 0]], source = 0, destination = 2",
    "output": "true"
  },
  {
    "input": "n = 6, edges = [[0, 1], [0, 2], [3, 5], [5, 4], [4, 3]], source = 0, destination = 5",
    "output": "false"
  },
  {
    "input": "n = 1, edges = [], source = 0, destination = 0",
    "output": "true"
  },
  {
    "input": "n = 4, edges = [[0, 1], [2, 3]], source = 1, destination = 3",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var validPath = function(n, edges, source, destination) {\n};\n",
  "python": "class Solution:\n    def validPath(self, n: int, edges: list[list[int]], source: int, destination: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool validPath(int n, std::vector<std::vector<int>>& edges, int source, int destination) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean validPath(int n, int[][] edges, int source, int destination) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "validPath",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "edges",
      "type": "int[][]"
    },
    {
      "name": "source",
      "type": "int"
    },
    {
      "name": "destination",
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
          ]
        ],
        0,
        2
      ],
      "expected": true
    },
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
            3,
            5
          ],
          [
            5,
            4
          ],
          [
            4,
            3
          ]
        ],
        0,
        5
      ],
      "expected": false
    },
    {
      "args": [
        1,
        [],
        0,
        0
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
            2,
            3
          ]
        ],
        1,
        3
      ],
      "expected": false
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
    "expected": false
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
          3,
          4
        ]
      ],
      2,
      4
    ],
    "expected": false
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
          3,
          4
        ],
        [
          2,
          3
        ]
      ],
      0,
      4
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
          2,
          3
        ],
        [
          1,
          2
        ]
      ],
      0,
      3
    ],
    "expected": true
  },
  {
    "args": [
      3,
      [
        [
          1,
          2
        ]
      ],
      0,
      0
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1832,
    '迷宫中离入口最近的出口',
    '给定一个 m x n 的迷宫 maze，字符 . 表示空地，+ 表示墙
入口位置为 entrance
每一步可以移动到上下左右相邻的空地
出口是位于迷宫边界上的空地，但入口本身不算出口
返回到达最近出口的最少步数，若无法到达任何出口则返回 -1',
    'medium',
    1000,
    256,
    ARRAY['图', '广度优先搜索', '矩阵'],
    $json$[
  {
    "input": "maze = [[\"+\", \"+\", \".\", \"+\"], [\".\", \".\", \".\", \"+\"], [\"+\", \"+\", \"+\", \".\"]], entrance = [1, 2]",
    "output": "1"
  },
  {
    "input": "maze = [[\"+\", \"+\", \"+\"], [\".\", \".\", \".\"], [\"+\", \"+\", \"+\"]], entrance = [1, 0]",
    "output": "2"
  },
  {
    "input": "maze = [[\".\", \"+\"]], entrance = [0, 0]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "maze = [[\"+\", \"+\", \".\", \"+\"], [\".\", \".\", \".\", \"+\"], [\"+\", \"+\", \"+\", \".\"]], entrance = [1, 2]",
    "output": "1"
  },
  {
    "input": "maze = [[\"+\", \"+\", \"+\"], [\".\", \".\", \".\"], [\"+\", \"+\", \"+\"]], entrance = [1, 0]",
    "output": "2"
  },
  {
    "input": "maze = [[\".\", \"+\"]], entrance = [0, 0]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var nearestExit = function(maze, entrance) {\n};\n",
  "python": "class Solution:\n    def nearestExit(self, maze: list[list[str]], entrance: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int nearestExit(std::vector<std::vector<std::string>>& maze, std::vector<int>& entrance) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int nearestExit(String[][] maze, int[] entrance) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "nearestExit",
  "params": [
    {
      "name": "maze",
      "type": "string[][]"
    },
    {
      "name": "entrance",
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
          [
            "+",
            "+",
            ".",
            "+"
          ],
          [
            ".",
            ".",
            ".",
            "+"
          ],
          [
            "+",
            "+",
            "+",
            "."
          ]
        ],
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
          [
            "+",
            "+",
            "+"
          ],
          [
            ".",
            ".",
            "."
          ],
          [
            "+",
            "+",
            "+"
          ]
        ],
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
          [
            ".",
            "+"
          ]
        ],
        [
          0,
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
        [
          "."
        ]
      ],
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
        [
          "+",
          ".",
          "+"
        ]
      ],
      [
        0,
        1
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        [
          "+",
          ".",
          "+"
        ],
        [
          ".",
          ".",
          "."
        ],
        [
          "+",
          ".",
          "+"
        ]
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
        [
          "+",
          "+",
          ".",
          "+"
        ],
        [
          ".",
          ".",
          ".",
          "+"
        ],
        [
          "+",
          "+",
          "+",
          "."
        ]
      ],
      [
        1,
        0
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        [
          "+",
          ".",
          "+",
          "+"
        ],
        [
          ".",
          ".",
          ".",
          "."
        ],
        [
          "+",
          "+",
          "+",
          "."
        ]
      ],
      [
        0,
        1
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1833,
    '跳跃游戏 VII',
    '给定一个下标从 0 开始的二进制字符串 s 和两个整数 minJump、maxJump
从下标 0 出发，当前在下标 i 时，可以跳到 [i+minJump, i+maxJump] 范围内任意满足 s[j] = 0 的下标 j
判断能否到达下标 n-1，其中 n 为字符串长度
注意 s[0] = 0',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '滑动窗口'],
    $json$[
  {
    "input": "s = \"011010\", minJump = 2, maxJump = 3",
    "output": "true"
  },
  {
    "input": "s = \"01101110\", minJump = 2, maxJump = 3",
    "output": "false"
  },
  {
    "input": "s = \"0\", minJump = 1, maxJump = 1",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"011010\", minJump = 2, maxJump = 3",
    "output": "true"
  },
  {
    "input": "s = \"01101110\", minJump = 2, maxJump = 3",
    "output": "false"
  },
  {
    "input": "s = \"0\", minJump = 1, maxJump = 1",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canReach = function(s, minJump, maxJump) {\n};\n",
  "python": "class Solution:\n    def canReach(self, s: str, minJump: int, maxJump: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canReach(std::string s, int minJump, int maxJump) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canReach(String s, int minJump, int maxJump) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canReach",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "minJump",
      "type": "int"
    },
    {
      "name": "maxJump",
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
        "011010",
        2,
        3
      ],
      "expected": true
    },
    {
      "args": [
        "01101110",
        2,
        3
      ],
      "expected": false
    },
    {
      "args": [
        "0",
        1,
        1
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "0000",
      1,
      1
    ],
    "expected": true
  },
  {
    "args": [
      "0",
      1,
      2
    ],
    "expected": true
  },
  {
    "args": [
      "01",
      1,
      1
    ],
    "expected": false
  },
  {
    "args": [
      "001",
      1,
      1
    ],
    "expected": false
  },
  {
    "args": [
      "0100",
      1,
      2
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1834,
    '统计子岛屿',
    '给定两个 m x n 的二进制矩阵 grid1 和 grid2
1 表示陆地，0 表示水域，四方向相邻的 1 组成岛屿
若 grid2 中的一座岛屿完全位于 grid1 的陆地之上，则称为子岛屿
返回 grid2 中子岛屿的数量',
    'medium',
    1000,
    256,
    ARRAY['图', '深度优先搜索', '矩阵'],
    $json$[
  {
    "input": "grid1 = [[1, 1, 1, 0, 0], [0, 1, 1, 1, 1], [0, 0, 0, 0, 0], [1, 0, 0, 0, 0], [1, 1, 0, 1, 1]], grid2 = [[1, 1, 1, 0, 0], [0, 0, 1, 1, 1], [0, 1, 0, 0, 0], [1, 0, 1, 1, 0], [0, 1, 0, 1, 0]]",
    "output": "3"
  },
  {
    "input": "grid1 = [[1, 0, 1, 0, 1], [1, 1, 1, 1, 1], [0, 0, 0, 0, 0], [1, 1, 1, 1, 1], [1, 0, 1, 0, 1]], grid2 = [[0, 0, 0, 0, 0], [1, 1, 1, 1, 1], [0, 1, 0, 1, 0], [0, 1, 0, 1, 0], [1, 0, 0, 0, 1]]",
    "output": "2"
  },
  {
    "input": "grid1 = [[1, 1], [1, 1]], grid2 = [[1, 1], [1, 0]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid1 = [[1, 1, 1, 0, 0], [0, 1, 1, 1, 1], [0, 0, 0, 0, 0], [1, 0, 0, 0, 0], [1, 1, 0, 1, 1]], grid2 = [[1, 1, 1, 0, 0], [0, 0, 1, 1, 1], [0, 1, 0, 0, 0], [1, 0, 1, 1, 0], [0, 1, 0, 1, 0]]",
    "output": "3"
  },
  {
    "input": "grid1 = [[1, 0, 1, 0, 1], [1, 1, 1, 1, 1], [0, 0, 0, 0, 0], [1, 1, 1, 1, 1], [1, 0, 1, 0, 1]], grid2 = [[0, 0, 0, 0, 0], [1, 1, 1, 1, 1], [0, 1, 0, 1, 0], [0, 1, 0, 1, 0], [1, 0, 0, 0, 1]]",
    "output": "2"
  },
  {
    "input": "grid1 = [[1, 1], [1, 1]], grid2 = [[1, 1], [1, 0]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countSubIslands = function(grid1, grid2) {\n};\n",
  "python": "class Solution:\n    def countSubIslands(self, grid1: list[list[int]], grid2: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countSubIslands(std::vector<std::vector<int>>& grid1, std::vector<std::vector<int>>& grid2) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countSubIslands(int[][] grid1, int[][] grid2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countSubIslands",
  "params": [
    {
      "name": "grid1",
      "type": "int[][]"
    },
    {
      "name": "grid2",
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
            0,
            0
          ],
          [
            0,
            1,
            1,
            1,
            1
          ],
          [
            0,
            0,
            0,
            0,
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
            1,
            1
          ]
        ],
        [
          [
            1,
            1,
            1,
            0,
            0
          ],
          [
            0,
            0,
            1,
            1,
            1
          ],
          [
            0,
            1,
            0,
            0,
            0
          ],
          [
            1,
            0,
            1,
            1,
            0
          ],
          [
            0,
            1,
            0,
            1,
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
            1,
            0,
            1,
            0,
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
            0,
            0,
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
          ],
          [
            1,
            0,
            1,
            0,
            1
          ]
        ],
        [
          [
            0,
            0,
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
          ],
          [
            0,
            1,
            0,
            1,
            0
          ],
          [
            0,
            1,
            0,
            1,
            0
          ],
          [
            1,
            0,
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
            1
          ],
          [
            1,
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
          1,
          0
        ],
        [
          0,
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
          1,
          0
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
      ],
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
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1835,
    '近义词句子',
    '给定近义词对数组 synonyms 和句子 text
synonyms 中每项 [a, b] 表示单词 a 与 b 互为近义词，近义词关系具有传递性
text 是由空格分隔的单词组成的句子
将句子中的每个单词替换为其所在近义词集合中的任意单词，得到所有可能句子
结果按字典序升序排列
不在任何近义词对中的单词保持不变',
    'medium',
    1000,
    256,
    ARRAY['并查集', '回溯', '字符串'],
    $json$[
  {
    "input": "synonyms = [[\"happy\", \"joy\"], [\"sad\", \"sorrow\"], [\"joy\", \"cheerful\"]], text = \"I am happy today but was sad yesterday\"",
    "output": "[\"I am cheerful today but was sad yesterday\", \"I am cheerful today but was sorrow yesterday\", \"I am happy today but was sad yesterday\", \"I am happy today but was sorrow yesterday\", \"I am joy today but was sad yesterday\", \"I am joy today but was sorrow yesterday\"]"
  },
  {
    "input": "synonyms = [[\"a\", \"b\"], [\"c\", \"d\"]], text = \"a c\"",
    "output": "[\"a c\", \"a d\", \"b c\", \"b d\"]"
  },
  {
    "input": "synonyms = [], text = \"hello world\"",
    "output": "[\"hello world\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "synonyms = [[\"happy\", \"joy\"], [\"sad\", \"sorrow\"], [\"joy\", \"cheerful\"]], text = \"I am happy today but was sad yesterday\"",
    "output": "[\"I am cheerful today but was sad yesterday\", \"I am cheerful today but was sorrow yesterday\", \"I am happy today but was sad yesterday\", \"I am happy today but was sorrow yesterday\", \"I am joy today but was sad yesterday\", \"I am joy today but was sorrow yesterday\"]"
  },
  {
    "input": "synonyms = [[\"a\", \"b\"], [\"c\", \"d\"]], text = \"a c\"",
    "output": "[\"a c\", \"a d\", \"b c\", \"b d\"]"
  },
  {
    "input": "synonyms = [], text = \"hello world\"",
    "output": "[\"hello world\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var generateSentences = function(synonyms, text) {\n};\n",
  "python": "class Solution:\n    def generateSentences(self, synonyms: list[list[str]], text: str) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> generateSentences(std::vector<std::vector<std::string>>& synonyms, std::string text) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] generateSentences(String[][] synonyms, String text) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "generateSentences",
  "params": [
    {
      "name": "synonyms",
      "type": "string[][]"
    },
    {
      "name": "text",
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
        [
          [
            "happy",
            "joy"
          ],
          [
            "sad",
            "sorrow"
          ],
          [
            "joy",
            "cheerful"
          ]
        ],
        "I am happy today but was sad yesterday"
      ],
      "expected": [
        "I am cheerful today but was sad yesterday",
        "I am cheerful today but was sorrow yesterday",
        "I am happy today but was sad yesterday",
        "I am happy today but was sorrow yesterday",
        "I am joy today but was sad yesterday",
        "I am joy today but was sorrow yesterday"
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
        "a c"
      ],
      "expected": [
        "a c",
        "a d",
        "b c",
        "b d"
      ]
    },
    {
      "args": [
        [],
        "hello world"
      ],
      "expected": [
        "hello world"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          "a",
          "b"
        ]
      ],
      "b"
    ],
    "expected": [
      "a",
      "b"
    ]
  },
  {
    "args": [
      [
        [
          "x",
          "y"
        ]
      ],
      "x y"
    ],
    "expected": [
      "x x",
      "x y",
      "y x",
      "y y"
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
          "b",
          "c"
        ]
      ],
      "a c"
    ],
    "expected": [
      "a a",
      "a b",
      "a c",
      "b a",
      "b b",
      "b c",
      "c a",
      "c b",
      "c c"
    ]
  },
  {
    "args": [
      [
        [
          "hello",
          "hi"
        ]
      ],
      "hello"
    ],
    "expected": [
      "hello",
      "hi"
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
      "a c a"
    ],
    "expected": [
      "a c a",
      "a c b",
      "a d a",
      "a d b",
      "b c a",
      "b c b",
      "b d a",
      "b d b"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1836,
    '连通网络的操作次数',
    '有 n 台计算机，编号 0 到 n-1
connections 中每项 [u, v] 表示计算机 u 与 v 之间有一条网线
可以拔下任意一条网线，再连接到任意两台尚未直接相连的计算机上
返回使所有计算机连通所需的最少操作次数，若无法做到则返回 -1',
    'medium',
    1000,
    256,
    ARRAY['图', '并查集'],
    $json$[
  {
    "input": "n = 4, connections = [[0, 1], [0, 2], [1, 2]]",
    "output": "1"
  },
  {
    "input": "n = 6, connections = [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3]]",
    "output": "2"
  },
  {
    "input": "n = 6, connections = [[0, 1], [0, 2], [0, 3], [1, 2]]",
    "output": "-1"
  },
  {
    "input": "n = 1, connections = []",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4, connections = [[0, 1], [0, 2], [1, 2]]",
    "output": "1"
  },
  {
    "input": "n = 6, connections = [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3]]",
    "output": "2"
  },
  {
    "input": "n = 6, connections = [[0, 1], [0, 2], [0, 3], [1, 2]]",
    "output": "-1"
  },
  {
    "input": "n = 1, connections = []",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var makeConnected = function(n, connections) {\n};\n",
  "python": "class Solution:\n    def makeConnected(self, n: int, connections: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int makeConnected(int n, std::vector<std::vector<int>>& connections) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int makeConnected(int n, int[][] connections) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "makeConnected",
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
            1,
            2
          ]
        ]
      ],
      "expected": 1
    },
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
            0,
            3
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
      "expected": 2
    },
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
            0,
            3
          ],
          [
            1,
            2
          ]
        ]
      ],
      "expected": -1
    },
    {
      "args": [
        1,
        []
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
          0,
          1
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
          0,
          1
        ]
      ]
    ],
    "expected": -1
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
    "expected": 0
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
          3,
          4
        ],
        [
          4,
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
          3
        ],
        [
          1,
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
    1837,
    '查找大小为 M 的最新分组',
    '给定一个由 1 到 n 的整数组成的排列 arr 和一个整数 m
第 i 步（i 从 1 开始）将 arr[i-1] 对应的位置标记为 1，其余位置为 0
求最后一次出现长度为 m 的连续 1 分组时的步数
若从未出现则返回 -1',
    'medium',
    1000,
    256,
    ARRAY['数组', '并查集'],
    $json$[
  {
    "input": "arr = [3, 5, 1, 2, 4], m = 1",
    "output": "4"
  },
  {
    "input": "arr = [3, 1, 5, 4, 2], m = 2",
    "output": "-1"
  },
  {
    "input": "arr = [1], m = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [3, 5, 1, 2, 4], m = 1",
    "output": "4"
  },
  {
    "input": "arr = [3, 1, 5, 4, 2], m = 2",
    "output": "-1"
  },
  {
    "input": "arr = [1], m = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findLatestStep = function(arr, m) {\n};\n",
  "python": "class Solution:\n    def findLatestStep(self, arr: list[int], m: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findLatestStep(std::vector<int>& arr, int m) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findLatestStep(int[] arr, int m) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findLatestStep",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
    },
    {
      "name": "m",
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
          2,
          4
        ],
        1
      ],
      "expected": 4
    },
    {
      "args": [
        [
          3,
          1,
          5,
          4,
          2
        ],
        2
      ],
      "expected": -1
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
        2,
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
        2
      ],
      1
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
    "expected": 1
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
]$json$::jsonb,
    'approved'
),
(
    1838,
    '执行交换操作后的最小汉明距离',
    '给定两个长度为 n 的整数数组 source 和 target
allowedSwaps 中每项 [u, v] 表示可以任意次交换 source[u] 与 source[v]
同一连通分量内的下标可以任意重排
在最优交换后，返回 source 与 target 的汉明距离，即对应位置元素不相等的下标数量',
    'medium',
    1000,
    256,
    ARRAY['并查集', '哈希表'],
    $json$[
  {
    "input": "source = [1, 2, 3, 4], target = [2, 1, 4, 5], allowedSwaps = [[0, 1], [2, 3]]",
    "output": "1"
  },
  {
    "input": "source = [1, 2, 3, 4], target = [2, 1, 4, 5], allowedSwaps = []",
    "output": "4"
  },
  {
    "input": "source = [1, 2, 3, 4], target = [2, 1, 3, 4], allowedSwaps = [[0, 1]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "source = [1, 2, 3, 4], target = [2, 1, 4, 5], allowedSwaps = [[0, 1], [2, 3]]",
    "output": "1"
  },
  {
    "input": "source = [1, 2, 3, 4], target = [2, 1, 4, 5], allowedSwaps = []",
    "output": "4"
  },
  {
    "input": "source = [1, 2, 3, 4], target = [2, 1, 3, 4], allowedSwaps = [[0, 1]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumHammingDistance = function(source, target, allowedSwaps) {\n};\n",
  "python": "class Solution:\n    def minimumHammingDistance(self, source: list[int], target: list[int], allowedSwaps: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumHammingDistance(std::vector<int>& source, std::vector<int>& target, std::vector<std::vector<int>>& allowedSwaps) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumHammingDistance(int[] source, int[] target, int[][] allowedSwaps) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumHammingDistance",
  "params": [
    {
      "name": "source",
      "type": "int[]"
    },
    {
      "name": "target",
      "type": "int[]"
    },
    {
      "name": "allowedSwaps",
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
          1,
          2,
          3,
          4
        ],
        [
          2,
          1,
          4,
          5
        ],
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
          2,
          1,
          4,
          5
        ],
        []
      ],
      "expected": 4
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
          1,
          3,
          4
        ],
        [
          [
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
        1,
        2
      ],
      [
        2,
        1
      ],
      []
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
        3,
        2,
        1
      ],
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
      [
        4,
        3,
        2,
        1
      ],
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
    "expected": 4
  },
  {
    "args": [
      [
        5,
        1,
        2,
        4,
        3
      ],
      [
        1,
        5,
        4,
        2,
        3
      ],
      [
        [
          0,
          1
        ],
        [
          2,
          3
        ],
        [
          4,
          0
        ]
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
        2,
        3,
        1
      ],
      [
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
    1839,
    '带阈值的图连通性',
    '有 n 个城市，编号 1 到 n
若两个城市编号的最大公约数严格大于 threshold，则它们之间存在一条双向道路
给定多个查询 [u, v]，判断城市 u 与 v 是否连通
返回与 queries 等长的数组，第 i 个元素为 1 表示连通，为 0 表示不连通，顺序与查询一致',
    'medium',
    1000,
    256,
    ARRAY['并查集', '数学'],
    $json$[
  {
    "input": "n = 6, threshold = 2, queries = [[1, 4], [2, 5], [3, 6]]",
    "output": "[0, 0, 1]"
  },
  {
    "input": "n = 6, threshold = 0, queries = [[1, 4]]",
    "output": "[1]"
  },
  {
    "input": "n = 4, threshold = 1, queries = [[1, 2], [2, 3], [3, 4]]",
    "output": "[0, 0, 0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 6, threshold = 2, queries = [[1, 4], [2, 5], [3, 6]]",
    "output": "[0, 0, 1]"
  },
  {
    "input": "n = 6, threshold = 0, queries = [[1, 4]]",
    "output": "[1]"
  },
  {
    "input": "n = 4, threshold = 1, queries = [[1, 2], [2, 3], [3, 4]]",
    "output": "[0, 0, 0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var areConnected = function(n, threshold, queries) {\n};\n",
  "python": "class Solution:\n    def areConnected(self, n: int, threshold: int, queries: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> areConnected(int n, int threshold, std::vector<std::vector<int>>& queries) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] areConnected(int n, int threshold, int[][] queries) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "areConnected",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "threshold",
      "type": "int"
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
        6,
        2,
        [
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
      ],
      "expected": [
        0,
        0,
        1
      ]
    },
    {
      "args": [
        6,
        0,
        [
          [
            1,
            4
          ]
        ]
      ],
      "expected": [
        1
      ]
    },
    {
      "args": [
        4,
        1,
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
      3,
      1,
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
    "expected": [
      0,
      0
    ]
  },
  {
    "args": [
      10,
      3,
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
          4,
          8
        ]
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
      2,
      0,
      [
        [
          1,
          2
        ]
      ]
    ],
    "expected": [
      1
    ]
  },
  {
    "args": [
      5,
      5,
      [
        [
          1,
          2
        ]
      ]
    ],
    "expected": [
      0
    ]
  },
  {
    "args": [
      9,
      2,
      [
        [
          3,
          6
        ],
        [
          6,
          9
        ],
        [
          1,
          8
        ]
      ]
    ],
    "expected": [
      1,
      1,
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1840,
    '最长定差子序列',
    '给定一个整数数组 arr 和一个整数 difference
找出 arr 中最长的子序列，使得相邻元素之差恰好为 difference
返回该子序列的长度
子序列不要求连续',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '哈希表'],
    $json$[
  {
    "input": "arr = [1, 2, 3, 4], difference = 1",
    "output": "4"
  },
  {
    "input": "arr = [1, 3, 5, 7], difference = 1",
    "output": "1"
  },
  {
    "input": "arr = [1, 5, 7, 8, 5, 3, 4, 2, 1], difference = -2",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [1, 2, 3, 4], difference = 1",
    "output": "4"
  },
  {
    "input": "arr = [1, 3, 5, 7], difference = 1",
    "output": "1"
  },
  {
    "input": "arr = [1, 5, 7, 8, 5, 3, 4, 2, 1], difference = -2",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestSubsequence = function(arr, difference) {\n};\n",
  "python": "class Solution:\n    def longestSubsequence(self, arr: list[int], difference: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestSubsequence(std::vector<int>& arr, int difference) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestSubsequence(int[] arr, int difference) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestSubsequence",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
    },
    {
      "name": "difference",
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
          4
        ],
        1
      ],
      "expected": 4
    },
    {
      "args": [
        [
          1,
          3,
          5,
          7
        ],
        1
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          5,
          7,
          8,
          5,
          3,
          4,
          2,
          1
        ],
        -2
      ],
      "expected": 4
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        3,
        4,
        -3,
        -2,
        -4
      ],
      -1
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
        5
      ],
      2
    ],
    "expected": 3
  },
  {
    "args": [
      [
        7,
        7,
        7
      ],
      0
    ],
    "expected": 3
  },
  {
    "args": [
      [
        4,
        12,
        10,
        6,
        8,
        2,
        10
      ],
      2
    ],
    "expected": 4
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ],
      -1
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1841,
    '可被三整除的最大和',
    '给定一个整数数组 nums
从中选出一个子序列，使其元素之和尽可能大，且能被 3 整除
返回该最大和，若只能选空子序列则返回 0',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '数组'],
    $json$[
  {
    "input": "nums = [3, 6, 5, 1, 8]",
    "output": "18"
  },
  {
    "input": "nums = [4]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3, 4, 4]",
    "output": "12"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 6, 5, 1, 8]",
    "output": "18"
  },
  {
    "input": "nums = [4]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3, 4, 4]",
    "output": "12"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxSumDivThree = function(nums) {\n};\n",
  "python": "class Solution:\n    def maxSumDivThree(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxSumDivThree(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxSumDivThree(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxSumDivThree",
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
          5,
          1,
          8
        ]
      ],
      "expected": 18
    },
    {
      "args": [
        [
          4
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
          4
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
        2,
        2,
        2,
        2
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
    "expected": 6
  },
  {
    "args": [
      [
        4,
        4,
        4
      ]
    ],
    "expected": 12
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
    "expected": 3
  },
  {
    "args": [
      [
        2,
        3,
        5,
        7
      ]
    ],
    "expected": 15
  }
]$json$::jsonb,
    'approved'
),
(
    1842,
    '下降路径最小和 II',
    '给定一个 n x n 的整数矩阵 grid
从第一行任意位置出发，每次移动到下一行，且列下标不能与上一行相同
路径经过的元素之和为得分
返回从第一行到最后一行的最小得分',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '矩阵'],
    $json$[
  {
    "input": "grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]",
    "output": "13"
  },
  {
    "input": "grid = [[7]]",
    "output": "7"
  },
  {
    "input": "grid = [[1, 2], [3, 4]]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]",
    "output": "13"
  },
  {
    "input": "grid = [[7]]",
    "output": "7"
  },
  {
    "input": "grid = [[1, 2], [3, 4]]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minFallingPathSum = function(grid) {\n};\n",
  "python": "class Solution:\n    def minFallingPathSum(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minFallingPathSum(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minFallingPathSum(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minFallingPathSum",
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
      "expected": 13
    },
    {
      "args": [
        [
          [
            7
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
            2
          ],
          [
            3,
            4
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
          2,
          1
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
    "expected": -17
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
          3
        ],
        [
          4,
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
          2,
          2,
          2
        ],
        [
          2,
          2,
          2
        ]
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1843,
    '统计作战单位数',
    '有 n 名士兵排成一列，rating[i] 表示第 i 名士兵的评分
一个作战单位由三名士兵组成，下标为 i < j < k
若评分严格递增 rating[i] < rating[j] < rating[k]，或严格递减 rating[i] > rating[j] > rating[k]，则构成一个作战单位
返回作战单位的数量',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "rating = [2, 5, 3, 4, 1]",
    "output": "3"
  },
  {
    "input": "rating = [2, 1, 3]",
    "output": "0"
  },
  {
    "input": "rating = [1, 2, 3, 4]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "rating = [2, 5, 3, 4, 1]",
    "output": "3"
  },
  {
    "input": "rating = [2, 1, 3]",
    "output": "0"
  },
  {
    "input": "rating = [1, 2, 3, 4]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numTeams = function(rating) {\n};\n",
  "python": "class Solution:\n    def numTeams(self, rating: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numTeams(std::vector<int>& rating) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numTeams(int[] rating) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numTeams",
  "params": [
    {
      "name": "rating",
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
          3,
          4,
          1
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
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
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
        2
      ]
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
        5
      ]
    ],
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1844,
    '可获得的最大点数',
    '给定一个整数数组 cardPoints 和一个整数 k
每次可以从数组最左端或最右端取走一张牌，一共取 k 次
返回能够获得的最大点数之和',
    'medium',
    1000,
    256,
    ARRAY['数组', '滑动窗口'],
    $json$[
  {
    "input": "cardPoints = [1, 2, 3, 4, 5, 6, 1], k = 3",
    "output": "12"
  },
  {
    "input": "cardPoints = [2, 2, 2], k = 2",
    "output": "4"
  },
  {
    "input": "cardPoints = [9, 7, 7, 9, 7, 7, 9], k = 7",
    "output": "55"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "cardPoints = [1, 2, 3, 4, 5, 6, 1], k = 3",
    "output": "12"
  },
  {
    "input": "cardPoints = [2, 2, 2], k = 2",
    "output": "4"
  },
  {
    "input": "cardPoints = [9, 7, 7, 9, 7, 7, 9], k = 7",
    "output": "55"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxPointsFromCards = function(cardPoints, k) {\n};\n",
  "python": "class Solution:\n    def maxPointsFromCards(self, cardPoints: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxPointsFromCards(std::vector<int>& cardPoints, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxPointsFromCards(int[] cardPoints, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxPointsFromCards",
  "params": [
    {
      "name": "cardPoints",
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
          3,
          4,
          5,
          6,
          1
        ],
        3
      ],
      "expected": 12
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
      "expected": 4
    },
    {
      "args": [
        [
          9,
          7,
          7,
          9,
          7,
          7,
          9
        ],
        7
      ],
      "expected": 55
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        1000,
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
        2,
        3,
        4,
        5
      ],
      5
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
      ],
      4
    ],
    "expected": 14
  },
  {
    "args": [
      [
        100,
        40,
        17,
        9,
        73,
        75
      ],
      3
    ],
    "expected": 248
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
        1
      ],
      4
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1845,
    '形成两个异或相等数组的三元组数目',
    '给定一个整数数组 arr
三元组 (i, j, k) 满足 i < j <= k
令 a = arr[i] ^ arr[i+1] ^ ... ^ arr[j-1]
令 b = arr[j] ^ arr[j+1] ^ ... ^ arr[k]
若 a == b 则称该三元组有效，其中 ^ 表示按位异或
返回有效三元组的数量',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀异或'],
    $json$[
  {
    "input": "arr = [2, 3, 1, 6, 7]",
    "output": "4"
  },
  {
    "input": "arr = [1, 1, 1]",
    "output": "2"
  },
  {
    "input": "arr = [1, 2, 3]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [2, 3, 1, 6, 7]",
    "output": "4"
  },
  {
    "input": "arr = [1, 1, 1]",
    "output": "2"
  },
  {
    "input": "arr = [1, 2, 3]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countTriplets = function(arr) {\n};\n",
  "python": "class Solution:\n    def countTriplets(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countTriplets(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countTriplets(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countTriplets",
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
          3,
          1,
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
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
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
        7,
        7,
        7
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
        4
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        0,
        0,
        0
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1846,
    '统计全 1 子矩形',
    '给定一个 m x n 的二进制矩阵 mat
统计其中所有元素均为 1 的子矩形的数量
子矩形由连续的行区间和连续的列区间确定',
    'medium',
    1000,
    256,
    ARRAY['矩阵', '单调栈', '动态规划'],
    $json$[
  {
    "input": "mat = [[1, 0, 1], [1, 1, 0], [1, 1, 0]]",
    "output": "13"
  },
  {
    "input": "mat = [[1, 1], [1, 1]]",
    "output": "9"
  },
  {
    "input": "mat = [[1]]",
    "output": "1"
  },
  {
    "input": "mat = [[0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mat = [[1, 0, 1], [1, 1, 0], [1, 1, 0]]",
    "output": "13"
  },
  {
    "input": "mat = [[1, 1], [1, 1]]",
    "output": "9"
  },
  {
    "input": "mat = [[1]]",
    "output": "1"
  },
  {
    "input": "mat = [[0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numSubmat = function(mat) {\n};\n",
  "python": "class Solution:\n    def numSubmat(self, mat: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numSubmat(std::vector<std::vector<int>>& mat) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numSubmat(int[][] mat) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numSubmat",
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
      "expected": 13
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
      "expected": 9
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
    "expected": 18
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
          1
        ]
      ]
    ],
    "expected": 19
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
    "expected": 20
  }
]$json$::jsonb,
    'approved'
),
(
    1847,
    '乘积为正数的最长子数组长度',
    '给定一个整数数组 nums
找出乘积为正数的最长连续子数组的长度
若不存在乘积为正数的非空子数组则返回 0',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "nums = [1, -2, -3, 4]",
    "output": "4"
  },
  {
    "input": "nums = [0, 1, -2, -3, -4]",
    "output": "3"
  },
  {
    "input": "nums = [-1, -2, -3, 0, 1]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, -2, -3, 4]",
    "output": "4"
  },
  {
    "input": "nums = [0, 1, -2, -3, -4]",
    "output": "3"
  },
  {
    "input": "nums = [-1, -2, -3, 0, 1]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var getMaxLen = function(nums) {\n};\n",
  "python": "class Solution:\n    def getMaxLen(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int getMaxLen(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int getMaxLen(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getMaxLen",
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
          -3,
          4
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          0,
          1,
          -2,
          -3,
          -4
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          -1,
          -2,
          -3,
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
        -1,
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
        3
      ]
    ],
    "expected": 3
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
        -1,
        -2
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        2,
        -1,
        -2,
        -3,
        4
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1848,
    '无矛盾的最佳球队',
    '给定两个整数数组 scores 和 ages，第 i 名球员的得分为 scores[i]，年龄为 ages[i]
选出一些球员组成球队，若对于球队中任意两名球员，年龄较大者的得分不低于年龄较小者，则球队无矛盾
返回无矛盾球队中得分总和的最大值
年龄相同的球员之间不产生矛盾',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '排序'],
    $json$[
  {
    "input": "scores = [1, 3, 5, 10, 15], ages = [1, 2, 3, 4, 5]",
    "output": "34"
  },
  {
    "input": "scores = [4, 5, 6, 5], ages = [2, 1, 2, 1]",
    "output": "16"
  },
  {
    "input": "scores = [1, 2, 3, 5], ages = [8, 9, 10, 1]",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "scores = [1, 3, 5, 10, 15], ages = [1, 2, 3, 4, 5]",
    "output": "34"
  },
  {
    "input": "scores = [4, 5, 6, 5], ages = [2, 1, 2, 1]",
    "output": "16"
  },
  {
    "input": "scores = [1, 2, 3, 5], ages = [8, 9, 10, 1]",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var bestTeamScore = function(scores, ages) {\n};\n",
  "python": "class Solution:\n    def bestTeamScore(self, scores: list[int], ages: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int bestTeamScore(std::vector<int>& scores, std::vector<int>& ages) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int bestTeamScore(int[] scores, int[] ages) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "bestTeamScore",
  "params": [
    {
      "name": "scores",
      "type": "int[]"
    },
    {
      "name": "ages",
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
          10,
          15
        ],
        [
          1,
          2,
          3,
          4,
          5
        ]
      ],
      "expected": 34
    },
    {
      "args": [
        [
          4,
          5,
          6,
          5
        ],
        [
          2,
          1,
          2,
          1
        ]
      ],
      "expected": 16
    },
    {
      "args": [
        [
          1,
          2,
          3,
          5
        ],
        [
          8,
          9,
          10,
          1
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
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        5,
        5
      ],
      [
        10,
        10
      ]
    ],
    "expected": 10
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
    "expected": 3
  },
  {
    "args": [
      [
        2,
        3
      ],
      [
        2,
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
      ],
      [
        3,
        2,
        1
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1849,
    '使数组和能被 P 整除',
    '给定一个正整数数组 nums 和一个正整数 p
删除一个连续子数组，使剩余元素之和能被 p 整除
返回需要删除的最短子数组长度，若无法做到则返回 -1
不能删除整个数组',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '哈希表'],
    $json$[
  {
    "input": "nums = [3, 1, 4, 2], p = 6",
    "output": "1"
  },
  {
    "input": "nums = [6, 3, 5, 2], p = 9",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 3], p = 3",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 1, 4, 2], p = 6",
    "output": "1"
  },
  {
    "input": "nums = [6, 3, 5, 2], p = 9",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 3], p = 3",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minSubarray = function(nums, p) {\n};\n",
  "python": "class Solution:\n    def minSubarray(self, nums: list[int], p: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minSubarray(std::vector<int>& nums, int p) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minSubarray(int[] nums, int p) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minSubarray",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "p",
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
          2
        ],
        6
      ],
      "expected": 1
    },
    {
      "args": [
        [
          6,
          3,
          5,
          2
        ],
        9
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
      ],
      7
    ],
    "expected": -1
  },
  {
    "args": [
      [
        1000000000,
        1000000000,
        1000000000
      ],
      3
    ],
    "expected": 0
  },
  {
    "args": [
      [
        4,
        5,
        6
      ],
      5
    ],
    "expected": 0
  },
  {
    "args": [
      [
        7,
        3,
        9,
        4
      ],
      7
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
      5
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1850,
    '矩阵的最大非负积',
    '给定一个 m x n 的整数矩阵 grid
从左上角出发，每次只能向右或向下移动，到达右下角
路径上所有元素之积为路径积
返回所有路径积中的最大值，若最大值为负数则返回 -1
结果对 1e9+7 取余',
    'medium',
    1000,
    256,
    ARRAY['矩阵', '动态规划'],
    $json$[
  {
    "input": "grid = [[-1, -2, -3], [-2, -3, -3], [-3, -3, -2]]",
    "output": "-1"
  },
  {
    "input": "grid = [[1, -2, 1], [1, -2, 1], [3, -4, 1]]",
    "output": "8"
  },
  {
    "input": "grid = [[2, 3], [4, 5]]",
    "output": "40"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[-1, -2, -3], [-2, -3, -3], [-3, -3, -2]]",
    "output": "-1"
  },
  {
    "input": "grid = [[1, -2, 1], [1, -2, 1], [3, -4, 1]]",
    "output": "8"
  },
  {
    "input": "grid = [[2, 3], [4, 5]]",
    "output": "40"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxProductPath = function(grid) {\n};\n",
  "python": "class Solution:\n    def maxProductPath(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxProductPath(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxProductPath(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxProductPath",
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
            -1,
            -2,
            -3
          ],
          [
            -2,
            -3,
            -3
          ],
          [
            -3,
            -3,
            -2
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
            -2,
            1
          ],
          [
            1,
            -2,
            1
          ],
          [
            3,
            -4,
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
            2,
            3
          ],
          [
            4,
            5
          ]
        ]
      ],
      "expected": 40
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          1,
          -2,
          3
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
        ]
      ]
    ],
    "expected": 12
  },
  {
    "args": [
      [
        [
          -1,
          2
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
          -1,
          1
        ],
        [
          1,
          -1,
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
    1851,
    '到家的最少跳跃次数',
    '有一条数轴，从位置 0 出发，家在位置 x
每次可以向前跳 a 个单位，或向后跳 b 个单位
不能落在 forbidden 中的位置，也不能跳到负数位置
不能连续两次向后跳
返回到家的最少跳跃次数，若无法到家则返回 -1',
    'medium',
    1000,
    256,
    ARRAY['图', '广度优先搜索'],
    $json$[
  {
    "input": "forbidden = [14, 4, 18, 1, 15], a = 3, b = 15, x = 9",
    "output": "3"
  },
  {
    "input": "forbidden = [8, 3, 16, 6, 12, 20], a = 15, b = 13, x = 11",
    "output": "-1"
  },
  {
    "input": "forbidden = [1, 6, 2, 14, 5, 17, 4], a = 16, b = 9, x = 7",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "forbidden = [14, 4, 18, 1, 15], a = 3, b = 15, x = 9",
    "output": "3"
  },
  {
    "input": "forbidden = [8, 3, 16, 6, 12, 20], a = 15, b = 13, x = 11",
    "output": "-1"
  },
  {
    "input": "forbidden = [1, 6, 2, 14, 5, 17, 4], a = 16, b = 9, x = 7",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumJumps = function(forbidden, a, b, x) {\n};\n",
  "python": "class Solution:\n    def minimumJumps(self, forbidden: list[int], a: int, b: int, x: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumJumps(std::vector<int>& forbidden, int a, int b, int x) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumJumps(int[] forbidden, int a, int b, int x) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumJumps",
  "params": [
    {
      "name": "forbidden",
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
        [
          14,
          4,
          18,
          1,
          15
        ],
        3,
        15,
        9
      ],
      "expected": 3
    },
    {
      "args": [
        [
          8,
          3,
          16,
          6,
          12,
          20
        ],
        15,
        13,
        11
      ],
      "expected": -1
    },
    {
      "args": [
        [
          1,
          6,
          2,
          14,
          5,
          17,
          4
        ],
        16,
        9,
        7
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
      1,
      1,
      4
    ],
    "expected": -1
  },
  {
    "args": [
      [],
      1,
      1,
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [],
      1,
      1,
      0
    ],
    "expected": 0
  },
  {
    "args": [
      [],
      2,
      1,
      3
    ],
    "expected": 3
  },
  {
    "args": [
      [],
      1,
      2,
      3
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1852,
    '删除子字符串的最大得分',
    '给定一个只包含字符 a 和 b 的字符串 s，以及两个整数 x 和 y
删除一个子字符串 ab 可以获得 x 分
删除一个子字符串 ba 可以获得 y 分
可以任意顺序反复删除，返回能够获得的最大得分',
    'medium',
    1000,
    256,
    ARRAY['字符串', '贪心', '栈'],
    $json$[
  {
    "input": "s = \"cdbcbbaaabab\", x = 4, y = 5",
    "output": "19"
  },
  {
    "input": "s = \"aabbaaxybbaabb\", x = 5, y = 4",
    "output": "20"
  },
  {
    "input": "s = \"ab\", x = 2, y = 3",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"cdbcbbaaabab\", x = 4, y = 5",
    "output": "19"
  },
  {
    "input": "s = \"aabbaaxybbaabb\", x = 5, y = 4",
    "output": "20"
  },
  {
    "input": "s = \"ab\", x = 2, y = 3",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumGain = function(s, x, y) {\n};\n",
  "python": "class Solution:\n    def maximumGain(self, s: str, x: int, y: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumGain(std::string s, int x, int y) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumGain(String s, int x, int y) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumGain",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "x",
      "type": "int"
    },
    {
      "name": "y",
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
        "cdbcbbaaabab",
        4,
        5
      ],
      "expected": 19
    },
    {
      "args": [
        "aabbaaxybbaabb",
        5,
        4
      ],
      "expected": 20
    },
    {
      "args": [
        "ab",
        2,
        3
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "ba",
      2,
      3
    ],
    "expected": 3
  },
  {
    "args": [
      "aabb",
      3,
      2
    ],
    "expected": 6
  },
  {
    "args": [
      "cd",
      5,
      5
    ],
    "expected": 0
  },
  {
    "args": [
      "abba",
      1,
      1
    ],
    "expected": 2
  },
  {
    "args": [
      "bbaa",
      4,
      3
    ],
    "expected": 6
  }
]$json$::jsonb,
    'approved'
),
(
    1853,
    '地图中的最高点',
    '给定一个 m x n 的二进制矩阵 isWater
isWater[i][j] = 1 表示该位置是水域，必须高度为 0
isWater[i][j] = 0 表示该位置是陆地，高度必须为正整数
任意两个相邻格子的高度差不能超过 1
返回一个满足条件的最高高度分布矩阵，保证至少有一个水域',
    'medium',
    1000,
    256,
    ARRAY['图', '广度优先搜索', '矩阵'],
    $json$[
  {
    "input": "isWater = [[0, 1], [0, 0]]",
    "output": "[[1, 0], [2, 1]]"
  },
  {
    "input": "isWater = [[0, 0, 1], [1, 0, 0], [0, 0, 0]]",
    "output": "[[1, 1, 0], [0, 1, 1], [1, 2, 2]]"
  },
  {
    "input": "isWater = [[1]]",
    "output": "[[0]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "isWater = [[0, 1], [0, 0]]",
    "output": "[[1, 0], [2, 1]]"
  },
  {
    "input": "isWater = [[0, 0, 1], [1, 0, 0], [0, 0, 0]]",
    "output": "[[1, 1, 0], [0, 1, 1], [1, 2, 2]]"
  },
  {
    "input": "isWater = [[1]]",
    "output": "[[0]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var highestPeak = function(isWater) {\n};\n",
  "python": "class Solution:\n    def highestPeak(self, isWater: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> highestPeak(std::vector<std::vector<int>>& isWater) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] highestPeak(int[][] isWater) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "highestPeak",
  "params": [
    {
      "name": "isWater",
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
            1
          ],
          [
            0,
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
      "expected": [
        [
          1,
          1,
          0
        ],
        [
          0,
          1,
          1
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
          1,
          0
        ]
      ]
    ],
    "expected": [
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
        [
          0,
          0,
          1
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
    "expected": [
      [
        2,
        1,
        0
      ],
      [
        3,
        2,
        1
      ],
      [
        4,
        3,
        2
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
        ],
        [
          0,
          0,
          1
        ]
      ]
    ],
    "expected": [
      [
        4,
        3,
        2
      ],
      [
        3,
        2,
        1
      ],
      [
        2,
        1,
        0
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1854,
    '最接近目标价格的甜点成本',
    '给定基料成本数组 baseCosts，配料成本数组 toppingCosts，以及目标价格 target
必须选择一种基料，每种配料最多选择两份
甜点成本为基料成本加上所选配料成本
返回最接近 target 的成本，若距离相同则返回成本较低者',
    'medium',
    1000,
    256,
    ARRAY['回溯', '数组'],
    $json$[
  {
    "input": "baseCosts = [1, 7], toppingCosts = [3, 4], target = 10",
    "output": "10"
  },
  {
    "input": "baseCosts = [2, 3], toppingCosts = [4, 5, 100], target = 18",
    "output": "17"
  },
  {
    "input": "baseCosts = [3, 10], toppingCosts = [2, 5], target = 9",
    "output": "8"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "baseCosts = [1, 7], toppingCosts = [3, 4], target = 10",
    "output": "10"
  },
  {
    "input": "baseCosts = [2, 3], toppingCosts = [4, 5, 100], target = 18",
    "output": "17"
  },
  {
    "input": "baseCosts = [3, 10], toppingCosts = [2, 5], target = 9",
    "output": "8"
  }
]$json$::jsonb,
    $json${
  "javascript": "var closestCost = function(baseCosts, toppingCosts, target) {\n};\n",
  "python": "class Solution:\n    def closestCost(self, baseCosts: list[int], toppingCosts: list[int], target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int closestCost(std::vector<int>& baseCosts, std::vector<int>& toppingCosts, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int closestCost(int[] baseCosts, int[] toppingCosts, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "closestCost",
  "params": [
    {
      "name": "baseCosts",
      "type": "int[]"
    },
    {
      "name": "toppingCosts",
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
          7
        ],
        [
          3,
          4
        ],
        10
      ],
      "expected": 10
    },
    {
      "args": [
        [
          2,
          3
        ],
        [
          4,
          5,
          100
        ],
        18
      ],
      "expected": 17
    },
    {
      "args": [
        [
          3,
          10
        ],
        [
          2,
          5
        ],
        9
      ],
      "expected": 8
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        10
      ],
      [
        1
      ],
      1
    ],
    "expected": 10
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
      ],
      10
    ],
    "expected": 10
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
    "expected": 1
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
      5
    ],
    "expected": 5
  },
  {
    "args": [
      [
        5,
        8
      ],
      [
        3,
        4
      ],
      10
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1855,
    '找出不同的二进制字符串',
    '给定 n 个互不相同的长度为 n 的二进制字符串 nums
返回一个长度为 n 且不在 nums 中出现的二进制字符串
为保证结果唯一，按下述方式构造：结果第 i 个字符等于 nums[i] 第 i 个字符取反，i 从 0 开始',
    'medium',
    1000,
    256,
    ARRAY['字符串', '回溯'],
    $json$[
  {
    "input": "nums = [\"01\", \"10\"]",
    "output": "\"11\""
  },
  {
    "input": "nums = [\"00\", \"01\"]",
    "output": "\"10\""
  },
  {
    "input": "nums = [\"111\", \"011\", \"001\"]",
    "output": "\"000\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [\"01\", \"10\"]",
    "output": "\"11\""
  },
  {
    "input": "nums = [\"00\", \"01\"]",
    "output": "\"10\""
  },
  {
    "input": "nums = [\"111\", \"011\", \"001\"]",
    "output": "\"000\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var findDifferentBinaryString = function(nums) {\n};\n",
  "python": "class Solution:\n    def findDifferentBinaryString(self, nums: list[str]) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string findDifferentBinaryString(std::vector<std::string>& nums) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String findDifferentBinaryString(String[] nums) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findDifferentBinaryString",
  "params": [
    {
      "name": "nums",
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
          "01",
          "10"
        ]
      ],
      "expected": "11"
    },
    {
      "args": [
        [
          "00",
          "01"
        ]
      ],
      "expected": "10"
    },
    {
      "args": [
        [
          "111",
          "011",
          "001"
        ]
      ],
      "expected": "000"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "0"
      ]
    ],
    "expected": "1"
  },
  {
    "args": [
      [
        "11",
        "10"
      ]
    ],
    "expected": "01"
  },
  {
    "args": [
      [
        "000",
        "011",
        "101"
      ]
    ],
    "expected": "100"
  },
  {
    "args": [
      [
        "0000",
        "0001",
        "0010",
        "0011"
      ]
    ],
    "expected": "1100"
  },
  {
    "args": [
      [
        "1"
      ]
    ],
    "expected": "0"
  }
]$json$::jsonb,
    'approved'
),
(
    1856,
    '最少侧跳次数',
    '有一条长度为 n 的跑道，分为三条车道，编号 1 到 3
obstacles[i] 表示第 i 个位置被障碍物占据的车道，0 表示没有障碍物
从位置 0 的车道 2 出发，只能向前移动，遇到障碍物时可侧跳到其他车道
侧跳一次算作一步，不能跳到有障碍物的车道
返回到达最后一个位置的最少侧跳次数',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '数组'],
    $json$[
  {
    "input": "obstacles = [0, 1, 2, 3, 0]",
    "output": "2"
  },
  {
    "input": "obstacles = [0, 1, 1, 3, 3, 0]",
    "output": "0"
  },
  {
    "input": "obstacles = [0, 2, 1, 0, 3, 0]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "obstacles = [0, 1, 2, 3, 0]",
    "output": "2"
  },
  {
    "input": "obstacles = [0, 1, 1, 3, 3, 0]",
    "output": "0"
  },
  {
    "input": "obstacles = [0, 2, 1, 0, 3, 0]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minSideJumps = function(obstacles) {\n};\n",
  "python": "class Solution:\n    def minSideJumps(self, obstacles: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minSideJumps(std::vector<int>& obstacles) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minSideJumps(int[] obstacles) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minSideJumps",
  "params": [
    {
      "name": "obstacles",
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
          2,
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
          1,
          1,
          3,
          3,
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
          0,
          3,
          0
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
        0
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        0,
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
        0,
        1,
        1,
        2,
        2,
        0
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1857,
    '扣分后的最大得分',
    '给定一个 m x n 的整数矩阵 points
从每一行恰好选择一个格子，第 r 行选择的列记为 c_r
得分为所有选中格子的值之和，减去相邻两行所选列下标之差的绝对值之和
返回能够获得的最大得分
数据保证结果在 64 位整数范围内',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '矩阵'],
    $json$[
  {
    "input": "points = [[1, 2, 3], [1, 5, 1], [3, 1, 1]]",
    "output": "9"
  },
  {
    "input": "points = [[1, 5], [2, 3], [4, 2]]",
    "output": "11"
  },
  {
    "input": "points = [[1, 2], [3, 4]]",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "points = [[1, 2, 3], [1, 5, 1], [3, 1, 1]]",
    "output": "9"
  },
  {
    "input": "points = [[1, 5], [2, 3], [4, 2]]",
    "output": "11"
  },
  {
    "input": "points = [[1, 2], [3, 4]]",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxPoints = function(points) {\n};\n",
  "python": "class Solution:\n    def maxPoints(self, points: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long maxPoints(std::vector<std::vector<int>>& points) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long maxPoints(int[][] points) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxPoints",
  "params": [
    {
      "name": "points",
      "type": "int[][]"
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
            3
          ],
          [
            1,
            5,
            1
          ],
          [
            3,
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
            5
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
      "expected": 6
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
          1,
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
          4,
          3,
          2,
          1
        ],
        [
          1,
          2,
          3,
          4
        ]
      ]
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1858,
    '找到所有的农场组',
    '给定一个 m x n 的二进制矩阵 land
1 表示农田，0 表示荒地，农场组是由 1 组成的矩形区域，且不同农场组互不接触
返回所有农场组，每组表示为 [左上角行, 左上角列, 右下角行, 右下角列]
结果按左上角先行后列的顺序升序排列',
    'medium',
    1000,
    256,
    ARRAY['图', '深度优先搜索', '矩阵'],
    $json$[
  {
    "input": "land = [[1, 0, 0], [0, 1, 1], [0, 1, 1]]",
    "output": "[[0, 0, 0, 0], [1, 1, 2, 2]]"
  },
  {
    "input": "land = [[1, 1], [1, 1]]",
    "output": "[[0, 0, 1, 1]]"
  },
  {
    "input": "land = [[0]]",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "land = [[1, 0, 0], [0, 1, 1], [0, 1, 1]]",
    "output": "[[0, 0, 0, 0], [1, 1, 2, 2]]"
  },
  {
    "input": "land = [[1, 1], [1, 1]]",
    "output": "[[0, 0, 1, 1]]"
  },
  {
    "input": "land = [[0]]",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findFarmland = function(land) {\n};\n",
  "python": "class Solution:\n    def findFarmland(self, land: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> findFarmland(std::vector<std::vector<int>>& land) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] findFarmland(int[][] land) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findFarmland",
  "params": [
    {
      "name": "land",
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
            0,
            0
          ],
          [
            0,
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
      "expected": [
        [
          0,
          0,
          0,
          0
        ],
        [
          1,
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
          0,
          0,
          1,
          1
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
          1,
          0,
          0
        ],
        [
          0,
          0,
          1,
          1
        ]
      ]
    ],
    "expected": [
      [
        0,
        0,
        0,
        1
      ],
      [
        1,
        2,
        1,
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
    "expected": []
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
          0,
          0,
          1
        ]
      ]
    ],
    "expected": [
      [
        0,
        0,
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
        1,
        0
      ],
      [
        0,
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
    "expected": [
      [
        0,
        0,
        2,
        1
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1859,
    '找到二叉树中的距离',
    '给定一棵二叉树的根节点 root，以及树中两个不同节点的值 p 和 q
返回值为 p 的节点与值为 q 的节点之间的最短路径边数
树中节点值互不相同，且 p、q 均存在',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索'],
    $json$[
  {
    "input": "root = [3, 5, 1, 6, 2, 0, 8, null, null, 7, 4], p = 5, q = 0",
    "output": "3"
  },
  {
    "input": "root = [3, 5, 1, 6, 2, 0, 8, null, null, 7, 4], p = 5, q = 7",
    "output": "2"
  },
  {
    "input": "root = [3, 5, 1, 6, 2, 0, 8, null, null, 7, 4], p = 5, q = 4",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [3, 5, 1, 6, 2, 0, 8, null, null, 7, 4], p = 5, q = 0",
    "output": "3"
  },
  {
    "input": "root = [3, 5, 1, 6, 2, 0, 8, null, null, 7, 4], p = 5, q = 7",
    "output": "2"
  },
  {
    "input": "root = [3, 5, 1, 6, 2, 0, 8, null, null, 7, 4], p = 5, q = 4",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar findDistance = function(root, p, q) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def findDistance(self, root: TreeNode | None, p: int, q: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int findDistance(TreeNode* root, int p, int q) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int findDistance(TreeNode root, int p, int q) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findDistance",
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
        0
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
        7
      ],
      "expected": 2
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
      1,
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
      1,
      2
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
      2,
      3
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
        5
      ],
      4,
      5
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
        5
      ],
      4,
      3
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1860,
    '合并石头的最低成本',
    '有 n 堆石头排成一排，第 i 堆有 stones[i] 颗石头
每次操作必须将连续的 k 堆石头合并成一堆，成本为这 k 堆石头的总数
经过若干次操作后，把所有石头合并成一堆
返回最小总成本
如果无法合并成一堆，返回 -1',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "stones = [3, 2, 4, 1], k = 2",
    "output": "20"
  },
  {
    "input": "stones = [3, 2, 4, 1], k = 3",
    "output": "-1"
  },
  {
    "input": "stones = [1, 2, 3, 4, 5], k = 2",
    "output": "33"
  },
  {
    "input": "stones = [1], k = 2",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "stones = [3, 2, 4, 1], k = 2",
    "output": "20"
  },
  {
    "input": "stones = [3, 2, 4, 1], k = 3",
    "output": "-1"
  },
  {
    "input": "stones = [1, 2, 3, 4, 5], k = 2",
    "output": "33"
  },
  {
    "input": "stones = [1], k = 2",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var mergeStones = function(stones, k) {\n};\n",
  "python": "class Solution:\n    def mergeStones(self, stones: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int mergeStones(std::vector<int>& stones, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int mergeStones(int[] stones, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "mergeStones",
  "params": [
    {
      "name": "stones",
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
          4,
          1
        ],
        2
      ],
      "expected": 20
    },
    {
      "args": [
        [
          3,
          2,
          4,
          1
        ],
        3
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
        2
      ],
      "expected": 33
    },
    {
      "args": [
        [
          1
        ],
        2
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
      ],
      2
    ],
    "expected": 9
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
    "expected": 6
  },
  {
    "args": [
      [
        4,
        1,
        1,
        1,
        1
      ],
      3
    ],
    "expected": 11
  },
  {
    "args": [
      [
        1,
        3,
        5,
        7,
        9,
        11
      ],
      3
    ],
    "expected": -1
  },
  {
    "args": [
      [
        5,
        5,
        5,
        5
      ],
      2
    ],
    "expected": 40
  },
  {
    "args": [
      [
        2,
        4,
        6,
        8
      ],
      2
    ],
    "expected": 38
  }
]$json$::jsonb,
    'approved'
),
(
    1861,
    '至少有 1 位重复的数字',
    '给定正整数 n
返回范围 [1, n] 内至少存在一位重复数字的正整数个数',
    'hard',
    1000,
    256,
    ARRAY['数学', '动态规划'],
    $json$[
  {
    "input": "n = 20",
    "output": "1"
  },
  {
    "input": "n = 100",
    "output": "10"
  },
  {
    "input": "n = 1000",
    "output": "262"
  },
  {
    "input": "n = 11",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 20",
    "output": "1"
  },
  {
    "input": "n = 100",
    "output": "10"
  },
  {
    "input": "n = 1000",
    "output": "262"
  },
  {
    "input": "n = 11",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numDupDigitsAtMostN = function(n) {\n};\n",
  "python": "class Solution:\n    def numDupDigitsAtMostN(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numDupDigitsAtMostN(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numDupDigitsAtMostN(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numDupDigitsAtMostN",
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
      "expected": 1
    },
    {
      "args": [
        100
      ],
      "expected": 10
    },
    {
      "args": [
        1000
      ],
      "expected": 262
    },
    {
      "args": [
        11
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
      9
    ],
    "expected": 0
  },
  {
    "args": [
      10
    ],
    "expected": 0
  },
  {
    "args": [
      10000
    ],
    "expected": 4726
  },
  {
    "args": [
      987654321
    ],
    "expected": 982042551
  },
  {
    "args": [
      1000000000
    ],
    "expected": 994388230
  }
]$json$::jsonb,
    'approved'
),
(
    1862,
    '验证回文串 III',
    '给定字符串 s 和整数 k
每次可以删除一个字符，最多删除 k 次
判断能否使剩余字符串成为回文串',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "s = \"abc\", k = 2",
    "output": "true"
  },
  {
    "input": "s = \"abcdeca\", k = 2",
    "output": "true"
  },
  {
    "input": "s = \"abc\", k = 1",
    "output": "false"
  },
  {
    "input": "s = \"a\", k = 1",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abc\", k = 2",
    "output": "true"
  },
  {
    "input": "s = \"abcdeca\", k = 2",
    "output": "true"
  },
  {
    "input": "s = \"abc\", k = 1",
    "output": "false"
  },
  {
    "input": "s = \"a\", k = 1",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isValidPalindromeIII = function(s, k) {\n};\n",
  "python": "class Solution:\n    def isValidPalindromeIII(self, s: str, k: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isValidPalindromeIII(std::string s, int k) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isValidPalindromeIII(String s, int k) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isValidPalindromeIII",
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
  "return_type": "bool",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "abc",
        2
      ],
      "expected": true
    },
    {
      "args": [
        "abcdeca",
        2
      ],
      "expected": true
    },
    {
      "args": [
        "abc",
        1
      ],
      "expected": false
    },
    {
      "args": [
        "a",
        1
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "aa",
      0
    ],
    "expected": true
  },
  {
    "args": [
      "ab",
      1
    ],
    "expected": true
  },
  {
    "args": [
      "abcd",
      1
    ],
    "expected": false
  },
  {
    "args": [
      "abcdef",
      3
    ],
    "expected": false
  },
  {
    "args": [
      "abca",
      1
    ],
    "expected": true
  },
  {
    "args": [
      "abbababa",
      1
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1863,
    '掷骰子模拟',
    '掷一个六面骰子 n 次，点数从 1 到 6
第 i 面连续出现的次数不能超过 rollMax[i-1]
返回不同点数序列的总数，对 10^9+7 取模',
    'hard',
    1000,
    256,
    ARRAY['动态规划'],
    $json$[
  {
    "input": "n = 1, rollMax = [1, 1, 2, 2, 2, 3]",
    "output": "6"
  },
  {
    "input": "n = 2, rollMax = [1, 1, 2, 2, 2, 3]",
    "output": "34"
  },
  {
    "input": "n = 2, rollMax = [1, 1, 1, 1, 1, 1]",
    "output": "30"
  },
  {
    "input": "n = 3, rollMax = [1, 1, 1, 2, 2, 3]",
    "output": "181"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 1, rollMax = [1, 1, 2, 2, 2, 3]",
    "output": "6"
  },
  {
    "input": "n = 2, rollMax = [1, 1, 2, 2, 2, 3]",
    "output": "34"
  },
  {
    "input": "n = 2, rollMax = [1, 1, 1, 1, 1, 1]",
    "output": "30"
  },
  {
    "input": "n = 3, rollMax = [1, 1, 1, 2, 2, 3]",
    "output": "181"
  }
]$json$::jsonb,
    $json${
  "javascript": "var dieSimulator = function(n, rollMax) {\n};\n",
  "python": "class Solution:\n    def dieSimulator(self, n: int, rollMax: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int dieSimulator(int n, std::vector<int>& rollMax) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int dieSimulator(int n, int[] rollMax) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "dieSimulator",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "rollMax",
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
        1,
        [
          1,
          1,
          2,
          2,
          2,
          3
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        2,
        [
          1,
          1,
          2,
          2,
          2,
          3
        ]
      ],
      "expected": 34
    },
    {
      "args": [
        2,
        [
          1,
          1,
          1,
          1,
          1,
          1
        ]
      ],
      "expected": 30
    },
    {
      "args": [
        3,
        [
          1,
          1,
          1,
          2,
          2,
          3
        ]
      ],
      "expected": 181
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      [
        1,
        1,
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
      10,
      [
        2,
        2,
        2,
        2,
        2,
        2
      ]
    ],
    "expected": 49503750
  },
  {
    "args": [
      50,
      [
        1,
        2,
        3,
        1,
        2,
        3
      ]
    ],
    "expected": 271774531
  },
  {
    "args": [
      500,
      [
        1,
        1,
        2,
        2,
        3,
        3
      ]
    ],
    "expected": 101616524
  },
  {
    "args": [
      5000,
      [
        1,
        1,
        2,
        2,
        2,
        3
      ]
    ],
    "expected": 462108995
  },
  {
    "args": [
      1000,
      [
        6,
        6,
        6,
        6,
        6,
        6
      ]
    ],
    "expected": 387736127
  }
]$json$::jsonb,
    'approved'
),
(
    1864,
    '规划兼职工作',
    '给定 startTime、endTime、profit 三个等长数组
第 i 份工作从 startTime[i] 持续到 endTime[i]，报酬为 profit[i]
同一时间只能做一份工作，下一份工作的开始时间必须不早于上一份工作的结束时间
返回能获得的最大报酬',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '二分查找'],
    $json$[
  {
    "input": "startTime = [1, 2, 3, 3], endTime = [3, 4, 5, 6], profit = [50, 10, 40, 70]",
    "output": "120"
  },
  {
    "input": "startTime = [1, 2, 3, 4, 6], endTime = [3, 5, 10, 6, 9], profit = [20, 20, 100, 70, 60]",
    "output": "150"
  },
  {
    "input": "startTime = [1, 1, 1], endTime = [2, 3, 4], profit = [5, 6, 7]",
    "output": "7"
  },
  {
    "input": "startTime = [1], endTime = [2], profit = [3]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "startTime = [1, 2, 3, 3], endTime = [3, 4, 5, 6], profit = [50, 10, 40, 70]",
    "output": "120"
  },
  {
    "input": "startTime = [1, 2, 3, 4, 6], endTime = [3, 5, 10, 6, 9], profit = [20, 20, 100, 70, 60]",
    "output": "150"
  },
  {
    "input": "startTime = [1, 1, 1], endTime = [2, 3, 4], profit = [5, 6, 7]",
    "output": "7"
  },
  {
    "input": "startTime = [1], endTime = [2], profit = [3]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var jobScheduling = function(startTime, endTime, profit) {\n};\n",
  "python": "class Solution:\n    def jobScheduling(self, startTime: list[int], endTime: list[int], profit: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int jobScheduling(std::vector<int>& startTime, std::vector<int>& endTime, std::vector<int>& profit) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int jobScheduling(int[] startTime, int[] endTime, int[] profit) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "jobScheduling",
  "params": [
    {
      "name": "startTime",
      "type": "int[]"
    },
    {
      "name": "endTime",
      "type": "int[]"
    },
    {
      "name": "profit",
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
        ],
        [
          3,
          4,
          5,
          6
        ],
        [
          50,
          10,
          40,
          70
        ]
      ],
      "expected": 120
    },
    {
      "args": [
        [
          1,
          2,
          3,
          4,
          6
        ],
        [
          3,
          5,
          10,
          6,
          9
        ],
        [
          20,
          20,
          100,
          70,
          60
        ]
      ],
      "expected": 150
    },
    {
      "args": [
        [
          1,
          1,
          1
        ],
        [
          2,
          3,
          4
        ],
        [
          5,
          6,
          7
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        [
          1
        ],
        [
          2
        ],
        [
          3
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
        1,
        2,
        3,
        4
      ],
      [
        2,
        3,
        4,
        5
      ],
      [
        1,
        2,
        3,
        4
      ]
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
    "expected": 3
  },
  {
    "args": [
      [
        4,
        2,
        4,
        8,
        2
      ],
      [
        5,
        5,
        5,
        10,
        8
      ],
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
    "expected": 6
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
        4,
        5
      ],
      [
        10,
        20,
        30
      ]
    ],
    "expected": 40
  },
  {
    "args": [
      [
        1,
        3,
        5,
        7
      ],
      [
        2,
        4,
        6,
        8
      ],
      [
        5,
        5,
        5,
        5
      ]
    ],
    "expected": 20
  }
]$json$::jsonb,
    'approved'
),
(
    1865,
    '分割回文串 III',
    '给定字符串 s 和整数 k
把 s 分割成 k 个非空子串，并可以修改任意位置的字符
返回使每个子串都成为回文串所需的最少修改次数',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "s = \"abc\", k = 2",
    "output": "1"
  },
  {
    "input": "s = \"aabbc\", k = 3",
    "output": "0"
  },
  {
    "input": "s = \"leetcode\", k = 8",
    "output": "0"
  },
  {
    "input": "s = \"abcdef\", k = 6",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abc\", k = 2",
    "output": "1"
  },
  {
    "input": "s = \"aabbc\", k = 3",
    "output": "0"
  },
  {
    "input": "s = \"leetcode\", k = 8",
    "output": "0"
  },
  {
    "input": "s = \"abcdef\", k = 6",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var palindromePartitionIII = function(s, k) {\n};\n",
  "python": "class Solution:\n    def palindromePartitionIII(self, s: str, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int palindromePartitionIII(std::string s, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int palindromePartitionIII(String s, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "palindromePartitionIII",
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
        "abc",
        2
      ],
      "expected": 1
    },
    {
      "args": [
        "aabbc",
        3
      ],
      "expected": 0
    },
    {
      "args": [
        "leetcode",
        8
      ],
      "expected": 0
    },
    {
      "args": [
        "abcdef",
        6
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abc",
      1
    ],
    "expected": 1
  },
  {
    "args": [
      "abcdef",
      1
    ],
    "expected": 3
  },
  {
    "args": [
      "aba",
      1
    ],
    "expected": 0
  },
  {
    "args": [
      "abcba",
      3
    ],
    "expected": 0
  },
  {
    "args": [
      "aaabbb",
      2
    ],
    "expected": 0
  },
  {
    "args": [
      "abcde",
      3
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1866,
    '两个子序列的最大点积',
    '给定两个整数数组 nums1 和 nums2
从 nums1 中选出一个非空子序列，从 nums2 中选出一个非空子序列，两者长度相同
按顺序对应相乘后求和，返回可能的最大点积',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "nums1 = [2, 1, -2, 5], nums2 = [3, 0, -6]",
    "output": "18"
  },
  {
    "input": "nums1 = [3, -2], nums2 = [2, 4]",
    "output": "12"
  },
  {
    "input": "nums1 = [-1, -1], nums2 = [-1, -1]",
    "output": "2"
  },
  {
    "input": "nums1 = [1, 2, 3], nums2 = [4, 5, 6]",
    "output": "32"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums1 = [2, 1, -2, 5], nums2 = [3, 0, -6]",
    "output": "18"
  },
  {
    "input": "nums1 = [3, -2], nums2 = [2, 4]",
    "output": "12"
  },
  {
    "input": "nums1 = [-1, -1], nums2 = [-1, -1]",
    "output": "2"
  },
  {
    "input": "nums1 = [1, 2, 3], nums2 = [4, 5, 6]",
    "output": "32"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxDotProduct = function(nums1, nums2) {\n};\n",
  "python": "class Solution:\n    def maxDotProduct(self, nums1: list[int], nums2: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxDotProduct(std::vector<int>& nums1, std::vector<int>& nums2) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxDotProduct(int[] nums1, int[] nums2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxDotProduct",
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
          -2,
          5
        ],
        [
          3,
          0,
          -6
        ]
      ],
      "expected": 18
    },
    {
      "args": [
        [
          3,
          -2
        ],
        [
          2,
          4
        ]
      ],
      "expected": 12
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
          4,
          5,
          6
        ]
      ],
      "expected": 32
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
        -1,
        -1
      ]
    ],
    "expected": -1
  },
  {
    "args": [
      [
        -3,
        -2,
        -1
      ],
      [
        -1,
        -2,
        -3
      ]
    ],
    "expected": 12
  },
  {
    "args": [
      [
        5
      ],
      [
        -2
      ]
    ],
    "expected": -10
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
    "expected": 11
  },
  {
    "args": [
      [
        -5,
        -4
      ],
      [
        -3,
        -2
      ]
    ],
    "expected": 23
  },
  {
    "args": [
      [
        0,
        1
      ],
      [
        -1,
        0
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1867,
    '切棍子的最小成本',
    '有一根长度为 n 的棍子，cuts 给出所有需要切割的位置
每次切割一根棍子时，成本为该棍子当前的长度
切割后得到两根更短的棍子，可以继续切割
返回完成所有切割的最小总成本',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "n = 7, cuts = [1, 3, 4, 5]",
    "output": "16"
  },
  {
    "input": "n = 9, cuts = [5, 6, 1, 4, 2]",
    "output": "22"
  },
  {
    "input": "n = 7, cuts = []",
    "output": "0"
  },
  {
    "input": "n = 10, cuts = [2, 4, 7]",
    "output": "20"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 7, cuts = [1, 3, 4, 5]",
    "output": "16"
  },
  {
    "input": "n = 9, cuts = [5, 6, 1, 4, 2]",
    "output": "22"
  },
  {
    "input": "n = 7, cuts = []",
    "output": "0"
  },
  {
    "input": "n = 10, cuts = [2, 4, 7]",
    "output": "20"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minCostCutStick = function(n, cuts) {\n};\n",
  "python": "class Solution:\n    def minCostCutStick(self, n: int, cuts: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minCostCutStick(int n, std::vector<int>& cuts) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minCostCutStick(int n, int[] cuts) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minCostCutStick",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "cuts",
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
          1,
          3,
          4,
          5
        ]
      ],
      "expected": 16
    },
    {
      "args": [
        9,
        [
          5,
          6,
          1,
          4,
          2
        ]
      ],
      "expected": 22
    },
    {
      "args": [
        7,
        []
      ],
      "expected": 0
    },
    {
      "args": [
        10,
        [
          2,
          4,
          7
        ]
      ],
      "expected": 20
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      7,
      [
        1
      ]
    ],
    "expected": 7
  },
  {
    "args": [
      100,
      [
        25,
        50,
        75
      ]
    ],
    "expected": 200
  },
  {
    "args": [
      5,
      [
        1,
        2,
        3,
        4
      ]
    ],
    "expected": 12
  },
  {
    "args": [
      20,
      [
        1,
        5,
        9,
        13,
        17
      ]
    ],
    "expected": 52
  },
  {
    "args": [
      30,
      [
        5,
        10,
        15,
        20,
        25
      ]
    ],
    "expected": 80
  },
  {
    "args": [
      8,
      [
        3,
        5
      ]
    ],
    "expected": 13
  }
]$json$::jsonb,
    'approved'
),
(
    1868,
    '执行乘法运算的最大分数',
    '给定数组 nums 和 multipliers
需要进行 multipliers.length 次操作
第 i 次操作取 nums 当前最左端或最右端的元素，与 multipliers[i] 相乘并累加
返回所有操作完成后的最大总分',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "nums = [1, 2, 3], multipliers = [3, 2, 1]",
    "output": "14"
  },
  {
    "input": "nums = [-5, -3, -3, -2, 7, 1], multipliers = [-10, -5, 3, 4, 6]",
    "output": "102"
  },
  {
    "input": "nums = [1, 2], multipliers = [1, 2]",
    "output": "5"
  },
  {
    "input": "nums = [1], multipliers = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3], multipliers = [3, 2, 1]",
    "output": "14"
  },
  {
    "input": "nums = [-5, -3, -3, -2, 7, 1], multipliers = [-10, -5, 3, 4, 6]",
    "output": "102"
  },
  {
    "input": "nums = [1, 2], multipliers = [1, 2]",
    "output": "5"
  },
  {
    "input": "nums = [1], multipliers = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumScoreMultipliers = function(nums, multipliers) {\n};\n",
  "python": "class Solution:\n    def maximumScoreMultipliers(self, nums: list[int], multipliers: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumScoreMultipliers(std::vector<int>& nums, std::vector<int>& multipliers) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumScoreMultipliers(int[] nums, int[] multipliers) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumScoreMultipliers",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "multipliers",
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
          3,
          2,
          1
        ]
      ],
      "expected": 14
    },
    {
      "args": [
        [
          -5,
          -3,
          -3,
          -2,
          7,
          1
        ],
        [
          -10,
          -5,
          3,
          4,
          6
        ]
      ],
      "expected": 102
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
      "expected": 5
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
        1
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        3,
        -1,
        -5,
        2,
        5
      ],
      [
        -2,
        -5,
        1,
        -4,
        3
      ]
    ],
    "expected": 30
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
        1,
        2,
        3
      ]
    ],
    "expected": 23
  },
  {
    "args": [
      [
        5,
        5,
        5
      ],
      [
        5,
        5
      ]
    ],
    "expected": 50
  },
  {
    "args": [
      [
        -1,
        -2,
        -3
      ],
      [
        -1,
        -2,
        -3
      ]
    ],
    "expected": 14
  },
  {
    "args": [
      [
        100,
        200,
        300
      ],
      [
        1,
        2,
        3
      ]
    ],
    "expected": 1400
  }
]$json$::jsonb,
    'approved'
),
(
    1869,
    '统计特殊子序列的数目',
    '特殊子序列由若干个 0、接着若干个 1、最后若干个 2 组成，三部分都非空
给定只含 0、1、2 的数组 nums
返回不同特殊子序列的数目，对 10^9+7 取模',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "nums = [0, 1, 2, 2]",
    "output": "3"
  },
  {
    "input": "nums = [2, 2, 0, 0]",
    "output": "0"
  },
  {
    "input": "nums = [0, 1, 2]",
    "output": "1"
  },
  {
    "input": "nums = [0, 0, 1, 1, 2, 2]",
    "output": "27"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [0, 1, 2, 2]",
    "output": "3"
  },
  {
    "input": "nums = [2, 2, 0, 0]",
    "output": "0"
  },
  {
    "input": "nums = [0, 1, 2]",
    "output": "1"
  },
  {
    "input": "nums = [0, 0, 1, 1, 2, 2]",
    "output": "27"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countSpecialSubsequences = function(nums) {\n};\n",
  "python": "class Solution:\n    def countSpecialSubsequences(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countSpecialSubsequences(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countSpecialSubsequences(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countSpecialSubsequences",
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
          2,
          2,
          0,
          0
        ]
      ],
      "expected": 0
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
          0,
          0,
          1,
          1,
          2,
          2
        ]
      ],
      "expected": 27
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
        1,
        2
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
    "expected": 0
  },
  {
    "args": [
      [
        0,
        1,
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
        2,
        0,
        1,
        2,
        2
      ]
    ],
    "expected": 19
  },
  {
    "args": [
      [
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
    1870,
    '石子游戏 III',
    'Alice 和 Bob 轮流从一排石头中取石头，Alice 先手
每名玩家每次必须从当前剩余石头的最前面取走 1 到 3 堆，得分等于取走石头的总数
双方都采用最优策略，返回最终获胜者
得分相同返回 Tie，否则返回 Alice 或 Bob',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '博弈'],
    $json$[
  {
    "input": "stoneValue = [1, 2, 3, 7]",
    "output": "\"Bob\""
  },
  {
    "input": "stoneValue = [1, 2, 3, -9]",
    "output": "\"Alice\""
  },
  {
    "input": "stoneValue = [1, 2, 3, 6]",
    "output": "\"Tie\""
  },
  {
    "input": "stoneValue = [5]",
    "output": "\"Alice\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "stoneValue = [1, 2, 3, 7]",
    "output": "\"Bob\""
  },
  {
    "input": "stoneValue = [1, 2, 3, -9]",
    "output": "\"Alice\""
  },
  {
    "input": "stoneValue = [1, 2, 3, 6]",
    "output": "\"Tie\""
  },
  {
    "input": "stoneValue = [5]",
    "output": "\"Alice\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var stoneGameIII = function(stoneValue) {\n};\n",
  "python": "class Solution:\n    def stoneGameIII(self, stoneValue: list[int]) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string stoneGameIII(std::vector<int>& stoneValue) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String stoneGameIII(int[] stoneValue) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "stoneGameIII",
  "params": [
    {
      "name": "stoneValue",
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
          1,
          2,
          3,
          7
        ]
      ],
      "expected": "Bob"
    },
    {
      "args": [
        [
          1,
          2,
          3,
          -9
        ]
      ],
      "expected": "Alice"
    },
    {
      "args": [
        [
          1,
          2,
          3,
          6
        ]
      ],
      "expected": "Tie"
    },
    {
      "args": [
        [
          5
        ]
      ],
      "expected": "Alice"
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
        -1,
        -2,
        -3,
        7
      ]
    ],
    "expected": "Alice"
  },
  {
    "args": [
      [
        -1,
        -2,
        -3
      ]
    ],
    "expected": "Tie"
  },
  {
    "args": [
      [
        0
      ]
    ],
    "expected": "Tie"
  },
  {
    "args": [
      [
        1,
        2
      ]
    ],
    "expected": "Alice"
  },
  {
    "args": [
      [
        10,
        -10,
        10,
        -10
      ]
    ],
    "expected": "Alice"
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
    "expected": "Alice"
  },
  {
    "args": [
      [
        -10,
        -10,
        -10
      ]
    ],
    "expected": "Bob"
  }
]$json$::jsonb,
    'approved'
),
(
    1871,
    '形成目标数组的子数组最少增加次数',
    '初始有一个长度与 target 相同的全零数组
每次操作可以选择一个子数组，并把其中每个元素都加一
给定目标数组 target，返回得到 target 所需的最少操作次数',
    'hard',
    1000,
    256,
    ARRAY['数组', '栈', '贪心'],
    $json$[
  {
    "input": "target = [1, 2, 3, 2, 1]",
    "output": "3"
  },
  {
    "input": "target = [3, 1, 1, 2]",
    "output": "4"
  },
  {
    "input": "target = [3, 1, 5, 4, 2]",
    "output": "7"
  },
  {
    "input": "target = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "target = [1, 2, 3, 2, 1]",
    "output": "3"
  },
  {
    "input": "target = [3, 1, 1, 2]",
    "output": "4"
  },
  {
    "input": "target = [3, 1, 5, 4, 2]",
    "output": "7"
  },
  {
    "input": "target = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minNumberOperationsTarget = function(target) {\n};\n",
  "python": "class Solution:\n    def minNumberOperationsTarget(self, target: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minNumberOperationsTarget(std::vector<int>& target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minNumberOperationsTarget(int[] target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minNumberOperationsTarget",
  "params": [
    {
      "name": "target",
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
          2,
          1
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          3,
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
          3,
          1,
          5,
          4,
          2
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
    "expected": 1
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
        1,
        3,
        2,
        4,
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
        10,
        9,
        8,
        7
      ]
    ],
    "expected": 10
  },
  {
    "args": [
      [
        1,
        10,
        1,
        10,
        1
      ]
    ],
    "expected": 19
  }
]$json$::jsonb,
    'approved'
),
(
    1872,
    '满足不等式的最大值',
    '给定按 x 严格递增排列的点 points，其中 points[i] = [x_i, y_i]，以及整数 k
选择两个不同下标 i < j，满足 x_j - x_i <= k
返回 y_i + y_j + x_j - x_i 的最大值
题目保证至少存在一对满足条件的点',
    'hard',
    1000,
    256,
    ARRAY['数组', '队列', '滑动窗口'],
    $json$[
  {
    "input": "points = [[1, 3], [2, 0], [5, 10], [6, -10]], k = 1",
    "output": "4"
  },
  {
    "input": "points = [[0, 0], [3, 0], [9, 2]], k = 3",
    "output": "3"
  },
  {
    "input": "points = [[0, 0], [1, 1], [2, 2]], k = 1",
    "output": "4"
  },
  {
    "input": "points = [[-5, 2], [0, 3], [1, 0], [3, 4]], k = 2",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "points = [[1, 3], [2, 0], [5, 10], [6, -10]], k = 1",
    "output": "4"
  },
  {
    "input": "points = [[0, 0], [3, 0], [9, 2]], k = 3",
    "output": "3"
  },
  {
    "input": "points = [[0, 0], [1, 1], [2, 2]], k = 1",
    "output": "4"
  },
  {
    "input": "points = [[-5, 2], [0, 3], [1, 0], [3, 4]], k = 2",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findMaxValueEquation = function(points, k) {\n};\n",
  "python": "class Solution:\n    def findMaxValueEquation(self, points: list[list[int]], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findMaxValueEquation(std::vector<std::vector<int>>& points, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findMaxValueEquation(int[][] points, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findMaxValueEquation",
  "params": [
    {
      "name": "points",
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
            3
          ],
          [
            2,
            0
          ],
          [
            5,
            10
          ],
          [
            6,
            -10
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
            0,
            0
          ],
          [
            3,
            0
          ],
          [
            9,
            2
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
        ],
        1
      ],
      "expected": 4
    },
    {
      "args": [
        [
          [
            -5,
            2
          ],
          [
            0,
            3
          ],
          [
            1,
            0
          ],
          [
            3,
            4
          ]
        ],
        2
      ],
      "expected": 6
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
          4
        ],
        [
          2,
          -2
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
          0,
          -5
        ],
        [
          2,
          3
        ],
        [
          4,
          1
        ]
      ],
      2
    ],
    "expected": 6
  },
  {
    "args": [
      [
        [
          -3,
          -3
        ],
        [
          0,
          1
        ],
        [
          2,
          -1
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
          0
        ],
        [
          2,
          10
        ],
        [
          3,
          1
        ],
        [
          4,
          2
        ]
      ],
      2
    ],
    "expected": 14
  },
  {
    "args": [
      [
        [
          -10,
          5
        ],
        [
          -9,
          3
        ],
        [
          -8,
          1
        ]
      ],
      1
    ],
    "expected": 9
  },
  {
    "args": [
      [
        [
          0,
          100
        ],
        [
          1,
          1
        ],
        [
          2,
          50
        ]
      ],
      2
    ],
    "expected": 152
  }
]$json$::jsonb,
    'approved'
),
(
    1873,
    '从先序遍历还原二叉树',
    '给定二叉树先序遍历的字符串 traversal
数字表示节点值，若干个连续的 ''-'' 表示该节点的深度，根节点深度为 0
请根据字符串还原这棵二叉树，并按层序返回
空节点用 null 表示，末尾多余的 null 不输出',
    'hard',
    1000,
    256,
    ARRAY['栈', '树', '二叉树'],
    $json$[
  {
    "input": "traversal = \"1-2--3--4-5--6--7\"",
    "output": "[1, 2, 5, 3, 4, 6, 7]"
  },
  {
    "input": "traversal = \"1-2--3---4----5\"",
    "output": "[1, 2, null, 3, null, 4, null, 5]"
  },
  {
    "input": "traversal = \"1-401--349---90--88\"",
    "output": "[1, 401, null, 349, 88, 90]"
  },
  {
    "input": "traversal = \"1\"",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "traversal = \"1-2--3--4-5--6--7\"",
    "output": "[1, 2, 5, 3, 4, 6, 7]"
  },
  {
    "input": "traversal = \"1-2--3---4----5\"",
    "output": "[1, 2, null, 3, null, 4, null, 5]"
  },
  {
    "input": "traversal = \"1-401--349---90--88\"",
    "output": "[1, 401, null, 349, 88, 90]"
  },
  {
    "input": "traversal = \"1\"",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar recoverFromPreorder = function(traversal) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def recoverFromPreorder(self, traversal: str) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* recoverFromPreorder(std::string traversal) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode recoverFromPreorder(String traversal) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "recoverFromPreorder",
  "params": [
    {
      "name": "traversal",
      "type": "string"
    }
  ],
  "return_type": "TreeNode",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "1-2--3--4-5--6--7"
      ],
      "expected": [
        1,
        2,
        5,
        3,
        4,
        6,
        7
      ]
    },
    {
      "args": [
        "1-2--3---4----5"
      ],
      "expected": [
        1,
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
        "1-401--349---90--88"
      ],
      "expected": [
        1,
        401,
        null,
        349,
        88,
        90
      ]
    },
    {
      "args": [
        "1"
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
      "1-2--3"
    ],
    "expected": [
      1,
      2,
      null,
      3
    ]
  },
  {
    "args": [
      "1-2-3"
    ],
    "expected": [
      1,
      2,
      3
    ]
  },
  {
    "args": [
      "5"
    ],
    "expected": [
      5
    ]
  },
  {
    "args": [
      "1-2--3--4"
    ],
    "expected": [
      1,
      2,
      null,
      3,
      4
    ]
  },
  {
    "args": [
      "1-2--3---4"
    ],
    "expected": [
      1,
      2,
      null,
      3,
      null,
      4
    ]
  },
  {
    "args": [
      "1-2--3--4-5"
    ],
    "expected": [
      1,
      2,
      5,
      3,
      4
    ]
  },
  {
    "args": [
      "9-8--7-6--5--4"
    ],
    "expected": [
      9,
      8,
      6,
      7,
      null,
      5,
      4
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1874,
    '最大的团队表现值',
    '给定 n 名工程师的速度 speed 和效率 efficiency，以及整数 k
选择至多 k 名工程师组成团队
团队表现值等于团队速度之和乘以团队中最小的效率
返回最大表现值，对 10^9+7 取模',
    'hard',
    1000,
    256,
    ARRAY['数组', '排序', '堆'],
    $json$[
  {
    "input": "n = 6, speed = [2, 10, 3, 1, 5, 8], efficiency = [5, 4, 3, 9, 7, 2], k = 2",
    "output": "60"
  },
  {
    "input": "n = 6, speed = [2, 10, 3, 1, 5, 8], efficiency = [5, 4, 3, 9, 7, 2], k = 3",
    "output": "68"
  },
  {
    "input": "n = 6, speed = [2, 10, 3, 1, 5, 8], efficiency = [5, 4, 3, 9, 7, 2], k = 4",
    "output": "72"
  },
  {
    "input": "n = 1, speed = [5], efficiency = [7], k = 1",
    "output": "35"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 6, speed = [2, 10, 3, 1, 5, 8], efficiency = [5, 4, 3, 9, 7, 2], k = 2",
    "output": "60"
  },
  {
    "input": "n = 6, speed = [2, 10, 3, 1, 5, 8], efficiency = [5, 4, 3, 9, 7, 2], k = 3",
    "output": "68"
  },
  {
    "input": "n = 6, speed = [2, 10, 3, 1, 5, 8], efficiency = [5, 4, 3, 9, 7, 2], k = 4",
    "output": "72"
  },
  {
    "input": "n = 1, speed = [5], efficiency = [7], k = 1",
    "output": "35"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxPerformanceTeam = function(n, speed, efficiency, k) {\n};\n",
  "python": "class Solution:\n    def maxPerformanceTeam(self, n: int, speed: list[int], efficiency: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxPerformanceTeam(int n, std::vector<int>& speed, std::vector<int>& efficiency, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxPerformanceTeam(int n, int[] speed, int[] efficiency, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxPerformanceTeam",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "speed",
      "type": "int[]"
    },
    {
      "name": "efficiency",
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
        6,
        [
          2,
          10,
          3,
          1,
          5,
          8
        ],
        [
          5,
          4,
          3,
          9,
          7,
          2
        ],
        2
      ],
      "expected": 60
    },
    {
      "args": [
        6,
        [
          2,
          10,
          3,
          1,
          5,
          8
        ],
        [
          5,
          4,
          3,
          9,
          7,
          2
        ],
        3
      ],
      "expected": 68
    },
    {
      "args": [
        6,
        [
          2,
          10,
          3,
          1,
          5,
          8
        ],
        [
          5,
          4,
          3,
          9,
          7,
          2
        ],
        4
      ],
      "expected": 72
    },
    {
      "args": [
        1,
        [
          5
        ],
        [
          7
        ],
        1
      ],
      "expected": 35
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2,
      [
        1,
        1
      ],
      [
        1,
        1
      ],
      2
    ],
    "expected": 2
  },
  {
    "args": [
      3,
      [
        10,
        1,
        1
      ],
      [
        5,
        5,
        5
      ],
      2
    ],
    "expected": 55
  },
  {
    "args": [
      5,
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
        4,
        5
      ],
      1
    ],
    "expected": 25
  },
  {
    "args": [
      4,
      [
        4,
        5,
        6,
        7
      ],
      [
        8,
        7,
        6,
        5
      ],
      2
    ],
    "expected": 66
  },
  {
    "args": [
      3,
      [
        100,
        80,
        60
      ],
      [
        2,
        3,
        5
      ],
      3
    ],
    "expected": 480
  },
  {
    "args": [
      5,
      [
        1,
        1,
        1,
        1,
        1
      ],
      [
        100,
        90,
        80,
        70,
        60
      ],
      3
    ],
    "expected": 240
  }
]$json$::jsonb,
    'approved'
),
(
    1875,
    '找到处理最多请求的服务器',
    '有 k 个编号从 0 到 k-1 的服务器
第 i 个请求在 arrival[i] 到达，需要 load[i] 时间处理
服务器空闲时，必须选择编号不小于 i mod k 的最小空闲服务器
若不存在这样的服务器，则选择编号最小的空闲服务器
若仍没有空闲服务器，则丢弃该请求
返回处理请求数最多的服务器编号列表，按编号升序',
    'hard',
    1000,
    256,
    ARRAY['数组', '堆', '有序集合'],
    $json$[
  {
    "input": "k = 3, arrival = [1, 2, 3, 4, 5], load = [5, 2, 3, 3, 3]",
    "output": "[1]"
  },
  {
    "input": "k = 3, arrival = [1, 2, 3, 4], load = [1, 2, 1, 2]",
    "output": "[0]"
  },
  {
    "input": "k = 1, arrival = [1], load = [1]",
    "output": "[0]"
  },
  {
    "input": "k = 2, arrival = [1, 1, 1], load = [5, 2, 1]",
    "output": "[0, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "k = 3, arrival = [1, 2, 3, 4, 5], load = [5, 2, 3, 3, 3]",
    "output": "[1]"
  },
  {
    "input": "k = 3, arrival = [1, 2, 3, 4], load = [1, 2, 1, 2]",
    "output": "[0]"
  },
  {
    "input": "k = 1, arrival = [1], load = [1]",
    "output": "[0]"
  },
  {
    "input": "k = 2, arrival = [1, 1, 1], load = [5, 2, 1]",
    "output": "[0, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var busiestServers = function(k, arrival, load) {\n};\n",
  "python": "class Solution:\n    def busiestServers(self, k: int, arrival: list[int], load: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> busiestServers(int k, std::vector<int>& arrival, std::vector<int>& load) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] busiestServers(int k, int[] arrival, int[] load) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "busiestServers",
  "params": [
    {
      "name": "k",
      "type": "int"
    },
    {
      "name": "arrival",
      "type": "int[]"
    },
    {
      "name": "load",
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
        3,
        [
          1,
          2,
          3,
          4,
          5
        ],
        [
          5,
          2,
          3,
          3,
          3
        ]
      ],
      "expected": [
        1
      ]
    },
    {
      "args": [
        3,
        [
          1,
          2,
          3,
          4
        ],
        [
          1,
          2,
          1,
          2
        ]
      ],
      "expected": [
        0
      ]
    },
    {
      "args": [
        1,
        [
          1
        ],
        [
          1
        ]
      ],
      "expected": [
        0
      ]
    },
    {
      "args": [
        2,
        [
          1,
          1,
          1
        ],
        [
          5,
          2,
          1
        ]
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
      3,
      [
        1,
        2,
        3,
        4,
        8,
        9,
        10
      ],
      [
        5,
        2,
        2,
        3,
        1,
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
      2,
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
    "expected": [
      0,
      1
    ]
  },
  {
    "args": [
      4,
      [
        1,
        2,
        3,
        4,
        5,
        6
      ],
      [
        10,
        10,
        10,
        10,
        10,
        10
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
      [
        1,
        2,
        3
      ],
      [
        1,
        1,
        1
      ]
    ],
    "expected": [
      0
    ]
  },
  {
    "args": [
      2,
      [
        1,
        2,
        3,
        4,
        5
      ],
      [
        1,
        1,
        1,
        1,
        1
      ]
    ],
    "expected": [
      0
    ]
  },
  {
    "args": [
      3,
      [
        5,
        5,
        5,
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
      0,
      1,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1876,
    '包含每个查询的最小区间',
    '给定若干闭区间 intervals 和查询数组 queries
对于每个查询 q，找出所有包含 q 的区间中长度最小的区间，返回该区间的长度
若没有区间包含 q，返回 -1
答案按 queries 中原有的顺序返回',
    'hard',
    1000,
    256,
    ARRAY['数组', '排序', '堆'],
    $json$[
  {
    "input": "intervals = [[1, 4], [2, 4], [3, 6], [4, 4]], queries = [2, 3, 4, 5]",
    "output": "[3, 3, 1, 4]"
  },
  {
    "input": "intervals = [[2, 3], [2, 5], [1, 8], [20, 25]], queries = [2, 19, 5, 22]",
    "output": "[2, -1, 4, 6]"
  },
  {
    "input": "intervals = [[1, 1]], queries = [1]",
    "output": "[1]"
  },
  {
    "input": "intervals = [[1, 5], [3, 7], [8, 9]], queries = [4, 7, 10]",
    "output": "[5, 5, -1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "intervals = [[1, 4], [2, 4], [3, 6], [4, 4]], queries = [2, 3, 4, 5]",
    "output": "[3, 3, 1, 4]"
  },
  {
    "input": "intervals = [[2, 3], [2, 5], [1, 8], [20, 25]], queries = [2, 19, 5, 22]",
    "output": "[2, -1, 4, 6]"
  },
  {
    "input": "intervals = [[1, 1]], queries = [1]",
    "output": "[1]"
  },
  {
    "input": "intervals = [[1, 5], [3, 7], [8, 9]], queries = [4, 7, 10]",
    "output": "[5, 5, -1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestRangeQueries = function(intervals, queries) {\n};\n",
  "python": "class Solution:\n    def smallestRangeQueries(self, intervals: list[list[int]], queries: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> smallestRangeQueries(std::vector<std::vector<int>>& intervals, std::vector<int>& queries) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] smallestRangeQueries(int[][] intervals, int[] queries) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestRangeQueries",
  "params": [
    {
      "name": "intervals",
      "type": "int[][]"
    },
    {
      "name": "queries",
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
            4
          ],
          [
            2,
            4
          ],
          [
            3,
            6
          ],
          [
            4,
            4
          ]
        ],
        [
          2,
          3,
          4,
          5
        ]
      ],
      "expected": [
        3,
        3,
        1,
        4
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
            2,
            5
          ],
          [
            1,
            8
          ],
          [
            20,
            25
          ]
        ],
        [
          2,
          19,
          5,
          22
        ]
      ],
      "expected": [
        2,
        -1,
        4,
        6
      ]
    },
    {
      "args": [
        [
          [
            1,
            1
          ]
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
          [
            1,
            5
          ],
          [
            3,
            7
          ],
          [
            8,
            9
          ]
        ],
        [
          4,
          7,
          10
        ]
      ],
      "expected": [
        5,
        5,
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
    "expected": [
      2,
      2,
      2
    ]
  },
  {
    "args": [
      [
        [
          1,
          10
        ]
      ],
      [
        0,
        11
      ]
    ],
    "expected": [
      -1,
      -1
    ]
  },
  {
    "args": [
      [
        [
          5,
          5
        ]
      ],
      [
        5
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
          3
        ],
        [
          2,
          2
        ]
      ],
      [
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
      ],
      [
        3,
        4
      ]
    ],
    "expected": [
      4,
      4
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
          15,
          25
        ],
        [
          5,
          15
        ]
      ],
      [
        12,
        18,
        22
      ]
    ],
    "expected": [
      11,
      11,
      11
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1877,
    '网格中的最短路径',
    '给定 m 行 n 列的网格 grid，0 表示空地，1 表示障碍
从左上角出发，每次可以向上、下、左、右移动一步，最多可以消除 k 个障碍
返回到达右下角所需的最少步数
如果无法到达，返回 -1',
    'hard',
    1000,
    256,
    ARRAY['图', '广度优先搜索', '数组'],
    $json$[
  {
    "input": "grid = [[0, 0, 0], [1, 1, 0], [0, 0, 0], [0, 1, 1], [0, 0, 0]], k = 1",
    "output": "6"
  },
  {
    "input": "grid = [[0, 1, 1], [1, 1, 1], [1, 0, 0]], k = 1",
    "output": "-1"
  },
  {
    "input": "grid = [[0, 0], [0, 0]], k = 0",
    "output": "2"
  },
  {
    "input": "grid = [[0, 1, 0, 1], [0, 1, 0, 0], [0, 0, 0, 0]], k = 1",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[0, 0, 0], [1, 1, 0], [0, 0, 0], [0, 1, 1], [0, 0, 0]], k = 1",
    "output": "6"
  },
  {
    "input": "grid = [[0, 1, 1], [1, 1, 1], [1, 0, 0]], k = 1",
    "output": "-1"
  },
  {
    "input": "grid = [[0, 0], [0, 0]], k = 0",
    "output": "2"
  },
  {
    "input": "grid = [[0, 1, 0, 1], [0, 1, 0, 0], [0, 0, 0, 0]], k = 1",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var shortestPathGrid = function(grid, k) {\n};\n",
  "python": "class Solution:\n    def shortestPathGrid(self, grid: list[list[int]], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int shortestPathGrid(std::vector<std::vector<int>>& grid, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int shortestPathGrid(int[][] grid, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "shortestPathGrid",
  "params": [
    {
      "name": "grid",
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
            0,
            0,
            0
          ],
          [
            0,
            1,
            1
          ],
          [
            0,
            0,
            0
          ]
        ],
        1
      ],
      "expected": 6
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
            0,
            0
          ]
        ],
        1
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
        ],
        0
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            0,
            1,
            0,
            1
          ],
          [
            0,
            1,
            0,
            0
          ],
          [
            0,
            0,
            0,
            0
          ]
        ],
        1
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
      ],
      0
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
      ],
      0
    ],
    "expected": 4
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
      ],
      1
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
      ],
      1
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          0,
          0,
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
          1,
          0
        ],
        [
          0,
          0,
          0,
          0,
          0,
          0
        ]
      ],
      1
    ],
    "expected": 7
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
          0,
          1,
          1
        ],
        [
          0,
          0,
          0
        ]
      ],
      2
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1878,
    '规定时间内到达终点的最小花费',
    '给定无向图，edges[i] = [u, v, time] 表示一条通行时间为 time 的边
passingFees[i] 表示经过节点 i 需要支付的费用，起点和终点也需要支付
从节点 0 出发，在不超过 maxTime 的时间内到达节点 n-1
返回最小总费用
如果无法按时到达，返回 -1',
    'hard',
    1000,
    256,
    ARRAY['图', '最短路', '动态规划'],
    $json$[
  {
    "input": "maxTime = 30, edges = [[0, 1, 10], [1, 2, 10], [2, 5, 10], [0, 3, 1], [3, 4, 10], [4, 5, 10]], passingFees = [5, 1, 2, 20, 20, 3]",
    "output": "11"
  },
  {
    "input": "maxTime = 29, edges = [[0, 1, 10], [1, 2, 10], [2, 5, 10], [0, 3, 1], [3, 4, 10], [4, 5, 10]], passingFees = [5, 1, 2, 20, 20, 3]",
    "output": "48"
  },
  {
    "input": "maxTime = 25, edges = [[0, 1, 10], [1, 2, 10], [2, 5, 10], [0, 3, 1], [3, 4, 10], [4, 5, 10]], passingFees = [5, 1, 2, 20, 20, 3]",
    "output": "48"
  },
  {
    "input": "maxTime = 2, edges = [[0, 1, 1]], passingFees = [2, 3]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "maxTime = 30, edges = [[0, 1, 10], [1, 2, 10], [2, 5, 10], [0, 3, 1], [3, 4, 10], [4, 5, 10]], passingFees = [5, 1, 2, 20, 20, 3]",
    "output": "11"
  },
  {
    "input": "maxTime = 29, edges = [[0, 1, 10], [1, 2, 10], [2, 5, 10], [0, 3, 1], [3, 4, 10], [4, 5, 10]], passingFees = [5, 1, 2, 20, 20, 3]",
    "output": "48"
  },
  {
    "input": "maxTime = 25, edges = [[0, 1, 10], [1, 2, 10], [2, 5, 10], [0, 3, 1], [3, 4, 10], [4, 5, 10]], passingFees = [5, 1, 2, 20, 20, 3]",
    "output": "48"
  },
  {
    "input": "maxTime = 2, edges = [[0, 1, 1]], passingFees = [2, 3]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minCostReachDestination = function(maxTime, edges, passingFees) {\n};\n",
  "python": "class Solution:\n    def minCostReachDestination(self, maxTime: int, edges: list[list[int]], passingFees: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minCostReachDestination(int maxTime, std::vector<std::vector<int>>& edges, std::vector<int>& passingFees) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minCostReachDestination(int maxTime, int[][] edges, int[] passingFees) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minCostReachDestination",
  "params": [
    {
      "name": "maxTime",
      "type": "int"
    },
    {
      "name": "edges",
      "type": "int[][]"
    },
    {
      "name": "passingFees",
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
        30,
        [
          [
            0,
            1,
            10
          ],
          [
            1,
            2,
            10
          ],
          [
            2,
            5,
            10
          ],
          [
            0,
            3,
            1
          ],
          [
            3,
            4,
            10
          ],
          [
            4,
            5,
            10
          ]
        ],
        [
          5,
          1,
          2,
          20,
          20,
          3
        ]
      ],
      "expected": 11
    },
    {
      "args": [
        29,
        [
          [
            0,
            1,
            10
          ],
          [
            1,
            2,
            10
          ],
          [
            2,
            5,
            10
          ],
          [
            0,
            3,
            1
          ],
          [
            3,
            4,
            10
          ],
          [
            4,
            5,
            10
          ]
        ],
        [
          5,
          1,
          2,
          20,
          20,
          3
        ]
      ],
      "expected": 48
    },
    {
      "args": [
        25,
        [
          [
            0,
            1,
            10
          ],
          [
            1,
            2,
            10
          ],
          [
            2,
            5,
            10
          ],
          [
            0,
            3,
            1
          ],
          [
            3,
            4,
            10
          ],
          [
            4,
            5,
            10
          ]
        ],
        [
          5,
          1,
          2,
          20,
          20,
          3
        ]
      ],
      "expected": 48
    },
    {
      "args": [
        2,
        [
          [
            0,
            1,
            1
          ]
        ],
        [
          2,
          3
        ]
      ],
      "expected": 5
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      [
        [
          0,
          1,
          1
        ]
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
      10,
      [
        [
          0,
          1,
          10
        ],
        [
          1,
          2,
          10
        ]
      ],
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
      4,
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
        ],
        [
          0,
          2,
          5
        ]
      ],
      [
        1,
        10,
        1
      ]
    ],
    "expected": 12
  },
  {
    "args": [
      5,
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
        ],
        [
          0,
          2,
          5
        ]
      ],
      [
        1,
        10,
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      10,
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
        ],
        [
          2,
          3,
          1
        ],
        [
          0,
          3,
          10
        ]
      ],
      [
        2,
        1,
        3,
        1
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      6,
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
      [
        1,
        10,
        1,
        1
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1879,
    '找到最小生成树里的关键边和伪关键边',
    '给定 n 个节点的无向连通图，edges[i] = [u, v, w]
关键边：从图中删除后会使命中最小生成树总权重增大或无法形成生成树的边
伪关键边：不是关键边，但存在于至少一棵最小生成树中的边
返回 [所有关键边编号, 所有伪关键边编号]
编号即 edges 的下标，两个列表都按编号升序排列',
    'hard',
    1000,
    256,
    ARRAY['图', '并查集', '最小生成树'],
    $json$[
  {
    "input": "n = 5, edges = [[0, 1, 1], [1, 2, 1], [2, 3, 2], [0, 3, 2], [0, 4, 3], [3, 4, 3], [1, 4, 6]]",
    "output": "[[0, 1], [2, 3, 4, 5]]"
  },
  {
    "input": "n = 4, edges = [[0, 1, 1], [1, 2, 1], [2, 3, 1], [0, 3, 1]]",
    "output": "[[], [0, 1, 2, 3]]"
  },
  {
    "input": "n = 2, edges = [[0, 1, 1]]",
    "output": "[[0], []]"
  },
  {
    "input": "n = 6, edges = [[0, 1, 1], [1, 2, 1], [2, 3, 1], [3, 4, 1], [4, 5, 1], [0, 5, 2]]",
    "output": "[[0, 1, 2, 3, 4], []]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5, edges = [[0, 1, 1], [1, 2, 1], [2, 3, 2], [0, 3, 2], [0, 4, 3], [3, 4, 3], [1, 4, 6]]",
    "output": "[[0, 1], [2, 3, 4, 5]]"
  },
  {
    "input": "n = 4, edges = [[0, 1, 1], [1, 2, 1], [2, 3, 1], [0, 3, 1]]",
    "output": "[[], [0, 1, 2, 3]]"
  },
  {
    "input": "n = 2, edges = [[0, 1, 1]]",
    "output": "[[0], []]"
  },
  {
    "input": "n = 6, edges = [[0, 1, 1], [1, 2, 1], [2, 3, 1], [3, 4, 1], [4, 5, 1], [0, 5, 2]]",
    "output": "[[0, 1, 2, 3, 4], []]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findCriticalPseudoCriticalEdges = function(n, edges) {\n};\n",
  "python": "class Solution:\n    def findCriticalPseudoCriticalEdges(self, n: int, edges: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> findCriticalPseudoCriticalEdges(int n, std::vector<std::vector<int>>& edges) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] findCriticalPseudoCriticalEdges(int n, int[][] edges) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findCriticalPseudoCriticalEdges",
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
  "return_type": "int[][]",
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
            1,
            1
          ],
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
            0,
            3,
            2
          ],
          [
            0,
            4,
            3
          ],
          [
            3,
            4,
            3
          ],
          [
            1,
            4,
            6
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
          3,
          4,
          5
        ]
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
            0,
            3,
            1
          ]
        ]
      ],
      "expected": [
        [],
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
        2,
        [
          [
            0,
            1,
            1
          ]
        ]
      ],
      "expected": [
        [
          0
        ],
        []
      ]
    },
    {
      "args": [
        6,
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
          ],
          [
            4,
            5,
            1
          ],
          [
            0,
            5,
            2
          ]
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
        []
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
          1,
          1
        ],
        [
          1,
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
      [
        0,
        1
      ],
      []
    ]
  },
  {
    "args": [
      5,
      [
        [
          0,
          1,
          2
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
        ],
        [
          2,
          3,
          3
        ],
        [
          3,
          4,
          3
        ],
        [
          1,
          4,
          5
        ]
      ]
    ],
    "expected": [
      [
        3,
        4
      ],
      [
        0,
        1,
        2
      ]
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
          1,
          2,
          2
        ],
        [
          2,
          3,
          3
        ],
        [
          0,
          3,
          6
        ],
        [
          0,
          2,
          4
        ],
        [
          1,
          3,
          5
        ]
      ]
    ],
    "expected": [
      [
        0,
        1,
        2
      ],
      []
    ]
  },
  {
    "args": [
      6,
      [
        [
          0,
          1,
          4
        ],
        [
          0,
          2,
          1
        ],
        [
          1,
          2,
          2
        ],
        [
          2,
          3,
          5
        ],
        [
          3,
          4,
          1
        ],
        [
          4,
          5,
          3
        ],
        [
          2,
          5,
          6
        ],
        [
          1,
          5,
          7
        ]
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
      []
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
          1
        ],
        [
          1,
          2,
          1
        ]
      ]
    ],
    "expected": [
      [],
      [
        0,
        1,
        2
      ]
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
          0,
          1
        ],
        [
          0,
          2,
          1
        ],
        [
          1,
          3,
          1
        ]
      ]
    ],
    "expected": [
      [],
      [
        0,
        1,
        2,
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
    1880,
    '将子数组重新排序得到同一个二叉查找树的方案数',
    '给定一个由互不相同的整数组成的数组 nums。
把 nums 按给定顺序依次插入一棵初始为空的二叉查找树，可以得到一棵确定的树。
现在可以任意重排 nums，问有多少种重排结果插入后得到的二叉查找树与原数组顺序得到的树完全相同。
答案对 10^9 + 7 取模。
数组长度不超过 1000。',
    'hard',
    1000,
    256,
    ARRAY['树', '二叉搜索树', '组合数学', '递归'],
    $json$[
  {
    "input": "nums = [2, 1, 3]",
    "output": "2"
  },
  {
    "input": "nums = [3, 4, 5, 1, 2]",
    "output": "6"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "1"
  },
  {
    "input": "nums = [10, 20, 30, 40]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 1, 3]",
    "output": "2"
  },
  {
    "input": "nums = [3, 4, 5, 1, 2]",
    "output": "6"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "1"
  },
  {
    "input": "nums = [10, 20, 30, 40]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var bstReorderWays = function(nums) {\n};\n",
  "python": "class Solution:\n    def bstReorderWays(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int bstReorderWays(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int bstReorderWays(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "bstReorderWays",
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
          3
        ]
      ],
      "expected": 2
    },
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
    "expected": 1
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
    "expected": 1
  },
  {
    "args": [
      [
        3,
        1,
        5,
        2,
        4
      ]
    ],
    "expected": 6
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
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1881,
    '连通两组点的最小成本',
    '给定 m x n 的整数矩阵 cost。
cost[i][j] 表示把第一组第 i 个点与第二组第 j 个点相连的代价。
需要让第一组的每个点至少与第二组中的某个点相连，同时第二组的每个点也至少与第一组中的某个点相连。
点对之间可以重复连接，求完成要求的最小总代价。
m 和 n 均不超过 12。',
    'hard',
    1000,
    256,
    ARRAY['动态规划', '状态压缩', '图'],
    $json$[
  {
    "input": "cost = [[15, 96], [36, 2]]",
    "output": "17"
  },
  {
    "input": "cost = [[1, 3, 5], [4, 1, 1], [1, 5, 3]]",
    "output": "4"
  },
  {
    "input": "cost = [[2, 5, 1], [3, 4, 7], [8, 1, 2], [6, 2, 4], [3, 8, 9]]",
    "output": "10"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "cost = [[15, 96], [36, 2]]",
    "output": "17"
  },
  {
    "input": "cost = [[1, 3, 5], [4, 1, 1], [1, 5, 3]]",
    "output": "4"
  },
  {
    "input": "cost = [[2, 5, 1], [3, 4, 7], [8, 1, 2], [6, 2, 4], [3, 8, 9]]",
    "output": "10"
  }
]$json$::jsonb,
    $json${
  "javascript": "var connectTwoGroups = function(cost) {\n};\n",
  "python": "class Solution:\n    def connectTwoGroups(self, cost: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int connectTwoGroups(std::vector<std::vector<int>>& cost) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int connectTwoGroups(int[][] cost) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "connectTwoGroups",
  "params": [
    {
      "name": "cost",
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
            15,
            96
          ],
          [
            36,
            2
          ]
        ]
      ],
      "expected": 17
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
            4,
            1,
            1
          ],
          [
            1,
            5,
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
            2,
            5,
            1
          ],
          [
            3,
            4,
            7
          ],
          [
            8,
            1,
            2
          ],
          [
            6,
            2,
            4
          ],
          [
            3,
            8,
            9
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
          1,
          2
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
    "expected": 2
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
          6
        ]
      ]
    ],
    "expected": 8
  },
  {
    "args": [
      [
        [
          5,
          2
        ],
        [
          3,
          7
        ],
        [
          9,
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
        ],
        [
          10,
          11,
          12
        ]
      ]
    ],
    "expected": 23
  }
]$json$::jsonb,
    'approved'
),
(
    1882,
    '第 K 条最小指令',
    '从坐标 (0, 0) 出发，目标是到达 (row, column)。
每次可以向右走一格，指令记为 H；或向上走一格，指令记为 V。
一条指令序列中恰好包含 column 个 H 和 row 个 V。
按字典序比较所有这样的指令序列，其中 H 排在 V 前面。
返回字典序第 k 小的指令序列，k 从 1 开始。
row、column 不超过 30。',
    'hard',
    1000,
    256,
    ARRAY['数学', '组合数学', '贪心'],
    $json$[
  {
    "input": "row = 2, column = 3, k = 1",
    "output": "\"HHHVV\""
  },
  {
    "input": "row = 2, column = 3, k = 2",
    "output": "\"HHVHV\""
  },
  {
    "input": "row = 2, column = 3, k = 3",
    "output": "\"HHVVH\""
  },
  {
    "input": "row = 1, column = 1, k = 1",
    "output": "\"HV\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "row = 2, column = 3, k = 1",
    "output": "\"HHHVV\""
  },
  {
    "input": "row = 2, column = 3, k = 2",
    "output": "\"HHVHV\""
  },
  {
    "input": "row = 2, column = 3, k = 3",
    "output": "\"HHVVH\""
  },
  {
    "input": "row = 1, column = 1, k = 1",
    "output": "\"HV\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var kthSmallestPath = function(row, column, k) {\n};\n",
  "python": "class Solution:\n    def kthSmallestPath(self, row: int, column: int, k: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string kthSmallestPath(int row, int column, int k) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String kthSmallestPath(int row, int column, int k) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kthSmallestPath",
  "params": [
    {
      "name": "row",
      "type": "int"
    },
    {
      "name": "column",
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
        2,
        3,
        1
      ],
      "expected": "HHHVV"
    },
    {
      "args": [
        2,
        3,
        2
      ],
      "expected": "HHVHV"
    },
    {
      "args": [
        2,
        3,
        3
      ],
      "expected": "HHVVH"
    },
    {
      "args": [
        1,
        1,
        1
      ],
      "expected": "HV"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      0,
      1,
      1
    ],
    "expected": "H"
  },
  {
    "args": [
      1,
      0,
      1
    ],
    "expected": "V"
  },
  {
    "args": [
      3,
      1,
      2
    ],
    "expected": "VHVV"
  },
  {
    "args": [
      2,
      2,
      4
    ],
    "expected": "VHHV"
  },
  {
    "args": [
      3,
      3,
      1
    ],
    "expected": "HHHVVV"
  },
  {
    "args": [
      3,
      3,
      20
    ],
    "expected": "VVVHHH"
  },
  {
    "args": [
      0,
      5,
      1
    ],
    "expected": "HHHHH"
  },
  {
    "args": [
      5,
      0,
      1
    ],
    "expected": "VVVVV"
  }
]$json$::jsonb,
    'approved'
),
(
    1883,
    '得到山形数组的最少删除次数',
    '给定整数数组 nums。
山形数组要求存在一个峰值下标 i，满足 0 < i < 长度 - 1，
且 nums[0] < nums[1] < ... < nums[i] 严格递增，
nums[i] > nums[i + 1] > ... > nums[长度 - 1] 严格递减。
可以删除任意数量的元素，保留元素的相对顺序。
返回使剩余数组成为山形数组的最少删除次数；无法做到返回 -1。
数组长度不超过 1000。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '最长递增子序列'],
    $json$[
  {
    "input": "nums = [1, 3, 1]",
    "output": "0"
  },
  {
    "input": "nums = [2, 1, 1, 5, 6, 2, 3, 1]",
    "output": "3"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "-1"
  },
  {
    "input": "nums = [1, 2, 3, 4, 4, 3, 2, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3, 1]",
    "output": "0"
  },
  {
    "input": "nums = [2, 1, 1, 5, 6, 2, 3, 1]",
    "output": "3"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "-1"
  },
  {
    "input": "nums = [1, 2, 3, 4, 4, 3, 2, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumMountainRemovals = function(nums) {\n};\n",
  "python": "class Solution:\n    def minimumMountainRemovals(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumMountainRemovals(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumMountainRemovals(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumMountainRemovals",
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
          1
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          2,
          1,
          1,
          5,
          6,
          2,
          3,
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
      "expected": -1
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
        3,
        4,
        5
      ]
    ],
    "expected": -1
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
    "expected": -1
  },
  {
    "args": [
      [
        1,
        5,
        3
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        2,
        3,
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
    "expected": -1
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
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1884,
    '堆叠长方体的最大高度',
    '给定若干个长方体，每个长方体用三条棱的长度 [a, b, c] 表示。
每个长方体可以任意旋转，旋转后把三条棱按从小到大排列，记作 (x, y, z)。
可以把长方体竖直堆叠，要求下方长方体的 x、y、z 分别不小于上方长方体的 x、y、z。
求堆叠后能达到的最大总高度，高度为最上方长方体的 z 值之和。
长方体数量不超过 100，棱长不超过 100。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '排序'],
    $json$[
  {
    "input": "cuboids = [[50, 45, 20], [95, 37, 53], [45, 23, 12]]",
    "output": "190"
  },
  {
    "input": "cuboids = [[38, 25, 45], [76, 35, 3]]",
    "output": "76"
  },
  {
    "input": "cuboids = [[7, 11, 17], [7, 17, 11], [11, 17, 7], [17, 7, 11], [17, 11, 7], [11, 7, 17]]",
    "output": "102"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "cuboids = [[50, 45, 20], [95, 37, 53], [45, 23, 12]]",
    "output": "190"
  },
  {
    "input": "cuboids = [[38, 25, 45], [76, 35, 3]]",
    "output": "76"
  },
  {
    "input": "cuboids = [[7, 11, 17], [7, 17, 11], [11, 17, 7], [17, 7, 11], [17, 11, 7], [11, 7, 17]]",
    "output": "102"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxCuboidHeight = function(cuboids) {\n};\n",
  "python": "class Solution:\n    def maxCuboidHeight(self, cuboids: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxCuboidHeight(std::vector<std::vector<int>>& cuboids) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxCuboidHeight(int[][] cuboids) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxCuboidHeight",
  "params": [
    {
      "name": "cuboids",
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
            50,
            45,
            20
          ],
          [
            95,
            37,
            53
          ],
          [
            45,
            23,
            12
          ]
        ]
      ],
      "expected": 190
    },
    {
      "args": [
        [
          [
            38,
            25,
            45
          ],
          [
            76,
            35,
            3
          ]
        ]
      ],
      "expected": 76
    },
    {
      "args": [
        [
          [
            7,
            11,
            17
          ],
          [
            7,
            17,
            11
          ],
          [
            11,
            17,
            7
          ],
          [
            17,
            7,
            11
          ],
          [
            17,
            11,
            7
          ],
          [
            11,
            7,
            17
          ]
        ]
      ],
      "expected": 102
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
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          10,
          10,
          10
        ],
        [
          10,
          10,
          10
        ]
      ]
    ],
    "expected": 20
  },
  {
    "args": [
      [
        [
          2,
          3,
          4
        ],
        [
          1,
          2,
          3
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
          100,
          1
        ],
        [
          2,
          3,
          4
        ],
        [
          5,
          6,
          7
        ]
      ]
    ],
    "expected": 100
  },
  {
    "args": [
      [
        [
          6,
          7,
          8
        ],
        [
          9,
          10,
          11
        ],
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
    "expected": 28
  }
]$json$::jsonb,
    'approved'
),
(
    1885,
    '生成乘积数组的方案数',
    '给定若干查询，每个查询为 [n, k]。
对每个查询，统计长度为 k 的正整数数组的个数，使得所有元素的乘积恰好等于 n。
数组元素顺序不同视为不同方案。
返回一个数组，按输入查询的顺序给出每个查询的答案，答案对 10^9 + 7 取模。
n 不超过 10000，k 不超过 10000。',
    'hard',
    1000,
    256,
    ARRAY['数组', '数学', '组合数学', '数论'],
    $json$[
  {
    "input": "queries = [[2, 3]]",
    "output": "[3]"
  },
  {
    "input": "queries = [[5, 1]]",
    "output": "[1]"
  },
  {
    "input": "queries = [[4, 2]]",
    "output": "[3]"
  },
  {
    "input": "queries = [[2, 6], [5, 1], [73, 3]]",
    "output": "[6, 1, 3]"
  },
  {
    "input": "queries = [[1, 5]]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "queries = [[2, 3]]",
    "output": "[3]"
  },
  {
    "input": "queries = [[5, 1]]",
    "output": "[1]"
  },
  {
    "input": "queries = [[4, 2]]",
    "output": "[3]"
  },
  {
    "input": "queries = [[2, 6], [5, 1], [73, 3]]",
    "output": "[6, 1, 3]"
  },
  {
    "input": "queries = [[1, 5]]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var waysToMakeProductArray = function(queries) {\n};\n",
  "python": "class Solution:\n    def waysToMakeProductArray(self, queries: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> waysToMakeProductArray(std::vector<std::vector<int>>& queries) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] waysToMakeProductArray(int[][] queries) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "waysToMakeProductArray",
  "params": [
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
            2,
            3
          ]
        ]
      ],
      "expected": [
        3
      ]
    },
    {
      "args": [
        [
          [
            5,
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
            4,
            2
          ]
        ]
      ],
      "expected": [
        3
      ]
    },
    {
      "args": [
        [
          [
            2,
            6
          ],
          [
            5,
            1
          ],
          [
            73,
            3
          ]
        ]
      ],
      "expected": [
        6,
        1,
        3
      ]
    },
    {
      "args": [
        [
          [
            1,
            5
          ]
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
        [
          7,
          2
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
          12,
          3
        ]
      ]
    ],
    "expected": [
      18
    ]
  },
  {
    "args": [
      [
        [
          36,
          2
        ]
      ]
    ],
    "expected": [
      9
    ]
  },
  {
    "args": [
      [
        [
          10000,
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
          8,
          4
        ]
      ]
    ],
    "expected": [
      20
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
          1
        ],
        [
          4,
          1
        ]
      ]
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
    1886,
    '回文串分割 IV',
    '给定字符串 s。
判断能否把 s 分割成恰好三个非空连续子串，并且这三个子串都是回文串。
可以返回 true 或 false。
字符串长度不超过 2000。',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划', '回文'],
    $json$[
  {
    "input": "s = \"abcbdd\"",
    "output": "true"
  },
  {
    "input": "s = \"bcbddxy\"",
    "output": "false"
  },
  {
    "input": "s = \"abc\"",
    "output": "true"
  },
  {
    "input": "s = \"abacaba\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abcbdd\"",
    "output": "true"
  },
  {
    "input": "s = \"bcbddxy\"",
    "output": "false"
  },
  {
    "input": "s = \"abc\"",
    "output": "true"
  },
  {
    "input": "s = \"abacaba\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canSplitIntoThreePalindromes = function(s) {\n};\n",
  "python": "class Solution:\n    def canSplitIntoThreePalindromes(self, s: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canSplitIntoThreePalindromes(std::string s) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canSplitIntoThreePalindromes(String s) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canSplitIntoThreePalindromes",
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
        "abcbdd"
      ],
      "expected": true
    },
    {
      "args": [
        "bcbddxy"
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
        "abacaba"
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a"
    ],
    "expected": false
  },
  {
    "args": [
      "aa"
    ],
    "expected": false
  },
  {
    "args": [
      "aaa"
    ],
    "expected": true
  },
  {
    "args": [
      "aba"
    ],
    "expected": true
  },
  {
    "args": [
      "abbab"
    ],
    "expected": true
  },
  {
    "args": [
      "aabbaa"
    ],
    "expected": true
  },
  {
    "args": [
      "abcbaabc"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1887,
    '由子序列构造的最长回文串的长度',
    '给定两个字符串 word1 和 word2。
从 word1 中选出一个非空子序列，从 word2 中选出一个非空子序列，
把两个子序列按顺序拼接成一个新字符串。
要求新字符串是回文串，求其最大可能长度。
两个字符串长度均不超过 1000。',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划', '区间动态规划'],
    $json$[
  {
    "input": "word1 = \"cacb\", word2 = \"cbba\"",
    "output": "5"
  },
  {
    "input": "word1 = \"ab\", word2 = \"ab\"",
    "output": "3"
  },
  {
    "input": "word1 = \"aa\", word2 = \"bb\"",
    "output": "0"
  },
  {
    "input": "word1 = \"a\", word2 = \"a\"",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "word1 = \"cacb\", word2 = \"cbba\"",
    "output": "5"
  },
  {
    "input": "word1 = \"ab\", word2 = \"ab\"",
    "output": "3"
  },
  {
    "input": "word1 = \"aa\", word2 = \"bb\"",
    "output": "0"
  },
  {
    "input": "word1 = \"a\", word2 = \"a\"",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestPalindromeFromSubsequences = function(word1, word2) {\n};\n",
  "python": "class Solution:\n    def longestPalindromeFromSubsequences(self, word1: str, word2: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestPalindromeFromSubsequences(std::string word1, std::string word2) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestPalindromeFromSubsequences(String word1, String word2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestPalindromeFromSubsequences",
  "params": [
    {
      "name": "word1",
      "type": "string"
    },
    {
      "name": "word2",
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
        "cacb",
        "cbba"
      ],
      "expected": 5
    },
    {
      "args": [
        "ab",
        "ab"
      ],
      "expected": 3
    },
    {
      "args": [
        "aa",
        "bb"
      ],
      "expected": 0
    },
    {
      "args": [
        "a",
        "a"
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abc",
      "def"
    ],
    "expected": 0
  },
  {
    "args": [
      "ab",
      "ba"
    ],
    "expected": 4
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
      "abcba",
      "abcba"
    ],
    "expected": 10
  },
  {
    "args": [
      "a",
      "bc"
    ],
    "expected": 0
  },
  {
    "args": [
      "ab",
      "cd"
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1888,
    '使所有区间的异或结果为零',
    '给定整数数组 nums 和整数 k，nums 中每个元素都在 0 到 1023 之间。
一次操作可以把任意元素修改为 0 到 1023 之间的任意整数。
要求修改后，所有长度为 k 的连续子数组的异或和都等于 0。
返回需要的最少修改次数。
数组长度不超过 2000，k 不超过数组长度。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '位运算'],
    $json$[
  {
    "input": "nums = [1, 2, 0, 3, 0], k = 1",
    "output": "3"
  },
  {
    "input": "nums = [3, 4, 5, 2, 1, 7, 3, 4, 7], k = 3",
    "output": "3"
  },
  {
    "input": "nums = [1, 2, 4, 1, 2, 5, 1, 2, 6], k = 3",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 0, 3, 0], k = 1",
    "output": "3"
  },
  {
    "input": "nums = [3, 4, 5, 2, 1, 7, 3, 4, 7], k = 3",
    "output": "3"
  },
  {
    "input": "nums = [1, 2, 4, 1, 2, 5, 1, 2, 6], k = 3",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumChangesForZeroXor = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def minimumChangesForZeroXor(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumChangesForZeroXor(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumChangesForZeroXor(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumChangesForZeroXor",
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
          0,
          3,
          0
        ],
        1
      ],
      "expected": 3
    },
    {
      "args": [
        [
          3,
          4,
          5,
          2,
          1,
          7,
          3,
          4,
          7
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
          1,
          2,
          5,
          1,
          2,
          6
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
        0
      ],
      1
    ],
    "expected": 0
  },
  {
    "args": [
      [
        5
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
      1
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        2
      ],
      1
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
    "expected": 3
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
        3,
        4,
        5
      ],
      3
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1889,
    '好子数组的最大分数',
    '给定整数数组 nums 和下标 k。
子数组的分数定义为：子数组中的最小值乘以子数组的长度。
好子数组是包含下标 k 的连续子数组。
返回所有好子数组的分数最大值。
数组长度不超过 10^5，元素均为正整数。',
    'hard',
    1000,
    256,
    ARRAY['数组', '双指针', '单调栈'],
    $json$[
  {
    "input": "nums = [1, 4, 3, 7, 4, 5], k = 3",
    "output": "15"
  },
  {
    "input": "nums = [5, 5, 4, 5, 4, 1, 1, 1], k = 0",
    "output": "20"
  },
  {
    "input": "nums = [1, 1, 1, 1], k = 2",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 4, 3, 7, 4, 5], k = 3",
    "output": "15"
  },
  {
    "input": "nums = [5, 5, 4, 5, 4, 1, 1, 1], k = 0",
    "output": "20"
  },
  {
    "input": "nums = [1, 1, 1, 1], k = 2",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumGoodSubarrayScore = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def maximumGoodSubarrayScore(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumGoodSubarrayScore(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumGoodSubarrayScore(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumGoodSubarrayScore",
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
          4,
          3,
          7,
          4,
          5
        ],
        3
      ],
      "expected": 15
    },
    {
      "args": [
        [
          5,
          5,
          4,
          5,
          4,
          1,
          1,
          1
        ],
        0
      ],
      "expected": 20
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
      0
    ],
    "expected": 1
  },
  {
    "args": [
      [
        10
      ],
      0
    ],
    "expected": 10
  },
  {
    "args": [
      [
        2,
        2,
        2
      ],
      1
    ],
    "expected": 6
  },
  {
    "args": [
      [
        3,
        1,
        4,
        1,
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
        2,
        3,
        4,
        5
      ],
      4
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
      ],
      0
    ],
    "expected": 9
  },
  {
    "args": [
      [
        2,
        5,
        2,
        5,
        2
      ],
      2
    ],
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1890,
    '统计异或值在范围内的数对有多少',
    '给定整数数组 nums 以及整数 low 和 high。
统计满足 i < j 且 low <= (nums[i] 异或 nums[j]) <= high 的下标对数量。
nums 中元素、low、high 均为非负整数且小于 2^30。
数组长度不超过 2 * 10^4。',
    'hard',
    1000,
    256,
    ARRAY['数组', '位运算', '字典树'],
    $json$[
  {
    "input": "nums = [1, 4, 2, 7], low = 2, high = 6",
    "output": "6"
  },
  {
    "input": "nums = [1, 2, 3], low = 0, high = 3",
    "output": "3"
  },
  {
    "input": "nums = [5, 5, 5, 5], low = 0, high = 0",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 4, 2, 7], low = 2, high = 6",
    "output": "6"
  },
  {
    "input": "nums = [1, 2, 3], low = 0, high = 3",
    "output": "3"
  },
  {
    "input": "nums = [5, 5, 5, 5], low = 0, high = 0",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countXorPairsInRange = function(nums, low, high) {\n};\n",
  "python": "class Solution:\n    def countXorPairsInRange(self, nums: list[int], low: int, high: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countXorPairsInRange(std::vector<int>& nums, int low, int high) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countXorPairsInRange(int[] nums, int low, int high) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countXorPairsInRange",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
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
          1,
          4,
          2,
          7
        ],
        2,
        6
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
        0,
        3
      ],
      "expected": 3
    },
    {
      "args": [
        [
          5,
          5,
          5,
          5
        ],
        0,
        0
      ],
      "expected": 6
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
      0,
      10
    ],
    "expected": 1
  },
  {
    "args": [
      [
        0
      ],
      0,
      100
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
      3,
      9
    ],
    "expected": 7
  },
  {
    "args": [
      [
        7,
        7,
        7
      ],
      0,
      0
    ],
    "expected": 3
  },
  {
    "args": [
      [
        10,
        20,
        30
      ],
      10,
      20
    ],
    "expected": 2
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
      0,
      7
    ],
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1891,
    '用三种不同颜色为网格涂色',
    '给定 m 和 n，表示一个 m 行 n 列的网格。
用三种颜色给每个格子涂色，要求任意两个相邻格子（上下或左右）颜色不同。
返回合法的涂色方案数，答案对 10^9 + 7 取模。
1 <= m <= 5，1 <= n <= 1000。',
    'hard',
    1000,
    256,
    ARRAY['动态规划', '状态压缩', '矩阵'],
    $json$[
  {
    "input": "m = 1, n = 1",
    "output": "3"
  },
  {
    "input": "m = 1, n = 2",
    "output": "6"
  },
  {
    "input": "m = 5, n = 5",
    "output": "580986"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "m = 1, n = 1",
    "output": "3"
  },
  {
    "input": "m = 1, n = 2",
    "output": "6"
  },
  {
    "input": "m = 5, n = 5",
    "output": "580986"
  }
]$json$::jsonb,
    $json${
  "javascript": "var colorGridThreeColors = function(m, n) {\n};\n",
  "python": "class Solution:\n    def colorGridThreeColors(self, m: int, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int colorGridThreeColors(int m, int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int colorGridThreeColors(int m, int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "colorGridThreeColors",
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
        1,
        1
      ],
      "expected": 3
    },
    {
      "args": [
        1,
        2
      ],
      "expected": 6
    },
    {
      "args": [
        5,
        5
      ],
      "expected": 580986
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      3
    ],
    "expected": 12
  },
  {
    "args": [
      2,
      1
    ],
    "expected": 6
  },
  {
    "args": [
      2,
      2
    ],
    "expected": 18
  },
  {
    "args": [
      3,
      2
    ],
    "expected": 54
  },
  {
    "args": [
      4,
      3
    ],
    "expected": 1122
  },
  {
    "args": [
      2,
      4
    ],
    "expected": 162
  }
]$json$::jsonb,
    'approved'
),
(
    1892,
    '好子集的数目',
    '给定整数数组 nums，其中每个元素在 1 到 30 之间。
如果一个非空子集的元素乘积可以表示为若干个互不相同的质数的乘积，
则称该子集是好的。
注意同一个数值出现在不同下标上视为不同的元素。
返回好子集的数量，答案对 10^9 + 7 取模。
数组长度不超过 10^5。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '状态压缩', '数学'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "6"
  },
  {
    "input": "nums = [4, 2, 3, 15]",
    "output": "5"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "0"
  },
  {
    "input": "nums = [2, 3, 5]",
    "output": "7"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "6"
  },
  {
    "input": "nums = [4, 2, 3, 15]",
    "output": "5"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "0"
  },
  {
    "input": "nums = [2, 3, 5]",
    "output": "7"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numberOfGoodSubsets = function(nums) {\n};\n",
  "python": "class Solution:\n    def numberOfGoodSubsets(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numberOfGoodSubsets(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numberOfGoodSubsets(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numberOfGoodSubsets",
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
      "expected": 6
    },
    {
      "args": [
        [
          4,
          2,
          3,
          15
        ]
      ],
      "expected": 5
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
          2,
          3,
          5
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
        1
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
    "expected": 1
  },
  {
    "args": [
      [
        4
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
        3,
        3
      ]
    ],
    "expected": 20
  },
  {
    "args": [
      [
        6,
        10,
        15
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        2,
        2,
        3
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        1,
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
        30,
        30
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1893,
    '数组的最大公因数排序',
    '给定整数数组 nums。
可以重复执行以下操作：选择两个下标 i 和 j，
如果 nums[i] 与 nums[j] 的最大公因数大于 1，就交换这两个元素。
判断能否通过若干次操作把数组变成非递减顺序。
数组长度不超过 10^5。',
    'hard',
    1000,
    256,
    ARRAY['数组', '并查集', '数论', '排序'],
    $json$[
  {
    "input": "nums = [7, 21, 3]",
    "output": "true"
  },
  {
    "input": "nums = [5, 2, 3, 1]",
    "output": "false"
  },
  {
    "input": "nums = [10, 5, 9, 3, 15]",
    "output": "true"
  },
  {
    "input": "nums = [2, 4, 6, 8]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [7, 21, 3]",
    "output": "true"
  },
  {
    "input": "nums = [5, 2, 3, 1]",
    "output": "false"
  },
  {
    "input": "nums = [10, 5, 9, 3, 15]",
    "output": "true"
  },
  {
    "input": "nums = [2, 4, 6, 8]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var gcdSortPossible = function(nums) {\n};\n",
  "python": "class Solution:\n    def gcdSortPossible(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool gcdSortPossible(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean gcdSortPossible(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "gcdSortPossible",
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
          7,
          21,
          3
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          5,
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
          10,
          5,
          9,
          3,
          15
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          2,
          4,
          6,
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
    "expected": false
  },
  {
    "args": [
      [
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
        5,
        7
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        6,
        2,
        3
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        12,
        3,
        4
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        2,
        3,
        6,
        9
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1894,
    '每棵子树内缺失的最小基因值',
    '给定一棵有 n 个节点的树，根为节点 0。
parents[i] 表示节点 i 的父节点，parents[0] = -1。
nums[i] 是节点 i 的基因值，所有基因值互不相同，且都在 0 到 n-1 之间。
对每个节点 i，考虑以 i 为根的子树中所有节点的基因值，
求其中缺失的最小非负整数（即 mex）。
返回长度为 n 的数组 answer，answer[i] 是节点 i 对应子树的答案，按节点编号 0 到 n-1 排列。
节点数不超过 10^5。',
    'hard',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '并查集'],
    $json$[
  {
    "input": "parents = [-1, 0, 0], nums = [0, 1, 2]",
    "output": "[3, 0, 0]"
  },
  {
    "input": "parents = [-1, 0, 0, 2], nums = [0, 2, 1, 3]",
    "output": "[4, 0, 0, 0]"
  },
  {
    "input": "parents = [-1, 0, 1, 2], nums = [2, 1, 0, 3]",
    "output": "[4, 2, 1, 0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "parents = [-1, 0, 0], nums = [0, 1, 2]",
    "output": "[3, 0, 0]"
  },
  {
    "input": "parents = [-1, 0, 0, 2], nums = [0, 2, 1, 3]",
    "output": "[4, 0, 0, 0]"
  },
  {
    "input": "parents = [-1, 0, 1, 2], nums = [2, 1, 0, 3]",
    "output": "[4, 2, 1, 0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestMissingGeneticValues = function(parents, nums) {\n};\n",
  "python": "class Solution:\n    def smallestMissingGeneticValues(self, parents: list[int], nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> smallestMissingGeneticValues(std::vector<int>& parents, std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] smallestMissingGeneticValues(int[] parents, int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestMissingGeneticValues",
  "params": [
    {
      "name": "parents",
      "type": "int[]"
    },
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
          -1,
          0,
          0
        ],
        [
          0,
          1,
          2
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
          -1,
          0,
          0,
          2
        ],
        [
          0,
          2,
          1,
          3
        ]
      ],
      "expected": [
        4,
        0,
        0,
        0
      ]
    },
    {
      "args": [
        [
          -1,
          0,
          1,
          2
        ],
        [
          2,
          1,
          0,
          3
        ]
      ],
      "expected": [
        4,
        2,
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
        -1
      ],
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
        -1,
        0
      ],
      [
        1,
        0
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
        -1,
        0
      ],
      [
        0,
        1
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
        -1,
        0,
        1,
        1,
        2,
        2,
        3
      ],
      [
        0,
        1,
        2,
        3,
        4,
        5,
        6
      ]
    ],
    "expected": [
      7,
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
        -1,
        0,
        1,
        2,
        3
      ],
      [
        3,
        1,
        0,
        2,
        4
      ]
    ],
    "expected": [
      5,
      3,
      1,
      0,
      0
    ]
  },
  {
    "args": [
      [
        -1,
        0,
        0,
        1,
        1,
        2,
        2
      ],
      [
        1,
        0,
        2,
        3,
        4,
        5,
        6
      ]
    ],
    "expected": [
      7,
      1,
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
    1895,
    '使数组连续的最少操作数',
    '给定整数数组 nums。
一次操作可以把数组中任意一个元素替换成任意整数。
要求操作后数组中所有元素互不相同，并且排序后相邻元素之差都等于 1，
也就是这些元素恰好构成一段连续整数。
返回最少操作次数。
数组长度不超过 10^5。',
    'hard',
    1000,
    256,
    ARRAY['数组', '排序', '滑动窗口'],
    $json$[
  {
    "input": "nums = [4, 2, 5, 3]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3, 5, 6]",
    "output": "1"
  },
  {
    "input": "nums = [1, 10, 100, 1000]",
    "output": "3"
  },
  {
    "input": "nums = [1, 1, 1, 1]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [4, 2, 5, 3]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3, 5, 6]",
    "output": "1"
  },
  {
    "input": "nums = [1, 10, 100, 1000]",
    "output": "3"
  },
  {
    "input": "nums = [1, 1, 1, 1]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumOperationsToMakeContinuous = function(nums) {\n};\n",
  "python": "class Solution:\n    def minimumOperationsToMakeContinuous(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumOperationsToMakeContinuous(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumOperationsToMakeContinuous(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumOperationsToMakeContinuous",
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
          4,
          2,
          5,
          3
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
          5,
          6
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          1,
          10,
          100,
          1000
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
          1
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
        5,
        6
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        10,
        1,
        5,
        7
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
        5,
        6,
        7,
        8,
        9,
        10
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        100,
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
        1000000000
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1896,
    '将数组分成两个数组并最小化数组和的差',
    '给定一个长度为偶数 2n 的整数数组 nums。
把数组中的每个元素分到两个长度均为 n 的数组之一，
求两个数组元素和的差的绝对值的最小值。
数组长度不超过 30。',
    'hard',
    1000,
    256,
    ARRAY['数组', '二分查找', '折半枚举'],
    $json$[
  {
    "input": "nums = [3, 9, 7, 3]",
    "output": "2"
  },
  {
    "input": "nums = [4, 3, 2, 1]",
    "output": "0"
  },
  {
    "input": "nums = [5, 2, 4, 6]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 9, 7, 3]",
    "output": "2"
  },
  {
    "input": "nums = [4, 3, 2, 1]",
    "output": "0"
  },
  {
    "input": "nums = [5, 2, 4, 6]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumSumDifferencePartition = function(nums) {\n};\n",
  "python": "class Solution:\n    def minimumSumDifferencePartition(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumSumDifferencePartition(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumSumDifferencePartition(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumSumDifferencePartition",
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
          9,
          7,
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
          2,
          1
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          5,
          2,
          4,
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
          3,
          4,
          5,
          6
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
        8,
        7,
        6,
        5,
        4
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        100,
        2,
        99
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        3,
        3,
        3,
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
        100000,
        1,
        2,
        3
      ]
    ],
    "expected": 99996
  }
]$json$::jsonb,
    'approved'
),
(
    1897,
    '摘水果',
    '给定水果位置数组 fruits，其中 fruits[i] = [position_i, amount_i]，
表示位置 position_i 上有 amount_i 个水果，所有位置互不相同。
从 startPos 出发，最多走 k 步，每步移动一个单位距离。
经过某个位置时可以摘走该位置上的全部水果，求最多能摘到的水果数量。
fruits 长度不超过 10^5，位置、amount、k 均为非负整数。',
    'hard',
    1000,
    256,
    ARRAY['数组', '二分查找', '滑动窗口'],
    $json$[
  {
    "input": "fruits = [[2, 8], [6, 3], [8, 6]], startPos = 5, k = 4",
    "output": "9"
  },
  {
    "input": "fruits = [[0, 9], [4, 1], [5, 7], [6, 2], [7, 4], [10, 9]], startPos = 5, k = 4",
    "output": "14"
  },
  {
    "input": "fruits = [[1, 1], [2, 1]], startPos = 0, k = 3",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "fruits = [[2, 8], [6, 3], [8, 6]], startPos = 5, k = 4",
    "output": "9"
  },
  {
    "input": "fruits = [[0, 9], [4, 1], [5, 7], [6, 2], [7, 4], [10, 9]], startPos = 5, k = 4",
    "output": "14"
  },
  {
    "input": "fruits = [[1, 1], [2, 1]], startPos = 0, k = 3",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumFruitsHarvested = function(fruits, startPos, k) {\n};\n",
  "python": "class Solution:\n    def maximumFruitsHarvested(self, fruits: list[list[int]], startPos: int, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumFruitsHarvested(std::vector<std::vector<int>>& fruits, int startPos, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumFruitsHarvested(int[][] fruits, int startPos, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumFruitsHarvested",
  "params": [
    {
      "name": "fruits",
      "type": "int[][]"
    },
    {
      "name": "startPos",
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
            8
          ],
          [
            6,
            3
          ],
          [
            8,
            6
          ]
        ],
        5,
        4
      ],
      "expected": 9
    },
    {
      "args": [
        [
          [
            0,
            9
          ],
          [
            4,
            1
          ],
          [
            5,
            7
          ],
          [
            6,
            2
          ],
          [
            7,
            4
          ],
          [
            10,
            9
          ]
        ],
        5,
        4
      ],
      "expected": 14
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
        ],
        0,
        3
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
          5
        ]
      ],
      0,
      0
    ],
    "expected": 5
  },
  {
    "args": [
      [
        [
          3,
          2
        ]
      ],
      0,
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
      4,
      2
    ],
    "expected": 6
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
      2,
      2
    ],
    "expected": 3
  },
  {
    "args": [
      [
        [
          0,
          100
        ],
        [
          10,
          1
        ]
      ],
      5,
      4
    ],
    "expected": 0
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
          1
        ],
        [
          6,
          4
        ],
        [
          8,
          2
        ]
      ],
      5,
      6
    ],
    "expected": 8
  }
]$json$::jsonb,
    'approved'
),
(
    1898,
    '数组的最大与和',
    '给定长度为 n 的整数数组 nums 和整数 numSlots。
有 numSlots 个槽位，编号为 1 到 numSlots，每个槽位最多容纳 2 个数字。
需要把 nums 中的每个数字都放进某个槽位。
一个数字 x 放进编号为 j 的槽位会获得 x 与 j 按位与的分数。
求所有数字获得的分数总和的最大值。
n 不超过 2 * numSlots，numSlots 不超过 9。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '状态压缩', '位运算'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 4, 5, 6], numSlots = 3",
    "output": "9"
  },
  {
    "input": "nums = [1, 3, 10, 4, 7, 1], numSlots = 9",
    "output": "24"
  },
  {
    "input": "nums = [1, 1], numSlots = 1",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 4, 5, 6], numSlots = 3",
    "output": "9"
  },
  {
    "input": "nums = [1, 3, 10, 4, 7, 1], numSlots = 9",
    "output": "24"
  },
  {
    "input": "nums = [1, 1], numSlots = 1",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumAndSum = function(nums, numSlots) {\n};\n",
  "python": "class Solution:\n    def maximumAndSum(self, nums: list[int], numSlots: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumAndSum(std::vector<int>& nums, int numSlots) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumAndSum(int[] nums, int numSlots) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumAndSum",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "numSlots",
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
          5,
          6
        ],
        3
      ],
      "expected": 9
    },
    {
      "args": [
        [
          1,
          3,
          10,
          4,
          7,
          1
        ],
        9
      ],
      "expected": 24
    },
    {
      "args": [
        [
          1,
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
    "expected": 0
  },
  {
    "args": [
      [
        1,
        2
      ],
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        10,
        10,
        10,
        10
      ],
      2
    ],
    "expected": 4
  },
  {
    "args": [
      [
        3,
        5,
        7
      ],
      3
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
      2
    ],
    "expected": 5
  },
  {
    "args": [
      [
        8,
        7,
        6,
        5,
        4,
        3,
        2,
        1
      ],
      4
    ],
    "expected": 19
  }
]$json$::jsonb,
    'approved'
),
(
    1899,
    '从栈中取出 K 个硬币的最大面值和',
    '给定 n 个栈，用二维数组 piles 表示，piles[i] 从栈顶到栈底列出第 i 个栈中的硬币面值。
每次可以从任意一个非空栈的栈顶取走一枚硬币。
一共恰好取走 k 枚硬币，求取走的硬币面值之和的最大值。
所有栈的硬币总数不少于 k，k 不超过 2000。',
    'hard',
    1000,
    256,
    ARRAY['数组', '动态规划', '前缀和'],
    $json$[
  {
    "input": "piles = [[1, 100, 3], [7, 8, 9]], k = 2",
    "output": "101"
  },
  {
    "input": "piles = [[100], [100], [100], [100], [100], [100], [1, 1, 1, 1, 1, 1, 700]], k = 7",
    "output": "706"
  },
  {
    "input": "piles = [[1, 2], [3, 4]], k = 3",
    "output": "8"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "piles = [[1, 100, 3], [7, 8, 9]], k = 2",
    "output": "101"
  },
  {
    "input": "piles = [[100], [100], [100], [100], [100], [100], [1, 1, 1, 1, 1, 1, 700]], k = 7",
    "output": "706"
  },
  {
    "input": "piles = [[1, 2], [3, 4]], k = 3",
    "output": "8"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumCoinsFromPiles = function(piles, k) {\n};\n",
  "python": "class Solution:\n    def maximumCoinsFromPiles(self, piles: list[list[int]], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumCoinsFromPiles(std::vector<std::vector<int>>& piles, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumCoinsFromPiles(int[][] piles, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumCoinsFromPiles",
  "params": [
    {
      "name": "piles",
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
            100,
            3
          ],
          [
            7,
            8,
            9
          ]
        ],
        2
      ],
      "expected": 101
    },
    {
      "args": [
        [
          [
            100
          ],
          [
            100
          ],
          [
            100
          ],
          [
            100
          ],
          [
            100
          ],
          [
            100
          ],
          [
            1,
            1,
            1,
            1,
            1,
            1,
            700
          ]
        ],
        7
      ],
      "expected": 706
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
        [
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
      ],
      2
    ],
    "expected": 7
  },
  {
    "args": [
      [
        [
          10,
          10,
          10
        ],
        [
          10,
          10,
          10
        ]
      ],
      4
    ],
    "expected": 40
  },
  {
    "args": [
      [
        [
          1,
          1000,
          1
        ],
        [
          2,
          2,
          2
        ]
      ],
      2
    ],
    "expected": 1001
  },
  {
    "args": [
      [
        [
          9,
          8,
          7
        ],
        [
          6,
          5,
          4
        ],
        [
          3,
          2,
          1
        ]
      ],
      6
    ],
    "expected": 39
  },
  {
    "args": [
      [
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
    "expected": 3
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
    GREATEST((SELECT COALESCE(MAX(id), 1) FROM problems), 1899)
);

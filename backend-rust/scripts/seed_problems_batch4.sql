-- 仅用于本地/测试环境的题目种子数据。
-- 使用固定 ID 1900-2099，便于通过 clean_dev.sql 安全清理。
-- 200 道函数式题目（run_config + 公开用例 + 隐藏 judge_cases），
-- 与 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）、seed_problems_82.sql（1116-1197）、seed_problems_100.sql（1200-1299）、seed_problems_batch1.sql（1300-1499）、seed_problems_batch2.sql（1500-1699）、seed_problems_batch3.sql（1700-1899）合计 1000 题。

INSERT INTO problems (
    id, title, description, difficulty, time_limit, memory_limit, tags,
    examples, test_cases, code_template, run_config, judge_cases, review_status
) VALUES
(
    1900,
    '判断能否形成等差数列',
    '给定一个整数数组 arr
如果将其重新排序后，任意相邻两个元素之差都相同，则称它可以形成等差数列
请判断 arr 能否形成等差数列
长度小于 3 的数组一律视为可以形成等差数列',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "arr = [3, 5, 1]",
    "output": "true"
  },
  {
    "input": "arr = [1, 2, 4]",
    "output": "false"
  },
  {
    "input": "arr = [1, 3, 5]",
    "output": "true"
  },
  {
    "input": "arr = [1, 2, 3, 4]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [3, 5, 1]",
    "output": "true"
  },
  {
    "input": "arr = [1, 2, 4]",
    "output": "false"
  },
  {
    "input": "arr = [1, 3, 5]",
    "output": "true"
  },
  {
    "input": "arr = [1, 2, 3, 4]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canMakeArithmeticProgression = function(arr) {\n};\n",
  "python": "class Solution:\n    def canMakeArithmeticProgression(self, arr: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canMakeArithmeticProgression(std::vector<int>& arr) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canMakeArithmeticProgression(int[] arr) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canMakeArithmeticProgression",
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
          5,
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
          4
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          1,
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
          2,
          3,
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
        4,
        1
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        5,
        9,
        13
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        3,
        3,
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
        2
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1901,
    '转变日期格式',
    '给定一个格式为 "日 月 年" 的日期字符串
日是带后缀 st、nd、rd、th 的 1 到 31 的数字，月是三个字母的英文缩写，年是四位数字
返回格式为 YYYY-MM-DD 的字符串，其中月份和日期都补齐两位',
    'easy',
    1000,
    256,
    ARRAY['字符串', '模拟'],
    $json$[
  {
    "input": "date = \"20th Oct 2052\"",
    "output": "\"2052-10-20\""
  },
  {
    "input": "date = \"6th Jun 1933\"",
    "output": "\"1933-06-06\""
  },
  {
    "input": "date = \"26th May 1960\"",
    "output": "\"1960-05-26\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "date = \"20th Oct 2052\"",
    "output": "\"2052-10-20\""
  },
  {
    "input": "date = \"6th Jun 1933\"",
    "output": "\"1933-06-06\""
  },
  {
    "input": "date = \"26th May 1960\"",
    "output": "\"1960-05-26\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var reformatDate = function(date) {\n};\n",
  "python": "class Solution:\n    def reformatDate(self, date: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string reformatDate(std::string date) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String reformatDate(String date) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reformatDate",
  "params": [
    {
      "name": "date",
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
        "20th Oct 2052"
      ],
      "expected": "2052-10-20"
    },
    {
      "args": [
        "6th Jun 1933"
      ],
      "expected": "1933-06-06"
    },
    {
      "args": [
        "26th May 1960"
      ],
      "expected": "1960-05-26"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "1st Jan 2000"
    ],
    "expected": "2000-01-01"
  },
  {
    "args": [
      "31st Dec 1999"
    ],
    "expected": "1999-12-31"
  },
  {
    "args": [
      "2nd Feb 2024"
    ],
    "expected": "2024-02-02"
  },
  {
    "args": [
      "3rd Mar 2020"
    ],
    "expected": "2020-03-03"
  },
  {
    "args": [
      "30th Nov 2100"
    ],
    "expected": "2100-11-30"
  }
]$json$::jsonb,
    'approved'
),
(
    1902,
    '存在连续三个奇数的数组',
    '给定一个整数数组 arr
判断数组中是否存在连续三个元素都是奇数的情况',
    'easy',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "arr = [2, 6, 4, 1]",
    "output": "false"
  },
  {
    "input": "arr = [1, 2, 34, 3, 4, 5, 7, 23, 12]",
    "output": "true"
  },
  {
    "input": "arr = [1, 3, 5]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [2, 6, 4, 1]",
    "output": "false"
  },
  {
    "input": "arr = [1, 2, 34, 3, 4, 5, 7, 23, 12]",
    "output": "true"
  },
  {
    "input": "arr = [1, 3, 5]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var threeConsecutiveOdds = function(arr) {\n};\n",
  "python": "class Solution:\n    def threeConsecutiveOdds(self, arr: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool threeConsecutiveOdds(std::vector<int>& arr) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean threeConsecutiveOdds(int[] arr) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "threeConsecutiveOdds",
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
          2,
          6,
          4,
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
          34,
          3,
          4,
          5,
          7,
          23,
          12
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          3,
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
    "expected": false
  },
  {
    "args": [
      [
        2,
        1,
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
        7,
        9,
        11,
        13
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
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1903,
    '千位分隔符',
    '给定一个非负整数 n
将它转换为字符串，并从右向左每三位插入一个点号作为千位分隔符
返回添加分隔符后的字符串，n 为 0 时返回由单个 0 组成的字符串',
    'easy',
    1000,
    256,
    ARRAY['字符串', '模拟'],
    $json$[
  {
    "input": "n = 987",
    "output": "\"987\""
  },
  {
    "input": "n = 1234",
    "output": "\"1.234\""
  },
  {
    "input": "n = 0",
    "output": "\"0\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 987",
    "output": "\"987\""
  },
  {
    "input": "n = 1234",
    "output": "\"1.234\""
  },
  {
    "input": "n = 0",
    "output": "\"0\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var thousandSeparator = function(n) {\n};\n",
  "python": "class Solution:\n    def thousandSeparator(self, n: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string thousandSeparator(int n) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String thousandSeparator(int n) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "thousandSeparator",
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
        987
      ],
      "expected": "987"
    },
    {
      "args": [
        1234
      ],
      "expected": "1.234"
    },
    {
      "args": [
        0
      ],
      "expected": "0"
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
      1000
    ],
    "expected": "1.000"
  },
  {
    "args": [
      123456789
    ],
    "expected": "123.456.789"
  },
  {
    "args": [
      10
    ],
    "expected": "10"
  },
  {
    "args": [
      999999999
    ],
    "expected": "999.999.999"
  },
  {
    "args": [
      2147483647
    ],
    "expected": "2.147.483.647"
  }
]$json$::jsonb,
    'approved'
),
(
    1904,
    '圆形赛道上最常访问的扇区',
    '一条环形赛道有编号 1 到 n 的 n 个扇区
选手从 rounds[0] 出发，按顺序依次到达 rounds 中的每个扇区，每段都沿编号递增方向前进，经过 n 后回到 1
经过和到达的每个扇区都计入一次访问，完整绕圈会对所有扇区产生相同次数的访问
返回访问次数最多的所有扇区编号，按升序排列',
    'easy',
    1000,
    256,
    ARRAY['数组', '模拟'],
    $json$[
  {
    "input": "n = 4, rounds = [1, 3, 1, 2]",
    "output": "[1, 2]"
  },
  {
    "input": "n = 2, rounds = [2, 1, 2, 1, 2, 1, 2, 1, 2]",
    "output": "[2]"
  },
  {
    "input": "n = 7, rounds = [1, 3, 5, 7]",
    "output": "[1, 2, 3, 4, 5, 6, 7]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4, rounds = [1, 3, 1, 2]",
    "output": "[1, 2]"
  },
  {
    "input": "n = 2, rounds = [2, 1, 2, 1, 2, 1, 2, 1, 2]",
    "output": "[2]"
  },
  {
    "input": "n = 7, rounds = [1, 3, 5, 7]",
    "output": "[1, 2, 3, 4, 5, 6, 7]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var mostVisited = function(n, rounds) {\n};\n",
  "python": "class Solution:\n    def mostVisited(self, n: int, rounds: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> mostVisited(int n, std::vector<int>& rounds) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] mostVisited(int n, int[] rounds) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "mostVisited",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "rounds",
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
        4,
        [
          1,
          3,
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
        2,
        [
          2,
          1,
          2,
          1,
          2,
          1,
          2,
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
        7,
        [
          1,
          3,
          5,
          7
        ]
      ],
      "expected": [
        1,
        2,
        3,
        4,
        5,
        6,
        7
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      3,
      [
        3,
        1
      ]
    ],
    "expected": [
      1,
      3
    ]
  },
  {
    "args": [
      3,
      [
        1,
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
      5,
      [
        5,
        1,
        3
      ]
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
      1,
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
      10,
      [
        10,
        5
      ]
    ],
    "expected": [
      1,
      2,
      3,
      4,
      5,
      10
    ]
  },
  {
    "args": [
      4,
      [
        2,
        2,
        2
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
    1905,
    '检测重复至少 K 次的长度为 M 的模式',
    '给定整数数组 arr 和两个整数 m、k
如果存在一个长度为 m 的模式，在数组中连续重复出现至少 k 次，返回 true，否则返回 false
连续重复指这 k 段首尾相接且内容完全相同',
    'easy',
    1000,
    256,
    ARRAY['数组', '滑动窗口'],
    $json$[
  {
    "input": "arr = [1, 2, 4, 4, 4, 4], m = 1, k = 3",
    "output": "true"
  },
  {
    "input": "arr = [1, 2, 1, 2, 1, 1, 1, 3], m = 2, k = 2",
    "output": "true"
  },
  {
    "input": "arr = [1, 2, 1, 2, 1, 3], m = 2, k = 3",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [1, 2, 4, 4, 4, 4], m = 1, k = 3",
    "output": "true"
  },
  {
    "input": "arr = [1, 2, 1, 2, 1, 1, 1, 3], m = 2, k = 2",
    "output": "true"
  },
  {
    "input": "arr = [1, 2, 1, 2, 1, 3], m = 2, k = 3",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var containsPattern = function(arr, m, k) {\n};\n",
  "python": "class Solution:\n    def containsPattern(self, arr: list[int], m: int, k: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool containsPattern(std::vector<int>& arr, int m, int k) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean containsPattern(int[] arr, int m, int k) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "containsPattern",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
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
          4,
          4,
          4,
          4
        ],
        1,
        3
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          2,
          1,
          2,
          1,
          1,
          1,
          3
        ],
        2,
        2
      ],
      "expected": true
    },
    {
      "args": [
        [
          1,
          2,
          1,
          2,
          1,
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
        1,
        2
      ],
      2,
      2
    ],
    "expected": false
  },
  {
    "args": [
      [
        1
      ],
      1,
      1
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
      ],
      2,
      2
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
      2,
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
      1,
      3
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1906,
    '替换所有问号',
    '给定一个只含小写字母和问号的字符串 s
将每个问号替换为一个小写字母，使得字符串中不存在连续相同的字符
如果某个位置有多种可选字母，选择字典序最小的那个，以保证结果唯一',
    'easy',
    1000,
    256,
    ARRAY['字符串', '模拟'],
    $json$[
  {
    "input": "s = \"?zs\"",
    "output": "\"azs\""
  },
  {
    "input": "s = \"ubv?\"",
    "output": "\"ubva\""
  },
  {
    "input": "s = \"???\"",
    "output": "\"aba\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"?zs\"",
    "output": "\"azs\""
  },
  {
    "input": "s = \"ubv?\"",
    "output": "\"ubva\""
  },
  {
    "input": "s = \"???\"",
    "output": "\"aba\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var modifyString = function(s) {\n};\n",
  "python": "class Solution:\n    def modifyString(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string modifyString(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String modifyString(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "modifyString",
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
        "?zs"
      ],
      "expected": "azs"
    },
    {
      "args": [
        "ubv?"
      ],
      "expected": "ubva"
    },
    {
      "args": [
        "???"
      ],
      "expected": "aba"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "?"
    ],
    "expected": "a"
  },
  {
    "args": [
      "a?b"
    ],
    "expected": "acb"
  },
  {
    "args": [
      "a?b?c"
    ],
    "expected": "acbac"
  },
  {
    "args": [
      "??"
    ],
    "expected": "ab"
  },
  {
    "args": [
      "abc??"
    ],
    "expected": "abcab"
  },
  {
    "args": [
      "z??z"
    ],
    "expected": "zabz"
  }
]$json$::jsonb,
    'approved'
),
(
    1907,
    '二进制矩阵中的特殊位置',
    '给定一个只含 0 和 1 的矩阵 mat
如果某个位置的值为 1，且它所在行和所在列的其他位置都为 0，则称该位置是特殊的
返回特殊位置的数量',
    'easy',
    1000,
    256,
    ARRAY['数组', '矩阵'],
    $json$[
  {
    "input": "mat = [[1, 0, 0], [0, 0, 1], [1, 0, 0]]",
    "output": "1"
  },
  {
    "input": "mat = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]",
    "output": "3"
  },
  {
    "input": "mat = [[0, 0, 0], [0, 1, 0], [0, 0, 0]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mat = [[1, 0, 0], [0, 0, 1], [1, 0, 0]]",
    "output": "1"
  },
  {
    "input": "mat = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]",
    "output": "3"
  },
  {
    "input": "mat = [[0, 0, 0], [0, 1, 0], [0, 0, 0]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numSpecial = function(mat) {\n};\n",
  "python": "class Solution:\n    def numSpecial(self, mat: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numSpecial(std::vector<std::vector<int>>& mat) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numSpecial(int[][] mat) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numSpecial",
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
            0
          ],
          [
            0,
            0,
            1
          ],
          [
            1,
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
  }
]$json$::jsonb,
    'approved'
),
(
    1908,
    '重新排列单词间的空格',
    '给定一个由单词和空格组成的字符串 text
单词之间用一个或多个空格分隔，字符串可能以空格开头或结尾
重新排列空格：单词顺序不变，单词之间用等量空格分隔，不能均分的多余空格全部追加到字符串末尾
只有一个单词时，所有空格都放在该单词后面，结果不含前导空格',
    'easy',
    1000,
    256,
    ARRAY['字符串', '模拟'],
    $json$[
  {
    "input": "text = \"  this   is  a sentence \"",
    "output": "\"this   is   a   sentence\""
  },
  {
    "input": "text = \" practice   makes   perfect\"",
    "output": "\"practice   makes   perfect \""
  },
  {
    "input": "text = \"hello world  \"",
    "output": "\"hello   world\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "text = \"  this   is  a sentence \"",
    "output": "\"this   is   a   sentence\""
  },
  {
    "input": "text = \" practice   makes   perfect\"",
    "output": "\"practice   makes   perfect \""
  },
  {
    "input": "text = \"hello world  \"",
    "output": "\"hello   world\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var reorderSpaces = function(text) {\n};\n",
  "python": "class Solution:\n    def reorderSpaces(self, text: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string reorderSpaces(std::string text) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String reorderSpaces(String text) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reorderSpaces",
  "params": [
    {
      "name": "text",
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
        "  this   is  a sentence "
      ],
      "expected": "this   is   a   sentence"
    },
    {
      "args": [
        " practice   makes   perfect"
      ],
      "expected": "practice   makes   perfect "
    },
    {
      "args": [
        "hello world  "
      ],
      "expected": "hello   world"
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
      "  a  "
    ],
    "expected": "a    "
  },
  {
    "args": [
      "a b"
    ],
    "expected": "a b"
  },
  {
    "args": [
      "a  b  c"
    ],
    "expected": "a  b  c"
  },
  {
    "args": [
      "abc def "
    ],
    "expected": "abc  def"
  },
  {
    "args": [
      " a b "
    ],
    "expected": "a   b"
  }
]$json$::jsonb,
    'approved'
),
(
    1909,
    '特殊数组的特征值',
    '给定一个非负整数数组 nums
如果存在一个整数 x，使得数组中恰好有 x 个元素大于或等于 x，则 x 是数组的特征值
返回最大的特征值；如果不存在，返回 -1',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "nums = [3, 5]",
    "output": "2"
  },
  {
    "input": "nums = [0, 0]",
    "output": "-1"
  },
  {
    "input": "nums = [0, 4, 3, 0, 4]",
    "output": "3"
  },
  {
    "input": "nums = [3, 6, 7, 7, 0]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 5]",
    "output": "2"
  },
  {
    "input": "nums = [0, 0]",
    "output": "-1"
  },
  {
    "input": "nums = [0, 4, 3, 0, 4]",
    "output": "3"
  },
  {
    "input": "nums = [3, 6, 7, 7, 0]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var specialArray = function(nums) {\n};\n",
  "python": "class Solution:\n    def specialArray(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int specialArray(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int specialArray(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "specialArray",
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
          5
        ]
      ],
      "expected": 2
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
          0,
          4,
          3,
          0,
          4
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          3,
          6,
          7,
          7,
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
    "expected": -1
  },
  {
    "args": [
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
        1,
        1,
        1
      ]
    ],
    "expected": -1
  }
]$json$::jsonb,
    'approved'
),
(
    1910,
    '删除某些元素后的数组均值',
    '给定一个长度为 n 的整数数组 arr，其中 n 是 20 的倍数
删除数组中最小和最大的各 n / 20 个元素，返回剩余元素的平均值
结果以浮点数返回',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "arr = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]",
    "output": "1.5"
  },
  {
    "input": "arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]",
    "output": "10.5"
  },
  {
    "input": "arr = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]",
    "output": "5.0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]",
    "output": "1.5"
  },
  {
    "input": "arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]",
    "output": "10.5"
  },
  {
    "input": "arr = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]",
    "output": "5.0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var trimMean = function(arr) {\n};\n",
  "python": "class Solution:\n    def trimMean(self, arr: list[int]) -> float:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    double trimMean(std::vector<int>& arr) {\n        return 0.0;\n    }\n};\n",
  "java": "class Solution {\n    public double trimMean(int[] arr) {\n        return 0.0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "trimMean",
  "params": [
    {
      "name": "arr",
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
          2,
          2,
          2,
          2,
          2,
          2,
          2,
          2,
          2,
          2
        ]
      ],
      "expected": 1.5
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
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20
        ]
      ],
      "expected": 10.5
    },
    {
      "args": [
        [
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5
        ]
      ],
      "expected": 5.0
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
    "expected": 1.0
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
        100,
        100,
        100,
        100,
        100,
        100,
        100,
        100,
        100,
        100
      ]
    ],
    "expected": 50.5
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
        15,
        16,
        17,
        18,
        19
      ]
    ],
    "expected": 9.5
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
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        33,
        34,
        35,
        36,
        37,
        38,
        39,
        40
      ]
    ],
    "expected": 20.5
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
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        4
      ]
    ],
    "expected": 2.0
  }
]$json$::jsonb,
    'approved'
),
(
    1911,
    '两个相同字符之间的最长子字符串',
    '给定一个字符串 s
选择两个相同的字符，返回它们之间（不含这两个字符）的子字符串的最大长度
如果不存在两个相同的字符，返回 -1',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "s = \"aa\"",
    "output": "0"
  },
  {
    "input": "s = \"abca\"",
    "output": "2"
  },
  {
    "input": "s = \"cbzxy\"",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aa\"",
    "output": "0"
  },
  {
    "input": "s = \"abca\"",
    "output": "2"
  },
  {
    "input": "s = \"cbzxy\"",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxLengthBetweenEqualCharacters = function(s) {\n};\n",
  "python": "class Solution:\n    def maxLengthBetweenEqualCharacters(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxLengthBetweenEqualCharacters(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxLengthBetweenEqualCharacters(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxLengthBetweenEqualCharacters",
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
        "aa"
      ],
      "expected": 0
    },
    {
      "args": [
        "abca"
      ],
      "expected": 2
    },
    {
      "args": [
        "cbzxy"
      ],
      "expected": -1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a"
    ],
    "expected": -1
  },
  {
    "args": [
      "ab"
    ],
    "expected": -1
  },
  {
    "args": [
      "abcba"
    ],
    "expected": 3
  },
  {
    "args": [
      "aaaa"
    ],
    "expected": 2
  },
  {
    "args": [
      "abacaba"
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1912,
    '按键持续时间最长的键',
    '给定整数数组 releaseTimes 和字符串 keysPressed
keysPressed[i] 是第 i 次按下的键，releaseTimes[i] 是它被释放的时刻，数组严格递增
第 i 次按键的持续时间为 releaseTimes[i] 减去 releaseTimes[i - 1]，第一次按键从时刻 0 开始计算
返回持续时间最长的键；如果并列，返回字母序更大的键',
    'easy',
    1000,
    256,
    ARRAY['数组', '字符串'],
    $json$[
  {
    "input": "releaseTimes = [9, 29, 49, 50], keysPressed = \"cbcd\"",
    "output": "\"c\""
  },
  {
    "input": "releaseTimes = [12, 23, 36, 46, 62], keysPressed = \"spuda\"",
    "output": "\"a\""
  },
  {
    "input": "releaseTimes = [3, 7], keysPressed = \"ab\"",
    "output": "\"b\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "releaseTimes = [9, 29, 49, 50], keysPressed = \"cbcd\"",
    "output": "\"c\""
  },
  {
    "input": "releaseTimes = [12, 23, 36, 46, 62], keysPressed = \"spuda\"",
    "output": "\"a\""
  },
  {
    "input": "releaseTimes = [3, 7], keysPressed = \"ab\"",
    "output": "\"b\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var slowestKey = function(releaseTimes, keysPressed) {\n};\n",
  "python": "class Solution:\n    def slowestKey(self, releaseTimes: list[int], keysPressed: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string slowestKey(std::vector<int>& releaseTimes, std::string keysPressed) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String slowestKey(int[] releaseTimes, String keysPressed) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "slowestKey",
  "params": [
    {
      "name": "releaseTimes",
      "type": "int[]"
    },
    {
      "name": "keysPressed",
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
        [
          9,
          29,
          49,
          50
        ],
        "cbcd"
      ],
      "expected": "c"
    },
    {
      "args": [
        [
          12,
          23,
          36,
          46,
          62
        ],
        "spuda"
      ],
      "expected": "a"
    },
    {
      "args": [
        [
          3,
          7
        ],
        "ab"
      ],
      "expected": "b"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1
      ],
      "a"
    ],
    "expected": "a"
  },
  {
    "args": [
      [
        1,
        2
      ],
      "ab"
    ],
    "expected": "b"
  },
  {
    "args": [
      [
        2,
        4
      ],
      "bb"
    ],
    "expected": "b"
  },
  {
    "args": [
      [
        10,
        20,
        30
      ],
      "abc"
    ],
    "expected": "c"
  },
  {
    "args": [
      [
        1,
        2,
        3,
        4
      ],
      "zzzz"
    ],
    "expected": "z"
  },
  {
    "args": [
      [
        5,
        10,
        15,
        20
      ],
      "abcd"
    ],
    "expected": "d"
  }
]$json$::jsonb,
    'approved'
),
(
    1913,
    '找到目标值的下标',
    '给定一个整数数组 nums 和目标值 target
先将 nums 按非递减顺序排序，再找出排序后数组中所有等于 target 的下标
返回这些下标组成的数组，按升序排列；如果没有元素等于 target，返回空数组',
    'easy',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "nums = [1, 2, 5, 2, 3], target = 2",
    "output": "[1, 2]"
  },
  {
    "input": "nums = [1, 2, 5, 2, 3], target = 3",
    "output": "[3]"
  },
  {
    "input": "nums = [1, 2, 5, 2, 3], target = 5",
    "output": "[4]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 5, 2, 3], target = 2",
    "output": "[1, 2]"
  },
  {
    "input": "nums = [1, 2, 5, 2, 3], target = 3",
    "output": "[3]"
  },
  {
    "input": "nums = [1, 2, 5, 2, 3], target = 5",
    "output": "[4]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findTargetIndices = function(nums, target) {\n};\n",
  "python": "class Solution:\n    def findTargetIndices(self, nums: list[int], target: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findTargetIndices(std::vector<int>& nums, int target) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findTargetIndices(int[] nums, int target) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findTargetIndices",
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
          1,
          2,
          5,
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
          1,
          2,
          5,
          2,
          3
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
          1,
          2,
          5,
          2,
          3
        ],
        5
      ],
      "expected": [
        4
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
      0
    ]
  },
  {
    "args": [
      [
        1
      ],
      2
    ],
    "expected": []
  },
  {
    "args": [
      [
        2,
        2
      ],
      2
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
        4,
        3,
        2,
        1
      ],
      3
    ],
    "expected": [
      2
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
      0,
      1,
      2
    ]
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
    "expected": []
  }
]$json$::jsonb,
    'approved'
),
(
    1914,
    '能否连接形成数组',
    '给定一个整数数组 arr 和一个二维整数数组 pieces
arr 中的整数互不相同，pieces 中所有整数也互不相同，且 pieces 的所有元素恰好组成 arr
只有当 pieces 中的每个子数组都能按原顺序、按任意子数组顺序首尾拼接成 arr 时，返回 true，否则返回 false',
    'easy',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "arr = [15, 88], pieces = [[88], [15]]",
    "output": "true"
  },
  {
    "input": "arr = [49, 18, 16], pieces = [[16, 18, 49]]",
    "output": "false"
  },
  {
    "input": "arr = [91, 4, 64, 78], pieces = [[78], [4, 64], [91]]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [15, 88], pieces = [[88], [15]]",
    "output": "true"
  },
  {
    "input": "arr = [49, 18, 16], pieces = [[16, 18, 49]]",
    "output": "false"
  },
  {
    "input": "arr = [91, 4, 64, 78], pieces = [[78], [4, 64], [91]]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canFormArray = function(arr, pieces) {\n};\n",
  "python": "class Solution:\n    def canFormArray(self, arr: list[int], pieces: list[list[int]]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canFormArray(std::vector<int>& arr, std::vector<std::vector<int>>& pieces) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canFormArray(int[] arr, int[][] pieces) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canFormArray",
  "params": [
    {
      "name": "arr",
      "type": "int[]"
    },
    {
      "name": "pieces",
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
          15,
          88
        ],
        [
          [
            88
          ],
          [
            15
          ]
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          49,
          18,
          16
        ],
        [
          [
            16,
            18,
            49
          ]
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          91,
          4,
          64,
          78
        ],
        [
          [
            78
          ],
          [
            4,
            64
          ],
          [
            91
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
        1
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
        1,
        2
      ],
      [
        [
          1
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
        2,
        1
      ],
      [
        [
          1
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
        1,
        2,
        3
      ],
      [
        [
          1,
          3
        ],
        [
          2
        ]
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        1,
        2
      ],
      [
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
        1,
        2,
        3
      ],
      [
        [
          1,
          2,
          3
        ]
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1915,
    '获取生成数组中的最大值',
    '按下述规则生成数组 nums：nums[0] = 0，nums[1] = 1
对于 2 <= i <= n，如果 i 是偶数，nums[i] = nums[i / 2]；如果 i 是奇数，nums[i] = nums[i / 2] + nums[i / 2 + 1]
返回 nums[0] 到 nums[n] 中的最大值，给定 0 <= n <= 100',
    'easy',
    1000,
    256,
    ARRAY['数组', '模拟'],
    $json$[
  {
    "input": "n = 7",
    "output": "3"
  },
  {
    "input": "n = 2",
    "output": "1"
  },
  {
    "input": "n = 3",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 7",
    "output": "3"
  },
  {
    "input": "n = 2",
    "output": "1"
  },
  {
    "input": "n = 3",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var getMaximumGenerated = function(n) {\n};\n",
  "python": "class Solution:\n    def getMaximumGenerated(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int getMaximumGenerated(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int getMaximumGenerated(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getMaximumGenerated",
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
      "expected": 3
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
      4
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
      100
    ],
    "expected": 21
  }
]$json$::jsonb,
    'approved'
),
(
    1916,
    '拆炸弹',
    '给定循环数组 code 和整数 k
如果 k > 0，将 code[i] 替换为它后面 k 个元素之和
如果 k < 0，将 code[i] 替换为它前面 -k 个元素之和
如果 k == 0，将所有元素替换为 0
数组首尾相接，返回替换后的数组',
    'easy',
    1000,
    256,
    ARRAY['数组', '模拟'],
    $json$[
  {
    "input": "code = [5, 7, 1, 4], k = 3",
    "output": "[12, 10, 16, 13]"
  },
  {
    "input": "code = [1, 2, 3, 4], k = 0",
    "output": "[0, 0, 0, 0]"
  },
  {
    "input": "code = [2, 4, 9, 3], k = -2",
    "output": "[12, 5, 6, 13]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "code = [5, 7, 1, 4], k = 3",
    "output": "[12, 10, 16, 13]"
  },
  {
    "input": "code = [1, 2, 3, 4], k = 0",
    "output": "[0, 0, 0, 0]"
  },
  {
    "input": "code = [2, 4, 9, 3], k = -2",
    "output": "[12, 5, 6, 13]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var decrypt = function(code, k) {\n};\n",
  "python": "class Solution:\n    def decrypt(self, code: list[int], k: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> decrypt(std::vector<int>& code, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] decrypt(int[] code, int k) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "decrypt",
  "params": [
    {
      "name": "code",
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
          5,
          7,
          1,
          4
        ],
        3
      ],
      "expected": [
        12,
        10,
        16,
        13
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
        0
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
          2,
          4,
          9,
          3
        ],
        -2
      ],
      "expected": [
        12,
        5,
        6,
        13
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
      0
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
      -1
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
      2
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
        2,
        3
      ],
      -2
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
        2,
        3,
        4
      ],
      3
    ],
    "expected": [
      9,
      8,
      7,
      6
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1917,
    '最大重复子字符串',
    '给定字符串 sequence 和 word
返回最大的整数 k，使得 word 重复 k 次后得到的字符串是 sequence 的子字符串
如果不存在这样的 k，返回 0',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "sequence = \"ababc\", word = \"ab\"",
    "output": "2"
  },
  {
    "input": "sequence = \"ababc\", word = \"ba\"",
    "output": "1"
  },
  {
    "input": "sequence = \"ababc\", word = \"ac\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "sequence = \"ababc\", word = \"ab\"",
    "output": "2"
  },
  {
    "input": "sequence = \"ababc\", word = \"ba\"",
    "output": "1"
  },
  {
    "input": "sequence = \"ababc\", word = \"ac\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxRepeating = function(sequence, word) {\n};\n",
  "python": "class Solution:\n    def maxRepeating(self, sequence: str, word: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxRepeating(std::string sequence, std::string word) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxRepeating(String sequence, String word) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxRepeating",
  "params": [
    {
      "name": "sequence",
      "type": "string"
    },
    {
      "name": "word",
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
        "ababc",
        "ab"
      ],
      "expected": 2
    },
    {
      "args": [
        "ababc",
        "ba"
      ],
      "expected": 1
    },
    {
      "args": [
        "ababc",
        "ac"
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
    "expected": 1
  },
  {
    "args": [
      "aa",
      "a"
    ],
    "expected": 2
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
      "ababab",
      "abab"
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
    1918,
    '设计 Goal 解析器',
    '给定一个只包含 "G"、"()"、"(al)" 三种片段的命令字符串
按以下规则解释： "G" 解释为 "G"，"()" 解释为 "o"，"(al)" 解释为 "al"
返回解释后的字符串',
    'easy',
    1000,
    256,
    ARRAY['字符串', '模拟'],
    $json$[
  {
    "input": "command = \"G()(al)\"",
    "output": "\"Goal\""
  },
  {
    "input": "command = \"GG()\"",
    "output": "\"GGo\""
  },
  {
    "input": "command = \"()()()\"",
    "output": "\"ooo\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "command = \"G()(al)\"",
    "output": "\"Goal\""
  },
  {
    "input": "command = \"GG()\"",
    "output": "\"GGo\""
  },
  {
    "input": "command = \"()()()\"",
    "output": "\"ooo\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var interpret = function(command) {\n};\n",
  "python": "class Solution:\n    def interpret(self, command: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string interpret(std::string command) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String interpret(String command) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "interpret",
  "params": [
    {
      "name": "command",
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
        "G()(al)"
      ],
      "expected": "Goal"
    },
    {
      "args": [
        "GG()"
      ],
      "expected": "GGo"
    },
    {
      "args": [
        "()()()"
      ],
      "expected": "ooo"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "G"
    ],
    "expected": "G"
  },
  {
    "args": [
      "()"
    ],
    "expected": "o"
  },
  {
    "args": [
      "(al)"
    ],
    "expected": "al"
  },
  {
    "args": [
      "G(al)()"
    ],
    "expected": "Galo"
  },
  {
    "args": [
      "G()()()()(al)"
    ],
    "expected": "Gooooal"
  }
]$json$::jsonb,
    'approved'
),
(
    1919,
    '重新格式化电话号码',
    '给定一个包含数字、空格和破折号的字符串 number
先删除所有空格和破折号，只保留数字
然后从左到右每 3 位分为一组；最后剩余 2 位时单独成组，剩余 4 位时分成两个 2 位组
返回用破折号连接各组的字符串',
    'easy',
    1000,
    256,
    ARRAY['字符串', '模拟'],
    $json$[
  {
    "input": "number = \"1-23-45 6\"",
    "output": "\"123-456\""
  },
  {
    "input": "number = \"123 4-567\"",
    "output": "\"123-45-67\""
  },
  {
    "input": "number = \"123 4-5678\"",
    "output": "\"123-456-78\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "number = \"1-23-45 6\"",
    "output": "\"123-456\""
  },
  {
    "input": "number = \"123 4-567\"",
    "output": "\"123-45-67\""
  },
  {
    "input": "number = \"123 4-5678\"",
    "output": "\"123-456-78\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var reformatNumber = function(number) {\n};\n",
  "python": "class Solution:\n    def reformatNumber(self, number: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string reformatNumber(std::string number) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String reformatNumber(String number) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reformatNumber",
  "params": [
    {
      "name": "number",
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
        "1-23-45 6"
      ],
      "expected": "123-456"
    },
    {
      "args": [
        "123 4-567"
      ],
      "expected": "123-45-67"
    },
    {
      "args": [
        "123 4-5678"
      ],
      "expected": "123-456-78"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "12"
    ],
    "expected": "12"
  },
  {
    "args": [
      "123"
    ],
    "expected": "123"
  },
  {
    "args": [
      "1234"
    ],
    "expected": "12-34"
  },
  {
    "args": [
      "1 2 3 4 5"
    ],
    "expected": "123-45"
  },
  {
    "args": [
      "--123-456--"
    ],
    "expected": "123-456"
  },
  {
    "args": [
      "123456789"
    ],
    "expected": "123-456-789"
  }
]$json$::jsonb,
    'approved'
),
(
    1920,
    '判断字符串的两半是否相似',
    '给定一个长度为偶数的字符串 s，将它从中间分成两个长度相等的部分
元音字母为 a、e、i、o、u 的大小写形式
如果两部分中元音字母的数量相等，返回 true，否则返回 false',
    'easy',
    1000,
    256,
    ARRAY['字符串', '计数'],
    $json$[
  {
    "input": "s = \"book\"",
    "output": "true"
  },
  {
    "input": "s = \"textbook\"",
    "output": "false"
  },
  {
    "input": "s = \"MerryChristmas\"",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"book\"",
    "output": "true"
  },
  {
    "input": "s = \"textbook\"",
    "output": "false"
  },
  {
    "input": "s = \"MerryChristmas\"",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var halvesAreAlike = function(s) {\n};\n",
  "python": "class Solution:\n    def halvesAreAlike(self, s: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool halvesAreAlike(std::string s) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean halvesAreAlike(String s) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "halvesAreAlike",
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
        "book"
      ],
      "expected": true
    },
    {
      "args": [
        "textbook"
      ],
      "expected": false
    },
    {
      "args": [
        "MerryChristmas"
      ],
      "expected": false
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "aa"
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
      "aeiouAEIOU"
    ],
    "expected": true
  },
  {
    "args": [
      "AbCdEfGh"
    ],
    "expected": true
  },
  {
    "args": [
      "aA"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1921,
    '可以形成最大正方形的矩形数目',
    '给定二维数组 rectangles，其中 rectangles[i] = [length, width]
从每个矩形中切出一个正方形，边长取长和宽的较小值
先求出所有矩形能切出的最大正方形边长，再返回能切出这个边长的矩形数量',
    'easy',
    1000,
    256,
    ARRAY['数组', '计数'],
    $json$[
  {
    "input": "rectangles = [[5, 8], [3, 9], [5, 12], [16, 5]]",
    "output": "3"
  },
  {
    "input": "rectangles = [[2, 3], [3, 7], [4, 3], [3, 7]]",
    "output": "3"
  },
  {
    "input": "rectangles = [[1, 1], [1, 1]]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "rectangles = [[5, 8], [3, 9], [5, 12], [16, 5]]",
    "output": "3"
  },
  {
    "input": "rectangles = [[2, 3], [3, 7], [4, 3], [3, 7]]",
    "output": "3"
  },
  {
    "input": "rectangles = [[1, 1], [1, 1]]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countGoodRectangles = function(rectangles) {\n};\n",
  "python": "class Solution:\n    def countGoodRectangles(self, rectangles: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countGoodRectangles(std::vector<std::vector<int>>& rectangles) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countGoodRectangles(int[][] rectangles) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countGoodRectangles",
  "params": [
    {
      "name": "rectangles",
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
            8
          ],
          [
            3,
            9
          ],
          [
            5,
            12
          ],
          [
            16,
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
            2,
            3
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
            3,
            7
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
          4,
          4
        ],
        [
          4,
          4
        ],
        [
          4,
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
          2,
          10
        ],
        [
          5,
          4
        ],
        [
          3,
          3
        ]
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1922,
    '替换隐藏数字得到的最晚时间',
    '给定一个长度为 5 的字符串 time，格式为 "HH:MM"，其中部分字符被问号隐藏
返回将问号替换为数字后能得到的最晚合法时间，合法时间范围为 00:00 到 23:59',
    'easy',
    1000,
    256,
    ARRAY['字符串', '枚举'],
    $json$[
  {
    "input": "time = \"2?:?0\"",
    "output": "\"23:50\""
  },
  {
    "input": "time = \"0?:3?\"",
    "output": "\"09:39\""
  },
  {
    "input": "time = \"1?:22\"",
    "output": "\"19:22\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "time = \"2?:?0\"",
    "output": "\"23:50\""
  },
  {
    "input": "time = \"0?:3?\"",
    "output": "\"09:39\""
  },
  {
    "input": "time = \"1?:22\"",
    "output": "\"19:22\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumTime = function(time) {\n};\n",
  "python": "class Solution:\n    def maximumTime(self, time: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string maximumTime(std::string time) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String maximumTime(String time) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumTime",
  "params": [
    {
      "name": "time",
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
        "2?:?0"
      ],
      "expected": "23:50"
    },
    {
      "args": [
        "0?:3?"
      ],
      "expected": "09:39"
    },
    {
      "args": [
        "1?:22"
      ],
      "expected": "19:22"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "??:??"
    ],
    "expected": "23:59"
  },
  {
    "args": [
      "?4:5?"
    ],
    "expected": "14:59"
  },
  {
    "args": [
      "?0:?0"
    ],
    "expected": "20:50"
  },
  {
    "args": [
      "??:3?"
    ],
    "expected": "23:39"
  },
  {
    "args": [
      "2?:??"
    ],
    "expected": "23:59"
  },
  {
    "args": [
      "?9:?9"
    ],
    "expected": "19:59"
  }
]$json$::jsonb,
    'approved'
),
(
    1923,
    '盒子中小球的最大数量',
    '有编号从 1 开始的无限多个盒子，编号 lowLimit 到 highLimit 的每个小球依次放入一个盒子
编号为 n 的小球放入编号等于 n 的十进制各位数字之和的盒子
返回球数量最多的盒子中的球数',
    'easy',
    1000,
    256,
    ARRAY['数学', '哈希表'],
    $json$[
  {
    "input": "lowLimit = 1, highLimit = 10",
    "output": "2"
  },
  {
    "input": "lowLimit = 5, highLimit = 15",
    "output": "2"
  },
  {
    "input": "lowLimit = 19, highLimit = 28",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "lowLimit = 1, highLimit = 10",
    "output": "2"
  },
  {
    "input": "lowLimit = 5, highLimit = 15",
    "output": "2"
  },
  {
    "input": "lowLimit = 19, highLimit = 28",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countBalls = function(lowLimit, highLimit) {\n};\n",
  "python": "class Solution:\n    def countBalls(self, lowLimit: int, highLimit: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countBalls(int lowLimit, int highLimit) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countBalls(int lowLimit, int highLimit) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countBalls",
  "params": [
    {
      "name": "lowLimit",
      "type": "int"
    },
    {
      "name": "highLimit",
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
        10
      ],
      "expected": 2
    },
    {
      "args": [
        5,
        15
      ],
      "expected": 2
    },
    {
      "args": [
        19,
        28
      ],
      "expected": 2
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
      1,
      2
    ],
    "expected": 1
  },
  {
    "args": [
      9,
      9
    ],
    "expected": 1
  },
  {
    "args": [
      1,
      20
    ],
    "expected": 3
  },
  {
    "args": [
      10,
      20
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1924,
    '最长的美好子字符串',
    '如果一个字符串中每种出现的字母都同时以大写和小写形式出现，则称它为美好字符串
给定字符串 s，返回最长的美好子字符串
如果有多个最长答案，返回最先出现的那个；如果不存在，返回空字符串',
    'easy',
    1000,
    256,
    ARRAY['字符串', '枚举'],
    $json$[
  {
    "input": "s = \"YazaAay\"",
    "output": "\"aAa\""
  },
  {
    "input": "s = \"Bb\"",
    "output": "\"Bb\""
  },
  {
    "input": "s = \"c\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"YazaAay\"",
    "output": "\"aAa\""
  },
  {
    "input": "s = \"Bb\"",
    "output": "\"Bb\""
  },
  {
    "input": "s = \"c\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestNiceSubstring = function(s) {\n};\n",
  "python": "class Solution:\n    def longestNiceSubstring(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string longestNiceSubstring(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String longestNiceSubstring(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestNiceSubstring",
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
        "YazaAay"
      ],
      "expected": "aAa"
    },
    {
      "args": [
        "Bb"
      ],
      "expected": "Bb"
    },
    {
      "args": [
        "c"
      ],
      "expected": ""
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "aA"
    ],
    "expected": "aA"
  },
  {
    "args": [
      "abc"
    ],
    "expected": ""
  },
  {
    "args": [
      "aAbB"
    ],
    "expected": "aAbB"
  },
  {
    "args": [
      "dDdD"
    ],
    "expected": "dDdD"
  },
  {
    "args": [
      "xXyYz"
    ],
    "expected": "xXyY"
  }
]$json$::jsonb,
    'approved'
),
(
    1925,
    '交替合并字符串',
    '给定两个字符串 word1 和 word2
从 word1 开始，依次从两个字符串中交替取字符并拼接
如果一个字符串先用完，就把另一个字符串剩余字符直接追加到结果末尾
返回合并后的字符串',
    'easy',
    1000,
    256,
    ARRAY['字符串', '双指针'],
    $json$[
  {
    "input": "word1 = \"abc\", word2 = \"pqr\"",
    "output": "\"apbqcr\""
  },
  {
    "input": "word1 = \"ab\", word2 = \"pqrs\"",
    "output": "\"apbqrs\""
  },
  {
    "input": "word1 = \"abcd\", word2 = \"pq\"",
    "output": "\"apbqcd\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "word1 = \"abc\", word2 = \"pqr\"",
    "output": "\"apbqcr\""
  },
  {
    "input": "word1 = \"ab\", word2 = \"pqrs\"",
    "output": "\"apbqrs\""
  },
  {
    "input": "word1 = \"abcd\", word2 = \"pq\"",
    "output": "\"apbqcd\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var mergeAlternately = function(word1, word2) {\n};\n",
  "python": "class Solution:\n    def mergeAlternately(self, word1: str, word2: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string mergeAlternately(std::string word1, std::string word2) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String mergeAlternately(String word1, String word2) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "mergeAlternately",
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
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "abc",
        "pqr"
      ],
      "expected": "apbqcr"
    },
    {
      "args": [
        "ab",
        "pqrs"
      ],
      "expected": "apbqrs"
    },
    {
      "args": [
        "abcd",
        "pq"
      ],
      "expected": "apbqcd"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "ab",
      "c"
    ],
    "expected": "acb"
  },
  {
    "args": [
      "a",
      "bc"
    ],
    "expected": "abc"
  },
  {
    "args": [
      "abcdef",
      "xy"
    ],
    "expected": "axbycdef"
  },
  {
    "args": [
      "x",
      "abcdef"
    ],
    "expected": "xabcdef"
  },
  {
    "args": [
      "a",
      "b"
    ],
    "expected": "ab"
  },
  {
    "args": [
      "abc",
      "xyz"
    ],
    "expected": "axbycz"
  }
]$json$::jsonb,
    'approved'
),
(
    1926,
    '统计匹配检索规则的物品数量',
    '给定二维字符串数组 items，其中 items[i] = [type, color, name]
同时给定规则键 ruleKey 和规则值 ruleValue，ruleKey 只能是 "type"、"color" 或 "name"
统计满足 item[ruleKey] == ruleValue 的物品数量',
    'easy',
    1000,
    256,
    ARRAY['数组', '字符串'],
    $json$[
  {
    "input": "items = [[\"phone\", \"blue\", \"pixel\"], [\"computer\", \"silver\", \"lenovo\"], [\"phone\", \"gold\", \"iphone\"]], ruleKey = \"color\", ruleValue = \"silver\"",
    "output": "1"
  },
  {
    "input": "items = [[\"phone\", \"blue\", \"pixel\"], [\"computer\", \"silver\", \"lenovo\"], [\"phone\", \"gold\", \"iphone\"]], ruleKey = \"type\", ruleValue = \"phone\"",
    "output": "2"
  },
  {
    "input": "items = [[\"phone\", \"blue\", \"pixel\"], [\"computer\", \"silver\", \"lenovo\"], [\"phone\", \"gold\", \"iphone\"]], ruleKey = \"name\", ruleValue = \"pixel\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "items = [[\"phone\", \"blue\", \"pixel\"], [\"computer\", \"silver\", \"lenovo\"], [\"phone\", \"gold\", \"iphone\"]], ruleKey = \"color\", ruleValue = \"silver\"",
    "output": "1"
  },
  {
    "input": "items = [[\"phone\", \"blue\", \"pixel\"], [\"computer\", \"silver\", \"lenovo\"], [\"phone\", \"gold\", \"iphone\"]], ruleKey = \"type\", ruleValue = \"phone\"",
    "output": "2"
  },
  {
    "input": "items = [[\"phone\", \"blue\", \"pixel\"], [\"computer\", \"silver\", \"lenovo\"], [\"phone\", \"gold\", \"iphone\"]], ruleKey = \"name\", ruleValue = \"pixel\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countMatches = function(items, ruleKey, ruleValue) {\n};\n",
  "python": "class Solution:\n    def countMatches(self, items: list[list[str]], ruleKey: str, ruleValue: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countMatches(std::vector<std::vector<std::string>>& items, std::string ruleKey, std::string ruleValue) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countMatches(String[][] items, String ruleKey, String ruleValue) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countMatches",
  "params": [
    {
      "name": "items",
      "type": "string[][]"
    },
    {
      "name": "ruleKey",
      "type": "string"
    },
    {
      "name": "ruleValue",
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
          [
            "phone",
            "blue",
            "pixel"
          ],
          [
            "computer",
            "silver",
            "lenovo"
          ],
          [
            "phone",
            "gold",
            "iphone"
          ]
        ],
        "color",
        "silver"
      ],
      "expected": 1
    },
    {
      "args": [
        [
          [
            "phone",
            "blue",
            "pixel"
          ],
          [
            "computer",
            "silver",
            "lenovo"
          ],
          [
            "phone",
            "gold",
            "iphone"
          ]
        ],
        "type",
        "phone"
      ],
      "expected": 2
    },
    {
      "args": [
        [
          [
            "phone",
            "blue",
            "pixel"
          ],
          [
            "computer",
            "silver",
            "lenovo"
          ],
          [
            "phone",
            "gold",
            "iphone"
          ]
        ],
        "name",
        "pixel"
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
          "a",
          "b",
          "c"
        ]
      ],
      "type",
      "a"
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          "a",
          "b",
          "c"
        ]
      ],
      "color",
      "x"
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          "a",
          "b",
          "c"
        ]
      ],
      "name",
      "c"
    ],
    "expected": 1
  },
  {
    "args": [
      [
        [
          "x",
          "y",
          "z"
        ],
        [
          "x",
          "y",
          "z"
        ]
      ],
      "type",
      "x"
    ],
    "expected": 2
  },
  {
    "args": [
      [
        [
          "phone",
          "blue",
          "pixel"
        ]
      ],
      "name",
      "pixel"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1927,
    '找到最近的有相同 X 或 Y 坐标的点',
    '给定整数 x、y 和点坐标数组 points，每个点由 [x_i, y_i] 表示
如果某个点与 (x, y) 有相同的横坐标或相同的纵坐标，则称它是有效点
返回距离 (x, y) 曼哈顿距离最近的有效点下标；距离相同时返回下标最小的点
如果没有有效点，返回 -1',
    'easy',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "x = 3, y = 4, points = [[1, 2], [3, 1], [2, 4], [2, 3], [4, 4]]",
    "output": "2"
  },
  {
    "input": "x = 3, y = 4, points = [[3, 4]]",
    "output": "0"
  },
  {
    "input": "x = 3, y = 4, points = [[2, 3]]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "x = 3, y = 4, points = [[1, 2], [3, 1], [2, 4], [2, 3], [4, 4]]",
    "output": "2"
  },
  {
    "input": "x = 3, y = 4, points = [[3, 4]]",
    "output": "0"
  },
  {
    "input": "x = 3, y = 4, points = [[2, 3]]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var nearestValidPoint = function(x, y, points) {\n};\n",
  "python": "class Solution:\n    def nearestValidPoint(self, x: int, y: int, points: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int nearestValidPoint(int x, int y, std::vector<std::vector<int>>& points) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int nearestValidPoint(int x, int y, int[][] points) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "nearestValidPoint",
  "params": [
    {
      "name": "x",
      "type": "int"
    },
    {
      "name": "y",
      "type": "int"
    },
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
        3,
        4,
        [
          [
            1,
            2
          ],
          [
            3,
            1
          ],
          [
            2,
            4
          ],
          [
            2,
            3
          ],
          [
            4,
            4
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        3,
        4,
        [
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
        3,
        4,
        [
          [
            2,
            3
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
      1,
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
      1,
      1,
      [
        [
          2,
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
      5,
      5,
      [
        [
          6,
          6
        ],
        [
          5,
          5
        ]
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      0,
      0,
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
      0,
      0,
      [
        [
          2,
          2
        ]
      ]
    ],
    "expected": -1
  }
]$json$::jsonb,
    'approved'
),
(
    1928,
    '检查二进制字符串字段',
    '给定一个只含 0 和 1 的字符串 s
如果字符串中所有的 1 构成至多一个连续段，返回 true，否则返回 false
只含 0 的字符串视为满足条件',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
  {
    "input": "s = \"1001\"",
    "output": "false"
  },
  {
    "input": "s = \"110\"",
    "output": "true"
  },
  {
    "input": "s = \"1\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"1001\"",
    "output": "false"
  },
  {
    "input": "s = \"110\"",
    "output": "true"
  },
  {
    "input": "s = \"1\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var checkOnesSegment = function(s) {\n};\n",
  "python": "class Solution:\n    def checkOnesSegment(self, s: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool checkOnesSegment(std::string s) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean checkOnesSegment(String s) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkOnesSegment",
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
        "1001"
      ],
      "expected": false
    },
    {
      "args": [
        "110"
      ],
      "expected": true
    },
    {
      "args": [
        "1"
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "0"
    ],
    "expected": true
  },
  {
    "args": [
      "10"
    ],
    "expected": true
  },
  {
    "args": [
      "01"
    ],
    "expected": false
  },
  {
    "args": [
      "101"
    ],
    "expected": false
  },
  {
    "args": [
      "111000"
    ],
    "expected": true
  },
  {
    "args": [
      "110011"
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    1929,
    '仅执行一次字符串交换能否使两个字符串相等',
    '给定两个长度相同的字符串 s1 和 s2
判断能否最多交换 s1 中的两个字母一次，使得交换后 s1 与 s2 相等
不交换也算满足条件',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "s1 = \"bank\", s2 = \"kanb\"",
    "output": "true"
  },
  {
    "input": "s1 = \"attack\", s2 = \"defend\"",
    "output": "false"
  },
  {
    "input": "s1 = \"kelb\", s2 = \"kelb\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s1 = \"bank\", s2 = \"kanb\"",
    "output": "true"
  },
  {
    "input": "s1 = \"attack\", s2 = \"defend\"",
    "output": "false"
  },
  {
    "input": "s1 = \"kelb\", s2 = \"kelb\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var areAlmostEqual = function(s1, s2) {\n};\n",
  "python": "class Solution:\n    def areAlmostEqual(self, s1: str, s2: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool areAlmostEqual(std::string s1, std::string s2) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean areAlmostEqual(String s1, String s2) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "areAlmostEqual",
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
        "bank",
        "kanb"
      ],
      "expected": true
    },
    {
      "args": [
        "attack",
        "defend"
      ],
      "expected": false
    },
    {
      "args": [
        "kelb",
        "kelb"
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "ab",
      "ba"
    ],
    "expected": true
  },
  {
    "args": [
      "ab",
      "ab"
    ],
    "expected": true
  },
  {
    "args": [
      "abc",
      "abd"
    ],
    "expected": false
  },
  {
    "args": [
      "abcd",
      "badc"
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
      "abc",
      "acb"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1930,
    '字符串中第二大的数字',
    '给定一个包含字母和数字的字符串 s
返回字符串中出现过的第二大不同数字
如果不存在第二大的不同数字，返回 -1',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "s = \"dfa12321afd\"",
    "output": "2"
  },
  {
    "input": "s = \"abc1111\"",
    "output": "-1"
  },
  {
    "input": "s = \"ck077\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"dfa12321afd\"",
    "output": "2"
  },
  {
    "input": "s = \"abc1111\"",
    "output": "-1"
  },
  {
    "input": "s = \"ck077\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var secondHighest = function(s) {\n};\n",
  "python": "class Solution:\n    def secondHighest(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int secondHighest(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int secondHighest(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "secondHighest",
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
        "dfa12321afd"
      ],
      "expected": 2
    },
    {
      "args": [
        "abc1111"
      ],
      "expected": -1
    },
    {
      "args": [
        "ck077"
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abc"
    ],
    "expected": -1
  },
  {
    "args": [
      "a1b2c3"
    ],
    "expected": 2
  },
  {
    "args": [
      "999"
    ],
    "expected": -1
  },
  {
    "args": [
      "0"
    ],
    "expected": -1
  },
  {
    "args": [
      "102"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1931,
    '最大升序子数组和',
    '给定一个正整数数组 nums
返回所有严格递增的连续子数组中的最大元素和
子数组至少包含一个元素',
    'easy',
    1000,
    256,
    ARRAY['数组'],
    $json$[
  {
    "input": "nums = [10, 20, 30, 5, 10, 50]",
    "output": "65"
  },
  {
    "input": "nums = [10, 20, 30, 40, 50]",
    "output": "150"
  },
  {
    "input": "nums = [12, 17, 15, 13, 10, 11, 12]",
    "output": "33"
  },
  {
    "input": "nums = [100, 10, 1]",
    "output": "100"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [10, 20, 30, 5, 10, 50]",
    "output": "65"
  },
  {
    "input": "nums = [10, 20, 30, 40, 50]",
    "output": "150"
  },
  {
    "input": "nums = [12, 17, 15, 13, 10, 11, 12]",
    "output": "33"
  },
  {
    "input": "nums = [100, 10, 1]",
    "output": "100"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxAscendingSum = function(nums) {\n};\n",
  "python": "class Solution:\n    def maxAscendingSum(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxAscendingSum(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxAscendingSum(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxAscendingSum",
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
          20,
          30,
          5,
          10,
          50
        ]
      ],
      "expected": 65
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
      "expected": 150
    },
    {
      "args": [
        [
          12,
          17,
          15,
          13,
          10,
          11,
          12
        ]
      ],
      "expected": 33
    },
    {
      "args": [
        [
          100,
          10,
          1
        ]
      ],
      "expected": 100
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
        5,
        4,
        3
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
    "expected": 4
  },
  {
    "args": [
      [
        1,
        2,
        3,
        0,
        5
      ]
    ],
    "expected": 6
  }
]$json$::jsonb,
    'approved'
),
(
    1932,
    '字符串中不同整数的数目',
    '给定一个由字母和数字组成的字符串 word
连续的若干位数字组成一个整数，前导零不影响整数的大小
返回字符串中不同整数的数目
例如 "01" 和 "1" 视为同一个整数',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "word = \"a123bc34d8ef34\"",
    "output": "3"
  },
  {
    "input": "word = \"leet1234code234\"",
    "output": "2"
  },
  {
    "input": "word = \"a1b01c001\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "word = \"a123bc34d8ef34\"",
    "output": "3"
  },
  {
    "input": "word = \"leet1234code234\"",
    "output": "2"
  },
  {
    "input": "word = \"a1b01c001\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numDifferentIntegers = function(word) {\n};\n",
  "python": "class Solution:\n    def numDifferentIntegers(self, word: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numDifferentIntegers(std::string word) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numDifferentIntegers(String word) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numDifferentIntegers",
  "params": [
    {
      "name": "word",
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
        "a123bc34d8ef34"
      ],
      "expected": 3
    },
    {
      "args": [
        "leet1234code234"
      ],
      "expected": 2
    },
    {
      "args": [
        "a1b01c001"
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abc"
    ],
    "expected": 0
  },
  {
    "args": [
      "0"
    ],
    "expected": 1
  },
  {
    "args": [
      "000"
    ],
    "expected": 1
  },
  {
    "args": [
      "a0b00c000"
    ],
    "expected": 1
  },
  {
    "args": [
      "123"
    ],
    "expected": 1
  },
  {
    "args": [
      "a1b2c3"
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1933,
    '数组元素积的符号',
    '给定一个整数数组 nums
计算所有元素乘积的符号：乘积为正返回 1，为负返回 -1，为 0 返回 0
注意不需要求出实际乘积',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "nums = [-1, -2, -3, -4, 3, 2, 1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 5, 0, 2, -3]",
    "output": "0"
  },
  {
    "input": "nums = [-1, 1, -1, 1, -1]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [-1, -2, -3, -4, 3, 2, 1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 5, 0, 2, -3]",
    "output": "0"
  },
  {
    "input": "nums = [-1, 1, -1, 1, -1]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var arraySign = function(nums) {\n};\n",
  "python": "class Solution:\n    def arraySign(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int arraySign(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int arraySign(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "arraySign",
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
          -1,
          -2,
          -3,
          -4,
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
          5,
          0,
          2,
          -3
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          -1,
          1,
          -1,
          1,
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
        0
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
        0,
        -1
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1934,
    '判断句子是否为全字母句',
    '给定一个只含小写英文字母的字符串 sentence
如果句子中至少出现一次从 a 到 z 的全部 26 个字母，返回 true，否则返回 false',
    'easy',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "sentence = \"thequickbrownfoxjumpsoverthelazydog\"",
    "output": "true"
  },
  {
    "input": "sentence = \"leetcode\"",
    "output": "false"
  },
  {
    "input": "sentence = \"abcdefghijklmnopqrstuvwxyz\"",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "sentence = \"thequickbrownfoxjumpsoverthelazydog\"",
    "output": "true"
  },
  {
    "input": "sentence = \"leetcode\"",
    "output": "false"
  },
  {
    "input": "sentence = \"abcdefghijklmnopqrstuvwxyz\"",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var checkIfPangram = function(sentence) {\n};\n",
  "python": "class Solution:\n    def checkIfPangram(self, sentence: str) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool checkIfPangram(std::string sentence) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean checkIfPangram(String sentence) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkIfPangram",
  "params": [
    {
      "name": "sentence",
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
        "thequickbrownfoxjumpsoverthelazydog"
      ],
      "expected": true
    },
    {
      "args": [
        "leetcode"
      ],
      "expected": false
    },
    {
      "args": [
        "abcdefghijklmnopqrstuvwxyz"
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
      "abcdefghijklmnopqrstuvwxyzabc"
    ],
    "expected": true
  },
  {
    "args": [
      "thequickbrownfoxjumpsoverthelazydogz"
    ],
    "expected": true
  },
  {
    "args": [
      "abcde"
    ],
    "expected": false
  },
  {
    "args": [
      "zyxwvutsrqponmlkjihgfedcba"
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1935,
    '将所有数字用字符替换',
    '给定一个字符串 s，偶数下标为小写字母，奇数下标为数字
对于每个奇数下标 i，将数字 d = s[i] 替换为字母 s[i - 1] 向后移动 d 位得到的字母
题目保证替换后的字母仍为小写字母，返回替换后的字符串',
    'easy',
    1000,
    256,
    ARRAY['字符串', '模拟'],
    $json$[
  {
    "input": "s = \"a1c1e1\"",
    "output": "\"abcdef\""
  },
  {
    "input": "s = \"a1b2c3d4e\"",
    "output": "\"abbdcfdhe\""
  },
  {
    "input": "s = \"z0\"",
    "output": "\"zz\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"a1c1e1\"",
    "output": "\"abcdef\""
  },
  {
    "input": "s = \"a1b2c3d4e\"",
    "output": "\"abbdcfdhe\""
  },
  {
    "input": "s = \"z0\"",
    "output": "\"zz\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var replaceDigits = function(s) {\n};\n",
  "python": "class Solution:\n    def replaceDigits(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string replaceDigits(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String replaceDigits(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "replaceDigits",
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
        "a1c1e1"
      ],
      "expected": "abcdef"
    },
    {
      "args": [
        "a1b2c3d4e"
      ],
      "expected": "abbdcfdhe"
    },
    {
      "args": [
        "z0"
      ],
      "expected": "zz"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a0"
    ],
    "expected": "aa"
  },
  {
    "args": [
      "b3"
    ],
    "expected": "be"
  },
  {
    "args": [
      "m5"
    ],
    "expected": "mr"
  },
  {
    "args": [
      "x2"
    ],
    "expected": "xz"
  },
  {
    "args": [
      "c2d4"
    ],
    "expected": "cedh"
  },
  {
    "args": [
      "y1"
    ],
    "expected": "yz"
  }
]$json$::jsonb,
    'approved'
),
(
    1936,
    '人口最多的年份',
    '给定二维整数数组 logs，其中 logs[i] = [birth_i, death_i] 表示第 i 个人的出生和死亡年份
一个人在 [birth_i, death_i) 区间内计入人口，即死亡当年不计入
返回人口最多且最早的年份',
    'easy',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "logs = [[1993, 1999], [2000, 2010]]",
    "output": "1993"
  },
  {
    "input": "logs = [[1950, 1961], [1960, 1971], [1970, 1981]]",
    "output": "1960"
  },
  {
    "input": "logs = [[2030, 2040], [2035, 2045]]",
    "output": "2035"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "logs = [[1993, 1999], [2000, 2010]]",
    "output": "1993"
  },
  {
    "input": "logs = [[1950, 1961], [1960, 1971], [1970, 1981]]",
    "output": "1960"
  },
  {
    "input": "logs = [[2030, 2040], [2035, 2045]]",
    "output": "2035"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumPopulation = function(logs) {\n};\n",
  "python": "class Solution:\n    def maximumPopulation(self, logs: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumPopulation(std::vector<std::vector<int>>& logs) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumPopulation(int[][] logs) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumPopulation",
  "params": [
    {
      "name": "logs",
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
            1993,
            1999
          ],
          [
            2000,
            2010
          ]
        ]
      ],
      "expected": 1993
    },
    {
      "args": [
        [
          [
            1950,
            1961
          ],
          [
            1960,
            1971
          ],
          [
            1970,
            1981
          ]
        ]
      ],
      "expected": 1960
    },
    {
      "args": [
        [
          [
            2030,
            2040
          ],
          [
            2035,
            2045
          ]
        ]
      ],
      "expected": 2035
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        [
          2000,
          2001
        ]
      ]
    ],
    "expected": 2000
  },
  {
    "args": [
      [
        [
          1950,
          1951
        ],
        [
          1951,
          1952
        ]
      ]
    ],
    "expected": 1950
  },
  {
    "args": [
      [
        [
          1960,
          1970
        ],
        [
          1960,
          1970
        ]
      ]
    ],
    "expected": 1960
  },
  {
    "args": [
      [
        [
          1950,
          2050
        ]
      ]
    ],
    "expected": 1950
  },
  {
    "args": [
      [
        [
          2000,
          2010
        ],
        [
          2001,
          2009
        ]
      ]
    ],
    "expected": 2001
  }
]$json$::jsonb,
    'approved'
),
(
    1937,
    '将句子排序',
    '给定一个句子 s，单词之间用一个空格分隔
每个单词的末尾都有一个 1 到 9 的数字，表示它在原句中的位置，且每个位置恰好出现一次
按这些位置数字升序重新排列单词，并去掉末尾数字
返回恢复后的句子',
    'easy',
    1000,
    256,
    ARRAY['字符串', '排序'],
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
    "input": "s = \"world2 hello1\"",
    "output": "\"hello world\""
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
    "input": "s = \"world2 hello1\"",
    "output": "\"hello world\""
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
        "world2 hello1"
      ],
      "expected": "hello world"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a1"
    ],
    "expected": "a"
  },
  {
    "args": [
      "b2 a1"
    ],
    "expected": "a b"
  },
  {
    "args": [
      "c3 a1 b2"
    ],
    "expected": "a b c"
  },
  {
    "args": [
      "word1"
    ],
    "expected": "word"
  },
  {
    "args": [
      "z9 a1"
    ],
    "expected": "a z"
  }
]$json$::jsonb,
    'approved'
),
(
    1938,
    '链表游戏的获胜者',
    '给定一个节点个数为偶数的单链表，节点值均为正整数。
从 0 开始编号，将偶数下标节点的值之和记为 evenSum，奇数下标节点的值之和记为 oddSum。
若 evenSum 大于 oddSum，返回 "Even"，若 oddSum 大于 evenSum 返回 "Odd"，两者相等返回 "Tie"。',
    'easy',
    1000,
    256,
    ARRAY['链表'],
    $json$[
  {
    "input": "head = [2, 1]",
    "output": "\"Even\""
  },
  {
    "input": "head = [4, 5, 2, 1]",
    "output": "\"Tie\""
  },
  {
    "input": "head = [1, 2, 3, 4]",
    "output": "\"Odd\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [2, 1]",
    "output": "\"Even\""
  },
  {
    "input": "head = [4, 5, 2, 1]",
    "output": "\"Tie\""
  },
  {
    "input": "head = [1, 2, 3, 4]",
    "output": "\"Odd\""
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar gameResult = function(head) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def gameResult(self, head: ListNode | None) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::string gameResult(ListNode* head) {\n        return \"\";\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public String gameResult(ListNode head) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "gameResult",
  "params": [
    {
      "name": "head",
      "type": "ListNode"
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
          2,
          1
        ]
      ],
      "expected": "Even"
    },
    {
      "args": [
        [
          4,
          5,
          2,
          1
        ]
      ],
      "expected": "Tie"
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
      "expected": "Odd"
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
    "expected": "Tie"
  },
  {
    "args": [
      [
        5,
        2,
        3,
        4
      ]
    ],
    "expected": "Even"
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
    "expected": "Odd"
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
    "expected": "Tie"
  },
  {
    "args": [
      [
        3,
        9,
        2,
        8
      ]
    ],
    "expected": "Odd"
  }
]$json$::jsonb,
    'approved'
),
(
    1939,
    '删除链表的中间节点',
    '给定一个单链表，删除它的中间节点并返回新的头节点。
若有偶数个节点，中间节点为下标 n / 2 的节点（下标从 0 开始，向下取整）。
只有一个节点时，删除后返回空链表。',
    'easy',
    1000,
    256,
    ARRAY['链表', '双指针'],
    $json$[
  {
    "input": "head = [1, 3, 4, 7, 1, 2, 6]",
    "output": "[1, 3, 4, 1, 2, 6]"
  },
  {
    "input": "head = [1, 2, 3, 4]",
    "output": "[1, 2, 4]"
  },
  {
    "input": "head = [2, 1]",
    "output": "[2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "head = [1, 3, 4, 7, 1, 2, 6]",
    "output": "[1, 3, 4, 1, 2, 6]"
  },
  {
    "input": "head = [1, 2, 3, 4]",
    "output": "[1, 2, 4]"
  },
  {
    "input": "head = [2, 1]",
    "output": "[2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar deleteMiddle = function(head) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def deleteMiddle(self, head: ListNode | None) -> ListNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    ListNode* deleteMiddle(ListNode* head) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode deleteMiddle(ListNode head) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "deleteMiddle",
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
          3,
          4,
          7,
          1,
          2,
          6
        ]
      ],
      "expected": [
        1,
        3,
        4,
        1,
        2,
        6
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
        4
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
    "expected": [
      1,
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
        6
      ]
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
    1940,
    '删除子串后的字符串最小长度',
    '给定只含大写字母的字符串 s。
重复执行操作：删除任意一个子串 "AB" 或 "CD"，直到无法继续删除。
返回最终字符串可能的最小长度。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '栈'],
    $json$[
  {
    "input": "s = \"ABFCACDB\"",
    "output": "2"
  },
  {
    "input": "s = \"ACBBD\"",
    "output": "5"
  },
  {
    "input": "s = \"AB\"",
    "output": "0"
  },
  {
    "input": "s = \"CD\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"ABFCACDB\"",
    "output": "2"
  },
  {
    "input": "s = \"ACBBD\"",
    "output": "5"
  },
  {
    "input": "s = \"AB\"",
    "output": "0"
  },
  {
    "input": "s = \"CD\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minLength = function(s) {\n};\n",
  "python": "class Solution:\n    def minLength(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minLength(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minLength(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minLength",
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
        "ABFCACDB"
      ],
      "expected": 2
    },
    {
      "args": [
        "ACBBD"
      ],
      "expected": 5
    },
    {
      "args": [
        "AB"
      ],
      "expected": 0
    },
    {
      "args": [
        "CD"
      ],
      "expected": 0
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
      "ACB"
    ],
    "expected": 3
  },
  {
    "args": [
      "ABCD"
    ],
    "expected": 0
  },
  {
    "args": [
      "AABB"
    ],
    "expected": 0
  },
  {
    "args": [
      "CABD"
    ],
    "expected": 0
  },
  {
    "args": [
      "ABCABC"
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1941,
    '用栈操作构建数组',
    '给定严格递增的整数数组 target 和整数 n，target 中元素都在 1 到 n 之间。
从 1 到 n 依次处理每个数字：先执行一次 "Push"；若该数字不在 target 中，
紧接着执行一次 "Pop" 把它弹出；否则保留在栈中。
当 target 中最后一个数字已经保留在栈中时立即停止。
返回得到的操作序列，顺序与原操作顺序一致。',
    'easy',
    1000,
    256,
    ARRAY['数组', '栈'],
    $json$[
  {
    "input": "target = [1, 3], n = 3",
    "output": "[\"Push\", \"Push\", \"Pop\", \"Push\"]"
  },
  {
    "input": "target = [1, 2, 3], n = 3",
    "output": "[\"Push\", \"Push\", \"Push\"]"
  },
  {
    "input": "target = [2, 3, 4], n = 4",
    "output": "[\"Push\", \"Pop\", \"Push\", \"Push\", \"Push\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "target = [1, 3], n = 3",
    "output": "[\"Push\", \"Push\", \"Pop\", \"Push\"]"
  },
  {
    "input": "target = [1, 2, 3], n = 3",
    "output": "[\"Push\", \"Push\", \"Push\"]"
  },
  {
    "input": "target = [2, 3, 4], n = 4",
    "output": "[\"Push\", \"Pop\", \"Push\", \"Push\", \"Push\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var buildArray = function(target, n) {\n};\n",
  "python": "class Solution:\n    def buildArray(self, target: list[int], n: int) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> buildArray(std::vector<int>& target, int n) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] buildArray(int[] target, int n) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "buildArray",
  "params": [
    {
      "name": "target",
      "type": "int[]"
    },
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
        [
          1,
          3
        ],
        3
      ],
      "expected": [
        "Push",
        "Push",
        "Pop",
        "Push"
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
        "Push",
        "Push",
        "Push"
      ]
    },
    {
      "args": [
        [
          2,
          3,
          4
        ],
        4
      ],
      "expected": [
        "Push",
        "Pop",
        "Push",
        "Push",
        "Push"
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
      "Push"
    ]
  },
  {
    "args": [
      [
        2
      ],
      2
    ],
    "expected": [
      "Push",
      "Pop",
      "Push"
    ]
  },
  {
    "args": [
      [
        1,
        4
      ],
      4
    ],
    "expected": [
      "Push",
      "Push",
      "Pop",
      "Push",
      "Pop",
      "Push"
    ]
  },
  {
    "args": [
      [
        3,
        5
      ],
      5
    ],
    "expected": [
      "Push",
      "Pop",
      "Push",
      "Pop",
      "Push",
      "Push",
      "Pop",
      "Push"
    ]
  },
  {
    "args": [
      [
        2,
        6
      ],
      6
    ],
    "expected": [
      "Push",
      "Pop",
      "Push",
      "Push",
      "Pop",
      "Push",
      "Pop",
      "Push",
      "Pop",
      "Push"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1942,
    '从字符串中移除星号',
    '给定字符串 s，其中 ''*'' 表示删除操作：移除它左侧最近的一个非星号字符。
若当前 ''*'' 左侧没有可删除的字符，则该操作不产生额外影响。
返回执行完所有删除后的字符串。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '栈'],
    $json$[
  {
    "input": "s = \"leet**cod*e\"",
    "output": "\"lecoe\""
  },
  {
    "input": "s = \"erase*****\"",
    "output": "\"\""
  },
  {
    "input": "s = \"a*b*c*\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"leet**cod*e\"",
    "output": "\"lecoe\""
  },
  {
    "input": "s = \"erase*****\"",
    "output": "\"\""
  },
  {
    "input": "s = \"a*b*c*\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeStars = function(s) {\n};\n",
  "python": "class Solution:\n    def removeStars(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string removeStars(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String removeStars(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeStars",
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
        "leet**cod*e"
      ],
      "expected": "lecoe"
    },
    {
      "args": [
        "erase*****"
      ],
      "expected": ""
    },
    {
      "args": [
        "a*b*c*"
      ],
      "expected": ""
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "*"
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
      "a**b"
    ],
    "expected": "b"
  },
  {
    "args": [
      "ab*c*"
    ],
    "expected": "a"
  },
  {
    "args": [
      "z*"
    ],
    "expected": ""
  }
]$json$::jsonb,
    'approved'
),
(
    1943,
    '清除数字',
    '给定一个字符串 s，其中可能包含小写字母和数字。
每次删除一个数字字符以及它左侧最近的一个非数字字符，重复直到字符串中没有数字。
返回最终字符串。若某次删除时左侧没有非数字字符，则只删除该数字。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '栈'],
    $json$[
  {
    "input": "s = \"cb34\"",
    "output": "\"\""
  },
  {
    "input": "s = \"a1b2\"",
    "output": "\"\""
  },
  {
    "input": "s = \"abc\"",
    "output": "\"abc\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"cb34\"",
    "output": "\"\""
  },
  {
    "input": "s = \"a1b2\"",
    "output": "\"\""
  },
  {
    "input": "s = \"abc\"",
    "output": "\"abc\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var clearDigits = function(s) {\n};\n",
  "python": "class Solution:\n    def clearDigits(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string clearDigits(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String clearDigits(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "clearDigits",
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
        "cb34"
      ],
      "expected": ""
    },
    {
      "args": [
        "a1b2"
      ],
      "expected": ""
    },
    {
      "args": [
        "abc"
      ],
      "expected": "abc"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "1"
    ],
    "expected": ""
  },
  {
    "args": [
      "ab2c3"
    ],
    "expected": "a"
  },
  {
    "args": [
      "a1b2c3"
    ],
    "expected": ""
  },
  {
    "args": [
      "xy9"
    ],
    "expected": "x"
  },
  {
    "args": [
      "a1"
    ],
    "expected": ""
  }
]$json$::jsonb,
    'approved'
),
(
    1944,
    '最近的请求次数',
    '给定一个严格递增的整数数组 pings，每个元素表示一次请求发生的毫秒时间。
对每一次请求 t，统计闭区间 [t - 3000, t] 内发生的请求总数（包含当前请求）。
返回与 pings 等长的数组，第 i 个元素对应第 i 次请求时的统计结果。',
    'easy',
    1000,
    256,
    ARRAY['队列', '设计'],
    $json$[
  {
    "input": "pings = [1, 100, 3001, 3002]",
    "output": "[1, 2, 3, 3]"
  },
  {
    "input": "pings = [1, 2, 3, 4]",
    "output": "[1, 2, 3, 4]"
  },
  {
    "input": "pings = [642, 1849, 4921, 5936, 5957]",
    "output": "[1, 2, 1, 2, 3]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "pings = [1, 100, 3001, 3002]",
    "output": "[1, 2, 3, 3]"
  },
  {
    "input": "pings = [1, 2, 3, 4]",
    "output": "[1, 2, 3, 4]"
  },
  {
    "input": "pings = [642, 1849, 4921, 5936, 5957]",
    "output": "[1, 2, 1, 2, 3]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var recentCounter = function(pings) {\n};\n",
  "python": "class Solution:\n    def recentCounter(self, pings: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> recentCounter(std::vector<int>& pings) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] recentCounter(int[] pings) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "recentCounter",
  "params": [
    {
      "name": "pings",
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
          100,
          3001,
          3002
        ]
      ],
      "expected": [
        1,
        2,
        3,
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
        2,
        3,
        4
      ]
    },
    {
      "args": [
        [
          642,
          1849,
          4921,
          5936,
          5957
        ]
      ],
      "expected": [
        1,
        2,
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
        3001
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
        5000,
        5001,
        5002
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
        100,
        200,
        300,
        4000
      ]
    ],
    "expected": [
      1,
      2,
      3,
      4,
      1
    ]
  },
  {
    "args": [
      [
        0,
        3000,
        3001
      ]
    ],
    "expected": [
      1,
      2,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1945,
    '找出游戏的获胜者',
    'n 个朋友围成一圈，编号从 1 到 n。从编号 1 开始报数，报到 k 的人出圈，
下一个人重新从 1 开始报数，如此重复，直到只剩一个人。
返回最后剩下的那个人的编号。',
    'easy',
    1000,
    256,
    ARRAY['队列', '数学', '模拟'],
    $json$[
  {
    "input": "n = 5, k = 2",
    "output": "3"
  },
  {
    "input": "n = 6, k = 5",
    "output": "1"
  },
  {
    "input": "n = 1, k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5, k = 2",
    "output": "3"
  },
  {
    "input": "n = 6, k = 5",
    "output": "1"
  },
  {
    "input": "n = 1, k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findTheWinner = function(n, k) {\n};\n",
  "python": "class Solution:\n    def findTheWinner(self, n: int, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findTheWinner(int n, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findTheWinner(int n, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findTheWinner",
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
        5,
        2
      ],
      "expected": 3
    },
    {
      "args": [
        6,
        5
      ],
      "expected": 1
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
      2,
      1
    ],
    "expected": 2
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
      5,
      3
    ],
    "expected": 4
  },
  {
    "args": [
      10,
      4
    ],
    "expected": 5
  },
  {
    "args": [
      7,
      7
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1946,
    '两数之和 IV - 输入 BST',
    '给定一棵二叉搜索树的层序遍历序列 root（None 表示空位）和整数 k。
判断树中是否存在两个不同节点，它们的值之和恰好等于 k。',
    'easy',
    1000,
    256,
    ARRAY['树', '二叉搜索树', '哈希表'],
    $json$[
  {
    "input": "root = [5, 3, 6, 2, 4, null, 7], k = 9",
    "output": "true"
  },
  {
    "input": "root = [5, 3, 6, 2, 4, null, 7], k = 28",
    "output": "false"
  },
  {
    "input": "root = [2, 1, 3], k = 4",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [5, 3, 6, 2, 4, null, 7], k = 9",
    "output": "true"
  },
  {
    "input": "root = [5, 3, 6, 2, 4, null, 7], k = 28",
    "output": "false"
  },
  {
    "input": "root = [2, 1, 3], k = 4",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar findTarget = function(root, k) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def findTarget(self, root: TreeNode | None, k: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    bool findTarget(TreeNode* root, int k) {\n        return false;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public boolean findTarget(TreeNode root, int k) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findTarget",
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
  "return_type": "bool",
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
        9
      ],
      "expected": true
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
        28
      ],
      "expected": false
    },
    {
      "args": [
        [
          2,
          1,
          3
        ],
        4
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
      2
    ],
    "expected": false
  },
  {
    "args": [
      [
        2,
        1,
        3
      ],
      3
    ],
    "expected": true
  },
  {
    "args": [
      [
        2,
        1,
        3
      ],
      5
    ],
    "expected": true
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
      10
    ],
    "expected": true
  },
  {
    "args": [
      [
        1,
        null,
        2
      ],
      3
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1947,
    '找树左下角的值',
    '给定一棵二叉树的层序遍历序列 root（None 表示空位）。
返回该树最底层最左边节点的值。',
    'easy',
    1000,
    256,
    ARRAY['树', '广度优先搜索'],
    $json$[
  {
    "input": "root = [2, 1, 3]",
    "output": "1"
  },
  {
    "input": "root = [1, 2, 3, 4, null, 5, 6, null, null, 7]",
    "output": "7"
  },
  {
    "input": "root = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [2, 1, 3]",
    "output": "1"
  },
  {
    "input": "root = [1, 2, 3, 4, null, 5, 6, null, null, 7]",
    "output": "7"
  },
  {
    "input": "root = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar findBottomLeftValue = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def findBottomLeftValue(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int findBottomLeftValue(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int findBottomLeftValue(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findBottomLeftValue",
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
          2,
          3,
          4,
          null,
          5,
          6,
          null,
          null,
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
    "expected": 2
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
        3,
        1,
        5,
        0,
        2,
        4,
        6
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
]$json$::jsonb,
    'approved'
),
(
    1948,
    '二叉树中的第 K 大层和',
    '给定一棵二叉树的层序遍历序列 root（None 表示空位）和整数 k。
每一层的层和是该层所有节点值之和。将所有层和按从大到小排序，
返回第 k 大的层和；若树的层数少于 k，返回 -1。',
    'easy',
    1000,
    256,
    ARRAY['树', '广度优先搜索', '排序'],
    $json$[
  {
    "input": "root = [5, 8, 9, 2, 1, 3, 7, 4, 6], k = 2",
    "output": "13"
  },
  {
    "input": "root = [1, 2, null, 3], k = 1",
    "output": "3"
  },
  {
    "input": "root = [1], k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [5, 8, 9, 2, 1, 3, 7, 4, 6], k = 2",
    "output": "13"
  },
  {
    "input": "root = [1, 2, null, 3], k = 1",
    "output": "3"
  },
  {
    "input": "root = [1], k = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar kthLargestLevelSum = function(root, k) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def kthLargestLevelSum(self, root: TreeNode | None, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    long long kthLargestLevelSum(TreeNode* root, int k) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public long kthLargestLevelSum(TreeNode root, int k) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kthLargestLevelSum",
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
  "return_type": "long",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        [
          5,
          8,
          9,
          2,
          1,
          3,
          7,
          4,
          6
        ],
        2
      ],
      "expected": 13
    },
    {
      "args": [
        [
          1,
          2,
          null,
          3
        ],
        1
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
    "expected": -1
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
    "expected": -1
  },
  {
    "args": [
      [
        1,
        2,
        null,
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
        3,
        4,
        1,
        5,
        6,
        7
      ],
      4
    ],
    "expected": -1
  },
  {
    "args": [
      [
        10,
        5,
        15
      ],
      2
    ],
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1949,
    '有效的完全平方数',
    '给定正整数 num，判断它是否是完全平方数。
完全平方数是指可以写成某个整数平方的数。',
    'easy',
    1000,
    256,
    ARRAY['数学', '二分查找'],
    $json$[
  {
    "input": "num = 16",
    "output": "true"
  },
  {
    "input": "num = 14",
    "output": "false"
  },
  {
    "input": "num = 1",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 16",
    "output": "true"
  },
  {
    "input": "num = 14",
    "output": "false"
  },
  {
    "input": "num = 1",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var isPerfectSquare = function(num) {\n};\n",
  "python": "class Solution:\n    def isPerfectSquare(self, num: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isPerfectSquare(int num) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean isPerfectSquare(int num) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "isPerfectSquare",
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
        16
      ],
      "expected": true
    },
    {
      "args": [
        14
      ],
      "expected": false
    },
    {
      "args": [
        1
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2
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
      100
    ],
    "expected": true
  },
  {
    "args": [
      2147395600
    ],
    "expected": true
  },
  {
    "args": [
      808201
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    1950,
    '排列硬币',
    '有 n 枚硬币，按第 1 行 1 枚、第 2 行 2 枚、第 3 行 3 枚的方式排列。
每一行都必须放满硬币，最后一行可能不满。返回可以形成的完整行数。',
    'easy',
    1000,
    256,
    ARRAY['数学', '二分查找'],
    $json$[
  {
    "input": "n = 5",
    "output": "2"
  },
  {
    "input": "n = 8",
    "output": "3"
  },
  {
    "input": "n = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5",
    "output": "2"
  },
  {
    "input": "n = 8",
    "output": "3"
  },
  {
    "input": "n = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var arrangeCoins = function(n) {\n};\n",
  "python": "class Solution:\n    def arrangeCoins(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int arrangeCoins(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int arrangeCoins(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "arrangeCoins",
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
        8
      ],
      "expected": 3
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
      6
    ],
    "expected": 3
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
    "expected": 65535
  }
]$json$::jsonb,
    'approved'
),
(
    1951,
    '范围求和 II',
    '给定 m 行 n 列的矩阵，初始所有元素为 0。
依次执行操作 ops[i] = [a, b]：将前 a 行、前 b 列的所有元素加 1。
返回执行完所有操作后矩阵中最大元素的个数。',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "m = 3, n = 3, ops = [[2, 2], [3, 3]]",
    "output": "4"
  },
  {
    "input": "m = 3, n = 3, ops = [[2, 2], [3, 3], [3, 3], [3, 3], [3, 3], [3, 3]]",
    "output": "4"
  },
  {
    "input": "m = 3, n = 3, ops = []",
    "output": "9"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "m = 3, n = 3, ops = [[2, 2], [3, 3]]",
    "output": "4"
  },
  {
    "input": "m = 3, n = 3, ops = [[2, 2], [3, 3], [3, 3], [3, 3], [3, 3], [3, 3]]",
    "output": "4"
  },
  {
    "input": "m = 3, n = 3, ops = []",
    "output": "9"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxCount = function(m, n, ops) {\n};\n",
  "python": "class Solution:\n    def maxCount(self, m: int, n: int, ops: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxCount(int m, int n, std::vector<std::vector<int>>& ops) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxCount(int m, int n, int[][] ops) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxCount",
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
      "name": "ops",
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
        3,
        3,
        [
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
      "expected": 4
    },
    {
      "args": [
        3,
        3,
        [
          [
            2,
            2
          ],
          [
            3,
            3
          ],
          [
            3,
            3
          ],
          [
            3,
            3
          ],
          [
            3,
            3
          ],
          [
            3,
            3
          ]
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        3,
        3,
        []
      ],
      "expected": 9
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
    "expected": 1
  },
  {
    "args": [
      2,
      2,
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
      3,
      4,
      [
        [
          2,
          3
        ]
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      5,
      5,
      [
        [
          5,
          5
        ]
      ]
    ],
    "expected": 25
  },
  {
    "args": [
      4,
      3,
      [
        [
          4,
          2
        ],
        [
          2,
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
    1952,
    '数组元素和与数字和的绝对差',
    '给定正整数数组 nums。
元素和是指数组中所有元素之和；数字和是指所有元素十进制表示中各位数字之和。
返回元素和与数字和的绝对差。',
    'easy',
    1000,
    256,
    ARRAY['数组', '数学'],
    $json$[
  {
    "input": "nums = [1, 15, 6, 3]",
    "output": "9"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "0"
  },
  {
    "input": "nums = [5, 10, 20]",
    "output": "27"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 15, 6, 3]",
    "output": "9"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "0"
  },
  {
    "input": "nums = [5, 10, 20]",
    "output": "27"
  }
]$json$::jsonb,
    $json${
  "javascript": "var differenceOfSum = function(nums) {\n};\n",
  "python": "class Solution:\n    def differenceOfSum(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int differenceOfSum(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int differenceOfSum(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "differenceOfSum",
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
          15,
          6,
          3
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
          4
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        [
          5,
          10,
          20
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
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        10
      ]
    ],
    "expected": 9
  },
  {
    "args": [
      [
        99
      ]
    ],
    "expected": 81
  },
  {
    "args": [
      [
        100,
        200
      ]
    ],
    "expected": 297
  },
  {
    "args": [
      [
        12,
        34
      ]
    ],
    "expected": 36
  }
]$json$::jsonb,
    'approved'
),
(
    1953,
    '交替数字和',
    '给定一个正整数 n。
从最高位开始，把各位数字按加、减、加、减的顺序交替求和（最高位取加号）。
返回最终的交替数字和。',
    'easy',
    1000,
    256,
    ARRAY['数学', '模拟'],
    $json$[
  {
    "input": "n = 521",
    "output": "4"
  },
  {
    "input": "n = 111",
    "output": "1"
  },
  {
    "input": "n = 886996",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 521",
    "output": "4"
  },
  {
    "input": "n = 111",
    "output": "1"
  },
  {
    "input": "n = 886996",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var alternateDigitSum = function(n) {\n};\n",
  "python": "class Solution:\n    def alternateDigitSum(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int alternateDigitSum(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int alternateDigitSum(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "alternateDigitSum",
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
        521
      ],
      "expected": 4
    },
    {
      "args": [
        111
      ],
      "expected": 1
    },
    {
      "args": [
        886996
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
      10
    ],
    "expected": 1
  },
  {
    "args": [
      99
    ],
    "expected": 0
  },
  {
    "args": [
      12345
    ],
    "expected": 3
  },
  {
    "args": [
      900000
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1954,
    '公因子的数目',
    '给定两个正整数 a 和 b。
返回同时整除 a 和 b 的正整数（即它们的公因子）的数目。',
    'easy',
    1000,
    256,
    ARRAY['数学', '数论'],
    $json$[
  {
    "input": "a = 12, b = 6",
    "output": "4"
  },
  {
    "input": "a = 25, b = 30",
    "output": "2"
  },
  {
    "input": "a = 8, b = 8",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "a = 12, b = 6",
    "output": "4"
  },
  {
    "input": "a = 25, b = 30",
    "output": "2"
  },
  {
    "input": "a = 8, b = 8",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var commonFactors = function(a, b) {\n};\n",
  "python": "class Solution:\n    def commonFactors(self, a: int, b: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int commonFactors(int a, int b) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int commonFactors(int a, int b) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "commonFactors",
  "params": [
    {
      "name": "a",
      "type": "int"
    },
    {
      "name": "b",
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
        12,
        6
      ],
      "expected": 4
    },
    {
      "args": [
        25,
        30
      ],
      "expected": 2
    },
    {
      "args": [
        8,
        8
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
      3
    ],
    "expected": 1
  },
  {
    "args": [
      12,
      18
    ],
    "expected": 4
  },
  {
    "args": [
      100,
      75
    ],
    "expected": 3
  },
  {
    "args": [
      7,
      13
    ],
    "expected": 1
  },
  {
    "args": [
      24,
      36
    ],
    "expected": 6
  }
]$json$::jsonb,
    'approved'
),
(
    1955,
    '哈沙德数',
    '给定一个正整数 x。
若 x 能被它的各位数字之和整除，则称 x 是哈沙德数，返回它的各位数字之和；
否则返回 -1。',
    'easy',
    1000,
    256,
    ARRAY['数学'],
    $json$[
  {
    "input": "x = 18",
    "output": "9"
  },
  {
    "input": "x = 23",
    "output": "-1"
  },
  {
    "input": "x = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "x = 18",
    "output": "9"
  },
  {
    "input": "x = 23",
    "output": "-1"
  },
  {
    "input": "x = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumOfTheDigitsOfHarshadNumber = function(x) {\n};\n",
  "python": "class Solution:\n    def sumOfTheDigitsOfHarshadNumber(self, x: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int sumOfTheDigitsOfHarshadNumber(int x) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int sumOfTheDigitsOfHarshadNumber(int x) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumOfTheDigitsOfHarshadNumber",
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
        18
      ],
      "expected": 9
    },
    {
      "args": [
        23
      ],
      "expected": -1
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
      10
    ],
    "expected": 1
  },
  {
    "args": [
      12
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
      99
    ],
    "expected": -1
  },
  {
    "args": [
      999
    ],
    "expected": 27
  }
]$json$::jsonb,
    'approved'
),
(
    1956,
    '得到 0 的操作数',
    '给定两个非负整数 num1 和 num2。
每次操作从较大的数中减去较小的数；若两数相等，则任选一个减去另一个。
当其中一个数变为 0 时停止。返回执行的操作次数。',
    'easy',
    1000,
    256,
    ARRAY['数学', '模拟'],
    $json$[
  {
    "input": "num1 = 2, num2 = 3",
    "output": "3"
  },
  {
    "input": "num1 = 10, num2 = 10",
    "output": "1"
  },
  {
    "input": "num1 = 0, num2 = 5",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num1 = 2, num2 = 3",
    "output": "3"
  },
  {
    "input": "num1 = 10, num2 = 10",
    "output": "1"
  },
  {
    "input": "num1 = 0, num2 = 5",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countOperations = function(num1, num2) {\n};\n",
  "python": "class Solution:\n    def countOperations(self, num1: int, num2: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countOperations(int num1, int num2) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countOperations(int num1, int num2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countOperations",
  "params": [
    {
      "name": "num1",
      "type": "int"
    },
    {
      "name": "num2",
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
      "expected": 3
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
        0,
        5
      ],
      "expected": 0
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
      0,
      0
    ],
    "expected": 0
  },
  {
    "args": [
      5,
      0
    ],
    "expected": 0
  },
  {
    "args": [
      7,
      3
    ],
    "expected": 5
  },
  {
    "args": [
      12,
      8
    ],
    "expected": 3
  },
  {
    "args": [
      9,
      6
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1957,
    '找出中枢整数',
    '给定正整数 n，寻找一个整数 x（1 <= x <= n），使得
1 + 2 + ... + x 等于 x + (x + 1) + ... + n。
若存在这样的 x 则返回它，否则返回 -1。',
    'easy',
    1000,
    256,
    ARRAY['数学', '前缀和'],
    $json$[
  {
    "input": "n = 8",
    "output": "6"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 4",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 8",
    "output": "6"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 4",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var pivotInteger = function(n) {\n};\n",
  "python": "class Solution:\n    def pivotInteger(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int pivotInteger(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int pivotInteger(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "pivotInteger",
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
      "expected": 6
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
      "expected": -1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2
    ],
    "expected": -1
  },
  {
    "args": [
      3
    ],
    "expected": -1
  },
  {
    "args": [
      49
    ],
    "expected": 35
  },
  {
    "args": [
      5
    ],
    "expected": -1
  },
  {
    "args": [
      1000
    ],
    "expected": -1
  }
]$json$::jsonb,
    'approved'
),
(
    1958,
    '递枕头',
    'n 个人站成一排，编号从 1 到 n。枕头最初在编号 1 的人手中。
每一秒，持枕者把枕头传给相邻的人；传到两端后方向反转。
给定时间 time（秒），返回 time 秒后持有枕头的人的编号。',
    'easy',
    1000,
    256,
    ARRAY['数学', '模拟'],
    $json$[
  {
    "input": "n = 4, time = 5",
    "output": "2"
  },
  {
    "input": "n = 3, time = 2",
    "output": "3"
  },
  {
    "input": "n = 2, time = 1",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4, time = 5",
    "output": "2"
  },
  {
    "input": "n = 3, time = 2",
    "output": "3"
  },
  {
    "input": "n = 2, time = 1",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var passThePillow = function(n, time) {\n};\n",
  "python": "class Solution:\n    def passThePillow(self, n: int, time: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int passThePillow(int n, int time) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int passThePillow(int n, int time) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "passThePillow",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "time",
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
        5
      ],
      "expected": 2
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
        2,
        1
      ],
      "expected": 2
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
      1,
      1000
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
      3,
      5
    ],
    "expected": 2
  },
  {
    "args": [
      5,
      6
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1959,
    '三角形的最大高度',
    '给定红色球 red 个、蓝色球 blue 个。
从第 1 行开始逐行堆叠三角形，第 i 行需要 i 个球，且相邻两行必须使用不同颜色。
可以选择第一行使用红色或蓝色。返回最多可以堆叠的行数。',
    'easy',
    1000,
    256,
    ARRAY['数学', '枚举'],
    $json$[
  {
    "input": "red = 2, blue = 4",
    "output": "3"
  },
  {
    "input": "red = 2, blue = 1",
    "output": "2"
  },
  {
    "input": "red = 1, blue = 1",
    "output": "1"
  },
  {
    "input": "red = 10, blue = 1",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "red = 2, blue = 4",
    "output": "3"
  },
  {
    "input": "red = 2, blue = 1",
    "output": "2"
  },
  {
    "input": "red = 1, blue = 1",
    "output": "1"
  },
  {
    "input": "red = 10, blue = 1",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxHeightOfTriangle = function(red, blue) {\n};\n",
  "python": "class Solution:\n    def maxHeightOfTriangle(self, red: int, blue: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxHeightOfTriangle(int red, int blue) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxHeightOfTriangle(int red, int blue) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxHeightOfTriangle",
  "params": [
    {
      "name": "red",
      "type": "int"
    },
    {
      "name": "blue",
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
        4
      ],
      "expected": 3
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
        1,
        1
      ],
      "expected": 1
    },
    {
      "args": [
        10,
        1
      ],
      "expected": 2
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
      1,
      10
    ],
    "expected": 2
  },
  {
    "args": [
      4,
      4
    ],
    "expected": 3
  },
  {
    "args": [
      5,
      5
    ],
    "expected": 3
  },
  {
    "args": [
      7,
      7
    ],
    "expected": 4
  },
  {
    "args": [
      3,
      3
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1960,
    'K 次取反后最大化的数组和',
    '给定整数数组 nums 和整数 k。
每次操作选择数组中的一个元素并将它取反（正变负、负变正），共执行恰好 k 次。
返回执行完所有操作后数组元素之和的最大值。',
    'easy',
    1000,
    256,
    ARRAY['数组', '贪心', '排序'],
    $json$[
  {
    "input": "nums = [4, 2, 3], k = 1",
    "output": "5"
  },
  {
    "input": "nums = [3, -1, 0, 2], k = 3",
    "output": "6"
  },
  {
    "input": "nums = [2, -3, -1, 5, -4], k = 2",
    "output": "13"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [4, 2, 3], k = 1",
    "output": "5"
  },
  {
    "input": "nums = [3, -1, 0, 2], k = 3",
    "output": "6"
  },
  {
    "input": "nums = [2, -3, -1, 5, -4], k = 2",
    "output": "13"
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestSumAfterKNegations = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def largestSumAfterKNegations(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int largestSumAfterKNegations(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int largestSumAfterKNegations(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestSumAfterKNegations",
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
          2,
          3
        ],
        1
      ],
      "expected": 5
    },
    {
      "args": [
        [
          3,
          -1,
          0,
          2
        ],
        3
      ],
      "expected": 6
    },
    {
      "args": [
        [
          2,
          -3,
          -1,
          5,
          -4
        ],
        2
      ],
      "expected": 13
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        -1,
        -2,
        -3
      ],
      1
    ],
    "expected": 0
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
    "expected": 4
  },
  {
    "args": [
      [
        1
      ],
      1
    ],
    "expected": -1
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
        5
      ],
      1
    ],
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1961,
    '两栋颜色不同且距离最远的房子',
    '给定整数数组 colors，colors[i] 表示第 i 栋房子的颜色。
选择两栋颜色不同的房子 i 和 j（i < j），返回 j - i 的最大值。
若不存在颜色不同的两栋房子，返回 0。',
    'easy',
    1000,
    256,
    ARRAY['数组', '贪心'],
    $json$[
  {
    "input": "colors = [1, 1, 1, 6, 1, 1, 1]",
    "output": "3"
  },
  {
    "input": "colors = [1, 8, 3, 8, 3]",
    "output": "4"
  },
  {
    "input": "colors = [0, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "colors = [1, 1, 1, 6, 1, 1, 1]",
    "output": "3"
  },
  {
    "input": "colors = [1, 8, 3, 8, 3]",
    "output": "4"
  },
  {
    "input": "colors = [0, 1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxDistance = function(colors) {\n};\n",
  "python": "class Solution:\n    def maxDistance(self, colors: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxDistance(std::vector<int>& colors) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxDistance(int[] colors) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxDistance",
  "params": [
    {
      "name": "colors",
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
          1,
          6,
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
          8,
          3,
          8,
          3
        ]
      ],
      "expected": 4
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
        4,
        4,
        4
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        0,
        1,
        0,
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
    1962,
    '转换字符串的最少操作次数',
    '给定只含 ''X'' 和 ''O'' 的字符串 s。
每次操作选择一个 ''X''，把它以及它右侧至多两个相邻字符都变成 ''O''；
若右侧不足两个字符，则只转换剩余字符。
返回把所有 ''X'' 都变成 ''O'' 的最少操作次数。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '贪心'],
    $json$[
  {
    "input": "s = \"XXX\"",
    "output": "1"
  },
  {
    "input": "s = \"XXOX\"",
    "output": "2"
  },
  {
    "input": "s = \"OOOO\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"XXX\"",
    "output": "1"
  },
  {
    "input": "s = \"XXOX\"",
    "output": "2"
  },
  {
    "input": "s = \"OOOO\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumMoves = function(s) {\n};\n",
  "python": "class Solution:\n    def minimumMoves(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumMoves(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumMoves(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumMoves",
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
        "XXX"
      ],
      "expected": 1
    },
    {
      "args": [
        "XXOX"
      ],
      "expected": 2
    },
    {
      "args": [
        "OOOO"
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "X"
    ],
    "expected": 1
  },
  {
    "args": [
      "OXOX"
    ],
    "expected": 1
  },
  {
    "args": [
      "XX"
    ],
    "expected": 1
  },
  {
    "args": [
      "XOX"
    ],
    "expected": 1
  },
  {
    "args": [
      "XXXX"
    ],
    "expected": 2
  },
  {
    "args": [
      "OXOXX"
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1963,
    '赢得比赛需要的最少训练时长',
    '给定初始精力 initialEnergy、初始经验 initialExperience，以及按顺序挑战的 n 个对手的精力数组 energy 和经验数组 experience。
挑战第 i 个对手要求当前精力严格大于 energy[i]、当前经验严格大于 experience[i]。
每训练 1 小时可以让精力或经验增加 1，训练可以在任意对手之前进行。
击败一个对手后，当前精力减少 energy[i]，当前经验增加 experience[i]。
返回击败所有对手所需的最少训练小时数。',
    'easy',
    1000,
    256,
    ARRAY['数组', '贪心', '模拟'],
    $json$[
  {
    "input": "initialEnergy = 5, initialExperience = 3, energy = [1, 4, 3, 2], experience = [2, 6, 3, 1]",
    "output": "8"
  },
  {
    "input": "initialEnergy = 2, initialExperience = 4, energy = [1], experience = [3]",
    "output": "0"
  },
  {
    "input": "initialEnergy = 1, initialExperience = 1, energy = [1, 1, 1, 1], experience = [1, 1, 1, 1]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "initialEnergy = 5, initialExperience = 3, energy = [1, 4, 3, 2], experience = [2, 6, 3, 1]",
    "output": "8"
  },
  {
    "input": "initialEnergy = 2, initialExperience = 4, energy = [1], experience = [3]",
    "output": "0"
  },
  {
    "input": "initialEnergy = 1, initialExperience = 1, energy = [1, 1, 1, 1], experience = [1, 1, 1, 1]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minNumberOfHours = function(initialEnergy, initialExperience, energy, experience) {\n};\n",
  "python": "class Solution:\n    def minNumberOfHours(self, initialEnergy: int, initialExperience: int, energy: list[int], experience: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minNumberOfHours(int initialEnergy, int initialExperience, std::vector<int>& energy, std::vector<int>& experience) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minNumberOfHours(int initialEnergy, int initialExperience, int[] energy, int[] experience) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minNumberOfHours",
  "params": [
    {
      "name": "initialEnergy",
      "type": "int"
    },
    {
      "name": "initialExperience",
      "type": "int"
    },
    {
      "name": "energy",
      "type": "int[]"
    },
    {
      "name": "experience",
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
        3,
        [
          1,
          4,
          3,
          2
        ],
        [
          2,
          6,
          3,
          1
        ]
      ],
      "expected": 8
    },
    {
      "args": [
        2,
        4,
        [
          1
        ],
        [
          3
        ]
      ],
      "expected": 0
    },
    {
      "args": [
        1,
        1,
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
      "expected": 5
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      1,
      [
        1
      ],
      [
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      10,
      10,
      [
        5,
        5
      ],
      [
        5,
        5
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      0,
      0,
      [
        1
      ],
      [
        1
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      100,
      100,
      [
        50,
        50,
        50
      ],
      [
        20,
        40,
        60
      ]
    ],
    "expected": 51
  },
  {
    "args": [
      3,
      2,
      [
        2,
        2,
        2
      ],
      [
        1,
        3,
        1
      ]
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1964,
    '字符串中的最大奇数',
    '给定一个表示正整数的字符串 num。
返回 num 的一个非空子串，它表示最大的奇数；若不存在奇数则返回空字符串。
子串必须由 num 中连续的一段字符组成。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '贪心', '数学'],
    $json$[
  {
    "input": "num = \"52\"",
    "output": "\"5\""
  },
  {
    "input": "num = \"4206\"",
    "output": "\"\""
  },
  {
    "input": "num = \"35427\"",
    "output": "\"35427\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = \"52\"",
    "output": "\"5\""
  },
  {
    "input": "num = \"4206\"",
    "output": "\"\""
  },
  {
    "input": "num = \"35427\"",
    "output": "\"35427\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestOddNumber = function(num) {\n};\n",
  "python": "class Solution:\n    def largestOddNumber(self, num: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string largestOddNumber(std::string num) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String largestOddNumber(String num) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestOddNumber",
  "params": [
    {
      "name": "num",
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
        "52"
      ],
      "expected": "5"
    },
    {
      "args": [
        "4206"
      ],
      "expected": ""
    },
    {
      "args": [
        "35427"
      ],
      "expected": "35427"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "1"
    ],
    "expected": "1"
  },
  {
    "args": [
      "2"
    ],
    "expected": ""
  },
  {
    "args": [
      "101"
    ],
    "expected": "101"
  },
  {
    "args": [
      "123456"
    ],
    "expected": "12345"
  },
  {
    "args": [
      "24680"
    ],
    "expected": ""
  },
  {
    "args": [
      "7"
    ],
    "expected": "7"
  }
]$json$::jsonb,
    'approved'
),
(
    1965,
    '拆分数位后四位数字的最小和',
    '给定一个四位整数 num。
把它的四个数字重新排列，组成两个新的两位数（允许有前导零），每个数字恰好使用一次。
返回这两个两位数之和的最小值。',
    'easy',
    1000,
    256,
    ARRAY['数学', '排序', '贪心'],
    $json$[
  {
    "input": "num = 2932",
    "output": "52"
  },
  {
    "input": "num = 4009",
    "output": "13"
  },
  {
    "input": "num = 1000",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = 2932",
    "output": "52"
  },
  {
    "input": "num = 4009",
    "output": "13"
  },
  {
    "input": "num = 1000",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumSum = function(num) {\n};\n",
  "python": "class Solution:\n    def minimumSum(self, num: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumSum(int num) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumSum(int num) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumSum",
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
        2932
      ],
      "expected": 52
    },
    {
      "args": [
        4009
      ],
      "expected": 13
    },
    {
      "args": [
        1000
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1111
    ],
    "expected": 22
  },
  {
    "args": [
      9999
    ],
    "expected": 198
  },
  {
    "args": [
      1234
    ],
    "expected": 37
  },
  {
    "args": [
      5000
    ],
    "expected": 5
  },
  {
    "args": [
      2020
    ],
    "expected": 4
  },
  {
    "args": [
      9876
    ],
    "expected": 147
  }
]$json$::jsonb,
    'approved'
),
(
    1966,
    '使用特殊打字机键入单词的最少时间',
    '键盘是一个圆盘，26 个小写字母按顺序围成一圈，指针最初指向 ''a''。
键入一个字符需要把指针移动到该字符（顺时针或逆时针，取较近方向）并按下，共耗时 1 秒。
移动一格耗时 1 秒。返回键入整个字符串 word 所需的最少秒数。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '贪心', '数学'],
    $json$[
  {
    "input": "word = \"abc\"",
    "output": "5"
  },
  {
    "input": "word = \"bza\"",
    "output": "7"
  },
  {
    "input": "word = \"zjpc\"",
    "output": "34"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "word = \"abc\"",
    "output": "5"
  },
  {
    "input": "word = \"bza\"",
    "output": "7"
  },
  {
    "input": "word = \"zjpc\"",
    "output": "34"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minTimeToType = function(word) {\n};\n",
  "python": "class Solution:\n    def minTimeToType(self, word: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minTimeToType(std::string word) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minTimeToType(String word) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minTimeToType",
  "params": [
    {
      "name": "word",
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
      "expected": 5
    },
    {
      "args": [
        "bza"
      ],
      "expected": 7
    },
    {
      "args": [
        "zjpc"
      ],
      "expected": 34
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
      "z"
    ],
    "expected": 2
  },
  {
    "args": [
      "az"
    ],
    "expected": 3
  },
  {
    "args": [
      "bad"
    ],
    "expected": 8
  },
  {
    "args": [
      "leetcode"
    ],
    "expected": 70
  }
]$json$::jsonb,
    'approved'
),
(
    1967,
    'K 件物品的最大和',
    '有 numOnes 件价值为 1 的物品、numZeros 件价值为 0 的物品、
numNegOnes 件价值为 -1 的物品。
从中恰好选择 k 件物品，返回可以得到的最大价值和。',
    'easy',
    1000,
    256,
    ARRAY['数学', '贪心'],
    $json$[
  {
    "input": "numOnes = 3, numZeros = 2, numNegOnes = 0, k = 2",
    "output": "2"
  },
  {
    "input": "numOnes = 3, numZeros = 2, numNegOnes = 0, k = 4",
    "output": "3"
  },
  {
    "input": "numOnes = 3, numZeros = 2, numNegOnes = 1, k = 6",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "numOnes = 3, numZeros = 2, numNegOnes = 0, k = 2",
    "output": "2"
  },
  {
    "input": "numOnes = 3, numZeros = 2, numNegOnes = 0, k = 4",
    "output": "3"
  },
  {
    "input": "numOnes = 3, numZeros = 2, numNegOnes = 1, k = 6",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var kItemsWithMaximumSum = function(numOnes, numZeros, numNegOnes, k) {\n};\n",
  "python": "class Solution:\n    def kItemsWithMaximumSum(self, numOnes: int, numZeros: int, numNegOnes: int, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int kItemsWithMaximumSum(int numOnes, int numZeros, int numNegOnes, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int kItemsWithMaximumSum(int numOnes, int numZeros, int numNegOnes, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kItemsWithMaximumSum",
  "params": [
    {
      "name": "numOnes",
      "type": "int"
    },
    {
      "name": "numZeros",
      "type": "int"
    },
    {
      "name": "numNegOnes",
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
        2,
        0,
        2
      ],
      "expected": 2
    },
    {
      "args": [
        3,
        2,
        0,
        4
      ],
      "expected": 3
    },
    {
      "args": [
        3,
        2,
        1,
        6
      ],
      "expected": 2
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      0,
      0,
      1
    ],
    "expected": 1
  },
  {
    "args": [
      0,
      1,
      0,
      1
    ],
    "expected": 0
  },
  {
    "args": [
      0,
      0,
      5,
      3
    ],
    "expected": -3
  },
  {
    "args": [
      5,
      0,
      5,
      5
    ],
    "expected": 5
  },
  {
    "args": [
      10,
      10,
      10,
      15
    ],
    "expected": 10
  }
]$json$::jsonb,
    'approved'
),
(
    1968,
    '奇偶位数',
    '给定非负整数 n，统计其二进制表示中 1 的个数。
下标从最低位（第 0 位）开始计算。返回 [even, odd]，
其中 even 是偶数下标上的 1 的个数，odd 是奇数下标上的 1 的个数。',
    'easy',
    1000,
    256,
    ARRAY['位运算'],
    $json$[
  {
    "input": "n = 17",
    "output": "[2, 0]"
  },
  {
    "input": "n = 2",
    "output": "[0, 1]"
  },
  {
    "input": "n = 7",
    "output": "[2, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 17",
    "output": "[2, 0]"
  },
  {
    "input": "n = 2",
    "output": "[0, 1]"
  },
  {
    "input": "n = 7",
    "output": "[2, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var evenOddBit = function(n) {\n};\n",
  "python": "class Solution:\n    def evenOddBit(self, n: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> evenOddBit(int n) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] evenOddBit(int n) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "evenOddBit",
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
        17
      ],
      "expected": [
        2,
        0
      ]
    },
    {
      "args": [
        2
      ],
      "expected": [
        0,
        1
      ]
    },
    {
      "args": [
        7
      ],
      "expected": [
        2,
        1
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      0
    ],
    "expected": [
      0,
      0
    ]
  },
  {
    "args": [
      1
    ],
    "expected": [
      1,
      0
    ]
  },
  {
    "args": [
      3
    ],
    "expected": [
      1,
      1
    ]
  },
  {
    "args": [
      10
    ],
    "expected": [
      0,
      2
    ]
  },
  {
    "args": [
      2147483647
    ],
    "expected": [
      16,
      15
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1969,
    '求出出现两次数字的 XOR 值',
    '给定整数数组 nums，其中每个元素恰好出现一次或两次。
将所有恰好出现两次的元素进行按位异或，返回异或结果；若没有这样的元素则返回 0。',
    'easy',
    1000,
    256,
    ARRAY['数组', '位运算', '哈希表'],
    $json$[
  {
    "input": "nums = [1, 2, 1, 3]",
    "output": "1"
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
    "input": "nums = [1, 2, 1, 3]",
    "output": "1"
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
  "javascript": "var duplicateNumbersXOR = function(nums) {\n};\n",
  "python": "class Solution:\n    def duplicateNumbersXOR(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int duplicateNumbersXOR(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int duplicateNumbersXOR(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "duplicateNumbersXOR",
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
        5
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        4,
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
        7,
        8,
        8,
        9
      ]
    ],
    "expected": 15
  },
  {
    "args": [
      [
        10,
        10,
        20,
        20,
        30,
        30
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1970,
    '使两个整数相等的位更改次数',
    '给定两个非负整数 n 和 k。
每次操作可以把 n 的二进制表示中的某一位从 1 改为 0。
若无法通过若干次操作把 n 变成 k，返回 -1；否则返回所需的最少操作次数。',
    'easy',
    1000,
    256,
    ARRAY['位运算'],
    $json$[
  {
    "input": "n = 13, k = 4",
    "output": "2"
  },
  {
    "input": "n = 21, k = 21",
    "output": "0"
  },
  {
    "input": "n = 14, k = 13",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 13, k = 4",
    "output": "2"
  },
  {
    "input": "n = 21, k = 21",
    "output": "0"
  },
  {
    "input": "n = 14, k = 13",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minChanges = function(n, k) {\n};\n",
  "python": "class Solution:\n    def minChanges(self, n: int, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minChanges(int n, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minChanges(int n, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minChanges",
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
        13,
        4
      ],
      "expected": 2
    },
    {
      "args": [
        21,
        21
      ],
      "expected": 0
    },
    {
      "args": [
        14,
        13
      ],
      "expected": -1
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
      0,
      0
    ],
    "expected": 0
  },
  {
    "args": [
      0,
      1
    ],
    "expected": -1
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
      7,
      3
    ],
    "expected": 1
  },
  {
    "args": [
      10,
      8
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1971,
    '仅含置位位的最小整数',
    '给定正整数 n。
返回大于等于 n 的最小整数，它的二进制表示中每一位都是 1。
例如 5 的二进制是 101，大于等于它的最小全 1 二进制数是 111，即 7。',
    'easy',
    1000,
    256,
    ARRAY['位运算', '数学'],
    $json$[
  {
    "input": "n = 5",
    "output": "7"
  },
  {
    "input": "n = 10",
    "output": "15"
  },
  {
    "input": "n = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5",
    "output": "7"
  },
  {
    "input": "n = 10",
    "output": "15"
  },
  {
    "input": "n = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestNumber = function(n) {\n};\n",
  "python": "class Solution:\n    def smallestNumber(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int smallestNumber(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int smallestNumber(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestNumber",
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
      "expected": 7
    },
    {
      "args": [
        10
      ],
      "expected": 15
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
    "expected": 3
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
    "expected": 7
  },
  {
    "args": [
      8
    ],
    "expected": 15
  },
  {
    "args": [
      100
    ],
    "expected": 127
  },
  {
    "args": [
      1000
    ],
    "expected": 1023
  }
]$json$::jsonb,
    'approved'
),
(
    1972,
    '找出数组中的 K-or 值',
    '给定整数数组 nums 和整数 k。
对每个二进制位，若数组中至少有 k 个元素的该位为 1，则结果的该位为 1，否则为 0。
返回所有满足条件的位组成的整数。',
    'easy',
    1000,
    256,
    ARRAY['数组', '位运算'],
    $json$[
  {
    "input": "nums = [7, 12, 9, 8, 9, 15], k = 4",
    "output": "9"
  },
  {
    "input": "nums = [2, 3, 4], k = 2",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 3], k = 1",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [7, 12, 9, 8, 9, 15], k = 4",
    "output": "9"
  },
  {
    "input": "nums = [2, 3, 4], k = 2",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 3], k = 1",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findKOr = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def findKOr(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findKOr(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findKOr(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findKOr",
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
          7,
          12,
          9,
          8,
          9,
          15
        ],
        4
      ],
      "expected": 9
    },
    {
      "args": [
        [
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
          2,
          3
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
        1,
        1
      ],
      1
    ],
    "expected": 1
  },
  {
    "args": [
      [
        15,
        15,
        15
      ],
      2
    ],
    "expected": 15
  },
  {
    "args": [
      [
        1,
        2,
        4,
        8
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
        4,
        8
      ],
      2
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1973,
    '计算 K 置位下标对应元素的和',
    '给定整数数组 nums 和整数 k。
下标 i 从 0 开始，若 i 的二进制表示中恰好有 k 个 1，则把 nums[i] 加入总和。
返回所有满足条件的下标对应元素之和。',
    'easy',
    1000,
    256,
    ARRAY['数组', '位运算'],
    $json$[
  {
    "input": "nums = [5, 10, 1, 5, 2], k = 1",
    "output": "13"
  },
  {
    "input": "nums = [4, 3, 2, 1], k = 2",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3], k = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [5, 10, 1, 5, 2], k = 1",
    "output": "13"
  },
  {
    "input": "nums = [4, 3, 2, 1], k = 2",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3], k = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumIndicesWithKSetBits = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def sumIndicesWithKSetBits(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int sumIndicesWithKSetBits(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int sumIndicesWithKSetBits(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumIndicesWithKSetBits",
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
          5,
          10,
          1,
          5,
          2
        ],
        1
      ],
      "expected": 13
    },
    {
      "args": [
        [
          4,
          3,
          2,
          1
        ],
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
        7,
        7
      ],
      2
    ],
    "expected": 21
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
  }
]$json$::jsonb,
    'approved'
),
(
    1974,
    '最大二进制奇数',
    '给定一个只含 ''0'' 和 ''1'' 的字符串 s，其中至少有一个 ''1''。
重新排列 s 中的字符，得到一个没有前导零的二进制数，且该数必须是奇数。
返回可以得到的最大二进制数（以字符串表示）。',
    'easy',
    1000,
    256,
    ARRAY['字符串', '贪心', '位运算'],
    $json$[
  {
    "input": "s = \"010\"",
    "output": "\"001\""
  },
  {
    "input": "s = \"0101\"",
    "output": "\"1001\""
  },
  {
    "input": "s = \"1\"",
    "output": "\"1\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"010\"",
    "output": "\"001\""
  },
  {
    "input": "s = \"0101\"",
    "output": "\"1001\""
  },
  {
    "input": "s = \"1\"",
    "output": "\"1\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumOddBinaryNumber = function(s) {\n};\n",
  "python": "class Solution:\n    def maximumOddBinaryNumber(self, s: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string maximumOddBinaryNumber(std::string s) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String maximumOddBinaryNumber(String s) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumOddBinaryNumber",
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
        "010"
      ],
      "expected": "001"
    },
    {
      "args": [
        "0101"
      ],
      "expected": "1001"
    },
    {
      "args": [
        "1"
      ],
      "expected": "1"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "11"
    ],
    "expected": "11"
  },
  {
    "args": [
      "1010"
    ],
    "expected": "1001"
  },
  {
    "args": [
      "0001"
    ],
    "expected": "0001"
  },
  {
    "args": [
      "111"
    ],
    "expected": "111"
  },
  {
    "args": [
      "1000"
    ],
    "expected": "0001"
  }
]$json$::jsonb,
    'approved'
),
(
    1975,
    '和为奇数的子数组数目',
    '给定整数数组 nums，返回所有元素和为奇数的连续子数组数目。
由于答案可能很大，请对 10^9 + 7 取模。
子数组必须非空且下标连续。
1 <= nums.length <= 10^5，1 <= nums[i] <= 100。',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "nums = [1, 3, 5]",
    "output": "4"
  },
  {
    "input": "nums = [2, 4, 6]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6, 7]",
    "output": "16"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3, 5]",
    "output": "4"
  },
  {
    "input": "nums = [2, 4, 6]",
    "output": "0"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6, 7]",
    "output": "16"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countOddSumSubarrays = function(nums) {\n};\n",
  "python": "class Solution:\n    def countOddSumSubarrays(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countOddSumSubarrays(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countOddSumSubarrays(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countOddSumSubarrays",
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
      "expected": 4
    },
    {
      "args": [
        [
          2,
          4,
          6
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
          6,
          7
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
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        2
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
    "expected": 2
  },
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
        2,
        3,
        4,
        5
      ]
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    1976,
    '字符串的好分割数目',
    '将字符串 s 在下标 i 与 i + 1 之间切开，得到两个非空部分。
若左半部分和右半部分包含的不同字符数量相等，称为一次好分割。
返回好分割的数目。1 <= s.length <= 1000，s 仅含小写英文字母。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '哈希表'],
    $json$[
  {
    "input": "s = \"aacaba\"",
    "output": "2"
  },
  {
    "input": "s = \"abcd\"",
    "output": "1"
  },
  {
    "input": "s = \"aaaaa\"",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aacaba\"",
    "output": "2"
  },
  {
    "input": "s = \"abcd\"",
    "output": "1"
  },
  {
    "input": "s = \"aaaaa\"",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var waysToSplitGoodString = function(s) {\n};\n",
  "python": "class Solution:\n    def waysToSplitGoodString(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int waysToSplitGoodString(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int waysToSplitGoodString(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "waysToSplitGoodString",
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
        "aacaba"
      ],
      "expected": 2
    },
    {
      "args": [
        "abcd"
      ],
      "expected": 1
    },
    {
      "args": [
        "aaaaa"
      ],
      "expected": 4
    }
  ]
}$json$::jsonb,
    $json$[
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
  },
  {
    "args": [
      "aaaa"
    ],
    "expected": 3
  },
  {
    "args": [
      "aab"
    ],
    "expected": 1
  },
  {
    "args": [
      "abcabc"
    ],
    "expected": 1
  },
  {
    "args": [
      "aaab"
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1977,
    '将 x 减到 0 的最小操作数',
    '给定正整数数组 nums 和整数 x。每次操作可以删除 nums 最左边或最右边的一个元素，
被删除元素的值从 x 中减去。返回将 x 恰好减到 0 的最少操作次数；做不到返回 -1。
1 <= nums.length <= 10^5，1 <= nums[i] <= 10^4，1 <= x <= 10^9。',
    'medium',
    1000,
    256,
    ARRAY['数组', '滑动窗口', '前缀和'],
    $json$[
  {
    "input": "nums = [1, 1, 4, 2, 3], x = 5",
    "output": "2"
  },
  {
    "input": "nums = [5, 6, 7, 8, 9], x = 4",
    "output": "-1"
  },
  {
    "input": "nums = [3, 2, 20, 1, 1, 3], x = 10",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 4, 2, 3], x = 5",
    "output": "2"
  },
  {
    "input": "nums = [5, 6, 7, 8, 9], x = 4",
    "output": "-1"
  },
  {
    "input": "nums = [3, 2, 20, 1, 1, 3], x = 10",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minOperationsToReduceX = function(nums, x) {\n};\n",
  "python": "class Solution:\n    def minOperationsToReduceX(self, nums: list[int], x: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minOperationsToReduceX(std::vector<int>& nums, int x) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minOperationsToReduceX(int[] nums, int x) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minOperationsToReduceX",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
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
          1,
          1,
          4,
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
          5,
          6,
          7,
          8,
          9
        ],
        4
      ],
      "expected": -1
    },
    {
      "args": [
        [
          3,
          2,
          20,
          1,
          1,
          3
        ],
        10
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
        2
      ],
      3
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
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    1978,
    '半径为 k 的子数组平均值',
    '给定数组 nums 和整数 k。对每个下标 i，若其左右各有至少 k 个元素，
则计算 nums[i - k] 到 nums[i + k]（含两端）共 2k + 1 个元素的平均值并向下取整；
否则该位置答案为 -1。返回结果数组。
1 <= nums.length <= 10^5，0 <= k <= 10^5，0 <= nums[i] <= 10^5。',
    'medium',
    1000,
    256,
    ARRAY['数组', '滑动窗口'],
    $json$[
  {
    "input": "nums = [7, 4, 3, 9, 1, 8, 2, 6], k = 3",
    "output": "[-1, -1, -1, 4, 4, -1, -1, -1]"
  },
  {
    "input": "nums = [1, 2, 3, 4], k = 1",
    "output": "[-1, 2, 3, -1]"
  },
  {
    "input": "nums = [5], k = 0",
    "output": "[5]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [7, 4, 3, 9, 1, 8, 2, 6], k = 3",
    "output": "[-1, -1, -1, 4, 4, -1, -1, -1]"
  },
  {
    "input": "nums = [1, 2, 3, 4], k = 1",
    "output": "[-1, 2, 3, -1]"
  },
  {
    "input": "nums = [5], k = 0",
    "output": "[5]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var getAverages = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def getAverages(self, nums: list[int], k: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> getAverages(std::vector<int>& nums, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] getAverages(int[] nums, int k) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getAverages",
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
          7,
          4,
          3,
          9,
          1,
          8,
          2,
          6
        ],
        3
      ],
      "expected": [
        -1,
        -1,
        -1,
        4,
        4,
        -1,
        -1,
        -1
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
        1
      ],
      "expected": [
        -1,
        2,
        3,
        -1
      ]
    },
    {
      "args": [
        [
          5
        ],
        0
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
        1,
        2
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
        1,
        2,
        3
      ],
      1
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
        2,
        2,
        2,
        2,
        2
      ],
      2
    ],
    "expected": [
      -1,
      -1,
      2,
      -1,
      -1
    ]
  },
  {
    "args": [
      [
        10,
        20,
        30
      ],
      1
    ],
    "expected": [
      -1,
      20,
      -1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1979,
    '最少交换次数来组合所有的 1 II',
    'nums 是环形二进制数组（首尾相连）。一次交换可以互换任意两个位置的元素。
返回把数组中所有 1 聚集到连续位置所需的最少交换次数。
1 <= nums.length <= 10^5，nums[i] 为 0 或 1。',
    'medium',
    1000,
    256,
    ARRAY['数组', '滑动窗口'],
    $json$[
  {
    "input": "nums = [0, 1, 0, 1, 1, 0, 0]",
    "output": "1"
  },
  {
    "input": "nums = [0, 1, 1, 1, 0, 0, 1, 1, 0]",
    "output": "2"
  },
  {
    "input": "nums = [1, 1, 0, 0, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [0, 1, 0, 1, 1, 0, 0]",
    "output": "1"
  },
  {
    "input": "nums = [0, 1, 1, 1, 0, 0, 1, 1, 0]",
    "output": "2"
  },
  {
    "input": "nums = [1, 1, 0, 0, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minSwapsToGroupOnes = function(nums) {\n};\n",
  "python": "class Solution:\n    def minSwapsToGroupOnes(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minSwapsToGroupOnes(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minSwapsToGroupOnes(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minSwapsToGroupOnes",
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
          0,
          1,
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
          0,
          1,
          1,
          1,
          0,
          0,
          1,
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
          0,
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
        1,
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
        0,
        1,
        1
      ]
    ],
    "expected": 0
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
    1980,
    '最高频元素的频数',
    '给定数组 nums 和整数 k。每次操作可以把一个元素增加 1，最多操作 k 次。
返回操作后某个元素可能达到的最大出现次数。
1 <= nums.length <= 10^5，1 <= nums[i] <= 10^5，0 <= k <= 10^5。',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '滑动窗口'],
    $json$[
  {
    "input": "nums = [1, 2, 4], k = 5",
    "output": "3"
  },
  {
    "input": "nums = [1, 4, 8, 13], k = 5",
    "output": "2"
  },
  {
    "input": "nums = [3, 9, 6], k = 2",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 4], k = 5",
    "output": "3"
  },
  {
    "input": "nums = [1, 4, 8, 13], k = 5",
    "output": "2"
  },
  {
    "input": "nums = [3, 9, 6], k = 2",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxFrequency = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def maxFrequency(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxFrequency(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxFrequency(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxFrequency",
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
          4
        ],
        5
      ],
      "expected": 3
    },
    {
      "args": [
        [
          1,
          4,
          8,
          13
        ],
        5
      ],
      "expected": 2
    },
    {
      "args": [
        [
          3,
          9,
          6
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
        5,
        5,
        5
      ],
      10
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        10,
        100
      ],
      9
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1981,
    '考试的最大困扰度',
    '给定只含 ''T'' 和 ''F'' 的字符串 answerKey 与整数 k。
最多可以修改 k 个字符，返回修改后最长的连续相同字符子串长度。
1 <= answerKey.length <= 10^5，0 <= k <= answerKey.length。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '滑动窗口'],
    $json$[
  {
    "input": "answerKey = \"TTFF\", k = 2",
    "output": "4"
  },
  {
    "input": "answerKey = \"TFFT\", k = 1",
    "output": "3"
  },
  {
    "input": "answerKey = \"TTFTTFTT\", k = 1",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "answerKey = \"TTFF\", k = 2",
    "output": "4"
  },
  {
    "input": "answerKey = \"TFFT\", k = 1",
    "output": "3"
  },
  {
    "input": "answerKey = \"TTFTTFTT\", k = 1",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxConsecutiveAnswers = function(answerKey, k) {\n};\n",
  "python": "class Solution:\n    def maxConsecutiveAnswers(self, answerKey: str, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxConsecutiveAnswers(std::string answerKey, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxConsecutiveAnswers(String answerKey, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxConsecutiveAnswers",
  "params": [
    {
      "name": "answerKey",
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
        "TTFF",
        2
      ],
      "expected": 4
    },
    {
      "args": [
        "TFFT",
        1
      ],
      "expected": 3
    },
    {
      "args": [
        "TTFTTFTT",
        1
      ],
      "expected": 5
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "T",
      0
    ],
    "expected": 1
  },
  {
    "args": [
      "F",
      1
    ],
    "expected": 1
  },
  {
    "args": [
      "TF",
      0
    ],
    "expected": 1
  },
  {
    "args": [
      "TTFF",
      0
    ],
    "expected": 2
  },
  {
    "args": [
      "TFTF",
      2
    ],
    "expected": 4
  },
  {
    "args": [
      "FFFTTFTT",
      2
    ],
    "expected": 6
  }
]$json$::jsonb,
    'approved'
),
(
    1982,
    '任意子数组和的绝对值的最大值',
    '给定整数数组 nums，返回所有非空连续子数组和的绝对值的最大值。
1 <= nums.length <= 10^5，-10^4 <= nums[i] <= 10^4。',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "nums = [1, -3, 2, 3, -4]",
    "output": "5"
  },
  {
    "input": "nums = [2, -5, 1, -4, 3, -2]",
    "output": "8"
  },
  {
    "input": "nums = [-1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, -3, 2, 3, -4]",
    "output": "5"
  },
  {
    "input": "nums = [2, -5, 1, -4, 3, -2]",
    "output": "8"
  },
  {
    "input": "nums = [-1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxAbsoluteSum = function(nums) {\n};\n",
  "python": "class Solution:\n    def maxAbsoluteSum(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxAbsoluteSum(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxAbsoluteSum(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxAbsoluteSum",
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
          -3,
          2,
          3,
          -4
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        [
          2,
          -5,
          1,
          -4,
          3,
          -2
        ]
      ],
      "expected": 8
    },
    {
      "args": [
        [
          -1
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
        -1,
        -2
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        -1
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
        2,
        -1,
        2
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        -2,
        1,
        -3
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1983,
    '移动所有球到每个盒子所需的最小操作数',
    '字符串 boxes 中 ''1'' 表示盒子里有一个球，''0'' 表示空盒。
把下标 j 的球移到下标 i 需要 |i - j| 步。对每个盒子 i，返回把所有球移到 i 的总步数。
1 <= boxes.length <= 2000，boxes 仅含 ''0'' 和 ''1''。',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "boxes = \"110\"",
    "output": "[1, 1, 3]"
  },
  {
    "input": "boxes = \"001011\"",
    "output": "[11, 8, 5, 4, 3, 4]"
  },
  {
    "input": "boxes = \"0\"",
    "output": "[0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "boxes = \"110\"",
    "output": "[1, 1, 3]"
  },
  {
    "input": "boxes = \"001011\"",
    "output": "[11, 8, 5, 4, 3, 4]"
  },
  {
    "input": "boxes = \"0\"",
    "output": "[0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minOperationsToMoveBalls = function(boxes) {\n};\n",
  "python": "class Solution:\n    def minOperationsToMoveBalls(self, boxes: str) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> minOperationsToMoveBalls(std::string boxes) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] minOperationsToMoveBalls(String boxes) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minOperationsToMoveBalls",
  "params": [
    {
      "name": "boxes",
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
        "110"
      ],
      "expected": [
        1,
        1,
        3
      ]
    },
    {
      "args": [
        "001011"
      ],
      "expected": [
        11,
        8,
        5,
        4,
        3,
        4
      ]
    },
    {
      "args": [
        "0"
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
      "1"
    ],
    "expected": [
      0
    ]
  },
  {
    "args": [
      "00"
    ],
    "expected": [
      0,
      0
    ]
  },
  {
    "args": [
      "101"
    ],
    "expected": [
      2,
      2,
      2
    ]
  },
  {
    "args": [
      "011"
    ],
    "expected": [
      3,
      1,
      1
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1984,
    '有序数组中差绝对值之和',
    '给定非递减数组 nums，返回数组 result，其中
result[i] 等于 nums[i] 与数组中其余所有元素差的绝对值之和。
1 <= nums.length <= 10^5，-10^4 <= nums[i] <= 10^4。',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "nums = [2, 3, 5]",
    "output": "[4, 3, 5]"
  },
  {
    "input": "nums = [1, 4, 6, 8, 10]",
    "output": "[24, 15, 13, 15, 21]"
  },
  {
    "input": "nums = [1, 2]",
    "output": "[1, 1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 3, 5]",
    "output": "[4, 3, 5]"
  },
  {
    "input": "nums = [1, 4, 6, 8, 10]",
    "output": "[24, 15, 13, 15, 21]"
  },
  {
    "input": "nums = [1, 2]",
    "output": "[1, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumOfAbsoluteDifferences = function(nums) {\n};\n",
  "python": "class Solution:\n    def sumOfAbsoluteDifferences(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> sumOfAbsoluteDifferences(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] sumOfAbsoluteDifferences(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumOfAbsoluteDifferences",
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
          3,
          5
        ]
      ],
      "expected": [
        4,
        3,
        5
      ]
    },
    {
      "args": [
        [
          1,
          4,
          6,
          8,
          10
        ]
      ],
      "expected": [
        24,
        15,
        13,
        15,
        21
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
        1
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
        1
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
        1,
        3,
        5,
        7
      ]
    ],
    "expected": [
      12,
      8,
      8,
      12
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1985,
    '生成平衡数组的方案数',
    '删除 nums 中恰好一个元素后，若剩余数组中下标为偶数的元素之和
等于下标为奇数的元素之和，则称为一次平衡删除。返回平衡删除的方案数。
1 <= nums.length <= 10^5，-10^4 <= nums[i] <= 10^4。',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "nums = [2, 1, 6, 4]",
    "output": "1"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "3"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 1, 6, 4]",
    "output": "1"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "3"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var waysToMakeFair = function(nums) {\n};\n",
  "python": "class Solution:\n    def waysToMakeFair(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int waysToMakeFair(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int waysToMakeFair(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "waysToMakeFair",
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
          6,
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
    "expected": 0
  },
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
        2,
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
        1,
        1,
        1
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    1986,
    '统计隐藏数组数目',
    '给定长度为 n - 1 的数组 differences 以及区间 [lower, upper]。
隐藏数组 hidden 长度为 n，且 hidden[i + 1] - hidden[i] = differences[i]。
统计所有元素都落在 [lower, upper] 内的隐藏数组数目。
1 <= differences.length <= 10^5，-10^4 <= differences[i] <= 10^4，
-10^4 <= lower <= upper <= 10^4。',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和'],
    $json$[
  {
    "input": "differences = [1, -3, 4], lower = 1, upper = 6",
    "output": "2"
  },
  {
    "input": "differences = [3, -4, 5, 1, -2], lower = -4, upper = 5",
    "output": "4"
  },
  {
    "input": "differences = [4, -7, 2], lower = 3, upper = 6",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "differences = [1, -3, 4], lower = 1, upper = 6",
    "output": "2"
  },
  {
    "input": "differences = [3, -4, 5, 1, -2], lower = -4, upper = 5",
    "output": "4"
  },
  {
    "input": "differences = [4, -7, 2], lower = 3, upper = 6",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countHiddenSequences = function(differences, lower, upper) {\n};\n",
  "python": "class Solution:\n    def countHiddenSequences(self, differences: list[int], lower: int, upper: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countHiddenSequences(std::vector<int>& differences, int lower, int upper) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countHiddenSequences(int[] differences, int lower, int upper) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countHiddenSequences",
  "params": [
    {
      "name": "differences",
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
          1,
          -3,
          4
        ],
        1,
        6
      ],
      "expected": 2
    },
    {
      "args": [
        [
          3,
          -4,
          5,
          1,
          -2
        ],
        -4,
        5
      ],
      "expected": 4
    },
    {
      "args": [
        [
          4,
          -7,
          2
        ],
        3,
        6
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
      0,
      0
    ],
    "expected": 0
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
        1
      ],
      1,
      2
    ],
    "expected": 1
  },
  {
    "args": [
      [
        -1,
        1
      ],
      -1,
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
      -2,
      2
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    1987,
    '网格游戏',
    '给定 2 x n 的网格 grid，两名机器人从 (0, 0) 出发前往 (1, n - 1)。
机器人只能向右或向下移动。第一个机器人先走，会收集路径上的数字；
随后第二个机器人从剩余数字中收集。第一个机器人希望第二个机器人得分尽可能小，
第二个机器人希望自己得分尽可能大。返回第二个机器人能获得的最大得分。
1 <= n <= 5 * 10^4，0 <= grid[i][j] <= 10^5。',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '矩阵'],
    $json$[
  {
    "input": "grid = [[2, 5, 4], [1, 5, 1]]",
    "output": "4"
  },
  {
    "input": "grid = [[3, 3, 1], [8, 5, 2]]",
    "output": "4"
  },
  {
    "input": "grid = [[1, 3, 1, 15], [1, 3, 3, 1]]",
    "output": "7"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[2, 5, 4], [1, 5, 1]]",
    "output": "4"
  },
  {
    "input": "grid = [[3, 3, 1], [8, 5, 2]]",
    "output": "4"
  },
  {
    "input": "grid = [[1, 3, 1, 15], [1, 3, 3, 1]]",
    "output": "7"
  }
]$json$::jsonb,
    $json${
  "javascript": "var gridGame = function(grid) {\n};\n",
  "python": "class Solution:\n    def gridGame(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long gridGame(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long gridGame(int[][] grid) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "gridGame",
  "params": [
    {
      "name": "grid",
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
            2,
            5,
            4
          ],
          [
            1,
            5,
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
            1
          ],
          [
            8,
            5,
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
            3,
            1,
            15
          ],
          [
            1,
            3,
            3,
            1
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
          10,
          10
        ],
        [
          10,
          10
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
    "expected": 2
  },
  {
    "args": [
      [
        [
          5,
          1,
          2
        ],
        [
          3,
          4,
          6
        ]
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    1988,
    '蜡烛之间的盘子',
    '给定字符串 s，''|'' 表示蜡烛，''*'' 表示盘子。再给定查询数组 queries，
每个查询为 [left, right]。对每个查询，统计位于区间内两根蜡烛之间的盘子数量；
若区间内不足两根蜡烛则答案为 0。按查询顺序返回结果。
1 <= s.length <= 10^5，1 <= queries.length <= 10^5，
0 <= left <= right < s.length。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '前缀和'],
    $json$[
  {
    "input": "s = \"**|**|***|\", queries = [[2, 5], [5, 9]]",
    "output": "[2, 3]"
  },
  {
    "input": "s = \"***|**|*****|**||**|*\", queries = [[1, 17], [4, 5], [14, 17], [5, 11], [15, 16]]",
    "output": "[9, 0, 0, 0, 0]"
  },
  {
    "input": "s = \"||\", queries = [[0, 1]]",
    "output": "[0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"**|**|***|\", queries = [[2, 5], [5, 9]]",
    "output": "[2, 3]"
  },
  {
    "input": "s = \"***|**|*****|**||**|*\", queries = [[1, 17], [4, 5], [14, 17], [5, 11], [15, 16]]",
    "output": "[9, 0, 0, 0, 0]"
  },
  {
    "input": "s = \"||\", queries = [[0, 1]]",
    "output": "[0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var platesBetweenCandles = function(s, queries) {\n};\n",
  "python": "class Solution:\n    def platesBetweenCandles(self, s: str, queries: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> platesBetweenCandles(std::string s, std::vector<std::vector<int>>& queries) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] platesBetweenCandles(String s, int[][] queries) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "platesBetweenCandles",
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
        "**|**|***|",
        [
          [
            2,
            5
          ],
          [
            5,
            9
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
        "***|**|*****|**||**|*",
        [
          [
            1,
            17
          ],
          [
            4,
            5
          ],
          [
            14,
            17
          ],
          [
            5,
            11
          ],
          [
            15,
            16
          ]
        ]
      ],
      "expected": [
        9,
        0,
        0,
        0,
        0
      ]
    },
    {
      "args": [
        "||",
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
      "|",
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
      "*",
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
      "|*|",
      [
        [
          0,
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
      "*|*",
      [
        [
          0,
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
      "**|**",
      [
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
      "|**|",
      [
        [
          0,
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
    1989,
    '描述绘画结果',
    '给定若干染色区间 segments，每个区间为 [start, end, color]，
表示把左闭右开区间 [start, end) 上的每个点颜色值加上 color。
多个区间重叠时颜色值相加。返回颜色值非零的互不重叠左闭右开区间，
相邻且颜色相同的区间合并为一个区间，每个结果区间为 [start, end, color]，按 start 升序排列。
1 <= segments.length <= 1000，1 <= start < end <= 10^5，1 <= color <= 10^6。',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '哈希表'],
    $json$[
  {
    "input": "segments = [[1, 4, 5], [4, 7, 7], [1, 7, 9]]",
    "output": "[[1, 4, 14], [4, 7, 16]]"
  },
  {
    "input": "segments = [[1, 4, 5], [1, 4, 7], [1, 4, 6]]",
    "output": "[[1, 4, 18]]"
  },
  {
    "input": "segments = [[1, 2, 3]]",
    "output": "[[1, 2, 3]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "segments = [[1, 4, 5], [4, 7, 7], [1, 7, 9]]",
    "output": "[[1, 4, 14], [4, 7, 16]]"
  },
  {
    "input": "segments = [[1, 4, 5], [1, 4, 7], [1, 4, 6]]",
    "output": "[[1, 4, 18]]"
  },
  {
    "input": "segments = [[1, 2, 3]]",
    "output": "[[1, 2, 3]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var describePainting = function(segments) {\n};\n",
  "python": "class Solution:\n    def describePainting(self, segments: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> describePainting(std::vector<std::vector<int>>& segments) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] describePainting(int[][] segments) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "describePainting",
  "params": [
    {
      "name": "segments",
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
            4,
            5
          ],
          [
            4,
            7,
            7
          ],
          [
            1,
            7,
            9
          ]
        ]
      ],
      "expected": [
        [
          1,
          4,
          14
        ],
        [
          4,
          7,
          16
        ]
      ]
    },
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
            4,
            7
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
          1,
          4,
          18
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
          1,
          3,
          1
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
        2,
        1
      ],
      [
        2,
        3,
        3
      ],
      [
        3,
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
          5,
          10
        ]
      ]
    ],
    "expected": [
      [
        1,
        5,
        10
      ]
    ]
  },
  {
    "args": [
      [
        [
          2,
          2,
          5
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
          10,
          1
        ],
        [
          5,
          15,
          2
        ]
      ]
    ],
    "expected": [
      [
        1,
        5,
        1
      ],
      [
        5,
        10,
        3
      ],
      [
        10,
        15,
        2
      ]
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1990,
    '子数组范围和',
    '给定整数数组 nums，返回所有非空连续子数组中
（最大值减最小值）之和。
1 <= nums.length <= 10^5，-10^4 <= nums[i] <= 10^4。',
    'medium',
    1000,
    256,
    ARRAY['数组', '单调栈'],
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "4"
  },
  {
    "input": "nums = [1, 3, 3]",
    "output": "4"
  },
  {
    "input": "nums = [4, -2, -3, 4, 1]",
    "output": "59"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3]",
    "output": "4"
  },
  {
    "input": "nums = [1, 3, 3]",
    "output": "4"
  },
  {
    "input": "nums = [4, -2, -3, 4, 1]",
    "output": "59"
  }
]$json$::jsonb,
    $json${
  "javascript": "var subarrayRangesSum = function(nums) {\n};\n",
  "python": "class Solution:\n    def subarrayRangesSum(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long subarrayRangesSum(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long subarrayRangesSum(int[] nums) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "subarrayRangesSum",
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
      "expected": 4
    },
    {
      "args": [
        [
          1,
          3,
          3
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          4,
          -2,
          -3,
          4,
          1
        ]
      ],
      "expected": 59
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
    "expected": 0
  },
  {
    "args": [
      [
        -1,
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
        2
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
    "expected": 20
  }
]$json$::jsonb,
    'approved'
),
(
    1991,
    '将数组分成三个子数组的方案数',
    '将非负整数数组 nums 切成三个非空连续部分，切点分别为 i 和 j
（即 [0, i]、[i + 1, j]、[j + 1, n - 1]）。
若三部分元素和依次不下降（第一段 <= 第二段 <= 第三段），则称为一种好方案。
返回好方案数目，对 10^9 + 7 取模。
3 <= nums.length <= 10^5，0 <= nums[i] <= 10^4。',
    'medium',
    1000,
    256,
    ARRAY['数组', '前缀和', '二分查找'],
    $json$[
  {
    "input": "nums = [1, 1, 1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 2, 2, 5, 0]",
    "output": "3"
  },
  {
    "input": "nums = [3, 2, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 1]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 2, 2, 5, 0]",
    "output": "3"
  },
  {
    "input": "nums = [3, 2, 1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var waysToSplitArray = function(nums) {\n};\n",
  "python": "class Solution:\n    def waysToSplitArray(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int waysToSplitArray(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int waysToSplitArray(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "waysToSplitArray",
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
      "expected": 1
    },
    {
      "args": [
        [
          1,
          2,
          2,
          2,
          5,
          0
        ]
      ],
      "expected": 3
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
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1992,
    '新增的最少台阶数',
    '给定严格递增的台阶高度数组 rungs（不含地面 0）和整数 dist。
你从高度 0 出发，每次最多向上跨 dist。可以在任意高度新增台阶，
返回到达最后一个台阶所需新增台阶的最少数量。
1 <= rungs.length <= 10^5，rungs 严格递增且 rungs[i] <= 10^5，1 <= dist <= 10^5。',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心'],
    $json$[
  {
    "input": "rungs = [1, 3, 5, 10], dist = 2",
    "output": "2"
  },
  {
    "input": "rungs = [3, 6, 8, 10], dist = 3",
    "output": "0"
  },
  {
    "input": "rungs = [3, 4, 6, 7], dist = 2",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "rungs = [1, 3, 5, 10], dist = 2",
    "output": "2"
  },
  {
    "input": "rungs = [3, 6, 8, 10], dist = 3",
    "output": "0"
  },
  {
    "input": "rungs = [3, 4, 6, 7], dist = 2",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var addMinimumRungs = function(rungs, dist) {\n};\n",
  "python": "class Solution:\n    def addMinimumRungs(self, rungs: list[int], dist: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int addMinimumRungs(std::vector<int>& rungs, int dist) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int addMinimumRungs(int[] rungs, int dist) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "addMinimumRungs",
  "params": [
    {
      "name": "rungs",
      "type": "int[]"
    },
    {
      "name": "dist",
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
          10
        ],
        2
      ],
      "expected": 2
    },
    {
      "args": [
        [
          3,
          6,
          8,
          10
        ],
        3
      ],
      "expected": 0
    },
    {
      "args": [
        [
          3,
          4,
          6,
          7
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
        5
      ],
      2
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
    "expected": 0
  },
  {
    "args": [
      [
        5,
        10
      ],
      5
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        5,
        9
      ],
      2
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1993,
    '袋子里最少数目的球',
    '给定整数数组 nums，nums[i] 表示第 i 个袋子中的球数。
每次操作可以选择一个袋子，把它分成两个非空袋子。
最多操作 maxOperations 次，返回单个袋子中球数最大值的最小可能值。
1 <= nums.length <= 10^5，0 <= maxOperations <= 10^5，1 <= nums[i] <= 10^9。',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "nums = [9], maxOperations = 2",
    "output": "3"
  },
  {
    "input": "nums = [2, 4, 8, 2], maxOperations = 4",
    "output": "2"
  },
  {
    "input": "nums = [7, 17], maxOperations = 2",
    "output": "7"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [9], maxOperations = 2",
    "output": "3"
  },
  {
    "input": "nums = [2, 4, 8, 2], maxOperations = 4",
    "output": "2"
  },
  {
    "input": "nums = [7, 17], maxOperations = 2",
    "output": "7"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumSizeOfBag = function(nums, maxOperations) {\n};\n",
  "python": "class Solution:\n    def minimumSizeOfBag(self, nums: list[int], maxOperations: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumSizeOfBag(std::vector<int>& nums, int maxOperations) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumSizeOfBag(int[] nums, int maxOperations) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumSizeOfBag",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "maxOperations",
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
          9
        ],
        2
      ],
      "expected": 3
    },
    {
      "args": [
        [
          2,
          4,
          8,
          2
        ],
        4
      ],
      "expected": 2
    },
    {
      "args": [
        [
          7,
          17
        ],
        2
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
      ],
      0
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        2
      ],
      0
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        100
      ],
      0
    ],
    "expected": 100
  },
  {
    "args": [
      [
        100
      ],
      10
    ],
    "expected": 10
  },
  {
    "args": [
      [
        5,
        5,
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
    1994,
    '分配给商店的最多商品的最小值',
    '有 n 家商店和若干种商品，quantities[i] 表示第 i 种商品的数量。
同一种商品可以分给多家商店，但每家商店只能收到一种商品。
返回分配给单家商店商品数的最大值的最小可能值。
1 <= n <= 10^5，1 <= quantities.length <= 10^5，
1 <= quantities[i] <= 10^5。',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
  {
    "input": "n = 6, quantities = [11, 6]",
    "output": "3"
  },
  {
    "input": "n = 7, quantities = [15, 10, 10]",
    "output": "5"
  },
  {
    "input": "n = 1, quantities = [100000]",
    "output": "100000"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 6, quantities = [11, 6]",
    "output": "3"
  },
  {
    "input": "n = 7, quantities = [15, 10, 10]",
    "output": "5"
  },
  {
    "input": "n = 1, quantities = [100000]",
    "output": "100000"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimizedMaximum = function(n, quantities) {\n};\n",
  "python": "class Solution:\n    def minimizedMaximum(self, n: int, quantities: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimizedMaximum(int n, std::vector<int>& quantities) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimizedMaximum(int n, int[] quantities) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimizedMaximum",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "quantities",
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
        6,
        [
          11,
          6
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        7,
        [
          15,
          10,
          10
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        1,
        [
          100000
        ]
      ],
      "expected": 100000
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
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      3,
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
      4,
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
      5,
      [
        7,
        7
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    1995,
    '可以到达的最远建筑',
    '给定建筑高度数组 heights，你有 bricks 块砖和 ladders 个梯子。
从建筑 0 出发向右移动，遇到更高的下一栋建筑时，可以用一架梯子，
或用高度差的砖块数量向上爬。梯子必须整架使用，砖块可以按需消耗。
返回能到达的最远建筑下标（从 0 开始）。
1 <= heights.length <= 10^5，0 <= bricks <= 10^9，0 <= ladders <= heights.length，
1 <= heights[i] <= 10^5。',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心', '堆'],
    $json$[
  {
    "input": "heights = [4, 2, 7, 6, 9, 14, 12], bricks = 5, ladders = 1",
    "output": "4"
  },
  {
    "input": "heights = [4, 12, 2, 7, 3, 18, 20, 3, 19], bricks = 10, ladders = 2",
    "output": "7"
  },
  {
    "input": "heights = [14, 3, 19, 3], bricks = 17, ladders = 0",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "heights = [4, 2, 7, 6, 9, 14, 12], bricks = 5, ladders = 1",
    "output": "4"
  },
  {
    "input": "heights = [4, 12, 2, 7, 3, 18, 20, 3, 19], bricks = 10, ladders = 2",
    "output": "7"
  },
  {
    "input": "heights = [14, 3, 19, 3], bricks = 17, ladders = 0",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var furthestBuilding = function(heights, bricks, ladders) {\n};\n",
  "python": "class Solution:\n    def furthestBuilding(self, heights: list[int], bricks: int, ladders: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int furthestBuilding(std::vector<int>& heights, int bricks, int ladders) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int furthestBuilding(int[] heights, int bricks, int ladders) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "furthestBuilding",
  "params": [
    {
      "name": "heights",
      "type": "int[]"
    },
    {
      "name": "bricks",
      "type": "int"
    },
    {
      "name": "ladders",
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
          2,
          7,
          6,
          9,
          14,
          12
        ],
        5,
        1
      ],
      "expected": 4
    },
    {
      "args": [
        [
          4,
          12,
          2,
          7,
          3,
          18,
          20,
          3,
          19
        ],
        10,
        2
      ],
      "expected": 7
    },
    {
      "args": [
        [
          14,
          3,
          19,
          3
        ],
        17,
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
      0,
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
      0,
      0
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        5
      ],
      3,
      0
    ],
    "expected": 0
  },
  {
    "args": [
      [
        1,
        5
      ],
      4,
      0
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        5
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
        3
      ],
      1,
      1
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    1996,
    '吃苹果的最大数目',
    '第 i 天苹果树会结 apples[i] 个苹果，这些苹果会在第 i + days[i] 天腐烂
（即只能在前 days[i] 天内食用，包括第 i 天）。每天最多吃一个苹果。
若某天 apples[i] == 0，则该天不结果。返回最多能吃到的苹果总数。
1 <= apples.length <= 10^4，0 <= apples[i] <= 10^4，
0 <= days[i] <= 10^4。',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心', '堆'],
    $json$[
  {
    "input": "apples = [1, 2, 3, 5, 2], days = [3, 2, 1, 4, 2]",
    "output": "7"
  },
  {
    "input": "apples = [3, 0, 0, 0, 0, 2], days = [3, 0, 0, 0, 0, 2]",
    "output": "5"
  },
  {
    "input": "apples = [1], days = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "apples = [1, 2, 3, 5, 2], days = [3, 2, 1, 4, 2]",
    "output": "7"
  },
  {
    "input": "apples = [3, 0, 0, 0, 0, 2], days = [3, 0, 0, 0, 0, 2]",
    "output": "5"
  },
  {
    "input": "apples = [1], days = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var eatenApples = function(apples, days) {\n};\n",
  "python": "class Solution:\n    def eatenApples(self, apples: list[int], days: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int eatenApples(std::vector<int>& apples, std::vector<int>& days) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int eatenApples(int[] apples, int[] days) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "eatenApples",
  "params": [
    {
      "name": "apples",
      "type": "int[]"
    },
    {
      "name": "days",
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
          5,
          2
        ],
        [
          3,
          2,
          1,
          4,
          2
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        [
          3,
          0,
          0,
          0,
          0,
          2
        ],
        [
          3,
          0,
          0,
          0,
          0,
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
        0
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
        1
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
      ],
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
        5,
        0,
        0,
        0,
        0,
        0
      ],
      [
        5,
        0,
        0,
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
    1997,
    '单线程 CPU',
    '给定任务数组 tasks，tasks[i] = [enqueueTime, processingTime]。
单线程 CPU 的规则：若 CPU 空闲，选择已到达且处理时间最短的任务（相同则下标最小）；
否则等待到下一个任务到达。返回任务下标的处理顺序。
1 <= tasks.length <= 10^5，1 <= enqueueTime <= 10^9，1 <= processingTime <= 10^9。',
    'medium',
    1000,
    256,
    ARRAY['数组', '堆', '排序'],
    $json$[
  {
    "input": "tasks = [[1, 2], [2, 4], [3, 2], [4, 1]]",
    "output": "[0, 2, 3, 1]"
  },
  {
    "input": "tasks = [[7, 10], [7, 12], [1, 5], [4, 8]]",
    "output": "[2, 3, 0, 1]"
  },
  {
    "input": "tasks = [[1, 1]]",
    "output": "[0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "tasks = [[1, 2], [2, 4], [3, 2], [4, 1]]",
    "output": "[0, 2, 3, 1]"
  },
  {
    "input": "tasks = [[7, 10], [7, 12], [1, 5], [4, 8]]",
    "output": "[2, 3, 0, 1]"
  },
  {
    "input": "tasks = [[1, 1]]",
    "output": "[0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var singleThreadedCpu = function(tasks) {\n};\n",
  "python": "class Solution:\n    def singleThreadedCpu(self, tasks: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> singleThreadedCpu(std::vector<std::vector<int>>& tasks) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] singleThreadedCpu(int[][] tasks) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "singleThreadedCpu",
  "params": [
    {
      "name": "tasks",
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
            4
          ],
          [
            3,
            2
          ],
          [
            4,
            1
          ]
        ]
      ],
      "expected": [
        0,
        2,
        3,
        1
      ]
    },
    {
      "args": [
        [
          [
            7,
            10
          ],
          [
            7,
            12
          ],
          [
            1,
            5
          ],
          [
            4,
            8
          ]
        ]
      ],
      "expected": [
        2,
        3,
        0,
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
          1
        ],
        [
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
    "expected": [
      1,
      0
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
          1
        ]
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
        [
          3,
          1
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
    "expected": [
      1,
      0,
      2
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    1998,
    '最大平均通过率',
    '给定 classes 数组，classes[i] = [passed_i, total_i] 表示第 i 个班级的
通过人数和总人数。你还有 extraStudents 名成绩必过的学生，需要全部分配到班级中。
返回分配后所有班级通过率的平均值的最大可能值。
误差在 10^-5 以内视为正确。
1 <= classes.length <= 10^5，1 <= passed_i <= total_i <= 10^5，
0 <= extraStudents <= 10^5。',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心', '堆'],
    $json$[
  {
    "input": "classes = [[1, 2], [3, 5], [2, 2]], extraStudents = 2",
    "output": "0.7833333333333333"
  },
  {
    "input": "classes = [[2, 4], [3, 9], [4, 5]], extraStudents = 1",
    "output": "0.5777777777777778"
  },
  {
    "input": "classes = [[1, 1]], extraStudents = 0",
    "output": "1.0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "classes = [[1, 2], [3, 5], [2, 2]], extraStudents = 2",
    "output": "0.7833333333333333"
  },
  {
    "input": "classes = [[2, 4], [3, 9], [4, 5]], extraStudents = 1",
    "output": "0.5777777777777778"
  },
  {
    "input": "classes = [[1, 1]], extraStudents = 0",
    "output": "1.0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxAverageRatio = function(classes, extraStudents) {\n};\n",
  "python": "class Solution:\n    def maxAverageRatio(self, classes: list[list[int]], extraStudents: int) -> float:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    double maxAverageRatio(std::vector<std::vector<int>>& classes, int extraStudents) {\n        return 0.0;\n    }\n};\n",
  "java": "class Solution {\n    public double maxAverageRatio(int[][] classes, int extraStudents) {\n        return 0.0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxAverageRatio",
  "params": [
    {
      "name": "classes",
      "type": "int[][]"
    },
    {
      "name": "extraStudents",
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
            2,
            2
          ]
        ],
        2
      ],
      "expected": 0.7833333333333333
    },
    {
      "args": [
        [
          [
            2,
            4
          ],
          [
            3,
            9
          ],
          [
            4,
            5
          ]
        ],
        1
      ],
      "expected": 0.5777777777777778
    },
    {
      "args": [
        [
          [
            1,
            1
          ]
        ],
        0
      ],
      "expected": 1.0
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
        ]
      ],
      0
    ],
    "expected": 0.6666666666666666
  },
  {
    "args": [
      [
        [
          1,
          2
        ]
      ],
      3
    ],
    "expected": 0.8
  },
  {
    "args": [
      [
        [
          3,
          4
        ],
        [
          1,
          2
        ]
      ],
      2
    ],
    "expected": 0.75
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
      ],
      4
    ],
    "expected": 0.8055555555555557
  }
]$json$::jsonb,
    'approved'
),
(
    1999,
    '找出数组中的第 K 大整数',
    '给定字符串数组 nums，每个字符串表示一个不含前导零的非负整数
（"0" 本身除外）。返回按数值大小降序排列后的第 k 大整数字符串。
1 <= k <= nums.length <= 10^4，1 <= nums[i].length <= 100。',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '字符串'],
    $json$[
  {
    "input": "nums = [\"3\", \"6\", \"7\", \"10\"], k = 4",
    "output": "\"3\""
  },
  {
    "input": "nums = [\"2\", \"21\", \"12\", \"1\"], k = 3",
    "output": "\"2\""
  },
  {
    "input": "nums = [\"0\", \"0\"], k = 2",
    "output": "\"0\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [\"3\", \"6\", \"7\", \"10\"], k = 4",
    "output": "\"3\""
  },
  {
    "input": "nums = [\"2\", \"21\", \"12\", \"1\"], k = 3",
    "output": "\"2\""
  },
  {
    "input": "nums = [\"0\", \"0\"], k = 2",
    "output": "\"0\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var kthLargestInteger = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def kthLargestInteger(self, nums: list[str], k: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string kthLargestInteger(std::vector<std::string>& nums, int k) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String kthLargestInteger(String[] nums, int k) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kthLargestInteger",
  "params": [
    {
      "name": "nums",
      "type": "string[]"
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
        [
          "3",
          "6",
          "7",
          "10"
        ],
        4
      ],
      "expected": "3"
    },
    {
      "args": [
        [
          "2",
          "21",
          "12",
          "1"
        ],
        3
      ],
      "expected": "2"
    },
    {
      "args": [
        [
          "0",
          "0"
        ],
        2
      ],
      "expected": "0"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "10"
      ],
      1
    ],
    "expected": "10"
  },
  {
    "args": [
      [
        "1",
        "2",
        "3"
      ],
      1
    ],
    "expected": "3"
  },
  {
    "args": [
      [
        "100",
        "20",
        "3"
      ],
      2
    ],
    "expected": "20"
  },
  {
    "args": [
      [
        "9",
        "8",
        "7"
      ],
      3
    ],
    "expected": "7"
  },
  {
    "args": [
      [
        "123",
        "123"
      ],
      1
    ],
    "expected": "123"
  }
]$json$::jsonb,
    'approved'
),
(
    2000,
    '等差子数组',
    '给定数组 nums 和等长查询数组 l、r。对每个查询 i，
取出 nums[l[i]] 到 nums[r[i]]（含两端）的子数组，判断其排序后是否为等差数列。
返回布尔数组，顺序与查询一致。
1 <= nums.length <= 500，-10^5 <= nums[i] <= 10^5，
1 <= l.length <= 500，0 <= l[i] <= r[i] < nums.length。',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "nums = [4, 6, 5, 9, 3, 7], l = [0, 0, 2], r = [2, 3, 5]",
    "output": "[true, false, true]"
  },
  {
    "input": "nums = [-12, -9, -3, -12, -6, 15, 20, -25, -20, -15, -10], l = [0, 1, 6, 4, 8, 7], r = [4, 4, 9, 7, 9, 10]",
    "output": "[false, true, false, false, true, true]"
  },
  {
    "input": "nums = [1, 2, 3, 4], l = [0, 2], r = [1, 3]",
    "output": "[true, true]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [4, 6, 5, 9, 3, 7], l = [0, 0, 2], r = [2, 3, 5]",
    "output": "[true, false, true]"
  },
  {
    "input": "nums = [-12, -9, -3, -12, -6, 15, 20, -25, -20, -15, -10], l = [0, 1, 6, 4, 8, 7], r = [4, 4, 9, 7, 9, 10]",
    "output": "[false, true, false, false, true, true]"
  },
  {
    "input": "nums = [1, 2, 3, 4], l = [0, 2], r = [1, 3]",
    "output": "[true, true]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var checkArithmeticSubarrays = function(nums, l, r) {\n};\n",
  "python": "class Solution:\n    def checkArithmeticSubarrays(self, nums: list[int], l: list[int], r: list[int]) -> list[bool]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<bool> checkArithmeticSubarrays(std::vector<int>& nums, std::vector<int>& l, std::vector<int>& r) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public boolean[] checkArithmeticSubarrays(int[] nums, int[] l, int[] r) {\n        return new boolean[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "checkArithmeticSubarrays",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "l",
      "type": "int[]"
    },
    {
      "name": "r",
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
          4,
          6,
          5,
          9,
          3,
          7
        ],
        [
          0,
          0,
          2
        ],
        [
          2,
          3,
          5
        ]
      ],
      "expected": [
        true,
        false,
        true
      ]
    },
    {
      "args": [
        [
          -12,
          -9,
          -3,
          -12,
          -6,
          15,
          20,
          -25,
          -20,
          -15,
          -10
        ],
        [
          0,
          1,
          6,
          4,
          8,
          7
        ],
        [
          4,
          4,
          9,
          7,
          9,
          10
        ]
      ],
      "expected": [
        false,
        true,
        false,
        false,
        true,
        true
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
          0,
          2
        ],
        [
          1,
          3
        ]
      ],
      "expected": [
        true,
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
      [
        0
      ],
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
        3,
        1,
        2
      ],
      [
        0
      ],
      [
        2
      ]
    ],
    "expected": [
      true
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
        0
      ],
      [
        2
      ]
    ],
    "expected": [
      true
    ]
  },
  {
    "args": [
      [
        1,
        3,
        6
      ],
      [
        0
      ],
      [
        2
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
        1,
        1
      ],
      [
        0
      ],
      [
        2
      ]
    ],
    "expected": [
      true
    ]
  },
  {
    "args": [
      [
        2,
        4,
        8,
        16
      ],
      [
        0,
        1
      ],
      [
        1,
        3
      ]
    ],
    "expected": [
      true,
      false
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    2001,
    '游戏中弱角色的数量',
    '给定二维数组 properties，properties[i] = [attack_i, defense_i]。
若存在另一个角色，其攻击力和防御力都严格大于当前角色，则当前角色是弱角色。
返回弱角色的数量。1 <= properties.length <= 10^5，
1 <= attack_i, defense_i <= 10^5。',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "properties = [[5, 5], [6, 3], [3, 6]]",
    "output": "0"
  },
  {
    "input": "properties = [[2, 2], [3, 3]]",
    "output": "1"
  },
  {
    "input": "properties = [[1, 5], [10, 4], [4, 3]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "properties = [[5, 5], [6, 3], [3, 6]]",
    "output": "0"
  },
  {
    "input": "properties = [[2, 2], [3, 3]]",
    "output": "1"
  },
  {
    "input": "properties = [[1, 5], [10, 4], [4, 3]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numberOfWeakCharacters = function(properties) {\n};\n",
  "python": "class Solution:\n    def numberOfWeakCharacters(self, properties: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numberOfWeakCharacters(std::vector<std::vector<int>>& properties) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numberOfWeakCharacters(int[][] properties) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numberOfWeakCharacters",
  "params": [
    {
      "name": "properties",
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
            5
          ],
          [
            6,
            3
          ],
          [
            3,
            6
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
            2
          ],
          [
            3,
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
            5
          ],
          [
            10,
            4
          ],
          [
            4,
            3
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
          10,
          1
        ],
        [
          1,
          10
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        [
          10,
          10
        ],
        [
          5,
          5
        ],
        [
          6,
          6
        ]
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    2002,
    '摧毁小行星',
    '给定初始质量 mass 和小行星质量数组 asteroids。
你可以按任意顺序摧毁小行星：只有质量不超过当前质量的小行星才能被摧毁，
摧毁后当前质量增加该小行星的质量。判断能否摧毁全部小行星。
1 <= mass <= 10^5，1 <= asteroids.length <= 10^5，1 <= asteroids[i] <= 10^5。',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心', '排序'],
    $json$[
  {
    "input": "mass = 10, asteroids = [3, 9, 19, 5, 21]",
    "output": "true"
  },
  {
    "input": "mass = 5, asteroids = [4, 9, 23, 4]",
    "output": "false"
  },
  {
    "input": "mass = 1, asteroids = [1]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "mass = 10, asteroids = [3, 9, 19, 5, 21]",
    "output": "true"
  },
  {
    "input": "mass = 5, asteroids = [4, 9, 23, 4]",
    "output": "false"
  },
  {
    "input": "mass = 1, asteroids = [1]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var asteroidsDestroyed = function(mass, asteroids) {\n};\n",
  "python": "class Solution:\n    def asteroidsDestroyed(self, mass: int, asteroids: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool asteroidsDestroyed(int mass, std::vector<int>& asteroids) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean asteroidsDestroyed(int mass, int[] asteroids) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "asteroidsDestroyed",
  "params": [
    {
      "name": "mass",
      "type": "int"
    },
    {
      "name": "asteroids",
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
        10,
        [
          3,
          9,
          19,
          5,
          21
        ]
      ],
      "expected": true
    },
    {
      "args": [
        5,
        [
          4,
          9,
          23,
          4
        ]
      ],
      "expected": false
    },
    {
      "args": [
        1,
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
      1,
      [
        2
      ]
    ],
    "expected": false
  },
  {
    "args": [
      1,
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
      10,
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
      5,
      [
        3,
        3,
        3
      ]
    ],
    "expected": true
  },
  {
    "args": [
      5,
      [
        10,
        1
      ]
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    2003,
    '使数组元素相等的减少操作次数',
    '给定整数数组 nums。每次操作选择一个元素，把它减小到数组中存在的某个更小元素。
返回使数组中所有元素都相等所需的最少操作次数。
1 <= nums.length <= 5 * 10^4，1 <= nums[i] <= 5 * 10^4。',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
  {
    "input": "nums = [5, 1, 3]",
    "output": "3"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "0"
  },
  {
    "input": "nums = [1, 1, 2, 2, 3]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [5, 1, 3]",
    "output": "3"
  },
  {
    "input": "nums = [1, 1, 1]",
    "output": "0"
  },
  {
    "input": "nums = [1, 1, 2, 2, 3]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var reductionOperations = function(nums) {\n};\n",
  "python": "class Solution:\n    def reductionOperations(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int reductionOperations(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int reductionOperations(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reductionOperations",
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
          1,
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
          1,
          2,
          2,
          3
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
        1,
        2
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
    "expected": 10
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
    "expected": 1
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
    "expected": 8
  }
]$json$::jsonb,
    'approved'
),
(
    2004,
    '减小和重新排列数组后的最大元素',
    '给定正整数数组 arr。你可以任意重新排列数组，并把某些元素减小到任意正整数。
操作后要求 arr[0] == 1，且相邻元素之差的绝对值不超过 1。
返回操作后 arr 中最大元素的最大可能值。
1 <= arr.length <= 10^5，1 <= arr[i] <= 10^9。',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '贪心'],
    $json$[
  {
    "input": "arr = [2, 2, 1, 2, 1]",
    "output": "2"
  },
  {
    "input": "arr = [100, 1, 1000]",
    "output": "3"
  },
  {
    "input": "arr = [1, 2, 3, 4, 5]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [2, 2, 1, 2, 1]",
    "output": "2"
  },
  {
    "input": "arr = [100, 1, 1000]",
    "output": "3"
  },
  {
    "input": "arr = [1, 2, 3, 4, 5]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumElementAfterDecrementing = function(arr) {\n};\n",
  "python": "class Solution:\n    def maximumElementAfterDecrementing(self, arr: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumElementAfterDecrementing(std::vector<int>& arr) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumElementAfterDecrementing(int[] arr) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumElementAfterDecrementing",
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
          100,
          1,
          1000
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
      [
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
        10,
        10,
        10
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
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    2005,
    '从双倍数组中还原原数组',
    '给定数组 changed，它由原数组 original 的每个元素和其两倍值混合后打乱得到。
返回 original；若 changed 无法由某个 original 得到，返回空数组。
答案按升序排列。changed 中的元素均为非负整数。
1 <= changed.length <= 10^5，0 <= changed[i] <= 10^5。',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '哈希表'],
    $json$[
  {
    "input": "changed = [1, 3, 4, 2, 6, 8]",
    "output": "[1, 3, 4]"
  },
  {
    "input": "changed = [6, 3, 0, 1]",
    "output": "[]"
  },
  {
    "input": "changed = [1]",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "changed = [1, 3, 4, 2, 6, 8]",
    "output": "[1, 3, 4]"
  },
  {
    "input": "changed = [6, 3, 0, 1]",
    "output": "[]"
  },
  {
    "input": "changed = [1]",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findOriginalArray = function(changed) {\n};\n",
  "python": "class Solution:\n    def findOriginalArray(self, changed: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findOriginalArray(std::vector<int>& changed) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findOriginalArray(int[] changed) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findOriginalArray",
  "params": [
    {
      "name": "changed",
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
          4,
          2,
          6,
          8
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
          6,
          3,
          0,
          1
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
      "expected": []
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        0,
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
        2,
        1,
        2,
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
        4,
        2,
        8,
        4
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
        2,
        4,
        8
      ]
    ],
    "expected": [
      1,
      4
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    2006,
    '构造字典序最大的合并字符串',
    '给定两个字符串 word1 和 word2。每次从任一字符串的开头取一个字符
追加到结果末尾，直到两个字符串都取完。返回能得到的字典序最大的字符串。
1 <= word1.length, word2.length <= 3000，两个字符串均只含小写英文字母。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '贪心', '双指针'],
    $json$[
  {
    "input": "word1 = \"cabaa\", word2 = \"bcaaa\"",
    "output": "\"cbcabaaaaa\""
  },
  {
    "input": "word1 = \"abcabc\", word2 = \"abdcaba\"",
    "output": "\"abdcabcabcaba\""
  },
  {
    "input": "word1 = \"a\", word2 = \"b\"",
    "output": "\"ba\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "word1 = \"cabaa\", word2 = \"bcaaa\"",
    "output": "\"cbcabaaaaa\""
  },
  {
    "input": "word1 = \"abcabc\", word2 = \"abdcaba\"",
    "output": "\"abdcabcabcaba\""
  },
  {
    "input": "word1 = \"a\", word2 = \"b\"",
    "output": "\"ba\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestMerge = function(word1, word2) {\n};\n",
  "python": "class Solution:\n    def largestMerge(self, word1: str, word2: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string largestMerge(std::string word1, std::string word2) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String largestMerge(String word1, String word2) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestMerge",
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
  "return_type": "string",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "cabaa",
        "bcaaa"
      ],
      "expected": "cbcabaaaaa"
    },
    {
      "args": [
        "abcabc",
        "abdcaba"
      ],
      "expected": "abdcabcabcaba"
    },
    {
      "args": [
        "a",
        "b"
      ],
      "expected": "ba"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      "a"
    ],
    "expected": "aa"
  },
  {
    "args": [
      "abc",
      "abc"
    ],
    "expected": "abcabc"
  },
  {
    "args": [
      "z",
      "z"
    ],
    "expected": "zz"
  },
  {
    "args": [
      "ab",
      "ba"
    ],
    "expected": "baba"
  },
  {
    "args": [
      "aaa",
      "aa"
    ],
    "expected": "aaaaa"
  }
]$json$::jsonb,
    'approved'
),
(
    2007,
    '统计同质子字符串的数目',
    '若一个字符串的所有字符都相同，则称其为同质字符串。
给定字符串 s，返回 s 的同质非空子字符串数目，对 10^9 + 7 取模。
1 <= s.length <= 10^5，s 仅含小写英文字母。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '数学'],
    $json$[
  {
    "input": "s = \"abbcccaa\"",
    "output": "13"
  },
  {
    "input": "s = \"xy\"",
    "output": "2"
  },
  {
    "input": "s = \"zzzzz\"",
    "output": "15"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abbcccaa\"",
    "output": "13"
  },
  {
    "input": "s = \"xy\"",
    "output": "2"
  },
  {
    "input": "s = \"zzzzz\"",
    "output": "15"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countHomogenousSubstrings = function(s) {\n};\n",
  "python": "class Solution:\n    def countHomogenousSubstrings(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countHomogenousSubstrings(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countHomogenousSubstrings(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countHomogenousSubstrings",
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
        "abbcccaa"
      ],
      "expected": 13
    },
    {
      "args": [
        "xy"
      ],
      "expected": 2
    },
    {
      "args": [
        "zzzzz"
      ],
      "expected": 15
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
      "aaa"
    ],
    "expected": 6
  },
  {
    "args": [
      "aab"
    ],
    "expected": 4
  },
  {
    "args": [
      "ababa"
    ],
    "expected": 5
  },
  {
    "args": [
      "aaaaabbbbb"
    ],
    "expected": 30
  }
]$json$::jsonb,
    'approved'
),
(
    2008,
    '所有子字符串美丽值之和',
    '一个字符串的美丽值定义为出现次数最多字符的频次减去出现次数最少字符的频次
（只统计出现过的字符）。给定字符串 s，返回其所有非空子字符串的美丽值之和。
1 <= s.length <= 500，s 仅含小写英文字母。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '哈希表', '计数'],
    $json$[
  {
    "input": "s = \"aabcb\"",
    "output": "5"
  },
  {
    "input": "s = \"aabcbaa\"",
    "output": "17"
  },
  {
    "input": "s = \"abc\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aabcb\"",
    "output": "5"
  },
  {
    "input": "s = \"aabcbaa\"",
    "output": "17"
  },
  {
    "input": "s = \"abc\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumOfBeauty = function(s) {\n};\n",
  "python": "class Solution:\n    def sumOfBeauty(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int sumOfBeauty(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int sumOfBeauty(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumOfBeauty",
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
        "aabcb"
      ],
      "expected": 5
    },
    {
      "args": [
        "aabcbaa"
      ],
      "expected": 17
    },
    {
      "args": [
        "abc"
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
      "aba"
    ],
    "expected": 1
  },
  {
    "args": [
      "abca"
    ],
    "expected": 1
  },
  {
    "args": [
      "abcba"
    ],
    "expected": 4
  },
  {
    "args": [
      "aabbcc"
    ],
    "expected": 7
  }
]$json$::jsonb,
    'approved'
),
(
    2009,
    '所有子字符串中的元音',
    '给定字符串 word，返回其所有非空子字符串中元音字母出现次数之和。
元音字母为 a、e、i、o、u。1 <= word.length <= 10^5，
word 仅含小写英文字母。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '数学'],
    $json$[
  {
    "input": "word = \"aba\"",
    "output": "6"
  },
  {
    "input": "word = \"abc\"",
    "output": "3"
  },
  {
    "input": "word = \"ltcd\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "word = \"aba\"",
    "output": "6"
  },
  {
    "input": "word = \"abc\"",
    "output": "3"
  },
  {
    "input": "word = \"ltcd\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var vowelsOfAllSubstrings = function(word) {\n};\n",
  "python": "class Solution:\n    def vowelsOfAllSubstrings(self, word: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long vowelsOfAllSubstrings(std::string word) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long vowelsOfAllSubstrings(String word) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "vowelsOfAllSubstrings",
  "params": [
    {
      "name": "word",
      "type": "string"
    }
  ],
  "return_type": "long",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "aba"
      ],
      "expected": 6
    },
    {
      "args": [
        "abc"
      ],
      "expected": 3
    },
    {
      "args": [
        "ltcd"
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
      "aa"
    ],
    "expected": 4
  },
  {
    "args": [
      "bcdfg"
    ],
    "expected": 0
  },
  {
    "args": [
      "aeiou"
    ],
    "expected": 35
  },
  {
    "args": [
      "banana"
    ],
    "expected": 28
  }
]$json$::jsonb,
    'approved'
),
(
    2010,
    '股票平滑下跌阶段的数目',
    '若一个连续子数组满足每一项恰好比前一项小 1，则称为平滑下跌阶段。
给定股票价格数组 prices，返回平滑下跌阶段（包括长度为 1 的阶段）的数目。
1 <= prices.length <= 10^5，1 <= prices[i] <= 10^5。',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "prices = [3, 2, 1, 4]",
    "output": "7"
  },
  {
    "input": "prices = [8, 6, 7, 7]",
    "output": "4"
  },
  {
    "input": "prices = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "prices = [3, 2, 1, 4]",
    "output": "7"
  },
  {
    "input": "prices = [8, 6, 7, 7]",
    "output": "4"
  },
  {
    "input": "prices = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var smoothDescentPeriods = function(prices) {\n};\n",
  "python": "class Solution:\n    def smoothDescentPeriods(self, prices: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long smoothDescentPeriods(std::vector<int>& prices) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long smoothDescentPeriods(int[] prices) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smoothDescentPeriods",
  "params": [
    {
      "name": "prices",
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
          3,
          2,
          1,
          4
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        [
          8,
          6,
          7,
          7
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
    }
  ]
}$json$::jsonb,
    $json$[
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
        1
      ]
    ],
    "expected": 6
  },
  {
    "args": [
      [
        5
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    2011,
    '大餐计数',
    '给定整数数组 deliciousness，统计满足 0 <= i < j < n 且
deliciousness[i] + deliciousness[j] 是 2 的幂的不同下标数对数目。
返回结果对 10^9 + 7 取模。1 <= deliciousness.length <= 10^5，
0 <= deliciousness[i] <= 2^20。',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表'],
    $json$[
  {
    "input": "deliciousness = [1, 3, 5, 7, 9]",
    "output": "4"
  },
  {
    "input": "deliciousness = [1, 1, 1, 3, 3, 3, 7]",
    "output": "15"
  },
  {
    "input": "deliciousness = [0, 0, 0]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "deliciousness = [1, 3, 5, 7, 9]",
    "output": "4"
  },
  {
    "input": "deliciousness = [1, 1, 1, 3, 3, 3, 7]",
    "output": "15"
  },
  {
    "input": "deliciousness = [0, 0, 0]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countGoodMeals = function(deliciousness) {\n};\n",
  "python": "class Solution:\n    def countGoodMeals(self, deliciousness: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countGoodMeals(std::vector<int>& deliciousness) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countGoodMeals(int[] deliciousness) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countGoodMeals",
  "params": [
    {
      "name": "deliciousness",
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
          7,
          9
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
          3,
          3,
          3,
          7
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
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1048576,
        1048576
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    2012,
    '统计一个数组中好对子的数目',
    '定义 rev(x) 为整数 x 十进制表示反转后得到的整数（忽略前导零）。
若 nums[i] + rev(nums[j]) == nums[j] + rev(nums[i])，则称 (i, j) 为好对子，
其中 0 <= i < j < nums.length。返回好对子数目，对 10^9 + 7 取模。
1 <= nums.length <= 10^5，0 <= nums[i] <= 10^9。',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表', '数学'],
    $json$[
  {
    "input": "nums = [42, 11, 1, 97]",
    "output": "2"
  },
  {
    "input": "nums = [13, 10, 35, 24, 76]",
    "output": "4"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [42, 11, 1, 97]",
    "output": "2"
  },
  {
    "input": "nums = [13, 10, 35, 24, 76]",
    "output": "4"
  },
  {
    "input": "nums = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countNicePairs = function(nums) {\n};\n",
  "python": "class Solution:\n    def countNicePairs(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countNicePairs(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countNicePairs(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countNicePairs",
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
          42,
          11,
          1,
          97
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          13,
          10,
          35,
          24,
          76
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
    "expected": 1
  },
  {
    "args": [
      [
        10,
        10
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        12,
        21
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        123,
        321
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
  }
]$json$::jsonb,
    'approved'
),
(
    2013,
    '找出数组中的所有孤独数字',
    '若数组中的一个数字只出现一次，且它相邻的整数（x - 1 和 x + 1）都没有出现，
则称该数字是孤独的。给定整数数组 nums，按升序返回所有孤独数字。
1 <= nums.length <= 10^5，0 <= nums[i] <= 10^6。',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表', '排序'],
    $json$[
  {
    "input": "nums = [10, 6, 5, 8]",
    "output": "[8, 10]"
  },
  {
    "input": "nums = [1, 3, 5, 3]",
    "output": "[1, 5]"
  },
  {
    "input": "nums = [7, 7, 7]",
    "output": "[]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [10, 6, 5, 8]",
    "output": "[8, 10]"
  },
  {
    "input": "nums = [1, 3, 5, 3]",
    "output": "[1, 5]"
  },
  {
    "input": "nums = [7, 7, 7]",
    "output": "[]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findLonelyNumbers = function(nums) {\n};\n",
  "python": "class Solution:\n    def findLonelyNumbers(self, nums: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findLonelyNumbers(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findLonelyNumbers(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findLonelyNumbers",
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
          10,
          6,
          5,
          8
        ]
      ],
      "expected": [
        8,
        10
      ]
    },
    {
      "args": [
        [
          1,
          3,
          5,
          3
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
          7,
          7,
          7
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
    "expected": []
  },
  {
    "args": [
      [
        5,
        4,
        3
      ]
    ],
    "expected": []
  },
  {
    "args": [
      [
        0,
        0,
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
        3
      ]
    ],
    "expected": [
      3
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    2014,
    '统计追加字母可以得到的目标字符串数目',
    '给定起始单词数组 startWords 和目标单词数组 targetWords。
若在某个起始单词中恰好添加一个字母，再重新排列所有字母，能够得到目标单词，
则称该目标单词可得到。返回可得到的目标单词数目。
每个单词只含小写英文字母，且同一单词内字母不重复。
1 <= startWords.length, targetWords.length <= 5 * 10^4，
1 <= 单词长度 <= 26。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '哈希表', '位运算'],
    $json$[
  {
    "input": "startWords = [\"ant\", \"act\", \"tack\"], targetWords = [\"tack\", \"act\", \"acti\"]",
    "output": "2"
  },
  {
    "input": "startWords = [\"ab\", \"a\"], targetWords = [\"abc\", \"abcd\"]",
    "output": "1"
  },
  {
    "input": "startWords = [\"a\"], targetWords = [\"a\"]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "startWords = [\"ant\", \"act\", \"tack\"], targetWords = [\"tack\", \"act\", \"acti\"]",
    "output": "2"
  },
  {
    "input": "startWords = [\"ab\", \"a\"], targetWords = [\"abc\", \"abcd\"]",
    "output": "1"
  },
  {
    "input": "startWords = [\"a\"], targetWords = [\"a\"]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var wordCountAfterAddingLetter = function(startWords, targetWords) {\n};\n",
  "python": "class Solution:\n    def wordCountAfterAddingLetter(self, startWords: list[str], targetWords: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int wordCountAfterAddingLetter(std::vector<std::string>& startWords, std::vector<std::string>& targetWords) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int wordCountAfterAddingLetter(String[] startWords, String[] targetWords) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "wordCountAfterAddingLetter",
  "params": [
    {
      "name": "startWords",
      "type": "string[]"
    },
    {
      "name": "targetWords",
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
          "ant",
          "act",
          "tack"
        ],
        [
          "tack",
          "act",
          "acti"
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          "ab",
          "a"
        ],
        [
          "abc",
          "abcd"
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          "a"
        ],
        [
          "a"
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
      ],
      [
        "ab"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "abc"
      ],
      [
        "abd",
        "abcd"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      [
        "abc"
      ],
      [
        "abc"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "ab",
        "ac"
      ],
      [
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
      ],
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
        "ab"
      ],
      [
        "abc",
        "abd"
      ]
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    2015,
    '删除一个字符串中所有出现的给定子字符串',
    '给定字符串 s 和子字符串 part。只要 part 在 s 中出现，就删除其中一次出现，
重复该过程直到 part 不再出现。返回最终字符串。
1 <= s.length <= 1000，1 <= part.length <= 1000，两个字符串均只含小写英文字母。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '栈', '模拟'],
    $json$[
  {
    "input": "s = \"daabcbaabcbc\", part = \"abc\"",
    "output": "\"dab\""
  },
  {
    "input": "s = \"axxxxyyyyb\", part = \"xy\"",
    "output": "\"ab\""
  },
  {
    "input": "s = \"a\", part = \"a\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"daabcbaabcbc\", part = \"abc\"",
    "output": "\"dab\""
  },
  {
    "input": "s = \"axxxxyyyyb\", part = \"xy\"",
    "output": "\"ab\""
  },
  {
    "input": "s = \"a\", part = \"a\"",
    "output": "\"\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var removeOccurrences = function(s, part) {\n};\n",
  "python": "class Solution:\n    def removeOccurrences(self, s: str, part: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string removeOccurrences(std::string s, std::string part) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String removeOccurrences(String s, String part) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "removeOccurrences",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "part",
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
        "daabcbaabcbc",
        "abc"
      ],
      "expected": "dab"
    },
    {
      "args": [
        "axxxxyyyyb",
        "xy"
      ],
      "expected": "ab"
    },
    {
      "args": [
        "a",
        "a"
      ],
      "expected": ""
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abc",
      "abc"
    ],
    "expected": ""
  },
  {
    "args": [
      "abccba",
      "cc"
    ],
    "expected": "abba"
  },
  {
    "args": [
      "aaaa",
      "aa"
    ],
    "expected": ""
  },
  {
    "args": [
      "xyz",
      "z"
    ],
    "expected": "xy"
  },
  {
    "args": [
      "ababab",
      "ab"
    ],
    "expected": ""
  }
]$json$::jsonb,
    'approved'
),
(
    2016,
    '使字符串平衡的最小交换次数',
    '给定一个长度为偶数、''['' 和 '']'' 数量相等的方括号字符串 s。
一次交换可以互换任意两个位置上的字符。返回使 s 成为平衡字符串的最少交换次数。
平衡字符串指每个 ''['' 都能与右侧某个 '']'' 配对，且所有括号正确嵌套。
1 <= s.length <= 10^5。',
    'medium',
    1000,
    256,
    ARRAY['字符串', '贪心', '栈'],
    $json$[
  {
    "input": "s = \"][\"",
    "output": "1"
  },
  {
    "input": "s = \"]]][[[\"",
    "output": "2"
  },
  {
    "input": "s = \"[]\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"][\"",
    "output": "1"
  },
  {
    "input": "s = \"]]][[[\"",
    "output": "2"
  },
  {
    "input": "s = \"[]\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minSwapsToBalance = function(s) {\n};\n",
  "python": "class Solution:\n    def minSwapsToBalance(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minSwapsToBalance(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minSwapsToBalance(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minSwapsToBalance",
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
        "]["
      ],
      "expected": 1
    },
    {
      "args": [
        "]]][[["
      ],
      "expected": 2
    },
    {
      "args": [
        "[]"
      ],
      "expected": 0
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "[[]]"
    ],
    "expected": 0
  },
  {
    "args": [
      "[][]"
    ],
    "expected": 0
  },
  {
    "args": [
      "[]]["
    ],
    "expected": 1
  },
  {
    "args": [
      "[[[]]]"
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    2017,
    '网络空闲的时刻',
    '给定无向连通图的边列表 edges 和每个节点重新发送消息的间隔 patience
节点编号为 0 到 n-1，其中 n 是 patience 的长度
节点 0 是主服务器，patience[0] 恒为 0，其余节点的 patience 均为正整数
每个节点在时刻 0 发送一条消息，之后每隔 patience[i] 秒重新发送一次
消息到达主服务器再原路返回共需 2 * 节点到节点 0 的最短距离秒
主服务器收到消息后立即回复
节点收到任意回复后就不再发送新消息
返回网络中没有消息在传输的最早时刻',
    'medium',
    1000,
    256,
    ARRAY['图', '广度优先搜索', '最短路'],
    $json$[
  {
    "input": "edges = [[0, 1], [0, 2]], patience = [0, 1, 1]",
    "output": "4"
  },
  {
    "input": "edges = [[0, 1], [1, 2]], patience = [0, 1, 1]",
    "output": "8"
  },
  {
    "input": "edges = [[0, 1], [0, 2], [1, 3]], patience = [0, 1, 1, 1]",
    "output": "8"
  },
  {
    "input": "edges = [[0, 1]], patience = [0, 5]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "edges = [[0, 1], [0, 2]], patience = [0, 1, 1]",
    "output": "4"
  },
  {
    "input": "edges = [[0, 1], [1, 2]], patience = [0, 1, 1]",
    "output": "8"
  },
  {
    "input": "edges = [[0, 1], [0, 2], [1, 3]], patience = [0, 1, 1, 1]",
    "output": "8"
  },
  {
    "input": "edges = [[0, 1]], patience = [0, 5]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var networkBecomesIdle = function(edges, patience) {\n};\n",
  "python": "class Solution:\n    def networkBecomesIdle(self, edges: list[list[int]], patience: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int networkBecomesIdle(std::vector<std::vector<int>>& edges, std::vector<int>& patience) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int networkBecomesIdle(int[][] edges, int[] patience) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "networkBecomesIdle",
  "params": [
    {
      "name": "edges",
      "type": "int[][]"
    },
    {
      "name": "patience",
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
            0,
            1
          ],
          [
            0,
            2
          ]
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
        [
          0,
          1,
          1
        ]
      ],
      "expected": 8
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
            2
          ],
          [
            1,
            3
          ]
        ],
        [
          0,
          1,
          1,
          1
        ]
      ],
      "expected": 8
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
          5
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
        0,
        2,
        3,
        4
      ]
    ],
    "expected": 11
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
      ],
      [
        0,
        1,
        100,
        1,
        100
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
          2
        ],
        [
          1,
          3
        ],
        [
          3,
          4
        ]
      ],
      [
        0,
        3,
        3,
        3,
        3
      ]
    ],
    "expected": 10
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
        10
      ]
    ],
    "expected": 3
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
          2
        ]
      ],
      [
        0,
        1,
        5
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
        ]
      ],
      [
        0,
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
    2018,
    '两个最好的不重叠活动',
    '给定活动列表 events，每项为 [开始时间, 结束时间, 价值]
选择至多两个互不重叠的活动，使价值之和最大
若两个活动满足前一个的结束时间严格小于后一个的开始时间，则它们不重叠
只选择一个活动也允许
返回能得到的最大价值之和',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序', '动态规划', '二分查找'],
    $json$[
  {
    "input": "events = [[1, 3, 2], [4, 5, 2], [2, 4, 3]]",
    "output": "4"
  },
  {
    "input": "events = [[1, 3, 2], [4, 5, 2], [1, 5, 5]]",
    "output": "5"
  },
  {
    "input": "events = [[1, 5, 3], [1, 5, 3], [1, 5, 3]]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "events = [[1, 3, 2], [4, 5, 2], [2, 4, 3]]",
    "output": "4"
  },
  {
    "input": "events = [[1, 3, 2], [4, 5, 2], [1, 5, 5]]",
    "output": "5"
  },
  {
    "input": "events = [[1, 5, 3], [1, 5, 3], [1, 5, 3]]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxTwoEvents = function(events) {\n};\n",
  "python": "class Solution:\n    def maxTwoEvents(self, events: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxTwoEvents(std::vector<std::vector<int>>& events) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxTwoEvents(int[][] events) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxTwoEvents",
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
            3,
            2
          ],
          [
            4,
            5,
            2
          ],
          [
            2,
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
            1,
            3,
            2
          ],
          [
            4,
            5,
            2
          ],
          [
            1,
            5,
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
            5,
            3
          ],
          [
            1,
            5,
            3
          ],
          [
            1,
            5,
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
          4,
          2
        ],
        [
          2,
          3,
          5
        ],
        [
          5,
          6,
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
          1
        ],
        [
          2,
          3,
          2
        ],
        [
          3,
          4,
          3
        ],
        [
          4,
          5,
          4
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
          20,
          100
        ],
        [
          1,
          5,
          1
        ],
        [
          6,
          9,
          1
        ]
      ]
    ],
    "expected": 101
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
        ],
        [
          3,
          5,
          7
        ]
      ]
    ],
    "expected": 7
  }
]$json$::jsonb,
    'approved'
),
(
    2019,
    '访问相同房间的路径',
    '给定无向图的房间数 n 和走廊列表 corridors
房间编号为 1 到 n
统计满足以下条件的房间对 (a, b)，其中 a 小于 b
从 a 到 b 恰好存在至少两条不同的长度为 2 的路径
两条长度为 2 的路径指分别经过两个不同的中间节点
返回这样的房间对数目',
    'medium',
    1000,
    256,
    ARRAY['图', '哈希表', '计数'],
    $json$[
  {
    "input": "n = 5, corridors = [[1, 2], [5, 2], [4, 1], [2, 4], [3, 1], [3, 4]]",
    "output": "2"
  },
  {
    "input": "n = 4, corridors = [[1, 2], [2, 3], [3, 1], [2, 4], [3, 4]]",
    "output": "2"
  },
  {
    "input": "n = 3, corridors = [[1, 2], [2, 3], [3, 1]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5, corridors = [[1, 2], [5, 2], [4, 1], [2, 4], [3, 1], [3, 4]]",
    "output": "2"
  },
  {
    "input": "n = 4, corridors = [[1, 2], [2, 3], [3, 1], [2, 4], [3, 4]]",
    "output": "2"
  },
  {
    "input": "n = 3, corridors = [[1, 2], [2, 3], [3, 1]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var pathsSameRoom = function(n, corridors) {\n};\n",
  "python": "class Solution:\n    def pathsSameRoom(self, n: int, corridors: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int pathsSameRoom(int n, std::vector<std::vector<int>>& corridors) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int pathsSameRoom(int n, int[][] corridors) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "pathsSameRoom",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "corridors",
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
            1,
            2
          ],
          [
            5,
            2
          ],
          [
            4,
            1
          ],
          [
            2,
            4
          ],
          [
            3,
            1
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
            1
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
          ],
          [
            3,
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
      2,
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
      6,
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
          3,
          4
        ],
        [
          4,
          5
        ],
        [
          5,
          3
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
          1
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      4,
      []
    ],
    "expected": 0
  },
  {
    "args": [
      6,
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
    ],
    "expected": 6
  },
  {
    "args": [
      7,
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
          4,
          5
        ],
        [
          5,
          6
        ],
        [
          6,
          4
        ],
        [
          3,
          4
        ]
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    2020,
    '从二叉树一个节点到另一个节点的步骤',
    '给定二叉树 root，节点值互不相同
给定树中两个不同节点的值 startValue 和 destValue
返回从 startValue 节点走到 destValue 节点的最短路径方向字符串
每一步用 L 表示走向左孩子，R 表示走向右孩子，U 表示走向父节点
答案保证唯一',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '字符串'],
    $json$[
  {
    "input": "root = [5, 1, 2, 3, null, 6, 4], startValue = 3, destValue = 6",
    "output": "\"UURL\""
  },
  {
    "input": "root = [2, 1], startValue = 2, destValue = 1",
    "output": "\"L\""
  },
  {
    "input": "root = [5, 1, 2, 3, null, 6, 4], startValue = 3, destValue = 4",
    "output": "\"UURR\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [5, 1, 2, 3, null, 6, 4], startValue = 3, destValue = 6",
    "output": "\"UURL\""
  },
  {
    "input": "root = [2, 1], startValue = 2, destValue = 1",
    "output": "\"L\""
  },
  {
    "input": "root = [5, 1, 2, 3, null, 6, 4], startValue = 3, destValue = 4",
    "output": "\"UURR\""
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar getDirections = function(root, startValue, destValue) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def getDirections(self, root: TreeNode | None, startValue: int, destValue: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    std::string getDirections(TreeNode* root, int startValue, int destValue) {\n        return \"\";\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public String getDirections(TreeNode root, int startValue, int destValue) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getDirections",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
    },
    {
      "name": "startValue",
      "type": "int"
    },
    {
      "name": "destValue",
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
        [
          5,
          1,
          2,
          3,
          null,
          6,
          4
        ],
        3,
        6
      ],
      "expected": "UURL"
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
      "expected": "L"
    },
    {
      "args": [
        [
          5,
          1,
          2,
          3,
          null,
          6,
          4
        ],
        3,
        4
      ],
      "expected": "UURR"
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
    "expected": ""
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
    "expected": "UR"
  },
  {
    "args": [
      [
        1,
        2,
        null,
        3
      ],
      3,
      2
    ],
    "expected": "U"
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
    "expected": "UR"
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
      6,
      7
    ],
    "expected": "UR"
  },
  {
    "args": [
      [
        1,
        2,
        null,
        3,
        4
      ],
      3,
      4
    ],
    "expected": "UR"
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
    "expected": "R"
  }
]$json$::jsonb,
    'approved'
),
(
    2021,
    '引爆最多的炸弹',
    '给定炸弹列表 bombs，每项为 [横坐标, 纵坐标, 爆炸半径]
炸弹 i 爆炸时能直接引爆炸弹 j 的条件是
两个炸弹中心的欧氏距离不大于炸弹 i 的爆炸半径
被引爆的炸弹还会继续引爆其他炸弹
选择引爆炸弹列表中的一个炸弹
返回最多能引爆的炸弹数量',
    'medium',
    1000,
    256,
    ARRAY['图', '深度优先搜索', '几何'],
    $json$[
  {
    "input": "bombs = [[2, 1, 3], [6, 1, 4]]",
    "output": "2"
  },
  {
    "input": "bombs = [[1, 1, 5], [10, 10, 5]]",
    "output": "1"
  },
  {
    "input": "bombs = [[1, 2, 3], [2, 3, 1], [3, 4, 2], [4, 5, 3], [5, 6, 4]]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "bombs = [[2, 1, 3], [6, 1, 4]]",
    "output": "2"
  },
  {
    "input": "bombs = [[1, 1, 5], [10, 10, 5]]",
    "output": "1"
  },
  {
    "input": "bombs = [[1, 2, 3], [2, 3, 1], [3, 4, 2], [4, 5, 3], [5, 6, 4]]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var detonateMaxBombs = function(bombs) {\n};\n",
  "python": "class Solution:\n    def detonateMaxBombs(self, bombs: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int detonateMaxBombs(std::vector<std::vector<int>>& bombs) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int detonateMaxBombs(int[][] bombs) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "detonateMaxBombs",
  "params": [
    {
      "name": "bombs",
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
            1,
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
            1,
            1,
            5
          ],
          [
            10,
            10,
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
            2,
            3
          ],
          [
            2,
            3,
            1
          ],
          [
            3,
            4,
            2
          ],
          [
            4,
            5,
            3
          ],
          [
            5,
            6,
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
          0,
          0,
          2
        ],
        [
          3,
          0,
          2
        ],
        [
          6,
          0,
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
          0,
          0,
          5
        ],
        [
          4,
          0,
          1
        ],
        [
          8,
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
          0,
          10
        ],
        [
          5,
          0,
          1
        ],
        [
          9,
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
          0,
          0,
          1
        ],
        [
          1,
          0,
          100
        ],
        [
          2,
          0,
          100
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
          0,
          1
        ],
        [
          2,
          0,
          100
        ],
        [
          4,
          0,
          100
        ]
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    2022,
    '从原材料到食物',
    '给定可制作的食谱 recipes，每道食谱所需的原材料 ingredients
以及当前拥有的原材料 supplies
ingredients[i] 是制作 recipes[i] 所需的一组材料
一道食谱可以被制作，当且仅当它的所有原材料要么在 supplies 中
要么可以由其他可制作食谱得到
返回所有最终可以制作的食谱，按字典序升序排列',
    'medium',
    1000,
    256,
    ARRAY['图', '拓扑排序', '哈希表'],
    $json$[
  {
    "input": "recipes = [\"bread\"], ingredients = [[\"yeast\", \"flour\"]], supplies = [\"yeast\", \"flour\"]",
    "output": "[\"bread\"]"
  },
  {
    "input": "recipes = [\"bread\", \"sandwich\"], ingredients = [[\"yeast\", \"flour\"], [\"bread\", \"meat\"]], supplies = [\"yeast\", \"flour\", \"meat\"]",
    "output": "[\"bread\", \"sandwich\"]"
  },
  {
    "input": "recipes = [\"bread\", \"sandwich\", \"burger\"], ingredients = [[\"yeast\", \"flour\"], [\"bread\", \"meat\"], [\"sandwich\", \"meat\", \"tomato\"]], supplies = [\"yeast\", \"flour\", \"meat\", \"tomato\"]",
    "output": "[\"bread\", \"burger\", \"sandwich\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "recipes = [\"bread\"], ingredients = [[\"yeast\", \"flour\"]], supplies = [\"yeast\", \"flour\"]",
    "output": "[\"bread\"]"
  },
  {
    "input": "recipes = [\"bread\", \"sandwich\"], ingredients = [[\"yeast\", \"flour\"], [\"bread\", \"meat\"]], supplies = [\"yeast\", \"flour\", \"meat\"]",
    "output": "[\"bread\", \"sandwich\"]"
  },
  {
    "input": "recipes = [\"bread\", \"sandwich\", \"burger\"], ingredients = [[\"yeast\", \"flour\"], [\"bread\", \"meat\"], [\"sandwich\", \"meat\", \"tomato\"]], supplies = [\"yeast\", \"flour\", \"meat\", \"tomato\"]",
    "output": "[\"bread\", \"burger\", \"sandwich\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findAllRecipes = function(recipes, ingredients, supplies) {\n};\n",
  "python": "class Solution:\n    def findAllRecipes(self, recipes: list[str], ingredients: list[list[str]], supplies: list[str]) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> findAllRecipes(std::vector<std::string>& recipes, std::vector<std::vector<std::string>>& ingredients, std::vector<std::string>& supplies) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] findAllRecipes(String[] recipes, String[][] ingredients, String[] supplies) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findAllRecipes",
  "params": [
    {
      "name": "recipes",
      "type": "string[]"
    },
    {
      "name": "ingredients",
      "type": "string[][]"
    },
    {
      "name": "supplies",
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
          "bread"
        ],
        [
          [
            "yeast",
            "flour"
          ]
        ],
        [
          "yeast",
          "flour"
        ]
      ],
      "expected": [
        "bread"
      ]
    },
    {
      "args": [
        [
          "bread",
          "sandwich"
        ],
        [
          [
            "yeast",
            "flour"
          ],
          [
            "bread",
            "meat"
          ]
        ],
        [
          "yeast",
          "flour",
          "meat"
        ]
      ],
      "expected": [
        "bread",
        "sandwich"
      ]
    },
    {
      "args": [
        [
          "bread",
          "sandwich",
          "burger"
        ],
        [
          [
            "yeast",
            "flour"
          ],
          [
            "bread",
            "meat"
          ],
          [
            "sandwich",
            "meat",
            "tomato"
          ]
        ],
        [
          "yeast",
          "flour",
          "meat",
          "tomato"
        ]
      ],
      "expected": [
        "bread",
        "burger",
        "sandwich"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "x"
      ],
      [
        [
          "a",
          "b"
        ]
      ],
      [
        "a"
      ]
    ],
    "expected": []
  },
  {
    "args": [
      [
        "x"
      ],
      [
        [
          "a",
          "b"
        ]
      ],
      [
        "a",
        "b"
      ]
    ],
    "expected": [
      "x"
    ]
  },
  {
    "args": [
      [
        "x",
        "y"
      ],
      [
        [
          "a"
        ],
        [
          "x"
        ]
      ],
      [
        "a"
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
        "x",
        "y",
        "z"
      ],
      [
        [
          "a"
        ],
        [
          "x"
        ],
        [
          "y"
        ]
      ],
      [
        "a"
      ]
    ],
    "expected": [
      "x",
      "y",
      "z"
    ]
  },
  {
    "args": [
      [
        "x",
        "y"
      ],
      [
        [
          "y"
        ],
        [
          "x"
        ]
      ],
      []
    ],
    "expected": []
  },
  {
    "args": [
      [
        "a",
        "b",
        "c"
      ],
      [
        [
          "m"
        ],
        [
          "n"
        ],
        [
          "a",
          "b"
        ]
      ],
      [
        "m",
        "n"
      ]
    ],
    "expected": [
      "a",
      "b",
      "c"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    2023,
    '平滑下降子数组的数目',
    '给定整数数组 prices
平滑下降子数组是连续子数组，且每对相邻元素都满足
前一个元素比后一个元素恰好大 1
返回数组中共有多少个平滑下降子数组',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "prices = [3, 2, 1, 4]",
    "output": "7"
  },
  {
    "input": "prices = [8, 6, 7, 4, 2]",
    "output": "5"
  },
  {
    "input": "prices = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "prices = [3, 2, 1, 4]",
    "output": "7"
  },
  {
    "input": "prices = [8, 6, 7, 4, 2]",
    "output": "5"
  },
  {
    "input": "prices = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var getDescentPeriods = function(prices) {\n};\n",
  "python": "class Solution:\n    def getDescentPeriods(self, prices: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long getDescentPeriods(std::vector<int>& prices) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long getDescentPeriods(int[] prices) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getDescentPeriods",
  "params": [
    {
      "name": "prices",
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
          3,
          2,
          1,
          4
        ]
      ],
      "expected": 7
    },
    {
      "args": [
        [
          8,
          6,
          7,
          4,
          2
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
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        5,
        4,
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
        3
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        3,
        2,
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
        3,
        2,
        1,
        0,
        -1
      ]
    ],
    "expected": 21
  }
]$json$::jsonb,
    'approved'
),
(
    2024,
    '有向无环图中一个节点的所有祖先',
    '给定有向无环图的节点数 n 和边列表 edges
第 i 个节点的编号为 i
返回长度为 n 的列表，第 i 项是节点 i 的所有祖先节点
祖先指存在一条从该节点到 i 的长度至少为 1 的路径
每项中的节点编号必须按升序排列',
    'medium',
    1000,
    256,
    ARRAY['图', '拓扑排序', '深度优先搜索'],
    $json$[
  {
    "input": "n = 8, edges = [[0, 1], [0, 2], [0, 3], [0, 4], [1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]",
    "output": "[[], [0], [0, 1], [0, 1, 2], [0, 1, 2, 3], [], [], []]"
  },
  {
    "input": "n = 5, edges = [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]]",
    "output": "[[], [0], [0, 1], [0, 1, 2], []]"
  },
  {
    "input": "n = 3, edges = []",
    "output": "[[], [], []]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 8, edges = [[0, 1], [0, 2], [0, 3], [0, 4], [1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]",
    "output": "[[], [0], [0, 1], [0, 1, 2], [0, 1, 2, 3], [], [], []]"
  },
  {
    "input": "n = 5, edges = [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]]",
    "output": "[[], [0], [0, 1], [0, 1, 2], []]"
  },
  {
    "input": "n = 3, edges = []",
    "output": "[[], [], []]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var getAncestors = function(n, edges) {\n};\n",
  "python": "class Solution:\n    def getAncestors(self, n: int, edges: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> getAncestors(int n, std::vector<std::vector<int>>& edges) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] getAncestors(int n, int[][] edges) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "getAncestors",
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
        8,
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
          ]
        ]
      ],
      "expected": [
        [],
        [
          0
        ],
        [
          0,
          1
        ],
        [
          0,
          1,
          2
        ],
        [
          0,
          1,
          2,
          3
        ],
        [],
        [],
        []
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
          ],
          [
            2,
            3
          ]
        ]
      ],
      "expected": [
        [],
        [
          0
        ],
        [
          0,
          1
        ],
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
        3,
        []
      ],
      "expected": [
        [],
        [],
        []
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
      ]
    ],
    "expected": [
      [],
      [
        0
      ],
      [
        0,
        1
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
          3
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
          2,
          5
        ]
      ]
    ],
    "expected": [
      [],
      [
        0
      ],
      [
        0
      ],
      [
        0,
        1,
        2
      ],
      [
        0,
        1,
        2,
        3
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
      [
        [
          0,
          1
        ]
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
      [],
      [
        0
      ],
      [
        0,
        1
      ],
      [
        0,
        1,
        2
      ],
      [
        0,
        1,
        2,
        3
      ],
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
      [],
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
        ],
        [
          1,
          2
        ]
      ]
    ],
    "expected": [
      [],
      [
        0
      ],
      [
        0,
        1
      ],
      [
        0,
        1,
        2
      ],
      []
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    2025,
    '根据描述创建二叉树',
    '给定二维数组 descriptions
每项为 [父节点值, 子节点值, 是否为左孩子]，其中 1 表示左孩子，0 表示右孩子
所有节点值互不相同，给出的描述刚好构成一棵二叉树
返回构造出的二叉树的根节点（按层序序列化输出）',
    'medium',
    1000,
    256,
    ARRAY['树', '哈希表', '二叉树'],
    $json$[
  {
    "input": "descriptions = [[20, 15, 1], [20, 17, 0], [50, 20, 1], [50, 80, 0], [80, 19, 1]]",
    "output": "[50, 20, 80, 15, 17, 19]"
  },
  {
    "input": "descriptions = [[1, 2, 1], [1, 3, 0], [2, 4, 1]]",
    "output": "[1, 2, 3, 4]"
  },
  {
    "input": "descriptions = [[1, 2, 1]]",
    "output": "[1, 2]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "descriptions = [[20, 15, 1], [20, 17, 0], [50, 20, 1], [50, 80, 0], [80, 19, 1]]",
    "output": "[50, 20, 80, 15, 17, 19]"
  },
  {
    "input": "descriptions = [[1, 2, 1], [1, 3, 0], [2, 4, 1]]",
    "output": "[1, 2, 3, 4]"
  },
  {
    "input": "descriptions = [[1, 2, 1]]",
    "output": "[1, 2]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar createBinaryTree = function(descriptions) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def createBinaryTree(self, descriptions: list[list[int]]) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* createBinaryTree(std::vector<std::vector<int>>& descriptions) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode createBinaryTree(int[][] descriptions) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "createBinaryTree",
  "params": [
    {
      "name": "descriptions",
      "type": "int[][]"
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
          [
            20,
            15,
            1
          ],
          [
            20,
            17,
            0
          ],
          [
            50,
            20,
            1
          ],
          [
            50,
            80,
            0
          ],
          [
            80,
            19,
            1
          ]
        ]
      ],
      "expected": [
        50,
        20,
        80,
        15,
        17,
        19
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
            3,
            0
          ],
          [
            2,
            4,
            1
          ]
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
          [
            1,
            2,
            1
          ]
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
        [
          5,
          6,
          1
        ]
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
        [
          1,
          2,
          0
        ],
        [
          1,
          3,
          1
        ],
        [
          2,
          4,
          1
        ],
        [
          3,
          5,
          0
        ]
      ]
    ],
    "expected": [
      1,
      3,
      2,
      null,
      5,
      4
    ]
  },
  {
    "args": [
      [
        [
          2,
          3,
          1
        ],
        [
          3,
          4,
          0
        ]
      ]
    ],
    "expected": [
      2,
      3,
      null,
      null,
      4
    ]
  },
  {
    "args": [
      [
        [
          10,
          5,
          1
        ],
        [
          10,
          7,
          0
        ],
        [
          5,
          3,
          1
        ],
        [
          7,
          9,
          0
        ]
      ]
    ],
    "expected": [
      10,
      5,
      7,
      3,
      null,
      null,
      9
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
          3,
          0
        ],
        [
          2,
          5,
          0
        ],
        [
          3,
          6,
          1
        ]
      ]
    ],
    "expected": [
      1,
      2,
      3,
      null,
      5,
      6
    ]
  },
  {
    "args": [
      [
        [
          8,
          4,
          1
        ],
        [
          8,
          12,
          0
        ],
        [
          4,
          2,
          0
        ],
        [
          12,
          10,
          1
        ]
      ]
    ],
    "expected": [
      8,
      4,
      12,
      null,
      2,
      10
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    2026,
    '统计值等于子树平均值的节点数',
    '给定二叉树的根节点 root
某个节点的子树平均值定义为该节点子树中所有节点值之和除以节点个数并向下取整
返回值等于其子树平均值的节点数目',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '二叉树'],
    $json$[
  {
    "input": "root = [4, 8, 5, 0, 1, null, 6]",
    "output": "5"
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
    "input": "root = [4, 8, 5, 0, 1, null, 6]",
    "output": "5"
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
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar countSubtreeAverageNodes = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def countSubtreeAverageNodes(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int countSubtreeAverageNodes(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int countSubtreeAverageNodes(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countSubtreeAverageNodes",
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
          8,
          5,
          0,
          1,
          null,
          6
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
        null,
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
        10,
        5,
        15,
        3,
        7,
        null,
        20
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
    "expected": 1
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
    "expected": 2
  },
  {
    "args": [
      [
        6,
        6,
        6
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    2027,
    '道路的最大总重要性',
    '给定城市数量 n 和道路列表 roads
第 i 个城市的编号为 i，每条道路连接两个城市
为每个城市分配一个 1 到 n 之间且互不相同的值
一条道路的重要性为它连接的两个城市的值之和
返回所有道路重要性之和的最大值',
    'medium',
    1000,
    256,
    ARRAY['贪心', '图', '排序'],
    $json$[
  {
    "input": "n = 5, roads = [[0, 1], [1, 2], [2, 3], [0, 2], [1, 3], [2, 4]]",
    "output": "43"
  },
  {
    "input": "n = 5, roads = [[0, 1], [0, 2], [0, 3], [0, 4]]",
    "output": "30"
  },
  {
    "input": "n = 2, roads = [[0, 1]]",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 5, roads = [[0, 1], [1, 2], [2, 3], [0, 2], [1, 3], [2, 4]]",
    "output": "43"
  },
  {
    "input": "n = 5, roads = [[0, 1], [0, 2], [0, 3], [0, 4]]",
    "output": "30"
  },
  {
    "input": "n = 2, roads = [[0, 1]]",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumImportance = function(n, roads) {\n};\n",
  "python": "class Solution:\n    def maximumImportance(self, n: int, roads: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long maximumImportance(int n, std::vector<std::vector<int>>& roads) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long maximumImportance(int n, int[][] roads) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumImportance",
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
  "return_type": "long",
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
            2
          ],
          [
            2,
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
            2,
            4
          ]
        ]
      ],
      "expected": 43
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
      "expected": 30
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
      "expected": 3
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
    "expected": 9
  },
  {
    "args": [
      1,
      []
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
    "expected": 23
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
          0
        ]
      ]
    ],
    "expected": 42
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
        ],
        [
          1,
          2
        ]
      ]
    ],
    "expected": 37
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
          3
        ]
      ]
    ],
    "expected": 17
  }
]$json$::jsonb,
    'approved'
),
(
    2028,
    '划分数组使最大差为 K',
    '给定整数数组 nums 和整数 k
把 nums 划分成若干个不相交的子序列
要求同一子序列中任意两个元素之差的绝对值都不大于 k
返回最少需要的子序列数目',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心', '排序'],
    $json$[
  {
    "input": "nums = [3, 6, 1, 2, 5], k = 2",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 3], k = 1",
    "output": "2"
  },
  {
    "input": "nums = [2, 2, 4, 5], k = 0",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 6, 1, 2, 5], k = 2",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 3], k = 1",
    "output": "2"
  },
  {
    "input": "nums = [2, 2, 4, 5], k = 0",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var partitionArray = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def partitionArray(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int partitionArray(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int partitionArray(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "partitionArray",
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
          6,
          1,
          2,
          5
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
      "expected": 2
    },
    {
      "args": [
        [
          2,
          2,
          4,
          5
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
      5
    ],
    "expected": 1
  },
  {
    "args": [
      [
        4,
        1,
        7,
        3
      ],
      3
    ],
    "expected": 2
  },
  {
    "args": [
      [
        5,
        5,
        5
      ],
      2
    ],
    "expected": 1
  },
  {
    "args": [
      [
        10,
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
        3,
        6,
        1,
        2,
        5
      ],
      10
    ],
    "expected": 1
  },
  {
    "args": [
      [
        1,
        100,
        101,
        102
      ],
      1
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    2029,
    '网格中的最小路径代价',
    '给定 m 行 n 列的网格 grid 和代价矩阵 moveCost
从第一行的任意格子出发，每步移动到下一行的一个格子
从 grid[i][j] 移动到 grid[i+1][k] 的代价为
moveCost[grid[i][j]][k] 加上 grid[i+1][k]
路径总代价还包括起点格子的值
返回到达最后一行的最小总代价',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '矩阵'],
    $json$[
  {
    "input": "grid = [[5, 3], [4, 0], [2, 1]], moveCost = [[9, 8], [1, 5], [10, 12], [18, 6], [2, 4], [14, 3]]",
    "output": "17"
  },
  {
    "input": "grid = [[1, 2], [3, 0]], moveCost = [[0, 1], [1, 0], [2, 2], [3, 3]]",
    "output": "1"
  },
  {
    "input": "grid = [[1, 1], [1, 1]], moveCost = [[0, 0], [0, 0], [0, 0], [0, 0]]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[5, 3], [4, 0], [2, 1]], moveCost = [[9, 8], [1, 5], [10, 12], [18, 6], [2, 4], [14, 3]]",
    "output": "17"
  },
  {
    "input": "grid = [[1, 2], [3, 0]], moveCost = [[0, 1], [1, 0], [2, 2], [3, 3]]",
    "output": "1"
  },
  {
    "input": "grid = [[1, 1], [1, 1]], moveCost = [[0, 0], [0, 0], [0, 0], [0, 0]]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minPathCost = function(grid, moveCost) {\n};\n",
  "python": "class Solution:\n    def minPathCost(self, grid: list[list[int]], moveCost: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minPathCost(std::vector<std::vector<int>>& grid, std::vector<std::vector<int>>& moveCost) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minPathCost(int[][] grid, int[][] moveCost) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minPathCost",
  "params": [
    {
      "name": "grid",
      "type": "int[][]"
    },
    {
      "name": "moveCost",
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
            3
          ],
          [
            4,
            0
          ],
          [
            2,
            1
          ]
        ],
        [
          [
            9,
            8
          ],
          [
            1,
            5
          ],
          [
            10,
            12
          ],
          [
            18,
            6
          ],
          [
            2,
            4
          ],
          [
            14,
            3
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
            2
          ],
          [
            3,
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
        ],
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
          2,
          3
        ],
        [
          4,
          5
        ],
        [
          6,
          7
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
        ],
        [
          2,
          3
        ],
        [
          3,
          2
        ],
        [
          4,
          0
        ],
        [
          5,
          0
        ],
        [
          6,
          0
        ],
        [
          7,
          0
        ]
      ]
    ],
    "expected": 15
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
          2
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
          5,
          1
        ],
        [
          2,
          8
        ],
        [
          3,
          4
        ]
      ],
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
          0,
          0
        ],
        [
          0,
          0
        ],
        [
          0,
          0
        ],
        [
          0,
          0
        ],
        [
          0,
          0
        ],
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
    "expected": 6
  },
  {
    "args": [
      [
        [
          9,
          2,
          5
        ],
        [
          1,
          7,
          3
        ]
      ],
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
        ],
        [
          9,
          10,
          11
        ],
        [
          12,
          13,
          14
        ],
        [
          15,
          16,
          17
        ],
        [
          18,
          19,
          20
        ],
        [
          21,
          22,
          23
        ],
        [
          24,
          25,
          26
        ],
        [
          27,
          28,
          29
        ]
      ]
    ],
    "expected": 9
  },
  {
    "args": [
      [
        [
          4,
          4
        ],
        [
          4,
          4
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
        ]
      ]
    ],
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    2030,
    '统计无向图中无法互相到达点对数',
    '给定无向图的节点数 n 和边列表 edges
节点编号为 0 到 n-1
统计无法互相到达的不同节点对 (a, b) 的数量，其中 a 小于 b
两个节点无法互相到达指它们之间不存在路径',
    'medium',
    1000,
    256,
    ARRAY['并查集', '图'],
    $json$[
  {
    "input": "n = 3, edges = [[0, 1]]",
    "output": "2"
  },
  {
    "input": "n = 7, edges = [[0, 2], [0, 5], [2, 4], [1, 6], [5, 4]]",
    "output": "14"
  },
  {
    "input": "n = 1, edges = []",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, edges = [[0, 1]]",
    "output": "2"
  },
  {
    "input": "n = 7, edges = [[0, 2], [0, 5], [2, 4], [1, 6], [5, 4]]",
    "output": "14"
  },
  {
    "input": "n = 1, edges = []",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countUnreachablePairs = function(n, edges) {\n};\n",
  "python": "class Solution:\n    def countUnreachablePairs(self, n: int, edges: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long countUnreachablePairs(int n, std::vector<std::vector<int>>& edges) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long countUnreachablePairs(int n, int[][] edges) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countUnreachablePairs",
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
  "return_type": "long",
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
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        7,
        [
          [
            0,
            2
          ],
          [
            0,
            5
          ],
          [
            2,
            4
          ],
          [
            1,
            6
          ],
          [
            5,
            4
          ]
        ]
      ],
      "expected": 14
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
      []
    ],
    "expected": 1
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
  },
  {
    "args": [
      6,
      []
    ],
    "expected": 15
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
          3
        ],
        [
          3,
          0
        ]
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      8,
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
    "expected": 22
  }
]$json$::jsonb,
    'approved'
),
(
    2031,
    '统计放置房子的方式数',
    '一条街道的两侧各有 n 块地，每块地可以空着或建一栋房子
同一侧不能有相邻的两块地都建房子
两侧的放置方案相互独立
返回在街道两侧放置房子的总方案数，结果对 10^9 + 7 取模',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '数学'],
    $json$[
  {
    "input": "n = 1",
    "output": "4"
  },
  {
    "input": "n = 2",
    "output": "9"
  },
  {
    "input": "n = 3",
    "output": "25"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 1",
    "output": "4"
  },
  {
    "input": "n = 2",
    "output": "9"
  },
  {
    "input": "n = 3",
    "output": "25"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countHousePlacements = function(n) {\n};\n",
  "python": "class Solution:\n    def countHousePlacements(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countHousePlacements(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countHousePlacements(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countHousePlacements",
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
      "expected": 4
    },
    {
      "args": [
        2
      ],
      "expected": 9
    },
    {
      "args": [
        3
      ],
      "expected": 25
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      4
    ],
    "expected": 64
  },
  {
    "args": [
      5
    ],
    "expected": 169
  },
  {
    "args": [
      10
    ],
    "expected": 20736
  },
  {
    "args": [
      20
    ],
    "expected": 313679521
  },
  {
    "args": [
      100
    ],
    "expected": 20522904
  },
  {
    "args": [
      1000
    ],
    "expected": 500478595
  }
]$json$::jsonb,
    'approved'
),
(
    2032,
    '知道秘密的人数',
    '从第 1 天起，第 0 个人知道一个秘密
每天开始时，每个已经知道秘密至少 delay 天的人会把这个秘密告诉一个新的人
每个知道秘密的人在知道后的第 forget 天开始时忘记秘密
返回第 n 天结束时知道秘密的人数，结果对 10^9 + 7 取模',
    'medium',
    1000,
    256,
    ARRAY['动态规划', '队列'],
    $json$[
  {
    "input": "n = 6, delay = 2, forget = 4",
    "output": "5"
  },
  {
    "input": "n = 4, delay = 1, forget = 3",
    "output": "6"
  },
  {
    "input": "n = 1, delay = 1, forget = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 6, delay = 2, forget = 4",
    "output": "5"
  },
  {
    "input": "n = 4, delay = 1, forget = 3",
    "output": "6"
  },
  {
    "input": "n = 1, delay = 1, forget = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var peopleAwareOfSecret = function(n, delay, forget) {\n};\n",
  "python": "class Solution:\n    def peopleAwareOfSecret(self, n: int, delay: int, forget: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int peopleAwareOfSecret(int n, int delay, int forget) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int peopleAwareOfSecret(int n, int delay, int forget) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "peopleAwareOfSecret",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "delay",
      "type": "int"
    },
    {
      "name": "forget",
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
        2,
        4
      ],
      "expected": 5
    },
    {
      "args": [
        4,
        1,
        3
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
      5,
      1,
      2
    ],
    "expected": 2
  },
  {
    "args": [
      6,
      1,
      3
    ],
    "expected": 16
  },
  {
    "args": [
      10,
      2,
      5
    ],
    "expected": 30
  },
  {
    "args": [
      7,
      1,
      4
    ],
    "expected": 48
  },
  {
    "args": [
      8,
      3,
      5
    ],
    "expected": 5
  },
  {
    "args": [
      20,
      3,
      7
    ],
    "expected": 361
  }
]$json$::jsonb,
    'approved'
),
(
    2033,
    '找到离给定两个节点最近的节点',
    '给定有向图，节点 i 至多有一条出边，edges[i] 表示节点 i 的出边终点
若 edges[i] 等于 -1 则表示没有出边
给定两个起点 node1 和 node2
找到同时能从两个起点到达的节点中
到两个起点距离的较大值最小的节点
若存在多个这样的节点，返回编号最小的那个
若不存在同时可达的节点，返回 -1',
    'medium',
    1000,
    256,
    ARRAY['图', '深度优先搜索'],
    $json$[
  {
    "input": "edges = [2, 2, 3, -1], node1 = 0, node2 = 1",
    "output": "2"
  },
  {
    "input": "edges = [1, 2, -1], node1 = 0, node2 = 2",
    "output": "2"
  },
  {
    "input": "edges = [2, -1, 3, -1], node1 = 0, node2 = 1",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "edges = [2, 2, 3, -1], node1 = 0, node2 = 1",
    "output": "2"
  },
  {
    "input": "edges = [1, 2, -1], node1 = 0, node2 = 2",
    "output": "2"
  },
  {
    "input": "edges = [2, -1, 3, -1], node1 = 0, node2 = 1",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var closestMeetingNode = function(edges, node1, node2) {\n};\n",
  "python": "class Solution:\n    def closestMeetingNode(self, edges: list[int], node1: int, node2: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int closestMeetingNode(std::vector<int>& edges, int node1, int node2) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int closestMeetingNode(int[] edges, int node1, int node2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "closestMeetingNode",
  "params": [
    {
      "name": "edges",
      "type": "int[]"
    },
    {
      "name": "node1",
      "type": "int"
    },
    {
      "name": "node2",
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
          2,
          3,
          -1
        ],
        0,
        1
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1,
          2,
          -1
        ],
        0,
        2
      ],
      "expected": 2
    },
    {
      "args": [
        [
          2,
          -1,
          3,
          -1
        ],
        0,
        1
      ],
      "expected": -1
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
        -1
      ],
      0,
      3
    ],
    "expected": 3
  },
  {
    "args": [
      [
        -1,
        -1
      ],
      0,
      1
    ],
    "expected": -1
  },
  {
    "args": [
      [
        1,
        -1,
        1,
        -1
      ],
      0,
      2
    ],
    "expected": 1
  },
  {
    "args": [
      [
        3,
        3,
        -1,
        1
      ],
      0,
      3
    ],
    "expected": 3
  },
  {
    "args": [
      [
        2,
        3,
        -1,
        2
      ],
      0,
      1
    ],
    "expected": 2
  },
  {
    "args": [
      [
        1,
        0
      ],
      0,
      1
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    2034,
    '受限条件下可到达节点的数目',
    '给定无向图的节点数 n 和边列表 edges
节点编号为 0 到 n-1
给定受限节点列表 restricted，这些节点不能访问
从节点 0 出发，返回能够到达的不同节点数目（包括节点 0）
题目保证节点 0 不在 restricted 中',
    'medium',
    1000,
    256,
    ARRAY['图', '广度优先搜索', '哈希表'],
    $json$[
  {
    "input": "n = 7, edges = [[0, 1], [1, 2], [3, 1], [3, 4], [0, 5], [5, 6]], restricted = [4, 5]",
    "output": "4"
  },
  {
    "input": "n = 7, edges = [[0, 1], [0, 2], [0, 5], [0, 4], [3, 2], [1, 3]], restricted = [3, 5]",
    "output": "4"
  },
  {
    "input": "n = 1, edges = [], restricted = []",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 7, edges = [[0, 1], [1, 2], [3, 1], [3, 4], [0, 5], [5, 6]], restricted = [4, 5]",
    "output": "4"
  },
  {
    "input": "n = 7, edges = [[0, 1], [0, 2], [0, 5], [0, 4], [3, 2], [1, 3]], restricted = [3, 5]",
    "output": "4"
  },
  {
    "input": "n = 1, edges = [], restricted = []",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var reachableNodes = function(n, edges, restricted) {\n};\n",
  "python": "class Solution:\n    def reachableNodes(self, n: int, edges: list[list[int]], restricted: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int reachableNodes(int n, std::vector<std::vector<int>>& edges, std::vector<int>& restricted) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int reachableNodes(int n, int[][] edges, int[] restricted) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reachableNodes",
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
      "name": "restricted",
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
            1
          ],
          [
            3,
            4
          ],
          [
            0,
            5
          ],
          [
            5,
            6
          ]
        ],
        [
          4,
          5
        ]
      ],
      "expected": 4
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
            0,
            2
          ],
          [
            0,
            5
          ],
          [
            0,
            4
          ],
          [
            3,
            2
          ],
          [
            1,
            3
          ]
        ],
        [
          3,
          5
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        1,
        [],
        []
      ],
      "expected": 1
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
      ],
      [
        1
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
        ]
      ],
      []
    ],
    "expected": 5
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
      ],
      [
        2,
        4
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      4,
      [],
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
      8,
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
          4,
          5
        ],
        [
          5,
          6
        ],
        [
          6,
          7
        ]
      ],
      [
        3,
        6
      ]
    ],
    "expected": 5
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
      ],
      [
        4
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    2035,
    '最长理想子序列',
    '给定由小写字母组成的字符串 s 和整数 k
理想字符串指相邻两个字符在字母表中的绝对差不超过 k
求 s 的最长理想子序列长度
子序列从 s 中删除若干字符得到，不改变剩余字符的相对顺序',
    'medium',
    1000,
    256,
    ARRAY['字符串', '动态规划', '哈希表'],
    $json$[
  {
    "input": "s = \"acfgbd\", k = 2",
    "output": "4"
  },
  {
    "input": "s = \"abcd\", k = 3",
    "output": "4"
  },
  {
    "input": "s = \"a\", k = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"acfgbd\", k = 2",
    "output": "4"
  },
  {
    "input": "s = \"abcd\", k = 3",
    "output": "4"
  },
  {
    "input": "s = \"a\", k = 0",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestIdealString = function(s, k) {\n};\n",
  "python": "class Solution:\n    def longestIdealString(self, s: str, k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestIdealString(std::string s, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestIdealString(String s, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestIdealString",
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
        "acfgbd",
        2
      ],
      "expected": 4
    },
    {
      "args": [
        "abcd",
        3
      ],
      "expected": 4
    },
    {
      "args": [
        "a",
        0
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "ab",
      1
    ],
    "expected": 2
  },
  {
    "args": [
      "az",
      1
    ],
    "expected": 1
  },
  {
    "args": [
      "abcabc",
      2
    ],
    "expected": 6
  },
  {
    "args": [
      "eduktdb",
      15
    ],
    "expected": 5
  },
  {
    "args": [
      "zzzz",
      0
    ],
    "expected": 4
  },
  {
    "args": [
      "ba",
      0
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    2036,
    '感染二叉树需要的总时间',
    '给定二叉树的根节点 root 和一个节点值 start
从值为 start 的节点开始，每一分钟感染会传播到相邻的节点
节点值互不相同
返回整棵树都被感染需要经过的分钟数',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '广度优先搜索'],
    $json$[
  {
    "input": "root = [1, 5, 3, null, 4, 10, 6, 9, 2], start = 3",
    "output": "4"
  },
  {
    "input": "root = [1], start = 1",
    "output": "0"
  },
  {
    "input": "root = [1, 2, 3], start = 2",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 5, 3, null, 4, 10, 6, 9, 2], start = 3",
    "output": "4"
  },
  {
    "input": "root = [1], start = 1",
    "output": "0"
  },
  {
    "input": "root = [1, 2, 3], start = 2",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar amountOfTime = function(root, start) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def amountOfTime(self, root: TreeNode | None, start: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int amountOfTime(TreeNode* root, int start) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int amountOfTime(TreeNode root, int start) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "amountOfTime",
  "params": [
    {
      "name": "root",
      "type": "TreeNode"
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
          5,
          3,
          null,
          4,
          10,
          6,
          9,
          2
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
      "expected": 2
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
      2
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
        null,
        6
      ],
      4
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
        7
      ],
      7
    ],
    "expected": 4
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
      ],
      4
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
      1
    ],
    "expected": 1
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
      2
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    2037,
    '被列覆盖的最多行数',
    '给定 m 行 n 列的二进制矩阵 matrix 和整数 numSelect
选择恰好 numSelect 列
若某一行中所有值为 1 的格子所在的列都被选中，则该行被覆盖
返回最多能覆盖的行数',
    'medium',
    1000,
    256,
    ARRAY['数组', '回溯', '位运算'],
    $json$[
  {
    "input": "matrix = [[0, 0, 0], [1, 0, 1], [0, 1, 1], [0, 0, 1]], numSelect = 2",
    "output": "3"
  },
  {
    "input": "matrix = [[1], [0]], numSelect = 1",
    "output": "2"
  },
  {
    "input": "matrix = [[1, 0], [0, 1]], numSelect = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "matrix = [[0, 0, 0], [1, 0, 1], [0, 1, 1], [0, 0, 1]], numSelect = 2",
    "output": "3"
  },
  {
    "input": "matrix = [[1], [0]], numSelect = 1",
    "output": "2"
  },
  {
    "input": "matrix = [[1, 0], [0, 1]], numSelect = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumRows = function(matrix, numSelect) {\n};\n",
  "python": "class Solution:\n    def maximumRows(self, matrix: list[list[int]], numSelect: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumRows(std::vector<std::vector<int>>& matrix, int numSelect) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumRows(int[][] matrix, int numSelect) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumRows",
  "params": [
    {
      "name": "matrix",
      "type": "int[][]"
    },
    {
      "name": "numSelect",
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
            0,
            1
          ]
        ],
        2
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
            0
          ],
          [
            0,
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
          1,
          1
        ],
        [
          1,
          0
        ],
        [
          0,
          1
        ]
      ],
      2
    ],
    "expected": 3
  },
  {
    "args": [
      [
        [
          0
        ]
      ],
      0
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
        ]
      ],
      2
    ],
    "expected": 0
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
          1,
          0,
          1,
          0
        ]
      ],
      2
    ],
    "expected": 1
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
          1
        ],
        [
          1,
          1,
          1
        ]
      ],
      2
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    2038,
    '反转二叉树的奇数层',
    '给定一棵二叉树的根节点 root
根节点位于第 0 层
对每个奇数层，反转该层所有节点的值
返回处理后的树（按层序序列化输出）',
    'medium',
    1000,
    256,
    ARRAY['树', '广度优先搜索', '二叉树'],
    $json$[
  {
    "input": "root = [2, 3, 5, 8, 13, 21, 34]",
    "output": "[2, 5, 3, 8, 13, 21, 34]"
  },
  {
    "input": "root = [7, 13, 11]",
    "output": "[7, 11, 13]"
  },
  {
    "input": "root = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [2, 3, 5, 8, 13, 21, 34]",
    "output": "[2, 5, 3, 8, 13, 21, 34]"
  },
  {
    "input": "root = [7, 13, 11]",
    "output": "[7, 11, 13]"
  },
  {
    "input": "root = [1]",
    "output": "[1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar reverseOddLevels = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def reverseOddLevels(self, root: TreeNode | None) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* reverseOddLevels(TreeNode* root) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode reverseOddLevels(TreeNode root) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reverseOddLevels",
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
          2,
          3,
          5,
          8,
          13,
          21,
          34
        ]
      ],
      "expected": [
        2,
        5,
        3,
        8,
        13,
        21,
        34
      ]
    },
    {
      "args": [
        [
          7,
          13,
          11
        ]
      ],
      "expected": [
        7,
        11,
        13
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
        5,
        6,
        7
      ]
    ],
    "expected": [
      1,
      3,
      2,
      4,
      5,
      6,
      7
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
        14
      ]
    ],
    "expected": [
      0,
      2,
      1,
      3,
      4,
      5,
      6,
      14,
      13,
      12,
      11,
      10,
      9,
      8,
      7
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
        null,
        4
      ]
    ],
    "expected": [
      1,
      3,
      2,
      null,
      4
    ]
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
    "expected": [
      5,
      8,
      3,
      1,
      4,
      7,
      9
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    2039,
    '树上最大得分',
    '给定一棵以节点 0 为根的树，边列表为 edges，每个节点的得分为 amount
Alice 从节点 0 出发，沿树向下走到任意叶子节点
Bob 从节点 bob 出发，沿唯一路径走到节点 0
两人每个时间单位移动一条边
节点被 Alice 先到则 Alice 获得该节点得分
节点被 Bob 先到则 Alice 得不到该节点得分
两人同时到达则 Alice 获得该节点得分的一半并向下取整
返回 Alice 可能获得的最大总分',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '动态规划'],
    $json$[
  {
    "input": "edges = [[0, 1], [1, 2], [1, 3], [3, 4]], bob = 3, amount = [-2, 4, 2, -4, 6]",
    "output": "6"
  },
  {
    "input": "edges = [[0, 1]], bob = 1, amount = [-1, 2]",
    "output": "-1"
  },
  {
    "input": "edges = [[0, 1], [1, 2]], bob = 2, amount = [-2, 1, 3]",
    "output": "-2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "edges = [[0, 1], [1, 2], [1, 3], [3, 4]], bob = 3, amount = [-2, 4, 2, -4, 6]",
    "output": "6"
  },
  {
    "input": "edges = [[0, 1]], bob = 1, amount = [-1, 2]",
    "output": "-1"
  },
  {
    "input": "edges = [[0, 1], [1, 2]], bob = 2, amount = [-2, 1, 3]",
    "output": "-2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var mostProfitablePath = function(edges, bob, amount) {\n};\n",
  "python": "class Solution:\n    def mostProfitablePath(self, edges: list[list[int]], bob: int, amount: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int mostProfitablePath(std::vector<std::vector<int>>& edges, int bob, std::vector<int>& amount) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int mostProfitablePath(int[][] edges, int bob, int[] amount) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "mostProfitablePath",
  "params": [
    {
      "name": "edges",
      "type": "int[][]"
    },
    {
      "name": "bob",
      "type": "int"
    },
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
          [
            0,
            1
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
            3,
            4
          ]
        ],
        3,
        [
          -2,
          4,
          2,
          -4,
          6
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          [
            0,
            1
          ]
        ],
        1,
        [
          -1,
          2
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
            2
          ]
        ],
        2,
        [
          -2,
          1,
          3
        ]
      ],
      "expected": -2
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
        ]
      ],
      0,
      [
        5,
        7
      ]
    ],
    "expected": 9
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
          2
        ]
      ],
      1,
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
      3,
      [
        5,
        5,
        5,
        5
      ]
    ],
    "expected": 10
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
          2
        ],
        [
          2,
          3
        ],
        [
          2,
          4
        ]
      ],
      4,
      [
        3,
        6,
        2,
        1,
        5
      ]
    ],
    "expected": 9
  },
  {
    "args": [
      [
        [
          0,
          1
        ]
      ],
      1,
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
        [
          0,
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
      ],
      1,
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
    2040,
    '逐层排序二叉树所需的最少操作数目',
    '给定二叉树的根节点 root
每一层可以独立进行任意次交换任意两个节点值的操作
求使每一层的节点值都严格递增所需的最少交换次数之和',
    'medium',
    1000,
    256,
    ARRAY['树', '广度优先搜索', '排序'],
    $json$[
  {
    "input": "root = [1, 3, 2, 7, 6, 5, 4]",
    "output": "3"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "0"
  },
  {
    "input": "root = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [1, 3, 2, 7, 6, 5, 4]",
    "output": "3"
  },
  {
    "input": "root = [1, 2, 3]",
    "output": "0"
  },
  {
    "input": "root = [1]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar minimumLevelSortOperations = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def minimumLevelSortOperations(self, root: TreeNode | None) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    int minimumLevelSortOperations(TreeNode* root) {\n        return 0;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public int minimumLevelSortOperations(TreeNode root) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumLevelSortOperations",
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
          3,
          2,
          7,
          6,
          5,
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
        7,
        6,
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
        1,
        2,
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
        2,
        1,
        3,
        6,
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
        4,
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
    2041,
    '到达首都的最少油耗',
    '给定一棵有 n 个节点的树，节点 0 是首都，roads 为边列表
每个节点住着一个人，所有人都要前往首都
每个城市有一辆车，可以容纳 seats 人，所有人可以任意拼车
每辆车每经过一条边消耗 1 升油
返回所有人到达首都所需的最少总油耗',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '贪心'],
    $json$[
  {
    "input": "roads = [[0, 1], [0, 2], [0, 3]], seats = 5",
    "output": "3"
  },
  {
    "input": "roads = [[3, 1], [3, 2], [1, 0], [0, 4], [0, 5], [4, 6]], seats = 2",
    "output": "7"
  },
  {
    "input": "roads = [[0, 1]], seats = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "roads = [[0, 1], [0, 2], [0, 3]], seats = 5",
    "output": "3"
  },
  {
    "input": "roads = [[3, 1], [3, 2], [1, 0], [0, 4], [0, 5], [4, 6]], seats = 2",
    "output": "7"
  },
  {
    "input": "roads = [[0, 1]], seats = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumFuelCost = function(roads, seats) {\n};\n",
  "python": "class Solution:\n    def minimumFuelCost(self, roads: list[list[int]], seats: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long minimumFuelCost(std::vector<std::vector<int>>& roads, int seats) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long minimumFuelCost(int[][] roads, int seats) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumFuelCost",
  "params": [
    {
      "name": "roads",
      "type": "int[][]"
    },
    {
      "name": "seats",
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
        ],
        5
      ],
      "expected": 3
    },
    {
      "args": [
        [
          [
            3,
            1
          ],
          [
            3,
            2
          ],
          [
            1,
            0
          ],
          [
            0,
            4
          ],
          [
            0,
            5
          ],
          [
            4,
            6
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
            0,
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
          0,
          1
        ],
        [
          1,
          2
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
          0,
          1
        ],
        [
          0,
          2
        ]
      ],
      3
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
          1,
          2
        ],
        [
          1,
          3
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
      ],
      2
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
      ],
      3
    ],
    "expected": 7
  },
  {
    "args": [
      [
        [
          0,
          1
        ]
      ],
      100
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    2042,
    '两个城市间路径的最小分数',
    '给定城市数量 n 和道路列表 roads
每项为 [城市 a, 城市 b, 道路分数]
一条路径的分数为路径上所有道路分数的最小值
路径可以重复经过城市和道路
题目保证城市 1 和城市 n 连通
返回城市 1 到城市 n 之间路径分数的最小可能值',
    'medium',
    1000,
    256,
    ARRAY['图', '并查集', '深度优先搜索'],
    $json$[
  {
    "input": "n = 4, roads = [[1, 2, 9], [2, 3, 6], [2, 4, 5], [1, 4, 7]]",
    "output": "5"
  },
  {
    "input": "n = 4, roads = [[1, 2, 2], [1, 3, 4], [3, 4, 7]]",
    "output": "2"
  },
  {
    "input": "n = 2, roads = [[1, 2, 5]]",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4, roads = [[1, 2, 9], [2, 3, 6], [2, 4, 5], [1, 4, 7]]",
    "output": "5"
  },
  {
    "input": "n = 4, roads = [[1, 2, 2], [1, 3, 4], [3, 4, 7]]",
    "output": "2"
  },
  {
    "input": "n = 2, roads = [[1, 2, 5]]",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minScore = function(n, roads) {\n};\n",
  "python": "class Solution:\n    def minScore(self, n: int, roads: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minScore(int n, std::vector<std::vector<int>>& roads) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minScore(int n, int[][] roads) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minScore",
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
            1,
            2,
            9
          ],
          [
            2,
            3,
            6
          ],
          [
            2,
            4,
            5
          ],
          [
            1,
            4,
            7
          ]
        ]
      ],
      "expected": 5
    },
    {
      "args": [
        4,
        [
          [
            1,
            2,
            2
          ],
          [
            1,
            3,
            4
          ],
          [
            3,
            4,
            7
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        2,
        [
          [
            1,
            2,
            5
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
      5,
      [
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
        ],
        [
          4,
          5,
          6
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
          2,
          1
        ],
        [
          2,
          3,
          1
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
          1,
          2,
          10
        ],
        [
          2,
          3,
          1
        ],
        [
          3,
          1,
          5
        ],
        [
          3,
          4,
          2
        ],
        [
          4,
          5,
          3
        ],
        [
          5,
          6,
          4
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
          1,
          2,
          8
        ],
        [
          2,
          3,
          8
        ],
        [
          3,
          4,
          8
        ],
        [
          1,
          4,
          8
        ]
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
          2,
          100
        ],
        [
          2,
          3,
          50
        ],
        [
          3,
          4,
          25
        ],
        [
          4,
          5,
          12
        ],
        [
          1,
          5,
          200
        ]
      ]
    ],
    "expected": 12
  },
  {
    "args": [
      2,
      [
        [
          1,
          2,
          100000
        ]
      ]
    ],
    "expected": 100000
  }
]$json$::jsonb,
    'approved'
),
(
    2043,
    '图中最大星和',
    '给定无向图的节点权重 values 和边列表 edges
节点编号为 0 到 n-1
以某个节点为中心可以选取它和至多 k 个邻居组成星形子图
星形子图的值为所选所有节点的权重之和
返回所有可能的星形子图中的最大权重和',
    'medium',
    1000,
    256,
    ARRAY['图', '贪心', '排序'],
    $json$[
  {
    "input": "values = [1, 2, 3, 4, 10, -10, -20], edges = [[0, 1], [1, 2], [1, 3], [3, 4], [3, 5], [3, 6]], k = 2",
    "output": "16"
  },
  {
    "input": "values = [-1], edges = [], k = 0",
    "output": "-1"
  },
  {
    "input": "values = [1, 2, 3, 4], edges = [[0, 1], [1, 2], [2, 3]], k = 1",
    "output": "7"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "values = [1, 2, 3, 4, 10, -10, -20], edges = [[0, 1], [1, 2], [1, 3], [3, 4], [3, 5], [3, 6]], k = 2",
    "output": "16"
  },
  {
    "input": "values = [-1], edges = [], k = 0",
    "output": "-1"
  },
  {
    "input": "values = [1, 2, 3, 4], edges = [[0, 1], [1, 2], [2, 3]], k = 1",
    "output": "7"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxStarSum = function(values, edges, k) {\n};\n",
  "python": "class Solution:\n    def maxStarSum(self, values: list[int], edges: list[list[int]], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxStarSum(std::vector<int>& values, std::vector<std::vector<int>>& edges, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxStarSum(int[] values, int[][] edges, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxStarSum",
  "params": [
    {
      "name": "values",
      "type": "int[]"
    },
    {
      "name": "edges",
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
          1,
          2,
          3,
          4,
          10,
          -10,
          -20
        ],
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
            1,
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
            3,
            6
          ]
        ],
        2
      ],
      "expected": 16
    },
    {
      "args": [
        [
          -1
        ],
        [],
        0
      ],
      "expected": -1
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
        1
      ],
      "expected": 7
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        5,
        1,
        1
      ],
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
      2
    ],
    "expected": 7
  },
  {
    "args": [
      [
        1,
        2,
        3
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
      ],
      0
    ],
    "expected": 3
  },
  {
    "args": [
      [
        -5,
        -3,
        -1
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
      ],
      2
    ],
    "expected": -1
  },
  {
    "args": [
      [
        4,
        5,
        6
      ],
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
      ],
      1
    ],
    "expected": 11
  },
  {
    "args": [
      [
        0,
        10,
        20,
        30
      ],
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
      2
    ],
    "expected": 60
  },
  {
    "args": [
      [
        5,
        -2,
        -3
      ],
      [],
      1
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    2044,
    '数组中最长的方波',
    '给定整数数组 nums
方波是数组的一个子序列，且除第一个元素外每个元素都等于前一个元素的平方
求 nums 中最长方波的长度
若最长方波长度小于 2，返回 -1',
    'medium',
    1000,
    256,
    ARRAY['数组', '哈希表', '动态规划'],
    $json$[
  {
    "input": "nums = [4, 3, 6, 16, 8, 2]",
    "output": "3"
  },
  {
    "input": "nums = [2, 3, 5]",
    "output": "-1"
  },
  {
    "input": "nums = [2, 4]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [4, 3, 6, 16, 8, 2]",
    "output": "3"
  },
  {
    "input": "nums = [2, 3, 5]",
    "output": "-1"
  },
  {
    "input": "nums = [2, 4]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestSquareStreak = function(nums) {\n};\n",
  "python": "class Solution:\n    def longestSquareStreak(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestSquareStreak(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestSquareStreak(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestSquareStreak",
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
          3,
          6,
          16,
          8,
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
          5
        ]
      ],
      "expected": -1
    },
    {
      "args": [
        [
          2,
          4
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
    "expected": -1
  },
  {
    "args": [
      [
        1,
        2,
        4,
        16
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        3,
        9,
        81
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        2,
        4,
        16,
        256
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        4,
        16,
        2
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        9,
        3,
        81,
        6561
      ]
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    2045,
    '最小化数组中的最大值',
    '给定下标从 0 开始的非负整数数组 nums
可以执行任意次以下操作
选择下标 i 大于 0，把 nums[i] 减 1，并把 nums[i-1] 加 1
返回操作后数组最大值的最小可能值',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找', '贪心'],
    $json$[
  {
    "input": "nums = [3, 7, 1, 6]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "3"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 7, 1, 6]",
    "output": "5"
  },
  {
    "input": "nums = [1, 2, 3, 4]",
    "output": "3"
  },
  {
    "input": "nums = [1]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimizeArrayValue = function(nums) {\n};\n",
  "python": "class Solution:\n    def minimizeArrayValue(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimizeArrayValue(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimizeArrayValue(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimizeArrayValue",
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
          7,
          1,
          6
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
        1
      ]
    ],
    "expected": 10
  },
  {
    "args": [
      [
        5,
        0,
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
        7,
        1,
        6,
        8
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
    "expected": 3
  },
  {
    "args": [
      [
        7,
        1,
        1,
        1,
        1
      ]
    ],
    "expected": 7
  }
]$json$::jsonb,
    'approved'
),
(
    2046,
    '将整数减少到零需要的最少操作数',
    '给定正整数 n
每次操作可以选择一个 2 的幂，把它加到 n 上或从 n 中减去
返回把 n 变成 0 所需的最少操作次数',
    'medium',
    1000,
    256,
    ARRAY['贪心', '位运算', '动态规划'],
    $json$[
  {
    "input": "n = 39",
    "output": "3"
  },
  {
    "input": "n = 54",
    "output": "3"
  },
  {
    "input": "n = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 39",
    "output": "3"
  },
  {
    "input": "n = 54",
    "output": "3"
  },
  {
    "input": "n = 1",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minOperationsToZero = function(n) {\n};\n",
  "python": "class Solution:\n    def minOperationsToZero(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minOperationsToZero(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minOperationsToZero(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minOperationsToZero",
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
        39
      ],
      "expected": 3
    },
    {
      "args": [
        54
      ],
      "expected": 3
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
      7
    ],
    "expected": 2
  },
  {
    "args": [
      13
    ],
    "expected": 3
  },
  {
    "args": [
      100
    ],
    "expected": 3
  },
  {
    "args": [
      1000
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    2047,
    '解决智力问题',
    '给定二维数组 questions，每项为 [得分, 跳过题数]
按顺序处理题目，选择第 i 题可以获得 questions[i][0] 分
但必须跳过接下来的 questions[i][1] 道题
也可以不选择第 i 题，直接处理下一题
返回能获得的最大总分',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划'],
    $json$[
  {
    "input": "questions = [[3, 2], [4, 3], [4, 4], [2, 5]]",
    "output": "5"
  },
  {
    "input": "questions = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]]",
    "output": "7"
  },
  {
    "input": "questions = [[1, 1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "questions = [[3, 2], [4, 3], [4, 4], [2, 5]]",
    "output": "5"
  },
  {
    "input": "questions = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]]",
    "output": "7"
  },
  {
    "input": "questions = [[1, 1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var mostPoints = function(questions) {\n};\n",
  "python": "class Solution:\n    def mostPoints(self, questions: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long mostPoints(std::vector<std::vector<int>>& questions) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long mostPoints(int[][] questions) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "mostPoints",
  "params": [
    {
      "name": "questions",
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
            3,
            2
          ],
          [
            4,
            3
          ],
          [
            4,
            4
          ],
          [
            2,
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
            2,
            2
          ],
          [
            3,
            3
          ],
          [
            4,
            4
          ],
          [
            5,
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
          2,
          0
        ],
        [
          3,
          0
        ]
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        [
          5,
          10
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
          2
        ],
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
          10,
          1
        ],
        [
          1,
          1
        ],
        [
          10,
          1
        ],
        [
          1,
          1
        ]
      ]
    ],
    "expected": 20
  },
  {
    "args": [
      [
        [
          4,
          0
        ],
        [
          3,
          0
        ],
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
    "expected": 10
  },
  {
    "args": [
      [
        [
          7,
          3
        ],
        [
          8,
          0
        ],
        [
          9,
          0
        ],
        [
          10,
          0
        ],
        [
          11,
          0
        ],
        [
          12,
          0
        ]
      ]
    ],
    "expected": 50
  }
]$json$::jsonb,
    'approved'
),
(
    2048,
    '美丽子集的数目',
    '给定整数数组 nums 和正整数 k
数组的子集是美丽的，当且仅当子集中不存在两个元素的差的绝对值等于 k
相同数值出现在不同下标视为不同元素
返回非空美丽子集的数目，结果对 10^9 + 7 取模',
    'medium',
    1000,
    256,
    ARRAY['数组', '回溯', '动态规划'],
    $json$[
  {
    "input": "nums = [2, 4, 6], k = 2",
    "output": "4"
  },
  {
    "input": "nums = [1], k = 1",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3, 4], k = 1",
    "output": "7"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 4, 6], k = 2",
    "output": "4"
  },
  {
    "input": "nums = [1], k = 1",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3, 4], k = 1",
    "output": "7"
  }
]$json$::jsonb,
    $json${
  "javascript": "var beautifulSubsets = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def beautifulSubsets(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int beautifulSubsets(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int beautifulSubsets(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "beautifulSubsets",
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
          2,
          4,
          6
        ],
        2
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
          1,
          2,
          3,
          4
        ],
        1
      ],
      "expected": 7
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        1,
        3
      ],
      1
    ],
    "expected": 3
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
        2,
        4,
        6,
        8
      ],
      2
    ],
    "expected": 7
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
    "expected": 7
  },
  {
    "args": [
      [
        4,
        2,
        5
      ],
      1
    ],
    "expected": 5
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
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    2049,
    '老鼠和奶酪',
    '给定两个长度相同的数组 reward1 和 reward2，以及整数 k
第 i 块奶酪被第一只老鼠吃掉得到 reward1[i] 分
被第二只老鼠吃掉得到 reward2[i] 分
第一只老鼠必须吃恰好 k 块奶酪，第二只老鼠吃掉剩下的所有奶酪
每块奶酪只能被一只老鼠吃掉
返回能获得的最大总分数',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心', '排序'],
    $json$[
  {
    "input": "reward1 = [1, 1, 3, 4], reward2 = [4, 4, 1, 1], k = 2",
    "output": "15"
  },
  {
    "input": "reward1 = [1, 1], reward2 = [1, 1], k = 2",
    "output": "2"
  },
  {
    "input": "reward1 = [1, 1], reward2 = [1, 1], k = 0",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "reward1 = [1, 1, 3, 4], reward2 = [4, 4, 1, 1], k = 2",
    "output": "15"
  },
  {
    "input": "reward1 = [1, 1], reward2 = [1, 1], k = 2",
    "output": "2"
  },
  {
    "input": "reward1 = [1, 1], reward2 = [1, 1], k = 0",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var miceAndCheese = function(reward1, reward2, k) {\n};\n",
  "python": "class Solution:\n    def miceAndCheese(self, reward1: list[int], reward2: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int miceAndCheese(std::vector<int>& reward1, std::vector<int>& reward2, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int miceAndCheese(int[] reward1, int[] reward2, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "miceAndCheese",
  "params": [
    {
      "name": "reward1",
      "type": "int[]"
    },
    {
      "name": "reward2",
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
          3,
          4
        ],
        [
          4,
          4,
          1,
          1
        ],
        2
      ],
      "expected": 15
    },
    {
      "args": [
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
        [
          1,
          1
        ],
        [
          1,
          1
        ],
        0
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
        5
      ],
      [
        3,
        8
      ],
      1
    ],
    "expected": 10
  },
  {
    "args": [
      [
        3,
        1,
        4
      ],
      [
        1,
        5,
        9
      ],
      2
    ],
    "expected": 13
  },
  {
    "args": [
      [
        10
      ],
      [
        20
      ],
      0
    ],
    "expected": 20
  },
  {
    "args": [
      [
        10
      ],
      [
        20
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
        4
      ],
      [
        4,
        3,
        2,
        1
      ],
      2
    ],
    "expected": 14
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
      ],
      3
    ],
    "expected": 15
  }
]$json$::jsonb,
    'approved'
),
(
    2050,
    '二叉树的堂兄弟节点 II',
    '给定二叉树的根节点 root
两个节点互为堂兄弟，当且仅当它们深度相同但父节点不同
把每个节点的值替换为它的所有堂兄弟节点值之和
返回处理后的树（按层序序列化输出）',
    'medium',
    1000,
    256,
    ARRAY['树', '广度优先搜索', '二叉树'],
    $json$[
  {
    "input": "root = [5, 4, 9, 1, 10, null, 7]",
    "output": "[0, 0, 0, 7, 7, null, 11]"
  },
  {
    "input": "root = [3, 1, 2]",
    "output": "[0, 0, 0]"
  },
  {
    "input": "root = [1]",
    "output": "[0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "root = [5, 4, 9, 1, 10, null, 7]",
    "output": "[0, 0, 0, 7, 7, null, 11]"
  },
  {
    "input": "root = [3, 1, 2]",
    "output": "[0, 0, 0]"
  },
  {
    "input": "root = [1]",
    "output": "[0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar replaceValueInTree = function(root) {\n};\n",
  "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def replaceValueInTree(self, root: TreeNode | None) -> TreeNode | None:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\n\nclass Solution {\npublic:\n    TreeNode* replaceValueInTree(TreeNode* root) {\n        return nullptr;\n    }\n};\n",
  "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public TreeNode replaceValueInTree(TreeNode root) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "replaceValueInTree",
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
          4,
          9,
          1,
          10,
          null,
          7
        ]
      ],
      "expected": [
        0,
        0,
        0,
        7,
        7,
        null,
        11
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
        0,
        0,
        0
      ]
    },
    {
      "args": [
        [
          1
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
      0,
      0,
      0,
      13,
      13,
      9,
      9
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
      0,
      0,
      null,
      0
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
      0,
      0,
      0,
      0
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
        null,
        4,
        5,
        6
      ]
    ],
    "expected": [
      0,
      0,
      0,
      null,
      11,
      4,
      4
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
  }
]$json$::jsonb,
    'approved'
),
(
    2051,
    '使二叉树所有路径值相等的最小代价',
    '给定一棵包含 n 个节点的满二叉树，节点按层序编号
第 i 个节点的值为 cost[i]，根节点下标为 0
节点 i 的左孩子下标为 2*i+1，右孩子下标为 2*i+2
每次操作可以把任意一个节点的值增加 1
求使所有从根到叶子的路径值之和都相等所需的最少操作次数',
    'medium',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '贪心'],
    $json$[
  {
    "input": "n = 7, cost = [1, 5, 2, 2, 3, 3, 1]",
    "output": "6"
  },
  {
    "input": "n = 3, cost = [1, 2, 3]",
    "output": "1"
  },
  {
    "input": "n = 1, cost = [5]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 7, cost = [1, 5, 2, 2, 3, 3, 1]",
    "output": "6"
  },
  {
    "input": "n = 3, cost = [1, 2, 3]",
    "output": "1"
  },
  {
    "input": "n = 1, cost = [5]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minIncrements = function(n, cost) {\n};\n",
  "python": "class Solution:\n    def minIncrements(self, n: int, cost: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minIncrements(int n, std::vector<int>& cost) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minIncrements(int n, int[] cost) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minIncrements",
  "params": [
    {
      "name": "n",
      "type": "int"
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
        7,
        [
          1,
          5,
          2,
          2,
          3,
          3,
          1
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        3,
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
        1,
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
      15,
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
        11,
        12,
        13,
        14,
        15
      ]
    ],
    "expected": 17
  },
  {
    "args": [
      7,
      [
        0,
        0,
        0,
        0,
        0,
        0,
        0
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      3,
      [
        5,
        1,
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      7,
      [
        10,
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
      7,
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
    "expected": 5
  },
  {
    "args": [
      3,
      [
        0,
        5,
        2
      ]
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    2052,
    '网格图中的最大移动次数',
    '给定 m 行 n 列的网格 grid
从第一列的任意格子出发
每一步可以移动到下一列的同一行、上一行或下一行
且目标格子的值必须严格大于当前格子的值
移动不能离开网格
返回最多可以移动的步数',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '矩阵'],
    $json$[
  {
    "input": "grid = [[2, 4, 3, 5], [5, 4, 9, 3], [3, 4, 2, 11], [10, 9, 13, 15]]",
    "output": "3"
  },
  {
    "input": "grid = [[3, 2, 4], [2, 1, 9], [1, 1, 7]]",
    "output": "0"
  },
  {
    "input": "grid = [[1, 1], [1, 1]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[2, 4, 3, 5], [5, 4, 9, 3], [3, 4, 2, 11], [10, 9, 13, 15]]",
    "output": "3"
  },
  {
    "input": "grid = [[3, 2, 4], [2, 1, 9], [1, 1, 7]]",
    "output": "0"
  },
  {
    "input": "grid = [[1, 1], [1, 1]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxMoves = function(grid) {\n};\n",
  "python": "class Solution:\n    def maxMoves(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxMoves(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxMoves(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxMoves",
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
            4,
            3,
            5
          ],
          [
            5,
            4,
            9,
            3
          ],
          [
            3,
            4,
            2,
            11
          ],
          [
            10,
            9,
            13,
            15
          ]
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          [
            3,
            2,
            4
          ],
          [
            2,
            1,
            9
          ],
          [
            1,
            1,
            7
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
            1,
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
          3,
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
          9,
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
          10
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
        ],
        [
          5,
          6,
          7,
          8
        ]
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      [
        [
          5,
          4,
          3,
          2,
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
    2053,
    '统计完全连通分量的数目',
    '给定无向图的节点数 n 和边列表 edges
节点编号为 0 到 n-1
连通分量是完全连通的，当且仅当分量内任意两个不同节点之间都有边
返回完全连通分量的数目
单个节点构成的连通分量视为完全连通',
    'medium',
    1000,
    256,
    ARRAY['图', '并查集'],
    $json$[
  {
    "input": "n = 6, edges = [[0, 1], [0, 2], [1, 2], [3, 4]]",
    "output": "3"
  },
  {
    "input": "n = 6, edges = [[0, 1], [0, 2], [1, 2], [3, 4], [3, 5]]",
    "output": "1"
  },
  {
    "input": "n = 1, edges = []",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 6, edges = [[0, 1], [0, 2], [1, 2], [3, 4]]",
    "output": "3"
  },
  {
    "input": "n = 6, edges = [[0, 1], [0, 2], [1, 2], [3, 4], [3, 5]]",
    "output": "1"
  },
  {
    "input": "n = 1, edges = []",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countCompleteComponents = function(n, edges) {\n};\n",
  "python": "class Solution:\n    def countCompleteComponents(self, n: int, edges: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countCompleteComponents(int n, std::vector<std::vector<int>>& edges) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countCompleteComponents(int n, int[][] edges) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countCompleteComponents",
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
          ]
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
          ]
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        1,
        []
      ],
      "expected": 1
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
          1,
          2
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
          0
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
      7,
      []
    ],
    "expected": 7
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
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    2054,
    '求一个整数的惩罚数',
    '给定正整数 n
若整数 i 的平方的十进制表示可以被切分成若干连续部分
且这些部分表示的整数之和恰好等于 i，则称 i 是惩罚数
求 1 到 n 之间所有惩罚数的平方之和',
    'medium',
    1000,
    256,
    ARRAY['数学', '回溯', '枚举'],
    $json$[
  {
    "input": "n = 10",
    "output": "182"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 37",
    "output": "1478"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 10",
    "output": "182"
  },
  {
    "input": "n = 1",
    "output": "1"
  },
  {
    "input": "n = 37",
    "output": "1478"
  }
]$json$::jsonb,
    $json${
  "javascript": "var punishmentNumber = function(n) {\n};\n",
  "python": "class Solution:\n    def punishmentNumber(self, n: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int punishmentNumber(int n) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int punishmentNumber(int n) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "punishmentNumber",
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
      "expected": 182
    },
    {
      "args": [
        1
      ],
      "expected": 1
    },
    {
      "args": [
        37
      ],
      "expected": 1478
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      9
    ],
    "expected": 82
  },
  {
    "args": [
      100
    ],
    "expected": 41334
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
      50
    ],
    "expected": 3503
  },
  {
    "args": [
      1000
    ],
    "expected": 10804657
  }
]$json$::jsonb,
    'approved'
),
(
    2055,
    '字符串中的额外字符',
    '给定字符串 s 和一个字符串字典 dictionary
把 s 中若干互不重叠的连续子串标记为字典中的单词
返回 s 中未被标记的字符数量的最小值
注意同一个字典单词可以在标记中多次使用',
    'medium',
    1000,
    256,
    ARRAY['字符串', '动态规划', '哈希表'],
    $json$[
  {
    "input": "s = \"leetscode\", dictionary = [\"leet\", \"code\", \"leetcode\"]",
    "output": "1"
  },
  {
    "input": "s = \"sayhelloworld\", dictionary = [\"hello\", \"world\"]",
    "output": "3"
  },
  {
    "input": "s = \"abc\", dictionary = []",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"leetscode\", dictionary = [\"leet\", \"code\", \"leetcode\"]",
    "output": "1"
  },
  {
    "input": "s = \"sayhelloworld\", dictionary = [\"hello\", \"world\"]",
    "output": "3"
  },
  {
    "input": "s = \"abc\", dictionary = []",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minExtraChar = function(s, dictionary) {\n};\n",
  "python": "class Solution:\n    def minExtraChar(self, s: str, dictionary: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minExtraChar(std::string s, std::vector<std::string>& dictionary) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minExtraChar(String s, String[] dictionary) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minExtraChar",
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
  "return_type": "int",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "leetscode",
        [
          "leet",
          "code",
          "leetcode"
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        "sayhelloworld",
        [
          "hello",
          "world"
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        "abc",
        []
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "abc",
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
      "abcd",
      [
        "ab",
        "cd"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      "abcd",
      [
        "abc"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      "aaa",
      [
        "aa"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      "dwmodizxvvbosxxw",
      [
        "ox",
        "lb",
        "diz",
        "gu",
        "v",
        "ksv",
        "o",
        "nuq",
        "r",
        "txhe",
        "e",
        "wmo",
        "cehy",
        "tskz",
        "ds",
        "kzbu"
      ]
    ],
    "expected": 7
  },
  {
    "args": [
      "a",
      [
        "b"
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      "ab",
      [
        "a"
      ]
    ],
    "expected": 1
  }
]$json$::jsonb,
    'approved'
),
(
    2056,
    '找出最安全路径',
    '给定 n 行 n 列的网格 grid，1 表示该格子有小偷，0 表示空格子
一个格子的安全系数等于它到最近小偷的曼哈顿距离
一条路径的安全系数等于路径上所有格子安全系数的最小值
从左上角走到右下角
返回所有路径中安全系数的最大值',
    'medium',
    1000,
    256,
    ARRAY['数组', '广度优先搜索', '二分查找'],
    $json$[
  {
    "input": "grid = [[1, 0, 0], [0, 0, 0], [0, 0, 1]]",
    "output": "0"
  },
  {
    "input": "grid = [[0, 0, 1], [0, 0, 0], [0, 0, 0]]",
    "output": "2"
  },
  {
    "input": "grid = [[0, 0, 0], [0, 1, 0], [0, 0, 0]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[1, 0, 0], [0, 0, 0], [0, 0, 1]]",
    "output": "0"
  },
  {
    "input": "grid = [[0, 0, 1], [0, 0, 0], [0, 0, 0]]",
    "output": "2"
  },
  {
    "input": "grid = [[0, 0, 0], [0, 1, 0], [0, 0, 0]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumSafenessFactor = function(grid) {\n};\n",
  "python": "class Solution:\n    def maximumSafenessFactor(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumSafenessFactor(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumSafenessFactor(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumSafenessFactor",
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
      "expected": 0
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
  ]
}$json$::jsonb,
    $json$[
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
        ],
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
          0,
          0,
          0
        ],
        [
          0,
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
    "expected": 1
  },
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
          0,
          0,
          0,
          0
        ],
        [
          1,
          0,
          0,
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
          1,
          0,
          0
        ],
        [
          0,
          0,
          0,
          0
        ],
        [
          0,
          0,
          0,
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
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    2057,
    '找到冠军 II',
    '给定 n 支队伍和比赛结果 edges
每项 [winner, loser] 表示 winner 战胜了 loser
冠军定义为没有输给任何其他队伍的队伍
若冠军唯一则返回其编号，否则返回 -1',
    'medium',
    1000,
    256,
    ARRAY['图', '数组'],
    $json$[
  {
    "input": "n = 3, edges = [[0, 1], [1, 2]]",
    "output": "0"
  },
  {
    "input": "n = 4, edges = [[0, 2], [1, 3], [1, 2]]",
    "output": "-1"
  },
  {
    "input": "n = 2, edges = [[0, 1]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, edges = [[0, 1], [1, 2]]",
    "output": "0"
  },
  {
    "input": "n = 4, edges = [[0, 2], [1, 3], [1, 2]]",
    "output": "-1"
  },
  {
    "input": "n = 2, edges = [[0, 1]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findChampion = function(n, edges) {\n};\n",
  "python": "class Solution:\n    def findChampion(self, n: int, edges: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findChampion(int n, std::vector<std::vector<int>>& edges) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findChampion(int n, int[][] edges) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findChampion",
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
      "expected": 0
    },
    {
      "args": [
        4,
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
            1,
            2
          ]
        ]
      ],
      "expected": -1
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
          0
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
    "expected": 0
  },
  {
    "args": [
      1,
      []
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
    "expected": 0
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
          0
        ],
        [
          4,
          0
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
      6,
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
          0,
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
    2058,
    '转换字符串的最小成本 I',
    '给定两个长度相同的字符串 source 和 target
给定若干字符转换规则，original[i] 可以转换为 changed[i]，成本为 cost[i]
转换规则可以连续使用，也可以不使用
把 source 的每个字符分别转换为 target 对应位置的字符
返回最小总成本，若无法完成转换则返回 -1',
    'medium',
    1000,
    256,
    ARRAY['图', '最短路', '数组'],
    $json$[
  {
    "input": "source = \"abcd\", target = \"acbe\", original = [\"a\", \"b\", \"c\", \"c\", \"e\", \"d\"], changed = [\"b\", \"c\", \"b\", \"e\", \"b\", \"e\"], cost = [2, 5, 5, 1, 2, 20]",
    "output": "28"
  },
  {
    "input": "source = \"aaaa\", target = \"bbbb\", original = [\"a\", \"c\"], changed = [\"c\", \"b\"], cost = [1, 2]",
    "output": "12"
  },
  {
    "input": "source = \"abc\", target = \"def\", original = [\"a\"], changed = [\"d\"], cost = [5]",
    "output": "-1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "source = \"abcd\", target = \"acbe\", original = [\"a\", \"b\", \"c\", \"c\", \"e\", \"d\"], changed = [\"b\", \"c\", \"b\", \"e\", \"b\", \"e\"], cost = [2, 5, 5, 1, 2, 20]",
    "output": "28"
  },
  {
    "input": "source = \"aaaa\", target = \"bbbb\", original = [\"a\", \"c\"], changed = [\"c\", \"b\"], cost = [1, 2]",
    "output": "12"
  },
  {
    "input": "source = \"abc\", target = \"def\", original = [\"a\"], changed = [\"d\"], cost = [5]",
    "output": "-1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumCostConvert = function(source, target, original, changed, cost) {\n};\n",
  "python": "class Solution:\n    def minimumCostConvert(self, source: str, target: str, original: list[str], changed: list[str], cost: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long minimumCostConvert(std::string source, std::string target, std::vector<std::string>& original, std::vector<std::string>& changed, std::vector<int>& cost) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long minimumCostConvert(String source, String target, String[] original, String[] changed, int[] cost) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumCostConvert",
  "params": [
    {
      "name": "source",
      "type": "string"
    },
    {
      "name": "target",
      "type": "string"
    },
    {
      "name": "original",
      "type": "string[]"
    },
    {
      "name": "changed",
      "type": "string[]"
    },
    {
      "name": "cost",
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
        "abcd",
        "acbe",
        [
          "a",
          "b",
          "c",
          "c",
          "e",
          "d"
        ],
        [
          "b",
          "c",
          "b",
          "e",
          "b",
          "e"
        ],
        [
          2,
          5,
          5,
          1,
          2,
          20
        ]
      ],
      "expected": 28
    },
    {
      "args": [
        "aaaa",
        "bbbb",
        [
          "a",
          "c"
        ],
        [
          "c",
          "b"
        ],
        [
          1,
          2
        ]
      ],
      "expected": 12
    },
    {
      "args": [
        "abc",
        "def",
        [
          "a"
        ],
        [
          "d"
        ],
        [
          5
        ]
      ],
      "expected": -1
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "a",
      "a",
      [],
      [],
      []
    ],
    "expected": 0
  },
  {
    "args": [
      "ab",
      "ba",
      [
        "a",
        "b"
      ],
      [
        "b",
        "a"
      ],
      [
        2,
        3
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      "x",
      "y",
      [
        "x"
      ],
      [
        "y"
      ],
      [
        10
      ]
    ],
    "expected": 10
  },
  {
    "args": [
      "abc",
      "abc",
      [
        "a",
        "b"
      ],
      [
        "b",
        "c"
      ],
      [
        1,
        1
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      "aaa",
      "bbb",
      [
        "a",
        "b"
      ],
      [
        "b",
        "c"
      ],
      [
        1,
        1
      ]
    ],
    "expected": 3
  },
  {
    "args": [
      "abc",
      "def",
      [
        "a",
        "b",
        "c"
      ],
      [
        "b",
        "c",
        "d"
      ],
      [
        1,
        1,
        100
      ]
    ],
    "expected": -1
  }
]$json$::jsonb,
    'approved'
),
(
    2059,
    '需要添加的硬币的最小数量',
    '给定正整数数组 coins 和整数 target
可以往数组中加入任意面额的正整数硬币
要求加入硬币后，能够用数组中的部分硬币组成 1 到 target 之间的所有整数金额
返回最少需要添加的硬币数量',
    'medium',
    1000,
    256,
    ARRAY['数组', '贪心', '排序'],
    $json$[
  {
    "input": "coins = [1, 4, 10], target = 19",
    "output": "2"
  },
  {
    "input": "coins = [1, 4, 10, 5, 9], target = 19",
    "output": "1"
  },
  {
    "input": "coins = [1, 1, 1], target = 20",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "coins = [1, 4, 10], target = 19",
    "output": "2"
  },
  {
    "input": "coins = [1, 4, 10, 5, 9], target = 19",
    "output": "1"
  },
  {
    "input": "coins = [1, 1, 1], target = 20",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumAddedCoins = function(coins, target) {\n};\n",
  "python": "class Solution:\n    def minimumAddedCoins(self, coins: list[int], target: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumAddedCoins(std::vector<int>& coins, int target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumAddedCoins(int[] coins, int target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumAddedCoins",
  "params": [
    {
      "name": "coins",
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
          4,
          10
        ],
        19
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1,
          4,
          10,
          5,
          9
        ],
        19
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
        20
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
    "expected": 0
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
        5,
        10
      ],
      20
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
      10
    ],
    "expected": 0
  },
  {
    "args": [
      [
        3,
        7
      ],
      5
    ],
    "expected": 2
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
  }
]$json$::jsonb,
    'approved'
),
(
    2060,
    '含指定字母的字典序最小 K 长子序列',
    '给定字符串 s、整数 k、字符 letter 与整数 repetition
从 s 中选出一个长度为 k 的子序列
要求子序列中 letter 至少出现 repetition 次
返回满足条件的字典序最小的子序列
保证至少存在一个满足条件的子序列
子序列指从 s 中删除若干字符（也可以不删除）后保持相对顺序得到的字符串',
    'hard',
    1000,
    256,
    ARRAY['字符串', '栈', '贪心'],
    $json$[
  {
    "input": "s = \"leet\", k = 3, letter = \"e\", repetition = 1",
    "output": "\"eet\""
  },
  {
    "input": "s = \"leetcode\", k = 4, letter = \"e\", repetition = 2",
    "output": "\"ecde\""
  },
  {
    "input": "s = \"aaabbbcccddd\", k = 6, letter = \"d\", repetition = 3",
    "output": "\"aaaddd\""
  },
  {
    "input": "s = \"abc\", k = 3, letter = \"a\", repetition = 1",
    "output": "\"abc\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"leet\", k = 3, letter = \"e\", repetition = 1",
    "output": "\"eet\""
  },
  {
    "input": "s = \"leetcode\", k = 4, letter = \"e\", repetition = 2",
    "output": "\"ecde\""
  },
  {
    "input": "s = \"aaabbbcccddd\", k = 6, letter = \"d\", repetition = 3",
    "output": "\"aaaddd\""
  },
  {
    "input": "s = \"abc\", k = 3, letter = \"a\", repetition = 1",
    "output": "\"abc\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestKLengthSubsequence = function(s, k, letter, repetition) {\n};\n",
  "python": "class Solution:\n    def smallestKLengthSubsequence(self, s: str, k: int, letter: str, repetition: int) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string smallestKLengthSubsequence(std::string s, int k, std::string letter, int repetition) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String smallestKLengthSubsequence(String s, int k, String letter, int repetition) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestKLengthSubsequence",
  "params": [
    {
      "name": "s",
      "type": "string"
    },
    {
      "name": "k",
      "type": "int"
    },
    {
      "name": "letter",
      "type": "string"
    },
    {
      "name": "repetition",
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
        "leet",
        3,
        "e",
        1
      ],
      "expected": "eet"
    },
    {
      "args": [
        "leetcode",
        4,
        "e",
        2
      ],
      "expected": "ecde"
    },
    {
      "args": [
        "aaabbbcccddd",
        6,
        "d",
        3
      ],
      "expected": "aaaddd"
    },
    {
      "args": [
        "abc",
        3,
        "a",
        1
      ],
      "expected": "abc"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "zxcvbnm",
      4,
      "z",
      1
    ],
    "expected": "zbnm"
  },
  {
    "args": [
      "aaaa",
      2,
      "a",
      2
    ],
    "expected": "aa"
  },
  {
    "args": [
      "bbbb",
      2,
      "b",
      1
    ],
    "expected": "bb"
  },
  {
    "args": [
      "abcd",
      1,
      "c",
      1
    ],
    "expected": "c"
  },
  {
    "args": [
      "bacab",
      3,
      "a",
      2
    ],
    "expected": "aab"
  },
  {
    "args": [
      "topcoder",
      5,
      "o",
      2
    ],
    "expected": "ocode"
  }
]$json$::jsonb,
    'approved'
),
(
    2061,
    '最多可以完成的任务数',
    '有若干任务与若干工人
第 i 个任务需要 tasks[i] 点体力才能完成
第 j 个工人的体力为 workers[j]
每个工人最多完成一个任务，每个任务最多由一个工人完成
另有 pills 颗药丸，每颗药丸可以让一名工人在本次任务中增加 strength 点体力
每名工人最多使用一颗药丸
返回最多可以完成的任务数',
    'hard',
    2000,
    256,
    ARRAY['数组', '二分查找', '贪心', '排序'],
    $json$[
  {
    "input": "tasks = [3, 2, 1], workers = [0, 3, 3], pills = 1, strength = 1",
    "output": "3"
  },
  {
    "input": "tasks = [5, 4, 4], workers = [4, 4, 4], pills = 1, strength = 5",
    "output": "3"
  },
  {
    "input": "tasks = [10, 15, 30], workers = [3, 7, 12], pills = 1, strength = 10",
    "output": "2"
  },
  {
    "input": "tasks = [1, 2, 3], workers = [1, 2, 3], pills = 0, strength = 1",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "tasks = [3, 2, 1], workers = [0, 3, 3], pills = 1, strength = 1",
    "output": "3"
  },
  {
    "input": "tasks = [5, 4, 4], workers = [4, 4, 4], pills = 1, strength = 5",
    "output": "3"
  },
  {
    "input": "tasks = [10, 15, 30], workers = [3, 7, 12], pills = 1, strength = 10",
    "output": "2"
  },
  {
    "input": "tasks = [1, 2, 3], workers = [1, 2, 3], pills = 0, strength = 1",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxTasksAssigned = function(tasks, workers, pills, strength) {\n};\n",
  "python": "class Solution:\n    def maxTasksAssigned(self, tasks: list[int], workers: list[int], pills: int, strength: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxTasksAssigned(std::vector<int>& tasks, std::vector<int>& workers, int pills, int strength) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxTasksAssigned(int[] tasks, int[] workers, int pills, int strength) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxTasksAssigned",
  "params": [
    {
      "name": "tasks",
      "type": "int[]"
    },
    {
      "name": "workers",
      "type": "int[]"
    },
    {
      "name": "pills",
      "type": "int"
    },
    {
      "name": "strength",
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
          1
        ],
        [
          0,
          3,
          3
        ],
        1,
        1
      ],
      "expected": 3
    },
    {
      "args": [
        [
          5,
          4,
          4
        ],
        [
          4,
          4,
          4
        ],
        1,
        5
      ],
      "expected": 3
    },
    {
      "args": [
        [
          10,
          15,
          30
        ],
        [
          3,
          7,
          12
        ],
        1,
        10
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
          1,
          2,
          3
        ],
        0,
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
        10,
        10,
        10
      ],
      [
        5,
        5,
        5
      ],
      1,
      5
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
      [
        1,
        1,
        1
      ],
      1,
      1
    ],
    "expected": 3
  },
  {
    "args": [
      [
        5,
        9,
        8,
        7
      ],
      [
        4,
        8,
        6
      ],
      2,
      3
    ],
    "expected": 3
  },
  {
    "args": [
      [
        100
      ],
      [
        1,
        2,
        3
      ],
      2,
      99
    ],
    "expected": 1
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
        2,
        3,
        4
      ],
      2,
      1
    ],
    "expected": 3
  },
  {
    "args": [
      [
        6,
        6,
        6,
        6
      ],
      [
        2,
        2,
        2,
        6
      ],
      3,
      4
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    2062,
    '使数组 K 递增的最少操作次数',
    '给定整数数组 arr 与正整数 k
如果对每个满足 i + k < n 的下标 i 都有 arr[i] <= arr[i + k]
则称数组是 K 递增的
每次操作可以把任意一个元素替换成任意整数
返回使数组变为 K 递增所需的最少操作次数',
    'hard',
    1000,
    256,
    ARRAY['数组', '二分查找', '最长递增子序列'],
    $json$[
  {
    "input": "arr = [5, 4, 3, 2, 1], k = 1",
    "output": "4"
  },
  {
    "input": "arr = [4, 1, 5, 2, 6, 3], k = 2",
    "output": "0"
  },
  {
    "input": "arr = [1, 2, 3, 4, 5], k = 3",
    "output": "0"
  },
  {
    "input": "arr = [2, 1, 2, 1, 2, 1], k = 3",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [5, 4, 3, 2, 1], k = 1",
    "output": "4"
  },
  {
    "input": "arr = [4, 1, 5, 2, 6, 3], k = 2",
    "output": "0"
  },
  {
    "input": "arr = [1, 2, 3, 4, 5], k = 3",
    "output": "0"
  },
  {
    "input": "arr = [2, 1, 2, 1, 2, 1], k = 3",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var kIncreasingMinOperations = function(arr, k) {\n};\n",
  "python": "class Solution:\n    def kIncreasingMinOperations(self, arr: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int kIncreasingMinOperations(std::vector<int>& arr, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int kIncreasingMinOperations(int[] arr, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kIncreasingMinOperations",
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
          5,
          4,
          3,
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
          4,
          1,
          5,
          2,
          6,
          3
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
          4,
          5
        ],
        3
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
          2,
          1
        ],
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
        1
      ],
      1
    ],
    "expected": 0
  },
  {
    "args": [
      [
        10,
        9,
        8
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
        2,
        4,
        3,
        5
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
      2
    ],
    "expected": 0
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
        1
      ],
      3
    ],
    "expected": 2
  },
  {
    "args": [
      [
        100,
        1,
        100,
        1,
        100,
        1
      ],
      1
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    2063,
    '参加会议的最多员工数',
    '公司有 n 名员工，编号 0 到 n-1
favorite[i] 表示员工 i 最喜欢的员工编号，且 favorite[i] != i
公司想安排一场会议
每名参会的员工都必须坐在自己最喜欢的员工旁边
每张圆桌至少坐两人，会议可以有多张圆桌
返回最多可以邀请的员工数',
    'hard',
    1000,
    256,
    ARRAY['图', '深度优先搜索', '拓扑排序'],
    $json$[
  {
    "input": "favorite = [2, 2, 1, 2]",
    "output": "3"
  },
  {
    "input": "favorite = [1, 2, 0]",
    "output": "3"
  },
  {
    "input": "favorite = [3, 0, 1, 4, 1]",
    "output": "4"
  },
  {
    "input": "favorite = [1, 0]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "favorite = [2, 2, 1, 2]",
    "output": "3"
  },
  {
    "input": "favorite = [1, 2, 0]",
    "output": "3"
  },
  {
    "input": "favorite = [3, 0, 1, 4, 1]",
    "output": "4"
  },
  {
    "input": "favorite = [1, 0]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumEmployeesInvited = function(favorite) {\n};\n",
  "python": "class Solution:\n    def maximumEmployeesInvited(self, favorite: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maximumEmployeesInvited(std::vector<int>& favorite) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maximumEmployeesInvited(int[] favorite) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumEmployeesInvited",
  "params": [
    {
      "name": "favorite",
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
          0,
          1,
          4,
          1
        ]
      ],
      "expected": 4
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
  ]
}$json$::jsonb,
    $json$[
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
        0,
        3,
        2
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        2,
        3,
        0,
        1
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        2,
        0,
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
        1,
        0,
        4,
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
    2064,
    '同时运行 N 台电脑的最长时间',
    '有 n 台电脑和若干电池
第 i 块电池的电量为 batteries[i]
每台电脑同一时刻最多使用一块电池
每块电池同一时刻最多给一台电脑供电
可以随时更换电脑使用的电池，换电池不消耗电量
所有电脑同时开始运行
返回能让 n 台电脑同时运行的最长分钟数
分钟数必须为整数',
    'hard',
    1000,
    256,
    ARRAY['数组', '二分查找', '贪心'],
    $json$[
  {
    "input": "n = 2, batteries = [3, 3, 3]",
    "output": "4"
  },
  {
    "input": "n = 2, batteries = [1, 1, 1, 1]",
    "output": "2"
  },
  {
    "input": "n = 3, batteries = [10, 10, 10]",
    "output": "10"
  },
  {
    "input": "n = 1, batteries = [5, 7, 9]",
    "output": "21"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 2, batteries = [3, 3, 3]",
    "output": "4"
  },
  {
    "input": "n = 2, batteries = [1, 1, 1, 1]",
    "output": "2"
  },
  {
    "input": "n = 3, batteries = [10, 10, 10]",
    "output": "10"
  },
  {
    "input": "n = 1, batteries = [5, 7, 9]",
    "output": "21"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxRunTime = function(n, batteries) {\n};\n",
  "python": "class Solution:\n    def maxRunTime(self, n: int, batteries: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long maxRunTime(int n, std::vector<int>& batteries) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long maxRunTime(int n, int[] batteries) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxRunTime",
  "params": [
    {
      "name": "n",
      "type": "int"
    },
    {
      "name": "batteries",
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
        2,
        [
          3,
          3,
          3
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        2,
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
        3,
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
        1,
        [
          5,
          7,
          9
        ]
      ],
      "expected": 21
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      2,
      [
        5,
        5
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      3,
      [
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
      1,
      [
        1
      ]
    ],
    "expected": 1
  },
  {
    "args": [
      4,
      [
        1,
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
      2,
      [
        100,
        1,
        1
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      5,
      [
        9,
        9,
        9
      ]
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    2065,
    '删除元素后和的最小差值',
    '给定长度为 3n 的整数数组 nums
先删除恰好 n 个元素
剩下 2n 个元素保持原顺序
前 n 个元素组成第一组，后 n 个元素组成第二组
第一组的和减去第二组的和记为差值
返回所有删除方案中可能的最小差值',
    'hard',
    1000,
    256,
    ARRAY['数组', '堆', '前缀和'],
    $json$[
  {
    "input": "nums = [3, 1, 2]",
    "output": "-1"
  },
  {
    "input": "nums = [7, 9, 5, 8, 1, 3]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]",
    "output": "-18"
  },
  {
    "input": "nums = [-1, -2, -3, -4, -5, -6]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [3, 1, 2]",
    "output": "-1"
  },
  {
    "input": "nums = [7, 9, 5, 8, 1, 3]",
    "output": "1"
  },
  {
    "input": "nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]",
    "output": "-18"
  },
  {
    "input": "nums = [-1, -2, -3, -4, -5, -6]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumDifferenceAfterRemoval = function(nums) {\n};\n",
  "python": "class Solution:\n    def minimumDifferenceAfterRemoval(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long minimumDifferenceAfterRemoval(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long minimumDifferenceAfterRemoval(int[] nums) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumDifferenceAfterRemoval",
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
          3,
          1,
          2
        ]
      ],
      "expected": -1
    },
    {
      "args": [
        [
          7,
          9,
          5,
          8,
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
      "expected": -18
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
        20,
        30
      ]
    ],
    "expected": -20
  },
  {
    "args": [
      [
        -5,
        1,
        2,
        3,
        4,
        6
      ]
    ],
    "expected": -14
  },
  {
    "args": [
      [
        100,
        1,
        1,
        1,
        1,
        100
      ]
    ],
    "expected": -99
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
    "expected": 0
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
    "expected": 9
  }
]$json$::jsonb,
    'approved'
),
(
    2066,
    '得到回文串的最少移动次数',
    '给定一个由小写英文字母组成的字符串 s
每次操作可以交换相邻的两个字符
保证 s 能通过重新排列变成回文串
返回使 s 变成回文串所需的最少相邻交换次数',
    'hard',
    1000,
    256,
    ARRAY['字符串', '双指针', '贪心'],
    $json$[
  {
    "input": "s = \"aabb\"",
    "output": "2"
  },
  {
    "input": "s = \"letelt\"",
    "output": "2"
  },
  {
    "input": "s = \"mamad\"",
    "output": "3"
  },
  {
    "input": "s = \"abcba\"",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aabb\"",
    "output": "2"
  },
  {
    "input": "s = \"letelt\"",
    "output": "2"
  },
  {
    "input": "s = \"mamad\"",
    "output": "3"
  },
  {
    "input": "s = \"abcba\"",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minMovesToPalindrome = function(s) {\n};\n",
  "python": "class Solution:\n    def minMovesToPalindrome(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minMovesToPalindrome(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minMovesToPalindrome(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minMovesToPalindrome",
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
        "aabb"
      ],
      "expected": 2
    },
    {
      "args": [
        "letelt"
      ],
      "expected": 2
    },
    {
      "args": [
        "mamad"
      ],
      "expected": 3
    },
    {
      "args": [
        "abcba"
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
      "abba"
    ],
    "expected": 0
  },
  {
    "args": [
      "abab"
    ],
    "expected": 1
  },
  {
    "args": [
      "aaabbbb"
    ],
    "expected": 6
  },
  {
    "args": [
      "aabbc"
    ],
    "expected": 4
  }
]$json$::jsonb,
    'approved'
),
(
    2067,
    '包含指定路径的最小加权子图',
    '给定 n 个节点、编号 0 到 n-1 的有向带权图
edges[i] = [u, v, w] 表示一条从 u 到 v、权值为 w 的边
再给定起点 src1、src2 与终点 dest
选择一个边集，使得子图中同时存在从 src1 到 dest 与从 src2 到 dest 的路径
返回所选边集的最小总权值
如果无法同时形成两条路径，返回 -1',
    'hard',
    1000,
    256,
    ARRAY['图', '最短路', '堆'],
    $json$[
  {
    "input": "n = 6, edges = [[0, 2, 2], [0, 5, 6], [1, 0, 3], [1, 4, 5], [2, 1, 1], [3, 0, 5], [5, 3, 1], [5, 4, 5]], src1 = 0, src2 = 1, dest = 5",
    "output": "9"
  },
  {
    "input": "n = 4, edges = [[0, 2, 1], [1, 2, 1], [1, 3, 1]], src1 = 0, src2 = 1, dest = 3",
    "output": "-1"
  },
  {
    "input": "n = 3, edges = [[0, 1, 2], [1, 2, 3], [0, 2, 10]], src1 = 0, src2 = 0, dest = 2",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 6, edges = [[0, 2, 2], [0, 5, 6], [1, 0, 3], [1, 4, 5], [2, 1, 1], [3, 0, 5], [5, 3, 1], [5, 4, 5]], src1 = 0, src2 = 1, dest = 5",
    "output": "9"
  },
  {
    "input": "n = 4, edges = [[0, 2, 1], [1, 2, 1], [1, 3, 1]], src1 = 0, src2 = 1, dest = 3",
    "output": "-1"
  },
  {
    "input": "n = 3, edges = [[0, 1, 2], [1, 2, 3], [0, 2, 10]], src1 = 0, src2 = 0, dest = 2",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumWeightedSubgraph = function(n, edges, src1, src2, dest) {\n};\n",
  "python": "class Solution:\n    def minimumWeightedSubgraph(self, n: int, edges: list[list[int]], src1: int, src2: int, dest: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long minimumWeightedSubgraph(int n, std::vector<std::vector<int>>& edges, int src1, int src2, int dest) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long minimumWeightedSubgraph(int n, int[][] edges, int src1, int src2, int dest) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumWeightedSubgraph",
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
      "name": "src1",
      "type": "int"
    },
    {
      "name": "src2",
      "type": "int"
    },
    {
      "name": "dest",
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
        6,
        [
          [
            0,
            2,
            2
          ],
          [
            0,
            5,
            6
          ],
          [
            1,
            0,
            3
          ],
          [
            1,
            4,
            5
          ],
          [
            2,
            1,
            1
          ],
          [
            3,
            0,
            5
          ],
          [
            5,
            3,
            1
          ],
          [
            5,
            4,
            5
          ]
        ],
        0,
        1,
        5
      ],
      "expected": 9
    },
    {
      "args": [
        4,
        [
          [
            0,
            2,
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
            1
          ]
        ],
        0,
        1,
        3
      ],
      "expected": -1
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
            3
          ],
          [
            0,
            2,
            10
          ]
        ],
        0,
        0,
        2
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
          0,
          1,
          4
        ]
      ],
      0,
      0,
      1
    ],
    "expected": 4
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
          5
        ]
      ],
      0,
      0,
      2
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
          2,
          1,
          1
        ],
        [
          1,
          3,
          1
        ]
      ],
      0,
      2,
      3
    ],
    "expected": 3
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
      1,
      2
    ],
    "expected": 4
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
      0,
      1,
      1
    ],
    "expected": 1
  },
  {
    "args": [
      5,
      [
        [
          0,
          4,
          3
        ],
        [
          4,
          3,
          2
        ],
        [
          1,
          4,
          1
        ],
        [
          3,
          2,
          1
        ]
      ],
      0,
      1,
      2
    ],
    "expected": 7
  }
]$json$::jsonb,
    'approved'
),
(
    2068,
    '相邻字符不同的最长路径',
    '给定一棵 n 个节点的树
parent[i] 表示节点 i 的父节点，其中 parent[0] = -1
s[i] 是节点 i 上的字符
路径是树中一条不重复经过节点的链
求最长的路径，使路径上任意两个相邻节点的字符都不相同
返回该路径包含的节点数',
    'hard',
    1000,
    256,
    ARRAY['树', '深度优先搜索', '动态规划'],
    $json$[
  {
    "input": "parent = [-1, 0, 0, 1, 1, 2], s = \"abacbe\"",
    "output": "3"
  },
  {
    "input": "parent = [-1, 0, 0, 0], s = \"aabc\"",
    "output": "3"
  },
  {
    "input": "parent = [-1, 0, 1, 2, 3, 4], s = \"aaaaaa\"",
    "output": "1"
  },
  {
    "input": "parent = [-1, 0, 0, 1, 1, 2], s = \"abcdef\"",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "parent = [-1, 0, 0, 1, 1, 2], s = \"abacbe\"",
    "output": "3"
  },
  {
    "input": "parent = [-1, 0, 0, 0], s = \"aabc\"",
    "output": "3"
  },
  {
    "input": "parent = [-1, 0, 1, 2, 3, 4], s = \"aaaaaa\"",
    "output": "1"
  },
  {
    "input": "parent = [-1, 0, 0, 1, 1, 2], s = \"abcdef\"",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestPathDifferentChars = function(parent, s) {\n};\n",
  "python": "class Solution:\n    def longestPathDifferentChars(self, parent: list[int], s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestPathDifferentChars(std::vector<int>& parent, std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestPathDifferentChars(int[] parent, String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestPathDifferentChars",
  "params": [
    {
      "name": "parent",
      "type": "int[]"
    },
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
        [
          -1,
          0,
          0,
          1,
          1,
          2
        ],
        "abacbe"
      ],
      "expected": 3
    },
    {
      "args": [
        [
          -1,
          0,
          0,
          0
        ],
        "aabc"
      ],
      "expected": 3
    },
    {
      "args": [
        [
          -1,
          0,
          1,
          2,
          3,
          4
        ],
        "aaaaaa"
      ],
      "expected": 1
    },
    {
      "args": [
        [
          -1,
          0,
          0,
          1,
          1,
          2
        ],
        "abcdef"
      ],
      "expected": 5
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        -1,
        0
      ],
      "ab"
    ],
    "expected": 2
  },
  {
    "args": [
      [
        -1,
        0
      ],
      "aa"
    ],
    "expected": 1
  },
  {
    "args": [
      [
        -1,
        0,
        1
      ],
      "abc"
    ],
    "expected": 3
  },
  {
    "args": [
      [
        -1,
        0,
        0,
        0,
        0
      ],
      "abcde"
    ],
    "expected": 3
  },
  {
    "args": [
      [
        -1,
        0,
        1,
        1,
        0,
        4,
        4
      ],
      "abacdef"
    ],
    "expected": 5
  },
  {
    "args": [
      [
        -1,
        0,
        0,
        1,
        2,
        3
      ],
      "aabbbb"
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    2069,
    '字符串的总引力',
    '给定字符串 s，仅包含小写英文字母
一个字符串的引力定义为其中不同字符的个数
求 s 所有子串的引力之和',
    'hard',
    1000,
    256,
    ARRAY['字符串', '哈希表', '动态规划'],
    $json$[
  {
    "input": "s = \"abc\"",
    "output": "10"
  },
  {
    "input": "s = \"aab\"",
    "output": "8"
  },
  {
    "input": "s = \"abbca\"",
    "output": "28"
  },
  {
    "input": "s = \"aaaa\"",
    "output": "10"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"abc\"",
    "output": "10"
  },
  {
    "input": "s = \"aab\"",
    "output": "8"
  },
  {
    "input": "s = \"abbca\"",
    "output": "28"
  },
  {
    "input": "s = \"aaaa\"",
    "output": "10"
  }
]$json$::jsonb,
    $json${
  "javascript": "var totalAppeal = function(s) {\n};\n",
  "python": "class Solution:\n    def totalAppeal(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long totalAppeal(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long totalAppeal(String s) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "totalAppeal",
  "params": [
    {
      "name": "s",
      "type": "string"
    }
  ],
  "return_type": "long",
  "compare": {
    "mode": "exact"
  },
  "public_cases": [
    {
      "args": [
        "abc"
      ],
      "expected": 10
    },
    {
      "args": [
        "aab"
      ],
      "expected": 8
    },
    {
      "args": [
        "abbca"
      ],
      "expected": 28
    },
    {
      "args": [
        "aaaa"
      ],
      "expected": 10
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
    "expected": 4
  },
  {
    "args": [
      "aba"
    ],
    "expected": 9
  },
  {
    "args": [
      "abcde"
    ],
    "expected": 35
  },
  {
    "args": [
      "zzza"
    ],
    "expected": 13
  },
  {
    "args": [
      "abab"
    ],
    "expected": 16
  }
]$json$::jsonb,
    'approved'
),
(
    2070,
    '最大波动的子字符串',
    '给定由小写英文字母组成的字符串 s
对于 s 的一个子串，若其中至少包含两种字符
定义波动值为子串中出现次数最多的字符的次数减去出现次数最少的字符的次数
求所有子串的最大波动值',
    'hard',
    2000,
    256,
    ARRAY['字符串', '动态规划', '枚举'],
    $json$[
  {
    "input": "s = \"aababbb\"",
    "output": "3"
  },
  {
    "input": "s = \"abcde\"",
    "output": "0"
  },
  {
    "input": "s = \"aaaaabbb\"",
    "output": "4"
  },
  {
    "input": "s = \"abcc\"",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"aababbb\"",
    "output": "3"
  },
  {
    "input": "s = \"abcde\"",
    "output": "0"
  },
  {
    "input": "s = \"aaaaabbb\"",
    "output": "4"
  },
  {
    "input": "s = \"abcc\"",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var largestVarianceSubstring = function(s) {\n};\n",
  "python": "class Solution:\n    def largestVarianceSubstring(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int largestVarianceSubstring(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int largestVarianceSubstring(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "largestVarianceSubstring",
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
        "aababbb"
      ],
      "expected": 3
    },
    {
      "args": [
        "abcde"
      ],
      "expected": 0
    },
    {
      "args": [
        "aaaaabbb"
      ],
      "expected": 4
    },
    {
      "args": [
        "abcc"
      ],
      "expected": 1
    }
  ]
}$json$::jsonb,
    $json$[
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
    "expected": 0
  },
  {
    "args": [
      "aab"
    ],
    "expected": 1
  },
  {
    "args": [
      "abbb"
    ],
    "expected": 2
  },
  {
    "args": [
      "abcabc"
    ],
    "expected": 1
  },
  {
    "args": [
      "zzzab"
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    2071,
    '巫师的总力量',
    '给定数组 strength 表示每名巫师的力量
一个连续子数组的总力量定义为该子数组中的最小力量乘以子数组元素之和
求所有连续子数组的总力量之和
结果对 1000000007 取模',
    'hard',
    1000,
    256,
    ARRAY['数组', '单调栈', '前缀和'],
    $json$[
  {
    "input": "strength = [1, 3, 1, 2]",
    "output": "44"
  },
  {
    "input": "strength = [5, 4, 6]",
    "output": "213"
  },
  {
    "input": "strength = [1, 2]",
    "output": "8"
  },
  {
    "input": "strength = [2, 2, 2]",
    "output": "40"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "strength = [1, 3, 1, 2]",
    "output": "44"
  },
  {
    "input": "strength = [5, 4, 6]",
    "output": "213"
  },
  {
    "input": "strength = [1, 2]",
    "output": "8"
  },
  {
    "input": "strength = [2, 2, 2]",
    "output": "40"
  }
]$json$::jsonb,
    $json${
  "javascript": "var totalStrengthWizards = function(strength) {\n};\n",
  "python": "class Solution:\n    def totalStrengthWizards(self, strength: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int totalStrengthWizards(std::vector<int>& strength) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int totalStrengthWizards(int[] strength) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "totalStrengthWizards",
  "params": [
    {
      "name": "strength",
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
          1,
          2
        ]
      ],
      "expected": 44
    },
    {
      "args": [
        [
          5,
          4,
          6
        ]
      ],
      "expected": 213
    },
    {
      "args": [
        [
          1,
          2
        ]
      ],
      "expected": 8
    },
    {
      "args": [
        [
          2,
          2,
          2
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
    "expected": 4
  },
  {
    "args": [
      [
        3,
        1,
        2
      ]
    ],
    "expected": 27
  },
  {
    "args": [
      [
        10,
        1,
        10
      ]
    ],
    "expected": 244
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
    "expected": 203
  },
  {
    "args": [
      [
        1,
        100,
        1,
        100,
        1
      ]
    ],
    "expected": 21419
  }
]$json$::jsonb,
    'approved'
),
(
    2072,
    '使数组非递减的最少步骤',
    '给定整数数组 nums
每一步同时删除所有满足 nums[i-1] > nums[i] 的元素 nums[i]，其中 i >= 1
所有判断都基于该步开始前的数组
当数组不再发生变化时停止
返回执行的总步数',
    'hard',
    1000,
    256,
    ARRAY['数组', '单调栈'],
    $json$[
  {
    "input": "nums = [5, 3, 4, 4, 7, 3, 6, 11, 8, 5, 11]",
    "output": "3"
  },
  {
    "input": "nums = [4, 5, 7, 7, 6]",
    "output": "1"
  },
  {
    "input": "nums = [7, 5, 6]",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [5, 3, 4, 4, 7, 3, 6, 11, 8, 5, 11]",
    "output": "3"
  },
  {
    "input": "nums = [4, 5, 7, 7, 6]",
    "output": "1"
  },
  {
    "input": "nums = [7, 5, 6]",
    "output": "2"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var totalStepsNonDecreasing = function(nums) {\n};\n",
  "python": "class Solution:\n    def totalStepsNonDecreasing(self, nums: list[int]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int totalStepsNonDecreasing(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int totalStepsNonDecreasing(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "totalStepsNonDecreasing",
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
          3,
          4,
          4,
          7,
          3,
          6,
          11,
          8,
          5,
          11
        ]
      ],
      "expected": 3
    },
    {
      "args": [
        [
          4,
          5,
          7,
          7,
          6
        ]
      ],
      "expected": 1
    },
    {
      "args": [
        [
          7,
          5,
          6
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
        10,
        4,
        5,
        5,
        6
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
    "expected": 0
  },
  {
    "args": [
      [
        2,
        1,
        3,
        2,
        4,
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
    2073,
    '移除障碍物到达角落的最少数量',
    '给定 n 行 m 列的 0-1 网格 grid
0 表示空地，1 表示障碍物
从左上角 (0, 0) 出发，每次可以向上、下、左、右移动到相邻格子
进入障碍物格子需要移除该障碍物，计数加一
可以重复经过格子
左上角与右下角保证是空地
返回到达右下角 (n-1, m-1) 需要移除的最少障碍物数量',
    'hard',
    1000,
    256,
    ARRAY['图', '广度优先搜索', '最短路'],
    $json$[
  {
    "input": "grid = [[0, 1, 1], [1, 1, 0], [1, 1, 0]]",
    "output": "2"
  },
  {
    "input": "grid = [[0, 1, 0, 0, 0], [0, 1, 0, 1, 0], [0, 0, 0, 1, 0]]",
    "output": "0"
  },
  {
    "input": "grid = [[0, 1, 1, 1], [1, 0, 1, 1], [1, 1, 0, 1], [1, 1, 1, 0]]",
    "output": "3"
  },
  {
    "input": "grid = [[0, 0], [0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[0, 1, 1], [1, 1, 0], [1, 1, 0]]",
    "output": "2"
  },
  {
    "input": "grid = [[0, 1, 0, 0, 0], [0, 1, 0, 1, 0], [0, 0, 0, 1, 0]]",
    "output": "0"
  },
  {
    "input": "grid = [[0, 1, 1, 1], [1, 0, 1, 1], [1, 1, 0, 1], [1, 1, 1, 0]]",
    "output": "3"
  },
  {
    "input": "grid = [[0, 0], [0, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumObstacles = function(grid) {\n};\n",
  "python": "class Solution:\n    def minimumObstacles(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumObstacles(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumObstacles(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumObstacles",
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
      "expected": 2
    },
    {
      "args": [
        [
          [
            0,
            1,
            0,
            0,
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
            0,
            0,
            0,
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
            0,
            1,
            1,
            1
          ],
          [
            1,
            0,
            1,
            1
          ],
          [
            1,
            1,
            0,
            1
          ],
          [
            1,
            1,
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
          1
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
    ],
    "expected": 2
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
    "expected": 0
  },
  {
    "args": [
      [
        [
          0,
          1,
          1,
          1,
          1
        ],
        [
          0,
          1,
          1,
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
          0,
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
    2074,
    '给公司命名',
    '给定互不相同的字符串数组 ideas
每个字符串由一个小写字母后跟若干小写字母组成
选择两个不同的字符串 ideaA 与 ideaB
交换它们的首字母，得到两个新名字
若两个新名字都不在 ideas 中，则这对名字有效
两个选择顺序不同视为不同的公司名
返回有效公司名的数量',
    'hard',
    1000,
    256,
    ARRAY['数组', '哈希表', '字符串'],
    $json$[
  {
    "input": "ideas = [\"coffee\", \"donuts\", \"time\", \"toffee\"]",
    "output": "6"
  },
  {
    "input": "ideas = [\"lack\", \"back\"]",
    "output": "0"
  },
  {
    "input": "ideas = [\"abc\", \"bcd\", \"cde\"]",
    "output": "6"
  },
  {
    "input": "ideas = [\"a\", \"b\"]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "ideas = [\"coffee\", \"donuts\", \"time\", \"toffee\"]",
    "output": "6"
  },
  {
    "input": "ideas = [\"lack\", \"back\"]",
    "output": "0"
  },
  {
    "input": "ideas = [\"abc\", \"bcd\", \"cde\"]",
    "output": "6"
  },
  {
    "input": "ideas = [\"a\", \"b\"]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var distinctCompanyNames = function(ideas) {\n};\n",
  "python": "class Solution:\n    def distinctCompanyNames(self, ideas: list[str]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    long long distinctCompanyNames(std::vector<std::string>& ideas) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public long distinctCompanyNames(String[] ideas) {\n        return 0L;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "distinctCompanyNames",
  "params": [
    {
      "name": "ideas",
      "type": "string[]"
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
          "coffee",
          "donuts",
          "time",
          "toffee"
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          "lack",
          "back"
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
      "expected": 6
    },
    {
      "args": [
        [
          "a",
          "b"
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
        "aa",
        "ab",
        "ba",
        "bb"
      ]
    ],
    "expected": 0
  },
  {
    "args": [
      [
        "ab",
        "ac"
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
    "expected": 2
  },
  {
    "args": [
      [
        "xyz",
        "abc"
      ]
    ],
    "expected": 2
  },
  {
    "args": [
      [
        "aab",
        "aba",
        "baa"
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        "abcd",
        "bcde",
        "cdef"
      ]
    ],
    "expected": 6
  }
]$json$::jsonb,
    'approved'
),
(
    2075,
    '删除操作后的最大子段和',
    '给定整数数组 nums 与数组 removeQueries
removeQueries 是 0 到 n-1 的一个排列
按 removeQueries 的顺序依次删除对应下标的元素
删除后数组可能被分成若干连续段
每删除一个元素后，求所有连续段中和的最大值
空段的值为 0
返回长度为 n 的数组 answer
answer[i] 表示删除前 i+1 个元素后的结果',
    'hard',
    1000,
    256,
    ARRAY['数组', '并查集', '前缀和'],
    $json$[
  {
    "input": "nums = [1, 2, 3, 4, 5], removeQueries = [0, 1, 2, 3, 4]",
    "output": "[14, 12, 9, 5, 0]"
  },
  {
    "input": "nums = [2, 9, 4, 2, 3, 4, 9], removeQueries = [5, 3, 6, 0, 2, 1, 4]",
    "output": "[20, 15, 15, 13, 9, 3, 0]"
  },
  {
    "input": "nums = [1, 1, 1], removeQueries = [0, 1, 2]",
    "output": "[2, 1, 0]"
  },
  {
    "input": "nums = [5], removeQueries = [0]",
    "output": "[0]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2, 3, 4, 5], removeQueries = [0, 1, 2, 3, 4]",
    "output": "[14, 12, 9, 5, 0]"
  },
  {
    "input": "nums = [2, 9, 4, 2, 3, 4, 9], removeQueries = [5, 3, 6, 0, 2, 1, 4]",
    "output": "[20, 15, 15, 13, 9, 3, 0]"
  },
  {
    "input": "nums = [1, 1, 1], removeQueries = [0, 1, 2]",
    "output": "[2, 1, 0]"
  },
  {
    "input": "nums = [5], removeQueries = [0]",
    "output": "[0]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maximumSegmentSumAfterRemovals = function(nums, removeQueries) {\n};\n",
  "python": "class Solution:\n    def maximumSegmentSumAfterRemovals(self, nums: list[int], removeQueries: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> maximumSegmentSumAfterRemovals(std::vector<int>& nums, std::vector<int>& removeQueries) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] maximumSegmentSumAfterRemovals(int[] nums, int[] removeQueries) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maximumSegmentSumAfterRemovals",
  "params": [
    {
      "name": "nums",
      "type": "int[]"
    },
    {
      "name": "removeQueries",
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
          4,
          5
        ],
        [
          0,
          1,
          2,
          3,
          4
        ]
      ],
      "expected": [
        14,
        12,
        9,
        5,
        0
      ]
    },
    {
      "args": [
        [
          2,
          9,
          4,
          2,
          3,
          4,
          9
        ],
        [
          5,
          3,
          6,
          0,
          2,
          1,
          4
        ]
      ],
      "expected": [
        20,
        15,
        15,
        13,
        9,
        3,
        0
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
          0,
          1,
          2
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
        [
          5
        ],
        [
          0
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
        1,
        2
      ],
      [
        1,
        0
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
        10,
        2,
        5
      ],
      [
        1,
        0,
        2
      ]
    ],
    "expected": [
      10,
      5,
      0
    ]
  },
  {
    "args": [
      [
        3,
        3,
        3,
        3
      ],
      [
        2,
        0,
        3,
        1
      ]
    ],
    "expected": [
      6,
      3,
      3,
      0
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
        0,
        1
      ]
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
        4,
        1,
        4
      ],
      [
        1,
        0,
        2
      ]
    ],
    "expected": [
      4,
      4,
      0
    ]
  },
  {
    "args": [
      [
        2,
        1,
        3,
        1,
        2
      ],
      [
        2,
        4,
        0,
        1,
        3
      ]
    ],
    "expected": [
      3,
      3,
      1,
      1,
      0
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    2076,
    '最长递增子序列 II',
    '给定整数数组 nums 与正整数 k
求最长的子序列
满足对子序列中每一对相邻元素都有前一个元素小于后一个元素
且后一个元素减前一个元素不超过 k
返回该子序列的长度',
    'hard',
    1000,
    256,
    ARRAY['数组', '线段树', '动态规划'],
    $json$[
  {
    "input": "nums = [4, 2, 1, 4, 3, 4, 5], k = 3",
    "output": "4"
  },
  {
    "input": "nums = [7, 4, 5, 1, 8, 12, 4, 7], k = 5",
    "output": "4"
  },
  {
    "input": "nums = [1, 2, 3, 4], k = 1",
    "output": "4"
  },
  {
    "input": "nums = [1, 5, 9], k = 3",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [4, 2, 1, 4, 3, 4, 5], k = 3",
    "output": "4"
  },
  {
    "input": "nums = [7, 4, 5, 1, 8, 12, 4, 7], k = 5",
    "output": "4"
  },
  {
    "input": "nums = [1, 2, 3, 4], k = 1",
    "output": "4"
  },
  {
    "input": "nums = [1, 5, 9], k = 3",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var longestIncreasingSubsequenceK = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def longestIncreasingSubsequenceK(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestIncreasingSubsequenceK(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int longestIncreasingSubsequenceK(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "longestIncreasingSubsequenceK",
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
          2,
          1,
          4,
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
          7,
          4,
          5,
          1,
          8,
          12,
          4,
          7
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
          5,
          9
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
    "expected": 1
  },
  {
    "args": [
      [
        5,
        5,
        5
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
        3
      ],
      2
    ],
    "expected": 2
  },
  {
    "args": [
      [
        10,
        1,
        2,
        3,
        4,
        5
      ],
      2
    ],
    "expected": 5
  },
  {
    "args": [
      [
        3,
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
        100,
        2,
        101,
        3,
        102
      ],
      1
    ],
    "expected": 3
  }
]$json$::jsonb,
    'approved'
),
(
    2077,
    '好路径的数目',
    '给定一棵 n 个节点的树，节点编号 0 到 n-1
vals[i] 是节点 i 的值
edges 表示树中的边
称节点对 (a, b) 是好路径，如果：
a 与 b 的值相等
从 a 到 b 的路径上所有节点的值都不超过 vals[a]
路径包含单个节点也算，即允许 a = b
返回好路径的数量
节点对按无序对计，(a, b) 与 (b, a) 视为同一条路径',
    'hard',
    1000,
    256,
    ARRAY['树', '并查集', '深度优先搜索'],
    $json$[
  {
    "input": "vals = [1, 3, 2, 1, 3], edges = [[0, 1], [0, 2], [2, 3], [2, 4]]",
    "output": "6"
  },
  {
    "input": "vals = [1, 1, 1], edges = [[0, 1], [1, 2]]",
    "output": "6"
  },
  {
    "input": "vals = [1, 2, 1], edges = [[0, 2]]",
    "output": "4"
  },
  {
    "input": "vals = [1], edges = []",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "vals = [1, 3, 2, 1, 3], edges = [[0, 1], [0, 2], [2, 3], [2, 4]]",
    "output": "6"
  },
  {
    "input": "vals = [1, 1, 1], edges = [[0, 1], [1, 2]]",
    "output": "6"
  },
  {
    "input": "vals = [1, 2, 1], edges = [[0, 2]]",
    "output": "4"
  },
  {
    "input": "vals = [1], edges = []",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countGoodPaths = function(vals, edges) {\n};\n",
  "python": "class Solution:\n    def countGoodPaths(self, vals: list[int], edges: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countGoodPaths(std::vector<int>& vals, std::vector<std::vector<int>>& edges) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countGoodPaths(int[] vals, int[][] edges) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countGoodPaths",
  "params": [
    {
      "name": "vals",
      "type": "int[]"
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
        [
          1,
          3,
          2,
          1,
          3
        ],
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
          ]
        ]
      ],
      "expected": 6
    },
    {
      "args": [
        [
          1,
          1,
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
      "expected": 6
    },
    {
      "args": [
        [
          1,
          2,
          1
        ],
        [
          [
            0,
            2
          ]
        ]
      ],
      "expected": 4
    },
    {
      "args": [
        [
          1
        ],
        []
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
      ],
      [
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
        3,
        1,
        3
      ],
      []
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
    "expected": 3
  },
  {
    "args": [
      [
        2,
        2,
        2
      ],
      [
        [
          0,
          1
        ]
      ]
    ],
    "expected": 4
  },
  {
    "args": [
      [
        1,
        2,
        1,
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
        ],
        [
          2,
          3
        ]
      ]
    ],
    "expected": 5
  },
  {
    "args": [
      [
        2,
        1,
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
        ],
        [
          1,
          3
        ]
      ]
    ],
    "expected": 6
  }
]$json$::jsonb,
    'approved'
),
(
    2078,
    '字符串的前缀分数和',
    '给定字符串数组 words
对于每个单词 word，它的前缀分数定义为：
对 word 的每一个非空前缀 p
统计 words 中以 p 为前缀的单词数量
再把这些数量相加
返回一个数组，第 i 个元素是 words[i] 的前缀分数',
    'hard',
    1000,
    256,
    ARRAY['字符串', '字典树', '数组'],
    $json$[
  {
    "input": "words = [\"abc\", \"ab\", \"bc\", \"bcd\"]",
    "output": "[5, 4, 4, 5]"
  },
  {
    "input": "words = [\"a\", \"ab\", \"abc\"]",
    "output": "[3, 5, 6]"
  },
  {
    "input": "words = [\"abcd\"]",
    "output": "[4]"
  },
  {
    "input": "words = [\"ab\", \"ab\"]",
    "output": "[4, 4]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "words = [\"abc\", \"ab\", \"bc\", \"bcd\"]",
    "output": "[5, 4, 4, 5]"
  },
  {
    "input": "words = [\"a\", \"ab\", \"abc\"]",
    "output": "[3, 5, 6]"
  },
  {
    "input": "words = [\"abcd\"]",
    "output": "[4]"
  },
  {
    "input": "words = [\"ab\", \"ab\"]",
    "output": "[4, 4]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var sumPrefixScores = function(words) {\n};\n",
  "python": "class Solution:\n    def sumPrefixScores(self, words: list[str]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> sumPrefixScores(std::vector<std::string>& words) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] sumPrefixScores(String[] words) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "sumPrefixScores",
  "params": [
    {
      "name": "words",
      "type": "string[]"
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
          "abc",
          "ab",
          "bc",
          "bcd"
        ]
      ],
      "expected": [
        5,
        4,
        4,
        5
      ]
    },
    {
      "args": [
        [
          "a",
          "ab",
          "abc"
        ]
      ],
      "expected": [
        3,
        5,
        6
      ]
    },
    {
      "args": [
        [
          "abcd"
        ]
      ],
      "expected": [
        4
      ]
    },
    {
      "args": [
        [
          "ab",
          "ab"
        ]
      ],
      "expected": [
        4,
        4
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "x"
      ]
    ],
    "expected": [
      1
    ]
  },
  {
    "args": [
      [
        "aa",
        "aa",
        "aa"
      ]
    ],
    "expected": [
      6,
      6,
      6
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
      2,
      2
    ]
  },
  {
    "args": [
      [
        "abc",
        "abd",
        "abe"
      ]
    ],
    "expected": [
      7,
      7,
      7
    ]
  },
  {
    "args": [
      [
        "z",
        "zz",
        "zzz"
      ]
    ],
    "expected": [
      3,
      5,
      6
    ]
  },
  {
    "args": [
      [
        "a",
        "ba",
        "cba"
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
    2079,
    '网格查询的最大得分',
    '给定 n 行 m 列的整数网格 grid 与整数数组 queries
对每个查询 queries[i]，从左上角 (0, 0) 出发
可以移动到上下左右相邻的格子
但目标格子的值必须严格小于 queries[i]
起点也只有在值严格小于 queries[i] 时才会计分
每个格子最多计一分
返回长度为 len(queries) 的数组 answer
answer[i] 表示第 i 个查询可以到达并计分的格子数量',
    'hard',
    1000,
    256,
    ARRAY['图', '广度优先搜索', '堆', '排序'],
    $json$[
  {
    "input": "grid = [[1, 2, 3], [2, 5, 7], [3, 5, 1]], queries = [5, 6, 2]",
    "output": "[5, 8, 1]"
  },
  {
    "input": "grid = [[1, 1], [1, 1]], queries = [1, 2]",
    "output": "[0, 4]"
  },
  {
    "input": "grid = [[5]], queries = [4, 6]",
    "output": "[0, 1]"
  },
  {
    "input": "grid = [[1, 2], [3, 4]], queries = [2, 3, 5]",
    "output": "[1, 2, 4]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[1, 2, 3], [2, 5, 7], [3, 5, 1]], queries = [5, 6, 2]",
    "output": "[5, 8, 1]"
  },
  {
    "input": "grid = [[1, 1], [1, 1]], queries = [1, 2]",
    "output": "[0, 4]"
  },
  {
    "input": "grid = [[5]], queries = [4, 6]",
    "output": "[0, 1]"
  },
  {
    "input": "grid = [[1, 2], [3, 4]], queries = [2, 3, 5]",
    "output": "[1, 2, 4]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxPointsFromGridQueries = function(grid, queries) {\n};\n",
  "python": "class Solution:\n    def maxPointsFromGridQueries(self, grid: list[list[int]], queries: list[int]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> maxPointsFromGridQueries(std::vector<std::vector<int>>& grid, std::vector<int>& queries) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] maxPointsFromGridQueries(int[][] grid, int[] queries) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxPointsFromGridQueries",
  "params": [
    {
      "name": "grid",
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
            2,
            3
          ],
          [
            2,
            5,
            7
          ],
          [
            3,
            5,
            1
          ]
        ],
        [
          5,
          6,
          2
        ]
      ],
      "expected": [
        5,
        8,
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
            1,
            1
          ]
        ],
        [
          1,
          2
        ]
      ],
      "expected": [
        0,
        4
      ]
    },
    {
      "args": [
        [
          [
            5
          ]
        ],
        [
          4,
          6
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
            2
          ],
          [
            3,
            4
          ]
        ],
        [
          2,
          3,
          5
        ]
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
        [
          1
        ]
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
      [
        [
          1
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
          1,
          1
        ]
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
        [
          1,
          2,
          1
        ]
      ],
      [
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
        [
          1,
          5,
          1
        ],
        [
          5,
          1,
          5
        ],
        [
          1,
          5,
          1
        ]
      ],
      [
        2,
        6
      ]
    ],
    "expected": [
      1,
      9
    ]
  },
  {
    "args": [
      [
        [
          1,
          3,
          1
        ],
        [
          3,
          1,
          3
        ],
        [
          1,
          3,
          1
        ]
      ],
      [
        2,
        4
      ]
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
    2080,
    '直线上最多的点数',
    '给定平面上的整数点数组 points，其中 points[i] = [xi, yi]
求最多有多少个点位于同一条直线上
所有点的坐标互不相同',
    'hard',
    1000,
    256,
    ARRAY['几何', '哈希表', '数学'],
    $json$[
  {
    "input": "points = [[1, 1], [2, 2], [3, 3]]",
    "output": "3"
  },
  {
    "input": "points = [[1, 1], [3, 2], [5, 3], [4, 1], [2, 3], [1, 4]]",
    "output": "4"
  },
  {
    "input": "points = [[0, 0]]",
    "output": "1"
  },
  {
    "input": "points = [[0, 0], [1, 1]]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "points = [[1, 1], [2, 2], [3, 3]]",
    "output": "3"
  },
  {
    "input": "points = [[1, 1], [3, 2], [5, 3], [4, 1], [2, 3], [1, 4]]",
    "output": "4"
  },
  {
    "input": "points = [[0, 0]]",
    "output": "1"
  },
  {
    "input": "points = [[0, 0], [1, 1]]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxPoints = function(points) {\n};\n",
  "python": "class Solution:\n    def maxPoints(self, points: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxPoints(std::vector<std::vector<int>>& points) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxPoints(int[][] points) {\n        return 0;\n    }\n}\n"
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
            1,
            1
          ],
          [
            3,
            2
          ],
          [
            5,
            3
          ],
          [
            4,
            1
          ],
          [
            2,
            3
          ],
          [
            1,
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
        ],
        [
          2,
          2
        ],
        [
          3,
          3
        ],
        [
          4,
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
          1
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
          3
        ],
        [
          3,
          3
        ],
        [
          5,
          3
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
      [
        [
          -1,
          -1
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
          2,
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
          0,
          0
        ],
        [
          1,
          2
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
          8
        ],
        [
          5,
          11
        ]
      ]
    ],
    "expected": 5
  }
]$json$::jsonb,
    'approved'
),
(
    2081,
    '给表达式添加运算符',
    '给定只包含数字的字符串 num 和整数 target
在 num 的数字之间插入 +、- 或 *，也可以选择不插入，构造表达式
表达式按通常的运算优先级计算，乘号优先于加减
数字的顺序不能改变，且不能有前导零（数字 0 本身除外）
返回所有计算结果等于 target 的表达式，按字典序升序排列',
    'hard',
    1000,
    256,
    ARRAY['字符串', '回溯', '数学'],
    $json$[
  {
    "input": "num = \"123\", target = 6",
    "output": "[\"1*2*3\", \"1+2+3\"]"
  },
  {
    "input": "num = \"232\", target = 8",
    "output": "[\"2*3+2\", \"2+3*2\"]"
  },
  {
    "input": "num = \"105\", target = 5",
    "output": "[\"1*0+5\", \"10-5\"]"
  },
  {
    "input": "num = \"0\", target = 0",
    "output": "[\"0\"]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num = \"123\", target = 6",
    "output": "[\"1*2*3\", \"1+2+3\"]"
  },
  {
    "input": "num = \"232\", target = 8",
    "output": "[\"2*3+2\", \"2+3*2\"]"
  },
  {
    "input": "num = \"105\", target = 5",
    "output": "[\"1*0+5\", \"10-5\"]"
  },
  {
    "input": "num = \"0\", target = 0",
    "output": "[\"0\"]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var addOperators = function(num, target) {\n};\n",
  "python": "class Solution:\n    def addOperators(self, num: str, target: int) -> list[str]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::string> addOperators(std::string num, int target) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public String[] addOperators(String num, int target) {\n        return new String[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "addOperators",
  "params": [
    {
      "name": "num",
      "type": "string"
    },
    {
      "name": "target",
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
        "123",
        6
      ],
      "expected": [
        "1*2*3",
        "1+2+3"
      ]
    },
    {
      "args": [
        "232",
        8
      ],
      "expected": [
        "2*3+2",
        "2+3*2"
      ]
    },
    {
      "args": [
        "105",
        5
      ],
      "expected": [
        "1*0+5",
        "10-5"
      ]
    },
    {
      "args": [
        "0",
        0
      ],
      "expected": [
        "0"
      ]
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "00",
      0
    ],
    "expected": [
      "0*0",
      "0+0",
      "0-0"
    ]
  },
  {
    "args": [
      "345",
      15
    ],
    "expected": []
  },
  {
    "args": [
      "1234",
      10
    ],
    "expected": [
      "1*2*3+4",
      "1+2+3+4"
    ]
  },
  {
    "args": [
      "999",
      81
    ],
    "expected": []
  },
  {
    "args": [
      "2147483647",
      2147483647
    ],
    "expected": [
      "2147483647"
    ]
  },
  {
    "args": [
      "100",
      100
    ],
    "expected": [
      "100"
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    2082,
    '最小好进制',
    '给定一个十进制正整数字符串 n
若整数 k（k >= 2）满足 n 在 k 进制下的表示全部由数字 1 组成，则称 k 是一个好进制
返回最小的好进制 k，以十进制字符串形式返回
保证答案存在',
    'hard',
    1000,
    256,
    ARRAY['数学', '二分查找'],
    $json$[
  {
    "input": "n = \"13\"",
    "output": "\"3\""
  },
  {
    "input": "n = \"4681\"",
    "output": "\"8\""
  },
  {
    "input": "n = \"100\"",
    "output": "\"99\""
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = \"13\"",
    "output": "\"3\""
  },
  {
    "input": "n = \"4681\"",
    "output": "\"8\""
  },
  {
    "input": "n = \"100\"",
    "output": "\"99\""
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestGoodBase = function(n) {\n};\n",
  "python": "class Solution:\n    def smallestGoodBase(self, n: str) -> str:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string smallestGoodBase(std::string n) {\n        return \"\";\n    }\n};\n",
  "java": "class Solution {\n    public String smallestGoodBase(String n) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestGoodBase",
  "params": [
    {
      "name": "n",
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
        "13"
      ],
      "expected": "3"
    },
    {
      "args": [
        "4681"
      ],
      "expected": "8"
    },
    {
      "args": [
        "100"
      ],
      "expected": "99"
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "3"
    ],
    "expected": "2"
  },
  {
    "args": [
      "7"
    ],
    "expected": "2"
  },
  {
    "args": [
      "15"
    ],
    "expected": "2"
  },
  {
    "args": [
      "31"
    ],
    "expected": "2"
  },
  {
    "args": [
      "8191"
    ],
    "expected": "2"
  },
  {
    "args": [
      "1000000000000000000"
    ],
    "expected": "999999999999999999"
  }
]$json$::jsonb,
    'approved'
),
(
    2083,
    '解码方法 II',
    '给定由数字和字符 * 组成的字符串 s，字符 * 可以代表 1 到 9 中的任意一个数字
将 s 解码为字母序列，编码规则为 A -> 1，B -> 2，……，Z -> 26
返回解码方法的总数，答案对 10^9 + 7 取模
数字 0 不能单独解码，也不能作为两位数的首位',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
  {
    "input": "s = \"*\"",
    "output": "9"
  },
  {
    "input": "s = \"1*\"",
    "output": "18"
  },
  {
    "input": "s = \"2*\"",
    "output": "15"
  },
  {
    "input": "s = \"**\"",
    "output": "96"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "s = \"*\"",
    "output": "9"
  },
  {
    "input": "s = \"1*\"",
    "output": "18"
  },
  {
    "input": "s = \"2*\"",
    "output": "15"
  },
  {
    "input": "s = \"**\"",
    "output": "96"
  }
]$json$::jsonb,
    $json${
  "javascript": "var numDecodingsII = function(s) {\n};\n",
  "python": "class Solution:\n    def numDecodingsII(self, s: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numDecodingsII(std::string s) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int numDecodingsII(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "numDecodingsII",
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
        "*"
      ],
      "expected": 9
    },
    {
      "args": [
        "1*"
      ],
      "expected": 18
    },
    {
      "args": [
        "2*"
      ],
      "expected": 15
    },
    {
      "args": [
        "**"
      ],
      "expected": 96
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
      "10"
    ],
    "expected": 1
  },
  {
    "args": [
      "*1"
    ],
    "expected": 11
  },
  {
    "args": [
      "06"
    ],
    "expected": 0
  },
  {
    "args": [
      "***"
    ],
    "expected": 999
  },
  {
    "args": [
      "1*1"
    ],
    "expected": 20
  }
]$json$::jsonb,
    'approved'
),
(
    2084,
    '中心对称数 III',
    '中心对称数是指旋转 180 度后仍与自身相同的数
旋转后 6 变成 9，9 变成 6，0、1、8 保持不变
给定两个非负整数 low 和 high（以十进制字符串给出）
返回区间 [low, high] 内中心对称数的个数
多位数不能有前导零',
    'hard',
    1000,
    256,
    ARRAY['数学', '字符串', '回溯'],
    $json$[
  {
    "input": "low = \"50\", high = \"100\"",
    "output": "3"
  },
  {
    "input": "low = \"0\", high = \"0\"",
    "output": "1"
  },
  {
    "input": "low = \"1\", high = \"100\"",
    "output": "6"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "low = \"50\", high = \"100\"",
    "output": "3"
  },
  {
    "input": "low = \"0\", high = \"0\"",
    "output": "1"
  },
  {
    "input": "low = \"1\", high = \"100\"",
    "output": "6"
  }
]$json$::jsonb,
    $json${
  "javascript": "var strobogrammaticInRange = function(low, high) {\n};\n",
  "python": "class Solution:\n    def strobogrammaticInRange(self, low: str, high: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int strobogrammaticInRange(std::string low, std::string high) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int strobogrammaticInRange(String low, String high) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "strobogrammaticInRange",
  "params": [
    {
      "name": "low",
      "type": "string"
    },
    {
      "name": "high",
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
        "50",
        "100"
      ],
      "expected": 3
    },
    {
      "args": [
        "0",
        "0"
      ],
      "expected": 1
    },
    {
      "args": [
        "1",
        "100"
      ],
      "expected": 6
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "0",
      "1000"
    ],
    "expected": 19
  },
  {
    "args": [
      "100",
      "10000"
    ],
    "expected": 32
  },
  {
    "args": [
      "69",
      "96"
    ],
    "expected": 3
  },
  {
    "args": [
      "1000",
      "10000"
    ],
    "expected": 20
  },
  {
    "args": [
      "0",
      "100000"
    ],
    "expected": 99
  },
  {
    "args": [
      "10000",
      "1000000"
    ],
    "expected": 160
  }
]$json$::jsonb,
    'approved'
),
(
    2085,
    '冗余连接 II',
    '给定有向边数组 edges，表示一棵以某个节点为根的树，额外多加了一条有向边
先前的树中每个节点最多只有一个父节点，图中不存在自环
返回一条可以删除的边，使得剩余部分是一棵有根树
如果有多条边满足条件，返回在输入中最后出现的那条
返回值形如 [u, v]',
    'hard',
    1000,
    256,
    ARRAY['图', '并查集'],
    $json$[
  {
    "input": "edges = [[1, 2], [1, 3], [2, 3]]",
    "output": "[2, 3]"
  },
  {
    "input": "edges = [[1, 2], [2, 3], [3, 4], [4, 1], [1, 5]]",
    "output": "[4, 1]"
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
    "input": "edges = [[1, 2], [2, 3], [3, 4], [4, 1], [1, 5]]",
    "output": "[4, 1]"
  },
  {
    "input": "edges = [[1, 2], [2, 3], [3, 1]]",
    "output": "[3, 1]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findRedundantDirectedConnection = function(edges) {\n};\n",
  "python": "class Solution:\n    def findRedundantDirectedConnection(self, edges: list[list[int]]) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> findRedundantDirectedConnection(std::vector<std::vector<int>>& edges) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] findRedundantDirectedConnection(int[][] edges) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findRedundantDirectedConnection",
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
            4,
            1
          ],
          [
            1,
            5
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
          2,
          1
        ],
        [
          3,
          1
        ],
        [
          2,
          3
        ]
      ]
    ],
    "expected": [
      3,
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
          4,
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
          4
        ],
        [
          4,
          5
        ],
        [
          5,
          2
        ]
      ]
    ],
    "expected": [
      5,
      2
    ]
  },
  {
    "args": [
      [
        [
          3,
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
          1,
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
  }
]$json$::jsonb,
    'approved'
),
(
    2086,
    '贴纸拼词',
    '给定字符串数组 stickers 和一个字符串 target
每次可以选择一张贴纸，剪下其中的若干字符拼到答案中，每种字符最多使用贴纸中出现的次数
每张贴纸可以重复使用无限次
返回拼出 target 所需的最少贴纸数量；无法拼出返回 -1',
    'hard',
    1000,
    256,
    ARRAY['位运算', '动态规划', '记忆化搜索'],
    $json$[
  {
    "input": "stickers = [\"with\", \"example\", \"science\"], target = \"thehat\"",
    "output": "3"
  },
  {
    "input": "stickers = [\"notice\", \"possible\"], target = \"basicbasic\"",
    "output": "-1"
  },
  {
    "input": "stickers = [\"a\", \"b\", \"c\"], target = \"abc\"",
    "output": "3"
  },
  {
    "input": "stickers = [\"a\"], target = \"aaa\"",
    "output": "3"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "stickers = [\"with\", \"example\", \"science\"], target = \"thehat\"",
    "output": "3"
  },
  {
    "input": "stickers = [\"notice\", \"possible\"], target = \"basicbasic\"",
    "output": "-1"
  },
  {
    "input": "stickers = [\"a\", \"b\", \"c\"], target = \"abc\"",
    "output": "3"
  },
  {
    "input": "stickers = [\"a\"], target = \"aaa\"",
    "output": "3"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minStickers = function(stickers, target) {\n};\n",
  "python": "class Solution:\n    def minStickers(self, stickers: list[str], target: str) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minStickers(std::vector<std::string>& stickers, std::string target) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minStickers(String[] stickers, String target) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minStickers",
  "params": [
    {
      "name": "stickers",
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
          "with",
          "example",
          "science"
        ],
        "thehat"
      ],
      "expected": 3
    },
    {
      "args": [
        [
          "notice",
          "possible"
        ],
        "basicbasic"
      ],
      "expected": -1
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
          "a"
        ],
        "aaa"
      ],
      "expected": 3
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      [
        "ab",
        "bc",
        "cd"
      ],
      "abcd"
    ],
    "expected": 2
  },
  {
    "args": [
      [
        "a",
        "b"
      ],
      "ab"
    ],
    "expected": 2
  },
  {
    "args": [
      [
        "control",
        "heart",
        "interest",
        "stream",
        "sentence",
        "soil"
      ],
      "ocean"
    ],
    "expected": 2
  },
  {
    "args": [
      [
        "x"
      ],
      "y"
    ],
    "expected": -1
  },
  {
    "args": [
      [
        "these",
        "guess",
        "about",
        "random",
        "worst",
        "time"
      ],
      "thequickbrownfox"
    ],
    "expected": -1
  },
  {
    "args": [
      [
        "aa"
      ],
      "aaa"
    ],
    "expected": 2
  }
]$json$::jsonb,
    'approved'
),
(
    2087,
    '找出第 K 小的数对距离',
    '给定整数数组 nums 和整数 k
数对距离定义为两个下标对应元素的绝对差
返回所有下标对 (i, j)（i < j）中第 k 小的数对距离
距离按非递减顺序计第 k 个',
    'hard',
    1000,
    256,
    ARRAY['数组', '二分查找', '双指针'],
    $json$[
  {
    "input": "nums = [1, 3, 1], k = 2",
    "output": "2"
  },
  {
    "input": "nums = [1, 1, 1], k = 2",
    "output": "0"
  },
  {
    "input": "nums = [1, 6, 1], k = 3",
    "output": "5"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 3, 1], k = 2",
    "output": "2"
  },
  {
    "input": "nums = [1, 1, 1], k = 2",
    "output": "0"
  },
  {
    "input": "nums = [1, 6, 1], k = 3",
    "output": "5"
  }
]$json$::jsonb,
    $json${
  "javascript": "var smallestDistancePair = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def smallestDistancePair(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int smallestDistancePair(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int smallestDistancePair(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "smallestDistancePair",
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
          3,
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
          6,
          1
        ],
        3
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
        4
      ],
      6
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        1000
      ],
      1
    ],
    "expected": 999
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
      4
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
      ],
      10
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
      3
    ],
    "expected": 0
  }
]$json$::jsonb,
    'approved'
),
(
    2088,
    '查找集群内的关键连接',
    '给定 n 个节点和无向边数组 connections，节点编号为 0 到 n-1，图连通
若删除某条边会使图不再连通，则称该边为关键连接
返回所有关键连接，每条边用 [u, v] 表示且 u < v
结果按字典序升序排列',
    'hard',
    1000,
    256,
    ARRAY['图', '深度优先搜索', '割边'],
    $json$[
  {
    "input": "n = 4, connections = [[0, 1], [1, 2], [2, 0], [1, 3]]",
    "output": "[[1, 3]]"
  },
  {
    "input": "n = 2, connections = [[0, 1]]",
    "output": "[[0, 1]]"
  },
  {
    "input": "n = 3, connections = [[0, 1], [1, 2]]",
    "output": "[[0, 1], [1, 2]]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 4, connections = [[0, 1], [1, 2], [2, 0], [1, 3]]",
    "output": "[[1, 3]]"
  },
  {
    "input": "n = 2, connections = [[0, 1]]",
    "output": "[[0, 1]]"
  },
  {
    "input": "n = 3, connections = [[0, 1], [1, 2]]",
    "output": "[[0, 1], [1, 2]]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var criticalConnections = function(n, connections) {\n};\n",
  "python": "class Solution:\n    def criticalConnections(self, n: int, connections: list[list[int]]) -> list[list[int]]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> criticalConnections(int n, std::vector<std::vector<int>>& connections) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[][] criticalConnections(int n, int[][] connections) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "criticalConnections",
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
  "return_type": "int[][]",
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
            1,
            2
          ],
          [
            2,
            0
          ],
          [
            1,
            3
          ]
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
        2,
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
        [
          0,
          1
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
          0
        ],
        [
          1,
          3
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
        3,
        4
      ]
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
          3
        ],
        [
          3,
          0
        ]
      ]
    ],
    "expected": []
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
        ]
      ]
    ],
    "expected": []
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
          0
        ],
        [
          0,
          4
        ]
      ]
    ],
    "expected": [
      [
        0,
        4
      ]
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
  }
]$json$::jsonb,
    'approved'
),
(
    2089,
    '滑动谜题',
    '给定一个 2 x 3 的滑动拼图 board，包含 0 到 5 的一个排列，0 表示空格
每次操作可以将 0 与上下左右相邻的数字交换
返回将拼图还原为 [[1, 2, 3], [4, 5, 0]] 的最少操作次数；无法还原返回 -1',
    'hard',
    1000,
    256,
    ARRAY['广度优先搜索', '数组', '矩阵'],
    $json$[
  {
    "input": "board = [[1, 2, 3], [4, 0, 5]]",
    "output": "1"
  },
  {
    "input": "board = [[1, 2, 3], [5, 4, 0]]",
    "output": "-1"
  },
  {
    "input": "board = [[4, 1, 2], [5, 0, 3]]",
    "output": "5"
  },
  {
    "input": "board = [[1, 2, 3], [4, 5, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "board = [[1, 2, 3], [4, 0, 5]]",
    "output": "1"
  },
  {
    "input": "board = [[1, 2, 3], [5, 4, 0]]",
    "output": "-1"
  },
  {
    "input": "board = [[4, 1, 2], [5, 0, 3]]",
    "output": "5"
  },
  {
    "input": "board = [[1, 2, 3], [4, 5, 0]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var slidingPuzzle = function(board) {\n};\n",
  "python": "class Solution:\n    def slidingPuzzle(self, board: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int slidingPuzzle(std::vector<std::vector<int>>& board) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int slidingPuzzle(int[][] board) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "slidingPuzzle",
  "params": [
    {
      "name": "board",
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
            0,
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
            2,
            3
          ],
          [
            5,
            4,
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
            4,
            1,
            2
          ],
          [
            5,
            0,
            3
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
            2,
            3
          ],
          [
            4,
            5,
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
          3,
          2,
          4
        ],
        [
          1,
          5,
          0
        ]
      ]
    ],
    "expected": 14
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
        ]
      ]
    ],
    "expected": 15
  },
  {
    "args": [
      [
        [
          2,
          4,
          3
        ],
        [
          1,
          0,
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
          5,
          4,
          3
        ],
        [
          2,
          1,
          0
        ]
      ]
    ],
    "expected": 14
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
          4,
          0,
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
          5,
          4
        ],
        [
          3,
          2,
          1
        ]
      ]
    ],
    "expected": 15
  }
]$json$::jsonb,
    'approved'
),
(
    2090,
    '到达终点',
    '给定四个正整数 sx、sy、tx、ty
从点 (sx, sy) 出发，每次操作可以把 (x, y) 变成 (x + y, y) 或 (x, y + x)
返回能否恰好到达点 (tx, ty)',
    'hard',
    1000,
    256,
    ARRAY['数学', '欧几里得算法'],
    $json$[
  {
    "input": "sx = 1, sy = 1, tx = 3, ty = 5",
    "output": "true"
  },
  {
    "input": "sx = 1, sy = 1, tx = 2, ty = 2",
    "output": "false"
  },
  {
    "input": "sx = 1, sy = 1, tx = 1, ty = 1",
    "output": "true"
  },
  {
    "input": "sx = 1, sy = 1, tx = 1, ty = 1000000000",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "sx = 1, sy = 1, tx = 3, ty = 5",
    "output": "true"
  },
  {
    "input": "sx = 1, sy = 1, tx = 2, ty = 2",
    "output": "false"
  },
  {
    "input": "sx = 1, sy = 1, tx = 1, ty = 1",
    "output": "true"
  },
  {
    "input": "sx = 1, sy = 1, tx = 1, ty = 1000000000",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var reachingPoints = function(sx, sy, tx, ty) {\n};\n",
  "python": "class Solution:\n    def reachingPoints(self, sx: int, sy: int, tx: int, ty: int) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool reachingPoints(int sx, int sy, int tx, int ty) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean reachingPoints(int sx, int sy, int tx, int ty) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "reachingPoints",
  "params": [
    {
      "name": "sx",
      "type": "int"
    },
    {
      "name": "sy",
      "type": "int"
    },
    {
      "name": "tx",
      "type": "int"
    },
    {
      "name": "ty",
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
        1,
        1,
        3,
        5
      ],
      "expected": true
    },
    {
      "args": [
        1,
        1,
        2,
        2
      ],
      "expected": false
    },
    {
      "args": [
        1,
        1,
        1,
        1
      ],
      "expected": true
    },
    {
      "args": [
        1,
        1,
        1,
        1000000000
      ],
      "expected": true
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      1,
      1,
      1000000000,
      1
    ],
    "expected": true
  },
  {
    "args": [
      1,
      1,
      3,
      4
    ],
    "expected": true
  },
  {
    "args": [
      1,
      2,
      3,
      4
    ],
    "expected": false
  },
  {
    "args": [
      2,
      3,
      5,
      8
    ],
    "expected": true
  },
  {
    "args": [
      35,
      13,
      455955547,
      420098884
    ],
    "expected": false
  },
  {
    "args": [
      1,
      1,
      6,
      3
    ],
    "expected": false
  }
]$json$::jsonb,
    'approved'
),
(
    2091,
    '第 K 个最小的素数分数',
    '给定按升序排列且元素互不相同的正整数数组 arr，其中 arr[0] = 1，以及整数 k
考虑所有满足 0 <= i < j < len(arr) 的分数 arr[i] / arr[j]
返回第 k 小的分数，用 [arr[i], arr[j]] 表示
分数按数值升序排列；数值相同时按分子升序，再按分母升序',
    'hard',
    1000,
    256,
    ARRAY['数组', '堆', '数学'],
    $json$[
  {
    "input": "arr = [1, 2, 3, 4], k = 1",
    "output": "[1, 4]"
  },
  {
    "input": "arr = [1, 2, 3, 4], k = 3",
    "output": "[1, 2]"
  },
  {
    "input": "arr = [1, 2, 3, 4], k = 4",
    "output": "[2, 4]"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "arr = [1, 2, 3, 4], k = 1",
    "output": "[1, 4]"
  },
  {
    "input": "arr = [1, 2, 3, 4], k = 3",
    "output": "[1, 2]"
  },
  {
    "input": "arr = [1, 2, 3, 4], k = 4",
    "output": "[2, 4]"
  }
]$json$::jsonb,
    $json${
  "javascript": "var kthSmallestPrimeFraction = function(arr, k) {\n};\n",
  "python": "class Solution:\n    def kthSmallestPrimeFraction(self, arr: list[int], k: int) -> list[int]:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> kthSmallestPrimeFraction(std::vector<int>& arr, int k) {\n        return {};\n    }\n};\n",
  "java": "class Solution {\n    public int[] kthSmallestPrimeFraction(int[] arr, int k) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "kthSmallestPrimeFraction",
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
        1
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
          2,
          3,
          4
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
          3,
          4
        ],
        4
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
        7,
        23
      ],
      2
    ],
    "expected": [
      1,
      7
    ]
  },
  {
    "args": [
      [
        1,
        3,
        5
      ],
      3
    ],
    "expected": [
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
      7
    ],
    "expected": [
      3,
      5
    ]
  },
  {
    "args": [
      [
        1,
        11,
        13,
        17
      ],
      6
    ],
    "expected": [
      11,
      13
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
      10
    ],
    "expected": [
      3,
      5
    ]
  }
]$json$::jsonb,
    'approved'
),
(
    2092,
    '黑板异或游戏',
    '给定整数数组 nums两名玩家轮流从黑板上擦去恰好一个数，先手为 Alice
若擦去一个数后，黑板上剩余所有数的异或和变为 0，则擦去该数的玩家立即失败
若某位玩家在回合开始时黑板上所有数的异或和为 0，则该玩家立即获胜
假设双方都采取最优策略，返回先手 Alice 是否必胜',
    'hard',
    1000,
    256,
    ARRAY['位运算', '数学', '博弈'],
    $json$[
  {
    "input": "nums = [1, 1, 2]",
    "output": "false"
  },
  {
    "input": "nums = [0, 1]",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "true"
  },
  {
    "input": "nums = [1, 2]",
    "output": "true"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 1, 2]",
    "output": "false"
  },
  {
    "input": "nums = [0, 1]",
    "output": "true"
  },
  {
    "input": "nums = [1, 2, 3]",
    "output": "true"
  },
  {
    "input": "nums = [1, 2]",
    "output": "true"
  }
]$json$::jsonb,
    $json${
  "javascript": "var xorGame = function(nums) {\n};\n",
  "python": "class Solution:\n    def xorGame(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool xorGame(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean xorGame(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "xorGame",
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
          1,
          2
        ]
      ],
      "expected": false
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
        4,
        8
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        3,
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
        7,
        8,
        9,
        10
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        0,
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
    2093,
    '矩形面积 II',
    '给定二维整数数组 rectangles
rectangles[i] = [x1, y1, x2, y2] 表示一个与坐标轴平行的矩形
返回这些矩形覆盖的总面积，重叠部分只计算一次
答案对 10^9 + 7 取模',
    'hard',
    1000,
    256,
    ARRAY['数组', '扫描线', '线段树'],
    $json$[
  {
    "input": "rectangles = [[0, 0, 2, 2], [1, 0, 2, 3], [1, 0, 3, 1]]",
    "output": "6"
  },
  {
    "input": "rectangles = [[0, 0, 1000000000, 1000000000]]",
    "output": "49"
  },
  {
    "input": "rectangles = [[0, 0, 1, 1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "rectangles = [[0, 0, 2, 2], [1, 0, 2, 3], [1, 0, 3, 1]]",
    "output": "6"
  },
  {
    "input": "rectangles = [[0, 0, 1000000000, 1000000000]]",
    "output": "49"
  },
  {
    "input": "rectangles = [[0, 0, 1, 1]]",
    "output": "1"
  }
]$json$::jsonb,
    $json${
  "javascript": "var rectangleArea = function(rectangles) {\n};\n",
  "python": "class Solution:\n    def rectangleArea(self, rectangles: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int rectangleArea(std::vector<std::vector<int>>& rectangles) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int rectangleArea(int[][] rectangles) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "rectangleArea",
  "params": [
    {
      "name": "rectangles",
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
            2,
            2
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
            0,
            1000000000,
            1000000000
          ]
        ]
      ],
      "expected": 49
    },
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
      ]
    ],
    "expected": 7
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
          2,
          0,
          3,
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
          0,
          0,
          1,
          3
        ],
        [
          0,
          1,
          1,
          4
        ],
        [
          0,
          2,
          1,
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
          0,
          3,
          3
        ],
        [
          1,
          1,
          2,
          2
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
          0,
          1,
          1
        ],
        [
          1,
          1,
          2,
          2
        ],
        [
          2,
          2,
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
          0,
          0,
          5,
          2
        ],
        [
          1,
          1,
          4,
          3
        ],
        [
          2,
          0,
          3,
          4
        ]
      ]
    ],
    "expected": 14
  }
]$json$::jsonb,
    'approved'
),
(
    2094,
    '在网格图中访问一个格子的最少时间',
    '给定 m x n 的网格图 grid
从左上角 (0, 0) 出发，时间为 0，每秒必须移动到上下左右相邻的格子，不能停留
只有在时间大于等于 grid[r][c] 时才能进入格子 (r, c)
返回到达右下角 (m-1, n-1) 的最早时间；无法到达返回 -1
保证 grid[0][0] = 0',
    'hard',
    1000,
    256,
    ARRAY['图', '最短路', '堆', '矩阵'],
    $json$[
  {
    "input": "grid = [[0, 1, 3, 2], [5, 1, 2, 5], [4, 3, 8, 6]]",
    "output": "7"
  },
  {
    "input": "grid = [[0, 2, 4], [3, 2, 1], [1, 0, 4]]",
    "output": "-1"
  },
  {
    "input": "grid = [[0, 1], [1, 2]]",
    "output": "2"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "grid = [[0, 1, 3, 2], [5, 1, 2, 5], [4, 3, 8, 6]]",
    "output": "7"
  },
  {
    "input": "grid = [[0, 2, 4], [3, 2, 1], [1, 0, 4]]",
    "output": "-1"
  },
  {
    "input": "grid = [[0, 1], [1, 2]]",
    "output": "2"
  }
]$json$::jsonb,
    $json${
  "javascript": "var minimumTime = function(grid) {\n};\n",
  "python": "class Solution:\n    def minimumTime(self, grid: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minimumTime(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int minimumTime(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "minimumTime",
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
            3,
            2
          ],
          [
            5,
            1,
            2,
            5
          ],
          [
            4,
            3,
            8,
            6
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
            2,
            4
          ],
          [
            3,
            2,
            1
          ],
          [
            1,
            0,
            4
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
          3
        ],
        [
          1,
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
          0,
          1,
          100
        ],
        [
          1,
          2,
          3
        ],
        [
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
          0,
          5
        ],
        [
          5,
          6
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
          0,
          10,
          10
        ],
        [
          10,
          10,
          10
        ],
        [
          10,
          10,
          0
        ]
      ]
    ],
    "expected": -1
  }
]$json$::jsonb,
    'approved'
),
(
    2095,
    '图中的最短环',
    '给定一个包含 n 个节点的无向图，节点编号为 0 到 n-1
边数组 edges 中 edges[i] = [u, v] 表示一条无向边，图中没有自环和重边
返回图中最短环的长度；如果不存在环，返回 -1
环是指起点和终点相同且至少包含 3 条边的路径',
    'hard',
    1000,
    256,
    ARRAY['图', '广度优先搜索'],
    $json$[
  {
    "input": "n = 3, edges = [[0, 1], [1, 2], [2, 0]]",
    "output": "3"
  },
  {
    "input": "n = 3, edges = [[0, 1], [1, 2]]",
    "output": "-1"
  },
  {
    "input": "n = 5, edges = [[0, 1], [0, 2], [1, 3], [2, 3], [3, 4]]",
    "output": "4"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "n = 3, edges = [[0, 1], [1, 2], [2, 0]]",
    "output": "3"
  },
  {
    "input": "n = 3, edges = [[0, 1], [1, 2]]",
    "output": "-1"
  },
  {
    "input": "n = 5, edges = [[0, 1], [0, 2], [1, 3], [2, 3], [3, 4]]",
    "output": "4"
  }
]$json$::jsonb,
    $json${
  "javascript": "var findShortestCycle = function(n, edges) {\n};\n",
  "python": "class Solution:\n    def findShortestCycle(self, n: int, edges: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int findShortestCycle(int n, std::vector<std::vector<int>>& edges) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int findShortestCycle(int n, int[][] edges) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "findShortestCycle",
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
        ]
      ],
      "expected": 3
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
            0,
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
        ],
        [
          3,
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
        ],
        [
          4,
          5
        ],
        [
          5,
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
    "expected": -1
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
    "expected": -1
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
        ],
        [
          6,
          0
        ]
      ]
    ],
    "expected": 7
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
          0
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
    2096,
    '最大公约数遍历',
    '给定整数数组 nums
节点 i 与节点 j 之间存在边当且仅当 gcd(nums[i], nums[j]) > 1
返回是否存在一条路径，可以从任意节点出发并经过所有节点
路径中可以多次访问节点',
    'hard',
    1000,
    256,
    ARRAY['数组', '数学', '并查集', '数论'],
    $json$[
  {
    "input": "nums = [2, 3, 6]",
    "output": "true"
  },
  {
    "input": "nums = [3, 9, 5]",
    "output": "false"
  },
  {
    "input": "nums = [4, 3, 12, 8]",
    "output": "true"
  },
  {
    "input": "nums = [2, 3, 5]",
    "output": "false"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [2, 3, 6]",
    "output": "true"
  },
  {
    "input": "nums = [3, 9, 5]",
    "output": "false"
  },
  {
    "input": "nums = [4, 3, 12, 8]",
    "output": "true"
  },
  {
    "input": "nums = [2, 3, 5]",
    "output": "false"
  }
]$json$::jsonb,
    $json${
  "javascript": "var canTraverseAllPairs = function(nums) {\n};\n",
  "python": "class Solution:\n    def canTraverseAllPairs(self, nums: list[int]) -> bool:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool canTraverseAllPairs(std::vector<int>& nums) {\n        return false;\n    }\n};\n",
  "java": "class Solution {\n    public boolean canTraverseAllPairs(int[] nums) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "canTraverseAllPairs",
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
          6
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          3,
          9,
          5
        ]
      ],
      "expected": false
    },
    {
      "args": [
        [
          4,
          3,
          12,
          8
        ]
      ],
      "expected": true
    },
    {
      "args": [
        [
          2,
          3,
          5
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
  },
  {
    "args": [
      [
        2,
        4,
        8,
        16
      ]
    ],
    "expected": true
  },
  {
    "args": [
      [
        7,
        11,
        13,
        17
      ]
    ],
    "expected": false
  },
  {
    "args": [
      [
        6,
        35,
        10,
        21
      ]
    ],
    "expected": true
  }
]$json$::jsonb,
    'approved'
),
(
    2097,
    '统计整数数目',
    '给定两个正整数 num1 和 num2（以十进制字符串给出），以及整数 min_sum 和 max_sum
返回区间 [num1, num2] 内，各位数字之和位于 [min_sum, max_sum] 的整数个数
答案对 10^9 + 7 取模',
    'hard',
    1000,
    256,
    ARRAY['数学', '动态规划', '数位动态规划'],
    $json$[
  {
    "input": "num1 = \"1\", num2 = \"12\", min_sum = 1, max_sum = 8",
    "output": "11"
  },
  {
    "input": "num1 = \"1\", num2 = \"5\", min_sum = 1, max_sum = 5",
    "output": "5"
  },
  {
    "input": "num1 = \"10\", num2 = \"20\", min_sum = 2, max_sum = 3",
    "output": "3"
  },
  {
    "input": "num1 = \"1\", num2 = \"100\", min_sum = 1, max_sum = 8",
    "output": "45"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "num1 = \"1\", num2 = \"12\", min_sum = 1, max_sum = 8",
    "output": "11"
  },
  {
    "input": "num1 = \"1\", num2 = \"5\", min_sum = 1, max_sum = 5",
    "output": "5"
  },
  {
    "input": "num1 = \"10\", num2 = \"20\", min_sum = 2, max_sum = 3",
    "output": "3"
  },
  {
    "input": "num1 = \"1\", num2 = \"100\", min_sum = 1, max_sum = 8",
    "output": "45"
  }
]$json$::jsonb,
    $json${
  "javascript": "var countOfIntegers = function(num1, num2, min_sum, max_sum) {\n};\n",
  "python": "class Solution:\n    def countOfIntegers(self, num1: str, num2: str, min_sum: int, max_sum: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int countOfIntegers(std::string num1, std::string num2, int min_sum, int max_sum) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int countOfIntegers(String num1, String num2, int min_sum, int max_sum) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "countOfIntegers",
  "params": [
    {
      "name": "num1",
      "type": "string"
    },
    {
      "name": "num2",
      "type": "string"
    },
    {
      "name": "min_sum",
      "type": "int"
    },
    {
      "name": "max_sum",
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
        "1",
        "12",
        1,
        8
      ],
      "expected": 11
    },
    {
      "args": [
        "1",
        "5",
        1,
        5
      ],
      "expected": 5
    },
    {
      "args": [
        "10",
        "20",
        2,
        3
      ],
      "expected": 3
    },
    {
      "args": [
        "1",
        "100",
        1,
        8
      ],
      "expected": 45
    }
  ]
}$json$::jsonb,
    $json$[
  {
    "args": [
      "1",
      "1",
      1,
      1
    ],
    "expected": 1
  },
  {
    "args": [
      "1",
      "1",
      2,
      2
    ],
    "expected": 0
  },
  {
    "args": [
      "100",
      "200",
      1,
      5
    ],
    "expected": 16
  },
  {
    "args": [
      "1",
      "1000",
      10,
      12
    ],
    "expected": 205
  },
  {
    "args": [
      "999",
      "1001",
      27,
      27
    ],
    "expected": 1
  },
  {
    "args": [
      "1",
      "1000000",
      1,
      10
    ],
    "expected": 8002
  }
]$json$::jsonb,
    'approved'
),
(
    2098,
    '收集树中金币',
    '给定一棵包含 n 个节点的无向树，节点编号为 0 到 n-1
边数组为 edges，长度为 n-1
数组 coins 中 coins[i] 为 1 表示节点 i 有一枚金币，为 0 表示没有
初始时可以选择任意节点作为起点
每次操作可以收集距离当前节点不超过 2 的所有金币，或移动到相邻节点
返回收集完所有金币并回到起点所需经过的最少边数
同一条边每经过一次都计入答案',
    'hard',
    1000,
    256,
    ARRAY['树', '广度优先搜索', '拓扑排序'],
    $json$[
  {
    "input": "coins = [1, 0, 0, 0, 0, 1], edges = [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]]",
    "output": "2"
  },
  {
    "input": "coins = [0, 0, 0, 1, 1, 0, 0, 1], edges = [[0, 1], [0, 2], [1, 3], [1, 4], [2, 5], [5, 6], [5, 7]]",
    "output": "2"
  },
  {
    "input": "coins = [1], edges = []",
    "output": "0"
  },
  {
    "input": "coins = [0, 1], edges = [[0, 1]]",
    "output": "0"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "coins = [1, 0, 0, 0, 0, 1], edges = [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]]",
    "output": "2"
  },
  {
    "input": "coins = [0, 0, 0, 1, 1, 0, 0, 1], edges = [[0, 1], [0, 2], [1, 3], [1, 4], [2, 5], [5, 6], [5, 7]]",
    "output": "2"
  },
  {
    "input": "coins = [1], edges = []",
    "output": "0"
  },
  {
    "input": "coins = [0, 1], edges = [[0, 1]]",
    "output": "0"
  }
]$json$::jsonb,
    $json${
  "javascript": "var collectCoinsInTree = function(coins, edges) {\n};\n",
  "python": "class Solution:\n    def collectCoinsInTree(self, coins: list[int], edges: list[list[int]]) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int collectCoinsInTree(std::vector<int>& coins, std::vector<std::vector<int>>& edges) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int collectCoinsInTree(int[] coins, int[][] edges) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "collectCoinsInTree",
  "params": [
    {
      "name": "coins",
      "type": "int[]"
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
        [
          1,
          0,
          0,
          0,
          0,
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
    },
    {
      "args": [
        [
          0,
          0,
          0,
          1,
          1,
          0,
          0,
          1
        ],
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
            5,
            6
          ],
          [
            5,
            7
          ]
        ]
      ],
      "expected": 2
    },
    {
      "args": [
        [
          1
        ],
        []
      ],
      "expected": 0
    },
    {
      "args": [
        [
          0,
          1
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
        0,
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
        0,
        0,
        0,
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
      [
        1,
        0,
        0,
        0,
        0,
        0,
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
    "expected": 4
  },
  {
    "args": [
      [
        0,
        0,
        0,
        1
      ],
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
    "expected": 0
  },
  {
    "args": [
      [
        0,
        0,
        1,
        0
      ],
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
    "expected": 0
  },
  {
    "args": [
      [
        1,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
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
        ],
        [
          6,
          7
        ],
        [
          7,
          8
        ]
      ]
    ],
    "expected": 8
  }
]$json$::jsonb,
    'approved'
),
(
    2099,
    '长度可被 K 整除的最大子数组和',
    '给定整数数组 nums 和正整数 k
求一个非空连续子数组的最大和，要求子数组长度能被 k 整除
保证至少存在一个长度能被 k 整除的子数组',
    'hard',
    1000,
    256,
    ARRAY['数组', '前缀和', '动态规划'],
    $json$[
  {
    "input": "nums = [1, 2], k = 1",
    "output": "3"
  },
  {
    "input": "nums = [-1, -2, -3, -4, -5], k = 4",
    "output": "-10"
  },
  {
    "input": "nums = [5, -2, 3, 1], k = 2",
    "output": "7"
  }
]$json$::jsonb,
    $json$[
  {
    "input": "nums = [1, 2], k = 1",
    "output": "3"
  },
  {
    "input": "nums = [-1, -2, -3, -4, -5], k = 4",
    "output": "-10"
  },
  {
    "input": "nums = [5, -2, 3, 1], k = 2",
    "output": "7"
  }
]$json$::jsonb,
    $json${
  "javascript": "var maxSubarraySumDivisibleByK = function(nums, k) {\n};\n",
  "python": "class Solution:\n    def maxSubarraySumDivisibleByK(self, nums: list[int], k: int) -> int:\n        pass\n",
  "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxSubarraySumDivisibleByK(std::vector<int>& nums, int k) {\n        return 0;\n    }\n};\n",
  "java": "class Solution {\n    public int maxSubarraySumDivisibleByK(int[] nums, int k) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
  "version": 1,
  "function_name": "maxSubarraySumDivisibleByK",
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
          2
        ],
        1
      ],
      "expected": 3
    },
    {
      "args": [
        [
          -1,
          -2,
          -3,
          -4,
          -5
        ],
        4
      ],
      "expected": -10
    },
    {
      "args": [
        [
          5,
          -2,
          3,
          1
        ],
        2
      ],
      "expected": 7
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
      5
    ],
    "expected": 15
  },
  {
    "args": [
      [
        -5,
        -3,
        -1
      ],
      2
    ],
    "expected": -4
  },
  {
    "args": [
      [
        2,
        -1,
        2
      ],
      3
    ],
    "expected": 3
  },
  {
    "args": [
      [
        1,
        -2,
        3,
        -4,
        5,
        -6
      ],
      2
    ],
    "expected": 2
  },
  {
    "args": [
      [
        10,
        -10,
        10,
        -10
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
        -1,
        -1
      ],
      3
    ],
    "expected": -3
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
    GREATEST((SELECT COALESCE(MAX(id), 1) FROM problems), 2099)
);

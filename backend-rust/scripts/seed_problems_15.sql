-- 仅用于本地/测试环境的题目种子数据。
-- 使用固定 ID 1101-1115，便于通过 clean_dev.sql 安全清理。
-- 全部题目使用 run_config + 隐藏 judge_cases，可被 judge_worker 直接评测。

INSERT INTO problems (
    id, title, description, difficulty, time_limit, memory_limit, tags,
    examples, test_cases, code_template, run_config, judge_cases, review_status
) VALUES
(
    1101,
    '回文数',
    '给你一个整数 x，如果 x 是一个回文整数，返回 true；否则，返回 false。

回文数是指正序（从左向右）和倒序（从右向左）读都是一样的整数。例如，121 是回文数，而 123 不是。

-2^31 <= x <= 2^31 - 1',
    'easy',
    1000,
    256,
    ARRAY['数学'],
    $json$[
    {
        "input": "x = 121",
        "output": "true",
        "explanation": "从左向右和从右向左读都是 121。"
    },
    {
        "input": "x = -121",
        "output": "false",
        "explanation": "从左向右读为 -121，从右向左读为 121-，因此不是回文数。"
    },
    {
        "input": "x = 10",
        "output": "false",
        "explanation": "从右向左读为 01，因此不是回文数。"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "x = 121",
        "output": "true"
    },
    {
        "input": "x = -121",
        "output": "false"
    },
    {
        "input": "x = 10",
        "output": "false"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def isPalindrome(self, x: int) -> bool:\n        pass\n",
    "javascript": "var isPalindrome = function(x) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isPalindrome(int x) {\n        return false;\n    }\n};\n",
    "java": "class Solution {\n    public boolean isPalindrome(int x) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "isPalindrome",
    "params": [
        {
            "name": "x",
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
                121
            ],
            "expected": true
        },
        {
            "args": [
                -121
            ],
            "expected": false
        },
        {
            "args": [
                10
            ],
            "expected": false
        },
        {
            "args": [
                0
            ],
            "expected": true
        }
    ]
}$json$::jsonb,
    $json$[
    {
        "args": [
            12321
        ],
        "expected": true
    },
    {
        "args": [
            1000021
        ],
        "expected": false
    },
    {
        "args": [
            2147447412
        ],
        "expected": true
    },
    {
        "args": [
            1001
        ],
        "expected": true
    },
    {
        "args": [
            -1
        ],
        "expected": false
    }
]$json$::jsonb,
    'approved'
),
(
    1102,
    '有效的括号',
    '给定一个只包括 ''(''、'')''、''{''、''}''、''[''、'']'' 的字符串 s，判断字符串是否有效。

有效字符串需要满足：左括号必须用相同类型的右括号闭合；左括号必须以正确的顺序闭合；每个右括号都有一个对应的相同类型的左括号。

0 <= s.length <= 10^4',
    'easy',
    1000,
    256,
    ARRAY['栈', '字符串'],
    $json$[
    {
        "input": "s = \"()\"",
        "output": "true"
    },
    {
        "input": "s = \"()[]{}\"",
        "output": "true"
    },
    {
        "input": "s = \"(]\"",
        "output": "false"
    },
    {
        "input": "s = \"([])\"",
        "output": "true"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "s = \"()\"",
        "output": "true"
    },
    {
        "input": "s = \"()[]{}\"",
        "output": "true"
    },
    {
        "input": "s = \"(]\"",
        "output": "false"
    },
    {
        "input": "s = \"([])\"",
        "output": "true"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def isValid(self, s: str) -> bool:\n        pass\n",
    "javascript": "var isValid = function(s) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    bool isValid(std::string s) {\n        return false;\n    }\n};\n",
    "java": "class Solution {\n    public boolean isValid(String s) {\n        return false;\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "isValid",
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
                "()[]{}"
            ],
            "expected": true
        },
        {
            "args": [
                "(]"
            ],
            "expected": false
        },
        {
            "args": [
                "([])"
            ],
            "expected": true
        },
        {
            "args": [
                ""
            ],
            "expected": true
        }
    ]
}$json$::jsonb,
    $json$[
    {
        "args": [
            "([)]"
        ],
        "expected": false
    },
    {
        "args": [
            "]"
        ],
        "expected": false
    },
    {
        "args": [
            "{[()]}"
        ],
        "expected": true
    },
    {
        "args": [
            "((("
        ],
        "expected": false
    },
    {
        "args": [
            "{[]}"
        ],
        "expected": true
    }
]$json$::jsonb,
    'approved'
),
(
    1103,
    '最长公共前缀',
    '编写一个函数来查找字符串数组中的最长公共前缀。如果不存在公共前缀，返回空字符串。

0 <= strs.length <= 200
0 <= strs[i].length <= 200
strs[i] 仅由小写英文字母组成',
    'easy',
    1000,
    256,
    ARRAY['字符串'],
    $json$[
    {
        "input": "strs = [\"flower\", \"flow\", \"flight\"]",
        "output": "\"fl\""
    },
    {
        "input": "strs = [\"dog\", \"racecar\", \"car\"]",
        "output": "\"\""
    },
    {
        "input": "strs = [\"a\"]",
        "output": "\"a\""
    }
]$json$::jsonb,
    $json$[
    {
        "input": "strs = [\"flower\", \"flow\", \"flight\"]",
        "output": "\"fl\""
    },
    {
        "input": "strs = [\"dog\", \"racecar\", \"car\"]",
        "output": "\"\""
    },
    {
        "input": "strs = [\"a\"]",
        "output": "\"a\""
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def longestCommonPrefix(self, strs: list[str]) -> str:\n        pass\n",
    "javascript": "var longestCommonPrefix = function(strs) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::string longestCommonPrefix(std::vector<std::string>& strs) {\n        return \"\";\n    }\n};\n",
    "java": "class Solution {\n    public String longestCommonPrefix(String[] strs) {\n        return \"\";\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "longestCommonPrefix",
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
                    "flower",
                    "flow",
                    "flight"
                ]
            ],
            "expected": "fl"
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
        },
        {
            "args": [
                [
                    "a"
                ]
            ],
            "expected": "a"
        },
        {
            "args": [
                [
                    "",
                    "b"
                ]
            ],
            "expected": ""
        },
        {
            "args": [
                [
                    "ab",
                    "a"
                ]
            ],
            "expected": "a"
        }
    ]
}$json$::jsonb,
    $json$[
    {
        "args": [
            [
                "abc",
                "abc",
                "abc"
            ]
        ],
        "expected": "abc"
    },
    {
        "args": [
            [
                "prefix",
                "pre",
                "pref"
            ]
        ],
        "expected": "pre"
    },
    {
        "args": [
            [
                "a",
                "b"
            ]
        ],
        "expected": ""
    },
    {
        "args": [
            [
                "",
                ""
            ]
        ],
        "expected": ""
    },
    {
        "args": [
            []
        ],
        "expected": ""
    }
]$json$::jsonb,
    'approved'
),
(
    1104,
    '移动零',
    '给定一个数组 nums，编写一个函数将所有 0 移动到数组的末尾，同时保持非零元素的相对顺序。请返回移动后的数组。

1 <= nums.length <= 10^4
-2^31 <= nums[i] <= 2^31 - 1',
    'easy',
    1000,
    256,
    ARRAY['数组', '双指针'],
    $json$[
    {
        "input": "nums = [0, 1, 0, 3, 12]",
        "output": "[1, 3, 12, 0, 0]"
    },
    {
        "input": "nums = [0]",
        "output": "[0]"
    },
    {
        "input": "nums = [1]",
        "output": "[1]"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "nums = [0, 1, 0, 3, 12]",
        "output": "[1, 3, 12, 0, 0]"
    },
    {
        "input": "nums = [0]",
        "output": "[0]"
    },
    {
        "input": "nums = [1]",
        "output": "[1]"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def moveZeroes(self, nums: list[int]) -> list[int]:\n        pass\n",
    "javascript": "var moveZeroes = function(nums) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> moveZeroes(std::vector<int>& nums) {\n        return {};\n    }\n};\n",
    "java": "class Solution {\n    public int[] moveZeroes(int[] nums) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "moveZeroes",
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
                    0,
                    1,
                    0,
                    3,
                    12
                ]
            ],
            "expected": [
                1,
                3,
                12,
                0,
                0
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
                    1
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
                -1,
                0,
                -2
            ]
        ],
        "expected": [
            -1,
            -2,
            0
        ]
    },
    {
        "args": [
            [
                0,
                -1,
                0,
                3,
                0
            ]
        ],
        "expected": [
            -1,
            3,
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
                2
            ]
        ],
        "expected": [
            1,
            2,
            0,
            0
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
    }
]$json$::jsonb,
    'approved'
),
(
    1105,
    '只出现一次的数字',
    '给你一个非空整数数组 nums，除了某个元素只出现一次以外，其余每个元素均出现两次。找出那个只出现了一次的元素。

1 <= nums.length <= 3 * 10^4
-3 * 10^4 <= nums[i] <= 3 * 10^4',
    'easy',
    1000,
    256,
    ARRAY['位运算', '数组'],
    $json$[
    {
        "input": "nums = [2, 2, 1]",
        "output": "1"
    },
    {
        "input": "nums = [4, 1, 2, 1, 2]",
        "output": "4"
    },
    {
        "input": "nums = [1]",
        "output": "1"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "nums = [2, 2, 1]",
        "output": "1"
    },
    {
        "input": "nums = [4, 1, 2, 1, 2]",
        "output": "4"
    },
    {
        "input": "nums = [1]",
        "output": "1"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def singleNumber(self, nums: list[int]) -> int:\n        pass\n",
    "javascript": "var singleNumber = function(nums) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int singleNumber(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
    "java": "class Solution {\n    public int singleNumber(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "singleNumber",
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
                    1
                ]
            ],
            "expected": 1
        },
        {
            "args": [
                [
                    4,
                    1,
                    2,
                    1,
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
        }
    ]
}$json$::jsonb,
    $json$[
    {
        "args": [
            [
                7,
                3,
                7
            ]
        ],
        "expected": 3
    },
    {
        "args": [
            [
                -1,
                -1,
                -2
            ]
        ],
        "expected": -2
    },
    {
        "args": [
            [
                0,
                0,
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
                2
            ]
        ],
        "expected": 1
    },
    {
        "args": [
            [
                -30000,
                30000,
                -30000
            ]
        ],
        "expected": 30000
    }
]$json$::jsonb,
    'approved'
),
(
    1106,
    '反转链表',
    '给你单链表的头节点 head，请你反转链表，并返回反转后的链表。

链表在输入和输出中用数组表示，空链表用 [] 表示。

0 <= 链表节点数 <= 5000
-5000 <= Node.val <= 5000',
    'easy',
    1000,
    256,
    ARRAY['链表', '递归'],
    $json$[
    {
        "input": "head = [1, 2, 3, 4, 5]",
        "output": "[5, 4, 3, 2, 1]"
    },
    {
        "input": "head = [1, 2]",
        "output": "[2, 1]"
    },
    {
        "input": "head = []",
        "output": "[]"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "head = [1, 2, 3, 4, 5]",
        "output": "[5, 4, 3, 2, 1]"
    },
    {
        "input": "head = [1, 2]",
        "output": "[2, 1]"
    },
    {
        "input": "head = []",
        "output": "[]"
    }
]$json$::jsonb,
    $json${
    "python": "class ListNode:\n    def __init__(self, val: int = 0, next: \"ListNode | None\" = None):\n        self.val = val\n        self.next = next\n\n\nclass TreeNode:\n    def __init__(\n        self,\n        val: int = 0,\n        left: \"TreeNode | None\" = None,\n        right: \"TreeNode | None\" = None,\n    ):\n        self.val = val\n        self.left = left\n        self.right = right\n\n\nclass Solution:\n    def reverseList(self, head: ListNode | None) -> ListNode | None:\n        pass\n",
    "javascript": "function ListNode(val, next) {\n  this.val = val === undefined ? 0 : val;\n  this.next = next === undefined ? null : next;\n}\n\nfunction TreeNode(val, left, right) {\n  this.val = val === undefined ? 0 : val;\n  this.left = left === undefined ? null : left;\n  this.right = right === undefined ? null : right;\n}\n\nvar reverseList = function(head) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\n#ifndef THESEUS_LIST_NODE_DEFINED\n#define THESEUS_LIST_NODE_DEFINED\nstruct ListNode {\n    int val;\n    ListNode* next;\n    ListNode() : val(0), next(nullptr) {}\n    explicit ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode* next) : val(x), next(next) {}\n};\n#endif\n\n#ifndef THESEUS_TREE_NODE_DEFINED\n#define THESEUS_TREE_NODE_DEFINED\nstruct TreeNode {\n    int val;\n    TreeNode* left;\n    TreeNode* right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}\n};\n#endif\n\nclass Solution {\npublic:\n    ListNode* reverseList(ListNode* head) {\n        return nullptr;\n    }\n};\n",
    "java": "class ListNode {\n    int val;\n    ListNode next;\n    ListNode() {}\n    ListNode(int val) { this.val = val; }\n    ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n}\n\nclass TreeNode {\n    int val;\n    TreeNode left;\n    TreeNode right;\n    TreeNode() {}\n    TreeNode(int val) { this.val = val; }\n    TreeNode(int val, TreeNode left, TreeNode right) {\n        this.val = val;\n        this.left = left;\n        this.right = right;\n    }\n}\n\nclass Solution {\n    public ListNode reverseList(ListNode head) {\n        return null;\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "reverseList",
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
            3,
            2,
            1
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
        "expected": [
            7,
            7,
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
                6
            ]
        ],
        "expected": [
            6,
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
                -1,
                0,
                1
            ]
        ],
        "expected": [
            1,
            0,
            -1
        ]
    }
]$json$::jsonb,
    'approved'
),
(
    1107,
    '最大子数组和',
    '给你一个整数数组 nums，请你找出一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。

1 <= nums.length <= 10^5
-10^4 <= nums[i] <= 10^4',
    'medium',
    1000,
    256,
    ARRAY['数组', '动态规划', '分治'],
    $json$[
    {
        "input": "nums = [-2, 1, -3, 4, -1, 2, 1, -5, 4]",
        "output": "6",
        "explanation": "连续子数组 [4, -1, 2, 1] 的和最大，为 6。"
    },
    {
        "input": "nums = [1]",
        "output": "1"
    },
    {
        "input": "nums = [5, 4, -1, 7, 8]",
        "output": "23",
        "explanation": "整个数组的和最大，为 23。"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "nums = [-2, 1, -3, 4, -1, 2, 1, -5, 4]",
        "output": "6"
    },
    {
        "input": "nums = [1]",
        "output": "1"
    },
    {
        "input": "nums = [5, 4, -1, 7, 8]",
        "output": "23"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def maxSubArray(self, nums: list[int]) -> int:\n        pass\n",
    "javascript": "var maxSubArray = function(nums) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxSubArray(std::vector<int>& nums) {\n        return 0;\n    }\n};\n",
    "java": "class Solution {\n    public int maxSubArray(int[] nums) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "maxSubArray",
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
                    5,
                    4,
                    -1,
                    7,
                    8
                ]
            ],
            "expected": 23
        }
    ]
}$json$::jsonb,
    $json$[
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
                -3,
                -2,
                -5
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
                1,
                -1,
                1
            ]
        ],
        "expected": 1
    },
    {
        "args": [
            [
                -2,
                -1
            ]
        ],
        "expected": -1
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
        "expected": 21
    }
]$json$::jsonb,
    'approved'
),
(
    1108,
    '轮转数组',
    '给定一个整数数组 nums，将数组中的元素向右轮转 k 个位置，其中 k 是非负数。请返回轮转后的数组。

1 <= nums.length <= 10^5
0 <= k <= 10^5
-2^31 <= nums[i] <= 2^31 - 1',
    'medium',
    1000,
    256,
    ARRAY['数组', '数学', '双指针'],
    $json$[
    {
        "input": "nums = [1, 2, 3, 4, 5, 6, 7], k = 3",
        "output": "[5, 6, 7, 1, 2, 3, 4]"
    },
    {
        "input": "nums = [-1, -100, 3, 99], k = 2",
        "output": "[3, 99, -1, -100]"
    },
    {
        "input": "nums = [1], k = 0",
        "output": "[1]"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "nums = [1, 2, 3, 4, 5, 6, 7], k = 3",
        "output": "[5, 6, 7, 1, 2, 3, 4]"
    },
    {
        "input": "nums = [-1, -100, 3, 99], k = 2",
        "output": "[3, 99, -1, -100]"
    },
    {
        "input": "nums = [1], k = 0",
        "output": "[1]"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def rotate(self, nums: list[int], k: int) -> list[int]:\n        pass\n",
    "javascript": "var rotate = function(nums, k) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> rotate(std::vector<int>& nums, int k) {\n        return {};\n    }\n};\n",
    "java": "class Solution {\n    public int[] rotate(int[] nums, int k) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "rotate",
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
                    3,
                    4,
                    5,
                    6,
                    7
                ],
                3
            ],
            "expected": [
                5,
                6,
                7,
                1,
                2,
                3,
                4
            ]
        },
        {
            "args": [
                [
                    -1,
                    -100,
                    3,
                    99
                ],
                2
            ],
            "expected": [
                3,
                99,
                -1,
                -100
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
                0,
                0,
                1
            ],
            2
        ],
        "expected": [
            0,
            1,
            0
        ]
    },
    {
        "args": [
            [
                1
            ],
            100
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
    }
]$json$::jsonb,
    'approved'
),
(
    1109,
    '搜索旋转排序数组',
    '整数数组 nums 按升序排列，数组中的值互不相同。数组在某个下标处经过旋转。给你旋转后的数组 nums 和一个整数 target，如果 nums 中存在这个目标值 target，则返回它的下标，否则返回 -1。

1 <= nums.length <= 5000
-10^4 <= nums[i], target <= 10^4
nums 中的每个值都独一无二',
    'medium',
    1000,
    256,
    ARRAY['数组', '二分查找'],
    $json$[
    {
        "input": "nums = [4, 5, 6, 7, 0, 1, 2], target = 0",
        "output": "4"
    },
    {
        "input": "nums = [4, 5, 6, 7, 0, 1, 2], target = 3",
        "output": "-1"
    },
    {
        "input": "nums = [1], target = 0",
        "output": "-1"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "nums = [4, 5, 6, 7, 0, 1, 2], target = 0",
        "output": "4"
    },
    {
        "input": "nums = [4, 5, 6, 7, 0, 1, 2], target = 3",
        "output": "-1"
    },
    {
        "input": "nums = [1], target = 0",
        "output": "-1"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def search(self, nums: list[int], target: int) -> int:\n        pass\n",
    "javascript": "var search = function(nums, target) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int search(std::vector<int>& nums, int target) {\n        return 0;\n    }\n};\n",
    "java": "class Solution {\n    public int search(int[] nums, int target) {\n        return 0;\n    }\n}\n"
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
                    6,
                    7,
                    0,
                    1,
                    2
                ],
                0
            ],
            "expected": 4
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
            1
        ],
        "expected": 0
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
            ],
            4
        ],
        "expected": 0
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
                3
            ],
            5
        ],
        "expected": 0
    },
    {
        "args": [
            [
                3,
                1
            ],
            1
        ],
        "expected": 1
    }
]$json$::jsonb,
    'approved'
),
(
    1110,
    '合并区间',
    '以数组 intervals 表示若干个区间的集合，其中单个区间为 intervals[i] = [start_i, end_i]。请合并所有重叠的区间，并返回一个不重叠的区间数组，该数组需恰好覆盖输入中的所有区间。返回结果按区间起始位置升序排列。

1 <= intervals.length <= 10^4
intervals[i].length == 2
0 <= start_i <= end_i <= 10^4',
    'medium',
    1000,
    256,
    ARRAY['数组', '排序'],
    $json$[
    {
        "input": "intervals = [[1, 3], [2, 6], [8, 10], [15, 18]]",
        "output": "[[1, 6], [8, 10], [15, 18]]",
        "explanation": "区间 [1, 3] 和 [2, 6] 重叠，合并为 [1, 6]。"
    },
    {
        "input": "intervals = [[1, 4], [4, 5]]",
        "output": "[[1, 5]]",
        "explanation": "相邻区间在端点处重叠，也需要合并。"
    },
    {
        "input": "intervals = [[1, 4], [0, 4]]",
        "output": "[[0, 4]]"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "intervals = [[1, 3], [2, 6], [8, 10], [15, 18]]",
        "output": "[[1, 6], [8, 10], [15, 18]]"
    },
    {
        "input": "intervals = [[1, 4], [4, 5]]",
        "output": "[[1, 5]]"
    },
    {
        "input": "intervals = [[1, 4], [0, 4]]",
        "output": "[[0, 4]]"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def merge(self, intervals: list[list[int]]) -> list[list[int]]:\n        pass\n",
    "javascript": "var merge = function(intervals) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<std::vector<int>> merge(std::vector<std::vector<int>>& intervals) {\n        return {};\n    }\n};\n",
    "java": "class Solution {\n    public int[][] merge(int[][] intervals) {\n        return new int[][]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "merge",
    "params": [
        {
            "name": "intervals",
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
                        3
                    ],
                    [
                        2,
                        6
                    ],
                    [
                        8,
                        10
                    ],
                    [
                        15,
                        18
                    ]
                ]
            ],
            "expected": [
                [
                    1,
                    6
                ],
                [
                    8,
                    10
                ],
                [
                    15,
                    18
                ]
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
                        4,
                        5
                    ]
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
                        4
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
                ]
            ]
        ],
        "expected": [
            [
                1,
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
        "expected": [
            [
                0,
                0
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
                ],
                [
                    8,
                    9
                ],
                [
                    1,
                    10
                ]
            ]
        ],
        "expected": [
            [
                1,
                10
            ]
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
                    0,
                    2
                ],
                [
                    3,
                    5
                ]
            ]
        ],
        "expected": [
            [
                0,
                5
            ]
        ]
    }
]$json$::jsonb,
    'approved'
),
(
    1111,
    '螺旋矩阵',
    '给你一个 m 行 n 列的矩阵 matrix，请按照顺时针螺旋顺序，返回矩阵中的所有元素。

m == matrix.length
n == matrix[i].length
1 <= m, n <= 10
-100 <= matrix[i][j] <= 100',
    'medium',
    1000,
    256,
    ARRAY['数组', '矩阵', '模拟'],
    $json$[
    {
        "input": "matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]",
        "output": "[1, 2, 3, 6, 9, 8, 7, 4, 5]"
    },
    {
        "input": "matrix = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]",
        "output": "[1, 2, 3, 4, 8, 12, 11, 10, 9, 5, 6, 7]"
    },
    {
        "input": "matrix = [[1]]",
        "output": "[1]"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]",
        "output": "[1, 2, 3, 6, 9, 8, 7, 4, 5]"
    },
    {
        "input": "matrix = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]",
        "output": "[1, 2, 3, 4, 8, 12, 11, 10, 9, 5, 6, 7]"
    },
    {
        "input": "matrix = [[1]]",
        "output": "[1]"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def spiralOrder(self, matrix: list[list[int]]) -> list[int]:\n        pass\n",
    "javascript": "var spiralOrder = function(matrix) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    std::vector<int> spiralOrder(std::vector<std::vector<int>>& matrix) {\n        return {};\n    }\n};\n",
    "java": "class Solution {\n    public int[] spiralOrder(int[][] matrix) {\n        return new int[]{};\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "spiralOrder",
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
                3,
                6,
                9,
                8,
                7,
                4,
                5
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
                    ]
                ]
            ],
            "expected": [
                1,
                2,
                3,
                4,
                8,
                12,
                11,
                10,
                9,
                5,
                6,
                7
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
                    3,
                    4
                ]
            ]
        ],
        "expected": [
            1,
            2,
            4,
            3
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
            1,
            2,
            3,
            6,
            5,
            4
        ]
    },
    {
        "args": [
            [
                [
                    2,
                    5
                ],
                [
                    8,
                    4
                ],
                [
                    0,
                    -1
                ]
            ]
        ],
        "expected": [
            2,
            5,
            4,
            -1,
            0,
            8
        ]
    }
]$json$::jsonb,
    'approved'
),
(
    1112,
    '岛屿数量',
    '给你一个由 1（陆地）和 0（水）组成的二维网格 grid，请你计算网格中岛屿的数量。

岛屿总是被水包围，并且每座岛屿只能由水平方向和/或竖直方向上相邻的陆地连接形成。此外，你可以假设该网格的四条边均被水包围。

本题用整数 1 表示陆地、0 表示水。

m == grid.length
n == grid[i].length
1 <= m, n <= 300
grid[i][j] 为 0 或 1',
    'medium',
    1000,
    256,
    ARRAY['深度优先搜索', '广度优先搜索', '并查集', '矩阵'],
    $json$[
    {
        "input": "grid = [[1, 1, 1, 1, 0], [1, 1, 0, 1, 0], [1, 1, 0, 0, 0], [0, 0, 0, 0, 0]]",
        "output": "1"
    },
    {
        "input": "grid = [[1, 1, 0, 0, 0], [1, 1, 0, 0, 0], [0, 0, 1, 0, 0], [0, 0, 0, 1, 1]]",
        "output": "3"
    },
    {
        "input": "grid = [[0]]",
        "output": "0"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "grid = [[1, 1, 1, 1, 0], [1, 1, 0, 1, 0], [1, 1, 0, 0, 0], [0, 0, 0, 0, 0]]",
        "output": "1"
    },
    {
        "input": "grid = [[1, 1, 0, 0, 0], [1, 1, 0, 0, 0], [0, 0, 1, 0, 0], [0, 0, 0, 1, 1]]",
        "output": "3"
    },
    {
        "input": "grid = [[0]]",
        "output": "0"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def numIslands(self, grid: list[list[int]]) -> int:\n        pass\n",
    "javascript": "var numIslands = function(grid) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int numIslands(std::vector<std::vector<int>>& grid) {\n        return 0;\n    }\n};\n",
    "java": "class Solution {\n    public int numIslands(int[][] grid) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "numIslands",
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
            "expected": 1
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
                    1,
                    0,
                    1,
                    0,
                    1
                ]
            ]
        ],
        "expected": 3
    }
]$json$::jsonb,
    'approved'
),
(
    1113,
    '接雨水',
    '给定 n 个非负整数表示每个宽度为 1 的柱子的高度图，计算按此排列的柱子，下雨之后能接多少雨水。

0 <= n <= 2 * 10^4
0 <= height[i] <= 10^5',
    'hard',
    1000,
    256,
    ARRAY['栈', '数组', '双指针', '动态规划'],
    $json$[
    {
        "input": "height = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]",
        "output": "6",
        "explanation": "柱子之间可以接住 6 个单位的雨水。"
    },
    {
        "input": "height = [4, 2, 0, 3, 2, 5]",
        "output": "9"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "height = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]",
        "output": "6"
    },
    {
        "input": "height = [4, 2, 0, 3, 2, 5]",
        "output": "9"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def trap(self, height: list[int]) -> int:\n        pass\n",
    "javascript": "var trap = function(height) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int trap(std::vector<int>& height) {\n        return 0;\n    }\n};\n",
    "java": "class Solution {\n    public int trap(int[] height) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "trap",
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
                    0,
                    1,
                    0,
                    2,
                    1,
                    0,
                    1,
                    3,
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
                    4,
                    2,
                    0,
                    3,
                    2,
                    5
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
                3
            ]
        ],
        "expected": 0
    },
    {
        "args": [
            [
                2,
                0,
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
                0
            ]
        ],
        "expected": 0
    }
]$json$::jsonb,
    'approved'
),
(
    1114,
    '编辑距离',
    '给你两个单词 word1 和 word2，请返回将 word1 转换成 word2 所使用的最少操作数。

你可以对一个单词进行如下三种操作：插入一个字符、删除一个字符、替换一个字符。

0 <= word1.length, word2.length <= 500
word1 和 word2 由小写英文字母组成',
    'hard',
    1000,
    256,
    ARRAY['字符串', '动态规划'],
    $json$[
    {
        "input": "word1 = \"horse\", word2 = \"ros\"",
        "output": "3",
        "explanation": "horse -> rorse（替换 h 为 r）-> rose（删除 r）-> ros（删除 e）。"
    },
    {
        "input": "word1 = \"intention\", word2 = \"execution\"",
        "output": "5"
    },
    {
        "input": "word1 = \"\", word2 = \"\"",
        "output": "0"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "word1 = \"horse\", word2 = \"ros\"",
        "output": "3"
    },
    {
        "input": "word1 = \"intention\", word2 = \"execution\"",
        "output": "5"
    },
    {
        "input": "word1 = \"\", word2 = \"\"",
        "output": "0"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def minDistance(self, word1: str, word2: str) -> int:\n        pass\n",
    "javascript": "var minDistance = function(word1, word2) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int minDistance(std::string word1, std::string word2) {\n        return 0;\n    }\n};\n",
    "java": "class Solution {\n    public int minDistance(String word1, String word2) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "minDistance",
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
                "horse",
                "ros"
            ],
            "expected": 3
        },
        {
            "args": [
                "intention",
                "execution"
            ],
            "expected": 5
        },
        {
            "args": [
                "",
                ""
            ],
            "expected": 0
        }
    ]
}$json$::jsonb,
    $json$[
    {
        "args": [
            "",
            "a"
        ],
        "expected": 1
    },
    {
        "args": [
            "a",
            ""
        ],
        "expected": 1
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
            "kitten",
            "sitting"
        ],
        "expected": 3
    },
    {
        "args": [
            "sunday",
            "saturday"
        ],
        "expected": 3
    }
]$json$::jsonb,
    'approved'
),
(
    1115,
    '最长有效括号',
    '给你一个只包含 ''('' 和 '')'' 的字符串，找出最长有效（格式正确且连续）括号子串的长度。

0 <= s.length <= 3 * 10^4
s[i] 为 ''('' 或 '')''',
    'hard',
    1000,
    256,
    ARRAY['栈', '字符串', '动态规划'],
    $json$[
    {
        "input": "s = \"(()\"",
        "output": "2",
        "explanation": "最长有效括号子串是 \"()\"。"
    },
    {
        "input": "s = \")()())\"",
        "output": "4",
        "explanation": "最长有效括号子串是 \"()()\"。"
    },
    {
        "input": "s = \"\"",
        "output": "0"
    }
]$json$::jsonb,
    $json$[
    {
        "input": "s = \"(()\"",
        "output": "2"
    },
    {
        "input": "s = \")()())\"",
        "output": "4"
    },
    {
        "input": "s = \"\"",
        "output": "0"
    }
]$json$::jsonb,
    $json${
    "python": "class Solution:\n    def longestValidParentheses(self, s: str) -> int:\n        pass\n",
    "javascript": "var longestValidParentheses = function(s) {\n};\n",
    "cpp": "#include <bits/stdc++.h>\nusing namespace std;\n\nclass Solution {\npublic:\n    int longestValidParentheses(std::string s) {\n        return 0;\n    }\n};\n",
    "java": "class Solution {\n    public int longestValidParentheses(String s) {\n        return 0;\n    }\n}\n"
}$json$::jsonb,
    $json${
    "version": 1,
    "function_name": "longestValidParentheses",
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
                "(()"
            ],
            "expected": 2
        },
        {
            "args": [
                ")()())"
            ],
            "expected": 4
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
            "()(()"
        ],
        "expected": 2
    },
    {
        "args": [
            "()(())"
        ],
        "expected": 6
    },
    {
        "args": [
            "(()())"
        ],
        "expected": 6
    },
    {
        "args": [
            "())"
        ],
        "expected": 2
    },
    {
        "args": [
            ")((()))("
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
    GREATEST((SELECT COALESCE(MAX(id), 1) FROM problems), 1115)
);

"""1146-1179：中等题（34 道）。"""

from __future__ import annotations

import math
from bisect import bisect_left, bisect_right

from problem_seed_common import Node, Problem, tree_from_list, tree_to_list

# ── 字符串 / 数组 ──────────────────────────────────────────────────


def multiply(num1: str, num2: str) -> str:
    return str(int(num1) * int(num2))


def add_two_numbers(l1: list[int], l2: list[int]) -> list[int]:
    value = int("".join(map(str, reversed(l1)))) + int("".join(map(str, reversed(l2))))
    return [int(digit) for digit in reversed(str(value))]


def merge_two_lists(list1: list[int], list2: list[int]) -> list[int]:
    return sorted(list1 + list2)


def remove_nth_from_end(head: list[int], n: int) -> list[int]:
    return head[: len(head) - n] + head[len(head) - n + 1 :]


def middle_node(head: list[int]) -> list[int]:
    return head[len(head) // 2 :]


def delete_duplicates(head: list[int]) -> list[int]:
    result: list[int] = []
    for value in head:
        if not result or result[-1] != value:
            result.append(value)
    return result


def is_palindrome_list(head: list[int]) -> bool:
    return head == head[::-1]


# ── 二叉树 ──────────────────────────────────────────────────────────


def max_depth(root: list[int | None]) -> int:
    node = tree_from_list(root)

    def depth(current: Node | None) -> int:
        if current is None:
            return 0
        return 1 + max(depth(current.left), depth(current.right))

    return depth(node)


def is_symmetric(root: list[int | None]) -> bool:
    node = tree_from_list(root)

    def mirror(left: Node | None, right: Node | None) -> bool:
        if left is None or right is None:
            return left is right
        return (
            left.value == right.value
            and mirror(left.left, right.right)
            and mirror(left.right, right.left)
        )

    return node is None or mirror(node.left, node.right)


def diameter_of_binary_tree(root: list[int | None]) -> int:
    node = tree_from_list(root)
    best = 0

    def depth(current: Node | None) -> int:
        nonlocal best
        if current is None:
            return 0
        left = depth(current.left)
        right = depth(current.right)
        best = max(best, left + right)
        return 1 + max(left, right)

    depth(node)
    return best


def has_path_sum(root: list[int | None], target_sum: int) -> bool:
    node = tree_from_list(root)

    def walk(current: Node | None, remaining: int) -> bool:
        if current is None:
            return False
        remaining -= current.value
        if current.left is None and current.right is None:
            return remaining == 0
        return walk(current.left, remaining) or walk(current.right, remaining)

    return walk(node, target_sum)


def invert_tree(root: list[int | None]) -> list[int | None]:
    node = tree_from_list(root)

    def invert(current: Node | None) -> Node | None:
        if current is None:
            return None
        current.left, current.right = invert(current.right), invert(current.left)
        return current

    return tree_to_list(invert(node))


def level_order(root: list[int | None]) -> list[list[int]]:
    node = tree_from_list(root)
    if node is None:
        return []
    result: list[list[int]] = []
    queue = [node]
    while queue:
        values = [current.value for current in queue]
        result.append(values)
        next_level: list[Node] = []
        for current in queue:
            if current.left is not None:
                next_level.append(current.left)
            if current.right is not None:
                next_level.append(current.right)
        queue = next_level
    return result


def inorder_traversal(root: list[int | None]) -> list[int]:
    node = tree_from_list(root)
    result: list[int] = []
    stack: list[Node] = []
    current = node
    while current is not None or stack:
        while current is not None:
            stack.append(current)
            current = current.left
        current = stack.pop()
        result.append(current.value)
        current = current.right
    return result


def is_valid_bst(root: list[int | None]) -> bool:
    node = tree_from_list(root)
    values = inorder_traversal(tree_to_list(node))
    return all(values[index] < values[index + 1] for index in range(len(values) - 1))


def kth_smallest(root: list[int | None], k: int) -> int:
    values = inorder_traversal(root)
    return values[k - 1]


# ── 网格 / 动态规划 ────────────────────────────────────────────────


def island_perimeter(grid: list[list[int]]) -> int:
    rows, columns = len(grid), len(grid[0])
    perimeter = 0
    for row in range(rows):
        for column in range(columns):
            if grid[row][column] != 1:
                continue
            perimeter += 4
            if row > 0 and grid[row - 1][column] == 1:
                perimeter -= 2
            if column > 0 and grid[row][column - 1] == 1:
                perimeter -= 2
    return perimeter


def maximal_square(matrix: list[list[int]]) -> int:
    rows, columns = len(matrix), len(matrix[0])
    dp = [[0] * (columns + 1) for _ in range(rows + 1)]
    best = 0
    for row in range(1, rows + 1):
        for column in range(1, columns + 1):
            if matrix[row - 1][column - 1] == 1:
                dp[row][column] = min(
                    dp[row - 1][column], dp[row][column - 1], dp[row - 1][column - 1]
                ) + 1
                best = max(best, dp[row][column])
    return best * best


def coin_change(coins: list[int], amount: int) -> int:
    unreachable = amount + 1
    dp = [0] + [unreachable] * amount
    for value in range(1, amount + 1):
        for coin in coins:
            if coin <= value:
                dp[value] = min(dp[value], dp[value - coin] + 1)
    return -1 if dp[amount] == unreachable else dp[amount]


def num_squares(n: int) -> int:
    dp = [0] * (n + 1)
    for value in range(1, n + 1):
        best = value
        square = 1
        while square * square <= value:
            best = min(best, dp[value - square * square] + 1)
            square += 1
        dp[value] = best
    return dp[n]


def length_of_lis(nums: list[int]) -> int:
    tails: list[int] = []
    for value in nums:
        position = bisect_left(tails, value)
        if position == len(tails):
            tails.append(value)
        else:
            tails[position] = value
    return len(tails)


def longest_common_subsequence(text1: str, text2: str) -> int:
    previous = [0] * (len(text2) + 1)
    for left in text1:
        current = [0]
        for index, right in enumerate(text2, start=1):
            if left == right:
                current.append(previous[index - 1] + 1)
            else:
                current.append(max(previous[index], current[index - 1]))
        previous = current
    return previous[-1]


def rob(nums: list[int]) -> int:
    two_back = one_back = 0
    for value in nums:
        two_back, one_back = one_back, max(one_back, two_back + value)
    return one_back


def max_profit_cooldown(prices: list[int]) -> int:
    if not prices:
        return 0
    hold = -prices[0]
    sold = 0
    rest = 0
    for price in prices[1:]:
        previous_hold, previous_sold, previous_rest = hold, sold, rest
        hold = max(previous_hold, previous_rest - price)
        sold = previous_hold + price
        rest = max(previous_rest, previous_sold)
    return max(sold, rest)


def max_product(nums: list[int]) -> int:
    best = current_max = current_min = nums[0]
    for value in nums[1:]:
        candidates = (value, current_max * value, current_min * value)
        current_max = max(candidates)
        current_min = min(candidates)
        best = max(best, current_max)
    return best


def can_partition(nums: list[int]) -> bool:
    total = sum(nums)
    if total % 2:
        return False
    target = total // 2
    reachable = {0}
    for value in nums:
        reachable |= {current + value for current in reachable if current + value <= target}
    return target in reachable


def word_break(s: str, word_dict: list[str]) -> bool:
    words = set(word_dict)
    reachable = [False] * (len(s) + 1)
    reachable[0] = True
    for end in range(1, len(s) + 1):
        for start in range(end):
            if reachable[start] and s[start:end] in words:
                reachable[end] = True
                break
    return reachable[-1]


def unique_paths(m: int, n: int) -> int:
    return math.comb(m + n - 2, n - 1)


def min_path_sum(grid: list[list[int]]) -> int:
    rows, columns = len(grid), len(grid[0])
    dp = [[0] * columns for _ in range(rows)]
    for row in range(rows):
        for column in range(columns):
            if row == 0 and column == 0:
                dp[row][column] = grid[row][column]
            elif row == 0:
                dp[row][column] = dp[row][column - 1] + grid[row][column]
            elif column == 0:
                dp[row][column] = dp[row - 1][column] + grid[row][column]
            else:
                dp[row][column] = (
                    min(dp[row - 1][column], dp[row][column - 1]) + grid[row][column]
                )
    return dp[-1][-1]


def num_decodings(s: str) -> int:
    if not s:
        return 0
    previous, current = 1, 0 if s[0] == "0" else 1
    for index in range(1, len(s)):
        next_value = 0
        if s[index] != "0":
            next_value += current
        if s[index - 1] == "1" or (s[index - 1] == "2" and s[index] <= "6"):
            next_value += previous
        previous, current = current, next_value
    return current


def rob_circle(nums: list[int]) -> int:
    if len(nums) == 1:
        return nums[0]
    return max(rob(nums[:-1]), rob(nums[1:]))


def max_profit_fee(prices: list[int], fee: int) -> int:
    cash = 0
    hold = -math.inf
    for price in prices:
        cash = max(cash, hold + price - fee)
        hold = max(hold, cash - price)
    return cash


def search_matrix(matrix: list[list[int]], target: int) -> bool:
    values = [value for row in matrix for value in row]
    position = bisect_left(values, target)
    return position < len(values) and values[position] == target


def search_range(nums: list[int], target: int) -> list[int]:
    left = bisect_left(nums, target)
    right = bisect_right(nums, target) - 1
    if left > right:
        return [-1, -1]
    return [left, right]


PROBLEMS = [
    Problem(
        pid=1146,
        title="字符串相乘",
        difficulty="medium",
        tags=["字符串", "数学", "模拟"],
        description="""给定两个以字符串形式表示的非负整数 num1 和 num2，返回它们的乘积，也用字符串表示。
不能使用任何内置的大整数库，也不能直接将输入转换为整数。

提示：
- 1 <= num1.length, num2.length <= 200
- num1 和 num2 只包含数字，且不含前导零（"0" 除外）""",
        function="multiply",
        params=[("num1", "string"), ("num2", "string")],
        returns="string",
        solver=multiply,
        public=[["2", "3"], ["123", "456"], ["0", "0"], ["9", "9"]],
        expected_public=["6", "56088", "0", "81"],
        hidden=[
            ["0", "123"], ["123", "0"], ["10", "10"], ["99", "99"],
            ["1", "1"], ["999", "999"], ["123456789", "987654321"],
            ["100", "200"], ["5", "12"], ["111", "111"], ["2", "0"],
            ["12", "34"],
        ],
    ),
    Problem(
        pid=1147,
        title="两数相加",
        difficulty="medium",
        tags=["链表", "数学", "递归"],
        description="""给定两个非空链表，表示两个非负整数。数字按逆序存储，每个节点只存储一位数字。
将两数相加并以相同形式返回一个表示和的链表。
可以假设除了数字 0 之外，这两个数都不会以 0 开头。

提示：
- 每个链表中的节点数在 1 到 100 之间
- 0 <= Node.val <= 9""",
        function="addTwoNumbers",
        params=[("l1", "ListNode"), ("l2", "ListNode")],
        returns="ListNode",
        solver=add_two_numbers,
        public=[
            [[2, 4, 3], [5, 6, 4]],
            [[0], [0]],
            [[9, 9, 9, 9, 9, 9, 9], [9, 9, 9, 9]],
            [[1], [9, 9]],
        ],
        expected_public=[
            [7, 0, 8],
            [0],
            [8, 9, 9, 9, 0, 0, 0, 1],
            [0, 0, 1],
        ],
        hidden=[
            [[5], [5]], [[1, 8], [0]], [[9], [1]], [[2, 4], [5, 6]],
            [[0], [1]], [[9, 9], [9, 9]], [[1, 2, 3], [4, 5, 6]],
            [[1], [9]], [[9, 9, 9], [1]], [[5], [5, 5, 5]],
        ],
    ),
    Problem(
        pid=1148,
        title="合并两个有序链表",
        difficulty="medium",
        tags=["链表", "递归"],
        description="""将两个升序链表合并为一个新的升序链表并返回。新链表由拼接给定两个链表的所有节点组成。

提示：
- 两个链表的节点数目范围是 [0, 50]
- -100 <= Node.val <= 100
- 两个链表均按非递减顺序排列""",
        function="mergeTwoLists",
        params=[("list1", "ListNode"), ("list2", "ListNode")],
        returns="ListNode",
        solver=merge_two_lists,
        public=[
            [[1, 2, 4], [1, 3, 4]],
            [[], []],
            [[], [0]],
            [[1], [2]],
        ],
        expected_public=[[1, 1, 2, 3, 4, 4], [], [0], [1, 2]],
        hidden=[
            [[-3, -1], [-2, 4]], [[1, 2, 3], []], [[], [1]], [[1, 1, 1], [1, 1]],
            [[-10, 10], [-5, 5]], [[5], [1, 2, 3, 4]], [[1, 3, 5], [2, 4, 6]],
            [[0], [0]], [[-1], [-2]], [[1, 2], [3, 4]],
        ],
    ),
    Problem(
        pid=1149,
        title="删除链表的倒数第 N 个结点",
        difficulty="medium",
        tags=["链表", "双指针"],
        description="""给定一个链表的头节点 head 和一个整数 n，删除链表的倒数第 n 个节点，并返回链表的头节点。

提示：
- 链表中节点数目为 sz
- 1 <= sz <= 30
- 0 <= Node.val <= 100
- 1 <= n <= sz""",
        function="removeNthFromEnd",
        params=[("head", "ListNode"), ("n", "int")],
        returns="ListNode",
        solver=remove_nth_from_end,
        public=[
            [[1, 2, 3, 4, 5], 2],
            [[1], 1],
            [[1, 2], 1],
            [[1, 2], 2],
        ],
        expected_public=[[1, 2, 3, 5], [], [1], [2]],
        hidden=[
            [[1, 2, 3], 1], [[1, 2, 3], 3], [[1, 2, 3, 4], 2],
            [[1, 2, 3, 4, 5], 5], [[0, 1], 2], [[5, 6, 7, 8], 3],
            [[9], 1], [[1, 2, 3, 4, 5, 6], 3],
        ],
    ),
    Problem(
        pid=1150,
        title="链表的中间结点",
        difficulty="medium",
        tags=["链表", "双指针"],
        description="""给定一个头节点为 head 的非空单链表，返回链表的中间节点。
如果有两个中间节点，则返回第二个中间节点。

提示：
- 链表中节点数目在 [1, 100] 范围内
- 1 <= Node.val <= 100""",
        function="middleNode",
        params=[("head", "ListNode")],
        returns="ListNode",
        solver=middle_node,
        public=[
            [[1, 2, 3, 4, 5]],
            [[1, 2, 3, 4, 5, 6]],
            [[1]],
            [[1, 2]],
        ],
        expected_public=[[3, 4, 5], [4, 5, 6], [1], [2]],
        hidden=[
            [[1, 2, 3]], [[1, 2, 3, 4]], [[1, 2, 3, 4, 5, 6, 7]],
            [[1, 2, 3, 4, 5, 6, 7, 8]], [[-1, -2]], [[1, 2, 3, 4, 5, 6, 7, 8, 9]],
            [[10, 20]], [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]],
        ],
    ),
    Problem(
        pid=1151,
        title="删除排序链表中的重复元素",
        difficulty="medium",
        tags=["链表"],
        description="""给定一个已排序的链表的头节点 head，删除所有重复的元素，使每个元素只出现一次。
返回已排序的链表。

提示：
- 链表中节点数目在 [0, 300] 范围内
- -100 <= Node.val <= 100
- 链表已按升序排列""",
        function="deleteDuplicates",
        params=[("head", "ListNode")],
        returns="ListNode",
        solver=delete_duplicates,
        public=[[[1, 1, 2]], [[1, 1, 2, 3, 3]], [[]], [[1]]],
        expected_public=[[1, 2], [1, 2, 3], [], [1]],
        hidden=[
            [[1, 1, 1]], [[1, 2, 3]], [[0, 0, 1, 1]], [[-3, -3, -2]],
            [[1, 2, 2, 2, 3, 3]], [[5, 5]], [[-1, 0, 0, 1]],
        ],
    ),
    Problem(
        pid=1152,
        title="回文链表",
        difficulty="medium",
        tags=["链表", "双指针", "栈", "递归"],
        description="""给定一个单链表的头节点 head，判断该链表是否为回文链表。
如果是，返回 true；否则返回 false。

提示：
- 链表中节点数目在 [1, 10^5] 范围内
- 0 <= Node.val <= 9""",
        function="isPalindromeList",
        params=[("head", "ListNode")],
        returns="bool",
        solver=is_palindrome_list,
        public=[[[1, 2, 2, 1]], [[1, 2]], [[1]], [[]]],
        expected_public=[True, False, True, True],
        hidden=[
            [[1, 1]], [[1, 2, 1]], [[1, 2, 3]], [[0, 0, 0]],
            [[-1, -1]], [[1, 2, 3, 2, 1]], [[1, 2, 3, 3, 2, 1]], [[1, 2, 3, 1]],
        ],
    ),
    Problem(
        pid=1153,
        title="二叉树的最大深度",
        difficulty="medium",
        tags=["二叉树", "深度优先搜索", "广度优先搜索"],
        description="""给定一个二叉树的根节点 root，返回它的最大深度。
最大深度是指从根节点到最远叶子节点的最长路径上的节点数。

提示：
- 树中节点的数目在 [0, 10^4] 范围内
- -100 <= Node.val <= 100""",
        function="maxDepth",
        params=[("root", "TreeNode")],
        returns="int",
        solver=max_depth,
        public=[
            [[3, 9, 20, None, None, 15, 7]],
            [[]],
            [[1]],
            [[1, 2, 3]],
        ],
        expected_public=[3, 0, 1, 2],
        hidden=[
            [[1, None, 2]], [[1, 2, None, 3]], [[1, 2, 3, 4, 5, 6, 7]],
            [[1, 2, 3, 4]], [[1, None, 2, None, 3]], [[1, 2, None, 3, None, 4]],
            [[0]], [[1, None, 2, 3]],
        ],
    ),
    Problem(
        pid=1154,
        title="对称二叉树",
        difficulty="medium",
        tags=["二叉树", "深度优先搜索", "广度优先搜索", "递归"],
        description="""给定一个二叉树的根节点 root，检查它是否轴对称。

提示：
- 树中节点数目在 [1, 1000] 范围内
- -100 <= Node.val <= 100""",
        function="isSymmetric",
        params=[("root", "TreeNode")],
        returns="bool",
        solver=is_symmetric,
        public=[
            [[1, 2, 2, 3, 4, 4, 3]],
            [[1, 2, 2, None, 3, None, 3]],
            [[1]],
            [[]],
        ],
        expected_public=[True, False, True, True],
        hidden=[
            [[1, 2, 2]], [[1, 2, 3]], [[1, 2, 2, None, 3, 3, None]],
            [[1, 2, 2, 3, None, None, 3]], [[1, 2, 2, 3, 4, 4, 3, 5, 6, 7, 8, 8, 7, 6, 5]],
            [[1, 2, 2, 3, 4, 4, 3, 5]],
            [[1, 2, 2, None, None, 2, 2]],
        ],
    ),
    Problem(
        pid=1155,
        title="二叉树的直径",
        difficulty="medium",
        tags=["二叉树", "深度优先搜索"],
        description="""给定一棵二叉树的根节点 root，返回该树的直径。
二叉树的直径是指任意两个节点之间最长路径的长度，这条路径可能经过也可能不经过根节点。
两个节点之间路径的长度由它们之间的边数表示。

提示：
- 树中节点数目在 [1, 10^4] 范围内
- -100 <= Node.val <= 100""",
        function="diameterOfBinaryTree",
        params=[("root", "TreeNode")],
        returns="int",
        solver=diameter_of_binary_tree,
        public=[
            [[1, 2, 3, 4, 5]],
            [[1, 2]],
            [[1]],
            [[1, 2, 3]],
        ],
        expected_public=[3, 1, 0, 2],
        hidden=[
            [[1, 2, 3, 4, 5, None, None]], [[1, 2, 3, 4, 5, 6, 7]],
            [[1, None, 2, 3]], [[1, 2, None, 3, 4]],
            [[1, 2, 3, None, 4, None, 5]], [[-1, -2, -3]],
        ],
    ),
    Problem(
        pid=1156,
        title="路径总和",
        difficulty="medium",
        tags=["二叉树", "深度优先搜索", "广度优先搜索"],
        description="""给定二叉树的根节点 root 和一个整数 targetSum，判断该树中是否存在根节点到叶子节点的路径，使这条路径上所有节点值之和等于 targetSum。
叶子节点是指没有子节点的节点。

提示：
- 树中节点的数目在 [0, 5000] 范围内
- -1000 <= Node.val, targetSum <= 1000""",
        function="hasPathSum",
        params=[("root", "TreeNode"), ("targetSum", "int")],
        returns="bool",
        solver=has_path_sum,
        public=[
            [[5, 4, 8, 11, None, 13, 4, 7, 2, None, None, None, 1], 22],
            [[], 0],
            [[1, 2, 3], 5],
            [[1, 2], 3],
        ],
        expected_public=[True, False, False, True],
        hidden=[
            [[1], 1], [[1], 0], [[1, 2], 1],
            [[1, -2, -3, 1, 3, -2, None, -1], -1],
            [[0, 1, 1], 1], [[0, 1, 1], 0], [[1, 2, None, 3], 6],
            [[1, 2, None, 3], 5], [[-2, None, -3], -5],
        ],
    ),
    Problem(
        pid=1157,
        title="翻转二叉树",
        difficulty="medium",
        tags=["二叉树", "深度优先搜索", "广度优先搜索"],
        description="""给定一棵二叉树的根节点 root，翻转这棵树，并返回其根节点。
翻转是指交换每个节点的左右子树。

提示：
- 树中节点数目在 [0, 100] 范围内
- -100 <= Node.val <= 100""",
        function="invertTree",
        params=[("root", "TreeNode")],
        returns="TreeNode",
        solver=invert_tree,
        public=[
            [[4, 2, 7, 1, 3, 6, 9]],
            [[2, 1, 3]],
            [[]],
            [[1]],
        ],
        expected_public=[
            [4, 7, 2, 9, 6, 3, 1],
            [2, 3, 1],
            [],
            [1],
        ],
        hidden=[
            [[1, 2]], [[1, None, 2]], [[1, 2, 3, 4]], [[3, 1, 2]],
            [[5, 4, 6, 2, None, 11, None]], [[1, 2, 3, 4, 5, 6, 7]],
        ],
    ),
    Problem(
        pid=1158,
        title="二叉树的层序遍历",
        difficulty="medium",
        tags=["二叉树", "广度优先搜索"],
        description="""给定二叉树的根节点 root，返回其节点值的层序遍历结果。
层序遍历指逐层地、从左到右访问所有节点，结果用二维数组表示。

提示：
- 树中节点数目在 [0, 2000] 范围内
- -1000 <= Node.val <= 1000""",
        function="levelOrder",
        params=[("root", "TreeNode")],
        returns="int[][]",
        solver=level_order,
        public=[
            [[3, 9, 20, None, None, 15, 7]],
            [[]],
            [[1]],
            [[1, 2, 3]],
        ],
        expected_public=[[[3], [9, 20], [15, 7]], [], [[1]], [[1], [2, 3]]],
        hidden=[
            [[1, 2, 3, 4, 5, 6, 7]], [[1, None, 2]], [[1, 2, None, 3]],
            [[1, 2, 3, None, 4]], [[0, -1, 1]], [[1, 2, 3, 4, 5, None, 6]],
        ],
    ),
    Problem(
        pid=1159,
        title="二叉树的中序遍历",
        difficulty="medium",
        tags=["栈", "树", "深度优先搜索"],
        description="""给定二叉树的根节点 root，返回它的中序遍历结果。
中序遍历的顺序是：左子树、根节点、右子树。

提示：
- 树中节点数目在 [0, 100] 范围内
- -100 <= Node.val <= 100""",
        function="inorderTraversal",
        params=[("root", "TreeNode")],
        returns="int[]",
        solver=inorder_traversal,
        public=[[[1, None, 2, 3]], [[]], [[1]], [[1, 2, 3]]],
        expected_public=[[1, 3, 2], [], [1], [2, 1, 3]],
        hidden=[
            [[1, 2, 3, 4, 5]], [[1, None, 2]], [[3, 1, 4, None, 2]],
            [[1, 2, None, 3]], [[-1, -2, -3]],
        ],
    ),
    Problem(
        pid=1160,
        title="验证二叉搜索树",
        difficulty="medium",
        tags=["树", "深度优先搜索", "二叉搜索树"],
        description="""给定一个二叉树的根节点 root，判断它是否是一个有效的二叉搜索树。
有效二叉搜索树满足：
- 节点的左子树只包含小于当前节点值的节点
- 节点的右子树只包含大于当前节点值的节点
- 所有左子树和右子树自身也必须是二叉搜索树

提示：
- 树中节点数目在 [1, 10^4] 范围内
- -2^31 <= Node.val <= 2^31 - 1""",
        function="isValidBST",
        params=[("root", "TreeNode")],
        returns="bool",
        solver=is_valid_bst,
        public=[
            [[2, 1, 3]],
            [[5, 1, 4, None, None, 3, 6]],
            [[1]],
            [[]],
        ],
        expected_public=[True, False, True, True],
        hidden=[
            [[1, 1]], [[5, 4, 6, None, None, 3, 7]], [[2, 2, 2]],
            [[10, 5, 15, None, None, 6, 20]], [[3, 1, 5, 0, 2, 4, 6]],
            [[-2147483648]], [[2147483647]], [[1, None, 2]], [[2, None, 3]],
            [[2, 3]],
        ],
    ),
    Problem(
        pid=1161,
        title="二叉搜索树中第 K 小的元素",
        difficulty="medium",
        tags=["树", "深度优先搜索", "二叉搜索树"],
        description="""给定一个二叉搜索树的根节点 root 和一个整数 k，返回树中第 k 小的元素。
树中节点数为 n，且 1 <= k <= n。

提示：
- 树中节点数目为 n
- 1 <= k <= n <= 10^4
- 0 <= Node.val <= 10^4""",
        function="kthSmallest",
        params=[("root", "TreeNode"), ("k", "int")],
        returns="int",
        solver=kth_smallest,
        public=[
            [[3, 1, 4, None, 2], 1],
            [[5, 3, 6, 2, 4, None, None, 1], 3],
            [[1], 1],
            [[2, 1, 3], 2],
        ],
        expected_public=[1, 3, 1, 2],
        hidden=[
            [[3, 1, 4, None, 2], 2], [[3, 1, 4, None, 2], 3],
            [[3, 1, 4, None, 2], 4], [[5, 3, 6, 2, 4, None, None, 1], 1],
            [[5, 3, 6, 2, 4, None, None, 1], 6], [[-1, -2], 1],
        ],
    ),
    Problem(
        pid=1162,
        title="岛屿的周长",
        difficulty="medium",
        tags=["深度优先搜索", "广度优先搜索", "数组", "矩阵"],
        description="""给定一个 row x col 的二维网格 grid，其中 grid[i][j] = 1 表示陆地，0 表示水域。
岛屿由水平或垂直方向相邻的陆地连接而成，网格四周被水包围。
返回岛屿的周长。

提示：
- row == grid.length
- col == grid[i].length
- 1 <= row, col <= 100
- grid[i][j] 为 0 或 1
- 网格中只有一个岛屿（也可能没有）""",
        function="islandPerimeter",
        params=[("grid", "int[][]")],
        returns="int",
        solver=island_perimeter,
        public=[
            [[[0, 1, 0, 0], [1, 1, 1, 0], [0, 1, 0, 0], [1, 1, 0, 0]]],
            [[[1]]],
            [[[1, 0]]],
            [[[0, 0], [0, 0]]],
        ],
        expected_public=[16, 4, 4, 0],
        hidden=[
            [[[1, 1]]], [[[1], [1]]], [[[1, 1], [1, 1]]],
            [[[0, 1, 0], [1, 1, 1], [0, 1, 0]]], [[[1, 1, 0], [1, 1, 0]]],
            [[[1, 0, 1]]], [[[1, 1, 1], [1, 0, 1]]],
        ],
    ),
    Problem(
        pid=1163,
        title="最大正方形",
        difficulty="medium",
        tags=["数组", "动态规划", "矩阵"],
        description="""在一个由 0 和 1 组成的二维矩阵内，找到只包含 1 的最大正方形，并返回其面积。

提示：
- m == matrix.length
- n == matrix[i].length
- 1 <= m, n <= 300
- matrix[i][j] 为 0 或 1""",
        function="maximalSquare",
        params=[("matrix", "int[][]")],
        returns="int",
        solver=maximal_square,
        public=[
            [[[1, 0, 1, 0, 0], [1, 0, 1, 1, 1], [1, 1, 1, 1, 1], [1, 0, 0, 1, 0]]],
            [[[0, 1], [1, 0]]],
            [[[0]]],
            [[[1]]],
        ],
        expected_public=[4, 1, 0, 1],
        hidden=[
            [[[1, 1], [1, 1]]],
            [[[1, 1, 1], [1, 1, 1], [1, 1, 1]]],
            [[[1, 1, 0], [1, 1, 0], [1, 0, 0]]],
            [[[0, 0], [0, 0]]],
            [[[1, 0, 0], [0, 1, 0], [0, 0, 1]]],
            [[[1, 1, 1, 1], [1, 1, 1, 1]]],
        ],
    ),
    Problem(
        pid=1164,
        title="零钱兑换",
        difficulty="medium",
        tags=["数组", "动态规划", "广度优先搜索"],
        description="""给定不同面额的硬币 coins 和一个总金额 amount，计算凑成总金额所需的最少硬币个数。
如果没有任何组合能凑成总金额，返回 -1。
可以认为每种硬币的数量是无限的。

提示：
- 1 <= coins.length <= 12
- 1 <= coins[i] <= 2^31 - 1
- 0 <= amount <= 10^4""",
        function="coinChange",
        params=[("coins", "int[]"), ("amount", "int")],
        returns="int",
        solver=coin_change,
        public=[
            [[1, 2, 5], 11],
            [[2], 3],
            [[1], 0],
            [[1], 2],
        ],
        expected_public=[3, -1, 0, 2],
        hidden=[
            [[1], 1], [[2], 1], [[1, 2, 5], 0], [[2, 5, 10, 1], 27],
            [[186, 419, 83, 408], 6249], [[3, 7], 5], [[5], 5],
            [[1, 5, 10], 12],
        ],
    ),
    Problem(
        pid=1165,
        title="完全平方数",
        difficulty="medium",
        tags=["数学", "动态规划", "广度优先搜索"],
        description="""给定一个整数 n，返回和为 n 的完全平方数的最少数量。
完全平方数是一个整数，其值等于另一个整数的平方，例如 1、4、9、16 等。

提示：
- 1 <= n <= 10^4""",
        function="numSquares",
        params=[("n", "int")],
        returns="int",
        solver=num_squares,
        public=[[12], [13], [1], [4]],
        expected_public=[3, 2, 1, 1],
        hidden=[[2], [3], [5], [7], [9], [10], [11], [43],
                [100], [101], [9999]],
    ),
    Problem(
        pid=1166,
        title="最长递增子序列",
        difficulty="medium",
        tags=["数组", "动态规划", "二分查找"],
        description="""给定一个整数数组 nums，找到其中最长严格递增子序列的长度。
子序列是由数组派生而来的序列，删除（或不删除）数组中的元素而不改变其余元素的顺序。

提示：
- 1 <= nums.length <= 2500
- -10^4 <= nums[i] <= 10^4""",
        function="lengthOfLIS",
        params=[("nums", "int[]")],
        returns="int",
        solver=length_of_lis,
        public=[
            [[10, 9, 2, 5, 3, 7, 101, 18]],
            [[0, 1, 0, 3, 2, 3]],
            [[7, 7, 7]],
            [[1]],
        ],
        expected_public=[4, 4, 1, 1],
        hidden=[
            [[]], [[1, 2, 3, 4, 5]], [[5, 4, 3, 2, 1]], [[2, 2, 2]],
            [[1, 3, 6, 7, 9, 4, 10, 5, 6]], [[-1, -2, 0, 1]],
            [[10, 10, 10]], [[3, 1, 4, 1, 5, 9, 2, 6]],
        ],
    ),
    Problem(
        pid=1167,
        title="最长公共子序列",
        difficulty="medium",
        tags=["字符串", "动态规划"],
        description="""给定两个字符串 text1 和 text2，返回它们的最长公共子序列的长度。
如果不存在公共子序列，返回 0。
子序列是指从字符串中删除某些字符（也可以不删除）后得到的新字符串，不改变剩余字符的相对顺序。

提示：
- 1 <= text1.length, text2.length <= 1000
- 两个字符串仅由小写英文字符组成""",
        function="longestCommonSubsequence",
        params=[("text1", "string"), ("text2", "string")],
        returns="int",
        solver=longest_common_subsequence,
        public=[
            ["abcde", "ace"],
            ["abc", "abc"],
            ["abc", "def"],
            ["", "abc"],
        ],
        expected_public=[3, 3, 0, 0],
        hidden=[
            ["", ""], ["a", "a"], ["a", "b"], ["bsbininm", "jmjkbkjkv"],
            ["abcba", "abcbcba"], ["abcd", "abcd"], ["oxcpqrsvwf", "shmtulqrypy"],
            ["ezupkr", "ubmrapg"],
        ],
    ),
    Problem(
        pid=1168,
        title="打家劫舍",
        difficulty="medium",
        tags=["数组", "动态规划"],
        description="""你是一个专业的小偷，计划偷窃沿街的房屋。每间房内都藏有一定的现金。
相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被闯入，系统会自动报警。
给定一个代表每个房屋存放金额的非负整数数组 nums，返回不触动警报装置的情况下能偷窃到的最高金额。

提示：
- 1 <= nums.length <= 100
- 0 <= nums[i] <= 400""",
        function="rob",
        params=[("nums", "int[]")],
        returns="int",
        solver=rob,
        public=[[[1, 2, 3, 1]], [[2, 7, 9, 3, 1]], [[1]], [[2, 1]]],
        expected_public=[4, 12, 1, 2],
        hidden=[
            [[]], [[5]], [[2, 1, 1, 2]], [[1, 3, 1, 3, 100]], [[0, 0, 0]],
            [[10, 1, 1, 10]],
        ],
    ),
    Problem(
        pid=1169,
        title="买卖股票的最佳时机含冷冻期",
        difficulty="medium",
        tags=["数组", "动态规划"],
        description="""给定一个整数数组 prices，其中第 i 个元素表示第 i 天的股票价格。
设计一个算法计算出最大利润。在满足以下约束条件下，可以尽可能多地完成交易：
- 卖出股票后，无法在第二天买入股票（即冷冻期为 1 天）

提示：
- 1 <= prices.length <= 5000
- 0 <= prices[i] <= 1000""",
        function="maxProfitCooldown",
        params=[("prices", "int[]")],
        returns="int",
        solver=max_profit_cooldown,
        public=[[[1, 2, 3, 0, 2]], [[1]], [[2, 1]], [[1, 2, 4]]],
        expected_public=[3, 0, 0, 3],
        hidden=[
            [[]], [[2, 2, 2]], [[6, 1, 3, 2, 4, 7]], [[2, 1, 4]],
            [[1, 4, 2, 7]], [[0, 0, 0]],
        ],
    ),
    Problem(
        pid=1170,
        title="乘积最大子数组",
        difficulty="medium",
        tags=["数组", "动态规划"],
        description="""给定一个整数数组 nums，找出乘积最大的非空连续子数组，并返回该子数组对应的乘积。

提示：
- 1 <= nums.length <= 15
- -5 <= nums[i] <= 5""",
        function="maxProduct",
        params=[("nums", "int[]")],
        returns="int",
        solver=max_product,
        public=[
            [[2, 3, -2, 4]],
            [[-2, 0, -1]],
            [[2]],
            [[-2, 3, -4]],
        ],
        expected_public=[6, 0, 2, 24],
        hidden=[
            [[-2]], [[0]], [[0, 2]], [[-2, 0]], [[2, -5, -2, -4, 3]],
            [[1, -2, 3, 4]], [[-1, -2, -3]], [[3, -1, 4]],
        ],
    ),
    Problem(
        pid=1171,
        title="分割等和子集",
        difficulty="medium",
        tags=["数组", "动态规划"],
        description="""给定一个只包含正整数的非空数组 nums，判断是否可以将这个数组分割成两个子集，使两个子集的元素和相等。

提示：
- 1 <= nums.length <= 200
- 1 <= nums[i] <= 100""",
        function="canPartition",
        params=[("nums", "int[]")],
        returns="bool",
        solver=can_partition,
        public=[[[1, 5, 11, 5]], [[1, 2, 3, 5]], [[1, 1]], [[1]]],
        expected_public=[True, False, True, False],
        hidden=[
            [[2, 2, 2, 2]], [[1, 2, 5]], [[3, 3, 3, 4, 5]], [[2, 2, 3, 5]],
            [[1, 1, 1, 1]], [[100, 100]], [[1, 2, 3, 4, 5, 6, 7]],
        ],
    ),
    Problem(
        pid=1172,
        title="单词拆分",
        difficulty="medium",
        tags=["字符串", "动态规划", "哈希表"],
        description="""给定一个字符串 s 和一个字符串列表 wordDict 作为字典，判断 s 是否可以被空格拆分为一个或多个字典中出现的单词。
字典中的单词可以重复使用。

提示：
- 1 <= s.length <= 300
- 1 <= wordDict.length <= 1000
- 1 <= wordDict[i].length <= 20
- 两个字符串仅由小写英文字母组成""",
        function="wordBreak",
        params=[("s", "string"), ("wordDict", "string[]")],
        returns="bool",
        solver=word_break,
        public=[
            ["leetcode", ["leet", "code"]],
            ["applepenapple", ["apple", "pen"]],
            ["catsandog", ["cats", "dog", "sand", "and", "cat"]],
            ["a", ["a"]],
        ],
        expected_public=[True, True, False, True],
        hidden=[
            ["a", []], ["aaaaaaa", ["aaaa", "aaa"]], ["ab", ["a", "b"]],
            ["abc", ["ab", "c"]], ["abcd", ["a", "abc"]], ["cars", ["car", "ca", "rs"]],
            ["bb", ["a", "b", "bbb", "bbbb"]], ["a", ["b"]],
        ],
    ),
    Problem(
        pid=1173,
        title="不同路径",
        difficulty="medium",
        tags=["数学", "动态规划", "组合数学"],
        description="""一个机器人位于一个 m x n 网格的左上角，每次只能向下或向右移动一步。
机器人试图到达网格的右下角，总共有多少条不同的路径？

提示：
- 1 <= m, n <= 10""",
        function="uniquePaths",
        params=[("m", "int"), ("n", "int")],
        returns="int",
        solver=unique_paths,
        public=[[3, 7], [3, 2], [1, 1], [10, 10]],
        expected_public=[28, 3, 1, 48620],
        hidden=[[1, 2], [2, 1], [2, 2], [3, 3], [5, 5], [7, 3],
                [10, 1], [9, 8]],
    ),
    Problem(
        pid=1174,
        title="最小路径和",
        difficulty="medium",
        tags=["数组", "动态规划", "矩阵"],
        description="""给定一个包含非负整数的 m x n 网格 grid，请找出一条从左上角到右下角的路径，使路径上的数字总和最小。
每次只能向下或向右移动一步。

提示：
- m == grid.length
- n == grid[i].length
- 1 <= m, n <= 200
- 0 <= grid[i][j] <= 200""",
        function="minPathSum",
        params=[("grid", "int[][]")],
        returns="int",
        solver=min_path_sum,
        public=[
            [[[1, 3, 1], [1, 5, 1], [4, 2, 1]]],
            [[[1, 2, 3], [4, 5, 6]]],
            [[[1]]],
            [[[1, 2], [1, 1]]],
        ],
        expected_public=[7, 12, 1, 3],
        hidden=[
            [[[5]]], [[[0, 0], [0, 0]]], [[[1, 2, 5], [3, 2, 1]]],
            [[[1, 3], [1, 5]]], [[[1, 1, 1, 1]]],
        ],
    ),
    Problem(
        pid=1175,
        title="解码方法",
        difficulty="medium",
        tags=["字符串", "动态规划"],
        description="""一条包含字母 A-Z 的消息通过以下映射进行了编码：
'A' -> "1", 'B' -> "2", ..., 'Z' -> "26"
给定一个只包含数字的非空字符串 s，请计算并返回解码方法的总数。

提示：
- 1 <= s.length <= 100
- s 只包含数字，可能包含前导零""",
        function="numDecodings",
        params=[("s", "string")],
        returns="int",
        solver=num_decodings,
        public=[["12"], ["226"], ["06"], ["10"]],
        expected_public=[2, 3, 0, 1],
        hidden=[
            ["0"], ["1"], ["27"], ["2101"], ["100"], ["11106"],
            ["12345"], ["1201234"], ["999"], ["101"],
        ],
    ),
    Problem(
        pid=1176,
        title="打家劫舍 II",
        difficulty="medium",
        tags=["数组", "动态规划"],
        description="""你是一个专业的小偷，计划偷窃沿街的房屋。这个地方的所有房屋都围成一圈，这意味着第一间房屋和最后一间房屋是相邻的。
相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被闯入，系统会自动报警。
给定一个代表每个房屋存放金额的非负整数数组 nums，返回不触动警报装置的情况下能偷窃到的最高金额。

提示：
- 1 <= nums.length <= 100
- 0 <= nums[i] <= 1000""",
        function="robCircle",
        params=[("nums", "int[]")],
        returns="int",
        solver=rob_circle,
        public=[[[2, 3, 2]], [[1, 2, 3, 1]], [[1]], [[1, 2]]],
        expected_public=[3, 4, 1, 2],
        hidden=[
            [[2, 2, 2]], [[1, 2, 3]], [[4, 1, 2, 7, 5, 3, 1]], [[0]],
            [[0, 0]], [[1, 3, 1, 3, 100]],
        ],
    ),
    Problem(
        pid=1177,
        title="买卖股票的最佳时机含手续费",
        difficulty="medium",
        tags=["数组", "动态规划", "贪心"],
        description="""给定一个整数数组 prices，其中 prices[i] 表示第 i 天的股票价格，以及一个表示交易手续费的整数 fee。
可以尽可能多地完成交易，但每笔交易都需要支付手续费。
卖出股票后不能再在当天买入股票，但可以在卖出后的第二天买入。
返回能获得的最大利润。

提示：
- 1 <= prices.length <= 5 * 10^4
- 1 <= prices[i] < 5 * 10^4
- 0 <= fee < 5 * 10^4""",
        function="maxProfitFee",
        params=[("prices", "int[]"), ("fee", "int")],
        returns="int",
        solver=max_profit_fee,
        public=[
            [[1, 3, 2, 8, 4, 9], 2],
            [[1, 3, 7, 5, 10, 3], 3],
            [[1], 0],
            [[1, 2], 0],
        ],
        expected_public=[8, 6, 0, 1],
        hidden=[
            [[], 0], [[5, 4, 3], 1], [[1, 2, 3, 4, 5], 1],
            [[1, 3, 2, 8, 4, 9], 3], [[2, 2, 2], 0], [[1, 4], 2],
        ],
    ),
    Problem(
        pid=1178,
        title="搜索二维矩阵",
        difficulty="medium",
        tags=["数组", "二分查找", "矩阵"],
        description="""给定一个 m x n 的矩阵 matrix 和一个整数 target。
该矩阵具有以下特性：
- 每行中的整数从左到右按升序排列
- 每行的第一个整数大于前一行的最后一个整数
判断 matrix 中是否存在 target。

提示：
- m == matrix.length
- n == matrix[i].length
- 1 <= m, n <= 100
- -10^4 <= matrix[i][j], target <= 10^4""",
        function="searchMatrix",
        params=[("matrix", "int[][]"), ("target", "int")],
        returns="bool",
        solver=search_matrix,
        public=[
            [[[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], 3],
            [[[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], 13],
            [[[1]], 1],
            [[[1]], 2],
        ],
        expected_public=[True, False, True, False],
        hidden=[
            [[[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], 1],
            [[[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], 60],
            [[[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], 0],
            [[[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], 61],
            [[[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], 20],
            [[[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], 22],
            [[[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], 23],
            [[[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], 7],
        ],
    ),
    Problem(
        pid=1179,
        title="在排序数组中查找元素的第一个和最后一个位置",
        difficulty="medium",
        tags=["数组", "二分查找"],
        description="""给定一个按照非递减顺序排列的整数数组 nums 和一个目标值 target，找出 target 在数组中的开始位置和结束位置。
如果数组中不存在目标值，返回 [-1, -1]。算法的时间复杂度应为 O(log n)。

提示：
- 0 <= nums.length <= 10^5
- -10^5 <= nums[i], target <= 10^5
- nums 是一个非递减数组""",
        function="searchRange",
        params=[("nums", "int[]"), ("target", "int")],
        returns="int[]",
        solver=search_range,
        public=[
            [[5, 7, 7, 8, 8, 10], 8],
            [[5, 7, 7, 8, 8, 10], 6],
            [[], 0],
            [[1], 1],
        ],
        expected_public=[[3, 4], [-1, -1], [-1, -1], [0, 0]],
        hidden=[
            [[5, 7, 7, 8, 8, 10], 5], [[5, 7, 7, 8, 8, 10], 10],
            [[5, 7, 7, 8, 8, 10], 7], [[1, 2, 3], 4], [[2, 2, 2], 2],
            [[1], 0], [[1, 3, 3, 5], 3],
        ],
    ),
]

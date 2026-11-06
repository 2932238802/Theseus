"""1738-1774：批量第三批简单题（37 道）。"""

from __future__ import annotations

from functools import partial
from math import isqrt

from problem_seed_common import make_problem, tree_from_list, tree_to_list

make = partial(make_problem, difficulty="easy")


class ListNode:
    def __init__(self, val: int = 0, next: "ListNode | None" = None):
        self.val = val
        self.next = next


def build_list(values: list[int]) -> ListNode | None:
    dummy = ListNode()
    tail = dummy
    for value in values:
        tail.next = ListNode(value)
        tail = tail.next
    return dummy.next


def list_to_values(head: ListNode | None) -> list[int]:
    values: list[int] = []
    node = head
    while node is not None:
        values.append(node.val)
        node = node.next
    return values


# ── 栈 / 队列 ─────────────────────────────────────────────────────


def crawler_log_folder(logs: list[str]) -> int:
    depth = 0
    for log in logs:
        if log == "../":
            depth = max(0, depth - 1)
        elif log != "./":
            depth += 1
    return depth


def max_nesting_depth(s: str) -> int:
    depth = 0
    best = 0
    for character in s:
        if character == "(":
            depth += 1
            best = max(best, depth)
        elif character == ")":
            depth -= 1
    return best


def make_string_great(s: str) -> str:
    stack: list[str] = []
    for character in s:
        if (
            stack
            and stack[-1] != character
            and stack[-1].lower() == character.lower()
        ):
            stack.pop()
        else:
            stack.append(character)
    return "".join(stack)


def self_dividing_numbers(left: int, right: int) -> list[int]:
    result: list[int] = []
    for number in range(left, right + 1):
        valid = True
        for character in str(number):
            digit = int(character)
            if digit == 0 or number % digit != 0:
                valid = False
                break
        if valid:
            result.append(number)
    return result


# ── 链表 ──────────────────────────────────────────────────────────


def delete_node_copy(head: list[int], val: int) -> list[int]:
    root = build_list(head)
    node = root
    while node is not None and node.val != val:
        node = node.next
    if node is not None and node.next is not None:
        node.val = node.next.val
        node.next = node.next.next
    return list_to_values(root)


def remove_duplicate_nodes(head: list[int]) -> list[int]:
    seen: set[int] = set()
    result: list[int] = []
    for value in head:
        if value not in seen:
            seen.add(value)
            result.append(value)
    return result


def reverse_print(head: list[int]) -> list[int]:
    return head[::-1]


# ── 二叉树 ───────────────────────────────────────────────────────


def preorder_traversal(root: list[int | None]) -> list[int]:
    result: list[int] = []
    stack = [tree_from_list(root)]
    while stack:
        node = stack.pop()
        if node is None:
            continue
        result.append(node.value)
        stack.append(node.right)
        stack.append(node.left)
    return result


def postorder_traversal(root: list[int | None]) -> list[int]:
    result: list[int] = []
    stack = [tree_from_list(root)]
    while stack:
        node = stack.pop()
        if node is None:
            continue
        result.append(node.value)
        stack.append(node.left)
        stack.append(node.right)
    result.reverse()
    return result


def level_order_bottom(root: list[int | None]) -> list[list[int]]:
    tree = tree_from_list(root)
    if tree is None:
        return []
    levels: list[list[int]] = []
    queue = [tree]
    while queue:
        levels.append([node.value for node in queue])
        next_queue = []
        for node in queue:
            if node.left is not None:
                next_queue.append(node.left)
            if node.right is not None:
                next_queue.append(node.right)
        queue = next_queue
    levels.reverse()
    return levels


def sorted_array_to_bst(nums: list[int]) -> list[int | None]:
    def build(left: int, right: int):
        if left > right:
            return None
        middle = (left + right) // 2
        node = tree_from_list([nums[middle]])
        node.left = build(left, middle - 1)
        node.right = build(middle + 1, right)
        return node

    return tree_to_list(build(0, len(nums) - 1))


def lowest_common_ancestor_bst(
    root: list[int | None], p: int, q: int
) -> int:
    node = tree_from_list(root)
    low, high = min(p, q), max(p, q)
    while node is not None:
        if node.value < low:
            node = node.right
        elif node.value > high:
            node = node.left
        else:
            return node.value
    return -1


def find_second_minimum_value(root: list[int | None]) -> int:
    values: list[int] = []

    def walk(node) -> None:
        if node is None:
            return
        values.append(node.value)
        walk(node.left)
        walk(node.right)

    walk(tree_from_list(root))
    smallest = min(values)
    candidates = [value for value in values if value > smallest]
    return min(candidates) if candidates else -1


def increasing_bst(root: list[int | None]) -> list[int | None]:
    values: list[int] = []

    def walk(node) -> None:
        if node is None:
            return
        walk(node.left)
        values.append(node.value)
        walk(node.right)

    walk(tree_from_list(root))
    dummy = tree_from_list([0])
    tail = dummy
    for value in values:
        tail.right = tree_from_list([value])
        tail = tail.right
    return tree_to_list(dummy.right)


def sum_root_to_leaf(root: list[int | None]) -> int:
    total = 0

    def walk(node, value: int) -> None:
        nonlocal total
        if node is None:
            return
        value = value * 2 + node.value
        if node.left is None and node.right is None:
            total += value
            return
        walk(node.left, value)
        walk(node.right, value)

    walk(tree_from_list(root), 0)
    return total


def is_cousins(root: list[int | None], x: int, y: int) -> bool:
    info: dict[int, tuple[int, int]] = {}

    def walk(node, parent: int, depth: int) -> None:
        if node is None:
            return
        if node.value in (x, y):
            info[node.value] = (parent, depth)
        walk(node.left, node.value, depth + 1)
        walk(node.right, node.value, depth + 1)

    walk(tree_from_list(root), -1, 0)
    if x not in info or y not in info:
        return False
    parent_x, depth_x = info[x]
    parent_y, depth_y = info[y]
    return depth_x == depth_y and parent_x != parent_y


def evaluate_tree(root: list[int | None]) -> bool:
    def walk(node) -> bool:
        if node.left is None and node.right is None:
            return node.value == 1
        left = walk(node.left)
        right = walk(node.right)
        if node.value == 2:
            return left or right
        return left and right

    return walk(tree_from_list(root))


def check_tree(root: list[int | None]) -> bool:
    tree = tree_from_list(root)
    return tree.value == tree.left.value + tree.right.value


# ── 位运算 ────────────────────────────────────────────────────────


def hamming_distance(x: int, y: int) -> int:
    return (x ^ y).bit_count()


def is_power_of_four(n: int) -> bool:
    return n > 0 and (n & (n - 1)) == 0 and (n & 0x55555555) != 0


def is_power_of_three(n: int) -> bool:
    if n <= 0:
        return False
    while n % 3 == 0:
        n //= 3
    return n == 1


def decode_xor_array(encoded: list[int], first: int) -> list[int]:
    result = [first]
    for value in encoded:
        result.append(result[-1] ^ value)
    return result


def min_bit_flips(start: int, goal: int) -> int:
    return (start ^ goal).bit_count()


# ── 数学 ──────────────────────────────────────────────────────────


def count_odds(low: int, high: int) -> int:
    return (high + 1) // 2 - low // 2


def number_of_matches(n: int) -> int:
    return n - 1


def total_money(n: int) -> int:
    weeks, days = divmod(n, 7)
    total = 7 * weeks * (weeks + 1) // 2 + 21 * weeks
    total += days * (weeks + 1) + days * (days - 1) // 2
    return total


def is_three(n: int) -> bool:
    count = 0
    for divisor in range(1, isqrt(n) + 1):
        if n % divisor == 0:
            count += 1 if divisor * divisor == n else 2
        if count > 3:
            return False
    return count == 3


def is_same_after_reversals(num: int) -> bool:
    return num == 0 or num % 10 != 0


def count_triples(n: int) -> int:
    count = 0
    for a in range(1, n + 1):
        for b in range(1, n + 1):
            c = isqrt(a * a + b * b)
            if c <= n and c * c == a * a + b * b:
                count += 1
    return count


def square_is_white(coordinate: str) -> bool:
    column = ord(coordinate[0]) - ord("a")
    row = int(coordinate[1])
    return (column + row) % 2 == 0


# ── 贪心 ──────────────────────────────────────────────────────────


def max_profit_ii(prices: list[int]) -> int:
    profit = 0
    for previous, current in zip(prices, prices[1:]):
        if current > previous:
            profit += current - previous
    return profit


def find_length_of_lcis(nums: list[int]) -> int:
    best = 1
    current = 1
    for previous, value in zip(nums, nums[1:]):
        if value > previous:
            current += 1
            best = max(best, current)
        else:
            current = 1
    return best


def fill_cups(amount: list[int]) -> int:
    first, second, third = sorted(amount)
    if third >= first + second:
        return third
    return (first + second + third + 1) // 2


def minimum_operations_zero_array(nums: list[int]) -> int:
    return len({value for value in nums if value > 0})


def minimum_cost_candies(cost: list[int]) -> int:
    values = sorted(cost, reverse=True)
    return sum(value for index, value in enumerate(values) if index % 3 != 2)


def min_moves_to_seat(seats: list[int], students: list[int]) -> int:
    return sum(
        abs(seat - student)
        for seat, student in zip(sorted(seats), sorted(students))
    )


def remove_digit_max(number: str, digit: str) -> str:
    best: str | None = None
    for index, character in enumerate(number):
        if character != digit:
            continue
        candidate = number[:index] + number[index + 1 :]
        candidate = candidate.lstrip("0") or "0"
        if best is None or len(candidate) > len(best) or (
            len(candidate) == len(best) and candidate > best
        ):
            best = candidate
    return best if best is not None else ""


PROBLEMS = [
    make(
        pid=1738,
        title="文件夹操作日志搜集器",
        tags=["栈", "数组", "字符串"],
        description="""你在主文件夹中，日志 logs 按顺序记录每次操作：
"../" 表示返回上一级文件夹，"./" 表示停留在当前文件夹，
其他形如 "x/" 的字符串表示进入名为 x 的子文件夹。
在主文件夹中执行 "../" 仍停留在主文件夹。
返回完成所有操作后，返回主文件夹所需的最少操作次数（即当前文件夹深度）。""",
        function="crawlerLogFolder",
        params=[("logs", "string[]")],
        returns="int",
        solver=crawler_log_folder,
        public=[
            [["d1/", "d2/", "../", "d21/", "./"]],
            [["d1/", "d2/", "./", "d3/", "../", "d31/"]],
            [["d1/", "../", "../", "../"]],
            [["./"]],
        ],
        hidden=[
            [["d1/", "d2/", "../", "../", "../"]],
            [["./", "./"]],
            [["a/", "b/", "c/", "../", "./", "d/"]],
            [["a/", "b/", "../", "../"]],
            [["x/", "y/", "../", "z/", "../", "../"]],
            [["a/"]],
        ],
    ),
    make(
        pid=1739,
        title="括号的最大嵌套深度",
        tags=["栈", "字符串"],
        description="""给定一个有效括号字符串 s，它可能同时包含数字和运算符。
字符串中任意一对括号都正确配对。
返回 s 中括号的最大嵌套深度；没有括号时返回 0。
嵌套深度指任意位置同时打开的未闭合括号的最大数量。""",
        function="maxNestingDepth",
        params=[("s", "string")],
        returns="int",
        solver=max_nesting_depth,
        public=[
            ["(1+(2*3)+((8)/4))+1"],
            ["(1)+((2))+(((3)))"],
            ["()()"],
            ["()"],
        ],
        hidden=[
            ["((()))"],
            ["(())()"],
            ["1"],
            ["1+(2*3)/(2-1)"],
            ["(((1)))"],
            ["(1)"],
        ],
    ),
    make(
        pid=1740,
        title="整理字符串",
        tags=["栈", "字符串"],
        description="""给定由英文字母组成的字符串 s。
如果相邻两个字符是同一个字母的大小写形式（如 "aA" 或 "Bb"），
则删除这两个字符；删除后可能产生新的相邻可删除字符，继续删除。
重复该过程直到无法删除，返回整理后的字符串。
可以证明最终结果与删除顺序无关。""",
        function="makeStringGreat",
        params=[("s", "string")],
        returns="string",
        solver=make_string_great,
        public=[
            ["leEeetcode"],
            ["abBAcC"],
            ["s"],
            ["Pp"],
        ],
        hidden=[
            ["AaBbCc"],
            ["aAbBcC"],
            ["abcCBA"],
            ["abBA"],
            ["aBa"],
            ["mC"],
            ["abc"],
        ],
    ),
    make(
        pid=1741,
        title="自除数",
        tags=["数学", "枚举"],
        description="""自除数指可以被其每一位数字整除的正整数，且其中不含数字 0。
例如 128 是自除数，因为 128 能被 1、2、8 整除；
10 不是自除数，因为它含有数字 0。
给定两个正整数 left 和 right，返回闭区间 [left, right] 内所有自除数，
按升序排列。""",
        function="selfDividingNumbers",
        params=[("left", "int"), ("right", "int")],
        returns="int[]",
        solver=self_dividing_numbers,
        public=[
            [1, 22],
            [47, 85],
            [1, 1],
            [10, 12],
        ],
        hidden=[
            [1, 10],
            [22, 22],
            [100, 100],
            [128, 128],
            [13, 15],
            [99, 99],
        ],
    ),
    make(
        pid=1742,
        title="删除链表中的节点",
        tags=["链表"],
        description="""给定一个整数数组 head 表示单链表各节点的值，以及整数 val。
链表中恰有一个节点的值为 val，各节点值互不相同，且该节点保证不是尾节点。
你只能访问值为 val 的那个节点本身，不能访问链表头。
删除该节点的方法是：把下一个节点的值复制到当前节点，再删除下一个节点。
返回删除后的链表值数组。""",
        function="deleteNodeCopy",
        params=[("head", "int[]"), ("val", "int")],
        returns="int[]",
        solver=delete_node_copy,
        public=[
            [[4, 5, 1, 9], 5],
            [[4, 5, 1, 9], 1],
            [[1, 2], 1],
        ],
        hidden=[
            [[1, 2, 3], 2],
            [[1, 2, 3, 4], 3],
            [[5, 6, 7], 5],
            [[0, 1], 0],
            [[1, 2, 3, 4, 5], 4],
            [[7, 8, 9], 8],
        ],
    ),
    make(
        pid=1743,
        title="移除重复节点",
        tags=["链表", "哈希表"],
        description="""给定一个未排序的整数数组 head 表示单链表各节点的值。
移除所有重复值的节点，只保留每个值第一次出现的节点，并保持剩余节点的原有顺序。
返回处理后的链表值数组。""",
        function="removeDuplicateNodes",
        params=[("head", "int[]")],
        returns="int[]",
        solver=remove_duplicate_nodes,
        public=[
            [[1, 2, 3, 3, 2, 1]],
            [[1, 1, 1, 1, 2]],
            [[1]],
        ],
        hidden=[
            [[1, 2, 2, 3, 3, 2, 1, 4]],
            [[5, 5]],
            [[1, 2, 3, 4]],
            [[1, 1, 2, 2, 3, 3]],
            [[2, 1, 2, 1]],
            [[7, 7, 7, 8, 9, 8, 9, 10]],
        ],
    ),
    make(
        pid=1744,
        title="从尾到头打印链表",
        tags=["链表", "栈", "递归"],
        description="""给定一个整数数组 head 表示单链表各节点的值。
返回从链表尾部到头部依次取出的节点值组成的数组。
链表为空时返回空数组。""",
        function="reversePrint",
        params=[("head", "int[]")],
        returns="int[]",
        solver=reverse_print,
        public=[
            [[1, 3, 2]],
            [[1]],
            [[]],
        ],
        hidden=[
            [[1, 2, 3, 4, 5]],
            [[7, 8]],
            [[0, 0, 0]],
            [[2, 4, 6, 8, 10]],
            [[9]],
        ],
    ),
    make(
        pid=1745,
        title="二叉树的前序遍历",
        tags=["二叉树", "深度优先搜索", "栈"],
        description="""给定一棵二叉树，以层序数组表示，None 表示空位。
返回其前序遍历的节点值数组，顺序为：根节点、左子树、右子树。
空树返回空数组。""",
        function="preorderTraversal",
        params=[("root", "TreeNode")],
        returns="int[]",
        solver=preorder_traversal,
        public=[
            [[1, None, 2, 3]],
            [[1, 2, 3, 4, 5, None, 6]],
            [[]],
            [[1]],
        ],
        hidden=[
            [[1, 2, None, 3]],
            [[1, None, 2, None, 3]],
            [[1, 2, 3]],
            [[1, 2, 3, 4, 5, 6, 7]],
            [[3, 9, 20, None, None, 15, 7]],
            [[1, 2, 3, None, 4]],
        ],
    ),
    make(
        pid=1746,
        title="二叉树的后序遍历",
        tags=["二叉树", "深度优先搜索", "栈"],
        description="""给定一棵二叉树，以层序数组表示，None 表示空位。
返回其后序遍历的节点值数组，顺序为：左子树、右子树、根节点。
空树返回空数组。""",
        function="postorderTraversal",
        params=[("root", "TreeNode")],
        returns="int[]",
        solver=postorder_traversal,
        public=[
            [[1, None, 2, 3]],
            [[1, 2, 3, 4, 5, None, 6]],
            [[]],
            [[1]],
        ],
        hidden=[
            [[1, 2, None, 3]],
            [[1, None, 2, None, 3]],
            [[1, 2, 3]],
            [[1, 2, 3, 4, 5, 6, 7]],
            [[3, 9, 20, None, None, 15, 7]],
            [[1, 2, 3, None, 4]],
        ],
    ),
    make(
        pid=1747,
        title="二叉树的层序遍历 II",
        tags=["二叉树", "广度优先搜索"],
        description="""给定一棵二叉树，以层序数组表示，None 表示空位。
返回自底向上的层序遍历结果：先返回最底层，从左到右；
再返回上一层的从左到右结果，依此类推，直到根节点。
空树返回空数组。""",
        function="levelOrderBottom",
        params=[("root", "TreeNode")],
        returns="int[][]",
        solver=level_order_bottom,
        public=[
            [[3, 9, 20, None, None, 15, 7]],
            [[1]],
            [[]],
            [[1, 2, 3]],
        ],
        hidden=[
            [[1, 2, None, 3]],
            [[1, 2, 3, 4, 5]],
            [[1, None, 2]],
            [[1, 2, None, 3, None, 4]],
            [[0, 2, 4, 1, None, 3, -1, 5, 1, None, 6, None, 8]],
        ],
    ),
    make(
        pid=1748,
        title="将有序数组转换为二叉搜索树",
        tags=["二叉树", "二叉搜索树", "分治"],
        description="""给定一个严格递增的整数数组 nums。
把它转换为一棵高度平衡的二叉搜索树。
构造规则固定为：对当前区间取中间下标作为根节点，
区间长度为偶数时取偏左的中间下标，然后递归构造左右子树。
返回按层序序列化的结果，None 表示空位，末尾连续的空位省略。""",
        function="sortedArrayToBST",
        params=[("nums", "int[]")],
        returns="TreeNode",
        solver=sorted_array_to_bst,
        public=[
            [[-10, -3, 0, 5, 9]],
            [[1, 2, 3]],
            [[1]],
            [[1, 2]],
        ],
        hidden=[
            [[1, 2, 3, 4]],
            [[-1, 0, 1, 2]],
            [[0, 1, 2, 3, 4, 5]],
            [[-5, -4, -3, -2, -1]],
            [[2, 5, 8, 11, 14, 17, 20]],
        ],
    ),
    make(
        pid=1749,
        title="二叉搜索树的最近公共祖先",
        tags=["二叉树", "二叉搜索树", "深度优先搜索"],
        description="""给定一棵二叉搜索树，以层序数组表示，None 表示空位。
树中节点值互不相同，p 和 q 是两个不同节点的值，且都存在于树中。
返回 p 和 q 的最近公共祖先节点的值。
最近公共祖先指同时是 p、q 祖先且深度最大的节点，节点也可以是自身的祖先。""",
        function="lowestCommonAncestorBST",
        params=[("root", "TreeNode"), ("p", "int"), ("q", "int")],
        returns="int",
        solver=lowest_common_ancestor_bst,
        public=[
            [[6, 2, 8, 0, 4, 7, 9, None, None, 3, 5], 2, 8],
            [[6, 2, 8, 0, 4, 7, 9, None, None, 3, 5], 2, 4],
            [[2, 1], 2, 1],
            [[2, 1], 1, 2],
        ],
        hidden=[
            [[6, 2, 8, 0, 4, 7, 9, None, None, 3, 5], 0, 5],
            [[6, 2, 8, 0, 4, 7, 9, None, None, 3, 5], 3, 5],
            [[6, 2, 8, 0, 4, 7, 9, None, None, 3, 5], 7, 9],
            [[6, 2, 8, 0, 4, 7, 9, None, None, 3, 5], 0, 9],
            [[5, 3, 6, 2, 4, None, None, 1], 1, 4],
            [[5, 3, 6, 2, 4, None, None, 1], 2, 4],
        ],
    ),
    make(
        pid=1750,
        title="二叉树中第二小的节点",
        tags=["二叉树", "深度优先搜索"],
        description="""给定一棵特殊的二叉树，以层序数组表示，None 表示空位。
每个节点的值都等于其子节点中较小的那个值（叶子节点除外），
因此根节点的值是整棵树中的最小值。
返回所有节点值中严格大于最小值的那个最小值，即第二小的值。
如果所有节点值都相同，返回 -1。""",
        function="findSecondMinimumValue",
        params=[("root", "TreeNode")],
        returns="int",
        solver=find_second_minimum_value,
        public=[
            [[2, 2, 5, None, None, 5, 7]],
            [[2, 2, 2]],
            [[5, 5, 6]],
        ],
        hidden=[
            [[1, 1, 2]],
            [[1, 2, 2]],
            [[2, 2, 2, None, None, 2, 3]],
            [[2, 2, 2, 2, 2, 2, 2]],
            [[1, 1, 2, 1, 1, 2, 2]],
            [[1, 1, 1, 1, 1, 1, 2]],
        ],
    ),
    make(
        pid=1751,
        title="递增顺序搜索树",
        tags=["二叉树", "二叉搜索树", "中序遍历"],
        description="""给定一棵二叉搜索树，以层序数组表示，None 表示空位。
按中序遍历的顺序重新排列所有节点，使新树只有右子节点，
并且每个节点的值都递增。
返回新树的层序序列化结果，None 表示空位，末尾连续空位省略。""",
        function="increasingBST",
        params=[("root", "TreeNode")],
        returns="TreeNode",
        solver=increasing_bst,
        public=[
            [[5, 3, 6, 2, 4, None, 8, 1, None, None, None, 7, 9]],
            [[5, 1, 7]],
            [[1, None, 2]],
            [[2, 1, 3]],
        ],
        hidden=[
            [[3, 2, 4, 1]],
            [[10, 5, 15]],
            [[1]],
            [[4, 2, 5, 1, 3]],
            [[6, 4, 9, 2, 5, 8, 10]],
        ],
    ),
    make(
        pid=1752,
        title="从根到叶的二进制数之和",
        tags=["二叉树", "深度优先搜索", "位运算"],
        description="""给定一棵二叉树，以层序数组表示，None 表示空位。
每个节点的值都是 0 或 1。
每条从根节点到叶节点的路径按从上到下的顺序组成一个二进制数。
返回所有从根到叶路径所表示数值的总和（十进制）。
叶子节点指没有子节点的节点。""",
        function="sumRootToLeaf",
        params=[("root", "TreeNode")],
        returns="int",
        solver=sum_root_to_leaf,
        public=[
            [[1, 0, 1, 0, 1, 0, 1]],
            [[0]],
            [[1]],
            [[1, 1]],
        ],
        hidden=[
            [[1, 0]],
            [[1, 1, 0]],
            [[1, None, 0]],
            [[1, 0, 1]],
            [[1, 0, 0, 1]],
            [[1, 0, 1, 0, 1]],
        ],
    ),
    make(
        pid=1753,
        title="二叉树的堂兄弟节点",
        tags=["二叉树", "广度优先搜索", "深度优先搜索"],
        description="""给定一棵二叉树，以层序数组表示，None 表示空位，节点值互不相同。
再给定两个节点值 x 和 y。
如果两个节点深度相同但父节点不同，则它们是堂兄弟节点，返回 true；
否则返回 false。深度指从根到该节点经过的边数。
x 和 y 保证都存在于树中且不相等。""",
        function="isCousins",
        params=[("root", "TreeNode"), ("x", "int"), ("y", "int")],
        returns="bool",
        solver=is_cousins,
        public=[
            [[1, 2, 3, 4], 4, 3],
            [[1, 2, 3, None, 4, None, 5], 5, 4],
            [[1, 2, 3, None, 4], 2, 3],
            [[1, 2, 3], 2, 3],
        ],
        hidden=[
            [[1, 2, 3, 4, 5, 6, 7], 4, 7],
            [[1, 2, 3, 4, 5, 6, 7], 4, 5],
            [[1, 2, 3, 4, 5, 6, 7], 4, 6],
            [[1, 2, 3, None, 4, None, 5], 4, 5],
            [[1, 2], 1, 2],
            [[1, 2, 3, 4, 5, 6, 7], 2, 3],
        ],
    ),
    make(
        pid=1754,
        title="计算布尔二叉树的值",
        tags=["二叉树", "深度优先搜索", "递归"],
        description="""给定一棵满二叉树，以层序数组表示，None 表示空位。
叶子节点的值为 0 或 1，表示 false 或 true。
内部节点的值为 2 或 3：2 表示对左右子节点的布尔值做逻辑或，3 表示做逻辑与。
返回根节点所代表的布尔值。""",
        function="evaluateTree",
        params=[("root", "TreeNode")],
        returns="bool",
        solver=evaluate_tree,
        public=[
            [[2, 1, 3, None, None, 0, 1]],
            [[0]],
            [[1]],
            [[3, 0, 1]],
            [[2, 0, 0]],
        ],
        hidden=[
            [[2, 3, 2, 0, 1, 0, 1]],
            [[3, 1, 1]],
            [[3, 1, 0]],
            [[2, 1, 1]],
            [[3, 2, 1, 0, 1]],
        ],
    ),
    make(
        pid=1755,
        title="判断根结点是否等于子结点之和",
        tags=["二叉树"],
        description="""给定一棵二叉树，以层序数组表示。
该树恰好有三个节点：根节点、左子节点和右子节点。
判断根节点的值是否等于左子节点与右子节点值之和，返回 true 或 false。""",
        function="checkTree",
        params=[("root", "TreeNode")],
        returns="bool",
        solver=check_tree,
        public=[
            [[10, 4, 6]],
            [[5, 3, 1]],
            [[2, 1, 1]],
        ],
        hidden=[
            [[0, 0, 0]],
            [[-1, -2, 1]],
            [[1, 2, 3]],
            [[100, 50, 50]],
            [[-5, -3, -2]],
        ],
    ),
    make(
        pid=1756,
        title="汉明距离",
        tags=["位运算"],
        description="""给定两个非负整数 x 和 y。
汉明距离指两个数的二进制表示中对应位不同的位置数量。
返回 x 和 y 的汉明距离。""",
        function="hammingDistance",
        params=[("x", "int"), ("y", "int")],
        returns="int",
        solver=hamming_distance,
        public=[
            [1, 4],
            [3, 1],
            [0, 0],
        ],
        hidden=[
            [0, 2147483647],
            [7, 7],
            [10, 15],
            [1, 2],
            [123, 456],
            [2147483647, 0],
        ],
    ),
    make(
        pid=1757,
        title="4 的幂",
        tags=["位运算", "数学", "递归"],
        description="""给定一个整数 n，判断它是否是 4 的幂。
若存在整数 k 使得 n == 4^k，则返回 true，其中 k 为非负整数。
负数、0 以及不是 4 的幂的整数都返回 false。""",
        function="isPowerOfFour",
        params=[("n", "int")],
        returns="bool",
        solver=is_power_of_four,
        public=[
            [16],
            [5],
            [1],
            [0],
        ],
        hidden=[
            [4],
            [2],
            [64],
            [-16],
            [1073741824],
            [8],
        ],
    ),
    make(
        pid=1758,
        title="3 的幂",
        tags=["数学", "递归"],
        description="""给定一个整数 n，判断它是否是 3 的幂。
若存在整数 k 使得 n == 3^k，则返回 true，其中 k 为非负整数。
负数、0 以及不是 3 的幂的整数都返回 false。""",
        function="isPowerOfThree",
        params=[("n", "int")],
        returns="bool",
        solver=is_power_of_three,
        public=[
            [27],
            [0],
            [9],
            [45],
        ],
        hidden=[
            [1],
            [3],
            [81],
            [-3],
            [1162261467],
            [2],
        ],
    ),
    make(
        pid=1759,
        title="解码异或后的数组",
        tags=["位运算", "数组"],
        description="""有一个长度为 n + 1 的非负整数数组 arr，它经过编码后得到长度为 n 的数组 encoded，
编码规则为 encoded[i] = arr[i] XOR arr[i + 1]，其中 XOR 表示按位异或。
现在给定 encoded 和 arr[0] 的值 first，返回原始数组 arr。""",
        function="decodeXorArray",
        params=[("encoded", "int[]"), ("first", "int")],
        returns="int[]",
        solver=decode_xor_array,
        public=[
            [[1, 2, 3], 1],
            [[6, 2, 7, 3], 4],
            [[0], 0],
            [[1], 0],
        ],
        hidden=[
            [[1, 2], 3],
            [[0, 0, 0], 5],
            [[5], 5],
            [[1, 1, 1, 1], 0],
            [[2, 4, 6], 1],
        ],
    ),
    make(
        pid=1760,
        title="转换数字的最少位翻转次数",
        tags=["位运算"],
        description="""给定两个非负整数 start 和 goal。
每次操作可以翻转 start 的二进制表示中的任意一位（0 变 1，1 变 0）。
返回把 start 变成 goal 所需的最少翻转次数。""",
        function="minBitFlips",
        params=[("start", "int"), ("goal", "int")],
        returns="int",
        solver=min_bit_flips,
        public=[
            [10, 7],
            [3, 4],
            [0, 0],
        ],
        hidden=[
            [1, 2],
            [0, 1023],
            [100, 100],
            [1024, 0],
            [12345, 67890],
        ],
    ),
    make(
        pid=1761,
        title="在区间范围内统计奇数数目",
        tags=["数学"],
        description="""给定两个非负整数 low 和 high，且 low <= high。
返回闭区间 [low, high] 中奇数的个数。""",
        function="countOdds",
        params=[("low", "int"), ("high", "int")],
        returns="int",
        solver=count_odds,
        public=[
            [3, 7],
            [8, 10],
            [0, 0],
            [1, 1],
        ],
        hidden=[
            [0, 10],
            [2, 2],
            [2, 3],
            [10, 20],
            [1, 1000000000],
        ],
    ),
    make(
        pid=1762,
        title="比赛中的配对次数",
        tags=["数学", "模拟"],
        description="""有 n 支队伍参加比赛，比赛规则如下：
每轮将所有队伍两两配对，每对进行一场比赛，胜者进入下一轮；
如果队伍数为奇数，则有一支队伍轮空直接进入下一轮。
当只剩一支队伍时比赛结束。
返回整个赛程中进行的比赛总场数。""",
        function="numberOfMatches",
        params=[("n", "int")],
        returns="int",
        solver=number_of_matches,
        public=[
            [7],
            [14],
            [1],
            [3],
        ],
        hidden=[
            [2],
            [4],
            [100],
            [200],
            [5],
        ],
    ),
    make(
        pid=1763,
        title="计算力扣银行的钱",
        tags=["数学", "模拟"],
        description="""Hercy 每天往银行存钱。
第 1 周（第 1 天到第 7 天）每天分别存 1、2、3、4、5、6、7 元；
第 2 周每天分别存 2、3、4、5、6、7、8 元；
依此类推，第 w 周每天分别存 w、w + 1、...、w + 6 元。
给定天数 n，返回第 n 天结束时共存了多少钱。""",
        function="totalMoney",
        params=[("n", "int")],
        returns="int",
        solver=total_money,
        public=[
            [4],
            [10],
            [20],
            [1],
        ],
        hidden=[
            [7],
            [8],
            [15],
            [28],
            [100],
        ],
    ),
    make(
        pid=1764,
        title="三除数",
        tags=["数学"],
        description="""给定一个整数 n。
如果 n 恰好有三个正除数，返回 true，否则返回 false。
正除数指能整除 n 的正整数，包括 1 和 n 本身。""",
        function="isThree",
        params=[("n", "int")],
        returns="bool",
        solver=is_three,
        public=[
            [2],
            [4],
            [7],
            [9],
        ],
        hidden=[
            [1],
            [8],
            [25],
            [49],
            [100],
            [9409],
        ],
    ),
    make(
        pid=1765,
        title="反转两次的数字",
        tags=["数学", "模拟"],
        description="""给定一个非负整数 num。
第一次反转：把 num 的十进制数字顺序颠倒，并去掉反转后可能产生的前导零，得到 reversed1。
第二次反转：把 reversed1 的十进制数字顺序颠倒，并去掉前导零，得到 reversed2。
如果 reversed2 等于 num，返回 true，否则返回 false。
注意：末尾带 0 的正整数在第一次反转后会丢失这些 0，因此无法还原。""",
        function="isSameAfterReversals",
        params=[("num", "int")],
        returns="bool",
        solver=is_same_after_reversals,
        public=[
            [526],
            [0],
            [1800],
            [5],
        ],
        hidden=[
            [10],
            [100],
            [123],
            [120],
            [1000000],
            [7],
        ],
    ),
    make(
        pid=1766,
        title="统计平方和三元组的数目",
        tags=["数学", "枚举"],
        description="""给定一个正整数 n。
统计满足 a^2 + b^2 = c^2 且 1 <= a, b, c <= n 的三元组 (a, b, c) 的数量。
三元组是有序的：交换 a 和 b 得到的三元组视为不同的三元组。""",
        function="countTriples",
        params=[("n", "int")],
        returns="int",
        solver=count_triples,
        public=[
            [5],
            [10],
            [1],
            [3],
        ],
        hidden=[
            [4],
            [13],
            [2],
            [15],
            [250],
        ],
    ),
    make(
        pid=1767,
        title="判断国际象棋棋盘中一个格子的颜色",
        tags=["数学", "字符串"],
        description="""国际象棋棋盘有 8 行 8 列，列用字母 a 到 h 表示，行用数字 1 到 8 表示。
左上角 a1 是深色格子，棋盘相邻格子颜色交替。
给定一个表示格子的字符串 coordinate（如 "a1"），
如果该格子是白色返回 true，是深色返回 false。""",
        function="squareIsWhite",
        params=[("coordinate", "string")],
        returns="bool",
        solver=square_is_white,
        public=[
            ["a1"],
            ["h3"],
            ["c7"],
            ["d4"],
        ],
        hidden=[
            ["a2"],
            ["b1"],
            ["h8"],
            ["e5"],
            ["g6"],
            ["h1"],
        ],
    ),
    make(
        pid=1768,
        title="买卖股票的最佳时机 II",
        tags=["贪心", "数组", "动态规划"],
        description="""给定一个整数数组 prices，其中 prices[i] 表示某支股票第 i 天的价格。
每天你可以决定买入或卖出至多一股股票，也可以什么都不做。
同一天可以先卖出再买入，但任何时刻最多持有 1 股。
初始时没有股票，要求最后也没有股票。
返回能获得的最大利润。""",
        function="maxProfitII",
        params=[("prices", "int[]")],
        returns="int",
        solver=max_profit_ii,
        public=[
            [[7, 1, 5, 3, 6, 4]],
            [[1, 2, 3, 4, 5]],
            [[7, 6, 4, 3, 1]],
        ],
        hidden=[
            [[1]],
            [[2, 1, 2, 1, 2]],
            [[3, 3, 3]],
            [[1, 5, 1, 5]],
            [[2, 4, 1, 7]],
            [[6, 1, 3, 2, 4, 7]],
        ],
    ),
    make(
        pid=1769,
        title="最长连续递增序列",
        tags=["数组", "贪心"],
        description="""给定一个整数数组 nums。
返回其中最长的连续递增子数组的长度。
连续递增子数组指下标连续且每个元素都严格大于前一个元素的一段子数组。
子数组长度至少为 1。""",
        function="findLengthOfLCIS",
        params=[("nums", "int[]")],
        returns="int",
        solver=find_length_of_lcis,
        public=[
            [[1, 3, 5, 4, 7]],
            [[2, 2, 2, 2, 2]],
            [[1, 2, 3, 4, 5]],
            [[5, 4, 3, 2, 1]],
        ],
        hidden=[
            [[1]],
            [[1, 3, 5, 4, 2, 3, 4, 5]],
            [[1, 2, 3, 2, 4, 5, 6, 7]],
            [[1, 2, 3, 4]],
            [[2, 1, 3]],
            [[1, 1, 2]],
        ],
    ),
    make(
        pid=1770,
        title="装满杯子需要的最短总时长",
        tags=["贪心", "数学"],
        description="""有一个水龙头，每秒钟可以选择：
给一个杯子装满水；或同时给两个不同类型（冷、温、热）的杯子各装一部分水。
给定数组 amount，依次表示冷、温、热水杯的数量。
返回装满所有杯子所需的最短秒数。""",
        function="fillCups",
        params=[("amount", "int[]")],
        returns="int",
        solver=fill_cups,
        public=[
            [[1, 4, 2]],
            [[5, 4, 4]],
            [[5, 0, 0]],
        ],
        hidden=[
            [[0, 0, 0]],
            [[1, 1, 1]],
            [[1, 2, 3]],
            [[3, 3, 3]],
            [[10, 0, 0]],
            [[2, 2, 2]],
        ],
    ),
    make(
        pid=1771,
        title="使数组中所有元素都等于零",
        tags=["贪心", "数组", "哈希表"],
        description="""给定一个非负整数数组 nums。
每次操作选择一个正整数 x，然后把数组中所有等于 x 的元素都减去 x（这些元素变为 0），
其他元素保持不变。
返回使数组中所有元素都等于 0 所需的最少操作次数。""",
        function="minimumOperationsZeroArray",
        params=[("nums", "int[]")],
        returns="int",
        solver=minimum_operations_zero_array,
        public=[
            [[1, 5, 0, 3, 5]],
            [[0]],
            [[2, 2, 2]],
            [[1, 2, 3]],
        ],
        hidden=[
            [[5, 5, 5, 5]],
            [[0, 0, 0]],
            [[10, 1, 10, 1]],
            [[3, 1, 2, 3]],
            [[1]],
        ],
    ),
    make(
        pid=1772,
        title="打折购买糖果的最小开销",
        tags=["贪心", "数组", "排序"],
        description="""给定一个正整数数组 cost，表示每种糖果的价格。
商店促销规则：每买两颗糖果，就可以免费拿走一颗价格不超过这两颗中较便宜者的糖果。
免费糖果必须从尚未购买的糖果中选择，且每颗糖果只能购买或免费获得一次。
返回买走所有糖果所需的最小总开销。""",
        function="minimumCostCandies",
        params=[("cost", "int[]")],
        returns="int",
        solver=minimum_cost_candies,
        public=[
            [[1, 2, 3]],
            [[6, 5, 5, 5, 5, 5, 5]],
            [[5]],
            [[5, 5, 5, 5]],
        ],
        hidden=[
            [[1]],
            [[1, 1, 1]],
            [[10, 5, 3]],
            [[2, 2, 2, 2, 2]],
            [[9, 8, 7, 6, 5, 4]],
        ],
    ),
    make(
        pid=1773,
        title="使每位学生都有座位的最少移动次数",
        tags=["贪心", "数组", "排序"],
        description="""给定两个长度相同的整数数组 seats 和 students。
seats[i] 表示第 i 个座位的坐标，students[i] 表示第 i 名学生当前的坐标。
把每名学生安排到一个座位，每个座位恰好安排一名学生。
一名学生移动到座位的代价是两者坐标之差的绝对值。
返回安排所有学生所需的最小总移动次数。""",
        function="minMovesToSeat",
        params=[("seats", "int[]"), ("students", "int[]")],
        returns="int",
        solver=min_moves_to_seat,
        public=[
            [[3, 1, 5], [2, 7, 4]],
            [[4, 1, 5, 9], [1, 3, 2, 6]],
            [[2, 2, 6, 6], [1, 3, 2, 6]],
        ],
        hidden=[
            [[1], [1]],
            [[1, 2, 3], [3, 2, 1]],
            [[10, 20, 30], [1, 2, 3]],
            [[5, 5, 5], [1, 2, 3]],
            [[2, 2, 2], [2, 2, 2]],
        ],
    ),
    make(
        pid=1774,
        title="移除指定数字得到的最大结果",
        tags=["贪心", "字符串", "枚举"],
        description="""给定一个表示正整数的字符串 number（不含前导零），以及一个数字字符 digit。
number 中至少出现一次 digit。
必须从中恰好移除一个等于 digit 的字符，得到一个新的整数值。
返回所有可能结果中数值最大的那个，以普通十进制字符串表示，
不保留前导零；如果结果为 0 则输出 "0"。""",
        function="removeDigitMax",
        params=[("number", "string"), ("digit", "string")],
        returns="string",
        solver=remove_digit_max,
        public=[
            ["123", "3"],
            ["1231", "1"],
            ["551", "5"],
            ["102", "1"],
        ],
        hidden=[
            ["10", "1"],
            ["1001", "1"],
            ["123", "1"],
            ["9876", "9"],
            ["111", "1"],
            ["4321", "4"],
            ["555", "5"],
        ],
    ),
]

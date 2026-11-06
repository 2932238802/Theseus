"""1538-1574：批量第二批简单题（37 道）。"""

from __future__ import annotations

from collections import Counter
from functools import partial
from math import gcd, isqrt

from problem_seed_common import Node, make_problem, tree_from_list, tree_to_list

make = partial(make_problem, difficulty="easy")


class ListNode:
    def __init__(self, val: int = 0, next: "ListNode | None" = None):
        self.val = val
        self.next = next


# ── 链表 ──────────────────────────────────────────────────────────


def has_cycle(head: list[int], pos: int) -> bool:
    nodes = [ListNode(value) for value in head]
    for index in range(len(nodes) - 1):
        nodes[index].next = nodes[index + 1]
    if pos >= 0 and nodes:
        nodes[-1].next = nodes[pos]

    slow = fast = nodes[0] if nodes else None
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow is fast:
            return True
    return False


def get_intersection_node(
    list_a: list[int], list_b: list[int], skip_a: int, skip_b: int
) -> int:
    nodes_a = [ListNode(value) for value in list_a]
    for index in range(len(nodes_a) - 1):
        nodes_a[index].next = nodes_a[index + 1]
    nodes_b = [ListNode(value) for value in list_b]
    for index in range(len(nodes_b) - 1):
        nodes_b[index].next = nodes_b[index + 1]

    if skip_a >= 0 and skip_b >= 0:
        if skip_b == 0:
            head_b = nodes_a[skip_a]
        else:
            nodes_b[skip_b - 1].next = nodes_a[skip_a]
            head_b = nodes_b[0]
    else:
        head_b = nodes_b[0] if nodes_b else None

    head_a = nodes_a[0] if nodes_a else None
    left, right = head_a, head_b
    while left is not right:
        left = left.next if left else head_b
        right = right.next if right else head_a
    return left.val if left else -1


# ── 栈 / 队列 ─────────────────────────────────────────────────────


def next_greater_element(nums1: list[int], nums2: list[int]) -> list[int]:
    stack: list[int] = []
    greater: dict[int, int] = {}
    for value in nums2:
        while stack and stack[-1] < value:
            greater[stack.pop()] = value
        stack.append(value)
    return [greater.get(value, -1) for value in nums1]


def cal_points(ops: list[str]) -> int:
    stack: list[int] = []
    for op in ops:
        if op == "C":
            stack.pop()
        elif op == "D":
            stack.append(stack[-1] * 2)
        elif op == "+":
            stack.append(stack[-1] + stack[-2])
        else:
            stack.append(int(op))
    return sum(stack)


def remove_duplicates(s: str) -> str:
    stack: list[str] = []
    for character in s:
        if stack and stack[-1] == character:
            stack.pop()
        else:
            stack.append(character)
    return "".join(stack)


def time_required_to_buy(tickets: list[int], k: int) -> int:
    target = tickets[k]
    total = 0
    for index, count in enumerate(tickets):
        if index <= k:
            total += min(count, target)
        else:
            total += min(count, target - 1)
    return total


# ── 二叉树 ────────────────────────────────────────────────────────


def find_mode(root: list[int | None]) -> list[int]:
    counts: Counter[int] = Counter()

    def walk(node):
        if node is None:
            return
        counts[node.value] += 1
        walk(node.left)
        walk(node.right)

    walk(tree_from_list(root))
    best = max(counts.values())
    return sorted(value for value, count in counts.items() if count == best)


def get_minimum_difference(root: list[int | None]) -> int:
    values: list[int] = []

    def walk(node):
        if node is None:
            return
        walk(node.left)
        values.append(node.value)
        walk(node.right)

    walk(tree_from_list(root))
    return min(right - left for left, right in zip(values, values[1:]))


def convert_bst(root: list[int | None]) -> list[int | None]:
    running = 0

    def walk(node):
        nonlocal running
        if node is None:
            return
        walk(node.right)
        running += node.value
        node.value = running
        walk(node.left)

    tree = tree_from_list(root)
    walk(tree)
    return tree_to_list(tree)


def find_tilt(root: list[int | None]) -> int:
    total = 0

    def walk(node) -> int:
        nonlocal total
        if node is None:
            return 0
        left_sum = walk(node.left)
        right_sum = walk(node.right)
        total += abs(left_sum - right_sum)
        return left_sum + right_sum + node.value

    walk(tree_from_list(root))
    return total


def is_subtree(root: list[int | None], sub_root: list[int | None]) -> bool:
    main_tree = tree_from_list(root)
    sub_tree = tree_from_list(sub_root)

    def same(left, right) -> bool:
        if left is None or right is None:
            return left is right
        return (
            left.value == right.value
            and same(left.left, right.left)
            and same(left.right, right.right)
        )

    def walk(node) -> bool:
        if node is None:
            return False
        return same(node, sub_tree) or walk(node.left) or walk(node.right)

    return walk(main_tree)


def tree2str(root: list[int | None]) -> str:
    def walk(node) -> str:
        text = str(node.value)
        if node.left or node.right:
            text += "(" + (walk(node.left) if node.left else "") + ")"
        if node.right:
            text += "(" + walk(node.right) + ")"
        return text

    tree = tree_from_list(root)
    return "" if tree is None else walk(tree)


def merge_trees(
    root1: list[int | None], root2: list[int | None]
) -> list[int | None]:
    def walk(left, right):
        if left is None and right is None:
            return None
        value = (left.value if left else 0) + (right.value if right else 0)
        return Node(
            value,
            walk(left.left if left else None, right.left if right else None),
            walk(left.right if left else None, right.right if right else None),
        )

    return tree_to_list(walk(tree_from_list(root1), tree_from_list(root2)))


def search_bst(root: list[int | None], val: int) -> list[int | None]:
    node = tree_from_list(root)
    while node is not None and node.value != val:
        node = node.left if val < node.value else node.right
    return tree_to_list(node)


def range_sum_bst(root: list[int | None], low: int, high: int) -> int:
    def walk(node) -> int:
        if node is None:
            return 0
        if node.value < low:
            return walk(node.right)
        if node.value > high:
            return walk(node.left)
        return node.value + walk(node.left) + walk(node.right)

    return walk(tree_from_list(root))


# ── 数学 ──────────────────────────────────────────────────────────


def find_common_chars(words: list[str]) -> list[str]:
    counts = [Counter(word) for word in words]
    result: list[str] = []
    for code in range(ord("a"), ord("z") + 1):
        character = chr(code)
        times = min(count[character] for count in counts)
        result.extend([character] * times)
    return result


def day_of_year(date: str) -> int:
    year, month, day = map(int, date.split("-"))
    days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    if year % 400 == 0 or (year % 4 == 0 and year % 100 != 0):
        days[1] = 29
    return sum(days[: month - 1]) + day


def construct_rectangle(area: int) -> list[int]:
    for width in range(isqrt(area), 0, -1):
        if area % width == 0:
            return [area // width, width]
    return [area, 1]


def convert_to_base7(num: int) -> str:
    if num == 0:
        return "0"
    negative = num < 0
    num = abs(num)
    digits: list[str] = []
    while num:
        digits.append(str(num % 7))
        num //= 7
    return ("-" if negative else "") + "".join(reversed(digits))


def check_perfect_number(num: int) -> bool:
    if num <= 1:
        return False
    total = 1
    divisor = 2
    while divisor * divisor <= num:
        if num % divisor == 0:
            total += divisor
            other = num // divisor
            if other != divisor:
                total += other
        divisor += 1
    return total == num


def find_gcd(nums: list[int]) -> int:
    return gcd(max(nums), min(nums))


def is_rectangle_overlap(rec1: list[int], rec2: list[int]) -> bool:
    return (
        max(rec1[0], rec2[0]) < min(rec1[2], rec2[2])
        and max(rec1[1], rec2[1]) < min(rec1[3], rec2[3])
    )


# ── 位运算 ────────────────────────────────────────────────────────


def count_bits(n: int) -> list[int]:
    result = [0] * (n + 1)
    for value in range(1, n + 1):
        result[value] = result[value >> 1] + (value & 1)
    return result


def count_prime_set_bits(left: int, right: int) -> int:
    primes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31}
    return sum(bin(value).count("1") in primes for value in range(left, right + 1))


def binary_gap(n: int) -> int:
    best = 0
    previous = -1
    position = 0
    while n:
        if n & 1:
            if previous >= 0:
                best = max(best, position - previous)
            previous = position
        n >>= 1
        position += 1
    return best


def bitwise_complement(n: int) -> int:
    if n == 0:
        return 1
    mask = (1 << n.bit_length()) - 1
    return n ^ mask


def reverse_bits(n: int) -> int:
    result = 0
    for _ in range(32):
        result = (result << 1) | (n & 1)
        n >>= 1
    return result


# ── 贪心 ──────────────────────────────────────────────────────────


def can_place_flowers(flowerbed: list[int], n: int) -> bool:
    bed = flowerbed[:]
    planted = 0
    for index in range(len(bed)):
        if bed[index] == 0:
            left_empty = index == 0 or bed[index - 1] == 0
            right_empty = index == len(bed) - 1 or bed[index + 1] == 0
            if left_empty and right_empty:
                bed[index] = 1
                planted += 1
                if planted >= n:
                    return True
    return planted >= n


def lemonade_change(bills: list[int]) -> bool:
    five = 0
    ten = 0
    for bill in bills:
        if bill == 5:
            five += 1
        elif bill == 10:
            if five == 0:
                return False
            five -= 1
            ten += 1
        else:
            if ten > 0 and five > 0:
                ten -= 1
                five -= 1
            elif five >= 3:
                five -= 3
            else:
                return False
    return True


def min_operations(nums: list[int]) -> int:
    operations = 0
    previous = nums[0]
    for value in nums[1:]:
        if value <= previous:
            previous += 1
            operations += previous - value
        else:
            previous = value
    return operations


def min_cost_to_move_chips(chips: list[int]) -> int:
    odd = sum(value % 2 for value in chips)
    return min(odd, len(chips) - odd)


def maximum_units(box_types: list[list[int]], truck_size: int) -> int:
    total = 0
    for boxes, units in sorted(box_types, key=lambda item: -item[1]):
        take = min(boxes, truck_size)
        total += take * units
        truck_size -= take
        if truck_size == 0:
            break
    return total


# ── 数组 / 哈希 / 字符串 ─────────────────────────────────────────


def find_relative_ranks(score: list[int]) -> list[str]:
    order = sorted(range(len(score)), key=lambda index: -score[index])
    result = [""] * len(score)
    medals = ["Gold Medal", "Silver Medal", "Bronze Medal"]
    for rank, index in enumerate(order):
        result[index] = medals[rank] if rank < 3 else str(rank + 1)
    return result


def num_equiv_domino_pairs(dominoes: list[list[int]]) -> int:
    counts: Counter[tuple[int, int]] = Counter()
    total = 0
    for left, right in dominoes:
        key = (left, right) if left <= right else (right, left)
        total += counts[key]
        counts[key] += 1
    return total


def find_error_nums(nums: list[int]) -> list[int]:
    counts = Counter(nums)
    n = len(nums)
    duplicate = next(value for value, count in counts.items() if count == 2)
    missing = next(value for value in range(1, n + 1) if value not in counts)
    return [duplicate, missing]


def num_identical_pairs(nums: list[int]) -> int:
    return sum(count * (count - 1) // 2 for count in Counter(nums).values())


def unique_occurrences(arr: list[int]) -> bool:
    counts = Counter(arr)
    frequencies = list(counts.values())
    return len(frequencies) == len(set(frequencies))


PROBLEMS = [
    make(
        pid=1538,
        title="环形链表",
        tags=["链表", "双指针", "哈希表"],
        description="""给定一个整数数组 head 表示一条单链表的值，以及整数 pos 表示链表末尾连接到的节点下标（从 0 开始）。
若 pos 为 -1，表示链表没有环。
判断链表中是否存在环。""",
        function="hasCycle",
        params=[("head", "int[]"), ("pos", "int")],
        returns="bool",
        solver=has_cycle,
        public=[
            [[3, 2, 0, -4], 1],
            [[1, 2], 0],
            [[1], -1],
            [[1, 2], -1],
        ],
        hidden=[
            [[], -1],
            [[1, 2, 3, 4, 5], 0],
            [[1, 2, 3, 4, 5], 4],
            [[1, 2, 3, 4, 5], -1],
            [[1, 2], 1],
            [[1], 0],
        ],
    ),
    make(
        pid=1539,
        title="相交链表",
        tags=["链表", "双指针"],
        description="""给定两个整数数组 listA、listB 表示两条单链表的值，节点值均为正整数且链表无环。
再给定两个下标 skipA、skipB：
若两者都等于 -1，则两条链表不相交；
否则从 listA[skipA] 与 listB[skipB] 开始，两条链表共享同一段后缀，且两段后缀的值相同。
返回两条链表相交节点的值；若不相交返回 -1。""",
        function="getIntersectionNode",
        params=[
            ("listA", "int[]"),
            ("listB", "int[]"),
            ("skipA", "int"),
            ("skipB", "int"),
        ],
        returns="int",
        solver=get_intersection_node,
        public=[
            [[4, 1, 8, 4, 5], [5, 6, 1, 8, 4, 5], 2, 3],
            [[1, 9, 1, 2, 4], [3, 2, 4], 3, 1],
            [[2, 6, 4], [1, 5], -1, -1],
            [[1], [1], 0, 0],
        ],
        hidden=[
            [[1, 2, 3], [4, 5, 6], -1, -1],
            [[5, 6, 7], [1, 2, 3, 5, 6, 7], 0, 3],
            [[10, 20, 30, 40], [99, 40], 3, 1],
            [[7, 8], [9, 7, 8], 0, 1],
            [[1, 2, 3, 4], [5, 6, 3, 4], 2, 2],
        ],
    ),
    make(
        pid=1540,
        title="下一个更大元素 I",
        tags=["栈", "数组", "哈希表"],
        description="""给定两个没有重复元素的整数数组 nums1 和 nums2，且 nums1 是 nums2 的子集。
对 nums1 中的每个元素，在 nums2 中找到它右侧第一个更大的元素；若不存在，结果为 -1。
按 nums1 的顺序返回结果数组。""",
        function="nextGreaterElement",
        params=[("nums1", "int[]"), ("nums2", "int[]")],
        returns="int[]",
        solver=next_greater_element,
        public=[
            [[4, 1, 2], [1, 3, 4, 2]],
            [[2, 4], [1, 2, 3, 4]],
            [[1], [1]],
            [[2, 1, 3], [2, 1, 3, 4]],
        ],
        hidden=[
            [[1, 3, 5], [5, 4, 3, 2, 1]],
            [[4, 2], [2, 4]],
            [[1, 2, 3], [1, 2, 3]],
            [[7, 6, 5], [5, 6, 7]],
            [[2], [2, 3]],
            [[3, 4], [3, 4, 5]],
        ],
    ),
    make(
        pid=1541,
        title="棒球比赛",
        tags=["栈", "数组", "模拟"],
        description="""给定一个字符串数组 ops 表示棒球比赛的记录，按顺序处理：
整数 x 表示本回合得到 x 分；
"+" 表示本回合得分是前两回合得分之和；
"D" 表示本回合得分是前一回合得分的两倍；
"C" 表示使前一回合的得分无效并将其移除。
返回所有有效回合得分的总和。题目保证操作序列合法。""",
        function="calPoints",
        params=[("ops", "string[]")],
        returns="int",
        solver=cal_points,
        public=[
            [["5", "2", "C", "D", "+"]],
            [["5", "-2", "4", "C", "D", "9", "+", "+"]],
            [["1"]],
            [["1", "C"]],
        ],
        hidden=[
            [["5", "D", "+"]],
            [["1", "2", "3"]],
            [["10", "20", "C", "D"]],
            [["-3", "C"]],
            [["2", "3", "+", "D"]],
            [["4", "C", "5", "D", "+"]],
        ],
    ),
    make(
        pid=1542,
        title="删除字符串中的所有相邻重复项",
        tags=["栈", "字符串"],
        description="""给定只包含小写字母的字符串 s，重复删除相邻且相同的两个字符，直到无法继续删除。
返回最终得到的字符串。""",
        function="removeDuplicates",
        params=[("s", "string")],
        returns="string",
        solver=remove_duplicates,
        public=[
            ["abbaca"],
            ["azxxzy"],
            ["a"],
            ["aa"],
        ],
        hidden=[
            ["abba"],
            ["aab"],
            ["mississippi"],
            ["aaaa"],
            ["abccba"],
        ],
    ),
    make(
        pid=1543,
        title="买票需要的时间",
        tags=["队列", "数组", "模拟"],
        description="""有 n 个人排队买票，tickets[i] 表示第 i 个人想买的票数，每个人每次只能买一张票。
售票员从队首开始，依次为每个人卖一张票；买完所需票数的人立刻离开队列，否则回到队尾。
求第 k 个人（下标从 0 开始）买完所有票需要的时间（按卖出的票数计）。""",
        function="timeRequiredToBuy",
        params=[("tickets", "int[]"), ("k", "int")],
        returns="int",
        solver=time_required_to_buy,
        public=[
            [[2, 3, 2], 2],
            [[5, 1, 1, 1], 0],
            [[1], 0],
            [[3, 4, 5], 1],
        ],
        hidden=[
            [[2, 3, 2], 1],
            [[1, 2, 3, 4, 5], 4],
            [[5, 5, 5], 1],
            [[100], 0],
            [[2, 1, 2, 1, 2], 3],
        ],
    ),
    make(
        pid=1544,
        title="二叉搜索树中的众数",
        tags=["二叉树", "深度优先搜索", "哈希表"],
        description="""给定一棵二叉搜索树的层序序列 root（None 表示空位），找出其中出现次数最多的节点值。
若存在多个众数，按升序返回所有众数。""",
        function="findMode",
        params=[("root", "TreeNode")],
        returns="int[]",
        solver=find_mode,
        public=[
            [[1, None, 2, 2]],
            [[0]],
            [[1, None, 2]],
            [[2, 1, 3]],
        ],
        hidden=[
            [[1, 1]],
            [[3, 1, 4, None, 2]],
            [[2, 2]],
            [[5, 3, 8, 2, 4, 7, 9]],
            [[6, 2, 8, 0, 4, 7, 9, None, None, 2, 6]],
        ],
    ),
    make(
        pid=1545,
        title="二叉搜索树的最小绝对差",
        tags=["二叉搜索树", "树", "深度优先搜索"],
        description="""给定一棵二叉搜索树的层序序列 root（None 表示空位），节点值互不相同。
返回任意两个不同节点值之间的最小绝对差。""",
        function="getMinimumDifference",
        params=[("root", "TreeNode")],
        returns="int",
        solver=get_minimum_difference,
        public=[
            [[4, 2, 6, 1, 3]],
            [[1, 0, 48, None, None, 12, 49]],
            [[5, 4, 7]],
            [[1, None, 2]],
        ],
        hidden=[
            [[236, 104, 701, None, 227, None, 911]],
            [[1, 0, 2]],
            [[10, 5, 15, 2, 8]],
            [[3, 1, 4]],
            [[0, None, 1]],
            [[2, 1]],
        ],
    ),
    make(
        pid=1546,
        title="把二叉搜索树转换为累加树",
        tags=["二叉搜索树", "树", "深度优先搜索"],
        description="""给定一棵二叉搜索树的层序序列 root（None 表示空位）。
把每个节点值替换为原树中大于或等于该节点值的所有节点值之和，返回修改后树的层序序列。""",
        function="convertBST",
        params=[("root", "TreeNode")],
        returns="TreeNode",
        solver=convert_bst,
        public=[
            [[4, 1, 6, 0, 2, 5, 7, None, None, None, 3, None, None, None, 8]],
            [[0, None, 1]],
            [[1, 0, 2]],
            [[2, 1]],
        ],
        hidden=[
            [[1]],
            [[5, 2, 13]],
            [[3, 1, 4, None, 2]],
            [[10, 5, 15]],
            [[2, 1, 3]],
        ],
    ),
    make(
        pid=1547,
        title="二叉树的坡度",
        tags=["树", "二叉树", "深度优先搜索"],
        description="""给定一棵二叉树的层序序列 root（None 表示空位）。
一个节点的坡度定义为它的左子树所有节点值之和与右子树所有节点值之和的绝对差。
返回整棵树中所有节点坡度之和。""",
        function="findTilt",
        params=[("root", "TreeNode")],
        returns="int",
        solver=find_tilt,
        public=[
            [[1, 2, 3]],
            [[4, 2, 9, 3, 5, None, 7]],
            [[21, 7, 14, 1, 1, 2, 2, 3, 3]],
            [[1]],
        ],
        hidden=[
            [[1, None, 2]],
            [[2, 1, 3]],
            [[1, 2, 3, 4, None, None, 5]],
            [[5, 2, 9, None, None, 4, 7]],
            [[0, None, 0]],
        ],
    ),
    make(
        pid=1548,
        title="另一棵树的子树",
        tags=["树", "深度优先搜索", "字符串匹配"],
        description="""给定两棵二叉树的层序序列 root 和 subRoot（None 表示空位）。
判断 subRoot 是否是 root 的某一棵子树：即 root 中存在一个节点，以该节点为根的树与 subRoot 结构和节点值完全相同。""",
        function="isSubtree",
        params=[("root", "TreeNode"), ("subRoot", "TreeNode")],
        returns="bool",
        solver=is_subtree,
        public=[
            [[3, 4, 5, 1, 2], [4, 1, 2]],
            [[3, 4, 5, 1, 2, None, None, None, None, 0], [4, 1, 2]],
            [[1], [1]],
            [[1, None, 1], [1]],
        ],
        hidden=[
            [[1, 2, 3], [2]],
            [[1, 2, 3], [3]],
            [[1, 2, 3, 4, 5], [2, 4, 5]],
            [[1, 2, 3, 4], [2, 4]],
            [[1, 2, 3], [2, 4]],
            [[3, 4, 5, 1, 2], [1, 2]],
        ],
    ),
    make(
        pid=1549,
        title="根据二叉树创建字符串",
        tags=["树", "深度优先搜索", "字符串"],
        description="""给定一棵二叉树的层序序列 root（None 表示空位），按前序遍历把它转换成由括号和整数组成的字符串。
空子树用一对空括号 "()" 表示，但需要省略所有不影响树结构一对一还原的空括号：
若节点有右子节点但没有左子节点，则必须保留左子节点的空括号 "()"。""",
        function="tree2str",
        params=[("root", "TreeNode")],
        returns="string",
        solver=tree2str,
        public=[
            [[1, 2, 3, 4]],
            [[1, 2, 3, None, 4]],
            [[1]],
            [[1, None, 2]],
        ],
        hidden=[
            [[1, 2]],
            [[1, None, 2, 3]],
            [[1, 2, None, 3]],
            [[1, 2, 3]],
            [[1, None, 2, None, 3]],
        ],
    ),
    make(
        pid=1550,
        title="合并二叉树",
        tags=["树", "深度优先搜索", "二叉树"],
        description="""给定两棵二叉树的层序序列 root1 和 root2（None 表示空位）。
把两棵树对应位置的节点值相加，返回合并后树的层序序列：
若两个节点都存在，新节点值为两者之和；若只有一个存在，新节点值取存在的那个。""",
        function="mergeTrees",
        params=[("root1", "TreeNode"), ("root2", "TreeNode")],
        returns="TreeNode",
        solver=merge_trees,
        public=[
            [[1, 3, 2, 5], [2, 1, 3, None, 4, None, 7]],
            [[1], [1, 2]],
            [[1], [2]],
            [[1, 2, 3], [1, 2, 3]],
        ],
        hidden=[
            [[], [1, 2, 3]],
            [[1, 2], [3, None, 4]],
            [[1, 2, 3], [1, 2, 3, 4, 5, 6, 7]],
            [[1, 2], [3, 4, 5]],
            [[1, None, 2], [3, 4]],
        ],
    ),
    make(
        pid=1551,
        title="二叉搜索树中的搜索",
        tags=["二叉搜索树", "树", "递归"],
        description="""给定一棵二叉搜索树的层序序列 root（None 表示空位）和目标值 val。
在树中查找值等于 val 的节点，返回以该节点为根的子树层序序列；若不存在则返回空数组。""",
        function="searchBST",
        params=[("root", "TreeNode"), ("val", "int")],
        returns="TreeNode",
        solver=search_bst,
        public=[
            [[4, 2, 7, 1, 3], 2],
            [[4, 2, 7, 1, 3], 5],
            [[1], 1],
            [[4, 2, 7, 1, 3], 7],
        ],
        hidden=[
            [[], 1],
            [[8, 3, 10, 1, 6, None, 14, None, None, 4, 7, 13, None], 6],
            [[5, 3, 8], 3],
            [[5, 3, 8], 9],
            [[2, 1, 3], 2],
        ],
    ),
    make(
        pid=1552,
        title="二叉搜索树的范围和",
        tags=["二叉搜索树", "树", "深度优先搜索"],
        description="""给定一棵二叉搜索树的层序序列 root（None 表示空位）以及整数 low、high。
返回树中所有值在闭区间 [low, high] 内的节点值之和。""",
        function="rangeSumBST",
        params=[("root", "TreeNode"), ("low", "int"), ("high", "int")],
        returns="int",
        solver=range_sum_bst,
        public=[
            [[10, 5, 15, 3, 7, None, 18], 7, 15],
            [[10, 5, 15, 3, 7, 13, 18, 1, None, 6], 6, 10],
            [[1], 1, 1],
            [[5, 3, 8], 2, 6],
        ],
        hidden=[
            [[10, 5, 15, 3, 7, None, 18], 5, 15],
            [[], 1, 2],
            [[2, 1, 3], 1, 3],
            [[5, 3, 8], 9, 10],
            [[20, 10, 30, 5, 15, 25, 35], 10, 30],
        ],
    ),
    make(
        pid=1553,
        title="查找共用字符",
        tags=["数组", "哈希表", "字符串"],
        description="""给定一个字符串数组 words，找出在所有字符串中都出现过的字符。
每个字符在结果中出现的次数等于它在所有字符串中出现次数的最小值。
按字母升序返回结果，每个字符重复对应的次数。""",
        function="findCommonChars",
        params=[("words", "string[]")],
        returns="string[]",
        solver=find_common_chars,
        public=[
            [["bella", "label", "roller"]],
            [["cool", "lock", "cook"]],
            [["a", "a"]],
            [["abc", "def"]],
        ],
        hidden=[
            [["a"]],
            [["ab", "ab", "ab"]],
            [["abcd", "ab", "a"]],
            [["zz", "zzz", "zzzz"]],
            [["hello", "world"]],
            [["b", "b"]],
        ],
    ),
    make(
        pid=1554,
        title="一年中的第几天",
        tags=["数学", "字符串"],
        description="""给定格式为 YYYY-MM-DD 的日期字符串 date，返回这一天是该年的第几天。
需正确处理闰年：能被 400 整除，或能被 4 整除但不能被 100 整除的年份为闰年。""",
        function="dayOfYear",
        params=[("date", "string")],
        returns="int",
        solver=day_of_year,
        public=[
            ["2019-01-09"],
            ["2019-02-10"],
            ["2003-03-01"],
            ["2004-03-01"],
        ],
        hidden=[
            ["2019-12-31"],
            ["2020-12-31"],
            ["1900-03-01"],
            ["2000-03-01"],
            ["2016-02-29"],
            ["2021-01-01"],
        ],
    ),
    make(
        pid=1555,
        title="构造矩形",
        tags=["数学"],
        description="""给定矩形面积 area，返回由两个整数组成的长和宽 [length, width]：
要求 length >= width，length * width == area，且 length 与 width 的差最小。
结果数组中第一项为长、第二项为宽。""",
        function="constructRectangle",
        params=[("area", "int")],
        returns="int[]",
        solver=construct_rectangle,
        public=[[4], [2], [37], [122122]],
        hidden=[[1], [3], [6], [12], [100], [1000000]],
    ),
    make(
        pid=1556,
        title="七进制数",
        tags=["数学", "字符串"],
        description="""给定整数 num，返回它的七进制表示字符串。负数需要保留负号。""",
        function="convertToBase7",
        params=[("num", "int")],
        returns="string",
        solver=convert_to_base7,
        public=[[100], [-7], [0], [7]],
        hidden=[[1], [-1], [49], [50], [-100]],
    ),
    make(
        pid=1557,
        title="完美数",
        tags=["数学"],
        description="""完全数是指一个正整数，它所有的正因子（不包含自身）之和恰好等于它本身。
给定整数 num，判断它是否为完全数。""",
        function="checkPerfectNumber",
        params=[("num", "int")],
        returns="bool",
        solver=check_perfect_number,
        public=[[28], [6], [496], [2]],
        hidden=[[1], [12], [27], [8128], [33550336]],
    ),
    make(
        pid=1558,
        title="找出数组的最大公约数",
        tags=["数学", "数组", "数论"],
        description="""给定一个正整数数组 nums，返回数组中最大值与最小值的最大公约数。""",
        function="findGCD",
        params=[("nums", "int[]")],
        returns="int",
        solver=find_gcd,
        public=[
            [[2, 5, 6, 9, 10]],
            [[7, 5, 6, 8, 3]],
            [[3, 3]],
            [[1, 1]],
        ],
        hidden=[
            [[2, 4, 6, 8]],
            [[9, 6]],
            [[10, 10, 10]],
            [[5, 10, 15, 20]],
            [[13, 17]],
            [[1, 2, 3]],
        ],
    ),
    make(
        pid=1559,
        title="矩形重叠",
        tags=["数学", "几何"],
        description="""矩形用数组 [x1, y1, x2, y2] 表示，(x1, y1) 为左下角，(x2, y2) 为右上角。
给定两个矩形 rec1 和 rec2，判断它们是否重叠。
仅边或点接触不算重叠。""",
        function="isRectangleOverlap",
        params=[("rec1", "int[]"), ("rec2", "int[]")],
        returns="bool",
        solver=is_rectangle_overlap,
        public=[
            [[0, 0, 2, 2], [1, 1, 3, 3]],
            [[0, 0, 1, 1], [1, 0, 2, 1]],
            [[0, 0, 1, 1], [2, 2, 3, 3]],
            [[0, 0, 2, 2], [0, 0, 2, 2]],
        ],
        hidden=[
            [[0, 0, 2, 2], [0, 2, 2, 3]],
            [[5, 5, 10, 10], [4, 4, 6, 6]],
            [[-1, -1, 1, 1], [0, 0, 2, 2]],
            [[0, 0, 1, 1], [1, 1, 2, 2]],
            [[1, 1, 2, 2], [0, 0, 3, 3]],
        ],
    ),
    make(
        pid=1560,
        title="比特位计数",
        tags=["位运算", "动态规划", "数组"],
        description="""给定整数 n，返回长度为 n + 1 的数组 ans，其中 ans[i] 是整数 i 的二进制表示中 1 的个数。
结果按 i 从 0 到 n 的顺序排列。""",
        function="countBits",
        params=[("n", "int")],
        returns="int[]",
        solver=count_bits,
        public=[[2], [5], [0], [1]],
        hidden=[[3], [4], [8], [10], [16]],
    ),
    make(
        pid=1561,
        title="二进制表示中质数个计算置位",
        tags=["位运算", "数学"],
        description="""给定两个整数 left 和 right，统计闭区间 [left, right] 内有多少个整数的二进制表示中
1 的个数是质数。""",
        function="countPrimeSetBits",
        params=[("left", "int"), ("right", "int")],
        returns="int",
        solver=count_prime_set_bits,
        public=[
            [6, 10],
            [10, 15],
            [1, 1],
            [2, 2],
        ],
        hidden=[
            [1, 10],
            [4, 4],
            [3, 3],
            [10, 10],
            [1, 2],
        ],
    ),
    make(
        pid=1562,
        title="二进制间距",
        tags=["位运算"],
        description="""给定正整数 n，返回其二进制表示中两个相邻的 1 之间的最大距离。
若二进制表示中 1 的个数少于 2，返回 0。""",
        function="binaryGap",
        params=[("n", "int")],
        returns="int",
        solver=binary_gap,
        public=[[22], [8], [5], [6]],
        hidden=[[1], [2], [3], [7], [100], [1024]],
    ),
    make(
        pid=1563,
        title="十进制整数的反码",
        tags=["位运算"],
        description="""每个非负整数的二进制表示都不含前导零。将其所有位取反得到反码。
给定非负整数 n，返回它的反码对应的十进制值。""",
        function="bitwiseComplement",
        params=[("n", "int")],
        returns="int",
        solver=bitwise_complement,
        public=[[5], [7], [10], [0]],
        hidden=[[1], [2], [3], [4], [8], [1024]],
    ),
    make(
        pid=1564,
        title="颠倒二进制位",
        tags=["位运算"],
        description="""给定一个非负整数 n，把它看作 32 位无符号整数的二进制表示，将所有位按位颠倒后返回结果。
输入保证颠倒后的结果不超过 2^31 - 1。""",
        function="reverseBits",
        params=[("n", "int")],
        returns="int",
        solver=reverse_bits,
        public=[[43261596], [2], [4], [0]],
        hidden=[[8], [16], [32], [64], [964176192], [1073741824]],
    ),
    make(
        pid=1565,
        title="种花问题",
        tags=["贪心", "数组"],
        description="""给定一个由 0 和 1 组成的数组 flowerbed 表示花坛，0 表示空位，1 表示已种花。
再给定整数 n。花不能种在相邻的两个位置上。
判断能否在不移动已有花的前提下，种下至多 n 朵新花（可以少于 n 朵，只要还能空出位置）。
实际要求为：是否存在一种方式恰好种下 n 朵新花。""",
        function="canPlaceFlowers",
        params=[("flowerbed", "int[]"), ("n", "int")],
        returns="bool",
        solver=can_place_flowers,
        public=[
            [[1, 0, 0, 0, 1], 1],
            [[1, 0, 0, 0, 1], 2],
            [[0, 0, 1, 0, 0], 2],
            [[0], 1],
        ],
        hidden=[
            [[0], 0],
            [[1], 1],
            [[0, 0, 0], 1],
            [[0, 0, 0], 2],
            [[0, 0, 0, 0], 2],
        ],
    ),
    make(
        pid=1566,
        title="柠檬水找零",
        tags=["贪心", "数组"],
        description="""一杯柠檬水售价 5 美元。顾客只可能用 5、10 或 20 美元付款。
给定按顺序付款的钞票数组 bills，开始时你没有任何零钱。
判断是否能正确给每位顾客找零。""",
        function="lemonadeChange",
        params=[("bills", "int[]")],
        returns="bool",
        solver=lemonade_change,
        public=[
            [[5, 5, 5, 10, 20]],
            [[5, 5, 10, 10, 20]],
            [[5, 5, 10]],
            [[10, 10]],
        ],
        hidden=[
            [[5]],
            [[20]],
            [[5, 5, 5, 20]],
            [[5, 10, 5, 20]],
            [[5, 5, 5, 5, 10, 5, 10, 10, 10, 20]],
        ],
    ),
    make(
        pid=1567,
        title="最少操作使数组递增",
        tags=["贪心", "数组"],
        description="""给定整数数组 nums。每次操作可以选择任意一个元素并把它增加 1。
返回使数组严格递增所需的最少操作次数。""",
        function="minOperations",
        params=[("nums", "int[]")],
        returns="int",
        solver=min_operations,
        public=[
            [[1, 1, 1]],
            [[1, 5, 2, 4, 1]],
            [[8]],
            [[1, 2, 3]],
        ],
        hidden=[
            [[1, 1]],
            [[3, 2, 1]],
            [[1, 2, 2]],
            [[5, 4, 3, 2, 1]],
            [[0, 0]],
        ],
    ),
    make(
        pid=1568,
        title="玩筹码",
        tags=["贪心", "数学", "数组"],
        description="""给定整数数组 chips，其中 chips[i] 表示第 i 个筹码所在的位置。
可以把任意筹码向左或向右移动 2 个位置，代价为 0；
也可以向左或向右移动 1 个位置，代价为 1。
返回把所有筹码移动到同一位置所需的最小代价。""",
        function="minCostToMoveChips",
        params=[("chips", "int[]")],
        returns="int",
        solver=min_cost_to_move_chips,
        public=[
            [[1, 2, 3]],
            [[2, 2, 2, 3, 3]],
            [[1, 2, 2, 2, 2]],
            [[1]],
        ],
        hidden=[
            [[2, 2]],
            [[1, 3, 5]],
            [[1, 2]],
            [[1, 3, 2, 4]],
            [[1, 1, 1, 2, 2, 2]],
        ],
    ),
    make(
        pid=1569,
        title="卡车上的最大单元数",
        tags=["贪心", "数组", "排序"],
        description="""给定二维整数数组 boxTypes，其中 boxTypes[i] = [numberOfBoxes, unitsPerBox]
表示第 i 类箱子有 numberOfBoxes 个，每个箱子装有 unitsPerBox 个单元。
再给定卡车最多能装载的箱子数 truckSize。
选择不超过 truckSize 个箱子装车，返回能装载的最大单元总数。""",
        function="maximumUnits",
        params=[("boxTypes", "int[][]"), ("truckSize", "int")],
        returns="int",
        solver=maximum_units,
        public=[
            [[[1, 3], [2, 2], [3, 1]], 4],
            [[[5, 10], [2, 5], [4, 7], [3, 9]], 10],
            [[[1, 1]], 1],
            [[[2, 3], [3, 4]], 1],
        ],
        hidden=[
            [[[1, 5]], 0],
            [[[3, 2]], 1],
            [[[1, 4], [2, 3], [1, 2]], 3],
            [[[2, 1], [1, 10], [3, 2]], 4],
            [[[1, 1], [1, 1]], 2],
        ],
    ),
    make(
        pid=1570,
        title="相对名次",
        tags=["数组", "排序", "字符串"],
        description="""给定分数互不相同的整数数组 score。
按分数从高到低确定名次：前三名分别返回 "Gold Medal"、"Silver Medal"、"Bronze Medal"，
其余名次返回排名的十进制字符串（如第 4 名返回 "4"）。
结果数组按 score 的原顺序返回。""",
        function="findRelativeRanks",
        params=[("score", "int[]")],
        returns="string[]",
        solver=find_relative_ranks,
        public=[
            [[5, 4, 3, 2, 1]],
            [[10, 3, 8, 9, 4]],
            [[1]],
            [[2, 1]],
        ],
        hidden=[
            [[3, 1, 2]],
            [[1, 2, 3]],
            [[10, 20, 30, 40, 50]],
            [[7, 8]],
            [[100, 50, 25, 12, 6, 3]],
        ],
    ),
    make(
        pid=1571,
        title="等价多米诺骨牌对的数量",
        tags=["数组", "哈希表", "计数"],
        description="""给定二维整数数组 dominoes，其中 dominoes[i] = [a, b] 表示一块多米诺骨牌的两端数字。
若两块骨牌 (a, b) 与 (c, d) 满足 a == c 且 b == d，或者 a == d 且 b == c，
则称它们等价。统计满足 i < j 且两块骨牌等价的骨牌对数量。""",
        function="numEquivDominoPairs",
        params=[("dominoes", "int[][]")],
        returns="int",
        solver=num_equiv_domino_pairs,
        public=[
            [[[1, 2], [2, 1], [3, 4], [5, 6]]],
            [[[1, 2], [1, 2], [1, 1], [1, 2], [2, 2]]],
            [[[1, 1]]],
            [[[1, 2], [2, 1]]],
        ],
        hidden=[
            [[[1, 1], [1, 1], [1, 1]]],
            [[[1, 2], [3, 4]]],
            [[[2, 1], [1, 2], [2, 1], [1, 2]]],
            [[[1, 1], [2, 2], [1, 1]]],
            [[[3, 4], [4, 3], [3, 4]]],
        ],
    ),
    make(
        pid=1572,
        title="错误的集合",
        tags=["数学", "数组", "哈希表"],
        description="""集合本应包含 1 到 n 的所有整数，但其中一个数重复出现，另一个数缺失。
给定长度为 n 的整数数组 nums，返回 [重复的数, 缺失的数]。""",
        function="findErrorNums",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=find_error_nums,
        public=[
            [[1, 2, 2, 4]],
            [[1, 1]],
            [[2, 2]],
            [[3, 1, 3]],
        ],
        hidden=[
            [[1, 2, 2, 3]],
            [[1, 2, 3, 4, 4, 6]],
            [[1, 1, 2, 3, 4]],
            [[1, 2, 3, 4, 5, 5]],
            [[2, 3, 3, 4]],
        ],
    ),
    make(
        pid=1573,
        title="好数对的数目",
        tags=["数组", "哈希表", "数学"],
        description="""给定整数数组 nums。若下标对 (i, j) 满足 i < j 且 nums[i] == nums[j]，
则称其为一个好数对。返回好数对的总数。""",
        function="numIdenticalPairs",
        params=[("nums", "int[]")],
        returns="int",
        solver=num_identical_pairs,
        public=[
            [[1, 2, 3, 1, 1, 3]],
            [[1, 1, 1, 1]],
            [[1, 2, 3]],
            [[1, 1]],
        ],
        hidden=[
            [[1]],
            [[1, 2, 1]],
            [[2, 2, 2]],
            [[4, 4, 4, 4, 4]],
            [[1, 2, 3, 4, 5]],
        ],
    ),
    make(
        pid=1574,
        title="独一无二的出现次数",
        tags=["哈希表", "数组"],
        description="""给定整数数组 arr，统计每个值出现的次数。
若所有值出现的次数互不相同，返回 true；否则返回 false。""",
        function="uniqueOccurrences",
        params=[("arr", "int[]")],
        returns="bool",
        solver=unique_occurrences,
        public=[
            [[1, 2, 2, 1, 1, 3]],
            [[1, 2]],
            [[-3, 0, 1, -3, 1, 1, 1, -3, 10, 0]],
            [[1, 1, 2, 2]],
        ],
        hidden=[
            [[1]],
            [[1, 1]],
            [[1, 1, 2]],
            [[1, 2, 3]],
            [[1, 1, 2, 2, 3]],
        ],
    ),
]

"""1338-1374：批量第一批简单题（37 道）。"""

from __future__ import annotations

from collections import Counter, deque
from functools import partial

from problem_seed_common import Node, make_problem, tree_from_list, tree_to_list

make = partial(make_problem, difficulty="easy")


def sum_odd_length_subarrays(arr: list[int]) -> int:
    total = 0
    for start in range(len(arr)):
        value = 0
        for end in range(start, len(arr)):
            value += arr[end]
            if (end - start + 1) % 2:
                total += value
    return total


def find_the_distance_value(arr1: list[int], arr2: list[int], d: int) -> int:
    return sum(all(abs(left - right) > d for right in arr2) for left in arr1)


def magic_index(nums: list[int]) -> int:
    for index, value in enumerate(nums):
        if index == value:
            return index
    return -1


def check_permutation(s1: str, s2: str) -> bool:
    return sorted(s1) == sorted(s2)


def replace_spaces(s: str, length: int) -> str:
    return s[:length].replace(" ", "%20")


def one_edit_away(first: str, second: str) -> bool:
    if abs(len(first) - len(second)) > 1:
        return False
    if len(first) > len(second):
        first, second = second, first
    i = j = 0
    edited = False
    while i < len(first) and j < len(second):
        if first[i] == second[j]:
            i += 1
            j += 1
        elif edited:
            return False
        else:
            edited = True
            if len(first) == len(second):
                i += 1
            j += 1
    return True


def count_negatives(grid: list[list[int]]) -> int:
    return sum(value < 0 for row in grid for value in row)


def freq_alphabets(s: str) -> str:
    result: list[str] = []
    index = len(s) - 1
    while index >= 0:
        if s[index] == "#":
            value = int(s[index - 2 : index])
            index -= 3
        else:
            value = int(s[index])
            index -= 1
        result.append(chr(ord("a") + value - 1))
    return "".join(reversed(result))


def rotated_digits(n: int) -> int:
    invalid = set("347")
    changed = set("2569")
    count = 0
    for value in range(1, n + 1):
        digits = str(value)
        if any(digit in invalid for digit in digits):
            continue
        if any(digit in changed for digit in digits):
            count += 1
    return count


def minimum_abs_difference(arr: list[int]) -> list[list[int]]:
    ordered = sorted(arr)
    best = min(
        right - left for left, right in zip(ordered, ordered[1:])
    )
    return [
        [left, right]
        for left, right in zip(ordered, ordered[1:])
        if right - left == best
    ]


def add_to_array_form(num: list[int], k: int) -> list[int]:
    value = int("".join(str(digit) for digit in num)) + k
    return [int(digit) for digit in str(value)]


def prefixes_div_by_5(nums: list[int]) -> list[bool]:
    remainder = 0
    result = []
    for bit in nums:
        remainder = (remainder * 2 + bit) % 5
        result.append(remainder == 0)
    return result


def surface_area(grid: list[list[int]]) -> int:
    size = len(grid)
    area = 0
    for row in range(size):
        for column in range(size):
            height = grid[row][column]
            if height == 0:
                continue
            area += 4 * height + 2
            if row + 1 < size:
                area -= 2 * min(height, grid[row + 1][column])
            if column + 1 < size:
                area -= 2 * min(height, grid[row][column + 1])
    return area


def min_time_to_visit_all_points(points: list[list[int]]) -> int:
    total = 0
    for (x1, y1), (x2, y2) in zip(points, points[1:]):
        total += max(abs(x1 - x2), abs(y1 - y2))
    return total


def tribonacci(n: int) -> int:
    if n == 0:
        return 0
    if n <= 2:
        return 1
    first, second, third = 0, 1, 1
    for _ in range(3, n + 1):
        first, second, third = second, third, first + second + third
    return third


def shuffle(nums: list[int], n: int) -> list[int]:
    result: list[int] = []
    for index in range(n):
        result.extend([nums[index], nums[index + n]])
    return result


def running_sum(nums: list[int]) -> list[int]:
    result = []
    total = 0
    for value in nums:
        total += value
        result.append(total)
    return result


def can_three_parts_equal_sum(arr: list[int]) -> bool:
    total = sum(arr)
    if total % 3:
        return False
    target = total // 3
    prefix = 0
    first = -1
    for index, value in enumerate(arr):
        prefix += value
        if first == -1 and prefix == target:
            first = index
        elif first != -1 and prefix == 2 * target and index > first and index < len(arr) - 1:
            return True
    return False


def find_lucky(arr: list[int]) -> int:
    counts = Counter(arr)
    values = [value for value, count in counts.items() if value == count]
    return max(values) if values else -1


def subtract_product_and_sum(n: int) -> int:
    digits = [int(digit) for digit in str(n)]
    product = 1
    for digit in digits:
        product *= digit
    return product - sum(digits)


def num_water_bottles(num_bottles: int, num_exchange: int) -> int:
    total = num_bottles
    empty = num_bottles
    while empty >= num_exchange:
        new_bottles = empty // num_exchange
        total += new_bottles
        empty = empty % num_exchange + new_bottles
    return total


def subset_xor_sum(nums: list[int]) -> int:
    union = 0
    for value in nums:
        union |= value
    return union * (1 << (len(nums) - 1))


def get_min_distance(nums: list[int], target: int, start: int) -> int:
    return min(
        abs(index - start) for index, value in enumerate(nums) if value == target
    )


def is_prefix_of_word(sentence: str, search_word: str) -> int:
    for index, word in enumerate(sentence.split(" "), start=1):
        if word.startswith(search_word):
            return index
    return -1


def count_students(students: list[int], sandwiches: list[int]) -> int:
    counts = [0, 0]
    for student in students:
        counts[student] += 1
    for sandwich in sandwiches:
        if counts[sandwich] == 0:
            break
        counts[sandwich] -= 1
    return counts[0] + counts[1]


def decompress_rle_list(nums: list[int]) -> list[int]:
    result: list[int] = []
    for index in range(0, len(nums), 2):
        result.extend([nums[index + 1]] * nums[index])
    return result


def get_decimal_value(head: list[int]) -> int:
    value = 0
    for bit in head:
        value = value * 2 + bit
    return value


def remove_elements(head: list[int], val: int) -> list[int]:
    return [value for value in head if value != val]


def get_kth_from_end(head: list[int], k: int) -> list[int]:
    return head[len(head) - k :]


def min_depth(root: list[int | None]) -> int:
    node = tree_from_list(root)
    if node is None:
        return 0
    queue = deque([(node, 1)])
    while queue:
        current, depth = queue.popleft()
        if current.left is None and current.right is None:
            return depth
        if current.left:
            queue.append((current.left, depth + 1))
        if current.right:
            queue.append((current.right, depth + 1))
    return 0


def is_same_tree(p: list[int | None], q: list[int | None]) -> bool:
    def compare(left: Node | None, right: Node | None) -> bool:
        if left is None or right is None:
            return left is right
        return (
            left.value == right.value
            and compare(left.left, right.left)
            and compare(left.right, right.right)
        )

    return compare(tree_from_list(p), tree_from_list(q))


def is_balanced(root: list[int | None]) -> bool:
    def height(node: Node | None) -> int:
        if node is None:
            return 0
        left = height(node.left)
        if left == -1:
            return -1
        right = height(node.right)
        if right == -1 or abs(left - right) > 1:
            return -1
        return max(left, right) + 1

    return height(tree_from_list(root)) != -1


def average_of_levels(root: list[int | None]) -> list[float]:
    node = tree_from_list(root)
    if node is None:
        return []
    result: list[float] = []
    queue = deque([node])
    while queue:
        size = len(queue)
        total = 0
        for _ in range(size):
            current = queue.popleft()
            total += current.value
            if current.left:
                queue.append(current.left)
            if current.right:
                queue.append(current.right)
        result.append(total / size)
    return result


def binary_tree_paths(root: list[int | None]) -> list[str]:
    node = tree_from_list(root)
    if node is None:
        return []
    result: list[str] = []

    def visit(current: Node, path: list[int]) -> None:
        path.append(current.value)
        if current.left is None and current.right is None:
            result.append("->".join(str(value) for value in path))
        else:
            if current.left:
                visit(current.left, path)
            if current.right:
                visit(current.right, path)
        path.pop()

    visit(node, [])
    return result


def sum_of_left_leaves(root: list[int | None]) -> int:
    node = tree_from_list(root)
    total = 0

    def visit(current: Node | None, is_left: bool) -> None:
        nonlocal total
        if current is None:
            return
        if is_left and current.left is None and current.right is None:
            total += current.value
        visit(current.left, True)
        visit(current.right, False)

    visit(node, False)
    return total


def leaf_similar(root1: list[int | None], root2: list[int | None]) -> bool:
    def leaves(root: list[int | None]) -> list[int]:
        node = tree_from_list(root)
        result: list[int] = []

        def visit(current: Node | None) -> None:
            if current is None:
                return
            if current.left is None and current.right is None:
                result.append(current.value)
            visit(current.left)
            visit(current.right)

        visit(node)
        return result

    return leaves(root1) == leaves(root2)


def is_unival_tree(root: list[int | None]) -> bool:
    node = tree_from_list(root)
    if node is None:
        return True

    def visit(current: Node | None, value: int) -> bool:
        if current is None:
            return True
        return current.value == value and visit(current.left, value) and visit(current.right, value)

    return visit(node, node.value)


PROBLEMS = [
    make(
        pid=1338,
        title="所有奇数长度子数组的和",
        tags=["数组", "前缀和"],
        description="""返回数组 arr 所有奇数长度连续子数组的元素之和的总和。""",
        function="sumOddLengthSubarrays",
        params=[("arr", "int[]")],
        returns="int",
        solver=sum_odd_length_subarrays,
        public=[[[1, 4, 2, 5, 3]], [[1, 2]], [[10, 11, 12]]],
        hidden=[[[1]], [[1, 1]], [[1, 1, 1]], [[2, 3, 4, 5]]],
    ),
    make(
        pid=1339,
        title="两个数组间的距离值",
        tags=["数组", "二分查找"],
        description="""返回 arr1 中满足以下条件的元素个数：
对任意 arr2[j]，都有 |arr1[i] - arr2[j]| > d。""",
        function="findTheDistanceValue",
        params=[("arr1", "int[]"), ("arr2", "int[]"), ("d", "int")],
        returns="int",
        solver=find_the_distance_value,
        public=[
            [[4, 5, 8], [10, 9, 1, 8], 2],
            [[1, 4, 2, 3], [-4, -3, 6, 10, 20, 30], 3],
            [[2, 1, 100, 3], [-5, -2, 10, -3, 7], 6],
        ],
        hidden=[[[1], [2], 0], [[1], [1], 0], [[1], [1], 1], [[5, 6], [1, 10], 3]],
    ),
    make(
        pid=1340,
        title="魔法索引",
        tags=["数组", "二分查找"],
        description="""给定按非递减顺序排列的整数数组 nums，返回最小的下标 i 使 nums[i] == i。
不存在这样的下标返回 -1。""",
        function="findMagicIndex",
        params=[("nums", "int[]")],
        returns="int",
        solver=magic_index,
        public=[[[0, 2, 3, 4, 5]], [[1, 1, 3]], [[0, 0, 2]], [[-1, 0, 1]]],
        hidden=[[[2]], [[0]], [[-2, -1, 0, 1]], [[1, 2, 3]], [[0, 1, 2]]],
    ),
    make(
        pid=1341,
        title="判定是否互为字符重排",
        tags=["字符串", "哈希表", "排序"],
        description="""给定两个字符串 s1 和 s2，判断 s2 是否由 s1 的字符重新排列得到
（字符种类和数量完全相同）。""",
        function="CheckPermutation",
        params=[("s1", "string"), ("s2", "string")],
        returns="bool",
        solver=check_permutation,
        public=[["abc", "bca"], ["abc", "bad"], ["a", "a"]],
        hidden=[["a", "b"], ["ab", "ba"], ["aab", "abb"], ["", ""]],
    ),
    make(
        pid=1342,
        title="URL 化",
        tags=["字符串"],
        description="""给定字符串 s（末尾用空格补足长度）和有效长度 length，
将前 length 个字符中的空格全部替换为 "%20"，返回结果。""",
        function="replaceSpaces",
        params=[("s", "string"), ("length", "int")],
        returns="string",
        solver=replace_spaces,
        public=[["Mr John Smith    ", 13], ["a b", 3], ["abc", 3]],
        hidden=[[" ", 1], ["  ", 2], ["a  b    ", 4], ["hello", 5]],
    ),
    make(
        pid=1343,
        title="一次编辑",
        tags=["字符串", "双指针"],
        description="""判断两个字符串是否最多经过一次插入、删除或替换操作就能相等。""",
        function="oneEditAway",
        params=[("first", "string"), ("second", "string")],
        returns="bool",
        solver=one_edit_away,
        public=[["pale", "ple"], ["pales", "pal"], ["pale", "bale"]],
        hidden=[["a", "a"], ["a", "b"], ["ab", "ba"], ["abc", "abc"], ["abc", "abcd"], ["", "a"]],
    ),
    make(
        pid=1344,
        title="统计有序矩阵中的负数",
        tags=["数组", "矩阵", "二分查找"],
        description="""给定按行、列均非递增排列的矩阵 grid，返回其中负数的个数。""",
        function="countNegatives",
        params=[("grid", "int[][]")],
        returns="int",
        solver=count_negatives,
        public=[
            [[[4, 3, 2, -1], [3, 2, 1, -1], [1, 1, -1, -2], [-1, -1, -2, -3]]],
            [[[3, 2], [1, 0]]],
            [[[1, 2, 3]]],
        ],
        hidden=[[[[-1]]], [[[0]]], [[[-1, -2], [-3, -4]]], [[[5, 4], [3, 2]]]],
    ),
    make(
        pid=1345,
        title="解码字母到整数映射",
        tags=["字符串"],
        description="""'1' 到 '9' 映射到 'a' 到 'i'，'10#' 到 '26#' 映射到 'j' 到 'z'。
给定编码字符串 s，返回解码后的字符串。""",
        function="freqAlphabets",
        params=[("s", "string")],
        returns="string",
        solver=freq_alphabets,
        public=[["10#11#12"], ["1326#"], ["25#"]],
        hidden=[["1"], ["26#"], ["10#1"], ["25#26#"], ["12#"]],
    ),
    make(
        pid=1346,
        title="旋转数字",
        tags=["数学", "动态规划"],
        description="""好数指旋转 180 度后每位仍是有效数字（0、1、8 不变，2 与 5 互换，6 与 9 互换），
且至少有一位发生变化的数。返回 [1, n] 中好数的个数。""",
        function="rotatedDigits",
        params=[("n", "int")],
        returns="int",
        solver=rotated_digits,
        public=[[10], [1], [2]],
        hidden=[[20], [100], [857], [5]],
    ),
    make(
        pid=1347,
        title="最小绝对差",
        tags=["数组", "排序"],
        description="""返回数组 arr 中所有具有最小绝对差的元素对 [a, b]（a <= b），按 a 升序排列。""",
        function="minimumAbsDifference",
        params=[("arr", "int[]")],
        returns="int[][]",
        solver=minimum_abs_difference,
        public=[
            [[4, 2, 1, 3]],
            [[1, 3, 6, 10, 15]],
            [[3, 8, -10, 23, 19, -4, -14, 27]],
        ],
        hidden=[[[1, 2]], [[1, 1]], [[5, 4, 3]], [[-1, -3, 0]]],
    ),
    make(
        pid=1348,
        title="数组形式的整数加法",
        tags=["数组", "数学"],
        description="""非负整数 num 以数组形式给出（最高位在前）。返回 num + k 的数组形式。""",
        function="addToArrayForm",
        params=[("num", "int[]"), ("k", "int")],
        returns="int[]",
        solver=add_to_array_form,
        public=[[[1, 2, 0, 0], 34], [[2, 7, 4], 181], [[2, 1, 5], 806]],
        hidden=[[[0], 0], [[0], 23], [[9, 9, 9], 1], [[1, 0, 0, 0], 1000]],
    ),
    make(
        pid=1349,
        title="可被 5 整除的二进制前缀",
        tags=["数组", "位运算"],
        description="""给定由 0 和 1 组成的数组 nums。对每个前缀，判断其二进制数值是否能被 5 整除，
返回布尔数组。""",
        function="prefixesDivBy5",
        params=[("nums", "int[]")],
        returns="bool[]",
        solver=prefixes_div_by_5,
        public=[[[0, 1, 1]], [[1, 1, 1]], [[0, 1, 1, 1, 1, 1]]],
        hidden=[[[0]], [[1]], [[1, 0, 1]], [[1, 1, 0, 1]]],
    ),
    make(
        pid=1350,
        title="三维形体的表面积",
        tags=["数组", "矩阵", "几何"],
        description="""给定 n x n 网格 grid，grid[i][j] 表示该位置叠放的立方体数量。
返回所有立方体暴露在外的总表面积。""",
        function="surfaceArea",
        params=[("grid", "int[][]")],
        returns="int",
        solver=surface_area,
        public=[
            [[[2]]],
            [[[1, 2], [3, 4]]],
            [[[1, 0], [0, 2]]],
        ],
        hidden=[[[[0]]], [[[1, 1, 1], [1, 1, 1], [1, 1, 1]]], [[[1, 0], [0, 1]]]],
    ),
    make(
        pid=1351,
        title="访问所有点的最小时间",
        tags=["数组", "数学"],
        description="""按顺序访问 points 中的所有点。每步可以水平、垂直或对角线移动一个单位。
返回访问所有点的最小总时间。""",
        function="minTimeToVisitAllPoints",
        params=[("points", "int[][]")],
        returns="int",
        solver=min_time_to_visit_all_points,
        public=[
            [[[1, 1], [3, 4], [-1, 0]]],
            [[[3, 2], [-2, 2]]],
            [[[0, 0], [1, 1]]],
        ],
        hidden=[[[[0, 0]]], [[[0, 0], [1, 0]]], [[[0, 0], [2, 2]]], [[[1, 1], [1, 1]]]],
    ),
    make(
        pid=1352,
        title="第 N 个泰波那契数",
        tags=["数学", "动态规划"],
        description="""T0 = 0，T1 = 1，T2 = 1，且 Tn = Tn-1 + Tn-2 + Tn-3。
给定 n（0 <= n <= 37），返回 Tn。""",
        function="tribonacci",
        params=[("n", "int")],
        returns="int",
        solver=tribonacci,
        public=[[4], [25], [0]],
        hidden=[[1], [2], [3], [5], [10]],
    ),
    make(
        pid=1353,
        title="重新排列数组",
        tags=["数组"],
        description="""给定长度为 2n 的数组 nums，前 n 个元素为 x 部分，后 n 个元素为 y 部分。
返回 [x1, y1, x2, y2, ..., xn, yn]。""",
        function="shuffle",
        params=[("nums", "int[]"), ("n", "int")],
        returns="int[]",
        solver=shuffle,
        public=[[[2, 5, 1, 3, 4, 7], 3], [[1, 2, 3, 4, 4, 3, 2, 1], 4], [[1, 1, 2, 2], 2]],
        hidden=[[[1, 2], 1], [[1, 2, 3, 4], 2]],
    ),
    make(
        pid=1354,
        title="一维数组的动态和",
        tags=["数组", "前缀和"],
        description="""返回数组 nums 的动态和：runningSum[i] = sum(nums[0..i])。""",
        function="runningSum",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=running_sum,
        public=[[[1, 2, 3, 4]], [[1, 1, 1, 1, 1]], [[3, 1, 2, 10, 1]]],
        hidden=[[[1]], [[0]], [[-1, -2]], [[5, 5]]],
    ),
    make(
        pid=1355,
        title="将数组分成和相等的三个部分",
        tags=["数组", "前缀和", "贪心"],
        description="""判断能否将数组 arr 分成三个非空连续部分，使三部分元素和相等。""",
        function="canThreePartsEqualSum",
        params=[("arr", "int[]")],
        returns="bool",
        solver=can_three_parts_equal_sum,
        public=[
            [[0, 2, 1, -6, 6, -7, 9, 1, 2, 0, 1]],
            [[0, 2, 1, -6, 6, 7, 9, -1, 2, 0, 1]],
            [[3, 3, 6, 5, -2, 2, 5, 1, -9, 4]],
        ],
        hidden=[[[0, 0, 0]], [[0, 0, 0, 0]], [[1, 1, 1]], [[1, 2, 3, 4, 5]], [[-1, 0, 1]]],
    ),
    make(
        pid=1356,
        title="找出数组中的幸运数",
        tags=["数组", "哈希表", "计数"],
        description="""幸运数指出现次数恰好等于其数值的元素。返回最大的幸运数；不存在返回 -1。""",
        function="findLucky",
        params=[("arr", "int[]")],
        returns="int",
        solver=find_lucky,
        public=[[[2, 2, 3, 4]], [[1, 2, 2, 3, 3, 3]], [[2, 2, 2, 3, 3]]],
        hidden=[[[1]], [[0, 0]], [[1, 1, 1]], [[5, 5, 5, 5, 5]], [[3, 3, 2, 2]]],
    ),
    make(
        pid=1357,
        title="整数的各位积和之差",
        tags=["数学"],
        description="""返回整数 n 的各位数字之积减去各位数字之和的结果。""",
        function="subtractProductAndSum",
        params=[("n", "int")],
        returns="int",
        solver=subtract_product_and_sum,
        public=[[234], [4421], [1]],
        hidden=[[10], [99], [12345], [11111]],
    ),
    make(
        pid=1358,
        title="换酒问题",
        tags=["数学", "模拟"],
        description="""初始有 numBottles 瓶酒。每 numExchange 个空瓶可以换 1 瓶酒。
返回最多能喝到的酒瓶数。""",
        function="numWaterBottles",
        params=[("numBottles", "int"), ("numExchange", "int")],
        returns="int",
        solver=num_water_bottles,
        public=[[9, 3], [15, 4], [5, 5]],
        hidden=[[1, 2], [2, 2], [10, 3], [100, 2]],
    ),
    make(
        pid=1359,
        title="找出所有子集的异或总和再求和",
        tags=["数组", "位运算", "数学"],
        description="""返回数组 nums 所有子集的异或值之和。""",
        function="subsetXORSum",
        params=[("nums", "int[]")],
        returns="int",
        solver=subset_xor_sum,
        public=[[[1, 3]], [[5, 1, 6]], [[3, 4, 5, 6, 7, 8]]],
        hidden=[[[0]], [[1]], [[2, 3]], [[0, 0]]],
    ),
    make(
        pid=1360,
        title="到目标元素的最小距离",
        tags=["数组"],
        description="""返回数组 nums 中距离 start 最近且值等于 target 的下标与 start 的距离。
保证 target 在 nums 中出现。""",
        function="getMinDistance",
        params=[("nums", "int[]"), ("target", "int"), ("start", "int")],
        returns="int",
        solver=get_min_distance,
        public=[[[1, 2, 3, 4, 5], 5, 3], [[1], 1, 0], [[1, 1, 1, 1, 1], 1, 0]],
        hidden=[[[2, 3, 4], 3, 1], [[5, 4, 3, 2, 1], 2, 0], [[1, 2, 1], 1, 1]],
    ),
    make(
        pid=1361,
        title="检查单词是否为句中其他单词的前缀",
        tags=["字符串"],
        description="""给定句子 sentence 和 searchWord，返回 searchWord 作为句子中某个单词前缀时
该单词的 1 基下标；不存在返回 -1。""",
        function="isPrefixOfWord",
        params=[("sentence", "string"), ("searchWord", "string")],
        returns="int",
        solver=is_prefix_of_word,
        public=[
            ["i love eating burger", "burg"],
            ["this problem is an easy problem", "pro"],
            ["i am tired", "you"],
        ],
        hidden=[["hello world", "hello"], ["a b c", "b"], ["abc abd", "ab"], ["a", "a"]],
    ),
    make(
        pid=1362,
        title="无法吃午餐的学生数量",
        tags=["数组", "队列", "计数"],
        description="""学生排队，sandwiches 栈顶在前。若队首学生喜欢栈顶三明治，他取走并离开；
否则回到队尾。返回无法吃午餐的学生数量。""",
        function="countStudents",
        params=[("students", "int[]"), ("sandwiches", "int[]")],
        returns="int",
        solver=count_students,
        public=[
            [[1, 1, 0, 0], [0, 1, 0, 1]],
            [[1, 1, 1, 0, 0, 1], [1, 0, 0, 0, 1, 1]],
            [[1, 0, 1, 0], [0, 1, 0, 1]],
        ],
        hidden=[[[1], [1]], [[0], [0]], [[1], [0]], [[1, 1], [0, 0]]],
    ),
    make(
        pid=1363,
        title="解压缩编码列表",
        tags=["数组"],
        description="""nums 按 [freq, val, freq, val, ...] 排列。
返回解压后的数组：每个 val 重复 freq 次。""",
        function="decompressRLElist",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=decompress_rle_list,
        public=[[[1, 2, 3, 4]], [[1, 1, 2, 3]], [[1, 2]]],
        hidden=[[[0, 1]], [[2, 0]], [[1, 5, 2, 3]]],
    ),
    make(
        pid=1364,
        title="二进制链表转整数",
        tags=["链表", "数学"],
        description="""链表每个节点的值为 0 或 1，最高位在头节点。
返回该链表表示的十进制整数。""",
        function="getDecimalValue",
        params=[("head", "ListNode")],
        returns="int",
        solver=get_decimal_value,
        public=[[[1, 0, 1]], [[0]], [[1]]],
        hidden=[[[1, 1, 1, 1]], [[0, 0, 1]], [[1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0]]],
    ),
    make(
        pid=1365,
        title="移除链表元素",
        tags=["链表"],
        description="""删除链表中所有值等于 val 的节点，返回新的头节点。""",
        function="removeElements",
        params=[("head", "ListNode"), ("val", "int")],
        returns="ListNode",
        solver=remove_elements,
        public=[[[1, 2, 6, 3, 4, 5, 6], 6], [[], 7], [[7, 7, 7, 7], 7]],
        hidden=[[[1, 2, 3], 4], [[1], 1], [[1, 2, 1], 1], [[2, 1, 2], 2]],
    ),
    make(
        pid=1366,
        title="链表中倒数第 k 个节点",
        tags=["链表", "双指针"],
        description="""返回链表中倒数第 k 个节点，并以该节点为头组成结果链表。
1 <= k <= 链表长度。""",
        function="getKthFromEnd",
        params=[("head", "ListNode"), ("k", "int")],
        returns="ListNode",
        solver=get_kth_from_end,
        public=[[[1, 2, 3, 4, 5], 2], [[1], 1], [[1, 2], 1]],
        hidden=[[[1, 2, 3], 3], [[1, 2, 3, 4], 4], [[5, 4, 3, 2, 1], 3]],
    ),
    make(
        pid=1367,
        title="二叉树的最小深度",
        tags=["树", "深度优先搜索", "广度优先搜索"],
        description="""最小深度是从根节点到最近叶子节点的节点数。返回二叉树的最小深度。
空树深度为 0。""",
        function="minDepth",
        params=[("root", "TreeNode")],
        returns="int",
        solver=min_depth,
        public=[[[3, 9, 20, None, None, 15, 7]], [[2, None, 3, None, 4, None, 5, None, 6]], [[]]],
        hidden=[[[1]], [[1, 2]], [[1, None, 2]], [[1, 2, 3, 4, None, None, 5]]],
    ),
    make(
        pid=1368,
        title="相同的树",
        tags=["树", "深度优先搜索"],
        description="""判断两棵二叉树的结构和节点值是否完全相同。""",
        function="isSameTree",
        params=[("p", "TreeNode"), ("q", "TreeNode")],
        returns="bool",
        solver=is_same_tree,
        public=[[[1, 2, 3], [1, 2, 3]], [[1, 2], [1, None, 2]], [[1, 2, 1], [1, 1, 2]]],
        hidden=[[[], []], [[], [1]], [[1, 2, 3], [1, 2, 4]], [[1, None, 2], [1, None, 2]]],
    ),
    make(
        pid=1369,
        title="平衡二叉树",
        tags=["树", "深度优先搜索"],
        description="""判断二叉树是否高度平衡：每个节点的左右子树高度差不超过 1。""",
        function="isBalanced",
        params=[("root", "TreeNode")],
        returns="bool",
        solver=is_balanced,
        public=[[[3, 9, 20, None, None, 15, 7]], [[1, 2, 2, 3, 3, None, None, 4, 4]], [[]]],
        hidden=[[[1]], [[1, 2]], [[1, None, 2]], [[1, 2, 3]]],
    ),
    make(
        pid=1370,
        title="二叉树的层平均值",
        tags=["树", "广度优先搜索"],
        description="""返回二叉树每一层节点值的平均值，按从根到叶的顺序。""",
        function="averageOfLevels",
        params=[("root", "TreeNode")],
        returns="double[]",
        solver=average_of_levels,
        compare={"mode": "double"},
        public=[[[3, 9, 20, None, None, 15, 7]], [[3, 9, 20, 15, 7]], [[]]],
        hidden=[[[1]], [[1, 2, 3]], [[1, None, 2]], [[1, 2, None, 3]]],
    ),
    make(
        pid=1371,
        title="二叉树的所有路径",
        tags=["树", "深度优先搜索", "回溯"],
        description="""返回所有从根节点到叶子节点的路径字符串，按从左到右的叶子顺序。
路径格式为 "a->b->c"。空树返回空数组。""",
        function="binaryTreePaths",
        params=[("root", "TreeNode")],
        returns="string[]",
        solver=binary_tree_paths,
        public=[[[1, 2, 3, None, 5]], [[1]], [[]]],
        hidden=[[[1, 2]], [[1, None, 2]], [[1, 2, 3, 4, 5, 6, 7]]],
    ),
    make(
        pid=1372,
        title="左叶子之和",
        tags=["树", "深度优先搜索"],
        description="""返回所有左叶子节点值之和。左叶子是某个节点的左孩子，且自身没有孩子。""",
        function="sumOfLeftLeaves",
        params=[("root", "TreeNode")],
        returns="int",
        solver=sum_of_left_leaves,
        public=[[[3, 9, 20, None, None, 15, 7]], [[1]], [[]]],
        hidden=[[[1, 2]], [[1, None, 2]], [[1, 2, 3, 4, None, None, 5]]],
    ),
    make(
        pid=1373,
        title="叶子相似的树",
        tags=["树", "深度优先搜索"],
        description="""判断两棵二叉树的叶子节点值序列（从左到右）是否相同。""",
        function="leafSimilar",
        params=[("root1", "TreeNode"), ("root2", "TreeNode")],
        returns="bool",
        solver=leaf_similar,
        public=[
            [[3, 5, 1, 6, 2, 9, 8, None, None, 7, 4], [3, 5, 1, 6, 7, 4, 2, None, None, None, None, None, None, 9, 8]],
            [[1], [1]],
            [[1], [2]],
        ],
        hidden=[[[], []], [[1, 2], [2, 1]], [[1, None, 2], [1, 2]]],
    ),
    make(
        pid=1374,
        title="单值二叉树",
        tags=["树", "深度优先搜索"],
        description="""判断二叉树的所有节点值是否相同。空树视为单值二叉树。""",
        function="isUnivalTree",
        params=[("root", "TreeNode")],
        returns="bool",
        solver=is_unival_tree,
        public=[[[1, 1, 1, 1, 1, None, 1]], [[2, 2, 2, 5, 2]], [[]]],
        hidden=[[[1]], [[1, 1]], [[1, 2]], [[1, 1, None, 1]]],
    ),
]

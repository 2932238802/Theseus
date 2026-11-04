"""1235-1279：新增中等题（45 道）。"""

from __future__ import annotations

from bisect import bisect_left
from collections import Counter, deque
from itertools import permutations

from problem_seed_common import Node, Problem, tree_from_list, tree_to_list


def make(
    *,
    pid: int,
    title: str,
    tags: list[str],
    description: str,
    function: str,
    params: list[tuple[str, str]],
    returns: str,
    solver,
    public: list[list],
    hidden: list[list],
    compare: dict | None = None,
) -> Problem:
    return Problem(
        pid=pid,
        title=title,
        difficulty="medium",
        tags=tags,
        description=description,
        function=function,
        params=params,
        returns=returns,
        solver=solver,
        public=public,
        expected_public=[solver(*args) for args in public],
        hidden=hidden,
        compare=compare or {"mode": "exact"},
    )


def longest_palindrome(s: str) -> str:
    best = ""
    for center in range(2 * len(s) - 1):
        left = center // 2
        right = left + center % 2
        while left >= 0 and right < len(s) and s[left] == s[right]:
            if right - left + 1 > len(best):
                best = s[left : right + 1]
            left -= 1
            right += 1
    return best


def my_atoi(s: str) -> int:
    index = 0
    while index < len(s) and s[index] == " ":
        index += 1
    sign = 1
    if index < len(s) and s[index] in "+-":
        sign = -1 if s[index] == "-" else 1
        index += 1
    value = 0
    while index < len(s) and s[index].isdigit():
        value = value * 10 + int(s[index])
        index += 1
        if sign * value >= 2**31 - 1:
            return 2**31 - 1
        if sign * value <= -(2**31):
            return -(2**31)
    return sign * value


ROMAN_VALUES = [
    (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"),
    (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I"),
]


def int_to_roman(num: int) -> str:
    result: list[str] = []
    for value, symbol in ROMAN_VALUES:
        while num >= value:
            result.append(symbol)
            num -= value
    return "".join(result)


def three_sum(nums: list[int]) -> list[list[int]]:
    nums = sorted(nums)
    result: list[list[int]] = []
    for index in range(len(nums) - 2):
        if index and nums[index] == nums[index - 1]:
            continue
        left, right = index + 1, len(nums) - 1
        while left < right:
            total = nums[index] + nums[left] + nums[right]
            if total == 0:
                result.append([nums[index], nums[left], nums[right]])
                left += 1
                right -= 1
                while left < right and nums[left] == nums[left - 1]:
                    left += 1
            elif total < 0:
                left += 1
            else:
                right -= 1
    return result


def three_sum_closest(nums: list[int], target: int) -> int:
    nums = sorted(nums)
    best = nums[0] + nums[1] + nums[2]
    for index in range(len(nums) - 2):
        left, right = index + 1, len(nums) - 1
        while left < right:
            total = nums[index] + nums[left] + nums[right]
            if abs(total - target) < abs(best - target):
                best = total
            if total < target:
                left += 1
            else:
                right -= 1
    return best


LETTERS = {
    "2": "abc", "3": "def", "4": "ghi", "5": "jkl",
    "6": "mno", "7": "pqrs", "8": "tuv", "9": "wxyz",
}


def letter_combinations(digits: str) -> list[str]:
    if not digits:
        return []
    result = [""]
    for digit in digits:
        result = [prefix + letter for prefix in result for letter in LETTERS[digit]]
    return result


def generate_parentheses(n: int) -> list[str]:
    result: list[str] = []

    def build(current: str, opened: int, closed: int) -> None:
        if len(current) == 2 * n:
            result.append(current)
            return
        if opened < n:
            build(current + "(", opened + 1, closed)
        if closed < opened:
            build(current + ")", opened, closed + 1)

    build("", 0, 0)
    return result


def next_permutation(nums: list[int]) -> list[int]:
    nums = nums[:]
    index = len(nums) - 2
    while index >= 0 and nums[index] >= nums[index + 1]:
        index -= 1
    if index >= 0:
        swap = len(nums) - 1
        while nums[swap] <= nums[index]:
            swap -= 1
        nums[index], nums[swap] = nums[swap], nums[index]
    nums[index + 1 :] = reversed(nums[index + 1 :])
    return nums


def find_min_rotated(nums: list[int]) -> int:
    left, right = 0, len(nums) - 1
    while left < right:
        middle = (left + right) // 2
        if nums[middle] > nums[right]:
            left = middle + 1
        else:
            right = middle
    return nums[left]


def all_permutations(nums: list[int]) -> list[list[int]]:
    return [list(value) for value in permutations(nums)]


def combination_sum(candidates: list[int], target: int) -> list[list[int]]:
    ordered = sorted(candidates)
    result: list[list[int]] = []

    def dfs(start: int, total: int, path: list[int]) -> None:
        if total == target:
            result.append(path[:])
            return
        for index in range(start, len(ordered)):
            if total + ordered[index] > target:
                break
            path.append(ordered[index])
            dfs(index, total + ordered[index], path)
            path.pop()

    dfs(0, 0, [])
    return result


def rotate_image(matrix: list[list[int]]) -> list[list[int]]:
    return [list(row) for row in zip(*matrix[::-1])]


def generate_matrix(n: int) -> list[list[int]]:
    matrix = [[0] * n for _ in range(n)]
    top, bottom, left, right = 0, n - 1, 0, n - 1
    value = 1
    while top <= bottom and left <= right:
        for column in range(left, right + 1):
            matrix[top][column] = value
            value += 1
        top += 1
        for row in range(top, bottom + 1):
            matrix[row][right] = value
            value += 1
        right -= 1
        if top <= bottom:
            for column in range(right, left - 1, -1):
                matrix[bottom][column] = value
                value += 1
            bottom -= 1
        if left <= right:
            for row in range(bottom, top - 1, -1):
                matrix[row][left] = value
                value += 1
            left += 1
    return matrix


def can_jump(nums: list[int]) -> bool:
    reach = 0
    for index, value in enumerate(nums):
        if index > reach:
            return False
        reach = max(reach, index + value)
    return True


def min_jumps(nums: list[int]) -> int:
    jumps = end = farthest = 0
    for index in range(len(nums) - 1):
        farthest = max(farthest, index + nums[index])
        if index == end:
            jumps += 1
            end = farthest
    return jumps


def unique_paths_with_obstacles(grid: list[list[int]]) -> int:
    if not grid or not grid[0] or grid[0][0] == 1:
        return 0
    dp = [0] * len(grid[0])
    dp[0] = 1
    for row in grid:
        for index, value in enumerate(row):
            if value == 1:
                dp[index] = 0
            elif index:
                dp[index] += dp[index - 1]
    return dp[-1]


def min_triangle_path(triangle: list[list[int]]) -> int:
    dp = triangle[-1][:]
    for row in reversed(triangle[:-1]):
        for index in range(len(row)):
            dp[index] = row[index] + min(dp[index], dp[index + 1])
    return dp[0]


def palindrome_partition(s: str) -> list[list[str]]:
    result: list[list[str]] = []

    def is_palindrome(value: str) -> bool:
        return value == value[::-1]

    def dfs(start: int, path: list[str]) -> None:
        if start == len(s):
            result.append(path[:])
            return
        for end in range(start + 1, len(s) + 1):
            piece = s[start:end]
            if is_palindrome(piece):
                path.append(piece)
                dfs(end, path)
                path.pop()

    dfs(0, [])
    return result


def odd_even_list(head: list[int]) -> list[int]:
    return head[::2] + head[1::2]


def swap_pairs(head: list[int]) -> list[int]:
    result = head[:]
    for index in range(0, len(result) - 1, 2):
        result[index], result[index + 1] = result[index + 1], result[index]
    return result


def partition_list(head: list[int], x: int) -> list[int]:
    return [value for value in head if value < x] + [value for value in head if value >= x]


def rotate_right(head: list[int], k: int) -> list[int]:
    if not head:
        return []
    k %= len(head)
    return head[-k:] + head[:-k] if k else head[:]


def right_side_view(root: list[int | None]) -> list[int]:
    node = tree_from_list(root)
    if node is None:
        return []
    result: list[int] = []
    queue = deque([node])
    while queue:
        size = len(queue)
        for index in range(size):
            current = queue.popleft()
            if index == size - 1:
                result.append(current.value)
            if current.left:
                queue.append(current.left)
            if current.right:
                queue.append(current.right)
    return result


def flatten_tree(root: list[int | None]) -> list[int | None]:
    node = tree_from_list(root)
    values: list[int] = []

    def visit(current: Node | None) -> None:
        if current is None:
            return
        values.append(current.value)
        visit(current.left)
        visit(current.right)

    visit(node)
    if not values:
        return []
    head = Node(values[0])
    current = head
    for value in values[1:]:
        current.right = Node(value)
        current = current.right
    return tree_to_list(head)


def build_tree(preorder: list[int], inorder: list[int]) -> list[int | None]:
    index_map = {value: index for index, value in enumerate(inorder)}

    def build(left: int, right: int, start: int) -> Node | None:
        if left > right:
            return None
        root = Node(preorder[start])
        middle = index_map[root.value]
        root.left = build(left, middle - 1, start + 1)
        root.right = build(middle + 1, right, start + middle - left + 1)
        return root

    return tree_to_list(build(0, len(inorder) - 1, 0))


def path_sum_ii(root: list[int | None], target_sum: int) -> list[list[int]]:
    node = tree_from_list(root)
    result: list[list[int]] = []

    def dfs(current: Node | None, remaining: int, path: list[int]) -> None:
        if current is None:
            return
        path.append(current.value)
        if current.left is None and current.right is None and remaining == current.value:
            result.append(path[:])
        dfs(current.left, remaining - current.value, path)
        dfs(current.right, remaining - current.value, path)
        path.pop()

    dfs(node, target_sum, [])
    return result


def sum_root_to_leaf(root: list[int | None]) -> int:
    node = tree_from_list(root)

    def dfs(current: Node | None, value: int) -> int:
        if current is None:
            return 0
        value = value * 10 + current.value
        if current.left is None and current.right is None:
            return value
        return dfs(current.left, value) + dfs(current.right, value)

    return dfs(node, 0)


def lowest_common_ancestor(root: list[int | None], p: int, q: int) -> int:
    node = tree_from_list(root)

    def search(current: Node | None) -> Node | None:
        if current is None or current.value in (p, q):
            return current
        left = search(current.left)
        right = search(current.right)
        if left and right:
            return current
        return left or right

    found = search(node)
    return found.value if found else -1


def insert_into_bst(root: list[int | None], val: int) -> list[int | None]:
    node = tree_from_list(root)
    if node is None:
        return [val]
    current = node
    while True:
        if val < current.value:
            if current.left is None:
                current.left = Node(val)
                break
            current = current.left
        else:
            if current.right is None:
                current.right = Node(val)
                break
            current = current.right
    return tree_to_list(node)


def delete_node(root: list[int | None], key: int) -> list[int | None]:
    def remove_min(current: Node) -> Node | None:
        if current.left is None:
            return current.right
        current.left = remove_min(current.left)
        return current

    def remove(current: Node | None) -> Node | None:
        if current is None:
            return None
        if key < current.value:
            current.left = remove(current.left)
        elif key > current.value:
            current.right = remove(current.right)
        else:
            if current.left is None:
                return current.right
            if current.right is None:
                return current.left
            successor = current.right
            while successor.left:
                successor = successor.left
            current.value = successor.value
            current.right = remove_min(current.right)
        return current

    return tree_to_list(remove(tree_from_list(root)))


def max_area_of_island(grid: list[list[int]]) -> int:
    rows, columns = len(grid), len(grid[0]) if grid else 0
    seen = [[False] * columns for _ in range(rows)]
    best = 0
    for row in range(rows):
        for column in range(columns):
            if grid[row][column] != 1 or seen[row][column]:
                continue
            area = 0
            stack = [(row, column)]
            seen[row][column] = True
            while stack:
                current_row, current_column = stack.pop()
                area += 1
                for next_row, next_column in (
                    (current_row + 1, current_column),
                    (current_row - 1, current_column),
                    (current_row, current_column + 1),
                    (current_row, current_column - 1),
                ):
                    if 0 <= next_row < rows and 0 <= next_column < columns and not seen[next_row][next_column] and grid[next_row][next_column] == 1:
                        seen[next_row][next_column] = True
                        stack.append((next_row, next_column))
            best = max(best, area)
    return best


def surrounded_regions(board: list[list[str]]) -> list[list[str]]:
    rows, columns = len(board), len(board[0]) if board else 0
    safe: set[tuple[int, int]] = set()
    stack: list[tuple[int, int]] = []
    for row in range(rows):
        for column in range(columns):
            if (row in (0, rows - 1) or column in (0, columns - 1)) and board[row][column] == "O":
                safe.add((row, column))
                stack.append((row, column))
    while stack:
        row, column = stack.pop()
        for next_row, next_column in ((row + 1, column), (row - 1, column), (row, column + 1), (row, column - 1)):
            if 0 <= next_row < rows and 0 <= next_column < columns and board[next_row][next_column] == "O" and (next_row, next_column) not in safe:
                safe.add((next_row, next_column))
                stack.append((next_row, next_column))
    return [["O" if (row, column) in safe else "X" for column in range(columns)] for row in range(rows)]


def course_schedule_ii(num_courses: int, prerequisites: list[list[int]]) -> list[int]:
    graph = [[] for _ in range(num_courses)]
    indegree = [0] * num_courses
    for course, prerequisite in prerequisites:
        graph[prerequisite].append(course)
        indegree[course] += 1
    queue = deque(index for index, value in enumerate(indegree) if value == 0)
    order: list[int] = []
    while queue:
        course = queue.popleft()
        order.append(course)
        for next_course in graph[course]:
            indegree[next_course] -= 1
            if indegree[next_course] == 0:
                queue.append(next_course)
    return order if len(order) == num_courses else []


def rob_tree(root: list[int | None]) -> int:
    node = tree_from_list(root)

    def dfs(current: Node | None) -> tuple[int, int]:
        if current is None:
            return (0, 0)
        left = dfs(current.left)
        right = dfs(current.right)
        take = current.value + left[1] + right[1]
        skip = max(left) + max(right)
        return (take, skip)

    return max(dfs(node))


def coin_change_ii(amount: int, coins: list[int]) -> int:
    dp = [0] * (amount + 1)
    dp[0] = 1
    for coin in coins:
        for value in range(coin, amount + 1):
            dp[value] += dp[value - coin]
    return dp[amount]


def max_subarray_sum_circular(nums: list[int]) -> int:
    current_max = best_max = nums[0]
    current_min = best_min = nums[0]
    for value in nums[1:]:
        current_max = max(value, current_max + value)
        best_max = max(best_max, current_max)
        current_min = min(value, current_min + value)
        best_min = min(best_min, current_min)
    total = sum(nums)
    if best_max < 0:
        return best_max
    return max(best_max, total - best_min)


def sort_colors(nums: list[int]) -> list[int]:
    return sorted(nums)


def search_matrix_ii(matrix: list[list[int]], target: int) -> bool:
    for row in matrix:
        index = bisect_left(row, target)
        if index < len(row) and row[index] == target:
            return True
    return False


def find_peak_element(nums: list[int]) -> int:
    left, right = 0, len(nums) - 1
    while left < right:
        middle = (left + right) // 2
        if nums[middle] < nums[middle + 1]:
            left = middle + 1
        else:
            right = middle
    return left


def find_duplicate(nums: list[int]) -> int:
    slow = fast = nums[0]
    while True:
        slow = nums[slow]
        fast = nums[nums[fast]]
        if slow == fast:
            break
    slow = nums[0]
    while slow != fast:
        slow = nums[slow]
        fast = nums[fast]
    return slow


def find_kth_largest(nums: list[int], k: int) -> int:
    return sorted(nums, reverse=True)[k - 1]


def top_k_frequent(nums: list[int], k: int) -> list[int]:
    counts = Counter(nums)
    return sorted(counts, key=lambda value: (-counts[value], value))[:k]


def frequency_sort(s: str) -> str:
    counts = Counter(s)
    return "".join(sorted(s, key=lambda character: (-counts[character], character)))


def can_complete_circuit(gas: list[int], cost: list[int]) -> int:
    if sum(gas) < sum(cost):
        return -1
    start = tank = 0
    for index in range(len(gas)):
        tank += gas[index] - cost[index]
        if tank < 0:
            start = index + 1
            tank = 0
    return start


def candy(ratings: list[int]) -> int:
    values = [1] * len(ratings)
    for index in range(1, len(ratings)):
        if ratings[index] > ratings[index - 1]:
            values[index] = values[index - 1] + 1
    for index in range(len(ratings) - 2, -1, -1):
        if ratings[index] > ratings[index + 1]:
            values[index] = max(values[index], values[index + 1] + 1)
    return sum(values)


PROBLEMS = [
    make(
        pid=1235,
        title="最长回文子串",
        tags=["字符串", "动态规划"],
        description="""给定一个字符串 s，找到 s 中最长的回文子串。如果存在多个长度相同的答案，返回从最左侧开始枚举得到的那个。

提示：
- 1 <= s.length <= 1000
- s 仅由数字和英文字母组成""",
        function="longestPalindrome",
        params=[("s", "string")],
        returns="string",
        solver=longest_palindrome,
        public=[["babad"], ["cbbd"], ["a"], ["racecar"]],
        hidden=[["bb"], ["abba"], ["forgeeksskeegfor"], ["abc"], ["aaaa"], ["abacdfgdcaba"], ["noon"]],
    ),
    make(
        pid=1236,
        title="字符串转换整数",
        tags=["字符串", "模拟"],
        description="""实现 myAtoi，将字符串转换为 32 位有符号整数。
忽略前导空格，读取可选正负号与连续数字，遇到非数字字符停止；结果超出范围时截断到 [-2^31, 2^31 - 1]。

提示：
- 0 <= s.length <= 200
- s 由英文字母、数字、空格和符号组成""",
        function="myAtoi",
        params=[("s", "string")],
        returns="int",
        solver=my_atoi,
        public=[["42"], ["   -42"], ["4193 with words"], ["words and 987"]],
        hidden=[[""], ["+"], ["-"], ["  +12"], ["-91283472332"], ["2147483648"], ["00012"], ["3.14"]],
    ),
    make(
        pid=1237,
        title="整数转罗马数字",
        tags=["数学", "字符串"],
        description="""给定一个整数 num，将其转换为罗马数字。

提示：
- 1 <= num <= 3999""",
        function="intToRoman",
        params=[("num", "int")],
        returns="string",
        solver=int_to_roman,
        public=[[3], [4], [9], [58]],
        hidden=[[1], [40], [90], [400], [1994], [3999], [2024]],
    ),
    make(
        pid=1238,
        title="三数之和",
        tags=["数组", "双指针", "排序"],
        description="""给定一个整数数组 nums，找出所有和为 0 且不重复的三元组。
答案中的三元组按升序排列，整个答案按三元组字典序排列。

提示：
- 3 <= nums.length <= 3000
- -10^5 <= nums[i] <= 10^5""",
        function="threeSum",
        params=[("nums", "int[]")],
        returns="int[][]",
        solver=three_sum,
        public=[[[-1, 0, 1, 2, -1, -4]], [[0, 1, 1]], [[0, 0, 0]], [[1, 2, -2, -1]]],
        hidden=[[[-2, 0, 1, 1, 2]], [[-1, 0, 1, 0]], [[3, 0, -2, -1, 1, 2]], [[0, 0, 0, 0]], [[1, -1, -1, 2, -2]]],
    ),
    make(
        pid=1239,
        title="最接近的三数之和",
        tags=["数组", "双指针", "排序"],
        description="""给定一个整数数组 nums 和一个目标值 target，选出三个整数使它们的和与 target 最接近，返回这个和。

提示：
- 3 <= nums.length <= 1000
- -1000 <= nums[i], target <= 1000""",
        function="threeSumClosest",
        params=[("nums", "int[]"), ("target", "int")],
        returns="int",
        solver=three_sum_closest,
        public=[[[-1, 2, 1, -4], 1], [[0, 0, 0], 1], [[1, 1, 1, 1], 0], [[4, 0, 5, -5, 3, 3, 0, -4, -5], -2]],
        hidden=[[[1, 2, 3], 6], [[-1, -2, -3], -6], [[1, 2, 4, 8, 16, 32, 64, 128], 82], [[0, 1, 2], 0], [[-5, -4, -3, -2, -1], -10]],
    ),
    make(
        pid=1240,
        title="电话号码的字母组合",
        tags=["字符串", "回溯", "哈希表"],
        description="""给定一个仅包含数字 2-9 的字符串 digits，返回它能表示的所有字母组合。答案按字典序排列。

提示：
- 1 <= digits.length <= 4
- digits[i] 是 2-9 的数字""",
        function="letterCombinations",
        params=[("digits", "string")],
        returns="string[]",
        solver=letter_combinations,
        public=[["23"], ["2"], ["79"], ["234"]],
        hidden=[["9"], ["22"], ["567"], ["89"], ["2345"]],
    ),
    make(
        pid=1241,
        title="括号生成",
        tags=["字符串", "回溯"],
        description="""给定数字 n，生成所有由 n 对括号组成的有效括号组合。答案按回溯生成顺序返回。

提示：
- 1 <= n <= 8""",
        function="generateParentheses",
        params=[("n", "int")],
        returns="string[]",
        solver=generate_parentheses,
        public=[[1], [2], [3], [4]],
        hidden=[[5], [6], [7], [8]],
    ),
    make(
        pid=1242,
        title="下一个排列",
        tags=["数组", "双指针"],
        description="""给定一个整数数组 nums，将其重新排列为字典序中的下一个更大排列；如果不存在更大排列，则重排为最小排列。

提示：
- 1 <= nums.length <= 100
- 0 <= nums[i] <= 100""",
        function="nextPermutation",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=next_permutation,
        public=[[[1, 2, 3]], [[3, 2, 1]], [[1, 1, 5]], [[1]]],
        hidden=[[[1, 3, 2]], [[2, 3, 1]], [[5, 1, 1]], [[1, 2]], [[2, 1, 3]], [[4, 2, 0, 2, 3, 2, 0]]],
    ),
    make(
        pid=1243,
        title="旋转排序数组中的最小值",
        tags=["数组", "二分查找"],
        description="""给定一个长度为 n 的升序数组经过若干次旋转后的结果 nums，返回数组中的最小元素。
数组中的值互不相同，旋转后可能仍保持升序。

提示：
- 1 <= nums.length <= 5000
- -5000 <= nums[i] <= 5000""",
        function="findMinRotated",
        params=[("nums", "int[]")],
        returns="int",
        solver=find_min_rotated,
        public=[[[3, 4, 5, 1, 2]], [[4, 5, 6, 7, 0, 1, 2]], [[11, 13, 15, 17]], [[2, 1]]],
        hidden=[[[1]], [[3, 1, 2]], [[5, 1, 3]], [[6, 7, 0, 1, 2, 4, 5]], [[2, 3, 4, 5, 1]]],
    ),
    make(
        pid=1244,
        title="全排列",
        tags=["数组", "回溯"],
        description="""给定一个不含重复数字的数组 nums，返回其所有可能的全排列。答案按字典序排列。

提示：
- 1 <= nums.length <= 6
- -10 <= nums[i] <= 10""",
        function="permutations",
        params=[("nums", "int[]")],
        returns="int[][]",
        solver=all_permutations,
        public=[[[1, 2, 3]], [[0, 1]], [[1]], [[1, 2, 3, 4]]],
        hidden=[[[-1, 0, 1]], [[2, 3]], [[3, 2, 1]], [[0, 1, 2, 3]], [[1, 2, 3, 4, 5]]],
    ),
    make(
        pid=1245,
        title="组合总和",
        tags=["数组", "回溯"],
        description="""给定一个无重复元素的整数数组 candidates 和一个目标整数 target，找出所有和为 target 的组合。
同一个数字可以无重复限制地被选取。答案按组合字典序排列。

提示：
- 1 <= candidates.length <= 30
- 1 <= candidates[i] <= 50
- 1 <= target <= 50""",
        function="combinationSum",
        params=[("candidates", "int[]"), ("target", "int")],
        returns="int[][]",
        solver=combination_sum,
        public=[[[2, 3, 6, 7], 7], [[2, 3, 5], 8], [[2], 1], [[1], 2]],
        hidden=[[[3, 5], 8], [[2, 4], 6], [[7], 7], [[1, 2], 4], [[8, 3, 5], 11]],
    ),
    make(
        pid=1246,
        title="旋转图像",
        tags=["数组", "矩阵"],
        description="""给定一个 n × n 的二维矩阵 matrix，将其顺时针旋转 90 度并返回旋转后的矩阵。

提示：
- 1 <= n <= 20
- -1000 <= matrix[i][j] <= 1000""",
        function="rotateImage",
        params=[("matrix", "int[][]")],
        returns="int[][]",
        solver=rotate_image,
        public=[[[[1, 2, 3], [4, 5, 6], [7, 8, 9]]], [[[5, 1, 9, 11], [2, 4, 8, 10], [13, 3, 6, 7], [15, 14, 12, 16]]], [[[1]]], [[[1, 2], [3, 4]]]],
        hidden=[[[[1, 2, 3], [4, 5, 6], [7, 8, 9]]], [[[0, 0], [0, 0]]], [[[1, 2], [3, 4]]], [[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]]],
    ),
    make(
        pid=1247,
        title="螺旋矩阵 II",
        tags=["数组", "矩阵", "模拟"],
        description="""给定一个正整数 n，生成一个 n × n 矩阵，按顺时针螺旋顺序填入 1 到 n^2，并返回该矩阵。

提示：
- 1 <= n <= 20""",
        function="generateMatrix",
        params=[("n", "int")],
        returns="int[][]",
        solver=generate_matrix,
        public=[[3], [1], [2], [4]],
        hidden=[[5], [6], [7], [8]],
    ),
    make(
        pid=1248,
        title="跳跃游戏",
        tags=["数组", "贪心"],
        description="""给定一个非负整数数组 nums，最初位于第一个下标。每个元素表示在该位置可以跳跃的最大长度。
判断是否能够到达最后一个下标。

提示：
- 1 <= nums.length <= 10^4
- 0 <= nums[i] <= 10^5""",
        function="canJump",
        params=[("nums", "int[]")],
        returns="bool",
        solver=can_jump,
        public=[[[2, 3, 1, 1, 4]], [[3, 2, 1, 0, 4]], [[0]], [[2, 0, 0]]],
        hidden=[[[1, 0]], [[1, 1, 1]], [[0, 1]], [[5, 0, 0, 0, 0]], [[2, 0, 1, 0, 4]], [[1, 2, 3]]],
    ),
    make(
        pid=1249,
        title="跳跃游戏 II",
        tags=["数组", "贪心"],
        description="""给定一个长度为 n 的非负整数数组 nums，每个元素表示从该位置可以跳跃的最大长度。
假设总能到达最后一个下标，返回到达最后一个下标所需的最少跳跃次数。

提示：
- 1 <= nums.length <= 10^4
- 0 <= nums[i] <= 10^5""",
        function="minJumps",
        params=[("nums", "int[]")],
        returns="int",
        solver=min_jumps,
        public=[[[2, 3, 1, 1, 4]], [[2, 3, 0, 1, 4]], [[1, 1, 1, 1]], [[0]]],
        hidden=[[[1, 2, 1, 1, 1]], [[5, 4, 3, 2, 1]], [[1, 2, 3]], [[2, 0, 2, 0, 1]], [[10, 0, 0, 0, 1]]],
    ),
    make(
        pid=1250,
        title="不同路径 II",
        tags=["数组", "动态规划", "矩阵"],
        description="""一个机器人位于 m × n 网格的左上角，每次只能向下或向右移动一步。
网格中的障碍物用 1 表示，空位置用 0 表示。求到达右下角的不同路径数。

提示：
- 1 <= m, n <= 100
- grid[i][j] 为 0 或 1""",
        function="uniquePathsWithObstacles",
        params=[("grid", "int[][]")],
        returns="int",
        solver=unique_paths_with_obstacles,
        public=[[[[0, 0, 0], [0, 1, 0], [0, 0, 0]]], [[[0, 1], [0, 0]]], [[[1]]], [[[0]]]],
        hidden=[[[[0, 0], [0, 0]]], [[[0, 0, 0]]], [[[0], [0], [0]]], [[[1, 0], [0, 0]]], [[[0, 0], [1, 1], [0, 0]]], [[[0, 1, 0], [0, 0, 0]]]],
    ),
    make(
        pid=1251,
        title="三角形最小路径和",
        tags=["数组", "动态规划"],
        description="""给定一个三角形数组 triangle，返回自顶向下的最小路径和。
每一步只能移动到下一行中相邻的节点。

提示：
- 1 <= triangle.length <= 200
- -10^4 <= triangle[i][j] <= 10^4""",
        function="minTrianglePath",
        params=[("triangle", "int[][]")],
        returns="int",
        solver=min_triangle_path,
        public=[[[[2], [3, 4], [6, 5, 7], [4, 1, 8, 3]]], [[[-10]]], [[[1], [2, 3]]], [[[1], [2, 3], [4, 5, 6]]]],
        hidden=[[[[1], [1, 1]]], [[[1], [2, 3], [1, 1, 1]]], [[[-1], [-2, -3]]], [[[3], [4, 5], [1, 2, 3]]], [[[0], [1, 2], [3, 4, 5]]]],
    ),
    make(
        pid=1252,
        title="分割回文串",
        tags=["字符串", "回溯"],
        description="""给定一个字符串 s，将 s 分割成若干回文子串，返回所有可能的分割方案。

提示：
- 1 <= s.length <= 16
- s 仅由小写英文字母组成""",
        function="partitionPalindrome",
        params=[("s", "string")],
        returns="string[][]",
        solver=palindrome_partition,
        public=[["aab"], ["a"], ["ab"], ["aabb"]],
        hidden=[["aa"], ["aba"], ["abcba"], ["abab"], ["aabc"]],
    ),
    make(
        pid=1253,
        title="奇偶链表",
        tags=["链表"],
        description="""给定单链表的头节点 head，将所有奇数位置节点和偶数位置节点分别相连后拼接，返回重排后的链表。
节点位置从 1 开始计数。

提示：
- 0 <= head.length <= 10^4
- -1000 <= head[i] <= 1000""",
        function="oddEvenList",
        params=[("head", "ListNode")],
        returns="ListNode",
        solver=odd_even_list,
        public=[[[1, 2, 3, 4, 5]], [[2, 1, 3, 5, 6, 4, 7]], [[1]], [[]]],
        hidden=[[[1, 2]], [[1, 2, 3]], [[1, 2, 3, 4]], [[5, 4, 3, 2, 1]], [[1, 2, 3, 4, 5, 6]]],
    ),
    make(
        pid=1254,
        title="两两交换链表中的节点",
        tags=["链表", "递归"],
        description="""给定一个链表，两两交换其中相邻的节点，并返回交换后链表的头节点。
不能只交换节点内部的值。

提示：
- 0 <= head.length <= 100
- 0 <= head[i] <= 100""",
        function="swapPairs",
        params=[("head", "ListNode")],
        returns="ListNode",
        solver=swap_pairs,
        public=[[[1, 2, 3, 4]], [[1]], [[]], [[1, 2, 3, 4, 5]]],
        hidden=[[[1, 2]], [[1, 2, 3]], [[5, 6, 7, 8]], [[0, 1]], [[1, 2, 3, 4, 5, 6]]],
    ),
    make(
        pid=1255,
        title="分隔链表",
        tags=["链表", "双指针"],
        description="""给定一个链表和一个特定值 x，对链表进行分隔，使所有小于 x 的节点都在大于或等于 x 的节点之前。
保持每个分区内节点的相对顺序。

提示：
- 0 <= head.length <= 200
- -100 <= head[i], x <= 100""",
        function="partitionList",
        params=[("head", "ListNode"), ("x", "int")],
        returns="ListNode",
        solver=partition_list,
        public=[[[1, 4, 3, 2, 5, 2], 3], [[2, 1], 2], [[1], 0], [[1, 2, 3], 4]],
        hidden=[[[3, 1, 2], 3], [[1, 2, 3], 2], [[1, 2, 3], 1], [[5, 4, 3], 3], [[1, 1, 1], 1]],
    ),
    make(
        pid=1256,
        title="旋转链表",
        tags=["链表", "双指针"],
        description="""给定一个链表头节点 head 和一个整数 k，将链表每个节点向右移动 k 个位置，返回旋转后的链表。

提示：
- 0 <= head.length <= 500
- -100 <= head[i] <= 100
- 0 <= k <= 2 * 10^9""",
        function="rotateRight",
        params=[("head", "ListNode"), ("k", "int")],
        returns="ListNode",
        solver=rotate_right,
        public=[[[1, 2, 3, 4, 5], 2], [[0, 1, 2], 4], [[], 1], [[1], 0]],
        hidden=[[[1, 2], 1], [[1, 2, 3], 1], [[1, 2, 3], 3], [[1, 2, 3, 4], 5], [[5, 4, 3, 2, 1], 7]],
    ),
    make(
        pid=1257,
        title="二叉树的右视图",
        tags=["树", "广度优先搜索"],
        description="""给定一棵二叉树，想象自己站在树的右侧，按从顶部到底部的顺序返回能看到的节点值。

提示：
- 0 <= root.length <= 100
- -100 <= Node.val <= 100""",
        function="rightSideView",
        params=[("root", "TreeNode")],
        returns="int[]",
        solver=right_side_view,
        public=[[[1, 2, 3, None, 5, None, 4]], [[1, None, 3]], [[1, 2]], [[]]],
        hidden=[[[1, 2, 3, 4]], [[1, 2, 3, None, 5]], [[1, 2, None, 3]], [[1, 2, 3, 4, 5, 6, 7]], [[5, 4, 6, 3, None, 7]]],
    ),
    make(
        pid=1258,
        title="二叉树展开为链表",
        tags=["树", "深度优先搜索", "链表"],
        description="""给定一棵二叉树，将其展开为一个只有右子节点的单链表，展开顺序为前序遍历顺序。

提示：
- 0 <= root.length <= 1000
- -100 <= Node.val <= 100""",
        function="flattenTree",
        params=[("root", "TreeNode")],
        returns="TreeNode",
        solver=flatten_tree,
        public=[[[1, 2, 5, 3, 4, None, 6]], [[]], [[1, 2]], [[1]]],
        hidden=[[[1, 2, 3]], [[1, 2, 3, 4]], [[1, None, 2, None, 3]], [[2, 1, 3]], [[1, 2, 5, 3, 4, None, 6]]],
    ),
    make(
        pid=1259,
        title="从前序与中序遍历序列构造二叉树",
        tags=["树", "数组", "哈希表", "分治"],
        description="""给定一棵二叉树的前序遍历 preorder 和中序遍历 inorder，构造并返回这棵二叉树。
树中节点值互不相同。

提示：
- 1 <= preorder.length <= 100
- inorder.length == preorder.length""",
        function="buildTree",
        params=[("preorder", "int[]"), ("inorder", "int[]")],
        returns="TreeNode",
        solver=build_tree,
        public=[[[3, 9, 20, 15, 7], [9, 3, 15, 20, 7]], [[-1], [-1]], [[1, 2], [2, 1]], [[1, 2, 3], [2, 1, 3]]],
        hidden=[[[1, 2, 4, 5, 3], [4, 2, 5, 1, 3]], [[2, 1, 3], [1, 2, 3]], [[1, 2, 3, 4], [1, 2, 3, 4]], [[5, 3, 2, 4, 7, 6, 8], [2, 3, 4, 5, 6, 7, 8]]],
    ),
    make(
        pid=1260,
        title="路径总和 II",
        tags=["树", "深度优先搜索", "回溯"],
        description="""给定二叉树根节点 root 和一个整数目标和 targetSum，找出所有从根节点到叶子节点且节点值之和等于 targetSum 的路径。

提示：
- 0 <= root.length <= 5000
- -1000 <= Node.val, targetSum <= 1000""",
        function="pathSumII",
        params=[("root", "TreeNode"), ("targetSum", "int")],
        returns="int[][]",
        solver=path_sum_ii,
        public=[[[5, 4, 8, 11, None, 13, 4, 7, 2, None, None, 5, 1], 22], [[1, 2, 3], 5], [[1, 2], 0], [[], 0]],
        hidden=[[[1, 2, 3], 4], [[1], 1], [[1, 2, None, 3], 4], [[0, 1, 1], 1], [[-2, None, -3], -5]],
    ),
    make(
        pid=1261,
        title="根到叶数字之和",
        tags=["树", "深度优先搜索"],
        description="""给定一棵二叉树，每个节点存储 0-9 的数字。每条从根到叶子的路径都表示一个数字。
返回所有根到叶数字之和。

提示：
- 1 <= root.length <= 1000
- 0 <= Node.val <= 9""",
        function="sumRootToLeaf",
        params=[("root", "TreeNode")],
        returns="int",
        solver=sum_root_to_leaf,
        public=[[[1, 2, 3]], [[4, 9, 0, 5, 1]], [[1]], [[0, 1]]],
        hidden=[[[1, 2]], [[1, 2, 3, 4]], [[9, 9, 9]], [[1, None, 2]], [[5, 3, 8, 1, 4]]],
    ),
    make(
        pid=1262,
        title="二叉树的最近公共祖先",
        tags=["树", "深度优先搜索"],
        description="""给定一棵二叉树和两个节点值 p、q，返回它们的最近公共祖先节点值。
树中所有节点值互不相同。

提示：
- 2 <= root.length <= 10^5
- p 和 q 均存在于树中""",
        function="lowestCommonAncestor",
        params=[("root", "TreeNode"), ("p", "int"), ("q", "int")],
        returns="int",
        solver=lowest_common_ancestor,
        public=[[[3, 5, 1, 6, 2, 0, 8, None, None, 7, 4], 5, 1], [[3, 5, 1, 6, 2, 0, 8, None, None, 7, 4], 5, 4], [[1, 2], 1, 2], [[3, 1, 4, None, 2], 2, 4]],
        hidden=[[[1, 2, 3], 2, 3], [[6, 2, 8, 0, 4, 7, 9, None, None, 3, 5], 3, 5], [[2, 1, 3], 1, 3], [[5, 4, 6], 4, 6]],
    ),
    make(
        pid=1263,
        title="二叉搜索树中的插入操作",
        tags=["树", "二叉搜索树"],
        description="""给定一棵二叉搜索树和要插入的值 val，将 val 插入树中并返回插入后的二叉搜索树。
如果树为空，新节点成为根节点。

提示：
- 0 <= root.length <= 10^4
- -10^8 <= Node.val, val <= 10^8""",
        function="insertIntoBST",
        params=[("root", "TreeNode"), ("val", "int")],
        returns="TreeNode",
        solver=insert_into_bst,
        public=[[[4, 2, 7, 1, 3], 5], [[40, 20, 60, 10, 30, 50, 70], 25], [[], 5], [[1], 2]],
        hidden=[[[2, 1, 3], 4], [[5, 3, 8], 0], [[5, 3, 8], 6], [[1, 2, 3], 0], [[10, 5, 15], 12]],
    ),
    make(
        pid=1264,
        title="删除二叉搜索树中的节点",
        tags=["树", "二叉搜索树"],
        description="""给定一棵二叉搜索树的根节点和一个 key，删除树中值为 key 的节点并返回新的根节点。
若存在多个可用的替换节点，使用中序后继。

提示：
- 0 <= root.length <= 10^4
- -10^8 <= Node.val, key <= 10^8""",
        function="deleteNode",
        params=[("root", "TreeNode"), ("key", "int")],
        returns="TreeNode",
        solver=delete_node,
        public=[[[5, 3, 6, 2, 4, None, 7], 3], [[5, 3, 6, 2, 4, None, 7], 0], [[], 0], [[0], 0]],
        hidden=[[[5, 3, 6, 2, 4, None, 7], 5], [[1, None, 2], 1], [[3, 1, 4, None, 2], 2], [[2, 1], 1], [[5, 4, 6], 6]],
    ),
    make(
        pid=1265,
        title="岛屿的最大面积",
        tags=["数组", "广度优先搜索", "深度优先搜索"],
        description="""给定一个由 0 和 1 组成的二维网格 grid，1 表示陆地，0 表示水域。
岛屿由上下左右相邻的陆地连接而成；如果不存在岛屿，返回 0。求所有岛屿中的最大面积。

提示：
- 1 <= m, n <= 300
- grid[i][j] 为 0 或 1""",
        function="maxAreaOfIsland",
        params=[("grid", "int[][]")],
        returns="int",
        solver=max_area_of_island,
        public=[[[[1, 1, 1, 1, 0], [1, 1, 0, 1, 0], [1, 1, 0, 0, 0], [0, 0, 0, 0, 0]]], [[[1, 1, 0, 0, 0], [1, 1, 0, 0, 0], [0, 0, 1, 0, 0], [0, 0, 0, 1, 1]]], [[[1]]], [[[0]]]],
        hidden=[[[[1, 0, 1], [0, 0, 0], [1, 0, 1]]], [[[1, 1], [1, 1]]], [[[0, 0], [0, 0]]], [[[1, 0], [1, 1]]], [[[1, 1, 1]]], [[[1], [0], [1]]]],
    ),
    make(
        pid=1266,
        title="被围绕的区域",
        tags=["数组", "深度优先搜索", "矩阵"],
        description="""给定一个 m × n 的字符矩阵 board，由 'X' 和 'O' 组成。将被 'X' 完全围绕的 'O' 替换为 'X'。
边界上的 'O' 及其连通的 'O' 不应被替换。返回处理后的矩阵。

提示：
- 1 <= m, n <= 200
- board[i][j] 为 'X' 或 'O'""",
        function="surroundedRegions",
        params=[("board", "string[][]")],
        returns="string[][]",
        solver=surrounded_regions,
        public=[[[["X", "X", "X", "X"], ["X", "O", "O", "X"], ["X", "X", "O", "X"], ["X", "O", "X", "X"]]], [[["X"]]], [[["O"]]], [[["X", "O"], ["O", "X"]]]],
        hidden=[[[["O", "O", "O"], ["O", "O", "O"], ["O", "O", "O"]]], [[["X", "X"], ["X", "O"]]], [[["O", "X"], ["X", "O"]]], [[["X", "X", "X"], ["X", "O", "X"], ["X", "X", "X"]]], [[["X", "O", "X"], ["O", "O", "O"], ["X", "O", "X"]]]],
    ),
    make(
        pid=1267,
        title="课程表 II",
        tags=["图", "拓扑排序", "广度优先搜索"],
        description="""给定课程总数 numCourses 和先修课程列表 prerequisites，返回学习所有课程的一种顺序。
prerequisites[i] = [a, b] 表示学习课程 a 前必须先完成课程 b。如果不可能完成，返回空数组。

提示：
- 1 <= numCourses <= 2000
- 0 <= prerequisites.length <= numCourses * (numCourses - 1)""",
        function="courseScheduleII",
        params=[("numCourses", "int"), ("prerequisites", "int[][]")],
        returns="int[]",
        solver=course_schedule_ii,
        public=[[2, [[1, 0]]], [4, [[1, 0], [2, 0], [3, 1], [3, 2]]], [1, []], [2, [[0, 1], [1, 0]]]],
        hidden=[[3, [[1, 0], [2, 1]]], [3, [[0, 1], [1, 2]]], [4, [[2, 0], [3, 1]]], [5, [[1, 0], [2, 0], [3, 1], [4, 2]]], [3, [[1, 0], [2, 1], [0, 2]]]],
    ),
    make(
        pid=1268,
        title="打家劫舍 III",
        tags=["树", "动态规划", "深度优先搜索"],
        description="""房屋形成一棵二叉树，每个节点的值表示该房屋的金额。
如果两个直接相连的房屋在同一晚上被偷，系统会自动报警。返回不触动警报的情况下能偷到的最高金额。

提示：
- 1 <= root.length <= 10^4
- 0 <= Node.val <= 10^4""",
        function="robTree",
        params=[("root", "TreeNode")],
        returns="int",
        solver=rob_tree,
        public=[[[3, 2, 3, None, 3, None, 1]], [[3, 4, 5, 1, 3, None, 1]], [[1]], [[5, 1, 7]]],
        hidden=[[[2, 1, 3]], [[4, 1, None, 2, None, 3]], [[0, 0, 0]], [[6, 4, 5, 1, 3]], [[10, 5, 15, 2, 7]]],
    ),
    make(
        pid=1269,
        title="零钱兑换 II",
        tags=["数组", "动态规划"],
        description="""给定不同面额的硬币 coins 和一个总金额 amount，返回可以凑成总金额的硬币组合数。
假设每种面额的硬币有无限个。

提示：
- 1 <= coins.length <= 300
- 1 <= coins[i] <= 5000
- 0 <= amount <= 5000""",
        function="coinChangeII",
        params=[("amount", "int"), ("coins", "int[]")],
        returns="int",
        solver=coin_change_ii,
        public=[[5, [1, 2, 5]], [3, [2]], [10, [10]], [0, [7]]],
        hidden=[[4, [1, 2]], [5, [1, 5, 10]], [7, [2, 3, 5]], [11, [1, 2, 5]], [8, [3, 5]]],
    ),
    make(
        pid=1270,
        title="环形子数组的最大和",
        tags=["数组", "动态规划", "队列"],
        description="""给定一个整数数组 nums，把它首尾相连看作环形数组，返回非空连续子数组的最大和。
子数组在环形数组中最多绕一圈，不能重复选取同一段。

提示：
- 1 <= nums.length <= 10^5
- -10^4 <= nums[i] <= 10^4""",
        function="maxSubarraySumCircular",
        params=[("nums", "int[]")],
        returns="int",
        solver=max_subarray_sum_circular,
        public=[[[1, -2, 3, -2]], [[5, -3, 5]], [[-3, -2, -3]], [[2, -1, 2]]],
        hidden=[[[1]], [[-1]], [[3, -1, 2, -1]], [[-2, 4, -5, 1]], [[8, -19, 5, -4, 20]], [[-5, -2, -3]]],
    ),
    make(
        pid=1271,
        title="颜色分类",
        tags=["数组", "双指针", "排序"],
        description="""给定一个包含红色、白色和蓝色对象的数组 nums，原地排序使相同颜色相邻，并按红、白、蓝顺序排列。
红色、白色、蓝色分别用 0、1、2 表示。返回排序后的数组。

提示：
- 1 <= nums.length <= 300
- nums[i] 为 0、1 或 2""",
        function="sortColors",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=sort_colors,
        public=[[[2, 0, 2, 1, 1, 0]], [[2, 0, 1]], [[0]], [[1, 2, 0]]],
        hidden=[[[2, 2, 1, 0]], [[1, 0, 0, 1]], [[2, 1, 0]], [[0, 0, 0]], [[2, 2, 2]]],
    ),
    make(
        pid=1272,
        title="搜索二维矩阵 II",
        tags=["数组", "二分查找", "矩阵"],
        description="""给定一个 m × n 矩阵 matrix，其每行从左到右升序排列，每列从上到下升序排列。
判断 target 是否存在于矩阵中。

提示：
- 1 <= m, n <= 300
- -10^9 <= matrix[i][j], target <= 10^9""",
        function="searchMatrixII",
        params=[("matrix", "int[][]"), ("target", "int")],
        returns="bool",
        solver=search_matrix_ii,
        public=[[[[1, 4, 7, 11, 15], [2, 5, 8, 12, 19], [3, 6, 9, 16, 22], [10, 13, 14, 17, 24], [18, 21, 23, 26, 30]], 5], [[[1, 4, 7, 11, 15], [2, 5, 8, 12, 19], [3, 6, 9, 16, 22], [10, 13, 14, 17, 24], [18, 21, 23, 26, 30]], 20], [[[1]], 1], [[[1]], 0]],
        hidden=[[[[1, 2], [3, 4]], 3], [[[1, 2], [3, 4]], 5], [[[1, 5], [2, 6]], 6], [[[1, 3, 5], [2, 4, 6]], 2], [[[1, 2, 3], [4, 5, 6]], 7]],
    ),
    make(
        pid=1273,
        title="寻找峰值",
        tags=["数组", "二分查找"],
        description="""峰值元素是指其值严格大于左右相邻值的元素。给定一个整数数组 nums，找到任意一个峰值并返回其下标。
可以假设 nums[-1] = nums[n] = -∞，且数组中相邻元素不相等。

提示：
- 1 <= nums.length <= 1000
- -2^31 <= nums[i] <= 2^31 - 1""",
        function="findPeakElement",
        params=[("nums", "int[]")],
        returns="int",
        solver=find_peak_element,
        public=[[[1, 2, 3, 1]], [[1, 2, 1, 3, 5, 6, 4]], [[1]], [[2, 1]]],
        hidden=[[[1, 2]], [[3, 2, 1]], [[1, 3, 2, 4]], [[5, 4, 3, 2, 1]], [[1, 2, 3, 4]], [[2, 1, 3]]],
    ),
    make(
        pid=1274,
        title="寻找重复数",
        tags=["数组", "双指针", "二分查找"],
        description="""给定一个包含 n + 1 个整数的数组 nums，数字都在 [1, n] 范围内，且至少有一个重复整数。
假设只有一个整数重复多次，返回这个重复数。

提示：
- 1 <= n <= 10^5
- nums.length == n + 1""",
        function="findDuplicate",
        params=[("nums", "int[]")],
        returns="int",
        solver=find_duplicate,
        public=[[[1, 3, 4, 2, 2]], [[3, 1, 3, 4, 2]], [[1, 1]], [[1, 2, 2]]],
        hidden=[[[2, 2, 2, 2, 2]], [[4, 3, 4, 1, 2]], [[1, 4, 4, 2, 4]], [[3, 3, 3, 3, 3]], [[5, 4, 3, 2, 1, 5]]],
    ),
    make(
        pid=1275,
        title="数组中的第 K 个最大元素",
        tags=["数组", "排序", "堆"],
        description="""给定一个整数数组 nums 和整数 k，返回数组中第 k 个最大的元素。
注意是排序后的第 k 个最大元素，不是第 k 个不同的元素。

提示：
- 1 <= k <= nums.length <= 10^5
- -10^4 <= nums[i] <= 10^4""",
        function="findKthLargest",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=find_kth_largest,
        public=[[[3, 2, 1, 5, 6, 4], 2], [[3, 2, 3, 1, 2, 4, 5, 5, 6], 4], [[1], 1], [[2, 1], 1]],
        hidden=[[[1, 2, 3], 3], [[5, 4, 3, 2, 1], 3], [[-1, -2, -3], 1], [[0, 1, 2], 2], [[7, 7, 7], 2]],
    ),
    make(
        pid=1276,
        title="前 K 个高频元素",
        tags=["数组", "哈希表", "排序"],
        description="""给定一个整数数组 nums 和一个整数 k，返回出现频率前 k 高的元素。
答案按频率降序排列，频率相同按元素值升序排列。

提示：
- 1 <= nums.length <= 10^5
- 1 <= k <= 不同元素数量""",
        function="topKFrequent",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int[]",
        solver=top_k_frequent,
        public=[[[1, 1, 1, 2, 2, 3], 2], [[1], 1], [[1, 2], 2], [[4, 4, 4, 3, 3, 2], 2]],
        hidden=[[[1, 2, 3, 1, 2, 1], 1], [[5, 5, 4, 4, 3], 2], [[0, 0, 1, 1, 2], 3], [[7, 7, 8, 8, 9], 2], [[1, 2, 3, 4], 3]],
    ),
    make(
        pid=1277,
        title="根据字符出现频率排序",
        tags=["字符串", "哈希表", "排序"],
        description="""给定一个字符串 s，根据字符出现频率降序排列。频率相同的字符按 ASCII 码升序排列。

提示：
- 1 <= s.length <= 10^5
- s 由英文字母、数字和符号组成""",
        function="frequencySort",
        params=[("s", "string")],
        returns="string",
        solver=frequency_sort,
        public=[["tree"], ["cccaaa"], ["Aabb"], ["loveleetcode"]],
        hidden=[["a"], ["ab"], ["ba"], ["abcabc"], ["zzzzzz"], ["aabbbcc"]],
    ),
    make(
        pid=1278,
        title="加油站",
        tags=["数组", "贪心"],
        description="""一条环路上有 n 个加油站，第 i 个加油站有 gas[i] 升汽油，从第 i 个加油站到第 i+1 个加油站需要消耗 cost[i] 升。
给定 gas 和 cost，返回能绕环路行驶一周的出发加油站编号；如果不存在，返回 -1。

提示：
- 1 <= n <= 10^5
- 0 <= gas[i], cost[i] <= 10^4""",
        function="canCompleteCircuit",
        params=[("gas", "int[]"), ("cost", "int[]")],
        returns="int",
        solver=can_complete_circuit,
        public=[[[1, 2, 3, 4, 5], [3, 4, 5, 1, 2]], [[2, 3, 4], [3, 4, 3]], [[5], [4]], [[2], [2]]],
        hidden=[[[3, 1, 1], [1, 2, 2]], [[1, 2, 3], [3, 2, 1]], [[4, 5, 2, 6, 5], [3, 4, 5, 1, 2]], [[1, 2], [2, 1]], [[0, 0], [0, 0]]],
    ),
    make(
        pid=1279,
        title="分发糖果",
        tags=["数组", "贪心"],
        description="""n 个孩子站成一排，每个孩子有一个评分。老师给每个孩子分发糖果，要求每个孩子至少得到 1 颗糖，相邻孩子中评分更高的必须得到更多糖果。
返回最少需要准备的糖果数。

提示：
- 1 <= ratings.length <= 10^5
- 0 <= ratings[i] <= 10^5""",
        function="candy",
        params=[("ratings", "int[]")],
        returns="int",
        solver=candy,
        public=[[[1, 0, 2]], [[1, 2, 2]], [[1]], [[1, 2, 3]]],
        hidden=[[[3, 2, 1]], [[2, 1, 2]], [[1, 3, 2, 2, 1]], [[5, 4, 3, 2, 1]], [[1, 2, 3, 4, 5]], [[0, 0, 0]]],
    ),
]

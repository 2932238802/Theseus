"""1575-1616：批量第二批中等题（42 道）。"""

from __future__ import annotations

import bisect
import heapq
from collections import Counter, defaultdict
from functools import cmp_to_key, partial

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="medium")


# ── 数组 / 双指针 ─────────────────────────────────────────────────


def max_area(height: list[int]) -> int:
    left, right = 0, len(height) - 1
    best = 0
    while left < right:
        best = max(best, min(height[left], height[right]) * (right - left))
        if height[left] < height[right]:
            left += 1
        else:
            right -= 1
    return best


def four_sum(nums: list[int], target: int) -> list[list[int]]:
    values = sorted(nums)
    n = len(values)
    result: list[list[int]] = []
    for first in range(n - 3):
        if first > 0 and values[first] == values[first - 1]:
            continue
        for second in range(first + 1, n - 2):
            if second > first + 1 and values[second] == values[second - 1]:
                continue
            left, right = second + 1, n - 1
            while left < right:
                total = values[first] + values[second] + values[left] + values[right]
                if total == target:
                    result.append(
                        [values[first], values[second], values[left], values[right]]
                    )
                    left += 1
                    right -= 1
                    while left < right and values[left] == values[left - 1]:
                        left += 1
                    while left < right and values[right] == values[right + 1]:
                        right -= 1
                elif total < target:
                    left += 1
                else:
                    right -= 1
    return result


def product_except_self(nums: list[int]) -> list[int]:
    n = len(nums)
    result = [1] * n
    left = 1
    for index, value in enumerate(nums):
        result[index] = left
        left *= value
    right = 1
    for index in range(n - 1, -1, -1):
        result[index] *= right
        right *= nums[index]
    return result


def increasing_triplet(nums: list[int]) -> bool:
    first = second = float("inf")
    for value in nums:
        if value <= first:
            first = value
        elif value <= second:
            second = value
        else:
            return True
    return False


def count_battleships(board: list[str]) -> int:
    rows, columns = len(board), len(board[0])
    count = 0
    for row in range(rows):
        for column in range(columns):
            if board[row][column] != "X":
                continue
            if row > 0 and board[row - 1][column] == "X":
                continue
            if column > 0 and board[row][column - 1] == "X":
                continue
            count += 1
    return count


def find_duplicates(nums: list[int]) -> list[int]:
    seen: set[int] = set()
    result: set[int] = set()
    for value in nums:
        if value in seen:
            result.add(value)
        else:
            seen.add(value)
    return sorted(result)


def array_nesting(nums: list[int]) -> int:
    n = len(nums)
    visited = [False] * n
    best = 0
    for start in range(n):
        if visited[start]:
            continue
        length = 0
        index = start
        while not visited[index]:
            visited[index] = True
            length += 1
            index = nums[index]
        best = max(best, length)
    return best


def find_unsorted_subarray(nums: list[int]) -> int:
    ordered = sorted(nums)
    left = 0
    while left < len(nums) and nums[left] == ordered[left]:
        left += 1
    if left == len(nums):
        return 0
    right = len(nums) - 1
    while nums[right] == ordered[right]:
        right -= 1
    return right - left + 1


def circular_array_loop(nums: list[int]) -> bool:
    n = len(nums)
    visited = [False] * n
    for start in range(n):
        if visited[start]:
            continue
        direction = nums[start] > 0
        path: set[int] = set()
        index = start
        while True:
            if index in path:
                return True
            if visited[index]:
                break
            if (nums[index] > 0) != direction:
                break
            visited[index] = True
            path.add(index)
            next_index = (index + nums[index]) % n
            if next_index == index:
                break
            index = next_index
    return False


def h_index(citations: list[int]) -> int:
    ordered = sorted(citations, reverse=True)
    h = 0
    for index, value in enumerate(ordered, start=1):
        if value >= index:
            h = index
        else:
            break
    return h


def min_moves2(nums: list[int]) -> int:
    ordered = sorted(nums)
    median = ordered[len(ordered) // 2]
    return sum(abs(value - median) for value in ordered)


def integer_replacement(n: int) -> int:
    steps = 0
    while n > 1:
        if n % 2 == 0:
            n //= 2
        elif n == 3 or n % 4 == 1:
            n -= 1
        else:
            n += 1
        steps += 1
    return steps


def largest_number(nums: list[int]) -> str:
    def compare(left: int, right: int) -> int:
        first, second = str(left) + str(right), str(right) + str(left)
        if first > second:
            return -1
        if first < second:
            return 1
        return 0

    ordered = sorted(nums, key=cmp_to_key(compare))
    if ordered and ordered[0] == 0:
        return "0"
    return "".join(str(value) for value in ordered)


def find_min_difference(time_points: list[str]) -> int:
    minutes = []
    for point in time_points:
        hour, minute = point.split(":")
        minutes.append(int(hour) * 60 + int(minute))
    minutes.sort()
    best = 24 * 60 + minutes[0] - minutes[-1]
    for index in range(1, len(minutes)):
        best = min(best, minutes[index] - minutes[index - 1])
    return best


def contains_nearby_almost_duplicate(nums: list[int], index_diff: int, value_diff: int) -> bool:
    if value_diff < 0:
        return False
    width = value_diff + 1
    buckets: dict[int, int] = {}
    for index, value in enumerate(nums):
        key = value // width
        if key in buckets:
            return True
        if key - 1 in buckets and abs(value - buckets[key - 1]) <= value_diff:
            return True
        if key + 1 in buckets and abs(value - buckets[key + 1]) <= value_diff:
            return True
        buckets[key] = value
        if index >= index_diff:
            del buckets[nums[index - index_diff] // width]
    return False


def four_sum_count(
    nums1: list[int], nums2: list[int], nums3: list[int], nums4: list[int]
) -> int:
    sums: Counter[int] = Counter()
    for first in nums1:
        for second in nums2:
            sums[first + second] += 1
    result = 0
    for third in nums3:
        for fourth in nums4:
            result += sums.get(-(third + fourth), 0)
    return result


def least_bricks(wall: list[list[int]]) -> int:
    counts: Counter[int] = Counter()
    for row in wall:
        position = 0
        for brick in row[:-1]:
            position += brick
            counts[position] += 1
    return len(wall) - max(counts.values(), default=0)


def find_repeated_dna_sequences(s: str) -> list[str]:
    counts: Counter[str] = Counter()
    for index in range(len(s) - 9):
        counts[s[index : index + 10]] += 1
    return sorted(sequence for sequence, count in counts.items() if count > 1)


def check_subarray_sum(nums: list[int], k: int) -> bool:
    first_index = {0: -1}
    prefix = 0
    for index, value in enumerate(nums):
        prefix += value
        remainder = prefix % k
        if remainder in first_index:
            if index - first_index[remainder] >= 2:
                return True
        else:
            first_index[remainder] = index
    return False


def find_max_length(nums: list[int]) -> int:
    first_index = {0: -1}
    prefix = 0
    best = 0
    for index, value in enumerate(nums):
        prefix += 1 if value == 1 else -1
        if prefix in first_index:
            best = max(best, index - first_index[prefix])
        else:
            first_index[prefix] = index
    return best


def sum_region_queries(matrix: list[list[int]], queries: list[list[int]]) -> list[int]:
    rows, columns = len(matrix), len(matrix[0])
    prefix = [[0] * (columns + 1) for _ in range(rows + 1)]
    for row in range(rows):
        for column in range(columns):
            prefix[row + 1][column + 1] = (
                matrix[row][column]
                + prefix[row][column + 1]
                + prefix[row + 1][column]
                - prefix[row][column]
            )
    result = []
    for row1, column1, row2, column2 in queries:
        result.append(
            prefix[row2 + 1][column2 + 1]
            - prefix[row1][column2 + 1]
            - prefix[row2 + 1][column1]
            + prefix[row1][column1]
        )
    return result


def max_rotate_function(nums: list[int]) -> int:
    n = len(nums)
    total = sum(nums)
    current = sum(index * value for index, value in enumerate(nums))
    best = current
    for rotation in range(1, n):
        current += total - n * nums[n - rotation]
        best = max(best, current)
    return best


def remove_k_digits(num: str, k: int) -> str:
    stack: list[str] = []
    for digit in num:
        while k > 0 and stack and stack[-1] > digit:
            stack.pop()
            k -= 1
        stack.append(digit)
    if k > 0:
        stack = stack[:-k]
    result = "".join(stack).lstrip("0")
    return result or "0"


def remove_duplicate_letters(s: str) -> str:
    last = {character: index for index, character in enumerate(s)}
    stack: list[str] = []
    used: set[str] = set()
    for index, character in enumerate(s):
        if character in used:
            continue
        while stack and stack[-1] > character and last[stack[-1]] > index:
            used.remove(stack.pop())
        stack.append(character)
        used.add(character)
    return "".join(stack)


def next_greater_elements(nums: list[int]) -> list[int]:
    n = len(nums)
    result = [-1] * n
    stack: list[int] = []
    for index in range(2 * n):
        position = index % n
        while stack and nums[stack[-1]] < nums[position]:
            result[stack.pop()] = nums[position]
        if index < n:
            stack.append(position)
    return result


def find132pattern(nums: list[int]) -> bool:
    stack: list[int] = []
    third = float("-inf")
    for value in reversed(nums):
        if value < third:
            return True
        while stack and stack[-1] < value:
            third = stack.pop()
        stack.append(value)
    return False


def single_non_duplicate(nums: list[int]) -> int:
    left, right = 0, len(nums) - 1
    while left < right:
        middle = (left + right) // 2
        if middle % 2 == 1:
            middle -= 1
        if nums[middle] == nums[middle + 1]:
            left = middle + 2
        else:
            right = middle
    return nums[left]


def find_right_interval(intervals: list[list[int]]) -> list[int]:
    ordered = sorted((start, index) for index, (start, _) in enumerate(intervals))
    starts = [start for start, _ in ordered]
    result = []
    for _, end in intervals:
        position = bisect.bisect_left(starts, end)
        result.append(ordered[position][1] if position < len(ordered) else -1)
    return result


def find_radius(houses: list[int], heaters: list[int]) -> int:
    ordered_houses = sorted(houses)
    ordered_heaters = sorted(heaters)
    radius = 0
    heater_index = 0
    for house in ordered_houses:
        while (
            heater_index + 1 < len(ordered_heaters)
            and abs(ordered_heaters[heater_index + 1] - house)
            <= abs(ordered_heaters[heater_index] - house)
        ):
            heater_index += 1
        radius = max(radius, abs(ordered_heaters[heater_index] - house))
    return radius


def k_smallest_pairs(nums1: list[int], nums2: list[int], k: int) -> list[list[int]]:
    if not nums1 or not nums2 or k <= 0:
        return []
    heap = [
        (nums1[0] + nums2[column], 0, column)
        for column in range(min(len(nums2), k))
    ]
    heapq.heapify(heap)
    result = []
    while heap and len(result) < k:
        _, row, column = heapq.heappop(heap)
        result.append([nums1[row], nums2[column]])
        if row + 1 < len(nums1):
            heapq.heappush(
                heap, (nums1[row + 1] + nums2[column], row + 1, column)
            )
    return result


def is_possible(nums: list[int]) -> bool:
    counts: Counter[int] = Counter(nums)
    tails: dict[int, int] = defaultdict(int)
    for value in sorted(nums):
        if counts[value] == 0:
            continue
        if tails[value - 1] > 0:
            tails[value - 1] -= 1
            tails[value] += 1
            counts[value] -= 1
        elif counts[value + 1] > 0 and counts[value + 2] > 0:
            counts[value] -= 1
            counts[value + 1] -= 1
            counts[value + 2] -= 1
            tails[value + 2] += 1
        else:
            return False
    return True


def number_of_boomerangs(points: list[list[int]]) -> int:
    result = 0
    for index, (x1, y1) in enumerate(points):
        distances: Counter[int] = Counter()
        for other, (x2, y2) in enumerate(points):
            if other == index:
                continue
            distances[(x1 - x2) ** 2 + (y1 - y2) ** 2] += 1
        for count in distances.values():
            result += count * (count - 1)
    return result


def compare_version(version1: str, version2: str) -> int:
    first = [int(part) for part in version1.split(".")]
    second = [int(part) for part in version2.split(".")]
    length = max(len(first), len(second))
    for index in range(length):
        left = first[index] if index < len(first) else 0
        right = second[index] if index < len(second) else 0
        if left < right:
            return -1
        if left > right:
            return 1
    return 0


def valid_ip_address(query_ip: str) -> str:
    def is_ipv4(text: str) -> bool:
        parts = text.split(".")
        if len(parts) != 4:
            return False
        for part in parts:
            if not part or len(part) > 3:
                return False
            if not all("0" <= character <= "9" for character in part):
                return False
            if len(part) > 1 and part[0] == "0":
                return False
            if int(part) > 255:
                return False
        return True

    def is_ipv6(text: str) -> bool:
        parts = text.split(":")
        if len(parts) != 8:
            return False
        hexadecimal = set("0123456789abcdefABCDEF")
        for part in parts:
            if not 1 <= len(part) <= 4:
                return False
            if not all(character in hexadecimal for character in part):
                return False
        return True

    if is_ipv4(query_ip):
        return "IPv4"
    if is_ipv6(query_ip):
        return "IPv6"
    return "Neither"


def reverse_words(s: str) -> str:
    return " ".join(reversed(s.split()))


def is_subsequence(candidate: str, source: str) -> bool:
    iterator = iter(source)
    return all(character in iterator for character in candidate)


def find_lus_length(strs: list[str]) -> int:
    order = sorted(range(len(strs)), key=lambda index: -len(strs[index]))
    for index in order:
        if all(
            not is_subsequence(strs[index], strs[other])
            for other in range(len(strs))
            if other != index
        ):
            return len(strs[index])
    return -1


def find_longest_word(s: str, dictionary: list[str]) -> str:
    best = ""
    for word in dictionary:
        if not is_subsequence(word, s):
            continue
        if len(word) > len(best) or (len(word) == len(best) and word < best):
            best = word
    return best


def complex_number_multiply(num1: str, num2: str) -> str:
    def parse(number: str) -> tuple[int, int]:
        real, imaginary = number[:-1].split("+")
        return int(real), int(imaginary)

    real1, imaginary1 = parse(num1)
    real2, imaginary2 = parse(num2)
    real = real1 * real2 - imaginary1 * imaginary2
    imaginary = real1 * imaginary2 + imaginary1 * real2
    return f"{real}+{imaginary}i"


def length_longest_path(input: str) -> int:
    stack: list[str] = []
    best = 0
    for line in input.split("\n"):
        depth = len(line) - len(line.lstrip("\t"))
        name = line[depth:]
        stack = stack[:depth]
        if "." in name:
            best = max(
                best, sum(len(part) for part in stack) + len(stack) + len(name)
            )
        else:
            stack.append(name)
    return best


def original_digits(s: str) -> str:
    counts: Counter[str] = Counter(s)
    digits = [0] * 10
    digits[0] = counts["z"]
    digits[2] = counts["w"]
    digits[4] = counts["u"]
    digits[6] = counts["x"]
    digits[8] = counts["g"]
    digits[1] = counts["o"] - digits[0] - digits[2] - digits[4]
    digits[3] = counts["h"] - digits[8]
    digits[5] = counts["f"] - digits[4]
    digits[7] = counts["s"] - digits[6]
    digits[9] = counts["i"] - digits[5] - digits[6] - digits[8]
    return "".join(str(digit) * digits[digit] for digit in range(10))


def valid_utf8(data: list[int]) -> bool:
    index = 0
    length = len(data)
    while index < length:
        byte = data[index]
        if byte < 0b10000000:
            index += 1
            continue
        elif 0b11000000 <= byte <= 0b11011111:
            needed = 1
            index += 1
        elif 0b11100000 <= byte <= 0b11101111:
            needed = 2
            index += 1
        elif 0b11110000 <= byte <= 0b11110111:
            needed = 3
            index += 1
        else:
            return False
        if index + needed > length:
            return False
        for _ in range(needed):
            if not 0b10000000 <= data[index] <= 0b10111111:
                return False
            index += 1
    return True


def find_nth_digit(n: int) -> int:
    digits = 1
    count = 9
    start = 1
    while n > digits * count:
        n -= digits * count
        digits += 1
        count *= 10
        start *= 10
    index = (n - 1) // digits
    position = (n - 1) % digits
    return int(str(start + index)[position])


PROBLEMS = [
    make(
        pid=1575,
        title="盛最多水的容器",
        tags=["数组", "双指针"],
        description="""给定长度为 n 的整数数组 height，第 i 条线的两个端点是 (i, 0) 和 (i, height[i])
选出两条线，与 x 轴共同构成一个容器，使容器能容纳的水最多
返回容器可以储存的最大水量""",
        function="maxArea",
        params=[("height", "int[]")],
        returns="int",
        solver=max_area,
        public=[
            [[1, 8, 6, 2, 5, 4, 8, 3, 7]],
            [[1, 1]],
            [[4, 3, 2, 1, 4]],
        ],
        hidden=[
            [[1, 2, 1]],
            [[2, 3, 4, 5, 18, 17, 6]],
            [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]],
            [[5, 5, 5, 5]],
        ],
    ),
    make(
        pid=1576,
        title="四数之和",
        tags=["数组", "双指针", "排序"],
        description="""给定整数数组 nums 和目标值 target，找出所有和为 target 且互不相同的四元组
四元组由四个不同的下标对应的元素组成，同一个四元组不能重复出现
每个四元组内部按升序排列，所有四元组整体按字典序升序排列后返回""",
        function="fourSum",
        params=[("nums", "int[]"), ("target", "int")],
        returns="int[][]",
        solver=four_sum,
        public=[
            [[1, 0, -1, 0, -2, 2], 0],
            [[2, 2, 2, 2, 2], 8],
            [[1, 2, 3, 4], 10],
            [[-3, -1, 0, 2, 4, 5], 2],
        ],
        hidden=[
            [[0, 0, 0, 0], 0],
            [[1, 2, 3, 4, 5, 6], 12],
            [[-2, -1, -1, 1, 1, 2, 2], 0],
            [[100000000, 100000000, 100000000, 100000000], 400000000],
            [[1, 2], 3],
        ],
    ),
    make(
        pid=1577,
        title="除自身以外数组的乘积",
        tags=["数组", "前缀和"],
        description="""给定整数数组 nums，返回数组 answer
其中 answer[i] 等于 nums 中除 nums[i] 之外其余所有元素的乘积
题目保证任意元素的乘积不会溢出 32 位整数
要求不使用除法并在 O(n) 时间内完成""",
        function="productExceptSelf",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=product_except_self,
        public=[
            [[1, 2, 3, 4]],
            [[-1, 1, 0, -3, 3]],
            [[2, 3]],
            [[0, 0, 4]],
        ],
        hidden=[
            [[2, 5, 1]],
            [[1, 2]],
            [[0, 4, 0]],
            [[-2, -3, -4]],
            [[5, 2, 3, 1, 4]],
        ],
    ),
    make(
        pid=1578,
        title="递增的三元子序列",
        tags=["数组", "贪心"],
        description="""给定整数数组 nums
判断是否存在下标 i < j < k 使得 nums[i] < nums[j] < nums[k]
若存在返回 true，否则返回 false
要求 O(n) 时间与 O(1) 额外空间""",
        function="increasingTriplet",
        params=[("nums", "int[]")],
        returns="bool",
        solver=increasing_triplet,
        public=[
            [[1, 2, 3, 4, 5]],
            [[5, 4, 3, 2, 1]],
            [[2, 1, 5, 0, 4, 6]],
            [[1, 1, 1, 1]],
        ],
        hidden=[
            [[1, 2, 1, 3]],
            [[20, 100, 10, 12, 5, 13]],
            [[1, 2]],
            [[1, 0, 0, 0, 0, 1]],
            [[3, 5, 1, 4, 2, 6]],
        ],
    ),
    make(
        pid=1579,
        title="甲板上的战舰",
        tags=["数组", "矩阵"],
        description="""给定由字符 X 和 . 组成的二维甲板 board
战舰只能是水平或垂直的连续 X，且任意两艘战舰互不相邻
返回甲板上战舰的数量
要求只扫描一次并使用 O(1) 额外空间""",
        function="countBattleships",
        params=[("board", "string[][]")],
        returns="int",
        solver=count_battleships,
        public=[
            [[["X", ".", ".", "X"], [".", ".", ".", "X"], [".", ".", ".", "X"]]],
            [[["."]]],
            [[["X"]]],
            [[["X", "X", ".", "."], [".", ".", "X", "."], [".", ".", "X", "."]]],
        ],
        hidden=[
            [[["X", ".", "X"], [".", "X", "."], ["X", ".", "X"]]],
            [[["X", "X", "X"]]],
            [[["X", ".", ".", "X", ".", "X"]]],
            [[["."], ["."], ["."]]],
        ],
    ),
    make(
        pid=1580,
        title="数组中重复的数据",
        tags=["数组", "哈希表"],
        description="""给定长度为 n 的整数数组 nums，其中 1 <= nums[i] <= n
每个整数最多出现两次，有些整数出现一次，有些出现两次
返回所有出现两次的整数，结果按升序排列
要求 O(n) 时间且只使用常量额外空间""",
        function="findDuplicates",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=find_duplicates,
        public=[
            [[4, 3, 2, 7, 8, 2, 3, 1]],
            [[1, 1, 2]],
            [[1, 2, 3]],
            [[2, 2, 1, 1]],
        ],
        hidden=[
            [[1]],
            [[1, 1]],
            [[5, 4, 6, 7, 9, 3, 10, 9, 5, 6]],
            [[1, 2, 2, 3, 3, 4]],
            [[2, 1, 2, 1]],
        ],
    ),
    make(
        pid=1581,
        title="数组嵌套",
        tags=["数组", "图"],
        description="""给定长度为 n 的整数数组 nums，它是 0 到 n-1 的一个排列
从某个下标 i 出发，不断访问 nums[i]，再访问 nums[nums[i]]，如此继续
访问路径最终会形成环，路径长度定义为经过的不同下标数量
返回所有可能路径中的最大长度""",
        function="arrayNesting",
        params=[("nums", "int[]")],
        returns="int",
        solver=array_nesting,
        public=[
            [[5, 4, 0, 3, 1, 2]],
            [[0, 1, 2]],
            [[1, 0]],
            [[0]],
        ],
        hidden=[
            [[0, 2, 1]],
            [[2, 0, 1]],
            [[1, 2, 3, 4, 5, 0]],
            [[4, 0, 2, 1, 3]],
        ],
    ),
    make(
        pid=1582,
        title="最短无序连续子数组",
        tags=["数组", "排序"],
        description="""给定整数数组 nums
找出一个最短的连续子数组，使得只将这个子数组升序排序后整个数组变为升序
返回该子数组的长度，若原数组已经有序则返回 0""",
        function="findUnsortedSubarray",
        params=[("nums", "int[]")],
        returns="int",
        solver=find_unsorted_subarray,
        public=[
            [[2, 6, 4, 8, 10, 9, 15]],
            [[1, 2, 3, 4]],
            [[1]],
            [[1, 3, 2, 2, 2]],
        ],
        hidden=[
            [[1, 2, 3, 3, 3]],
            [[1, 3, 2, 4, 5]],
            [[5, 4, 3, 2, 1]],
            [[2, 1]],
            [[1, 2, 4, 5, 3]],
        ],
    ),
    make(
        pid=1583,
        title="环形数组是否存在循环",
        tags=["数组", "双指针"],
        description="""给定不含 0 的整数数组 nums，从下标 i 移动 nums[i] 步到达 (i + nums[i]) % n
移动时正数表示前进，负数表示后退
若存在一个循环，循环中的移动方向一致且循环长度大于 1，返回 true，否则返回 false""",
        function="circularArrayLoop",
        params=[("nums", "int[]")],
        returns="bool",
        solver=circular_array_loop,
        public=[
            [[2, -1, 1, 2, 2]],
            [[-1, 2]],
            [[-2, 1, -1, -2, -2]],
            [[1]],
        ],
        hidden=[
            [[1, 1, 1, 1, 1]],
            [[-1, -1, -1, -1, -1]],
            [[1, -1, 1, -1]],
            [[3, 1, 2]],
            [[2, 2, 2, 2]],
        ],
    ),
    make(
        pid=1584,
        title="H 指数",
        tags=["数组", "排序"],
        description="""给定研究者的引用次数数组 citations
H 指数定义为最大的 h，使得至少有 h 篇论文分别被引用至少 h 次
返回该研究者的 H 指数""",
        function="hIndex",
        params=[("citations", "int[]")],
        returns="int",
        solver=h_index,
        public=[
            [[3, 0, 6, 1, 5]],
            [[1, 3, 1]],
            [[0]],
            [[1]],
        ],
        hidden=[
            [[4, 4, 4, 4]],
            [[10, 8, 5, 3, 3]],
            [[100]],
            [[0, 0, 0]],
            [[2, 2, 2]],
        ],
    ),
    make(
        pid=1585,
        title="最少移动次数使数组元素相等 II",
        tags=["数组", "排序", "中位数"],
        description="""给定整数数组 nums
每次操作可以将任意一个元素加 1 或减 1
返回使所有数组元素相等所需的最小操作次数""",
        function="minMoves2",
        params=[("nums", "int[]")],
        returns="long",
        solver=min_moves2,
        public=[
            [[1, 2, 3]],
            [[1, 10, 2, 9]],
            [[1, 0, 0, 8, 6]],
            [[5]],
        ],
        hidden=[
            [[1, 1, 1]],
            [[-1, 2, 4]],
            [[1, 2, 3, 4, 5]],
            [[0, 1000000000]],
        ],
    ),
    make(
        pid=1586,
        title="整数替换",
        tags=["数学", "位运算", "贪心"],
        description="""给定正整数 n
当 n 为偶数时，可以将 n 替换为 n / 2
当 n 为奇数时，可以将 n 替换为 n - 1 或 n + 1
返回把 n 变成 1 所需的最少操作次数""",
        function="integerReplacement",
        params=[("n", "int")],
        returns="int",
        solver=integer_replacement,
        public=[
            [8],
            [7],
            [4],
            [1],
        ],
        hidden=[
            [2],
            [3],
            [15],
            [16],
            [10],
            [2147483647],
        ],
    ),
    make(
        pid=1587,
        title="最大数",
        tags=["数组", "排序", "字符串"],
        description="""给定非负整数数组 nums
将数组中的数字重新排列并拼接，使得到的字符串表示的数最大
返回这个最大的数字字符串
若结果全是 0 则返回字符串 0""",
        function="largestNumber",
        params=[("nums", "int[]")],
        returns="string",
        solver=largest_number,
        public=[
            [[10, 2]],
            [[3, 30, 34, 5, 9]],
            [[0, 0]],
            [[1]],
        ],
        hidden=[
            [[1, 2, 3]],
            [[0]],
            [[121, 12]],
            [[999999998, 999999997, 999999999]],
            [[0, 0, 0, 1]],
        ],
    ),
    make(
        pid=1588,
        title="最小时间差",
        tags=["数组", "排序", "字符串"],
        description="""给定一个 24 小时制时间列表 timePoints，格式为 HH:MM
返回列表中任意两个时间之间的最小分钟差
时间按环形计算，例如 23:59 与 00:00 相差 1 分钟""",
        function="findMinDifference",
        params=[("timePoints", "string[]")],
        returns="int",
        solver=find_min_difference,
        public=[
            [["23:59", "00:00"]],
            [["00:00", "23:59", "00:00"]],
            [["01:01", "02:01", "03:01"]],
            [["05:31", "22:08", "00:35"]],
        ],
        hidden=[
            [["00:00", "00:01"]],
            [["00:00", "12:00"]],
            [["12:00", "12:01", "00:00"]],
            [["01:00", "01:30", "02:00", "23:00"]],
        ],
    ),
    make(
        pid=1589,
        title="存在重复元素 III",
        tags=["数组", "哈希表", "滑动窗口"],
        description="""给定整数数组 nums 以及整数 indexDiff 和 valueDiff
判断是否存在两个不同下标 i 和 j 满足 abs(i - j) <= indexDiff 且 abs(nums[i] - nums[j]) <= valueDiff
若存在返回 true，否则返回 false""",
        function="containsNearbyAlmostDuplicate",
        params=[("nums", "int[]"), ("indexDiff", "int"), ("valueDiff", "int")],
        returns="bool",
        solver=contains_nearby_almost_duplicate,
        public=[
            [[1, 2, 3, 1], 3, 0],
            [[1, 0, 1, 1], 1, 2],
            [[1, 5, 9, 1, 5, 9], 2, 3],
            [[1, 2], 0, 1],
        ],
        hidden=[
            [[1, 2, 3, 1], 3, 1],
            [[-3, 3], 1, 6],
            [[1, 2, 1, 2], 1, 0],
            [[0, 10, 20], 5, 5],
            [[4, 1, 2, 3], 2, 1],
        ],
    ),
    make(
        pid=1590,
        title="四数相加 II",
        tags=["数组", "哈希表"],
        description="""给定四个整数数组 nums1、nums2、nums3、nums4，长度都为 n
统计有多少个四元组 (i, j, k, l) 满足 nums1[i] + nums2[j] + nums3[k] + nums4[l] == 0
返回满足条件的元组数量""",
        function="fourSumCount",
        params=[
            ("nums1", "int[]"),
            ("nums2", "int[]"),
            ("nums3", "int[]"),
            ("nums4", "int[]"),
        ],
        returns="int",
        solver=four_sum_count,
        public=[
            [[1, 2], [-2, -1], [-1, 2], [0, 2]],
            [[0], [0], [0], [0]],
            [[1, 2], [3, 4], [5, 6], [7, 8]],
            [[-1, -1], [-1, -1], [-1, -1], [-1, -1]],
        ],
        hidden=[
            [[1], [-1], [0], [0]],
            [[1, 2, 3], [0, 0, 0], [0, 0, 0], [-1, -2, -3]],
            [[2, -2], [2, -2], [2, -2], [2, -2]],
            [[5], [-5], [0], [0]],
        ],
    ),
    make(
        pid=1591,
        title="砖墙",
        tags=["数组", "哈希表"],
        description="""给定一面由砖块组成的墙 wall，wall[i] 表示第 i 行每块砖的宽度
所有行的总宽度相同，从顶部画一条垂直线，要求穿过的砖块数量最少
返回穿过砖块的最少数量
垂直线不能画在墙的两端""",
        function="leastBricks",
        params=[("wall", "int[][]")],
        returns="int",
        solver=least_bricks,
        public=[
            [[[1, 2, 2, 1], [3, 1, 2], [1, 3, 2], [2, 4], [3, 1, 2], [1, 3, 1, 1]]],
            [[[1], [1], [1]]],
            [[[1, 1], [2]]],
            [[[2, 2, 2], [1, 1, 2, 2]]],
        ],
        hidden=[
            [[[1, 1, 1], [1, 1, 1]]],
            [[[1, 2, 3], [1, 2, 3], [1, 2, 3]]],
            [[[4], [4], [4]]],
            [[[1, 1, 1, 1]]],
        ],
    ),
    make(
        pid=1592,
        title="重复的 DNA 序列",
        tags=["字符串", "哈希表", "滑动窗口"],
        description="""DNA 序列由字符 A、C、G、T 组成
给定字符串 s，找出所有在 s 中出现不止一次的长度为 10 的子串
返回这些子串，按字典序升序排列，重复子串只返回一次""",
        function="findRepeatedDnaSequences",
        params=[("s", "string")],
        returns="string[]",
        solver=find_repeated_dna_sequences,
        public=[
            ["AAAAACCCCCAAAAACCCCCCAAAAAGGGTTT"],
            ["AAAAAAAAAAAAA"],
            ["ACGT"],
            ["AAAAAAAAAA"],
        ],
        hidden=[
            ["ACGTACGTACGTACGTACGT"],
            ["CCCACCCCAAACCCACCCCC"],
            ["GAGAGAGAGAGAGAGAGAGA"],
            ["TTTTTTTTTTTTTTTTTTTT"],
            ["A"],
        ],
    ),
    make(
        pid=1593,
        title="连续的子数组和",
        tags=["数组", "前缀和", "哈希表"],
        description="""给定整数数组 nums 和整数 k，k 大于 0
判断是否存在长度至少为 2 的连续子数组，其元素和是 k 的整数倍
若存在返回 true，否则返回 false""",
        function="checkSubarraySum",
        params=[("nums", "int[]"), ("k", "int")],
        returns="bool",
        solver=check_subarray_sum,
        public=[
            [[23, 2, 4, 6, 7], 6],
            [[23, 2, 6, 4, 7], 6],
            [[23, 2, 6, 4, 7], 13],
            [[5, 0, 0, 0], 3],
        ],
        hidden=[
            [[0, 0], 1],
            [[1, 2, 3], 5],
            [[1, 2, 3, 4, 5], 9],
            [[0], 1],
            [[2, 4, 3], 6],
        ],
    ),
    make(
        pid=1594,
        title="连续数组",
        tags=["数组", "前缀和", "哈希表"],
        description="""给定只包含 0 和 1 的整数数组 nums
找出含有相同数量 0 和 1 的最长连续子数组，返回其长度
若不存在这样的子数组则返回 0""",
        function="findMaxLength",
        params=[("nums", "int[]")],
        returns="int",
        solver=find_max_length,
        public=[
            [[0, 1]],
            [[0, 1, 0]],
            [[0, 0, 1, 0, 0, 0, 1, 1]],
            [[1, 1, 1, 1, 1]],
        ],
        hidden=[
            [[0]],
            [[0, 0, 1, 1]],
            [[1, 0, 1, 0, 1, 1, 0, 0]],
            [[0, 0, 0, 1, 1, 1, 0]],
            [[1, 0]],
        ],
    ),
    make(
        pid=1595,
        title="二维区域和检索 - 矩阵不可变",
        tags=["数组", "前缀和", "矩阵"],
        description="""给定二维整数矩阵 matrix 和查询列表 queries
每个查询为 [row1, col1, row2, col2]，表示矩阵中一个矩形区域的左上角和右下角下标
计算每个矩形区域内元素之和，区域边界包含在内
返回数组按 queries 的顺序给出每个查询的结果""",
        function="sumRegionQueries",
        params=[("matrix", "int[][]"), ("queries", "int[][]")],
        returns="int[]",
        solver=sum_region_queries,
        public=[
            [
                [[3, 0, 1, 4, 2], [5, 6, 3, 2, 1], [1, 2, 0, 1, 5], [4, 1, 0, 1, 7], [1, 0, 3, 0, 5]],
                [[2, 1, 4, 3], [1, 1, 2, 2], [1, 2, 2, 4]],
            ],
            [[[1]], [[0, 0, 0, 0]]],
            [[[1, 2], [3, 4]], [[0, 0, 1, 1], [0, 0, 0, 0], [0, 1, 1, 1]]],
            [[[2, 3], [5, 7]], [[0, 0, 0, 1]]],
        ],
        hidden=[
            [[[1, 2, 3], [4, 5, 6]], [[0, 0, 1, 1], [1, 0, 1, 2]]],
            [[[-1, -2], [-3, -4]], [[0, 0, 1, 1], [0, 1, 0, 1]]],
            [[[1, 1, 1], [1, 1, 1]], [[0, 0, 0, 2], [1, 1, 1, 1], [0, 1, 1, 2]]],
            [[[0, 0], [0, 0]], [[0, 0, 1, 1]]],
        ],
    ),
    make(
        pid=1596,
        title="旋转函数",
        tags=["数组", "前缀和", "数学"],
        description="""给定长度为 n 的整数数组 nums
定义 F(k) = 0 * nums[k] + 1 * nums[k+1] + ... + (n-1) * nums[(k+n-1) % n]
其中 k 从 0 到 n-1，数组下标按循环方式取用
返回 F(0) 到 F(n-1) 中的最大值""",
        function="maxRotateFunction",
        params=[("nums", "int[]")],
        returns="long",
        solver=max_rotate_function,
        public=[
            [[4, 3, 2, 6]],
            [[100]],
            [[1, 2, 3]],
            [[0, 0, 0]],
        ],
        hidden=[
            [[1, 2, 3, 4, 5]],
            [[-1, -2, -3]],
            [[5, 1, 9]],
            [[1]],
            [[2, 3, 4, 1]],
        ],
    ),
    make(
        pid=1597,
        title="移掉 K 位数字",
        tags=["字符串", "栈", "贪心"],
        description="""给定一个以字符串表示的非负整数 num 和整数 k
移除 num 中的 k 个数字，使剩下的数字组成的新数最小
返回这个最小数字对应的字符串，不能有前导零
如果移除后所有数字都被删掉，返回字符串 0""",
        function="removeKdigits",
        params=[("num", "string"), ("k", "int")],
        returns="string",
        solver=remove_k_digits,
        public=[
            ["1432219", 3],
            ["10200", 1],
            ["10", 2],
            ["112", 1],
        ],
        hidden=[
            ["9", 1],
            ["12345", 2],
            ["1111", 2],
            ["100200", 2],
            ["4321", 2],
        ],
    ),
    make(
        pid=1598,
        title="去除重复字母",
        tags=["字符串", "栈", "贪心"],
        description="""给定字符串 s，删除其中重复的字母，使每个字母只出现一次
在所有可能的结果中，要求返回字典序最小的结果
返回的字符串中字符相对顺序不能改变""",
        function="removeDuplicateLetters",
        params=[("s", "string")],
        returns="string",
        solver=remove_duplicate_letters,
        public=[
            ["bcabc"],
            ["cbacdcbc"],
            ["abacb"],
            ["zab"],
        ],
        hidden=[
            ["a"],
            ["aaaa"],
            ["cba"],
            ["bacbc"],
            ["edcbaabcd"],
        ],
    ),
    make(
        pid=1599,
        title="下一个更大元素 II",
        tags=["数组", "栈", "单调栈"],
        description="""给定循环整数数组 nums
对每个元素 nums[i]，找到它后面第一个比它大的元素
查找时可以循环使用数组，若不存在这样的元素则为 -1
返回每个位置对应的下一个更大元素""",
        function="nextGreaterElements",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=next_greater_elements,
        public=[
            [[1, 2, 1]],
            [[1, 2, 3, 4, 3]],
            [[5, 4, 3, 2, 1]],
            [[1, 1, 1]],
        ],
        hidden=[
            [[2, 1, 2]],
            [[-1, 0]],
            [[3, 1, 2, 4]],
            [[1]],
            [[7, 1, 5, 3, 6, 4]],
        ],
    ),
    make(
        pid=1600,
        title="132 模式",
        tags=["数组", "栈", "单调栈"],
        description="""给定整数数组 nums
判断是否存在下标 i < j < k，满足 nums[i] < nums[k] < nums[j]
若存在返回 true，否则返回 false""",
        function="find132pattern",
        params=[("nums", "int[]")],
        returns="bool",
        solver=find132pattern,
        public=[
            [[1, 2, 3, 4]],
            [[3, 1, 4, 2]],
            [[-1, 3, 2, 0]],
            [[1, 0, 1, -1, -1]],
        ],
        hidden=[
            [[1, 2]],
            [[2, 3, 1]],
            [[3, 5, 0, 3, 4]],
            [[-2, 1, 2, -2, 1, 2]],
            [[1, 0, -1]],
        ],
    ),
    make(
        pid=1601,
        title="有序数组中的单一元素",
        tags=["数组", "二分查找"],
        description="""给定一个按升序排列的整数数组 nums
除一个元素只出现一次外，其余每个元素都恰好出现两次
返回只出现一次的元素
要求 O(log n) 时间与 O(1) 额外空间""",
        function="singleNonDuplicate",
        params=[("nums", "int[]")],
        returns="int",
        solver=single_non_duplicate,
        public=[
            [[1, 1, 2, 3, 3, 4, 4, 8, 8]],
            [[3, 3, 7, 7, 10, 11, 11]],
            [[1]],
            [[1, 1, 2]],
        ],
        hidden=[
            [[1, 2, 2]],
            [[0, 0, 1, 1, 2, 3, 3]],
            [[-1, -1, 0]],
            [[5, 5, 6, 6, 7, 8, 8, 9, 9]],
            [[2, 3, 3]],
        ],
    ),
    make(
        pid=1602,
        title="寻找右区间",
        tags=["数组", "二分查找", "排序"],
        description="""给定一组区间 intervals，其中 intervals[i] = [start_i, end_i]
对于每个区间 i，寻找另一个区间 j，使 start_j >= end_i 且 start_j 最小
返回每个区间对应的 j 的下标，若不存在则返回 -1
结果数组按输入区间的顺序排列""",
        function="findRightInterval",
        params=[("intervals", "int[][]")],
        returns="int[]",
        solver=find_right_interval,
        public=[
            [[[1, 2]]],
            [[[3, 4], [2, 3], [1, 2]]],
            [[[1, 4], [2, 3], [3, 4]]],
            [[[1, 2], [2, 3]]],
        ],
        hidden=[
            [[[1, 4], [2, 3], [3, 4], [5, 6]]],
            [[[5, 6], [1, 2], [2, 3]]],
            [[[-3, -2], [-1, 0], [0, 1]]],
            [[[1, 10], [2, 3], [4, 5]]],
        ],
    ),
    make(
        pid=1603,
        title="供暖器",
        tags=["数组", "二分查找", "排序"],
        description="""给定房屋位置数组 houses 和供暖器位置数组 heaters
供暖器的辐射半径相同，所有房屋都必须被至少一个供暖器覆盖
返回能够覆盖所有房屋的最小辐射半径""",
        function="findRadius",
        params=[("houses", "int[]"), ("heaters", "int[]")],
        returns="int",
        solver=find_radius,
        public=[
            [[1, 2, 3], [2]],
            [[1, 2, 3, 4], [1, 4]],
            [[1, 5], [2]],
            [[1, 2, 3], [1, 3]],
        ],
        hidden=[
            [[1], [1]],
            [[1, 2, 3, 4, 5], [3]],
            [[1, 100], [50, 51]],
            [[1, 2, 3, 4, 5, 6], [2, 5]],
            [[10, 20, 30], [15]],
        ],
    ),
    make(
        pid=1604,
        title="查找和最小的 K 对数字",
        tags=["数组", "堆", "排序"],
        description="""给定两个升序整数数组 nums1 和 nums2，以及整数 k
从两个数组中各取一个元素组成数对 (nums1[i], nums2[j])
返回和最小的 k 个数对
结果按数对和升序排列；和相同时先按 i 升序、再按 j 升序排列""",
        function="kSmallestPairs",
        params=[("nums1", "int[]"), ("nums2", "int[]"), ("k", "int")],
        returns="int[][]",
        solver=k_smallest_pairs,
        public=[
            [[1, 7, 11], [2, 4, 6], 3],
            [[1, 1, 2], [1, 2, 3], 2],
            [[1, 2], [3, 4], 3],
            [[1, 2, 3], [1, 1, 1], 4],
        ],
        hidden=[
            [[1], [1], 1],
            [[1, 3, 5], [2, 4, 6], 4],
            [[-5, -3, -1], [-2, 0, 2], 3],
            [[1, 2], [3, 4, 5], 6],
            [[2, 3], [1], 2],
        ],
    ),
    make(
        pid=1605,
        title="分割数组为连续子序列",
        tags=["数组", "哈希表", "贪心"],
        description="""给定升序排列的整数数组 nums
判断能否把数组分割成一个或多个长度至少为 3 的连续子序列
每个元素必须且只能属于一个子序列
若可以返回 true，否则返回 false""",
        function="isPossible",
        params=[("nums", "int[]")],
        returns="bool",
        solver=is_possible,
        public=[
            [[1, 2, 3, 3, 4, 5]],
            [[1, 2, 3, 3, 4, 4, 5, 5]],
            [[1, 2, 3, 4, 4, 5]],
            [[1, 2, 3]],
        ],
        hidden=[
            [[1, 2]],
            [[1, 2, 3, 5, 6, 7]],
            [[1, 2, 3, 4]],
            [[1, 2, 3, 3, 4, 5, 6, 7]],
            [[1, 1, 2, 2, 3, 3]],
        ],
    ),
    make(
        pid=1606,
        title="回旋镖的数量",
        tags=["数组", "哈希表", "数学"],
        description="""给定平面上 n 个不同的点 points，其中 points[i] = [x_i, y_i]
回旋镖是满足 i、j、k 互不相同且 dist(i, j) == dist(i, k) 的有序三元组 (i, j, k)
返回回旋镖的数量""",
        function="numberOfBoomerangs",
        params=[("points", "int[][]")],
        returns="int",
        solver=number_of_boomerangs,
        public=[
            [[[0, 0], [1, 0], [2, 0]]],
            [[[1, 1]]],
            [[[1, 1], [2, 2], [3, 3]]],
            [[[0, 0], [1, 0], [0, 1]]],
        ],
        hidden=[
            [[[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1]]],
            [[[1, 2], [2, 1], [0, 0]]],
            [[[3, 3], [3, 4], [3, 5], [4, 3]]],
            [[[0, 0], [0, 1], [0, 2], [0, 3]]],
        ],
    ),
    make(
        pid=1607,
        title="比较版本号",
        tags=["字符串", "双指针"],
        description="""给定两个版本号字符串 version1 和 version2
版本号由若干以点分隔的修订号组成，每个修订号可包含前导零
按从左到右的顺序逐个比较修订号，缺少的修订号视为 0
若 version1 小于 version2 返回 -1，相等返回 0，大于返回 1""",
        function="compareVersion",
        params=[("version1", "string"), ("version2", "string")],
        returns="int",
        solver=compare_version,
        public=[
            ["1.01", "1.001"],
            ["1.0", "1.0.0"],
            ["0.1", "1.1"],
            ["1.0.1", "1"],
        ],
        hidden=[
            ["7.5.2.4", "7.5.2.4"],
            ["1.2", "1.10"],
            ["1.0.0.0.1", "1"],
            ["0.0.0", "0"],
            ["10", "9.9"],
        ],
    ),
    make(
        pid=1608,
        title="验证 IP 地址",
        tags=["字符串"],
        description="""给定字符串 queryIP
若它是有效的 IPv4 地址返回 IPv4，若是有效的 IPv6 地址返回 IPv6，否则返回 Neither
IPv4 由四个 0 到 255 的十进制数组成，用点分隔，不能有前导零
IPv6 由八组 1 到 4 位十六进制数组成，用冒号分隔，允许前导零，不区分大小写""",
        function="validIPAddress",
        params=[("queryIP", "string")],
        returns="string",
        solver=valid_ip_address,
        public=[
            ["172.16.254.1"],
            ["2001:0db8:85a3:0000:0000:8a2e:0370:7334"],
            ["256.256.256.256"],
            ["02001:0db8:85a3:0000:0000:8a2e:0370:7334"],
        ],
        hidden=[
            ["1.1.1.1."],
            ["2001:db8:85a3:0:0:8A2E:0370:7334"],
            ["1e1.4.5.6"],
            ["192.168.01.1"],
            ["2001:db8:85a3::8a2e:0370:7334"],
            ["0.0.0.0"],
        ],
    ),
    make(
        pid=1609,
        title="反转字符串中的单词",
        tags=["字符串", "双指针"],
        description="""给定字符串 s，其中包含由空格分隔的若干单词
反转单词的顺序，单词内部字符顺序保持不变
返回结果字符串，单词之间只保留一个空格，且不含首尾空格""",
        function="reverseWords",
        params=[("s", "string")],
        returns="string",
        solver=reverse_words,
        public=[
            ["the sky is blue"],
            ["  hello world  "],
            ["a good   example"],
            ["  Bob    Loves  Alice   "],
        ],
        hidden=[
            ["Alice does not even like bob"],
            ["one"],
            ["   "],
            ["hello"],
            ["  a  b  c  "],
        ],
    ),
    make(
        pid=1610,
        title="最长特殊序列 II",
        tags=["字符串", "排序"],
        description="""给定字符串数组 strs
最长特殊序列定义为某个字符串中最长的、且不是其余任何字符串子序列的子序列
若不存在这样的序列返回 -1，否则返回该最长特殊序列的长度""",
        function="findLUSlength",
        params=[("strs", "string[]")],
        returns="int",
        solver=find_lus_length,
        public=[
            [["aba", "cdc", "eae"]],
            [["aaa", "aaa", "aa"]],
            [["aabbcc", "aabbcc", "cb", "abc"]],
            [["a", "b", "c"]],
        ],
        hidden=[
            [["a"]],
            [["a", "aa", "aaa"]],
            [["abc", "abc", "ab"]],
            [["abcd", "ab", "abc"]],
            [["aaa", "bbb", "ccc"]],
        ],
    ),
    make(
        pid=1611,
        title="通过删除字母匹配到字典里最长单词",
        tags=["字符串", "双指针", "排序"],
        description="""给定字符串 s 和字符串数组 dictionary
找出 dictionary 中最长的字符串，使得它可以通过删除 s 中的一些字符得到
若有多个长度相同的答案，返回字典序最小的那个
若不存在则返回空字符串""",
        function="findLongestWord",
        params=[("s", "string"), ("dictionary", "string[]")],
        returns="string",
        solver=find_longest_word,
        public=[
            ["abpcplea", ["ale", "apple", "monkey", "plea"]],
            ["abpcplea", ["a", "b", "c"]],
            ["bab", ["ba", "ab", "a", "b"]],
            ["aaa", ["aaa", "aa", "a"]],
        ],
        hidden=[
            ["abc", ["def"]],
            ["apple", ["z", "y", "x"]],
            ["ab", ["a", "b", "ab"]],
            ["abcd", ["ab", "abc", "bc", "bcd"]],
            ["xyz", ["x", "y", "z"]],
        ],
    ),
    make(
        pid=1612,
        title="复数乘法",
        tags=["字符串", "数学"],
        description="""给定两个表示复数的字符串 num1 和 num2，格式为 a+bi
其中 a 和 b 是整数，i 表示虚数单位
计算两个复数的乘积，并按 a+bi 的格式返回结果""",
        function="complexNumberMultiply",
        params=[("num1", "string"), ("num2", "string")],
        returns="string",
        solver=complex_number_multiply,
        public=[
            ["1+1i", "1+1i"],
            ["1+-1i", "1+-1i"],
            ["1+0i", "1+0i"],
            ["2+3i", "4+5i"],
        ],
        hidden=[
            ["0+0i", "5+7i"],
            ["-1+-2i", "3+4i"],
            ["3+-2i", "1+1i"],
            ["-5+0i", "-5+0i"],
            ["10+-10i", "10+10i"],
        ],
    ),
    make(
        pid=1613,
        title="文件的最长绝对路径",
        tags=["字符串", "栈"],
        description="""给定字符串 input 表示文件系统的目录结构
字符串中换行符 \\n 分隔不同层级，制表符 \\t 表示目录深度
文件名包含点号，目录名不包含点号
返回文件系统中文件绝对路径的最大长度，若没有文件则返回 0
路径长度不包含文件名前的制表符和换行符""",
        function="lengthLongestPath",
        params=[("input", "string")],
        returns="int",
        solver=length_longest_path,
        public=[
            ["dir\n\tsubdir1\n\tsubdir2\n\t\tfile.ext"],
            [
                "dir\n\tsubdir1\n\t\tfile1.ext\n\t\t\tsubsubdir1\n\tsubdir2\n\t\t\tsubsubdir2\n\t\t\t\tfile2.ext"
            ],
            ["a"],
            ["file1.txt\nfile2.txt"],
        ],
        hidden=[
            ["dir\n\ta"],
            ["dir\n\tfile.txt"],
            ["a\n\tb\n\t\tc.txt"],
            ["dir\n\tsubdir\n\t\tfile.txt"],
            ["a.b.c"],
        ],
    ),
    make(
        pid=1614,
        title="从英文中重建数字",
        tags=["字符串", "哈希表"],
        description="""给定字符串 s，它由若干英文数字单词的字母打乱顺序后拼接而成
英文数字单词为 zero、one、two、three、four、five、six、seven、eight、nine
还原这些数字并按升序拼接成字符串返回""",
        function="originalDigits",
        params=[("s", "string")],
        returns="string",
        solver=original_digits,
        public=[
            ["owoztneoer"],
            ["fviefuro"],
            ["zerozero"],
            ["nine"],
        ],
        hidden=[
            ["zeroonetwothreefourfivesixseveneightnine"],
            ["oneone"],
            ["sixseven"],
            ["fivefourthree"],
            ["eight"],
        ],
    ),
    make(
        pid=1615,
        title="UTF-8 编码验证",
        tags=["数组", "位运算"],
        description="""给定整数数组 data 表示若干字节
判断这些字节是否构成合法的 UTF-8 编码
UTF-8 字符长度可以是 1 到 4 字节，后续字节必须以 10 开头
若编码合法返回 true，否则返回 false""",
        function="validUtf8",
        params=[("data", "int[]")],
        returns="bool",
        solver=valid_utf8,
        public=[
            [[197, 130, 1]],
            [[235, 140, 4]],
            [[10]],
            [[240, 162, 138, 147]],
        ],
        hidden=[
            [[255]],
            [[145]],
            [[248, 130, 130, 130]],
            [[194, 155]],
            [[240, 162, 138]],
            [[0]],
        ],
    ),
    make(
        pid=1616,
        title="第 N 位数字",
        tags=["数学", "二分查找"],
        description="""将正整数按顺序拼接成无限序列 123456789101112...
给定整数 n，返回这个序列中第 n 位数字
n 从 1 开始计数""",
        function="findNthDigit",
        params=[("n", "int")],
        returns="int",
        solver=find_nth_digit,
        public=[
            [3],
            [11],
            [12],
            [100],
        ],
        hidden=[
            [1],
            [9],
            [10],
            [1000],
            [2147483647],
        ],
    ),
]

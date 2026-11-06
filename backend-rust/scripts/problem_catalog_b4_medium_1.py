"""1975-2016：批量第四批中等题（42 道）。"""

from __future__ import annotations

import bisect
import heapq
from collections import Counter, defaultdict
from functools import partial

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="medium")


# ── 数组 / 前缀和 / 滑动窗口 ──────────────────────────────────────


def count_odd_sum_subarrays(nums: list[int]) -> int:
    """统计和为奇数的连续子数组数目（对 10^9 + 7 取模）。"""
    even, odd = 1, 0
    parity = 0
    answer = 0
    for value in nums:
        parity ^= value & 1
        if parity:
            answer += even
            odd += 1
        else:
            answer += odd
            even += 1
    return answer % (10**9 + 7)


def ways_to_split_good_string(s: str) -> int:
    """统计使左右两段不同字符数相等的切分数目。"""
    n = len(s)
    suffix = [0] * (n + 1)
    seen: set[str] = set()
    for index in range(n - 1, -1, -1):
        seen.add(s[index])
        suffix[index] = len(seen)
    left: set[str] = set()
    answer = 0
    for index in range(n - 1):
        left.add(s[index])
        if len(left) == suffix[index + 1]:
            answer += 1
    return answer


def min_operations_to_reduce_x(nums: list[int], x: int) -> int:
    """每次删除最左或最右元素，求把 x 减到 0 的最少删除次数。"""
    total = sum(nums)
    if x > total:
        return -1
    target = total - x
    left = 0
    current = 0
    longest = -1
    for right, value in enumerate(nums):
        current += value
        while current > target and left <= right:
            current -= nums[left]
            left += 1
        if current == target:
            longest = max(longest, right - left + 1)
    return len(nums) - longest if longest >= 0 else -1


def get_averages(nums: list[int], k: int) -> list[int]:
    """返回以每个下标为中心、半径 k 的窗口平均值（不足窗口为 -1）。"""
    n = len(nums)
    answer = [-1] * n
    size = 2 * k + 1
    if size > n:
        return answer
    window = sum(nums[:size])
    answer[k] = window // size
    for index in range(k + 1, n - k):
        window += nums[index + k] - nums[index - k - 1]
        answer[index] = window // size
    return answer


def min_swaps_to_group_ones(nums: list[int]) -> int:
    """环形数组中，把全部 1 聚在一起的最少交换次数。"""
    ones = sum(nums)
    if ones <= 1:
        return 0
    doubled = nums + nums
    zeros = sum(1 for value in doubled[:ones] if value == 0)
    best = zeros
    for start in range(1, len(nums)):
        if doubled[start - 1] == 0:
            zeros -= 1
        if doubled[start + ones - 1] == 0:
            zeros += 1
        best = min(best, zeros)
    return best


def max_frequency(nums: list[int], k: int) -> int:
    """最多执行 k 次单点加一后，某个值的最大出现次数。"""
    nums = sorted(nums)
    left = 0
    window_sum = 0
    best = 0
    for right, value in enumerate(nums):
        window_sum += value
        while value * (right - left + 1) - window_sum > k:
            window_sum -= nums[left]
            left += 1
        best = max(best, right - left + 1)
    return best


def max_consecutive_answers(answerKey: str, k: int) -> int:
    """最多修改 k 个字符后，能得到的最长连续相同字符子串。"""
    counts = {"T": 0, "F": 0}
    left = 0
    best = 0
    for right, character in enumerate(answerKey):
        counts[character] += 1
        while (right - left + 1) - max(counts.values()) > k:
            counts[answerKey[left]] -= 1
            left += 1
        best = max(best, right - left + 1)
    return best


def max_absolute_sum(nums: list[int]) -> int:
    """任意非空连续子数组和的绝对值的最大值。"""
    prefix = 0
    minimum_prefix = 0
    maximum_prefix = 0
    best = 0
    for value in nums:
        prefix += value
        best = max(best, prefix - minimum_prefix, maximum_prefix - prefix)
        minimum_prefix = min(minimum_prefix, prefix)
        maximum_prefix = max(maximum_prefix, prefix)
    return best


def min_operations_to_move_balls(boxes: str) -> list[int]:
    """把每个盒子中的球都移到当前盒子所需的移动步数。"""
    n = len(boxes)
    positions = [index for index, character in enumerate(boxes) if character == "1"]
    total = sum(positions)
    count = len(positions)
    left_count = 0
    left_sum = 0
    answer = []
    for index in range(n):
        right_count = count - left_count
        right_sum = total - left_sum
        cost = (
            index * left_count
            - left_sum
            + right_sum
            - index * right_count
        )
        answer.append(cost)
        if boxes[index] == "1":
            left_count += 1
            left_sum += index
    return answer


def sum_of_absolute_differences(nums: list[int]) -> list[int]:
    """有序数组中对每个元素求与其余元素差的绝对值之和。"""
    n = len(nums)
    total = sum(nums)
    prefix = 0
    answer = []
    for index, value in enumerate(nums):
        suffix = total - prefix - value
        answer.append(
            index * value - prefix + suffix - (n - 1 - index) * value
        )
        prefix += value
    return answer


def ways_to_make_fair(nums: list[int]) -> int:
    """统计删除一个元素后，剩余数组奇数位与偶数位元素和相等的方案数。"""
    right_even = sum(nums[0::2])
    right_odd = sum(nums[1::2])
    left_even = 0
    left_odd = 0
    answer = 0
    for index, value in enumerate(nums):
        if index % 2 == 0:
            right_even -= value
        else:
            right_odd -= value
        if left_even + right_odd == left_odd + right_even:
            answer += 1
        if index % 2 == 0:
            left_even += value
        else:
            left_odd += value
    return answer


def count_hidden_sequences(differences: list[int], lower: int, upper: int) -> int:
    """统计长度比 differences 多 1、且所有元素都在 [lower, upper] 内的数组个数。"""
    prefix = 0
    minimum = 0
    maximum = 0
    for difference in differences:
        prefix += difference
        minimum = min(minimum, prefix)
        maximum = max(maximum, prefix)
    return max(0, (upper - lower) - (maximum - minimum) + 1)


def grid_game(grid: list[list[int]]) -> int:
    """两名机器人收集 2 x n 网格中的数字，返回后手能收集到的最大总数。"""
    columns = len(grid[0])
    top_remaining = sum(grid[0])
    bottom_taken = 0
    answer = float("inf")
    for column in range(columns):
        top_remaining -= grid[0][column]
        second_robot = max(top_remaining, bottom_taken)
        answer = min(answer, second_robot)
        bottom_taken += grid[1][column]
    return int(answer)


def plates_between_candles(s: str, queries: list[list[int]]) -> list[int]:
    """对每个区间，统计两根蜡烛之间的盘子数量。"""
    n = len(s)
    prefix = [0] * (n + 1)
    for index, character in enumerate(s):
        prefix[index + 1] = prefix[index] + (1 if character == "*" else 0)

    next_candle = [n] * n
    following = n
    for index in range(n - 1, -1, -1):
        if s[index] == "|":
            following = index
        next_candle[index] = following

    previous_candle = [-1] * n
    previous = -1
    for index in range(n):
        if s[index] == "|":
            previous = index
        previous_candle[index] = previous

    answer = []
    for left, right in queries:
        first = next_candle[left]
        last = previous_candle[right]
        if first < last:
            answer.append(prefix[last + 1] - prefix[first + 1])
        else:
            answer.append(0)
    return answer


def describe_painting(segments: list[list[int]]) -> list[list[int]]:
    """把多个左闭右开染色区间合并成颜色之和非零的互不重叠区间。"""
    events: dict[int, int] = defaultdict(int)
    for start, end, color in segments:
        events[start] += color
        events[end] -= color
    keys = sorted(events)
    answer = []
    current = 0
    for index in range(len(keys) - 1):
        current += events[keys[index]]
        if current > 0 and keys[index] < keys[index + 1]:
            if answer and answer[-1][1] == keys[index] and answer[-1][2] == current:
                answer[-1][1] = keys[index + 1]
            else:
                answer.append([keys[index], keys[index + 1], current])
    return answer


def subarray_ranges_sum(nums: list[int]) -> int:
    """返回所有连续子数组 (最大值 - 最小值) 之和。"""
    n = len(nums)

    def sum_of_minimums() -> int:
        left = [0] * n
        stack: list[int] = []
        for index, value in enumerate(nums):
            while stack and nums[stack[-1]] >= value:
                stack.pop()
            left[index] = index - stack[-1] if stack else index + 1
            stack.append(index)
        right = [0] * n
        stack.clear()
        for index in range(n - 1, -1, -1):
            while stack and nums[stack[-1]] > nums[index]:
                stack.pop()
            right[index] = stack[-1] - index if stack else n - index
            stack.append(index)
        return sum(nums[index] * left[index] * right[index] for index in range(n))

    def sum_of_maximums() -> int:
        left = [0] * n
        stack: list[int] = []
        for index, value in enumerate(nums):
            while stack and nums[stack[-1]] <= value:
                stack.pop()
            left[index] = index - stack[-1] if stack else index + 1
            stack.append(index)
        right = [0] * n
        stack.clear()
        for index in range(n - 1, -1, -1):
            while stack and nums[stack[-1]] < nums[index]:
                stack.pop()
            right[index] = stack[-1] - index if stack else n - index
            stack.append(index)
        return sum(nums[index] * left[index] * right[index] for index in range(n))

    return sum_of_maximums() - sum_of_minimums()


def ways_to_split_array(nums: list[int]) -> int:
    """统计把数组切成三段、且三段和依次不下降的方案数（取模）。"""
    n = len(nums)
    prefix = [0] * (n + 1)
    for index, value in enumerate(nums):
        prefix[index + 1] = prefix[index] + value
    total = prefix[n]
    answer = 0
    for index in range(n - 2):
        left_sum = prefix[index + 1]
        low = 2 * left_sum
        high = (total + left_sum) // 2
        if low > high:
            continue
        start = bisect.bisect_left(prefix, low, index + 2, n)
        end = bisect.bisect_right(prefix, high, index + 2, n)
        answer += end - start
    return answer % (10**9 + 7)


# ── 贪心 / 二分 / 堆 ──────────────────────────────────────────────


def add_minimum_rungs(rungs: list[int], dist: int) -> int:
    """在台阶之间补充最少台阶，使相邻台阶高度差不超过 dist。"""
    answer = 0
    previous = 0
    for rung in rungs:
        gap = rung - previous
        if gap > 0:
            answer += (gap - 1) // dist
        previous = rung
    return answer


def minimum_size_of_bag(nums: list[int], max_operations: int) -> int:
    """最多拆分 max_operations 次，使袋子中球数的最大值最小。"""
    low, high = 1, max(nums)
    while low < high:
        middle = (low + high) // 2
        operations = sum((value + middle - 1) // middle - 1 for value in nums)
        if operations <= max_operations:
            high = middle
        else:
            low = middle + 1
    return low


def minimized_maximum(n: int, quantities: list[int]) -> int:
    """把商品分给 n 家商店，最小化单店商品数的最大值。"""
    low, high = 1, max(quantities)
    while low < high:
        middle = (low + high) // 2
        needed = sum((quantity + middle - 1) // middle for quantity in quantities)
        if needed <= n:
            high = middle
        else:
            low = middle + 1
    return low


def furthest_building(heights: list[int], bricks: int, ladders: int) -> int:
    """使用砖块和梯子，返回能到达的最远建筑下标。"""
    climb_heap: list[int] = []
    answer = 0
    for index in range(1, len(heights)):
        climb = heights[index] - heights[index - 1]
        if climb > 0:
            heapq.heappush(climb_heap, climb)
            if len(climb_heap) > ladders:
                bricks -= heapq.heappop(climb_heap)
                if bricks < 0:
                    return index - 1
        answer = index
    return answer


def eaten_apples(apples: list[int], days: list[int]) -> int:
    """每天最多吃一个苹果，返回能吃到的苹果总数。"""
    heap: list[tuple[int, int]] = []
    day = 0
    eaten = 0
    while day < len(apples) or heap:
        if day < len(apples) and apples[day] > 0:
            heapq.heappush(heap, (day + days[day], apples[day]))
        while heap and heap[0][0] <= day:
            heapq.heappop(heap)
        if heap:
            expiry, count = heapq.heappop(heap)
            eaten += 1
            if count > 1:
                heapq.heappush(heap, (expiry, count - 1))
        day += 1
    return eaten


def single_threaded_cpu(tasks: list[list[int]]) -> list[int]:
    """单线程 CPU 按规则处理任务，返回任务下标的处理顺序。"""
    n = len(tasks)
    order = sorted(range(n), key=lambda index: (tasks[index][0], index))
    heap: list[tuple[int, int]] = []
    answer = []
    time = 0
    index = 0
    while index < n or heap:
        if not heap:
            time = max(time, tasks[order[index]][0])
        while index < n and tasks[order[index]][0] <= time:
            task = order[index]
            heapq.heappush(heap, (tasks[task][1], task))
            index += 1
        duration, task = heapq.heappop(heap)
        time += duration
        answer.append(task)
    return answer


def max_average_ratio(classes: list[list[int]], extra_students: int) -> float:
    """分配额外学生，使所有班级通过率平均值最大。"""
    heap: list[tuple[float, int, int]] = []
    total = 0.0
    for passed, students in classes:
        total += passed / students
        gain = (passed + 1) / (students + 1) - passed / students
        heapq.heappush(heap, (-gain, passed, students))
    for _ in range(extra_students):
        negative_gain, passed, students = heapq.heappop(heap)
        total += -negative_gain
        passed += 1
        students += 1
        gain = (passed + 1) / (students + 1) - passed / students
        heapq.heappush(heap, (-gain, passed, students))
    return total / len(classes)


# ── 排序 / 哈希 / 字符串 ─────────────────────────────────────────


def kth_largest_integer(nums: list[str], k: int) -> str:
    """返回字符串数组中第 k 大的整数字符串。"""
    return sorted(nums, key=int, reverse=True)[k - 1]


def check_arithmetic_subarrays(
    nums: list[int], l: list[int], r: list[int]
) -> list[bool]:
    """对每个查询区间，判断其元素排序后是否构成等差数列。"""
    answer = []
    for left, right in zip(l, r):
        part = sorted(nums[left : right + 1])
        if len(part) <= 2:
            answer.append(True)
            continue
        difference = part[1] - part[0]
        answer.append(
            all(part[index] - part[index - 1] == difference for index in range(2, len(part)))
        )
    return answer


def number_of_weak_characters(properties: list[list[int]]) -> int:
    """统计攻击力和防御力都严格小于另一个角色的角色数量。"""
    properties = sorted(properties, key=lambda pair: (-pair[0], pair[1]))
    answer = 0
    maximum_defense = 0
    for _, defense in properties:
        if defense < maximum_defense:
            answer += 1
        else:
            maximum_defense = defense
    return answer


def asteroids_destroyed(mass: int, asteroids: list[int]) -> bool:
    """按升序摧毁质量不超过当前质量的小行星，判断能否全部摧毁。"""
    for asteroid in sorted(asteroids):
        if asteroid > mass:
            return False
        mass += asteroid
    return True


def reduction_operations(nums: list[int]) -> int:
    """每次把一个较大元素减小到某个较小元素，返回使数组全相等的最少操作数。"""
    nums = sorted(nums)
    answer = 0
    levels = 0
    for index in range(1, len(nums)):
        if nums[index] != nums[index - 1]:
            levels += 1
        answer += levels
    return answer


def maximum_element_after_decrementing(arr: list[int]) -> int:
    """只减不增并重新排列后，数组最大元素的最大可能值。"""
    current = 0
    for value in sorted(arr):
        current = min(value, current + 1)
    return current


def find_original_array(changed: list[int]) -> list[int]:
    """从双倍数组中还原原数组，按升序返回；无解返回空数组。"""
    if len(changed) % 2:
        return []
    counts = Counter(changed)
    answer: list[int] = []
    for value in sorted(counts):
        if counts[value] == 0:
            continue
        if value == 0:
            if counts[0] % 2:
                return []
            answer.extend([0] * (counts[0] // 2))
            counts[0] = 0
            continue
        doubled = value * 2
        if counts[doubled] < counts[value]:
            return []
        answer.extend([value] * counts[value])
        counts[doubled] -= counts[value]
        counts[value] = 0
    return answer


def largest_merge(word1: str, word2: str) -> str:
    """按字典序最大规则合并两个字符串，返回合并结果。"""
    first = 0
    second = 0
    pieces: list[str] = []
    while first < len(word1) and second < len(word2):
        if word1[first:] > word2[second:]:
            pieces.append(word1[first])
            first += 1
        else:
            pieces.append(word2[second])
            second += 1
    pieces.append(word1[first:])
    pieces.append(word2[second:])
    return "".join(pieces)


def count_homogenous_substrings(s: str) -> int:
    """统计字符全部相同的子字符串数目（取模）。"""
    total = 1
    run = 1
    for index in range(1, len(s)):
        if s[index] == s[index - 1]:
            run += 1
        else:
            run = 1
        total += run
    return total % (10**9 + 7)


def sum_of_beauty(s: str) -> int:
    """返回所有子字符串美丽值（最高频次减最低频次）之和。"""
    n = len(s)
    answer = 0
    for start in range(n):
        counts = [0] * 26
        maximum = 0
        for end in range(start, n):
            index = ord(s[end]) - ord("a")
            counts[index] += 1
            maximum = max(maximum, counts[index])
            minimum = min(count for count in counts if count > 0)
            answer += maximum - minimum
    return answer


def vowels_of_all_substrings(word: str) -> int:
    """返回所有子字符串中元音字母出现次数之和。"""
    n = len(word)
    vowels = set("aeiou")
    answer = 0
    for index, character in enumerate(word):
        if character in vowels:
            answer += (index + 1) * (n - index)
    return answer


def smooth_descent_periods(prices: list[int]) -> int:
    """统计所有平滑下跌阶段（每项比前一项恰小 1）的数目。"""
    total = 1
    run = 1
    for index in range(1, len(prices)):
        if prices[index] == prices[index - 1] - 1:
            run += 1
        else:
            run = 1
        total += run
    return total


def count_good_meals(deliciousness: list[int]) -> int:
    """统计元素和是 2 的幂的不同下标数对数目（取模）。"""
    mod = 10**9 + 7
    powers = [1 << index for index in range(22)]
    counts: Counter[int] = Counter()
    answer = 0
    for value in deliciousness:
        for power in powers:
            answer += counts.get(power - value, 0)
        answer %= mod
        counts[value] += 1
    return answer % mod


def count_nice_pairs(nums: list[int]) -> int:
    """统计满足 nums[i] + rev(nums[j]) == nums[j] + rev(nums[i]) 的数对数目。"""
    counts: Counter[int] = Counter()
    answer = 0
    for value in nums:
        key = value - int(str(value)[::-1])
        answer += counts[key]
        counts[key] += 1
    return answer % (10**9 + 7)


def find_lonely_numbers(nums: list[int]) -> list[int]:
    """按升序返回只出现一次且相邻整数均未出现的元素。"""
    counts = Counter(nums)
    return sorted(
        value
        for value, count in counts.items()
        if count == 1 and value - 1 not in counts and value + 1 not in counts
    )


def word_count_after_adding_letter(
    start_words: list[str], target_words: list[str]
) -> int:
    """统计能由某个起始词添加一个字母重排得到的 target 单词数目。"""
    masks_by_length: dict[int, set[int]] = defaultdict(set)
    for word in start_words:
        mask = 0
        for character in word:
            mask |= 1 << (ord(character) - ord("a"))
        masks_by_length[len(word)].add(mask)
    answer = 0
    for word in target_words:
        candidates = masks_by_length.get(len(word) - 1)
        if not candidates:
            continue
        mask = 0
        for character in word:
            mask |= 1 << (ord(character) - ord("a"))
        for character in word:
            if (mask ^ (1 << (ord(character) - ord("a")))) in candidates:
                answer += 1
                break
    return answer


def remove_occurrences(s: str, part: str) -> str:
    """反复删除字符串中出现的 part，返回最终字符串。"""
    stack: list[str] = []
    size = len(part)
    for character in s:
        stack.append(character)
        if len(stack) >= size and "".join(stack[-size:]) == part:
            del stack[-size:]
    return "".join(stack)


def min_swaps_to_balance(s: str) -> int:
    """返回使方括号字符串平衡的最少交换次数。"""
    available = 0
    unmatched = 0
    for character in s:
        if character == "[":
            available += 1
        elif available > 0:
            available -= 1
        else:
            unmatched += 1
    return (unmatched + 1) // 2


PROBLEMS = [
    make(
        pid=1975,
        title="和为奇数的子数组数目",
        tags=["数组", "前缀和"],
        description="""给定整数数组 nums，返回所有元素和为奇数的连续子数组数目。
由于答案可能很大，请对 10^9 + 7 取模。
子数组必须非空且下标连续。
1 <= nums.length <= 10^5，1 <= nums[i] <= 100。""",
        function="countOddSumSubarrays",
        params=[("nums", "int[]")],
        returns="int",
        solver=count_odd_sum_subarrays,
        public=[[[1, 3, 5]], [[2, 4, 6]], [[1, 2, 3, 4, 5, 6, 7]]],
        hidden=[[[1]], [[2]], [[1, 2]], [[2, 2]], [[1, 2, 3, 4, 5]]],
    ),
    make(
        pid=1976,
        title="字符串的好分割数目",
        tags=["字符串", "哈希表"],
        description="""将字符串 s 在下标 i 与 i + 1 之间切开，得到两个非空部分。
若左半部分和右半部分包含的不同字符数量相等，称为一次好分割。
返回好分割的数目。1 <= s.length <= 1000，s 仅含小写英文字母。""",
        function="waysToSplitGoodString",
        params=[("s", "string")],
        returns="int",
        solver=ways_to_split_good_string,
        public=[["aacaba"], ["abcd"], ["aaaaa"]],
        hidden=[["a"], ["ab"], ["aaaa"], ["aab"], ["abcabc"], ["aaab"]],
    ),
    make(
        pid=1977,
        title="将 x 减到 0 的最小操作数",
        tags=["数组", "滑动窗口", "前缀和"],
        description="""给定正整数数组 nums 和整数 x。每次操作可以删除 nums 最左边或最右边的一个元素，
被删除元素的值从 x 中减去。返回将 x 恰好减到 0 的最少操作次数；做不到返回 -1。
1 <= nums.length <= 10^5，1 <= nums[i] <= 10^4，1 <= x <= 10^9。""",
        function="minOperationsToReduceX",
        params=[("nums", "int[]"), ("x", "int")],
        returns="int",
        solver=min_operations_to_reduce_x,
        public=[[[1, 1, 4, 2, 3], 5], [[5, 6, 7, 8, 9], 4], [[3, 2, 20, 1, 1, 3], 10]],
        hidden=[[[1], 1], [[1], 2], [[1, 2], 1], [[1, 2], 3], [[1, 2, 3], 3]],
    ),
    make(
        pid=1978,
        title="半径为 k 的子数组平均值",
        tags=["数组", "滑动窗口"],
        description="""给定数组 nums 和整数 k。对每个下标 i，若其左右各有至少 k 个元素，
则计算 nums[i - k] 到 nums[i + k]（含两端）共 2k + 1 个元素的平均值并向下取整；
否则该位置答案为 -1。返回结果数组。
1 <= nums.length <= 10^5，0 <= k <= 10^5，0 <= nums[i] <= 10^5。""",
        function="getAverages",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int[]",
        solver=get_averages,
        public=[[[7, 4, 3, 9, 1, 8, 2, 6], 3], [[1, 2, 3, 4], 1], [[5], 0]],
        hidden=[[[1, 2], 0], [[1, 2, 3], 1], [[2, 2, 2, 2, 2], 2], [[10, 20, 30], 1]],
    ),
    make(
        pid=1979,
        title="最少交换次数来组合所有的 1 II",
        tags=["数组", "滑动窗口"],
        description="""nums 是环形二进制数组（首尾相连）。一次交换可以互换任意两个位置的元素。
返回把数组中所有 1 聚集到连续位置所需的最少交换次数。
1 <= nums.length <= 10^5，nums[i] 为 0 或 1。""",
        function="minSwapsToGroupOnes",
        params=[("nums", "int[]")],
        returns="int",
        solver=min_swaps_to_group_ones,
        public=[[[0, 1, 0, 1, 1, 0, 0]], [[0, 1, 1, 1, 0, 0, 1, 1, 0]], [[1, 1, 0, 0, 1]]],
        hidden=[[[1]], [[0]], [[1, 0]], [[1, 0, 1, 0]], [[0, 0, 1, 1]], [[0, 1, 0, 1]]],
    ),
    make(
        pid=1980,
        title="最高频元素的频数",
        tags=["数组", "排序", "滑动窗口"],
        description="""给定数组 nums 和整数 k。每次操作可以把一个元素增加 1，最多操作 k 次。
返回操作后某个元素可能达到的最大出现次数。
1 <= nums.length <= 10^5，1 <= nums[i] <= 10^5，0 <= k <= 10^5。""",
        function="maxFrequency",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=max_frequency,
        public=[[[1, 2, 4], 5], [[1, 4, 8, 13], 5], [[3, 9, 6], 2]],
        hidden=[[[1], 0], [[1, 1, 1], 0], [[1, 2, 3], 1], [[5, 5, 5], 10], [[1, 10, 100], 9]],
    ),
    make(
        pid=1981,
        title="考试的最大困扰度",
        tags=["字符串", "滑动窗口"],
        description="""给定只含 'T' 和 'F' 的字符串 answerKey 与整数 k。
最多可以修改 k 个字符，返回修改后最长的连续相同字符子串长度。
1 <= answerKey.length <= 10^5，0 <= k <= answerKey.length。""",
        function="maxConsecutiveAnswers",
        params=[("answerKey", "string"), ("k", "int")],
        returns="int",
        solver=max_consecutive_answers,
        public=[["TTFF", 2], ["TFFT", 1], ["TTFTTFTT", 1]],
        hidden=[["T", 0], ["F", 1], ["TF", 0], ["TTFF", 0], ["TFTF", 2], ["FFFTTFTT", 2]],
    ),
    make(
        pid=1982,
        title="任意子数组和的绝对值的最大值",
        tags=["数组", "前缀和"],
        description="""给定整数数组 nums，返回所有非空连续子数组和的绝对值的最大值。
1 <= nums.length <= 10^5，-10^4 <= nums[i] <= 10^4。""",
        function="maxAbsoluteSum",
        params=[("nums", "int[]")],
        returns="int",
        solver=max_absolute_sum,
        public=[[[1, -3, 2, 3, -4]], [[2, -5, 1, -4, 3, -2]], [[-1]]],
        hidden=[[[1]], [[-1, -2]], [[1, -1]], [[0]], [[2, -1, 2]], [[-2, 1, -3]]],
    ),
    make(
        pid=1983,
        title="移动所有球到每个盒子所需的最小操作数",
        tags=["数组", "前缀和"],
        description="""字符串 boxes 中 '1' 表示盒子里有一个球，'0' 表示空盒。
把下标 j 的球移到下标 i 需要 |i - j| 步。对每个盒子 i，返回把所有球移到 i 的总步数。
1 <= boxes.length <= 2000，boxes 仅含 '0' 和 '1'。""",
        function="minOperationsToMoveBalls",
        params=[("boxes", "string")],
        returns="int[]",
        solver=min_operations_to_move_balls,
        public=[["110"], ["001011"], ["0"]],
        hidden=[["1"], ["00"], ["101"], ["011"]],
    ),
    make(
        pid=1984,
        title="有序数组中差绝对值之和",
        tags=["数组", "前缀和"],
        description="""给定非递减数组 nums，返回数组 result，其中
result[i] 等于 nums[i] 与数组中其余所有元素差的绝对值之和。
1 <= nums.length <= 10^5，-10^4 <= nums[i] <= 10^4。""",
        function="sumOfAbsoluteDifferences",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=sum_of_absolute_differences,
        public=[[[2, 3, 5]], [[1, 4, 6, 8, 10]], [[1, 2]]],
        hidden=[[[1]], [[0, 0]], [[-1, 1]], [[1, 1, 1]], [[1, 3, 5, 7]]],
    ),
    make(
        pid=1985,
        title="生成平衡数组的方案数",
        tags=["数组", "前缀和"],
        description="""删除 nums 中恰好一个元素后，若剩余数组中下标为偶数的元素之和
等于下标为奇数的元素之和，则称为一次平衡删除。返回平衡删除的方案数。
1 <= nums.length <= 10^5，-10^4 <= nums[i] <= 10^4。""",
        function="waysToMakeFair",
        params=[("nums", "int[]")],
        returns="int",
        solver=ways_to_make_fair,
        public=[[[2, 1, 6, 4]], [[1, 1, 1]], [[1, 2, 3]]],
        hidden=[[[1]], [[1, 2]], [[2, 2]], [[2, 1, 2]], [[1, 1, 1, 1]]],
    ),
    make(
        pid=1986,
        title="统计隐藏数组数目",
        tags=["数组", "前缀和"],
        description="""给定长度为 n - 1 的数组 differences 以及区间 [lower, upper]。
隐藏数组 hidden 长度为 n，且 hidden[i + 1] - hidden[i] = differences[i]。
统计所有元素都落在 [lower, upper] 内的隐藏数组数目。
1 <= differences.length <= 10^5，-10^4 <= differences[i] <= 10^4，
-10^4 <= lower <= upper <= 10^4。""",
        function="countHiddenSequences",
        params=[("differences", "int[]"), ("lower", "int"), ("upper", "int")],
        returns="int",
        solver=count_hidden_sequences,
        public=[[[1, -3, 4], 1, 6], [[3, -4, 5, 1, -2], -4, 5], [[4, -7, 2], 3, 6]],
        hidden=[[[1], 0, 0], [[0], 0, 0], [[1], 1, 2], [[-1, 1], -1, 1], [[0, 0, 0], -2, 2]],
    ),
    make(
        pid=1987,
        title="网格游戏",
        tags=["数组", "前缀和", "矩阵"],
        description="""给定 2 x n 的网格 grid，两名机器人从 (0, 0) 出发前往 (1, n - 1)。
机器人只能向右或向下移动。第一个机器人先走，会收集路径上的数字；
随后第二个机器人从剩余数字中收集。第一个机器人希望第二个机器人得分尽可能小，
第二个机器人希望自己得分尽可能大。返回第二个机器人能获得的最大得分。
1 <= n <= 5 * 10^4，0 <= grid[i][j] <= 10^5。""",
        function="gridGame",
        params=[("grid", "int[][]")],
        returns="long",
        solver=grid_game,
        public=[
            [[[2, 5, 4], [1, 5, 1]]],
            [[[3, 3, 1], [8, 5, 2]]],
            [[[1, 3, 1, 15], [1, 3, 3, 1]]],
        ],
        hidden=[
            [[[1], [1]]],
            [[[10, 10], [10, 10]]],
            [[[1, 2], [3, 4]]],
            [[[5, 1, 2], [3, 4, 6]]],
        ],
    ),
    make(
        pid=1988,
        title="蜡烛之间的盘子",
        tags=["字符串", "前缀和"],
        description="""给定字符串 s，'|' 表示蜡烛，'*' 表示盘子。再给定查询数组 queries，
每个查询为 [left, right]。对每个查询，统计位于区间内两根蜡烛之间的盘子数量；
若区间内不足两根蜡烛则答案为 0。按查询顺序返回结果。
1 <= s.length <= 10^5，1 <= queries.length <= 10^5，
0 <= left <= right < s.length。""",
        function="platesBetweenCandles",
        params=[("s", "string"), ("queries", "int[][]")],
        returns="int[]",
        solver=plates_between_candles,
        public=[
            ["**|**|***|", [[2, 5], [5, 9]]],
            [
                "***|**|*****|**||**|*",
                [[1, 17], [4, 5], [14, 17], [5, 11], [15, 16]],
            ],
            ["||", [[0, 1]]],
        ],
        hidden=[
            ["|", [[0, 0]]],
            ["*", [[0, 0]]],
            ["|*|", [[0, 2]]],
            ["*|*", [[0, 2]]],
            ["**|**", [[0, 4]]],
            ["|**|", [[0, 3]]],
        ],
    ),
    make(
        pid=1989,
        title="描述绘画结果",
        tags=["数组", "前缀和", "哈希表"],
        description="""给定若干染色区间 segments，每个区间为 [start, end, color]，
表示把左闭右开区间 [start, end) 上的每个点颜色值加上 color。
多个区间重叠时颜色值相加。返回颜色值非零的互不重叠左闭右开区间，
相邻且颜色相同的区间合并为一个区间，每个结果区间为 [start, end, color]，按 start 升序排列。
1 <= segments.length <= 1000，1 <= start < end <= 10^5，1 <= color <= 10^6。""",
        function="describePainting",
        params=[("segments", "int[][]")],
        returns="int[][]",
        solver=describe_painting,
        public=[
            [[[1, 4, 5], [4, 7, 7], [1, 7, 9]]],
            [[[1, 4, 5], [1, 4, 7], [1, 4, 6]]],
            [[[1, 2, 3]]],
        ],
        hidden=[
            [[[1, 3, 1], [2, 4, 2]]],
            [[[1, 5, 10]]],
            [[[2, 2, 5]]],
            [[[1, 10, 1], [5, 15, 2]]],
        ],
    ),
    make(
        pid=1990,
        title="子数组范围和",
        tags=["数组", "单调栈"],
        description="""给定整数数组 nums，返回所有非空连续子数组中
（最大值减最小值）之和。
1 <= nums.length <= 10^5，-10^4 <= nums[i] <= 10^4。""",
        function="subarrayRangesSum",
        params=[("nums", "int[]")],
        returns="long",
        solver=subarray_ranges_sum,
        public=[[[1, 2, 3]], [[1, 3, 3]], [[4, -2, -3, 4, 1]]],
        hidden=[[[1]], [[2, 2]], [[1, 1, 1]], [[-1, 2]], [[3, 1, 2]], [[5, 4, 3, 2, 1]]],
    ),
    make(
        pid=1991,
        title="将数组分成三个子数组的方案数",
        tags=["数组", "前缀和", "二分查找"],
        description="""将非负整数数组 nums 切成三个非空连续部分，切点分别为 i 和 j
（即 [0, i]、[i + 1, j]、[j + 1, n - 1]）。
若三部分元素和依次不下降（第一段 <= 第二段 <= 第三段），则称为一种好方案。
返回好方案数目，对 10^9 + 7 取模。
3 <= nums.length <= 10^5，0 <= nums[i] <= 10^4。""",
        function="waysToSplitArray",
        params=[("nums", "int[]")],
        returns="int",
        solver=ways_to_split_array,
        public=[[[1, 1, 1]], [[1, 2, 2, 2, 5, 0]], [[3, 2, 1]]],
        hidden=[[[1, 2]], [[1, 1]], [[1, 1, 1, 1]], [[0, 0, 0]], [[1, 2, 3, 4]]],
    ),
    make(
        pid=1992,
        title="新增的最少台阶数",
        tags=["数组", "贪心"],
        description="""给定严格递增的台阶高度数组 rungs（不含地面 0）和整数 dist。
你从高度 0 出发，每次最多向上跨 dist。可以在任意高度新增台阶，
返回到达最后一个台阶所需新增台阶的最少数量。
1 <= rungs.length <= 10^5，rungs 严格递增且 rungs[i] <= 10^5，1 <= dist <= 10^5。""",
        function="addMinimumRungs",
        params=[("rungs", "int[]"), ("dist", "int")],
        returns="int",
        solver=add_minimum_rungs,
        public=[[[1, 3, 5, 10], 2], [[3, 6, 8, 10], 3], [[3, 4, 6, 7], 2]],
        hidden=[[[1], 1], [[5], 2], [[1, 2], 1], [[5, 10], 5], [[1, 5, 9], 2]],
    ),
    make(
        pid=1993,
        title="袋子里最少数目的球",
        tags=["数组", "二分查找"],
        description="""给定整数数组 nums，nums[i] 表示第 i 个袋子中的球数。
每次操作可以选择一个袋子，把它分成两个非空袋子。
最多操作 maxOperations 次，返回单个袋子中球数最大值的最小可能值。
1 <= nums.length <= 10^5，0 <= maxOperations <= 10^5，1 <= nums[i] <= 10^9。""",
        function="minimumSizeOfBag",
        params=[("nums", "int[]"), ("maxOperations", "int")],
        returns="int",
        solver=minimum_size_of_bag,
        public=[[[9], 2], [[2, 4, 8, 2], 4], [[7, 17], 2]],
        hidden=[[[1], 0], [[1, 2], 0], [[1, 100], 0], [[100], 10], [[5, 5, 5], 3]],
    ),
    make(
        pid=1994,
        title="分配给商店的最多商品的最小值",
        tags=["数组", "二分查找"],
        description="""有 n 家商店和若干种商品，quantities[i] 表示第 i 种商品的数量。
同一种商品可以分给多家商店，但每家商店只能收到一种商品。
返回分配给单家商店商品数的最大值的最小可能值。
1 <= n <= 10^5，1 <= quantities.length <= 10^5，
1 <= quantities[i] <= 10^5。""",
        function="minimizedMaximum",
        params=[("n", "int"), ("quantities", "int[]")],
        returns="int",
        solver=minimized_maximum,
        public=[[6, [11, 6]], [7, [15, 10, 10]], [1, [100000]]],
        hidden=[[2, [1, 1]], [3, [2, 2, 2]], [4, [1, 1, 1, 1]], [5, [7, 7]]],
    ),
    make(
        pid=1995,
        title="可以到达的最远建筑",
        tags=["数组", "贪心", "堆"],
        description="""给定建筑高度数组 heights，你有 bricks 块砖和 ladders 个梯子。
从建筑 0 出发向右移动，遇到更高的下一栋建筑时，可以用一架梯子，
或用高度差的砖块数量向上爬。梯子必须整架使用，砖块可以按需消耗。
返回能到达的最远建筑下标（从 0 开始）。
1 <= heights.length <= 10^5，0 <= bricks <= 10^9，0 <= ladders <= heights.length，
1 <= heights[i] <= 10^5。""",
        function="furthestBuilding",
        params=[("heights", "int[]"), ("bricks", "int"), ("ladders", "int")],
        returns="int",
        solver=furthest_building,
        public=[
            [[4, 2, 7, 6, 9, 14, 12], 5, 1],
            [[4, 12, 2, 7, 3, 18, 20, 3, 19], 10, 2],
            [[14, 3, 19, 3], 17, 0],
        ],
        hidden=[
            [[1], 0, 0],
            [[1, 2], 0, 0],
            [[1, 5], 3, 0],
            [[1, 5], 4, 0],
            [[1, 5], 0, 1],
            [[1, 2, 3], 1, 1],
        ],
    ),
    make(
        pid=1996,
        title="吃苹果的最大数目",
        tags=["数组", "贪心", "堆"],
        description="""第 i 天苹果树会结 apples[i] 个苹果，这些苹果会在第 i + days[i] 天腐烂
（即只能在前 days[i] 天内食用，包括第 i 天）。每天最多吃一个苹果。
若某天 apples[i] == 0，则该天不结果。返回最多能吃到的苹果总数。
1 <= apples.length <= 10^4，0 <= apples[i] <= 10^4，
0 <= days[i] <= 10^4。""",
        function="eatenApples",
        params=[("apples", "int[]"), ("days", "int[]")],
        returns="int",
        solver=eaten_apples,
        public=[
            [[1, 2, 3, 5, 2], [3, 2, 1, 4, 2]],
            [[3, 0, 0, 0, 0, 2], [3, 0, 0, 0, 0, 2]],
            [[1], [1]],
        ],
        hidden=[
            [[1], [0]],
            [[0], [1]],
            [[2, 1], [1, 1]],
            [[1, 0, 1], [1, 1, 1]],
            [[5, 0, 0, 0, 0, 0], [5, 0, 0, 0, 0, 0]],
        ],
    ),
    make(
        pid=1997,
        title="单线程 CPU",
        tags=["数组", "堆", "排序"],
        description="""给定任务数组 tasks，tasks[i] = [enqueueTime, processingTime]。
单线程 CPU 的规则：若 CPU 空闲，选择已到达且处理时间最短的任务（相同则下标最小）；
否则等待到下一个任务到达。返回任务下标的处理顺序。
1 <= tasks.length <= 10^5，1 <= enqueueTime <= 10^9，1 <= processingTime <= 10^9。""",
        function="singleThreadedCpu",
        params=[("tasks", "int[][]")],
        returns="int[]",
        solver=single_threaded_cpu,
        public=[
            [[[1, 2], [2, 4], [3, 2], [4, 1]]],
            [[[7, 10], [7, 12], [1, 5], [4, 8]]],
            [[[1, 1]]],
        ],
        hidden=[
            [[[1, 1], [2, 1]]],
            [[[2, 1], [1, 1]]],
            [[[1, 2], [1, 1]]],
            [[[3, 1], [1, 2], [2, 1]]],
        ],
    ),
    make(
        pid=1998,
        title="最大平均通过率",
        tags=["数组", "贪心", "堆"],
        description="""给定 classes 数组，classes[i] = [passed_i, total_i] 表示第 i 个班级的
通过人数和总人数。你还有 extraStudents 名成绩必过的学生，需要全部分配到班级中。
返回分配后所有班级通过率的平均值的最大可能值。
误差在 10^-5 以内视为正确。
1 <= classes.length <= 10^5，1 <= passed_i <= total_i <= 10^5，
0 <= extraStudents <= 10^5。""",
        function="maxAverageRatio",
        params=[("classes", "int[][]"), ("extraStudents", "int")],
        returns="double",
        solver=max_average_ratio,
        public=[
            [[[1, 2], [3, 5], [2, 2]], 2],
            [[[2, 4], [3, 9], [4, 5]], 1],
            [[[1, 1]], 0],
        ],
        hidden=[
            [[[2, 3]], 0],
            [[[1, 2]], 3],
            [[[3, 4], [1, 2]], 2],
            [[[1, 3], [2, 3], [3, 3]], 4],
        ],
        compare={"mode": "double"},
    ),
    make(
        pid=1999,
        title="找出数组中的第 K 大整数",
        tags=["数组", "排序", "字符串"],
        description="""给定字符串数组 nums，每个字符串表示一个不含前导零的非负整数
（"0" 本身除外）。返回按数值大小降序排列后的第 k 大整数字符串。
1 <= k <= nums.length <= 10^4，1 <= nums[i].length <= 100。""",
        function="kthLargestInteger",
        params=[("nums", "string[]"), ("k", "int")],
        returns="string",
        solver=kth_largest_integer,
        public=[
            [["3", "6", "7", "10"], 4],
            [["2", "21", "12", "1"], 3],
            [["0", "0"], 2],
        ],
        hidden=[
            [["10"], 1],
            [["1", "2", "3"], 1],
            [["100", "20", "3"], 2],
            [["9", "8", "7"], 3],
            [["123", "123"], 1],
        ],
    ),
    make(
        pid=2000,
        title="等差子数组",
        tags=["数组", "排序"],
        description="""给定数组 nums 和等长查询数组 l、r。对每个查询 i，
取出 nums[l[i]] 到 nums[r[i]]（含两端）的子数组，判断其排序后是否为等差数列。
返回布尔数组，顺序与查询一致。
1 <= nums.length <= 500，-10^5 <= nums[i] <= 10^5，
1 <= l.length <= 500，0 <= l[i] <= r[i] < nums.length。""",
        function="checkArithmeticSubarrays",
        params=[("nums", "int[]"), ("l", "int[]"), ("r", "int[]")],
        returns="bool[]",
        solver=check_arithmetic_subarrays,
        public=[
            [[4, 6, 5, 9, 3, 7], [0, 0, 2], [2, 3, 5]],
            [
                [-12, -9, -3, -12, -6, 15, 20, -25, -20, -15, -10],
                [0, 1, 6, 4, 8, 7],
                [4, 4, 9, 7, 9, 10],
            ],
            [[1, 2, 3, 4], [0, 2], [1, 3]],
        ],
        hidden=[
            [[1], [0], [0]],
            [[3, 1, 2], [0], [2]],
            [[1, 3, 5], [0], [2]],
            [[1, 3, 6], [0], [2]],
            [[1, 1, 1], [0], [2]],
            [[2, 4, 8, 16], [0, 1], [1, 3]],
        ],
    ),
    make(
        pid=2001,
        title="游戏中弱角色的数量",
        tags=["数组", "排序"],
        description="""给定二维数组 properties，properties[i] = [attack_i, defense_i]。
若存在另一个角色，其攻击力和防御力都严格大于当前角色，则当前角色是弱角色。
返回弱角色的数量。1 <= properties.length <= 10^5，
1 <= attack_i, defense_i <= 10^5。""",
        function="numberOfWeakCharacters",
        params=[("properties", "int[][]")],
        returns="int",
        solver=number_of_weak_characters,
        public=[
            [[[5, 5], [6, 3], [3, 6]]],
            [[[2, 2], [3, 3]]],
            [[[1, 5], [10, 4], [4, 3]]],
        ],
        hidden=[
            [[[1, 1]]],
            [[[1, 1], [2, 2], [3, 3]]],
            [[[10, 1], [1, 10]]],
            [[[10, 10], [5, 5], [6, 6]]],
        ],
    ),
    make(
        pid=2002,
        title="摧毁小行星",
        tags=["数组", "贪心", "排序"],
        description="""给定初始质量 mass 和小行星质量数组 asteroids。
你可以按任意顺序摧毁小行星：只有质量不超过当前质量的小行星才能被摧毁，
摧毁后当前质量增加该小行星的质量。判断能否摧毁全部小行星。
1 <= mass <= 10^5，1 <= asteroids.length <= 10^5，1 <= asteroids[i] <= 10^5。""",
        function="asteroidsDestroyed",
        params=[("mass", "int"), ("asteroids", "int[]")],
        returns="bool",
        solver=asteroids_destroyed,
        public=[
            [10, [3, 9, 19, 5, 21]],
            [5, [4, 9, 23, 4]],
            [1, [1]],
        ],
        hidden=[
            [1, [2]],
            [1, [1, 1, 1]],
            [10, [1, 2, 3, 4]],
            [5, [3, 3, 3]],
            [5, [10, 1]],
        ],
    ),
    make(
        pid=2003,
        title="使数组元素相等的减少操作次数",
        tags=["数组", "排序"],
        description="""给定整数数组 nums。每次操作选择一个元素，把它减小到数组中存在的某个更小元素。
返回使数组中所有元素都相等所需的最少操作次数。
1 <= nums.length <= 5 * 10^4，1 <= nums[i] <= 5 * 10^4。""",
        function="reductionOperations",
        params=[("nums", "int[]")],
        returns="int",
        solver=reduction_operations,
        public=[[[5, 1, 3]], [[1, 1, 1]], [[1, 1, 2, 2, 3]]],
        hidden=[[[1]], [[1, 2]], [[2, 2, 2]], [[5, 4, 3, 2, 1]], [[1, 1, 1, 2]], [[1, 2, 2, 3, 3, 3]]],
    ),
    make(
        pid=2004,
        title="减小和重新排列数组后的最大元素",
        tags=["数组", "排序", "贪心"],
        description="""给定正整数数组 arr。你可以任意重新排列数组，并把某些元素减小到任意正整数。
操作后要求 arr[0] == 1，且相邻元素之差的绝对值不超过 1。
返回操作后 arr 中最大元素的最大可能值。
1 <= arr.length <= 10^5，1 <= arr[i] <= 10^9。""",
        function="maximumElementAfterDecrementing",
        params=[("arr", "int[]")],
        returns="int",
        solver=maximum_element_after_decrementing,
        public=[[[2, 2, 1, 2, 1]], [[100, 1, 1000]], [[1, 2, 3, 4, 5]]],
        hidden=[[[1]], [[5]], [[1, 1]], [[10, 10, 10]], [[5, 5, 5]]],
    ),
    make(
        pid=2005,
        title="从双倍数组中还原原数组",
        tags=["数组", "排序", "哈希表"],
        description="""给定数组 changed，它由原数组 original 的每个元素和其两倍值混合后打乱得到。
返回 original；若 changed 无法由某个 original 得到，返回空数组。
答案按升序排列。changed 中的元素均为非负整数。
1 <= changed.length <= 10^5，0 <= changed[i] <= 10^5。""",
        function="findOriginalArray",
        params=[("changed", "int[]")],
        returns="int[]",
        solver=find_original_array,
        public=[
            [[1, 3, 4, 2, 6, 8]],
            [[6, 3, 0, 1]],
            [[1]],
        ],
        hidden=[
            [[0, 0]],
            [[2, 1, 2, 1]],
            [[4, 2, 8, 4]],
            [[3, 2, 1]],
            [[0, 0, 0]],
            [[1, 2, 4, 8]],
        ],
    ),
    make(
        pid=2006,
        title="构造字典序最大的合并字符串",
        tags=["字符串", "贪心", "双指针"],
        description="""给定两个字符串 word1 和 word2。每次从任一字符串的开头取一个字符
追加到结果末尾，直到两个字符串都取完。返回能得到的字典序最大的字符串。
1 <= word1.length, word2.length <= 3000，两个字符串均只含小写英文字母。""",
        function="largestMerge",
        params=[("word1", "string"), ("word2", "string")],
        returns="string",
        solver=largest_merge,
        public=[
            ["cabaa", "bcaaa"],
            ["abcabc", "abdcaba"],
            ["a", "b"],
        ],
        hidden=[
            ["a", "a"],
            ["abc", "abc"],
            ["z", "z"],
            ["ab", "ba"],
            ["aaa", "aa"],
        ],
    ),
    make(
        pid=2007,
        title="统计同质子字符串的数目",
        tags=["字符串", "数学"],
        description="""若一个字符串的所有字符都相同，则称其为同质字符串。
给定字符串 s，返回 s 的同质非空子字符串数目，对 10^9 + 7 取模。
1 <= s.length <= 10^5，s 仅含小写英文字母。""",
        function="countHomogenousSubstrings",
        params=[("s", "string")],
        returns="int",
        solver=count_homogenous_substrings,
        public=[["abbcccaa"], ["xy"], ["zzzzz"]],
        hidden=[["a"], ["ab"], ["aaa"], ["aab"], ["ababa"], ["aaaaabbbbb"]],
    ),
    make(
        pid=2008,
        title="所有子字符串美丽值之和",
        tags=["字符串", "哈希表", "计数"],
        description="""一个字符串的美丽值定义为出现次数最多字符的频次减去出现次数最少字符的频次
（只统计出现过的字符）。给定字符串 s，返回其所有非空子字符串的美丽值之和。
1 <= s.length <= 500，s 仅含小写英文字母。""",
        function="sumOfBeauty",
        params=[("s", "string")],
        returns="int",
        solver=sum_of_beauty,
        public=[["aabcb"], ["aabcbaa"], ["abc"]],
        hidden=[["a"], ["aa"], ["aba"], ["abca"], ["abcba"], ["aabbcc"]],
    ),
    make(
        pid=2009,
        title="所有子字符串中的元音",
        tags=["字符串", "数学"],
        description="""给定字符串 word，返回其所有非空子字符串中元音字母出现次数之和。
元音字母为 a、e、i、o、u。1 <= word.length <= 10^5，
word 仅含小写英文字母。""",
        function="vowelsOfAllSubstrings",
        params=[("word", "string")],
        returns="long",
        solver=vowels_of_all_substrings,
        public=[["aba"], ["abc"], ["ltcd"]],
        hidden=[["a"], ["aa"], ["bcdfg"], ["aeiou"], ["banana"]],
    ),
    make(
        pid=2010,
        title="股票平滑下跌阶段的数目",
        tags=["数组", "动态规划"],
        description="""若一个连续子数组满足每一项恰好比前一项小 1，则称为平滑下跌阶段。
给定股票价格数组 prices，返回平滑下跌阶段（包括长度为 1 的阶段）的数目。
1 <= prices.length <= 10^5，1 <= prices[i] <= 10^5。""",
        function="smoothDescentPeriods",
        params=[("prices", "int[]")],
        returns="long",
        solver=smooth_descent_periods,
        public=[[[3, 2, 1, 4]], [[8, 6, 7, 7]], [[1]]],
        hidden=[[[5, 4, 3, 2, 1]], [[1, 2, 3]], [[2, 1, 2, 1]], [[5]]],
    ),
    make(
        pid=2011,
        title="大餐计数",
        tags=["数组", "哈希表"],
        description="""给定整数数组 deliciousness，统计满足 0 <= i < j < n 且
deliciousness[i] + deliciousness[j] 是 2 的幂的不同下标数对数目。
返回结果对 10^9 + 7 取模。1 <= deliciousness.length <= 10^5，
0 <= deliciousness[i] <= 2^20。""",
        function="countGoodMeals",
        params=[("deliciousness", "int[]")],
        returns="int",
        solver=count_good_meals,
        public=[
            [[1, 3, 5, 7, 9]],
            [[1, 1, 1, 3, 3, 3, 7]],
            [[0, 0, 0]],
        ],
        hidden=[
            [[1, 1]],
            [[1]],
            [[2, 2]],
            [[1, 1, 1]],
            [[0, 1]],
            [[1048576, 1048576]],
        ],
    ),
    make(
        pid=2012,
        title="统计一个数组中好对子的数目",
        tags=["数组", "哈希表", "数学"],
        description="""定义 rev(x) 为整数 x 十进制表示反转后得到的整数（忽略前导零）。
若 nums[i] + rev(nums[j]) == nums[j] + rev(nums[i])，则称 (i, j) 为好对子，
其中 0 <= i < j < nums.length。返回好对子数目，对 10^9 + 7 取模。
1 <= nums.length <= 10^5，0 <= nums[i] <= 10^9。""",
        function="countNicePairs",
        params=[("nums", "int[]")],
        returns="int",
        solver=count_nice_pairs,
        public=[
            [[42, 11, 1, 97]],
            [[13, 10, 35, 24, 76]],
            [[1]],
        ],
        hidden=[
            [[0]],
            [[1, 1]],
            [[10, 10]],
            [[12, 21]],
            [[123, 321]],
            [[1, 2]],
        ],
    ),
    make(
        pid=2013,
        title="找出数组中的所有孤独数字",
        tags=["数组", "哈希表", "排序"],
        description="""若数组中的一个数字只出现一次，且它相邻的整数（x - 1 和 x + 1）都没有出现，
则称该数字是孤独的。给定整数数组 nums，按升序返回所有孤独数字。
1 <= nums.length <= 10^5，0 <= nums[i] <= 10^6。""",
        function="findLonelyNumbers",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=find_lonely_numbers,
        public=[
            [[10, 6, 5, 8]],
            [[1, 3, 5, 3]],
            [[7, 7, 7]],
        ],
        hidden=[
            [[1]],
            [[1, 2]],
            [[5, 4, 3]],
            [[0, 0, 1]],
            [[1, 1, 3]],
        ],
    ),
    make(
        pid=2014,
        title="统计追加字母可以得到的目标字符串数目",
        tags=["字符串", "哈希表", "位运算"],
        description="""给定起始单词数组 startWords 和目标单词数组 targetWords。
若在某个起始单词中恰好添加一个字母，再重新排列所有字母，能够得到目标单词，
则称该目标单词可得到。返回可得到的目标单词数目。
每个单词只含小写英文字母，且同一单词内字母不重复。
1 <= startWords.length, targetWords.length <= 5 * 10^4，
1 <= 单词长度 <= 26。""",
        function="wordCountAfterAddingLetter",
        params=[("startWords", "string[]"), ("targetWords", "string[]")],
        returns="int",
        solver=word_count_after_adding_letter,
        public=[
            [["ant", "act", "tack"], ["tack", "act", "acti"]],
            [["ab", "a"], ["abc", "abcd"]],
            [["a"], ["a"]],
        ],
        hidden=[
            [["a"], ["ab"]],
            [["abc"], ["abd", "abcd"]],
            [["abc"], ["abc"]],
            [["ab", "ac"], ["abc"]],
            [["a", "b"], ["ab", "ba"]],
            [["ab"], ["abc", "abd"]],
        ],
    ),
    make(
        pid=2015,
        title="删除一个字符串中所有出现的给定子字符串",
        tags=["字符串", "栈", "模拟"],
        description="""给定字符串 s 和子字符串 part。只要 part 在 s 中出现，就删除其中一次出现，
重复该过程直到 part 不再出现。返回最终字符串。
1 <= s.length <= 1000，1 <= part.length <= 1000，两个字符串均只含小写英文字母。""",
        function="removeOccurrences",
        params=[("s", "string"), ("part", "string")],
        returns="string",
        solver=remove_occurrences,
        public=[
            ["daabcbaabcbc", "abc"],
            ["axxxxyyyyb", "xy"],
            ["a", "a"],
        ],
        hidden=[
            ["abc", "abc"],
            ["abccba", "cc"],
            ["aaaa", "aa"],
            ["xyz", "z"],
            ["ababab", "ab"],
        ],
    ),
    make(
        pid=2016,
        title="使字符串平衡的最小交换次数",
        tags=["字符串", "贪心", "栈"],
        description="""给定一个长度为偶数、'[' 和 ']' 数量相等的方括号字符串 s。
一次交换可以互换任意两个位置上的字符。返回使 s 成为平衡字符串的最少交换次数。
平衡字符串指每个 '[' 都能与右侧某个 ']' 配对，且所有括号正确嵌套。
1 <= s.length <= 10^5。""",
        function="minSwapsToBalance",
        params=[("s", "string")],
        returns="int",
        solver=min_swaps_to_balance,
        public=[["]["], ["]]][[["], ["[]"]],
        hidden=[["[[]]"], ["[][]"], ["[]]["], ["[[[]]]"]],
    ),
]

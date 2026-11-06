"""1775-1816：批量第三批中等题（42 道）。"""

from __future__ import annotations

import bisect
from collections import Counter, defaultdict
from functools import partial

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="medium")


# ── 数组 / 前缀和 / 单调栈 ─────────────────────────────────────────


def sum_subarray_mins(arr: list[int]) -> int:
    mod = 10**9 + 7
    n = len(arr)
    previous = [-1] * n
    following = [n] * n
    stack: list[int] = []
    for index, value in enumerate(arr):
        while stack and arr[stack[-1]] > value:
            stack.pop()
        previous[index] = stack[-1] if stack else -1
        stack.append(index)
    stack.clear()
    for index in range(n - 1, -1, -1):
        while stack and arr[stack[-1]] >= arr[index]:
            stack.pop()
        following[index] = stack[-1] if stack else n
        stack.append(index)
    total = 0
    for index in range(n):
        total += arr[index] * (index - previous[index]) * (following[index] - index)
    return total % mod


def smallest_range_ii(nums: list[int], k: int) -> int:
    ordered = sorted(nums)
    answer = ordered[-1] - ordered[0]
    for split in range(len(ordered) - 1):
        low = min(ordered[0] + k, ordered[split + 1] - k)
        high = max(ordered[split] + k, ordered[-1] - k)
        answer = min(answer, high - low)
    return answer


def partition_disjoint(nums: list[int]) -> int:
    n = len(nums)
    suffix_min = [0] * n
    suffix_min[-1] = nums[-1]
    for index in range(n - 2, -1, -1):
        suffix_min[index] = min(nums[index], suffix_min[index + 1])
    left_max = nums[0]
    for index in range(n - 1):
        left_max = max(left_max, nums[index])
        if left_max <= suffix_min[index + 1]:
            return index + 1
    return n - 1


def three_sum_multi(nums: list[int], target: int) -> int:
    mod = 10**9 + 7
    ordered = sorted(nums)
    n = len(ordered)
    answer = 0
    for first in range(n - 2):
        left, right = first + 1, n - 1
        while left < right:
            total = ordered[first] + ordered[left] + ordered[right]
            if total < target:
                left += 1
            elif total > target:
                right -= 1
            else:
                if ordered[left] == ordered[right]:
                    count = right - left + 1
                    answer += count * (count - 1) // 2
                    break
                left_count = 1
                while left + 1 < right and ordered[left + 1] == ordered[left]:
                    left += 1
                    left_count += 1
                right_count = 1
                while right - 1 > left and ordered[right - 1] == ordered[right]:
                    right -= 1
                    right_count += 1
                answer += left_count * right_count
                left += 1
                right -= 1
    return answer % mod


def num_subarrays_with_sum(nums: list[int], goal: int) -> int:
    counts: Counter[int] = Counter({0: 1})
    prefix = 0
    answer = 0
    for value in nums:
        prefix += value
        answer += counts[prefix - goal]
        counts[prefix] += 1
    return answer


def min_area_rect(points: list[list[int]]) -> int:
    existing = {(x, y) for x, y in points}
    answer = float("inf")
    n = len(points)
    for first in range(n):
        x1, y1 = points[first]
        for second in range(first + 1, n):
            x2, y2 = points[second]
            if x1 == x2 or y1 == y2:
                continue
            if (x1, y2) in existing and (x2, y1) in existing:
                answer = min(answer, abs(x1 - x2) * abs(y1 - y2))
    return 0 if answer == float("inf") else int(answer)


def min_increment_for_unique(nums: list[int]) -> int:
    ordered = sorted(nums)
    moves = 0
    for index in range(1, len(ordered)):
        if ordered[index] <= ordered[index - 1]:
            moves += ordered[index - 1] + 1 - ordered[index]
            ordered[index] = ordered[index - 1] + 1
    return moves


def can_reorder_doubled(arr: list[int]) -> bool:
    counts = Counter(arr)
    if counts[0] % 2 != 0:
        return False
    for value in sorted(counts, key=abs):
        if value == 0 or counts[value] == 0:
            continue
        if counts[2 * value] < counts[value]:
            return False
        counts[2 * value] -= counts[value]
    return True


def max_width_ramp(nums: list[int]) -> int:
    stack: list[int] = []
    for index, value in enumerate(nums):
        if not stack or nums[stack[-1]] > value:
            stack.append(index)
    best = 0
    for index in range(len(nums) - 1, -1, -1):
        while stack and nums[stack[-1]] <= nums[index]:
            best = max(best, index - stack.pop())
    return best


def prev_perm_opt1(arr: list[int]) -> list[int]:
    result = list(arr)
    n = len(result)
    pivot = -1
    for index in range(n - 2, -1, -1):
        if result[index] > result[index + 1]:
            pivot = index
            break
    if pivot == -1:
        return result
    best_value = -1
    best_index = -1
    for index in range(pivot + 1, n):
        if result[index] < result[pivot] and result[index] > best_value:
            best_value = result[index]
            best_index = index
    if best_index != -1:
        result[pivot], result[best_index] = result[best_index], result[pivot]
    return result


def k_closest_points(points: list[list[int]], k: int) -> list[list[int]]:
    ordered = sorted(points, key=lambda point: (point[0] ** 2 + point[1] ** 2, point[0], point[1]))
    return [list(point) for point in ordered[:k]]


def subarrays_div_by_k(nums: list[int], k: int) -> int:
    counts: Counter[int] = Counter({0: 1})
    prefix = 0
    answer = 0
    for value in nums:
        prefix += value
        remainder = prefix % k
        answer += counts[remainder]
        counts[remainder] += 1
    return answer


def broken_calc(start_value: int, target: int) -> int:
    steps = 0
    while target > start_value:
        if target % 2 == 0:
            target //= 2
        else:
            target += 1
        steps += 1
    return steps + start_value - target


def min_k_bit_flips(nums: list[int], k: int) -> int:
    n = len(nums)
    toggles = [0] * (n + 1)
    flips = 0
    current = 0
    for index in range(n):
        current ^= toggles[index]
        if (nums[index] ^ current) == 0:
            if index + k > n:
                return -1
            current ^= 1
            toggles[index + k] ^= 1
            flips += 1
    return flips


def ship_within_days(weights: list[int], days: int) -> int:
    low, high = max(weights), sum(weights)
    while low < high:
        middle = (low + high) // 2
        needed = 1
        current = 0
        for weight in weights:
            if current + weight > middle:
                needed += 1
                current = weight
            else:
                current += weight
        if needed <= days:
            high = middle
        else:
            low = middle + 1
    return low


def max_score_sightseeing_pair(values: list[int]) -> int:
    best = 0
    best_left = values[0]
    for index in range(1, len(values)):
        best = max(best, best_left + values[index] - index)
        best_left = max(best_left, values[index] + index)
    return best


def camel_match(queries: list[str], pattern: str) -> list[int]:
    def matches(query: str) -> int:
        position = 0
        for character in query:
            if position < len(pattern) and character == pattern[position]:
                position += 1
            elif character.isupper():
                return 0
        return 1 if position == len(pattern) else 0

    return [matches(query) for query in queries]


def max_sum_two_no_overlap(nums: list[int], first_len: int, second_len: int) -> int:
    n = len(nums)
    prefix = [0] * (n + 1)
    for index, value in enumerate(nums):
        prefix[index + 1] = prefix[index] + value

    def best(one: int, two: int) -> int:
        best_one = 0
        answer = 0
        for index in range(one, n - two + 1):
            best_one = max(best_one, prefix[index] - prefix[index - one])
            answer = max(answer, best_one + prefix[index + two] - prefix[index])
        return answer

    return max(best(first_len, second_len), best(second_len, first_len))


def max_satisfied(customers: list[int], grumpy: list[int], minutes: int) -> int:
    base = sum(customer for customer, mood in zip(customers, grumpy) if mood == 0)
    extra = 0
    current = 0
    for index in range(len(customers)):
        if grumpy[index]:
            current += customers[index]
        if index >= minutes and grumpy[index - minutes]:
            current -= customers[index - minutes]
        extra = max(extra, current)
    return base + extra


def rank_teams(votes: list[str]) -> str:
    team_count = len(votes[0])
    scores: dict[str, list[int]] = defaultdict(lambda: [0] * team_count)
    for vote in votes:
        for position, team in enumerate(vote):
            scores[team][position] += 1
    order = sorted(scores, key=lambda team: tuple(-count for count in scores[team]) + (team,))
    return "".join(order)


def smallest_subsequence(s: str) -> str:
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


def largest_vals_from_labels(
    values: list[int], labels: list[int], num_wanted: int, use_limit: int
) -> int:
    items = sorted(zip(values, labels), reverse=True)
    used: Counter[int] = Counter()
    total = 0
    chosen = 0
    for value, label in items:
        if chosen == num_wanted:
            break
        if used[label] < use_limit:
            used[label] += 1
            total += value
            chosen += 1
    return total


def car_pooling(trips: list[list[int]], capacity: int) -> bool:
    difference = [0] * 1001
    for passengers, start, end in trips:
        difference[start] += passengers
        difference[end] -= passengers
    current = 0
    for delta in difference:
        current += delta
        if current > capacity:
            return False
    return True


def corp_flight_bookings(bookings: list[list[int]], n: int) -> list[int]:
    difference = [0] * (n + 2)
    for first, last, seats in bookings:
        difference[first] += seats
        difference[last + 1] -= seats
    answer = []
    current = 0
    for index in range(1, n + 1):
        current += difference[index]
        answer.append(current)
    return answer


def longest_wpi(hours: list[int]) -> int:
    first_index = {0: -1}
    prefix = 0
    best = 0
    for index, hour in enumerate(hours):
        prefix += 1 if hour > 8 else -1
        if prefix > 0:
            best = index + 1
        elif prefix - 1 in first_index:
            best = max(best, index - first_index[prefix - 1])
        if prefix not in first_index:
            first_index[prefix] = index
    return best


def max_rep_opt1(text: str) -> int:
    total = Counter(text)
    best = 0
    index = 0
    n = len(text)
    while index < n:
        end = index
        while end < n and text[end] == text[index]:
            end += 1
        length = end - index
        best = max(best, min(length + 1, total[text[index]]))
        if end < n and end + 1 < n and text[end + 1] == text[index]:
            right = end + 1
            while right < n and text[right] == text[index]:
                right += 1
            best = max(best, min(length + right - end, total[text[index]]))
        index = end
    return best


def can_make_pali_queries(s: str, queries: list[list[int]]) -> list[int]:
    prefix = [[0] * 26]
    for character in s:
        current = prefix[-1].copy()
        current[ord(character) - ord("a")] ^= 1
        prefix.append(current)
    answer = []
    for left, right, k in queries:
        odd = 0
        for code in range(26):
            odd += prefix[right + 1][code] ^ prefix[left][code]
        answer.append(1 if odd // 2 <= k else 0)
    return answer


def reverse_parentheses(s: str) -> str:
    stack: list[str] = []
    for character in s:
        if character == ")":
            buffer = []
            while stack[-1] != "(":
                buffer.append(stack.pop())
            stack.pop()
            stack.extend(buffer)
        else:
            stack.append(character)
    return "".join(stack)


def equal_substring(s: str, t: str, max_cost: int) -> int:
    costs = [abs(ord(first) - ord(second)) for first, second in zip(s, t)]
    left = 0
    total = 0
    best = 0
    for right, cost in enumerate(costs):
        total += cost
        while total > max_cost:
            total -= costs[left]
            left += 1
        best = max(best, right - left + 1)
    return best


def remove_duplicates_ii(s: str, k: int) -> str:
    stack: list[list] = []
    for character in s:
        if stack and stack[-1][0] == character:
            stack[-1][1] += 1
        else:
            stack.append([character, 1])
        if stack and stack[-1][1] == k:
            stack.pop()
    return "".join(character * count for character, count in stack)


def remove_subfolders(folder: list[str]) -> list[str]:
    existing = set(folder)
    answer = []
    for path in sorted(existing):
        parts = path.split("/")[1:]
        current = ""
        is_subfolder = False
        for part in parts[:-1]:
            current = part if not current else current + "/" + part
            if "/" + current in existing:
                is_subfolder = True
                break
        if not is_subfolder:
            answer.append(path)
    return answer


def balanced_string(s: str) -> int:
    n = len(s)
    target = n // 4
    counts = Counter(s)
    need = {character: max(0, counts[character] - target) for character in "QWER"}
    if all(value == 0 for value in need.values()):
        return 0
    window: Counter[str] = Counter()
    left = 0
    best = n

    def valid() -> bool:
        return all(window[character] >= need[character] for character in "QWER")

    for right, character in enumerate(s):
        window[character] += 1
        while valid():
            best = min(best, right - left + 1)
            window[s[left]] -= 1
            left += 1
    return best


def number_of_subarrays(nums: list[int], k: int) -> int:
    counts: Counter[int] = Counter({0: 1})
    prefix = 0
    answer = 0
    for value in nums:
        prefix += value & 1
        answer += counts[prefix - k]
        counts[prefix] += 1
    return answer


def min_remove_to_make_valid(s: str) -> str:
    characters = list(s)
    stack: list[int] = []
    for index, character in enumerate(characters):
        if character == "(":
            stack.append(index)
        elif character == ")":
            if stack:
                stack.pop()
            else:
                characters[index] = ""
    for index in stack:
        characters[index] = ""
    return "".join(characters)


def min_steps(s: str, t: str) -> int:
    source = Counter(s)
    goal = Counter(t)
    return sum(max(0, goal[character] - source[character]) for character in goal)


def smallest_divisor(nums: list[int], threshold: int) -> int:
    def total(divisor: int) -> int:
        return sum((value + divisor - 1) // divisor for value in nums)

    low, high = 1, max(nums)
    while low < high:
        middle = (low + high) // 2
        if total(middle) <= threshold:
            high = middle
        else:
            low = middle + 1
    return low


def max_side_length(mat: list[list[int]], threshold: int) -> int:
    rows, columns = len(mat), len(mat[0])
    prefix = [[0] * (columns + 1) for _ in range(rows + 1)]
    for row in range(rows):
        for column in range(columns):
            prefix[row + 1][column + 1] = (
                mat[row][column]
                + prefix[row][column + 1]
                + prefix[row + 1][column]
                - prefix[row][column]
            )

    def possible(size: int) -> bool:
        for row in range(size, rows + 1):
            for column in range(size, columns + 1):
                total = (
                    prefix[row][column]
                    - prefix[row - size][column]
                    - prefix[row][column - size]
                    + prefix[row - size][column - size]
                )
                if total <= threshold:
                    return True
        return False

    low, high = 0, min(rows, columns)
    while low < high:
        middle = (low + high + 1) // 2
        if possible(middle):
            low = middle
        else:
            high = middle - 1
    return low


def is_possible_divide(nums: list[int], k: int) -> bool:
    if len(nums) % k != 0:
        return False
    counts = Counter(nums)
    for value in sorted(counts):
        amount = counts[value]
        if amount == 0:
            continue
        for offset in range(k):
            needed = value + offset
            if counts[needed] < amount:
                return False
            counts[needed] -= amount
    return True


def find_best_value(arr: list[int], target: int) -> int:
    def total(value: int) -> int:
        return sum(min(number, value) for number in arr)

    low, high = 0, max(arr)
    while low < high:
        middle = (low + high) // 2
        if total(middle) < target:
            low = middle + 1
        else:
            high = middle
    best_value = 0
    best_diff = float("inf")
    for candidate in sorted({max(0, low - 1), low}):
        diff = abs(total(candidate) - target)
        if diff < best_diff:
            best_diff = diff
            best_value = candidate
    return best_value


def matrix_block_sum(mat: list[list[int]], k: int) -> list[list[int]]:
    rows, columns = len(mat), len(mat[0])
    prefix = [[0] * (columns + 1) for _ in range(rows + 1)]
    for row in range(rows):
        for column in range(columns):
            prefix[row + 1][column + 1] = (
                mat[row][column]
                + prefix[row][column + 1]
                + prefix[row + 1][column]
                - prefix[row][column]
            )
    answer = [[0] * columns for _ in range(rows)]
    for row in range(rows):
        for column in range(columns):
            top = max(0, row - k)
            left = max(0, column - k)
            bottom = min(rows - 1, row + k)
            right = min(columns - 1, column + k)
            answer[row][column] = (
                prefix[bottom + 1][right + 1]
                - prefix[top][right + 1]
                - prefix[bottom + 1][left]
                + prefix[top][left]
            )
    return answer


def break_palindrome(palindrome: str) -> str:
    if len(palindrome) <= 1:
        return ""
    characters = list(palindrome)
    n = len(characters)
    for index in range(n // 2):
        if characters[index] != "a":
            characters[index] = "a"
            return "".join(characters)
    characters[-1] = "b"
    return "".join(characters)


def num_subseq(nums: list[int], target: int) -> int:
    mod = 10**9 + 7
    ordered = sorted(nums)
    n = len(ordered)
    answer = 0
    for index in range(n):
        right = bisect.bisect_right(ordered, target - ordered[index]) - 1
        if right >= index:
            answer = (answer + pow(2, right - index, mod)) % mod
    return answer


PROBLEMS = [
    make(
        pid=1775,
        title="子数组的最小值之和",
        tags=["数组", "单调栈"],
        description="""给定整数数组 arr
返回 arr 的所有非空连续子数组的最小值之和
结果对 10^9 + 7 取模""",
        function="sumSubarrayMins",
        params=[("arr", "int[]")],
        returns="int",
        solver=sum_subarray_mins,
        public=[
            [[3, 1, 2, 4]],
            [[11, 81, 94, 43, 3]],
            [[1]],
        ],
        hidden=[
            [[1, 2, 3, 4]],
            [[5, 4, 3, 2, 1]],
            [[2, 2, 2]],
            [[1, 2, 3]],
            [[3, 3, 3, 1, 2, 4]],
        ],
    ),
    make(
        pid=1776,
        title="最小差值 II",
        tags=["数组", "排序"],
        description="""给定整数数组 nums 和整数 k
对每个元素必须执行一次操作：加上 k 或者减去 k
返回操作后数组最大值与最小值之差的最小可能值""",
        function="smallestRangeII",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=smallest_range_ii,
        public=[
            [[1], 0],
            [[0, 10], 2],
            [[1, 3, 6], 3],
        ],
        hidden=[
            [[2, 7, 2], 1],
            [[1, 1, 1], 5],
            [[7, 8, 8, 5], 4],
            [[0, 0, 0], 10],
            [[1, 5, 9, 13], 3],
        ],
    ),
    make(
        pid=1777,
        title="分割数组",
        tags=["数组"],
        description="""给定整数数组 nums
把它分成左右两个非空连续部分
要求左部分的每个元素都不大于右部分的每个元素
返回满足条件时左部分的最小长度
题目保证至少存在一种分割方案""",
        function="partitionDisjoint",
        params=[("nums", "int[]")],
        returns="int",
        solver=partition_disjoint,
        public=[
            [[5, 0, 3, 8, 6]],
            [[1, 1, 1, 0, 6, 12]],
            [[1, 2, 3, 4]],
        ],
        hidden=[
            [[1, 2, 3, 4, 5]],
            [[1, 1, 1, 1]],
            [[2, 2, 1, 1]],
            [[0, 0, 0, 1]],
            [[1, 3, 2, 4]],
        ],
    ),
    make(
        pid=1778,
        title="三数之和的多种可能",
        tags=["数组", "排序", "双指针"],
        description="""给定整数数组 nums 和目标值 target
统计满足 i < j < k 且 nums[i] + nums[j] + nums[k] == target 的三元组数量
下标三元组按位置区分，数值相同的不同位置算作不同三元组
结果对 10^9 + 7 取模""",
        function="threeSumMulti",
        params=[("nums", "int[]"), ("target", "int")],
        returns="int",
        solver=three_sum_multi,
        public=[
            [[1, 1, 2, 2, 3, 3, 4, 4, 5, 5], 8],
            [[1, 1, 2, 2, 2, 2], 5],
            [[2, 1, 3], 6],
        ],
        hidden=[
            [[2, 2, 2], 6],
            [[0, 0, 0], 0],
            [[1, 2, 3, 4, 5], 9],
            [[0, 1, 2], 3],
            [[1, 1, 1, 2, 2], 5],
        ],
    ),
    make(
        pid=1779,
        title="和相同的二元子数组",
        tags=["数组", "前缀和", "哈希表"],
        description="""给定只包含 0 和 1 的整数数组 nums 与整数 goal
返回元素和恰好等于 goal 的非空连续子数组数量""",
        function="numSubarraysWithSum",
        params=[("nums", "int[]"), ("goal", "int")],
        returns="int",
        solver=num_subarrays_with_sum,
        public=[
            [[1, 0, 1, 0, 1], 2],
            [[0, 0, 0, 0, 0], 0],
            [[1], 1],
        ],
        hidden=[
            [[1, 0, 1], 1],
            [[0], 0],
            [[1, 1, 1], 2],
            [[0, 0, 0], 0],
            [[1, 0, 0, 1], 2],
        ],
    ),
    make(
        pid=1780,
        title="最小面积矩形",
        tags=["数组", "哈希表", "几何"],
        description="""给定二维整数数组 points，points[i] = [xi, yi] 表示平面上的一个点
所有点互不相同
找出由这些点构成、边与坐标轴平行的矩形的最小面积
矩形的四个顶点都必须是给定点
若不存在这样的矩形则返回 0""",
        function="minAreaRect",
        params=[("points", "int[][]")],
        returns="int",
        solver=min_area_rect,
        public=[
            [[[1, 1], [1, 3], [3, 1], [3, 3], [2, 2]]],
            [[[1, 1], [1, 3], [3, 1], [3, 3], [4, 1], [4, 3]]],
            [[[1, 1], [1, 3], [3, 1], [3, 3]]],
        ],
        hidden=[
            [[[1, 1], [1, 2], [3, 1], [3, 2]]],
            [[[0, 0], [1, 0], [1, 1], [0, 1], [2, 2]]],
            [[[1, 1], [2, 2], [3, 3]]],
            [[[0, 0], [0, 1], [1, 0], [1, 1], [2, 1], [2, 0]]],
            [[[1, 2], [2, 3], [3, 1], [1, 3], [2, 1], [3, 2]]],
        ],
    ),
    make(
        pid=1781,
        title="使数组唯一的最小增量",
        tags=["数组", "排序", "贪心"],
        description="""给定整数数组 nums
每次操作可以选择一个元素并将其加 1
返回使数组中所有元素互不相同所需的最少操作次数""",
        function="minIncrementForUnique",
        params=[("nums", "int[]")],
        returns="int",
        solver=min_increment_for_unique,
        public=[
            [[1, 2, 2]],
            [[3, 2, 1, 2, 1, 7]],
            [[0, 2, 2]],
        ],
        hidden=[
            [[1, 1, 1]],
            [[0, 0, 0]],
            [[1, 2, 3]],
            [[7, 7, 7, 7]],
            [[2, 2, 2, 2, 2]],
        ],
    ),
    make(
        pid=1782,
        title="二倍数对数组",
        tags=["数组", "哈希表", "排序"],
        description="""给定整数数组 arr
判断能否重新排列 arr，使得对于每个偶数下标 i，都有 arr[i + 1] == 2 * arr[i]
可以按任意顺序配对，返回是否可行""",
        function="canReorderDoubled",
        params=[("arr", "int[]")],
        returns="bool",
        solver=can_reorder_doubled,
        public=[
            [[3, 1, 3, 6]],
            [[2, 1, 2, 6]],
            [[4, -2, 2, -4]],
        ],
        hidden=[
            [[1, 2, 4, 8]],
            [[0, 0]],
            [[0]],
            [[1, 2, 4]],
            [[-1, -2, 2, 4]],
            [[1, 2, 3, 4]],
        ],
    ),
    make(
        pid=1783,
        title="最大宽度坡",
        tags=["数组", "单调栈"],
        description="""给定整数数组 nums
坡是一对下标 (i, j)，满足 i < j 且 nums[i] <= nums[j]
坡的宽度为 j - i
返回所有坡中的最大宽度，若不存在坡则返回 0""",
        function="maxWidthRamp",
        params=[("nums", "int[]")],
        returns="int",
        solver=max_width_ramp,
        public=[
            [[6, 0, 8, 2, 1, 5]],
            [[9, 8, 1, 0, 1, 9, 4, 0, 4, 1]],
            [[1, 0]],
        ],
        hidden=[
            [[1, 2, 3, 4]],
            [[4, 3, 2, 1]],
            [[0, 1]],
            [[2, 2, 2]],
            [[0, 1, 0]],
        ],
    ),
    make(
        pid=1784,
        title="交换一次的先前排列",
        tags=["数组", "贪心"],
        description="""给定整数数组 arr
最多选择一对下标 i < j 并交换 arr[i] 与 arr[j]
返回能得到的、字典序严格小于 arr 的字典序最大的数组
若无法得到更小的排列，则返回原数组""",
        function="prevPermOpt1",
        params=[("arr", "int[]")],
        returns="int[]",
        solver=prev_perm_opt1,
        public=[
            [[3, 2, 1]],
            [[1, 1, 1]],
            [[1, 9, 4, 6, 7]],
        ],
        hidden=[
            [[3, 1, 1, 3]],
            [[1, 2, 3]],
            [[5, 4, 3, 2, 1]],
            [[2, 2, 1]],
            [[1, 2]],
        ],
    ),
    make(
        pid=1785,
        title="最接近原点的 K 个点",
        tags=["数组", "排序", "堆"],
        description="""给定二维整数数组 points 和整数 k，points[i] = [xi, yi]
返回距离原点最近的 k 个点
距离按欧几里得距离的平方比较
结果按距离升序返回，距离相同时按横坐标升序，再按纵坐标升序""",
        function="kClosestPoints",
        params=[("points", "int[][]"), ("k", "int")],
        returns="int[][]",
        solver=k_closest_points,
        public=[
            [[[1, 3], [-2, 2]], 1],
            [[[3, 3], [5, -1], [-2, 4]], 2],
            [[[0, 0], [1, 1], [2, 2]], 3],
        ],
        hidden=[
            [[[1, 0], [-1, 0]], 1],
            [[[0, 1], [1, 0]], 2],
            [[[10, 10]], 1],
            [[[2, 2], [-2, -2], [2, -2], [-2, 2]], 2],
            [[[-1, -1], [1, 1], [0, 0]], 2],
        ],
    ),
    make(
        pid=1786,
        title="和可被 K 整除的子数组",
        tags=["数组", "前缀和", "哈希表"],
        description="""给定整数数组 nums 和正整数 k
返回元素和能被 k 整除的非空连续子数组数量""",
        function="subarraysDivByK",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=subarrays_div_by_k,
        public=[
            [[4, 5, 0, -2, -3, 1], 5],
            [[5], 9],
            [[0, 0], 1],
        ],
        hidden=[
            [[-1, 2, 9], 2],
            [[1, 2, 3], 2],
            [[2, 2, 2], 2],
            [[-5, 3, 2], 5],
            [[1, -1, 0], 3],
        ],
    ),
    make(
        pid=1787,
        title="坏了的计算器",
        tags=["数学", "贪心"],
        description="""给定两个整数 startValue 和 target
从 startValue 出发，每次可以执行以下两种操作之一：
1 将当前值减 1
2 将当前值乘以 2
返回把 startValue 变成 target 的最少操作次数""",
        function="brokenCalc",
        params=[("startValue", "int"), ("target", "int")],
        returns="int",
        solver=broken_calc,
        public=[
            [2, 3],
            [5, 8],
            [3, 10],
        ],
        hidden=[
            [1, 1],
            [10, 3],
            [1, 1000000000],
            [5, 2],
            [4, 12],
        ],
    ),
    make(
        pid=1788,
        title="K 连续位的最小翻转次数",
        tags=["数组", "滑动窗口", "位运算"],
        description="""给定只包含 0 和 1 的整数数组 nums 与整数 k
每次可以翻转长度为 k 的连续子数组，0 变 1、1 变 0
返回使整个数组都变成 1 的最少翻转次数
若无法做到则返回 -1""",
        function="minKBitFlips",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=min_k_bit_flips,
        public=[
            [[0, 1, 0], 1],
            [[1, 1, 0], 2],
            [[0, 0, 0, 1, 0, 1, 1, 0], 3],
        ],
        hidden=[
            [[0, 0, 0], 3],
            [[1, 1, 1], 1],
            [[1, 0, 1], 2],
            [[0, 1, 0, 1], 2],
            [[0, 0, 0, 0], 2],
        ],
    ),
    make(
        pid=1789,
        title="在 D 天内送达包裹的能力",
        tags=["数组", "二分查找"],
        description="""给定整数数组 weights 表示包裹重量，以及整数 days
包裹必须按给定顺序用船运送，每天可以装载若干包裹
每天装载的包裹总重量不能超过船的载重能力
返回在 days 天内运完所有包裹所需的最小载重能力""",
        function="shipWithinDays",
        params=[("weights", "int[]"), ("days", "int")],
        returns="int",
        solver=ship_within_days,
        public=[
            [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 5],
            [[3, 2, 2, 4, 1, 4], 3],
            [[1, 2, 3, 1, 1], 4],
        ],
        hidden=[
            [[1], 1],
            [[10, 10], 2],
            [[5, 4, 3, 2, 1], 1],
            [[1, 2, 3, 4, 5], 5],
            [[2, 2, 2, 2, 2, 2], 3],
        ],
    ),
    make(
        pid=1790,
        title="最佳观光组合",
        tags=["数组"],
        description="""给定正整数数组 values
选择一对下标 i < j，得分为 values[i] + values[j] + i - j
返回所有下标对中的最高得分""",
        function="maxScoreSightseeingPair",
        params=[("values", "int[]")],
        returns="int",
        solver=max_score_sightseeing_pair,
        public=[
            [[8, 1, 5, 2, 6]],
            [[1, 2]],
            [[1, 1]],
        ],
        hidden=[
            [[2, 7, 5, 4, 3]],
            [[3, 7, 2, 3]],
            [[1, 1, 1]],
            [[10, 1, 1, 1, 10]],
            [[5, 6, 7]],
        ],
    ),
    make(
        pid=1791,
        title="驼峰式匹配",
        tags=["字符串", "双指针"],
        description="""给定字符串数组 queries 和模式串 pattern
对每个 query，判断能否从 query 中删除若干小写字母后得到 pattern
删除时不能删除任何大写字母
返回整数数组，第 i 项为 1 表示 queries[i] 匹配，为 0 表示不匹配""",
        function="camelMatch",
        params=[("queries", "string[]"), ("pattern", "string")],
        returns="int[]",
        solver=camel_match,
        public=[
            [
                ["FooBar", "FooBarTest", "FootBall", "FrameBuffer", "ForceFeedBack"],
                "FB",
            ],
            [
                ["FooBar", "FooBarTest", "FootBall", "FrameBuffer", "ForceFeedBack"],
                "FoBa",
            ],
            [
                ["FooBar", "FooBarTest", "FootBall", "FrameBuffer", "ForceFeedBack"],
                "FoBaT",
            ],
        ],
        hidden=[
            [["FooBar"], "FB"],
            [["FooBar", "FooBarTest"], "FoBaT"],
            [["CompetitiveProgramming"], "CP"],
            [["abCde"], "ace"],
            [["AB"], "A"],
        ],
    ),
    make(
        pid=1792,
        title="两个非重叠子数组的最大和",
        tags=["数组", "前缀和", "滑动窗口"],
        description="""给定整数数组 nums 和两个整数 firstLen、secondLen
找出两个不重叠的连续子数组
一个长度为 firstLen，另一个长度为 secondLen，顺序不限
返回这两个子数组元素和的最大值""",
        function="maxSumTwoNoOverlap",
        params=[("nums", "int[]"), ("firstLen", "int"), ("secondLen", "int")],
        returns="int",
        solver=max_sum_two_no_overlap,
        public=[
            [[0, 6, 5, 2, 2, 5, 1, 9, 4], 1, 2],
            [[3, 8, 1, 3, 2, 1, 8, 9, 0], 3, 2],
            [[2, 1, 5, 6, 0, 9, 5, 0, 3, 8], 4, 3],
        ],
        hidden=[
            [[1, 2, 3, 4, 5], 1, 1],
            [[4, 5, 6, 7, 8], 2, 2],
            [[1, 2, 3], 1, 1],
            [[8, 1, 5, 2, 6], 2, 1],
            [[1, 1, 1, 1, 1], 2, 2],
        ],
    ),
    make(
        pid=1793,
        title="爱生气的书店老板",
        tags=["数组", "滑动窗口"],
        description="""给定整数数组 customers 和 grumpy，以及整数 minutes
customers[i] 表示第 i 分钟进入的顾客数量
grumpy[i] 为 1 表示老板第 i 分钟生气，此时顾客不会满意，为 0 时顾客满意
老板可以连续 minutes 分钟不生气，且只能使用一次这个技巧
返回最多能让多少顾客满意""",
        function="maxSatisfied",
        params=[("customers", "int[]"), ("grumpy", "int[]"), ("minutes", "int")],
        returns="int",
        solver=max_satisfied,
        public=[
            [[1, 0, 1, 2, 1, 1, 7, 5], [0, 1, 0, 1, 0, 1, 0, 1], 3],
            [[1], [0], 1],
            [[1], [1], 1],
        ],
        hidden=[
            [[2, 3, 4, 5], [0, 0, 0, 0], 2],
            [[2, 3, 4, 5], [1, 1, 1, 1], 2],
            [[5, 0, 5], [0, 1, 0], 1],
            [[1, 2, 3, 4, 5], [1, 0, 1, 0, 1], 2],
            [[3, 3, 3], [0, 1, 0], 2],
        ],
    ),
    make(
        pid=1794,
        title="通过投票对团队排名",
        tags=["数组", "字符串", "排序", "哈希表"],
        description="""给定字符串数组 votes，每个字符串表示一张选票上的团队排名
第 i 个字符表示该选票上的第 i 名
排名规则：先比较第一名票数，票数多者在前
若相同则比较第二名票数，依此类推
若所有名次票数都相同，则按团队字母升序排列
返回按此规则排好序的团队字符串""",
        function="rankTeams",
        params=[("votes", "string[]")],
        returns="string",
        solver=rank_teams,
        public=[
            [["ABC", "ACB", "ABC", "ACB", "ACB"]],
            [["WXYZ", "XYZW"]],
            [["ZMNAGUEDSJYLBOPHRQICWFXTVK"]],
        ],
        hidden=[
            [["ABC"]],
            [["ABC", "ABC"]],
            [["BCA", "CAB", "CBA"]],
            [["AB", "BA"]],
            [["A", "A", "A"]],
        ],
    ),
    make(
        pid=1795,
        title="不同字符的最小子序列",
        tags=["字符串", "单调栈", "贪心"],
        description="""给定字符串 s
返回 s 的一个子序列，要求 s 中出现的每个不同字符都恰好出现一次
在满足条件的所有子序列中，返回字典序最小的一个""",
        function="smallestSubsequence",
        params=[("s", "string")],
        returns="string",
        solver=smallest_subsequence,
        public=[
            ["bcabc"],
            ["cbacdcbc"],
            ["abcd"],
        ],
        hidden=[
            ["ecbacba"],
            ["cba"],
            ["abab"],
            ["bcbcbc"],
            ["acdb"],
        ],
    ),
    make(
        pid=1796,
        title="受标签影响的最大值",
        tags=["数组", "排序", "哈希表", "贪心"],
        description="""给定整数数组 values、labels，以及整数 numWanted 和 useLimit
从 0 到 n-1 中选择若干下标，选出的元素个数不超过 numWanted
同一个标签最多只能选择 useLimit 个元素
返回所选元素值之和的最大值""",
        function="largestValsFromLabels",
        params=[
            ("values", "int[]"),
            ("labels", "int[]"),
            ("numWanted", "int"),
            ("useLimit", "int"),
        ],
        returns="int",
        solver=largest_vals_from_labels,
        public=[
            [[5, 4, 3, 2, 1], [1, 1, 2, 2, 3], 3, 1],
            [[5, 4, 3, 2, 1], [1, 3, 3, 3, 2], 3, 2],
            [[9, 8, 8, 7, 6], [0, 0, 0, 1, 1], 3, 1],
        ],
        hidden=[
            [[1, 2, 3], [0, 0, 0], 2, 1],
            [[1, 2, 3], [0, 1, 2], 3, 1],
            [[5, 5, 5], [0, 0, 0], 2, 2],
            [[10, 9, 8, 7], [0, 1, 0, 1], 4, 1],
            [[1], [0], 1, 1],
        ],
    ),
    make(
        pid=1797,
        title="拼车",
        tags=["数组", "差分数组", "排序"],
        description="""给定二维整数数组 trips 和整数 capacity
trips[i] = [numPassengers, start, end] 表示第 i 次行程有 numPassengers 人
这些乘客从 start 上车，在 end 下车
判断车辆容量为 capacity 时能否完成所有行程
乘客只能在起点上车、在终点下车，且任意时刻车上人数不能超过容量""",
        function="carPooling",
        params=[("trips", "int[][]"), ("capacity", "int")],
        returns="bool",
        solver=car_pooling,
        public=[
            [[[2, 1, 5], [3, 3, 7]], 4],
            [[[2, 1, 5], [3, 3, 7]], 5],
            [[[2, 1, 5], [3, 5, 7]], 3],
        ],
        hidden=[
            [[[1, 0, 2]], 1],
            [[[2, 0, 2], [1, 1, 2]], 2],
            [[[3, 0, 5]], 2],
            [[[2, 0, 5], [2, 5, 10]], 2],
            [[[1, 0, 1], [1, 1, 2], [1, 2, 3]], 1],
        ],
    ),
    make(
        pid=1798,
        title="航班预订统计",
        tags=["数组", "差分数组", "前缀和"],
        description="""给定二维整数数组 bookings 和整数 n
bookings[i] = [first, last, seats] 表示从 first 到 last 的每个航班都预订了 seats 个座位
航班编号从 1 到 n
返回长度为 n 的数组，第 i 项表示航班 i 的预订座位总数""",
        function="corpFlightBookings",
        params=[("bookings", "int[][]"), ("n", "int")],
        returns="int[]",
        solver=corp_flight_bookings,
        public=[
            [[[1, 2, 10], [2, 3, 20], [2, 5, 25]], 5],
            [[[1, 2, 10], [2, 2, 15]], 2],
            [[[1, 1, 1]], 1],
        ],
        hidden=[
            [[], 3],
            [[[1, 3, 5]], 3],
            [[[1, 2, 1], [2, 3, 2], [1, 3, 3]], 3],
            [[[2, 2, 7]], 4],
            [[[1, 5, 2], [3, 4, 3]], 5],
        ],
    ),
    make(
        pid=1799,
        title="表现良好的最长时间段",
        tags=["数组", "前缀和", "哈希表"],
        description="""给定整数数组 hours
若某天工作小时数大于 8，则这一天为「劳累的一天」，否则为「不劳累的一天」
找出一个连续时间段，使得其中劳累的天数严格多于不劳累的天数
返回满足条件的最长时间段的长度，若不存在则返回 0""",
        function="longestWPI",
        params=[("hours", "int[]")],
        returns="int",
        solver=longest_wpi,
        public=[
            [[9, 9, 6, 0, 6, 6, 9]],
            [[6, 6, 6]],
            [[6, 9, 9]],
        ],
        hidden=[
            [[9, 6, 6]],
            [[6, 9, 6]],
            [[9, 9, 9, 9]],
            [[6, 6, 9, 6, 6, 9]],
            [[9, 6, 9, 6, 9]],
        ],
    ),
    make(
        pid=1800,
        title="单字符重复子串的最大长度",
        tags=["字符串", "滑动窗口", "哈希表"],
        description="""给定字符串 text
最多交换字符串中的两个字符一次
返回交换后只包含一种字符的最长连续子串的长度""",
        function="maxRepOpt1",
        params=[("text", "string")],
        returns="int",
        solver=max_rep_opt1,
        public=[
            ["ababa"],
            ["aaabaaa"],
            ["aaabbb"],
        ],
        hidden=[
            ["a"],
            ["aaaa"],
            ["ab"],
            ["aabaa"],
            ["abcdef"],
        ],
    ),
    make(
        pid=1801,
        title="构建回文串检测",
        tags=["字符串", "前缀和", "位运算"],
        description="""给定字符串 s 和二维整数数组 queries
queries[i] = [left, right, k] 表示对子串 s[left..right] 进行检测
可以重新排列子串中的字符，并最多替换其中 k 个字符
判断能否把该子串变成回文串
返回整数数组，第 i 项为 1 表示可以，为 0 表示不可以""",
        function="canMakePaliQueries",
        params=[("s", "string"), ("queries", "int[][]")],
        returns="int[]",
        solver=can_make_pali_queries,
        public=[
            ["abcda", [[3, 3, 0], [1, 2, 0], [0, 3, 1], [0, 4, 2]]],
            ["ab", [[0, 1, 0]]],
            ["aa", [[0, 1, 0]]],
        ],
        hidden=[
            ["abc", [[0, 2, 0], [0, 2, 1]]],
            ["a", [[0, 0, 0]]],
            ["abcd", [[0, 3, 1], [0, 3, 2]]],
            ["abba", [[0, 3, 0]]],
            ["abcdef", [[0, 5, 2], [1, 4, 1]]],
        ],
    ),
    make(
        pid=1802,
        title="反转每对括号间的子串",
        tags=["字符串", "栈"],
        description="""给定字符串 s，其中只包含小写字母和括号
从左到右处理每一对括号，把括号内的子串反转，然后去掉这对括号
括号可能嵌套，按从内到外的顺序处理
返回处理后的最终字符串""",
        function="reverseParentheses",
        params=[("s", "string")],
        returns="string",
        solver=reverse_parentheses,
        public=[
            ["(abcd)"],
            ["(u(love)i)"],
            ["(ed(et(oc))el)"],
        ],
        hidden=[
            ["a(bcdefghijkl(mno)p)q"],
            ["()"],
            ["abc"],
            ["((ab))"],
            ["(ab)(cd)"],
        ],
    ),
    make(
        pid=1803,
        title="尽可能使字符串相等",
        tags=["字符串", "滑动窗口", "二分查找"],
        description="""给定两个长度相同的字符串 s 和 t，以及整数 maxCost
把 s[i] 改成 t[i] 的代价是它们字符编码之差的绝对值
最多可以花费 maxCost
返回能够变成 t 对应子串的 s 的最长连续子串长度""",
        function="equalSubstring",
        params=[("s", "string"), ("t", "string"), ("maxCost", "int")],
        returns="int",
        solver=equal_substring,
        public=[
            ["abcd", "bcdf", 3],
            ["abcd", "cdef", 3],
            ["abcd", "acde", 0],
        ],
        hidden=[
            ["a", "a", 0],
            ["abc", "xyz", 100],
            ["abcd", "abcd", 0],
            ["krrgw", "zjxss", 19],
            ["ab", "ba", 2],
        ],
    ),
    make(
        pid=1804,
        title="删除字符串中的所有相邻重复项 II",
        tags=["字符串", "栈"],
        description="""给定字符串 s 和整数 k，其中 2 <= k <= 100
反复删除字符串中连续出现 k 次的相同字符
删除后两边的部分会拼接，可能形成新的连续 k 个相同字符，需要继续删除
返回最终字符串
题目保证最终结果唯一""",
        function="removeDuplicatesII",
        params=[("s", "string"), ("k", "int")],
        returns="string",
        solver=remove_duplicates_ii,
        public=[
            ["abcd", 2],
            ["deeedbbcccbdaa", 3],
            ["pbbcggttciiippooaais", 2],
        ],
        hidden=[
            ["a", 2],
            ["aa", 2],
            ["aaa", 2],
            ["abbba", 3],
            ["aabbbac", 2],
        ],
    ),
    make(
        pid=1805,
        title="删除子文件夹",
        tags=["字符串", "数组", "排序", "哈希表"],
        description="""给定字符串数组 folder，其中每一项都是绝对路径
如果某个文件夹位于另一个文件夹内部，则它应被删除
不同文件夹之间不会因为前缀相同而产生误判，例如 /a/b 不是 /a/bc 的子文件夹
返回删除所有子文件夹后剩余的文件夹，结果按字典序升序排列""",
        function="removeSubfolders",
        params=[("folder", "string[]")],
        returns="string[]",
        solver=remove_subfolders,
        public=[
            [["/a", "/a/b", "/c/d", "/c/d/e", "/c/f"]],
            [["/a", "/a/b/c", "/a/b/d"]],
            [["/a/b/c", "/a/b/ca", "/a/b/d"]],
        ],
        hidden=[
            [["/a"]],
            [["/z/y", "/z", "/a/b"]],
            [["/a/b", "/a/b/c", "/a/b/d", "/a/b/c/d"]],
            [["/a/b/c", "/a/b/ca", "/a/b/c/d"]],
            [["/x1", "/x2", "/x1/y", "/x2/y"]],
        ],
    ),
    make(
        pid=1806,
        title="替换子串得到平衡字符串",
        tags=["字符串", "滑动窗口", "哈希表"],
        description="""给定长度为 4 的倍数的字符串 s，只包含 Q、W、E、R 四种字符
如果四种字符出现的次数都等于 n / 4，则称 s 是平衡的
可以选一个连续子串，替换成任意长度相同的字符串
返回使 s 变得平衡所需替换子串的最小长度""",
        function="balancedString",
        params=[("s", "string")],
        returns="int",
        solver=balanced_string,
        public=[
            ["QWER"],
            ["QQWE"],
            ["QQQW"],
            ["QQQQ"],
        ],
        hidden=[
            ["WQWRQQQW"],
            ["QWERQWER"],
            ["QQQQWWWW"],
            ["QQWEQWER"],
            ["WWEERRQQ"],
        ],
    ),
    make(
        pid=1807,
        title="统计「优美子数组」",
        tags=["数组", "前缀和", "滑动窗口"],
        description="""给定整数数组 nums 和整数 k
如果某个连续子数组中恰好有 k 个奇数，则称它为优美子数组
返回优美子数组的数量""",
        function="numberOfSubarrays",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=number_of_subarrays,
        public=[
            [[1, 1, 2, 1, 1], 3],
            [[2, 4, 6], 1],
            [[2, 2, 2, 1, 2, 2, 1, 2, 2, 2], 2],
        ],
        hidden=[
            [[1], 1],
            [[2], 1],
            [[1, 2, 3], 2],
            [[1, 1, 1, 1], 2],
            [[2, 2, 1, 2, 2], 1],
        ],
    ),
    make(
        pid=1808,
        title="移除无效的括号",
        tags=["字符串", "栈"],
        description="""给定字符串 s，其中包含小写字母和括号
删除最少数量的左括号或右括号，使剩余括号序列有效
有效的条件是每个右括号都有对应的左括号，且配对顺序正确
返回删除后的字符串，若存在多种删除方式需保证结果字符串唯一
题目数据保证结果唯一""",
        function="minRemoveToMakeValid",
        params=[("s", "string")],
        returns="string",
        solver=min_remove_to_make_valid,
        public=[
            ["lee(t(c)o)de)"],
            ["a)b(c)d"],
            ["))(("],
        ],
        hidden=[
            [""],
            ["abc"],
            ["(a(b)c)"],
            ["))(a"],
            ["a)b(c)d)e"],
        ],
    ),
    make(
        pid=1809,
        title="制造字母异位词的最小步骤数",
        tags=["字符串", "哈希表", "计数"],
        description="""给定两个长度相同的字符串 s 和 t
每步可以选择 s 中任意一个字符替换成另一个字符
返回使 t 成为 s 的字母异位词所需的最少步骤数
字母异位词指两个字符串中每种字符出现次数都相同""",
        function="minSteps",
        params=[("s", "string"), ("t", "string")],
        returns="int",
        solver=min_steps,
        public=[
            ["bab", "aba"],
            ["leetcode", "practice"],
            ["anagram", "mangaar"],
        ],
        hidden=[
            ["a", "a"],
            ["a", "b"],
            ["abc", "cba"],
            ["aaa", "bbb"],
            ["abcde", "edcba"],
        ],
    ),
    make(
        pid=1810,
        title="使结果不超过阈值的最小除数",
        tags=["数组", "二分查找"],
        description="""给定整数数组 nums 和整数 threshold
选择一个正整数 divisor，把每个 nums[i] 除以 divisor 并向上取整后求和
返回使总和不超过 threshold 的最小 divisor""",
        function="smallestDivisor",
        params=[("nums", "int[]"), ("threshold", "int")],
        returns="int",
        solver=smallest_divisor,
        public=[
            [[1, 2, 5, 9], 6],
            [[2, 3, 5, 7, 11], 11],
            [[19], 5],
        ],
        hidden=[
            [[1], 1],
            [[2, 2, 2], 3],
            [[10, 10, 10], 3],
            [[5, 9, 14], 7],
            [[1, 2, 3, 4, 5], 5],
        ],
    ),
    make(
        pid=1811,
        title="元素和小于等于阈值的正方形的最大边长",
        tags=["数组", "前缀和", "二分查找", "矩阵"],
        description="""给定 m x n 的非负整数矩阵 mat 和整数 threshold
找出一个正方形子矩阵，使其所有元素之和不超过 threshold
返回满足条件的正方形的最大边长，若不存在则返回 0""",
        function="maxSideLength",
        params=[("mat", "int[][]"), ("threshold", "int")],
        returns="int",
        solver=max_side_length,
        public=[
            [
                [[1, 1, 3, 2, 4, 3, 2], [1, 1, 3, 2, 4, 3, 2], [1, 1, 3, 2, 4, 3, 2]],
                4,
            ],
            [
                [[2, 2, 2, 2, 2], [2, 2, 2, 2, 2], [2, 2, 2, 2, 2], [2, 2, 2, 2, 2], [2, 2, 2, 2, 2]],
                1,
            ],
            [[[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], 4],
        ],
        hidden=[
            [[[1]], 1],
            [[[1]], 0],
            [[[5, 5], [5, 5]], 20],
            [[[1, 2], [3, 4]], 5],
            [[[3, 3, 3], [3, 3, 3], [3, 3, 3]], 9],
        ],
    ),
    make(
        pid=1812,
        title="划分数组为连续数字的集合",
        tags=["数组", "排序", "哈希表"],
        description="""给定整数数组 nums 和正整数 k
判断能否把数组划分成若干个大小为 k 的集合
每个集合中的数字必须是连续的 k 个整数，且每个元素只能使用一次
返回是否能完成划分""",
        function="isPossibleDivide",
        params=[("nums", "int[]"), ("k", "int")],
        returns="bool",
        solver=is_possible_divide,
        public=[
            [[1, 2, 3, 3, 4, 4, 5, 6], 4],
            [[3, 2, 1, 2, 3, 4, 3, 4, 5, 9, 10, 11], 3],
            [[1, 2, 3, 4], 3],
        ],
        hidden=[
            [[1, 2, 3], 1],
            [[1, 2, 3], 3],
            [[1, 1, 2, 2], 2],
            [[1, 2, 4, 5], 2],
            [[1, 2, 3, 4, 5, 6], 2],
            [[15, 16, 17, 18], 4],
        ],
    ),
    make(
        pid=1813,
        title="转变数组后最接近目标值的数组和",
        tags=["数组", "二分查找", "排序"],
        description="""给定整数数组 arr 和目标值 target
选择一个整数 value，把数组中每个大于 value 的元素都变成 value
修改后数组元素和记为 sum
返回使 |sum - target| 最小的 value
若存在多个这样的 value，返回其中最小的一个""",
        function="findBestValue",
        params=[("arr", "int[]"), ("target", "int")],
        returns="int",
        solver=find_best_value,
        public=[
            [[4, 9, 3], 10],
            [[2, 3, 5], 10],
            [[60864, 25176, 27249, 21296, 20204], 56803],
        ],
        hidden=[
            [[1], 1],
            [[1, 2, 3], 3],
            [[1, 2, 3], 100],
            [[10, 10, 10], 0],
            [[3, 5, 7], 12],
        ],
    ),
    make(
        pid=1814,
        title="矩阵区域和",
        tags=["数组", "前缀和", "矩阵"],
        description="""给定 m x n 整数矩阵 mat 和整数 k
返回同样大小的矩阵 answer
answer[i][j] 等于 mat 中以 (i, j) 为中心、上下左右各扩展 k 行或 k 列的区域元素和
超出矩阵边界的部分不参与计算""",
        function="matrixBlockSum",
        params=[("mat", "int[][]"), ("k", "int")],
        returns="int[][]",
        solver=matrix_block_sum,
        public=[
            [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], 1],
            [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], 2],
            [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], 0],
        ],
        hidden=[
            [[[1]], 0],
            [[[1]], 5],
            [[[1, 2], [3, 4]], 1],
            [[[5, 5], [5, 5]], 2],
            [[[1, 2, 3, 4]], 1],
        ],
    ),
    make(
        pid=1815,
        title="破坏回文串",
        tags=["字符串", "贪心"],
        description="""给定一个回文字符串 palindrome
必须把其中一个字符替换成另一个小写字母
返回替换后字典序最小的非回文字符串
若无法得到非回文字符串则返回空字符串""",
        function="breakPalindrome",
        params=[("palindrome", "string")],
        returns="string",
        solver=break_palindrome,
        public=[
            ["abccba"],
            ["a"],
            ["aa"],
        ],
        hidden=[
            ["aba"],
            ["abba"],
            ["aabaa"],
            ["abcba"],
            ["aaa"],
        ],
    ),
    make(
        pid=1816,
        title="满足条件的子序列数目",
        tags=["数组", "排序", "双指针", "二分查找"],
        description="""给定整数数组 nums 和目标值 target
统计满足最小值与最大值之和不超过 target 的非空子序列数量
子序列按原数组下标选取，不同下标集合算作不同子序列
结果对 10^9 + 7 取模""",
        function="numSubseq",
        params=[("nums", "int[]"), ("target", "int")],
        returns="int",
        solver=num_subseq,
        public=[
            [[3, 5, 6, 7], 9],
            [[3, 3, 6, 8], 10],
            [[2, 3, 3, 4, 6, 7], 12],
        ],
        hidden=[
            [[1], 1],
            [[1], 0],
            [[2, 2, 2], 4],
            [[1, 2, 3, 4], 5],
            [[4, 3, 2, 1], 4],
        ],
    ),
]

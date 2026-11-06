"""1900-1937：批量第四批简单题（38 道）。"""

from __future__ import annotations

from functools import partial

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="easy")


# ── 数组 / 排序 / 哈希表 / 模拟 ──────────────────────────────────────


def can_make_arithmetic_progression(arr: list[int]) -> bool:
    ordered = sorted(arr)
    if len(ordered) < 3:
        return True
    difference = ordered[1] - ordered[0]
    return all(
        ordered[index] - ordered[index - 1] == difference
        for index in range(2, len(ordered))
    )


def reformat_date(date: str) -> str:
    day, month, year = date.split()
    months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    ]
    month_number = months.index(month) + 1
    return f"{year}-{month_number:02d}-{int(day[:-2]):02d}"


def three_consecutive_odds(arr: list[int]) -> bool:
    for index in range(len(arr) - 2):
        if arr[index] % 2 and arr[index + 1] % 2 and arr[index + 2] % 2:
            return True
    return False


def thousand_separator(n: int) -> str:
    digits = str(n)
    groups: list[str] = []
    while len(digits) > 3:
        groups.append(digits[-3:])
        digits = digits[:-3]
    groups.append(digits)
    return ".".join(reversed(groups))


def most_visited(n: int, rounds: list[int]) -> list[int]:
    start, end = rounds[0], rounds[-1]
    if start <= end:
        return list(range(start, end + 1))
    return list(range(1, end + 1)) + list(range(start, n + 1))


def contains_pattern(arr: list[int], m: int, k: int) -> bool:
    total = m * k
    for start in range(len(arr) - total + 1):
        pattern = arr[start:start + m]
        if all(
            arr[start + offset] == pattern[offset % m]
            for offset in range(total)
        ):
            return True
    return False


def modify_string(s: str) -> str:
    chars = list(s)
    for index, character in enumerate(chars):
        if character != "?":
            continue
        previous = chars[index - 1] if index > 0 else ""
        following = chars[index + 1] if index + 1 < len(chars) else ""
        for candidate in "abcdefghijklmnopqrstuvwxyz":
            if candidate != previous and candidate != following:
                chars[index] = candidate
                break
    return "".join(chars)


def num_special(mat: list[list[int]]) -> int:
    rows = [sum(row) for row in mat]
    columns = [
        sum(mat[row][column] for row in range(len(mat)))
        for column in range(len(mat[0]))
    ]
    count = 0
    for row in range(len(mat)):
        for column in range(len(mat[0])):
            if mat[row][column] == 1 and rows[row] == 1 and columns[column] == 1:
                count += 1
    return count


def reorder_spaces(text: str) -> str:
    words = text.split()
    spaces = text.count(" ")
    if len(words) == 1:
        return words[0] + " " * spaces
    gaps = len(words) - 1
    per_gap, extra = divmod(spaces, gaps)
    return (" " * per_gap).join(words) + " " * extra


def special_array(nums: list[int]) -> int:
    for value in range(1, len(nums) + 1):
        if sum(number >= value for number in nums) == value:
            return value
    return -1


def trim_mean(arr: list[int]) -> float:
    ordered = sorted(arr)
    removed = len(ordered) // 20
    kept = ordered[removed:len(ordered) - removed]
    return sum(kept) / len(kept)


def max_length_between_equal_characters(s: str) -> int:
    first = {}
    best = -1
    for index, character in enumerate(s):
        if character in first:
            best = max(best, index - first[character] - 1)
        else:
            first[character] = index
    return best


def slowest_key(release_times: list[int], keys_pressed: str) -> str:
    best_time = -1
    best_key = ""
    previous = 0
    for time, key in zip(release_times, keys_pressed):
        duration = time - previous
        previous = time
        if duration > best_time or (duration == best_time and key > best_key):
            best_time = duration
            best_key = key
    return best_key


def find_target_indices(nums: list[int], target: int) -> list[int]:
    ordered = sorted(nums)
    return [
        index for index, value in enumerate(ordered) if value == target
    ]


def can_form_array(arr: list[int], pieces: list[list[int]]) -> bool:
    starts = {piece[0]: piece for piece in pieces}
    index = 0
    while index < len(arr):
        piece = starts.get(arr[index])
        if piece is None:
            return False
        if arr[index:index + len(piece)] != piece:
            return False
        index += len(piece)
    return True


def get_maximum_generated(n: int) -> int:
    if n == 0:
        return 0
    nums = [0] * (n + 1)
    nums[1] = 1
    for index in range(2, n + 1):
        if index % 2 == 0:
            nums[index] = nums[index // 2]
        else:
            nums[index] = nums[index // 2] + nums[index // 2 + 1]
    return max(nums)


def decrypt(code: list[int], k: int) -> list[int]:
    size = len(code)
    if k == 0:
        return [0] * size
    result = []
    for index in range(size):
        if k > 0:
            total = sum(code[(index + step) % size] for step in range(1, k + 1))
        else:
            total = sum(code[(index - step) % size] for step in range(1, -k + 1))
        result.append(total)
    return result


def max_repeating(sequence: str, word: str) -> int:
    count = 0
    while word * (count + 1) in sequence:
        count += 1
    return count


def interpret(command: str) -> str:
    result: list[str] = []
    index = 0
    while index < len(command):
        if command[index] == "G":
            result.append("G")
            index += 1
        elif command[index:index + 2] == "()":
            result.append("o")
            index += 2
        else:
            result.append("al")
            index += 4
    return "".join(result)


def reformat_number(number: str) -> str:
    digits = [character for character in number if character.isdigit()]
    groups: list[str] = []
    while len(digits) > 4:
        groups.append("".join(digits[:3]))
        digits = digits[3:]
    if len(digits) == 4:
        groups.append("".join(digits[:2]))
        groups.append("".join(digits[2:]))
    else:
        groups.append("".join(digits))
    return "-".join(groups)


def halves_are_alike(s: str) -> bool:
    vowels = set("aeiouAEIOU")
    middle = len(s) // 2
    left = sum(character in vowels for character in s[:middle])
    right = sum(character in vowels for character in s[middle:])
    return left == right


def count_good_rectangles(rectangles: list[list[int]]) -> int:
    sides = [min(width, height) for width, height in rectangles]
    largest = max(sides)
    return sum(side == largest for side in sides)


def maximum_time(time: str) -> str:
    def matches(candidate: str) -> bool:
        return all(
            pattern == "?" or pattern == character
            for character, pattern in zip(candidate, time)
        )

    for hour in range(23, -1, -1):
        for minute in range(59, -1, -1):
            candidate = f"{hour:02d}:{minute:02d}"
            if matches(candidate):
                return candidate
    return ""


def count_balls(low_limit: int, high_limit: int) -> int:
    boxes = {}
    for number in range(low_limit, high_limit + 1):
        box = sum(int(digit) for digit in str(number))
        boxes[box] = boxes.get(box, 0) + 1
    return max(boxes.values())


def longest_nice_substring(s: str) -> str:
    for length in range(len(s), 0, -1):
        for start in range(len(s) - length + 1):
            candidate = s[start:start + length]
            letters = set(candidate)
            if all(
                character.lower() in letters and character.upper() in letters
                for character in letters
            ):
                return candidate
    return ""


def merge_alternately(word1: str, word2: str) -> str:
    result: list[str] = []
    for index in range(max(len(word1), len(word2))):
        if index < len(word1):
            result.append(word1[index])
        if index < len(word2):
            result.append(word2[index])
    return "".join(result)


def count_matches(items: list[list[str]], rule_key: str, rule_value: str) -> int:
    key_index = {"type": 0, "color": 1, "name": 2}
    position = key_index[rule_key]
    return sum(item[position] == rule_value for item in items)


def nearest_valid_point(x: int, y: int, points: list[list[int]]) -> int:
    best_index = -1
    best_distance = None
    for index, (point_x, point_y) in enumerate(points):
        if point_x != x and point_y != y:
            continue
        distance = abs(point_x - x) + abs(point_y - y)
        if best_distance is None or distance < best_distance:
            best_distance = distance
            best_index = index
    return best_index


def check_ones_segment(s: str) -> bool:
    seen_zero = False
    for character in s:
        if character == "0":
            seen_zero = True
        elif seen_zero:
            return False
    return True


def are_almost_equal(s1: str, s2: str) -> bool:
    if len(s1) != len(s2):
        return False
    differences = [
        index for index in range(len(s1)) if s1[index] != s2[index]
    ]
    if not differences:
        return True
    if len(differences) != 2:
        return False
    left, right = differences
    return s1[left] == s2[right] and s1[right] == s2[left]


def second_highest(s: str) -> int:
    digits = sorted({int(character) for character in s if character.isdigit()})
    return digits[-2] if len(digits) >= 2 else -1


def max_ascending_sum(nums: list[int]) -> int:
    current = best = nums[0]
    for index in range(1, len(nums)):
        if nums[index] > nums[index - 1]:
            current += nums[index]
        else:
            current = nums[index]
        best = max(best, current)
    return best


def num_different_integers(word: str) -> int:
    numbers: set[str] = set()
    current: list[str] = []

    def flush() -> None:
        if current:
            numbers.add("".join(current).lstrip("0") or "0")
            current.clear()

    for character in word:
        if character.isdigit():
            current.append(character)
        else:
            flush()
    flush()
    return len(numbers)


def array_sign(nums: list[int]) -> int:
    if any(number == 0 for number in nums):
        return 0
    negatives = sum(number < 0 for number in nums)
    return -1 if negatives % 2 else 1


def check_if_pangram(sentence: str) -> bool:
    return len(set(sentence)) == 26


def replace_digits(s: str) -> str:
    chars = list(s)
    for index in range(1, len(chars), 2):
        chars[index] = chr(ord(chars[index - 1]) + int(chars[index]))
    return "".join(chars)


def maximum_population(logs: list[list[int]]) -> int:
    start_year = 1950
    differences = [0] * 102
    for birth, death in logs:
        differences[birth - start_year] += 1
        differences[death - start_year] -= 1
    best_year = start_year
    best_population = -1
    population = 0
    for offset in range(101):
        population += differences[offset]
        if population > best_population:
            best_population = population
            best_year = start_year + offset
    return best_year


def sort_sentence(s: str) -> str:
    words = s.split()
    words.sort(key=lambda word: int(word[-1]))
    return " ".join(word[:-1] for word in words)


PROBLEMS = [
    make(
        pid=1900,
        title="判断能否形成等差数列",
        tags=["数组", "排序"],
        description="""给定一个整数数组 arr
如果将其重新排序后，任意相邻两个元素之差都相同，则称它可以形成等差数列
请判断 arr 能否形成等差数列
长度小于 3 的数组一律视为可以形成等差数列""",
        function="canMakeArithmeticProgression",
        params=[("arr", "int[]")],
        returns="bool",
        solver=can_make_arithmetic_progression,
        public=[[[3, 5, 1]], [[1, 2, 4]], [[1, 3, 5]], [[1, 2, 3, 4]]],
        hidden=[[[1]], [[1, 2]], [[2, 4, 1]], [[1, 5, 9, 13]], [[3, 3, 3]], [[1, 2, 2]]],
    ),
    make(
        pid=1901,
        title="转变日期格式",
        tags=["字符串", "模拟"],
        description="""给定一个格式为 "日 月 年" 的日期字符串
日是带后缀 st、nd、rd、th 的 1 到 31 的数字，月是三个字母的英文缩写，年是四位数字
返回格式为 YYYY-MM-DD 的字符串，其中月份和日期都补齐两位""",
        function="reformatDate",
        params=[("date", "string")],
        returns="string",
        solver=reformat_date,
        public=[
            ["20th Oct 2052"],
            ["6th Jun 1933"],
            ["26th May 1960"],
        ],
        hidden=[
            ["1st Jan 2000"],
            ["31st Dec 1999"],
            ["2nd Feb 2024"],
            ["3rd Mar 2020"],
            ["30th Nov 2100"],
        ],
    ),
    make(
        pid=1902,
        title="存在连续三个奇数的数组",
        tags=["数组"],
        description="""给定一个整数数组 arr
判断数组中是否存在连续三个元素都是奇数的情况""",
        function="threeConsecutiveOdds",
        params=[("arr", "int[]")],
        returns="bool",
        solver=three_consecutive_odds,
        public=[[[2, 6, 4, 1]], [[1, 2, 34, 3, 4, 5, 7, 23, 12]], [[1, 3, 5]]],
        hidden=[[[1]], [[2, 1, 3, 5]], [[1, 2, 3, 4]], [[7, 9, 11, 13]], [[1, 1, 1, 2]]],
    ),
    make(
        pid=1903,
        title="千位分隔符",
        tags=["字符串", "模拟"],
        description="""给定一个非负整数 n
将它转换为字符串，并从右向左每三位插入一个点号作为千位分隔符
返回添加分隔符后的字符串，n 为 0 时返回由单个 0 组成的字符串""",
        function="thousandSeparator",
        params=[("n", "int")],
        returns="string",
        solver=thousand_separator,
        public=[[987], [1234], [0]],
        hidden=[[1], [1000], [123456789], [10], [999999999], [2147483647]],
    ),
    make(
        pid=1904,
        title="圆形赛道上最常访问的扇区",
        tags=["数组", "模拟"],
        description="""一条环形赛道有编号 1 到 n 的 n 个扇区
选手从 rounds[0] 出发，按顺序依次到达 rounds 中的每个扇区，每段都沿编号递增方向前进，经过 n 后回到 1
经过和到达的每个扇区都计入一次访问，完整绕圈会对所有扇区产生相同次数的访问
返回访问次数最多的所有扇区编号，按升序排列""",
        function="mostVisited",
        params=[("n", "int"), ("rounds", "int[]")],
        returns="int[]",
        solver=most_visited,
        public=[
            [4, [1, 3, 1, 2]],
            [2, [2, 1, 2, 1, 2, 1, 2, 1, 2]],
            [7, [1, 3, 5, 7]],
        ],
        hidden=[
            [3, [3, 1]],
            [3, [1, 3]],
            [5, [5, 1, 3]],
            [1, [1, 1]],
            [10, [10, 5]],
            [4, [2, 2, 2]],
        ],
    ),
    make(
        pid=1905,
        title="检测重复至少 K 次的长度为 M 的模式",
        tags=["数组", "滑动窗口"],
        description="""给定整数数组 arr 和两个整数 m、k
如果存在一个长度为 m 的模式，在数组中连续重复出现至少 k 次，返回 true，否则返回 false
连续重复指这 k 段首尾相接且内容完全相同""",
        function="containsPattern",
        params=[("arr", "int[]"), ("m", "int"), ("k", "int")],
        returns="bool",
        solver=contains_pattern,
        public=[
            [[1, 2, 4, 4, 4, 4], 1, 3],
            [[1, 2, 1, 2, 1, 1, 1, 3], 2, 2],
            [[1, 2, 1, 2, 1, 3], 2, 3],
        ],
        hidden=[
            [[1, 2, 3, 1, 2], 2, 2],
            [[1], 1, 1],
            [[2, 2, 2, 2], 2, 2],
            [[1, 2, 1, 2], 2, 1],
            [[1, 2, 3], 1, 3],
        ],
    ),
    make(
        pid=1906,
        title="替换所有问号",
        tags=["字符串", "模拟"],
        description="""给定一个只含小写字母和问号的字符串 s
将每个问号替换为一个小写字母，使得字符串中不存在连续相同的字符
如果某个位置有多种可选字母，选择字典序最小的那个，以保证结果唯一""",
        function="modifyString",
        params=[("s", "string")],
        returns="string",
        solver=modify_string,
        public=[["?zs"], ["ubv?"], ["???"]],
        hidden=[["?"], ["a?b"], ["a?b?c"], ["??"], ["abc??"], ["z??z"]],
    ),
    make(
        pid=1907,
        title="二进制矩阵中的特殊位置",
        tags=["数组", "矩阵"],
        description="""给定一个只含 0 和 1 的矩阵 mat
如果某个位置的值为 1，且它所在行和所在列的其他位置都为 0，则称该位置是特殊的
返回特殊位置的数量""",
        function="numSpecial",
        params=[("mat", "int[][]")],
        returns="int",
        solver=num_special,
        public=[
            [[[1, 0, 0], [0, 0, 1], [1, 0, 0]]],
            [[[1, 0, 0], [0, 1, 0], [0, 0, 1]]],
            [[[0, 0, 0], [0, 1, 0], [0, 0, 0]]],
        ],
        hidden=[
            [[[0]]],
            [[[1]]],
            [[[1, 0], [0, 1]]],
            [[[1, 1], [1, 1]]],
            [[[0, 0], [0, 0]]],
        ],
    ),
    make(
        pid=1908,
        title="重新排列单词间的空格",
        tags=["字符串", "模拟"],
        description="""给定一个由单词和空格组成的字符串 text
单词之间用一个或多个空格分隔，字符串可能以空格开头或结尾
重新排列空格：单词顺序不变，单词之间用等量空格分隔，不能均分的多余空格全部追加到字符串末尾
只有一个单词时，所有空格都放在该单词后面，结果不含前导空格""",
        function="reorderSpaces",
        params=[("text", "string")],
        returns="string",
        solver=reorder_spaces,
        public=[
            ["  this   is  a sentence "],
            [" practice   makes   perfect"],
            ["hello world  "],
        ],
        hidden=[
            ["a"],
            ["  a  "],
            ["a b"],
            ["a  b  c"],
            ["abc def "],
            [" a b "],
        ],
    ),
    make(
        pid=1909,
        title="特殊数组的特征值",
        tags=["数组", "排序"],
        description="""给定一个非负整数数组 nums
如果存在一个整数 x，使得数组中恰好有 x 个元素大于或等于 x，则 x 是数组的特征值
返回最大的特征值；如果不存在，返回 -1""",
        function="specialArray",
        params=[("nums", "int[]")],
        returns="int",
        solver=special_array,
        public=[
            [[3, 5]],
            [[0, 0]],
            [[0, 4, 3, 0, 4]],
            [[3, 6, 7, 7, 0]],
        ],
        hidden=[
            [[1]],
            [[0]],
            [[1, 2]],
            [[2, 2]],
            [[3, 3, 3]],
            [[1, 1, 1, 1]],
        ],
    ),
    make(
        pid=1910,
        title="删除某些元素后的数组均值",
        tags=["数组", "排序"],
        description="""给定一个长度为 n 的整数数组 arr，其中 n 是 20 的倍数
删除数组中最小和最大的各 n / 20 个元素，返回剩余元素的平均值
结果以浮点数返回""",
        function="trimMean",
        params=[("arr", "int[]")],
        returns="double",
        solver=trim_mean,
        compare={"mode": "double"},
        public=[
            [[1] * 10 + [2] * 10],
            [list(range(1, 21))],
            [[5] * 20],
        ],
        hidden=[
            [[1] * 20],
            [[1] * 10 + [100] * 10],
            [list(range(0, 20))],
            [list(range(1, 41))],
            [[2] * 19 + [4]],
        ],
    ),
    make(
        pid=1911,
        title="两个相同字符之间的最长子字符串",
        tags=["字符串", "哈希表"],
        description="""给定一个字符串 s
选择两个相同的字符，返回它们之间（不含这两个字符）的子字符串的最大长度
如果不存在两个相同的字符，返回 -1""",
        function="maxLengthBetweenEqualCharacters",
        params=[("s", "string")],
        returns="int",
        solver=max_length_between_equal_characters,
        public=[["aa"], ["abca"], ["cbzxy"]],
        hidden=[["a"], ["ab"], ["abcba"], ["aaaa"], ["abacaba"]],
    ),
    make(
        pid=1912,
        title="按键持续时间最长的键",
        tags=["数组", "字符串"],
        description="""给定整数数组 releaseTimes 和字符串 keysPressed
keysPressed[i] 是第 i 次按下的键，releaseTimes[i] 是它被释放的时刻，数组严格递增
第 i 次按键的持续时间为 releaseTimes[i] 减去 releaseTimes[i - 1]，第一次按键从时刻 0 开始计算
返回持续时间最长的键；如果并列，返回字母序更大的键""",
        function="slowestKey",
        params=[("releaseTimes", "int[]"), ("keysPressed", "string")],
        returns="string",
        solver=slowest_key,
        public=[
            [[9, 29, 49, 50], "cbcd"],
            [[12, 23, 36, 46, 62], "spuda"],
            [[3, 7], "ab"],
        ],
        hidden=[
            [[1], "a"],
            [[1, 2], "ab"],
            [[2, 4], "bb"],
            [[10, 20, 30], "abc"],
            [[1, 2, 3, 4], "zzzz"],
            [[5, 10, 15, 20], "abcd"],
        ],
    ),
    make(
        pid=1913,
        title="找到目标值的下标",
        tags=["数组", "排序"],
        description="""给定一个整数数组 nums 和目标值 target
先将 nums 按非递减顺序排序，再找出排序后数组中所有等于 target 的下标
返回这些下标组成的数组，按升序排列；如果没有元素等于 target，返回空数组""",
        function="findTargetIndices",
        params=[("nums", "int[]"), ("target", "int")],
        returns="int[]",
        solver=find_target_indices,
        public=[
            [[1, 2, 5, 2, 3], 2],
            [[1, 2, 5, 2, 3], 3],
            [[1, 2, 5, 2, 3], 5],
        ],
        hidden=[
            [[1], 1],
            [[1], 2],
            [[2, 2], 2],
            [[5, 4, 3, 2, 1], 3],
            [[1, 1, 1], 1],
            [[3, 1, 2], 4],
        ],
    ),
    make(
        pid=1914,
        title="能否连接形成数组",
        tags=["数组", "哈希表"],
        description="""给定一个整数数组 arr 和一个二维整数数组 pieces
arr 中的整数互不相同，pieces 中所有整数也互不相同，且 pieces 的所有元素恰好组成 arr
只有当 pieces 中的每个子数组都能按原顺序、按任意子数组顺序首尾拼接成 arr 时，返回 true，否则返回 false""",
        function="canFormArray",
        params=[("arr", "int[]"), ("pieces", "int[][]")],
        returns="bool",
        solver=can_form_array,
        public=[
            [[15, 88], [[88], [15]]],
            [[49, 18, 16], [[16, 18, 49]]],
            [[91, 4, 64, 78], [[78], [4, 64], [91]]],
        ],
        hidden=[
            [[1], [[1]]],
            [[1, 2], [[1], [2]]],
            [[2, 1], [[1], [2]]],
            [[1, 2, 3], [[1, 3], [2]]],
            [[1, 2], [[1, 2]]],
            [[1, 2, 3], [[1, 2, 3]]],
        ],
    ),
    make(
        pid=1915,
        title="获取生成数组中的最大值",
        tags=["数组", "模拟"],
        description="""按下述规则生成数组 nums：nums[0] = 0，nums[1] = 1
对于 2 <= i <= n，如果 i 是偶数，nums[i] = nums[i / 2]；如果 i 是奇数，nums[i] = nums[i / 2] + nums[i / 2 + 1]
返回 nums[0] 到 nums[n] 中的最大值，给定 0 <= n <= 100""",
        function="getMaximumGenerated",
        params=[("n", "int")],
        returns="int",
        solver=get_maximum_generated,
        public=[[7], [2], [3]],
        hidden=[[0], [1], [4], [10], [100]],
    ),
    make(
        pid=1916,
        title="拆炸弹",
        tags=["数组", "模拟"],
        description="""给定循环数组 code 和整数 k
如果 k > 0，将 code[i] 替换为它后面 k 个元素之和
如果 k < 0，将 code[i] 替换为它前面 -k 个元素之和
如果 k == 0，将所有元素替换为 0
数组首尾相接，返回替换后的数组""",
        function="decrypt",
        params=[("code", "int[]"), ("k", "int")],
        returns="int[]",
        solver=decrypt,
        public=[
            [[5, 7, 1, 4], 3],
            [[1, 2, 3, 4], 0],
            [[2, 4, 9, 3], -2],
        ],
        hidden=[
            [[1], 0],
            [[1, 2], 1],
            [[1, 2], -1],
            [[1, 2, 3], 2],
            [[1, 2, 3], -2],
            [[1, 2, 3, 4], 3],
        ],
    ),
    make(
        pid=1917,
        title="最大重复子字符串",
        tags=["字符串"],
        description="""给定字符串 sequence 和 word
返回最大的整数 k，使得 word 重复 k 次后得到的字符串是 sequence 的子字符串
如果不存在这样的 k，返回 0""",
        function="maxRepeating",
        params=[("sequence", "string"), ("word", "string")],
        returns="int",
        solver=max_repeating,
        public=[
            ["ababc", "ab"],
            ["ababc", "ba"],
            ["ababc", "ac"],
        ],
        hidden=[
            ["a", "a"],
            ["aa", "a"],
            ["abc", "abc"],
            ["ababab", "abab"],
            ["aaaa", "aa"],
        ],
    ),
    make(
        pid=1918,
        title="设计 Goal 解析器",
        tags=["字符串", "模拟"],
        description="""给定一个只包含 "G"、"()"、"(al)" 三种片段的命令字符串
按以下规则解释： "G" 解释为 "G"，"()" 解释为 "o"，"(al)" 解释为 "al"
返回解释后的字符串""",
        function="interpret",
        params=[("command", "string")],
        returns="string",
        solver=interpret,
        public=[["G()(al)"], ["GG()"], ["()()()"]],
        hidden=[["G"], ["()"], ["(al)"], ["G(al)()"], ["G()()()()(al)"]],
    ),
    make(
        pid=1919,
        title="重新格式化电话号码",
        tags=["字符串", "模拟"],
        description="""给定一个包含数字、空格和破折号的字符串 number
先删除所有空格和破折号，只保留数字
然后从左到右每 3 位分为一组；最后剩余 2 位时单独成组，剩余 4 位时分成两个 2 位组
返回用破折号连接各组的字符串""",
        function="reformatNumber",
        params=[("number", "string")],
        returns="string",
        solver=reformat_number,
        public=[
            ["1-23-45 6"],
            ["123 4-567"],
            ["123 4-5678"],
        ],
        hidden=[
            ["12"],
            ["123"],
            ["1234"],
            ["1 2 3 4 5"],
            ["--123-456--"],
            ["123456789"],
        ],
    ),
    make(
        pid=1920,
        title="判断字符串的两半是否相似",
        tags=["字符串", "计数"],
        description="""给定一个长度为偶数的字符串 s，将它从中间分成两个长度相等的部分
元音字母为 a、e、i、o、u 的大小写形式
如果两部分中元音字母的数量相等，返回 true，否则返回 false""",
        function="halvesAreAlike",
        params=[("s", "string")],
        returns="bool",
        solver=halves_are_alike,
        public=[["book"], ["textbook"], ["MerryChristmas"]],
        hidden=[["aa"], ["ab"], ["aeiouAEIOU"], ["AbCdEfGh"], ["aA"]],
    ),
    make(
        pid=1921,
        title="可以形成最大正方形的矩形数目",
        tags=["数组", "计数"],
        description="""给定二维数组 rectangles，其中 rectangles[i] = [length, width]
从每个矩形中切出一个正方形，边长取长和宽的较小值
先求出所有矩形能切出的最大正方形边长，再返回能切出这个边长的矩形数量""",
        function="countGoodRectangles",
        params=[("rectangles", "int[][]")],
        returns="int",
        solver=count_good_rectangles,
        public=[
            [[[5, 8], [3, 9], [5, 12], [16, 5]]],
            [[[2, 3], [3, 7], [4, 3], [3, 7]]],
            [[[1, 1], [1, 1]]],
        ],
        hidden=[
            [[[1, 1]]],
            [[[1, 2], [2, 1]]],
            [[[4, 4], [4, 4], [4, 4]]],
            [[[2, 10], [5, 4], [3, 3]]],
        ],
    ),
    make(
        pid=1922,
        title="替换隐藏数字得到的最晚时间",
        tags=["字符串", "枚举"],
        description="""给定一个长度为 5 的字符串 time，格式为 "HH:MM"，其中部分字符被问号隐藏
返回将问号替换为数字后能得到的最晚合法时间，合法时间范围为 00:00 到 23:59""",
        function="maximumTime",
        params=[("time", "string")],
        returns="string",
        solver=maximum_time,
        public=[["2?:?0"], ["0?:3?"], ["1?:22"]],
        hidden=[["??:??"], ["?4:5?"], ["?0:?0"], ["??:3?"], ["2?:??"], ["?9:?9"]],
    ),
    make(
        pid=1923,
        title="盒子中小球的最大数量",
        tags=["数学", "哈希表"],
        description="""有编号从 1 开始的无限多个盒子，编号 lowLimit 到 highLimit 的每个小球依次放入一个盒子
编号为 n 的小球放入编号等于 n 的十进制各位数字之和的盒子
返回球数量最多的盒子中的球数""",
        function="countBalls",
        params=[("lowLimit", "int"), ("highLimit", "int")],
        returns="int",
        solver=count_balls,
        public=[[1, 10], [5, 15], [19, 28]],
        hidden=[[1, 1], [1, 2], [9, 9], [1, 20], [10, 20]],
    ),
    make(
        pid=1924,
        title="最长的美好子字符串",
        tags=["字符串", "枚举"],
        description="""如果一个字符串中每种出现的字母都同时以大写和小写形式出现，则称它为美好字符串
给定字符串 s，返回最长的美好子字符串
如果有多个最长答案，返回最先出现的那个；如果不存在，返回空字符串""",
        function="longestNiceSubstring",
        params=[("s", "string")],
        returns="string",
        solver=longest_nice_substring,
        public=[["YazaAay"], ["Bb"], ["c"]],
        hidden=[["aA"], ["abc"], ["aAbB"], ["dDdD"], ["xXyYz"]],
    ),
    make(
        pid=1925,
        title="交替合并字符串",
        tags=["字符串", "双指针"],
        description="""给定两个字符串 word1 和 word2
从 word1 开始，依次从两个字符串中交替取字符并拼接
如果一个字符串先用完，就把另一个字符串剩余字符直接追加到结果末尾
返回合并后的字符串""",
        function="mergeAlternately",
        params=[("word1", "string"), ("word2", "string")],
        returns="string",
        solver=merge_alternately,
        public=[
            ["abc", "pqr"],
            ["ab", "pqrs"],
            ["abcd", "pq"],
        ],
        hidden=[
            ["ab", "c"],
            ["a", "bc"],
            ["abcdef", "xy"],
            ["x", "abcdef"],
            ["a", "b"],
            ["abc", "xyz"],
        ],
    ),
    make(
        pid=1926,
        title="统计匹配检索规则的物品数量",
        tags=["数组", "字符串"],
        description="""给定二维字符串数组 items，其中 items[i] = [type, color, name]
同时给定规则键 ruleKey 和规则值 ruleValue，ruleKey 只能是 "type"、"color" 或 "name"
统计满足 item[ruleKey] == ruleValue 的物品数量""",
        function="countMatches",
        params=[("items", "string[][]"), ("ruleKey", "string"), ("ruleValue", "string")],
        returns="int",
        solver=count_matches,
        public=[
            [
                [
                    ["phone", "blue", "pixel"],
                    ["computer", "silver", "lenovo"],
                    ["phone", "gold", "iphone"],
                ],
                "color",
                "silver",
            ],
            [
                [
                    ["phone", "blue", "pixel"],
                    ["computer", "silver", "lenovo"],
                    ["phone", "gold", "iphone"],
                ],
                "type",
                "phone",
            ],
            [
                [
                    ["phone", "blue", "pixel"],
                    ["computer", "silver", "lenovo"],
                    ["phone", "gold", "iphone"],
                ],
                "name",
                "pixel",
            ],
        ],
        hidden=[
            [[["a", "b", "c"]], "type", "a"],
            [[["a", "b", "c"]], "color", "x"],
            [[["a", "b", "c"]], "name", "c"],
            [[["x", "y", "z"], ["x", "y", "z"]], "type", "x"],
            [[["phone", "blue", "pixel"]], "name", "pixel"],
        ],
    ),
    make(
        pid=1927,
        title="找到最近的有相同 X 或 Y 坐标的点",
        tags=["数组"],
        description="""给定整数 x、y 和点坐标数组 points，每个点由 [x_i, y_i] 表示
如果某个点与 (x, y) 有相同的横坐标或相同的纵坐标，则称它是有效点
返回距离 (x, y) 曼哈顿距离最近的有效点下标；距离相同时返回下标最小的点
如果没有有效点，返回 -1""",
        function="nearestValidPoint",
        params=[("x", "int"), ("y", "int"), ("points", "int[][]")],
        returns="int",
        solver=nearest_valid_point,
        public=[
            [3, 4, [[1, 2], [3, 1], [2, 4], [2, 3], [4, 4]]],
            [3, 4, [[3, 4]]],
            [3, 4, [[2, 3]]],
        ],
        hidden=[
            [1, 1, [[1, 2]]],
            [1, 1, [[2, 2], [1, 3]]],
            [5, 5, [[6, 6], [5, 5]]],
            [0, 0, [[1, 0], [0, 1]]],
            [0, 0, [[2, 2]]],
        ],
    ),
    make(
        pid=1928,
        title="检查二进制字符串字段",
        tags=["字符串"],
        description="""给定一个只含 0 和 1 的字符串 s
如果字符串中所有的 1 构成至多一个连续段，返回 true，否则返回 false
只含 0 的字符串视为满足条件""",
        function="checkOnesSegment",
        params=[("s", "string")],
        returns="bool",
        solver=check_ones_segment,
        public=[["1001"], ["110"], ["1"]],
        hidden=[["0"], ["10"], ["01"], ["101"], ["111000"], ["110011"]],
    ),
    make(
        pid=1929,
        title="仅执行一次字符串交换能否使两个字符串相等",
        tags=["字符串", "哈希表"],
        description="""给定两个长度相同的字符串 s1 和 s2
判断能否最多交换 s1 中的两个字母一次，使得交换后 s1 与 s2 相等
不交换也算满足条件""",
        function="areAlmostEqual",
        params=[("s1", "string"), ("s2", "string")],
        returns="bool",
        solver=are_almost_equal,
        public=[
            ["bank", "kanb"],
            ["attack", "defend"],
            ["kelb", "kelb"],
        ],
        hidden=[
            ["ab", "ba"],
            ["ab", "ab"],
            ["abc", "abd"],
            ["abcd", "badc"],
            ["aa", "aa"],
            ["abc", "acb"],
        ],
    ),
    make(
        pid=1930,
        title="字符串中第二大的数字",
        tags=["字符串", "哈希表"],
        description="""给定一个包含字母和数字的字符串 s
返回字符串中出现过的第二大不同数字
如果不存在第二大的不同数字，返回 -1""",
        function="secondHighest",
        params=[("s", "string")],
        returns="int",
        solver=second_highest,
        public=[["dfa12321afd"], ["abc1111"], ["ck077"]],
        hidden=[["abc"], ["a1b2c3"], ["999"], ["0"], ["102"]],
    ),
    make(
        pid=1931,
        title="最大升序子数组和",
        tags=["数组"],
        description="""给定一个正整数数组 nums
返回所有严格递增的连续子数组中的最大元素和
子数组至少包含一个元素""",
        function="maxAscendingSum",
        params=[("nums", "int[]")],
        returns="int",
        solver=max_ascending_sum,
        public=[
            [[10, 20, 30, 5, 10, 50]],
            [[10, 20, 30, 40, 50]],
            [[12, 17, 15, 13, 10, 11, 12]],
            [[100, 10, 1]],
        ],
        hidden=[
            [[1]],
            [[5, 4, 3]],
            [[1, 2]],
            [[2, 1, 3]],
            [[1, 2, 3, 0, 5]],
        ],
    ),
    make(
        pid=1932,
        title="字符串中不同整数的数目",
        tags=["字符串", "哈希表"],
        description="""给定一个由字母和数字组成的字符串 word
连续的若干位数字组成一个整数，前导零不影响整数的大小
返回字符串中不同整数的数目
例如 "01" 和 "1" 视为同一个整数""",
        function="numDifferentIntegers",
        params=[("word", "string")],
        returns="int",
        solver=num_different_integers,
        public=[
            ["a123bc34d8ef34"],
            ["leet1234code234"],
            ["a1b01c001"],
        ],
        hidden=[
            ["abc"],
            ["0"],
            ["000"],
            ["a0b00c000"],
            ["123"],
            ["a1b2c3"],
        ],
    ),
    make(
        pid=1933,
        title="数组元素积的符号",
        tags=["数组", "数学"],
        description="""给定一个整数数组 nums
计算所有元素乘积的符号：乘积为正返回 1，为负返回 -1，为 0 返回 0
注意不需要求出实际乘积""",
        function="arraySign",
        params=[("nums", "int[]")],
        returns="int",
        solver=array_sign,
        public=[
            [[-1, -2, -3, -4, 3, 2, 1]],
            [[1, 5, 0, 2, -3]],
            [[-1, 1, -1, 1, -1]],
        ],
        hidden=[
            [[1]],
            [[-1]],
            [[0]],
            [[1, 2, 3]],
            [[-1, -2]],
            [[0, -1]],
        ],
    ),
    make(
        pid=1934,
        title="判断句子是否为全字母句",
        tags=["字符串", "哈希表"],
        description="""给定一个只含小写英文字母的字符串 sentence
如果句子中至少出现一次从 a 到 z 的全部 26 个字母，返回 true，否则返回 false""",
        function="checkIfPangram",
        params=[("sentence", "string")],
        returns="bool",
        solver=check_if_pangram,
        public=[
            ["thequickbrownfoxjumpsoverthelazydog"],
            ["leetcode"],
            ["abcdefghijklmnopqrstuvwxyz"],
        ],
        hidden=[
            ["a"],
            ["abcdefghijklmnopqrstuvwxyzabc"],
            ["thequickbrownfoxjumpsoverthelazydogz"],
            ["abcde"],
            ["zyxwvutsrqponmlkjihgfedcba"],
        ],
    ),
    make(
        pid=1935,
        title="将所有数字用字符替换",
        tags=["字符串", "模拟"],
        description="""给定一个字符串 s，偶数下标为小写字母，奇数下标为数字
对于每个奇数下标 i，将数字 d = s[i] 替换为字母 s[i - 1] 向后移动 d 位得到的字母
题目保证替换后的字母仍为小写字母，返回替换后的字符串""",
        function="replaceDigits",
        params=[("s", "string")],
        returns="string",
        solver=replace_digits,
        public=[
            ["a1c1e1"],
            ["a1b2c3d4e"],
            ["z0"],
        ],
        hidden=[
            ["a0"],
            ["b3"],
            ["m5"],
            ["x2"],
            ["c2d4"],
            ["y1"],
        ],
    ),
    make(
        pid=1936,
        title="人口最多的年份",
        tags=["数组", "前缀和"],
        description="""给定二维整数数组 logs，其中 logs[i] = [birth_i, death_i] 表示第 i 个人的出生和死亡年份
一个人在 [birth_i, death_i) 区间内计入人口，即死亡当年不计入
返回人口最多且最早的年份""",
        function="maximumPopulation",
        params=[("logs", "int[][]")],
        returns="int",
        solver=maximum_population,
        public=[
            [[[1993, 1999], [2000, 2010]]],
            [[[1950, 1961], [1960, 1971], [1970, 1981]]],
            [[[2030, 2040], [2035, 2045]]],
        ],
        hidden=[
            [[[2000, 2001]]],
            [[[1950, 1951], [1951, 1952]]],
            [[[1960, 1970], [1960, 1970]]],
            [[[1950, 2050]]],
            [[[2000, 2010], [2001, 2009]]],
        ],
    ),
    make(
        pid=1937,
        title="将句子排序",
        tags=["字符串", "排序"],
        description="""给定一个句子 s，单词之间用一个空格分隔
每个单词的末尾都有一个 1 到 9 的数字，表示它在原句中的位置，且每个位置恰好出现一次
按这些位置数字升序重新排列单词，并去掉末尾数字
返回恢复后的句子""",
        function="sortSentence",
        params=[("s", "string")],
        returns="string",
        solver=sort_sentence,
        public=[
            ["is2 sentence4 This1 a3"],
            ["Myself2 Me1 I4 and3"],
            ["world2 hello1"],
        ],
        hidden=[
            ["a1"],
            ["b2 a1"],
            ["c3 a1 b2"],
            ["word1"],
            ["z9 a1"],
        ],
    ),
]

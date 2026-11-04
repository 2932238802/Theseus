#!/usr/bin/env python3
"""生成 `seed_problems_100.sql`：1200-1299 共 100 道新增函数式题目。

用法：
    python3 scripts/generate_extra_problem_seed.py            # 重写 seed_problems_100.sql
    python3 scripts/generate_extra_problem_seed.py --dry-run  # 只校验并打印统计
    python3 scripts/generate_extra_problem_seed.py --check    # 校验现有 seed 文件是否最新

题库由原有 100 题（seed_dev.sql、seed_problems_15.sql、seed_problems_82.sql）
与本脚本生成的 100 道题共同组成，合计 200 题。
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import Counter
from pathlib import Path

from problem_catalog_easy import PROBLEMS as BASE_EASY
from problem_catalog_extra_easy import PROBLEMS as EXTRA_EASY
from problem_catalog_extra_hard import PROBLEMS as EXTRA_HARD
from problem_catalog_extra_medium import PROBLEMS as EXTRA_MEDIUM
from problem_catalog_hard import PROBLEMS as BASE_HARD
from problem_catalog_medium import PROBLEMS as BASE_MEDIUM
from problem_seed_common import Problem, render_sql, validate_problem

SEED_PATH = Path(__file__).resolve().parent / "seed_problems_100.sql"
BASE_SEED_PATHS = [
    Path(__file__).resolve().parent / name
    for name in ("seed_dev.sql", "seed_problems_15.sql", "seed_problems_82.sql")
]
FIRST_ID = 1200
LAST_ID = 1299
RELATED_SEEDS = (
    "与 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）、"
    "seed_problems_82.sql（1116-1197）合计 200 题。"
)


def load_problems() -> list[Problem]:
    problems = EXTRA_EASY + EXTRA_MEDIUM + EXTRA_HARD
    expected_ids = list(range(FIRST_ID, LAST_ID + 1))
    ids = [problem.pid for problem in problems]
    if ids != expected_ids:
        raise SystemExit(
            f"题目 ID 必须是 {FIRST_ID}-{LAST_ID} 的连续序列，当前为 {ids[:3]}...{ids[-3:]}"
        )
    titles = [problem.title for problem in problems]
    duplicates = [title for title, count in Counter(titles).items() if count > 1]
    if duplicates:
        raise SystemExit(f"新增题目标题重复：{duplicates}")
    base_titles = {problem.title for problem in BASE_EASY + BASE_MEDIUM + BASE_HARD}
    for path in BASE_SEED_PATHS:
        text = path.read_text(encoding="utf-8")
        base_titles.update(
            title.replace("''", "'")
            for _, title in re.findall(r"\n    (\d+),\n    '((?:[^']|'')*)',", text)
        )
    overlaps = [title for title in titles if title in base_titles]
    if overlaps:
        raise SystemExit(f"新增题目与原有 100 题重名：{overlaps}")
    return problems


def print_stats(problems: list[Problem]) -> None:
    difficulties = Counter(problem.difficulty for problem in problems)
    total_cases = sum(len(problem.hidden) + len(problem.public) for problem in problems)
    print(f"题目数量：{len(problems)}（{FIRST_ID}-{LAST_ID}）")
    print(
        "难度分布："
        f"简单 {difficulties['easy']} / 中等 {difficulties['medium']} / 困难 {difficulties['hard']}"
    )
    print(f"用例总数：{total_cases}（含公开用例）")
    print(f"标签数量：{len({tag for problem in problems for tag in problem.tags})}")


def main() -> int:
    parser = argparse.ArgumentParser(description="生成 100 道新增题的种子 SQL")
    parser.add_argument("--dry-run", action="store_true", help="只校验并打印统计")
    parser.add_argument("--check", action="store_true", help="校验现有文件是否需要更新")
    args = parser.parse_args()

    problems = load_problems()
    for problem in problems:
        validate_problem(problem)
    print_stats(problems)

    sql = render_sql(problems, related_seeds=RELATED_SEEDS)
    if args.dry_run:
        return 0
    if args.check:
        existing = SEED_PATH.read_text(encoding="utf-8") if SEED_PATH.exists() else ""
        if existing != sql:
            print(f"{SEED_PATH.name} 不是最新版本，请重新运行本脚本", file=sys.stderr)
            return 1
        print(f"{SEED_PATH.name} 已是最新版本")
        return 0

    SEED_PATH.write_text(sql, encoding="utf-8", newline="\n")
    print(f"已写入 {SEED_PATH}（{len(sql.encode('utf-8')) / 1024:.1f} KB）")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

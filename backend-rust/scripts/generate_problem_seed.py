#!/usr/bin/env python3
"""生成 `seed_problems_82.sql`：1116-1197 共 82 道函数式题目。

用法：
    python3 scripts/generate_problem_seed.py            # 重写 seed_problems_82.sql
    python3 scripts/generate_problem_seed.py --dry-run  # 只校验并打印统计
    python3 scripts/generate_problem_seed.py --check    # 校验现有 seed 文件是否最新

题库由 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）和本脚本生成的
82 道题共同组成，合计 100 题。

每道题的 hidden 用例由 `problem_catalog_*.py` 里的参考解算出 expected，
因此修改题目参数或参考解后重新运行本脚本即可；输出完全确定，可进版本库。
"""

from __future__ import annotations

import argparse
import sys
from collections import Counter
from pathlib import Path

from problem_catalog_easy import PROBLEMS as EASY
from problem_catalog_hard import PROBLEMS as HARD
from problem_catalog_medium import PROBLEMS as MEDIUM
from problem_seed_common import Problem, render_sql, validate_problem

SEED_PATH = Path(__file__).resolve().parent / "seed_problems_82.sql"
FIRST_ID = 1116
LAST_ID = 1197


def load_problems() -> list[Problem]:
    problems = EASY + MEDIUM + HARD
    expected_ids = list(range(FIRST_ID, LAST_ID + 1))
    ids = [problem.pid for problem in problems]
    if ids != expected_ids:
        raise SystemExit(
            f"题目 ID 必须是 {FIRST_ID}-{LAST_ID} 的连续序列，当前为 {ids[:3]}...{ids[-3:]}"
        )
    titles = [problem.title for problem in problems]
    duplicates = [title for title, count in Counter(titles).items() if count > 1]
    if duplicates:
        raise SystemExit(f"题目标题重复：{duplicates}")
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
    parser = argparse.ArgumentParser(description="生成 82 道题的种子 SQL")
    parser.add_argument("--dry-run", action="store_true", help="只校验并打印统计")
    parser.add_argument("--check", action="store_true", help="校验现有文件是否需要更新")
    args = parser.parse_args()

    problems = load_problems()
    # 每道题的 public 用例都会用参考解重新计算一次，提前暴露参考答案错误。
    for problem in problems:
        validate_problem(problem)
    print_stats(problems)

    sql = render_sql(problems)
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

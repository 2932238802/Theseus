#!/usr/bin/env python3
"""生成批量题库种子 SQL。

当前支持第一批（1300-1499）、第二批（1500-1699）、第三批（1700-1899）与第四批（1900-2099），每批 200 道新增函数式题目。

用法：
    python3 scripts/generate_bulk_problem_seed.py --batch 1            # 重写 seed_problems_batch1.sql
    python3 scripts/generate_bulk_problem_seed.py --batch 2            # 重写 seed_problems_batch2.sql
    python3 scripts/generate_bulk_problem_seed.py --batch 3            # 重写 seed_problems_batch3.sql
    python3 scripts/generate_bulk_problem_seed.py --batch 4            # 重写 seed_problems_batch4.sql
    python3 scripts/generate_bulk_problem_seed.py --batch 4 --dry-run  # 只校验并打印统计
    python3 scripts/generate_bulk_problem_seed.py --batch 4 --check    # 校验现有 seed 文件是否最新

题库由原有 200 题（seed_dev.sql、seed_problems_15.sql、seed_problems_82.sql、
seed_problems_100.sql）与四批新增题共同组成，合计 1000 题。
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import Counter
from pathlib import Path

import problem_catalog_b1_easy_1
import problem_catalog_b1_easy_2
import problem_catalog_b1_hard_1
import problem_catalog_b1_hard_2
import problem_catalog_b1_medium_1
import problem_catalog_b1_medium_2
import problem_catalog_b2_easy_1
import problem_catalog_b2_easy_2
import problem_catalog_b2_hard_1
import problem_catalog_b2_hard_2
import problem_catalog_b2_medium_1
import problem_catalog_b2_medium_2
import problem_catalog_b3_easy_1
import problem_catalog_b3_easy_2
import problem_catalog_b3_hard_1
import problem_catalog_b3_hard_2
import problem_catalog_b3_medium_1
import problem_catalog_b3_medium_2
import problem_catalog_b4_easy_1
import problem_catalog_b4_easy_2
import problem_catalog_b4_hard_1
import problem_catalog_b4_hard_2
import problem_catalog_b4_medium_1
import problem_catalog_b4_medium_2
from problem_catalog_easy import PROBLEMS as BASE_EASY
from problem_catalog_extra_easy import PROBLEMS as EXTRA_EASY
from problem_catalog_extra_hard import PROBLEMS as EXTRA_HARD
from problem_catalog_extra_medium import PROBLEMS as EXTRA_MEDIUM
from problem_catalog_hard import PROBLEMS as BASE_HARD
from problem_catalog_medium import PROBLEMS as BASE_MEDIUM
from problem_seed_common import Problem, render_sql, validate_problem

SCRIPT_DIR = Path(__file__).resolve().parent
BASE_SEED_PATHS = [
    SCRIPT_DIR / name
    for name in (
        "seed_dev.sql",
        "seed_problems_15.sql",
        "seed_problems_82.sql",
        "seed_problems_100.sql",
    )
]

BATCHES = {
    1: {
        "first_id": 1300,
        "last_id": 1499,
        "seed_path": SCRIPT_DIR / "seed_problems_batch1.sql",
        "modules": (
            problem_catalog_b1_easy_1,
            problem_catalog_b1_easy_2,
            problem_catalog_b1_medium_1,
            problem_catalog_b1_medium_2,
            problem_catalog_b1_hard_1,
            problem_catalog_b1_hard_2,
        ),
        "related_seeds": (
            "与 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）、"
            "seed_problems_82.sql（1116-1197）、seed_problems_100.sql（1200-1299）"
            "合计 400 题。"
        ),
    },
    2: {
        "first_id": 1500,
        "last_id": 1699,
        "seed_path": SCRIPT_DIR / "seed_problems_batch2.sql",
        "modules": (
            problem_catalog_b2_easy_1,
            problem_catalog_b2_easy_2,
            problem_catalog_b2_medium_1,
            problem_catalog_b2_medium_2,
            problem_catalog_b2_hard_1,
            problem_catalog_b2_hard_2,
        ),
        "related_seeds": (
            "与 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）、"
            "seed_problems_82.sql（1116-1197）、seed_problems_100.sql（1200-1299）、"
            "seed_problems_batch1.sql（1300-1499）合计 600 题。"
        ),
    },
    3: {
        "first_id": 1700,
        "last_id": 1899,
        "seed_path": SCRIPT_DIR / "seed_problems_batch3.sql",
        "modules": (
            problem_catalog_b3_easy_1,
            problem_catalog_b3_easy_2,
            problem_catalog_b3_medium_1,
            problem_catalog_b3_medium_2,
            problem_catalog_b3_hard_1,
            problem_catalog_b3_hard_2,
        ),
        "related_seeds": (
            "与 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）、"
            "seed_problems_82.sql（1116-1197）、seed_problems_100.sql（1200-1299）、"
            "seed_problems_batch1.sql（1300-1499）、seed_problems_batch2.sql（1500-1699）"
            "合计 800 题。"
        ),
    },
    4: {
        "first_id": 1900,
        "last_id": 2099,
        "seed_path": SCRIPT_DIR / "seed_problems_batch4.sql",
        "modules": (
            problem_catalog_b4_easy_1,
            problem_catalog_b4_easy_2,
            problem_catalog_b4_medium_1,
            problem_catalog_b4_medium_2,
            problem_catalog_b4_hard_1,
            problem_catalog_b4_hard_2,
        ),
        "related_seeds": (
            "与 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）、"
            "seed_problems_82.sql（1116-1197）、seed_problems_100.sql（1200-1299）、"
            "seed_problems_batch1.sql（1300-1499）、seed_problems_batch2.sql（1500-1699）、"
            "seed_problems_batch3.sql（1700-1899）合计 1000 题。"
        ),
    },
}


def load_problems(batch: int) -> tuple[list[Problem], dict]:
    if batch not in BATCHES:
        raise SystemExit(f"未知批次 {batch}，当前仅支持：{sorted(BATCHES)}")
    config = BATCHES[batch]
    problems: list[Problem] = []
    for module in config["modules"]:
        problems.extend(module.PROBLEMS)

    first_id, last_id = config["first_id"], config["last_id"]
    expected_ids = list(range(first_id, last_id + 1))
    ids = [problem.pid for problem in problems]
    if ids != expected_ids:
        raise SystemExit(
            f"题目 ID 必须是 {first_id}-{last_id} 的连续序列，"
            f"当前为 {ids[:3]}...{ids[-3:]}"
        )

    titles = [problem.title for problem in problems]
    duplicates = [title for title, count in Counter(titles).items() if count > 1]
    if duplicates:
        raise SystemExit(f"批次 {batch} 内题目标题重复：{duplicates}")

    base_titles = {
        problem.title
        for problem in BASE_EASY + BASE_MEDIUM + BASE_HARD + EXTRA_EASY + EXTRA_MEDIUM + EXTRA_HARD
    }
    for path in BASE_SEED_PATHS:
        text = path.read_text(encoding="utf-8")
        base_titles.update(
            title.replace("''", "'")
            for _, title in re.findall(r"\n    (\d+),\n    '((?:[^']|'')*)',", text)
        )
    for other_batch, other_config in BATCHES.items():
        if other_batch == batch:
            continue
        for module in other_config["modules"]:
            base_titles.update(problem.title for problem in module.PROBLEMS)
    overlaps = [title for title in titles if title in base_titles]
    if overlaps:
        raise SystemExit(f"新增题目与原有题库重名：{overlaps}")

    return problems, config


def print_stats(problems: list[Problem], config: dict) -> None:
    difficulties = Counter(problem.difficulty for problem in problems)
    total_cases = sum(len(problem.hidden) + len(problem.public) for problem in problems)
    print(f"题目数量：{len(problems)}（{config['first_id']}-{config['last_id']}）")
    print(
        "难度分布："
        f"简单 {difficulties['easy']} / 中等 {difficulties['medium']} / 困难 {difficulties['hard']}"
    )
    print(f"用例总数：{total_cases}（含公开用例）")
    print(f"标签数量：{len({tag for problem in problems for tag in problem.tags})}")


def main() -> int:
    parser = argparse.ArgumentParser(description="生成批量题库种子 SQL")
    parser.add_argument("--batch", type=int, default=1, help="批次编号，默认 1")
    parser.add_argument("--dry-run", action="store_true", help="只校验并打印统计")
    parser.add_argument("--check", action="store_true", help="校验现有文件是否需要更新")
    args = parser.parse_args()

    problems, config = load_problems(args.batch)
    for problem in problems:
        validate_problem(problem)
    print_stats(problems, config)

    sql = render_sql(problems, related_seeds=config["related_seeds"])
    seed_path: Path = config["seed_path"]
    if args.dry_run:
        return 0
    if args.check:
        existing = seed_path.read_text(encoding="utf-8") if seed_path.exists() else ""
        if existing != sql:
            print(f"{seed_path.name} 不是最新版本，请重新运行本脚本", file=sys.stderr)
            return 1
        print(f"{seed_path.name} 已是最新版本")
        return 0

    seed_path.write_text(sql, encoding="utf-8", newline="\n")
    print(f"已写入 {seed_path}（{len(sql.encode('utf-8')) / 1024:.1f} KB）")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

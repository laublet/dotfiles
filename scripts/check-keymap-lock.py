#!/usr/bin/env python3
"""Validate cross-tool keymap lock against Nvim/WezTerm references."""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


@dataclass
class FileRule:
    family: str
    path: str
    must_contain: list[str] = field(default_factory=list)
    must_not_contain: list[str] = field(default_factory=list)


RULES: list[FileRule] = [
    # Nvim remains the reference for editor-level split semantics.
    FileRule(
        family="split_and_ai_reference",
        path="conf/nvim/lua/keymaps.lua",
        must_contain=[
            r'map\("n", "<leader>\|", ":vsplit<CR>"',
            r'map\("n", "<leader>-", ":split<CR>"',
            r'map\("n", "<leader>x", "<C-w>q"',
            r'map\("n", "<leader>a", function\(\) vscode\.action\("workbench\.action\.chat\.open"\) end, opts\)',
            r'map\("n", "<leader>v", function\(\) vscode\.action\("workbench\.action\.showCommands"\) end, opts\)',
            r'map\("n", "<leader>V", function\(\) vscode\.action\("workbench\.view\.scm"\) end, opts\)',
        ],
        must_not_contain=[
            r'map\("n", "<leader>c", function\(\) vscode\.action\("workbench\.action\.chat\.open"\) end, opts\)',
        ],
    ),
    # WezTerm remains the reference for app-level split semantics.
    FileRule(
        family="split_and_ai_reference",
        path="conf/wezterm/.wezterm.lua",
        must_contain=[
            r'action = act\.SplitHorizontal\(\{ domain = "CurrentPaneDomain" \}\)',
            r'action = act\.SplitVertical\(\{ domain = "CurrentPaneDomain" \}\)',
            r'-- Split creation: Cmd\+d / Cmd\+Shift\+d',
        ],
    ),
    # Cursor editor split must follow WezTerm semantics.
    FileRule(
        family="split_and_ai_reference",
        path="conf/cursor/keybindings.json",
        must_contain=[
            r'"command": "workbench\.action\.splitEditorDown"',
            r'"command": "workbench\.action\.splitEditor"',
            r'Space\+a  AI chat',
        ],
    ),
    # Zed split + close alias policy.
    FileRule(
        family="close_semantics",
        path="conf/zed/keymap.json",
        must_contain=[
            r'"cmd-d": "pane::SplitDown"',
            r'"cmd-shift-d": "pane::SplitRight"',
            r'"space q": "pane::CloseActiveItem"',
        ],
        must_not_contain=[
            r'"space x": "pane::CloseActiveItem"',
        ],
    ),
    # Obsidian keeps adapted leader choices.
    FileRule(
        family="obsidian_adaptation",
        path="conf/obsidian/obsidian-vimrc",
        must_contain=[
            r"nmap <Space>s :globalSearch",
            r"nmap <Space>u :toggleRightSidebar",
            r"nmap <Space>v :commandPalette",
            r"nmap <Space>V :togglePreview",
            r"nmap <Space>X :toggleChecklist",
        ],
        must_not_contain=[
            r"nmap <Space>g :globalSearch",
            r"nmap <Space>r :toggleRightSidebar",
            r"nmap <Space>x :toggleChecklist",
        ],
    ),
]


def check_rule(rule: FileRule) -> list[dict[str, str]]:
    problems: list[dict[str, str]] = []
    path = ROOT / rule.path
    if not path.exists():
        return [
            {
                "family": rule.family,
                "path": rule.path,
                "kind": "missing_file",
                "pattern": "",
                "message": f"[MISSING FILE] {rule.path}",
            }
        ]

    text = path.read_text(encoding="utf-8")

    for pattern in rule.must_contain:
        if not re.search(pattern, text, re.MULTILINE):
            problems.append(
                {
                    "family": rule.family,
                    "path": rule.path,
                    "kind": "missing",
                    "pattern": pattern,
                    "message": f"[MISSING] {rule.path} :: /{pattern}/",
                }
            )

    for pattern in rule.must_not_contain:
        if re.search(pattern, text, re.MULTILINE):
            problems.append(
                {
                    "family": rule.family,
                    "path": rule.path,
                    "kind": "forbidden",
                    "pattern": pattern,
                    "message": f"[FORBIDDEN] {rule.path} :: /{pattern}/",
                }
            )

    return problems


def summarize_by_family(results: list[dict[str, str]]) -> dict[str, int]:
    summary: dict[str, int] = {}
    for row in results:
        summary[row["family"]] = summary.get(row["family"], 0) + 1
    return summary


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Check cross-tool keymap lock (Nvim/WezTerm references)."
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Emit machine-readable JSON output.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    errors: list[dict[str, str]] = []
    for rule in RULES:
        errors.extend(check_rule(rule))

    checked_files = sorted({r.path for r in RULES})
    payload = {
        "ok": len(errors) == 0,
        "checked_files": checked_files,
        "families": sorted({r.family for r in RULES}),
        "error_count": len(errors),
        "error_count_by_family": summarize_by_family(errors),
        "errors": errors,
    }

    if args.json:
        print(json.dumps(payload, indent=2, sort_keys=True))
        return 0 if payload["ok"] else 1

    if errors:
        print("Keymap lock check FAILED:")
        for family, count in sorted(payload["error_count_by_family"].items()):
            print(f" - {family}: {count} issue(s)")
        print("")
        for err in errors:
            print(f" - {err['message']}")
        return 1

    print("Keymap lock check OK.")
    print(f"Checked files: {len(checked_files)}")
    print("Families: " + ", ".join(payload["families"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())

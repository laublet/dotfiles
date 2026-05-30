#!/usr/bin/env python3
"""Bookmark triage workflow helper.

Features:
- Categorize reject-low-score.csv into themed buckets.
- Create per-category CSV files for fast manual review.
- Generate keepers delta since last snapshot.
- Optionally update snapshot after review.
"""

from __future__ import annotations

import argparse
import csv
import json
from collections import defaultdict
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, Iterable, List
from urllib.parse import parse_qs, urlencode, urlparse, urlunparse


TRACKING_PARAMS = {
    "utm_source",
    "utm_medium",
    "utm_campaign",
    "utm_term",
    "utm_content",
    "gclid",
    "fbclid",
    "mc_cid",
    "mc_eid",
    "hsa_acc",
    "hsa_cam",
    "hsa_grp",
    "hsa_ad",
    "hsa_src",
    "hsa_tgt",
    "hsa_kw",
    "hsa_mt",
    "hsa_net",
    "hsa_ver",
    "matchtype",
    "targetid",
}


@dataclass(frozen=True)
class CategoryRule:
    name: str
    keywords: tuple[str, ...]
    suggested_list: str


CATEGORY_RULES: tuple[CategoryRule, ...] = (
    CategoryRule("work", ("notion.so", "gitlab.com", "jira", "confluence"), "dev"),
    CategoryRule("dev-docs", ("developer.mozilla.org", "docs.", "api.", "stackoverflow.com"), "dev"),
    CategoryRule("cloud-devops", ("aws.amazon.com", "console.aws.", "cloudwatch"), "dev"),
    CategoryRule("homelab", ("192.168.", ".home.loicaublet.fr", "docker", "jellyfin"), "dev"),
    CategoryRule("learning", ("course", "tutorial", "udemy", "learn"), "read-later"),
    CategoryRule("news-tech", ("news.ycombinator.com", "lobste.rs", "medium.com"), "read-later"),
    CategoryRule("social-media", ("reddit.com", "youtube.com", "x.com", "twitter.com"), "read-later"),
    CategoryRule("shopping", ("amazon.", "aliexpress.", "ebay."), "read-later"),
    CategoryRule("language-writing", ("deepl.com", "scribens", "bonpatron"), "read-later"),
    CategoryRule("finance-admin", ("impots.gouv.fr", "ameli.fr", "banque", "urssaf"), "read-later"),
)


def normalize_url(url: str) -> str:
    value = (url or "").strip()
    if not value:
        return ""
    parsed = urlparse(value)
    if parsed.scheme not in ("http", "https"):
        return value.lower()
    host = (parsed.hostname or "").lower()
    if host.startswith("www."):
        host = host[4:]
    path = parsed.path or "/"
    if path != "/" and path.endswith("/"):
        path = path.rstrip("/")
    query_items = []
    for key, values in parse_qs(parsed.query, keep_blank_values=True).items():
        if key.lower() in TRACKING_PARAMS:
            continue
        for one in values:
            query_items.append((key, one))
    query_items.sort()
    query = urlencode(query_items, doseq=True) if query_items else ""
    return urlunparse((parsed.scheme.lower(), host, path, "", query, ""))


def detect_category(name: str, url: str, folder: str) -> tuple[str, str]:
    blob = f"{name} {url} {folder}".lower()
    for rule in CATEGORY_RULES:
        if any(keyword in blob for keyword in rule.keywords):
            return rule.name, rule.suggested_list
    return "misc", "read-later"


def read_csv_rows(path: Path) -> List[Dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle)
        rows = list(reader)
    if not rows:
        return []

    # User edit safety: tolerate common typo "n jame".
    for row in rows:
        if "name" not in row or not row.get("name"):
            row["name"] = row.get("n jame", "") or row.get("title", "")
    return rows


def write_csv(path: Path, rows: Iterable[Dict[str, str]], fields: list[str]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def build_reject_categories(triage_dir: Path) -> None:
    reject_path = triage_dir / "reject-low-score.csv"
    reject_rows = read_csv_rows(reject_path)
    if not reject_rows:
        return

    categorized: list[Dict[str, str]] = []
    by_category: dict[str, list[Dict[str, str]]] = defaultdict(list)

    for row in reject_rows:
        name = row.get("name", "")
        url = row.get("url", "")
        folder = row.get("folder", "")
        category, suggested_list = detect_category(name, url, folder)
        item = dict(row)
        item["category"] = category
        item["suggested_list"] = suggested_list
        item["norm_url"] = row.get("norm_url") or normalize_url(url)
        categorized.append(item)
        by_category[category].append(item)

    fields = list(categorized[0].keys())
    write_csv(triage_dir / "reject-categorized.csv", categorized, fields)

    category_dir = triage_dir / "reject-by-category"
    category_dir.mkdir(parents=True, exist_ok=True)
    for category, rows in sorted(by_category.items()):
        write_csv(category_dir / f"{category}.csv", rows, fields)


def build_keepers_categories(triage_dir: Path) -> None:
    keepers_path = triage_dir / "keepers.csv"
    keepers_rows = read_csv_rows(keepers_path)
    if not keepers_rows:
        return

    categorized: list[Dict[str, str]] = []
    by_category: dict[str, list[Dict[str, str]]] = defaultdict(list)
    for row in keepers_rows:
        name = row.get("name", "")
        url = row.get("url", "")
        folder = row.get("folder", "")
        category, suggested_list = detect_category(name, url, folder)
        item = dict(row)
        item["category"] = category
        item["suggested_list"] = suggested_list
        item["norm_url"] = row.get("norm_url") or normalize_url(url)
        categorized.append(item)
        by_category[category].append(item)

    fields = list(categorized[0].keys())
    write_csv(triage_dir / "keepers-categorized.csv", categorized, fields)

    category_dir = triage_dir / "keepers-by-category"
    category_dir.mkdir(parents=True, exist_ok=True)
    for category, rows in sorted(by_category.items()):
        write_csv(category_dir / f"{category}.csv", rows, fields)


def keeper_norm_map(rows: Iterable[Dict[str, str]]) -> Dict[str, Dict[str, str]]:
    result: Dict[str, Dict[str, str]] = {}
    for row in rows:
        url = row.get("url", "")
        norm = row.get("norm_url") or normalize_url(url)
        if not norm:
            continue
        if norm not in result:
            result[norm] = row
    return result


def build_keeper_diff(triage_dir: Path, update_snapshot: bool) -> None:
    keepers_path = triage_dir / "keepers.csv"
    keepers_rows = read_csv_rows(keepers_path)
    keepers_map = keeper_norm_map(keepers_rows)

    snapshot_path = triage_dir / "keepers.snapshot.json"
    now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

    if snapshot_path.exists():
        snapshot = json.loads(snapshot_path.read_text(encoding="utf-8"))
        old_norms = set(snapshot.get("norm_urls", []))
    else:
        snapshot = {"created_at": now, "norm_urls": []}
        old_norms = set()

    current_norms = set(keepers_map.keys())
    added_norms = sorted(current_norms - old_norms)
    removed_norms = sorted(old_norms - current_norms)

    diff_rows = []
    for norm in added_norms:
        row = dict(keepers_map[norm])
        row["change"] = "added"
        row["norm_url"] = norm
        diff_rows.append(row)
    for norm in removed_norms:
        diff_rows.append(
            {
                "change": "removed",
                "name": "",
                "url": "",
                "norm_url": norm,
                "folder": "",
                "sources": "",
                "source_count": "",
                "visit_count": "",
                "score": "",
                "copies": "",
                "list": "",
            }
        )

    diff_fields = [
        "change",
        "name",
        "url",
        "norm_url",
        "folder",
        "sources",
        "source_count",
        "visit_count",
        "score",
        "copies",
        "list",
    ]
    write_csv(triage_dir / "keepers-diff.csv", diff_rows, diff_fields)

    if update_snapshot or not snapshot_path.exists():
        snapshot_payload = {
            "updated_at": now,
            "norm_urls": sorted(current_norms),
            "count": len(current_norms),
        }
        snapshot_path.write_text(
            json.dumps(snapshot_payload, ensure_ascii=True, indent=2) + "\n",
            encoding="utf-8",
        )


def sync_keepers_import_csv(triage_dir: Path) -> None:
    keepers_rows = read_csv_rows(triage_dir / "keepers.csv")
    import_rows = []
    for row in keepers_rows:
        import_rows.append(
            {
                "url": row.get("url", ""),
                "title": row.get("name", ""),
                "tags": "imported",
                "list": row.get("list", "") or "read-later",
            }
        )
    write_csv(
        triage_dir / "keepers-karakeep-import.csv",
        import_rows,
        ["url", "title", "tags", "list"],
    )


def main() -> int:
    parser = argparse.ArgumentParser(description="Bookmark triage helper workflow")
    parser.add_argument(
        "--triage-dir",
        required=True,
        help="Path to triage directory containing keepers.csv/reject-low-score.csv",
    )
    parser.add_argument(
        "--update-snapshot",
        action="store_true",
        help="Write current keepers as new baseline snapshot after generating diff",
    )
    args = parser.parse_args()

    triage_dir = Path(args.triage_dir).expanduser().resolve()
    build_reject_categories(triage_dir)
    build_keepers_categories(triage_dir)
    sync_keepers_import_csv(triage_dir)
    build_keeper_diff(triage_dir, update_snapshot=args.update_snapshot)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

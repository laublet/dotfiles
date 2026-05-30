#!/usr/bin/env python3
"""HTTP-check URLs in keepers.csv (or any CSV with a url column)."""

from __future__ import annotations

import argparse
import csv
import ssl
import sys
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

USER_AGENT = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
    "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
)
DEFAULT_INPUT = Path.home() / (
    "dev/perso/vaults/Research/Inbox/karakeep-bookmarks-export/triage/keepers.csv"
)


@dataclass
class CheckResult:
    url: str
    status: str  # ok | redirect | client_error | server_error | timeout | error | skip
    http_code: str
    final_url: str
    note: str


def check_url(url: str, timeout: float) -> CheckResult:
    url = (url or "").strip()
    if not url:
        return CheckResult(url, "skip", "", "", "empty url")
    if not url.startswith(("http://", "https://")):
        return CheckResult(url, "skip", "", "", "not http(s)")

    req = urllib.request.Request(url, method="HEAD", headers={"User-Agent": USER_AGENT})

    def fetch(method: str) -> tuple[int, str]:
        r = urllib.request.Request(url, method=method, headers={"User-Agent": USER_AGENT})
        with urllib.request.urlopen(r, timeout=timeout) as resp:
            return resp.status, resp.geturl()

    try:
        try:
            code, final = fetch("HEAD")
        except urllib.error.HTTPError as e:
            if e.code in (405, 501, 403):
                code, final = fetch("GET")
            else:
                raise
        bucket = "ok" if code < 400 else "client_error" if code < 500 else "server_error"
        if 300 <= code < 400:
            bucket = "redirect"
        return CheckResult(url, bucket, str(code), final, "")
    except urllib.error.HTTPError as e:
        bucket = "client_error" if e.code < 500 else "server_error"
        return CheckResult(url, bucket, str(e.code), e.geturl() if e.fp else url, str(e.reason))
    except urllib.error.URLError as e:
        reason = e.reason
        if isinstance(reason, TimeoutError) or "timed out" in str(reason).lower():
            return CheckResult(url, "timeout", "", url, str(reason))
        if isinstance(reason, ssl.SSLError):
            return CheckResult(url, "error", "", url, f"ssl: {reason}")
        return CheckResult(url, "error", "", url, str(reason))
    except TimeoutError:
        return CheckResult(url, "timeout", "", url, "timeout")
    except Exception as e:  # noqa: BLE001
        return CheckResult(url, "error", "", url, str(e))


def load_rows(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def write_report(rows: list[dict[str, str]], results: dict[str, CheckResult], out: Path) -> None:
    fieldnames = list(rows[0].keys()) + ["url_status", "http_code", "final_url", "url_note"]
    with out.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        w.writeheader()
        for row in rows:
            r = results.get(row.get("url", "").strip(), CheckResult("", "skip", "", "", "missing"))
            row = dict(row)
            row["url_status"] = r.status
            row["http_code"] = r.http_code
            row["final_url"] = r.final_url
            row["url_note"] = r.note
            w.writerow(row)


def summarize(results: Iterable[CheckResult]) -> dict[str, int]:
    counts: dict[str, int] = {}
    for r in results:
        counts[r.status] = counts.get(r.status, 0) + 1
    return counts


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--input", type=Path, default=DEFAULT_INPUT)
    p.add_argument(
        "--output",
        type=Path,
        default=None,
        help="CSV with status columns (default: <input_dir>/keepers-url-status.csv)",
    )
    p.add_argument("--workers", type=int, default=12)
    p.add_argument("--timeout", type=float, default=15.0)
    args = p.parse_args()

    if not args.input.is_file():
        print(f"error: not found: {args.input}", file=sys.stderr)
        return 1

    out = args.output or args.input.parent / "keepers-url-status.csv"
    rows = load_rows(args.input)
    urls = list({(r.get("url") or "").strip() for r in rows if (r.get("url") or "").strip()})

    results: dict[str, CheckResult] = {}
    with ThreadPoolExecutor(max_workers=args.workers) as pool:
        futures = {pool.submit(check_url, u, args.timeout): u for u in urls}
        done = 0
        for fut in as_completed(futures):
            u = futures[fut]
            results[u] = fut.result()
            done += 1
            if done % 10 == 0 or done == len(urls):
                print(f"checked {done}/{len(urls)}", file=sys.stderr)

    write_report(rows, results, out)

    counts = summarize(results.values())
    broken = [r for r in results.values() if r.status in ("client_error", "server_error", "timeout", "error")]

    print(f"\nWrote {out}")
    print("Summary:", ", ".join(f"{k}={v}" for k, v in sorted(counts.items())))

    if broken:
        print(f"\nBroken / unreachable ({len(broken)}):")
        for r in sorted(broken, key=lambda x: x.url):
            extra = f" [{r.http_code}]" if r.http_code else ""
            note = f" — {r.note}" if r.note else ""
            print(f"  {r.status}{extra}: {r.url}{note}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

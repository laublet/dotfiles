#!/usr/bin/env python3
"""Clean Firefox Developer Edition bookmarks to a minimal Daily toolbar folder."""

from __future__ import annotations

import shutil
import sqlite3
import time
import uuid
from pathlib import Path

PROFILE = Path.home() / "Library/Application Support/Firefox/Profiles/2b8ye8ri.dev-edition-default"
DB = PROFILE / "places.sqlite"
BACKUP_ROOT = (
    Path.home()
    / "dev/perso/vaults/Research/Inbox/karakeep-bookmarks-export"
)

# Curated daily shortcuts (title, url)
DAILY: list[tuple[str, str]] = [
    ("Karakeep", "http://karakeep.home.loicaublet.fr"),
    ("Glance", "http://glance.home.loicaublet.fr"),
    ("Jellyfin", "http://jellyfin.home.loicaublet.fr"),
    ("Hacker News", "https://news.ycombinator.com"),
    ("FastMail", "https://www.fastmail.com/mail/Inbox/"),
    ("Keybr", "https://www.keybr.com/"),
    ("IT Tools", "http://tools.home.loicaublet.fr"),
    ("Dockge", "http://docker.home.loicaublet.fr"),
    ("Nextcloud", "https://cloud.loicaublet.fr"),
    ("qBittorrent", "http://qbit.home.loicaublet.fr"),
    ("Reddit", "https://www.reddit.com/"),
    ("YouTube", "https://www.youtube.com/"),
]

SYSTEM_FOLDER_IDS = {1, 2, 3, 4, 5, 6}  # root, menu, toolbar, tags, unfiled, mobile
TOOLBAR_ID = 3
USER_JS = PROFILE / "user.js"
SYNC_PREF = 'user_pref("services.sync.engine.bookmarks", false);'


def disable_bookmark_sync() -> None:
    """Prevent Firefox Sync from re-downloading the old bookmark library."""
    line = SYNC_PREF + "\n"
    if USER_JS.exists():
        content = USER_JS.read_text(encoding="utf-8")
        if SYNC_PREF in content:
            return
        USER_JS.write_text(content.rstrip() + "\n" + line, encoding="utf-8")
    else:
        USER_JS.write_text(line, encoding="utf-8")


def now_us() -> int:
    return int(time.time() * 1_000_000)


def backup_db() -> Path:
    stamp = time.strftime("%Y%m%d-%H%M%S")
    backup_dir = BACKUP_ROOT / f"firefox-clean-{stamp}"
    backup_dir.mkdir(parents=True, exist_ok=True)
    shutil.copy2(DB, backup_dir / "places.sqlite.pre-clean")
    for name in ("places.sqlite-wal", "places.sqlite-shm"):
        src = PROFILE / name
        if src.exists():
            shutil.copy2(src, backup_dir / f"{name}.pre-clean")
    return backup_dir


def get_or_create_place(conn: sqlite3.Connection, url: str, title: str) -> int:
    row = conn.execute("SELECT id FROM moz_places WHERE url = ?", (url,)).fetchone()
    if row:
        place_id = row[0]
        conn.execute("UPDATE moz_places SET title = ? WHERE id = ?", (title, place_id))
        return place_id

    guid = "{" + str(uuid.uuid4()).upper() + "}"
    conn.execute(
        """
        INSERT INTO moz_places (url, title, rev_host, visit_count, hidden, typed, guid, frecency, last_visit_date)
        VALUES (?, ?, ?, 0, 0, 0, ?, 100, 0)
        """,
        (url, title, url.split("/")[2][::-1] if "://" in url else "", guid),
    )
    return conn.execute("SELECT last_insert_rowid()").fetchone()[0]


def clean() -> dict:
    disable_bookmark_sync()
    backup_dir = backup_db()

    # Drop WAL so we can write exclusively after Firefox is closed.
    for name in ("places.sqlite-wal", "places.sqlite-shm"):
        path = PROFILE / name
        if path.exists():
            path.unlink()

    conn = sqlite3.connect(DB, timeout=60)
    conn.execute("PRAGMA busy_timeout = 60000")

    before = conn.execute(
        "SELECT COUNT(*) FROM moz_bookmarks b JOIN moz_places p ON b.fk = p.id WHERE b.type = 1"
    ).fetchone()[0]

    # Remove all bookmarks and non-system folders.
    conn.execute("DELETE FROM moz_bookmarks WHERE type = 1")
    conn.execute(
        f"DELETE FROM moz_bookmarks WHERE type = 2 AND id NOT IN ({','.join(map(str, SYSTEM_FOLDER_IDS))})"
    )

    # Orphan place cleanup (keep history-linked places).
    conn.execute(
        """
        DELETE FROM moz_places
        WHERE id NOT IN (SELECT fk FROM moz_bookmarks WHERE fk IS NOT NULL)
          AND id NOT IN (SELECT place_id FROM moz_historyvisits)
        """
    )

    ts = now_us()
    conn.execute(
        """
        INSERT INTO moz_bookmarks (type, fk, parent, position, title, dateAdded, lastModified)
        VALUES (2, NULL, ?, 0, 'Daily', ?, ?)
        """,
        (TOOLBAR_ID, ts, ts),
    )
    daily_folder_id = conn.execute("SELECT last_insert_rowid()").fetchone()[0]

    for pos, (title, url) in enumerate(DAILY):
        place_id = get_or_create_place(conn, url, title)
        conn.execute(
            """
            INSERT INTO moz_bookmarks (type, fk, parent, position, title, dateAdded, lastModified)
            VALUES (1, ?, ?, ?, ?, ?, ?)
            """,
            (place_id, daily_folder_id, pos, title, ts, ts),
        )

    conn.commit()

    # Toolbar must contain only the Daily folder (no loose URLs on the bar).
    toolbar_children = conn.execute(
        "SELECT id, type, title FROM moz_bookmarks WHERE parent = ? ORDER BY position",
        (TOOLBAR_ID,),
    ).fetchall()
    loose_urls = [r for r in toolbar_children if r[1] == 1]
    if loose_urls:
        conn.executemany("DELETE FROM moz_bookmarks WHERE id = ?", [(r[0],) for r in loose_urls])
        conn.commit()

    after = conn.execute(
        "SELECT COUNT(*) FROM moz_bookmarks b JOIN moz_places p ON b.fk = p.id WHERE b.type = 1"
    ).fetchone()[0]
    toolbar_url_count = conn.execute(
        """
        SELECT COUNT(*) FROM moz_bookmarks
        WHERE type = 1 AND parent = ?
        """,
        (TOOLBAR_ID,),
    ).fetchone()[0]

    # Export post-clean HTML for reference.
    rows = conn.execute(
        """
        SELECT b.title, p.url
        FROM moz_bookmarks b
        JOIN moz_places p ON b.fk = p.id
        WHERE b.type = 1
        ORDER BY b.position
        """
    ).fetchall()
    conn.close()

    html_path = backup_dir / "firefox-daily-after-clean.html"
    lines = [
        "<!DOCTYPE NETSCAPE-Bookmark-file-1>",
        "<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">",
        "<TITLE>Daily</TITLE>",
        "<H1>Daily</H1>",
        "<DL><p>",
        "    <DT><H3>Daily</H3>",
        "    <DL><p>",
    ]
    for title, url in rows:
        lines.append(f'        <DT><A HREF="{url}">{title}</A>')
    lines.extend(["    </DL><p>", "</DL>"])
    html_path.write_text("\n".join(lines) + "\n", encoding="utf-8")

    return {
        "backup_dir": str(backup_dir),
        "before": before,
        "after": after,
        "daily_count": len(DAILY),
        "toolbar_url_count": toolbar_url_count,
        "sync_disabled": True,
        "html": str(html_path),
    }


if __name__ == "__main__":
    result = clean()
    print("backup_dir:", result["backup_dir"])
    print("bookmarks_before:", result["before"])
    print("bookmarks_after:", result["after"])
    print("daily_count:", result["daily_count"])
    print("export:", result["html"])

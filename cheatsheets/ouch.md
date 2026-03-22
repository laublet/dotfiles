# ouch — painless compression & decompression

> Replaces `tar`, `zip`, `gzip`, etc. Unified interface, format detected from extension.

## Everyday usage

```bash
# Decompress (format auto-detected)
ouch d archive.tar.gz
ouch d archive.zip
ouch d archive.tar.zst

# Compress
ouch c file1 file2 dir/ output.tar.gz
ouch c src/ src.zip
ouch c *.log logs.tar.zst

# List contents without extracting
ouch l archive.tar.gz
```

## Supported formats

`tar`, `zip`, `gz`, `bz2`, `xz`, `zst` (zstd), `7z`, `rar` (decompress only), `br` (brotli)

Any combination works: `.tar.gz`, `.tar.zst`, `.tar.bz2`, `.tar.xz`, etc.

## Useful flags

| Flag | Effect |
|------|--------|
| `-y` / `--yes` | skip confirmation prompts |
| `-n` / `--no` | auto-decline prompts |
| `-d <dir>` | extract to specific directory |
| `--threads <N>` | concurrency control (zstd) |

## Recipes

```bash
# Extract to a specific directory
ouch d archive.tar.gz -d /tmp/output

# Compress with zstd (fast + great ratio)
ouch c project/ project.tar.zst

# Quick one-liner: compress and extract
ouch c src/ src.tar.gz && ouch d src.tar.gz -d /tmp/test
```

## ouch vs traditional tools

| Task | Traditional | ouch |
|------|-------------|------|
| Extract tar.gz | `tar xzf a.tar.gz` | `ouch d a.tar.gz` |
| Create tar.gz | `tar czf a.tar.gz dir/` | `ouch c dir/ a.tar.gz` |
| Extract zip | `unzip a.zip` | `ouch d a.zip` |
| List contents | `tar tf a.tar.gz` | `ouch l a.tar.gz` |

## Links

- Repo: https://github.com/ouch-org/ouch

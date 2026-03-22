# tokei — code line counter

> Replaces `cloc`. Counts lines of code by language, extremely fast.

## Everyday usage

```bash
tokei                                # current directory
tokei /path/to/project               # specific directory
tokei src/                           # specific subdirectory
tokei -s code                        # sort by lines of code
tokei -s blanks                      # sort by blank lines
tokei -s comments                    # sort by comments
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-s <sort>` | sort by: `code`, `blanks`, `comments`, `files`, `lines` |
| `-e <path>` | exclude path (can repeat) |
| `-t <langs>` | only count specific languages (e.g. `-t Rust,Python`) |
| `-f` | show per-file statistics |
| `-c` | show columns for each file |
| `-o <format>` | output format: `json`, `yaml`, `cbor` |
| `--hidden` | include hidden files |

## Recipes

```bash
# Only Rust and TypeScript
tokei -t Rust,TypeScript

# Exclude test directories
tokei -e tests -e __tests__

# Per-file breakdown
tokei -f src/

# JSON output (for scripts)
tokei -o json | jq '.Rust.code'

# Compare two projects
tokei project-a/ project-b/
```

## Links

- Repo: https://github.com/XAMPPRocky/tokei

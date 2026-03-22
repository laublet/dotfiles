# sd — intuitive find & replace

> Replaces `sed` for find & replace. No arcane escaping rules.

## Everyday usage

```bash
sd 'from' 'to' file.txt             # replace in file (in-place)
sd 'from' 'to' file1 file2          # multiple files
echo "hello world" | sd 'world' 'rust'  # pipe mode
sd -p 'from' 'to' file.txt          # preview changes (no write)
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-p` | preview mode (print changes, don't write) |
| `-s` / `--string-mode` | literal strings (no regex) |
| `-f <flags>` | regex flags: `i` (case insensitive), `m` (multiline) |
| `-A` / `--across` | process whole file at once (for cross-line patterns) |

## Recipes

```bash
# Case-insensitive replace
sd -f i 'foo' 'bar' file.txt

# Regex with capture groups
sd '(\w+)@(\w+)' '$1 AT $2' emails.txt

# Replace across all files matching a pattern (with fd)
fd -e py | xargs sd 'old_func' 'new_func'

# Replace in all .ts files recursively
fd -e ts -x sd 'oldImport' 'newImport' {}

# Literal string mode (no regex interpretation)
sd -s 'arr[0]' 'arr.first()' file.rs

# Preview before applying
sd -p 'TODO' 'DONE' *.md
```

## sd vs sed

| Task | sed | sd |
|------|-----|----|
| Simple replace | `sed -i 's/foo/bar/g' f` | `sd foo bar f` |
| Regex groups | `sed 's/\(a\)/\1b/'` | `sd '(a)' '${1}b'` |
| Literal dots | `sed 's/a\.b/c/'` | `sd -s 'a.b' 'c'` |

## Links

- Repo: https://github.com/chmln/sd

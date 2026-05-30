# fx — interactive JSON viewer

> **Help:** `?` in TUI · `fx --help`

> TUI for exploring JSON. Vim-style navigation, JS expressions inline, no `jq` syntax. Use when a Lambda/CloudWatch payload is too big for `jq` one-liners.

## Everyday usage

```bash
cat payload.json | fx                      # interactive viewer
fx payload.json                            # same, file arg
curl -s api/users | fx                     # pipe direct from HTTP
aws logs ... --output json | fx            # AWS CLI output
```

## Interactive keys

| Key | Action |
|-----|--------|
| `j` / `k` | next / prev line |
| `J` / `K` (Shift) | collapse / expand current node |
| `h` / `l` | collapse / expand (vim-style) |
| `g` / `G` | top / bottom |
| `/` | search (regex) |
| `n` / `N` | next / prev search match |
| `e` | expand all |
| `E` | collapse all |
| `.` | enter expression mode (filter with JS) |
| `q` / `Ctrl+C` | quit |
| `?` | help |
| `y` | yank current path to clipboard (e.g. `.users[0].name`) |
| `Y` | yank current value |

## Expression mode (`.`)

JavaScript expressions, not jq:

```js
.users.length                              # count
.users.filter(u => u.active)               # filter
.users.map(u => u.email)                   # extract field
.events.filter(e => e.ts > Date.now()-86400000)  # last 24h
this.users[0]                              # `this` = current node
```

Expressions update the view live.

## Non-interactive usage (jq-like)

```bash
fx file.json '.users.length'               # one-shot, prints result
fx file.json '.users.map(u => u.name)'     # transform
fx file.json 'this[0]'                     # array access
```

## When to use what

| Need | Tool |
|------|------|
| One-shot query, scriptable | `jq` (already in `/usr/bin/jq`) |
| Explore a big unknown payload | `fx` |
| Filter with JS rather than jq syntax | `fx` expression mode |
| Compose pipelines | `jq` (better for chains) |

## Links

- Repo: https://github.com/antonmedv/fx

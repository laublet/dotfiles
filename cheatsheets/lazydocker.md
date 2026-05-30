# lazydocker — TUI Docker client

> **Help:** `?` in TUI · `lazydocker --help`

> Docker dashboard in the terminal. Alias: `lzd`.

## Launch

```bash
lzd                      # open lazydocker
lazydocker               # same, no alias
```

## Panels (navigate with Tab or brackets)

| Key | Panel |
|-----|-------|
| `[` / `]` | switch panels |
| Tab | next panel |

Panels: Containers, Images, Volumes, Networks

## Containers

| Key | Action |
|-----|--------|
| `Enter` | view logs/stats/config |
| `d` | remove container |
| `s` | stop |
| `r` | restart |
| `a` | attach (shell into container) |
| `m` | view logs |
| `E` | exec shell |
| `b` | bulk actions |

## Images

| Key | Action |
|-----|--------|
| `d` | remove image |
| `Enter` | view details |

## Volumes

| Key | Action |
|-----|--------|
| `d` | remove volume |
| `Enter` | view details |

## General

| Key | Action |
|-----|--------|
| `?` | help |
| `/` | filter |
| `q` | quit |
| `x` | menu |

## Links

- Repo: https://github.com/jesseduffield/lazydocker

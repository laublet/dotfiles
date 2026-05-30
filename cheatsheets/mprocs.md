# mprocs — multi-process dev runner

> **Help:** `mprocs --help` · `cheat mprocs` · [github.com/pvolok/mprocs](https://github.com/pvolok/mprocs)

> One TUI to run **several dev commands** (API, front, worker, docker logs) with restart, scrollback, and copy mode. Install: `brew install mprocs`. Shell alias: **`mp`**.

## When to use

| Situation | Use |
|-----------|-----|
| One `npm run dev` | plain WezTerm pane |
| API + web + worker + compose logs | **mprocs** |
| Same stack every day on a repo | commit `mprocs.yaml` at project root |

## Launch

```bash
mprocs                              # reads ./mprocs.yaml (or global ~/.config/mprocs/mprocs.yaml)
mprocs -c ./deploy/mprocs.yaml      # alternate config path
mprocs "api: npm run dev" "web: npm run dev --prefix apps/web"   # ad hoc (no yaml)
mprocs --just                       # load recipes from justfile (manual start per proc)
mprocs --npm                        # load package.json scripts (manual start)
mprocs --procfile ./Procfile.dev    # Heroku-style Procfile
mprocs --on-init '{c: restart-all}' # autostart everything (with --procfile)
```

Global config (optional): `~/.config/mprocs/mprocs.yaml` — shared keymaps / defaults. Local `mprocs.yaml` overrides it.

## Minimal `mprocs.yaml`

```yaml
procs:
  api:
    cmd: ["npm", "run", "dev"]
  web:
    cmd: ["npm", "run", "dev", "--prefix", "apps/web"]
```

`cmd` = argv array. Alternative: `shell: "npm run dev"` (one string, run in shell).

## Full example (typical full-stack repo)

```yaml
procs:
  db:
    shell: "docker compose up postgres redis"
    autostart: true
    autorestart: false
    stop:
      cmd: "docker compose stop postgres redis"

  api:
    cmd: ["npm", "run", "dev"]
    cwd: "<CONFIG_DIR>/apps/api"
    env:
      NODE_ENV: development
      PORT: "3000"
    autostart: true
    autorestart: true

  web:
    cmd: ["npm", "run", "dev"]
    cwd: "<CONFIG_DIR>/apps/web"
    env:
      VITE_API_URL: "http://localhost:3000"
    autostart: true

  worker:
    shell: "npm run worker --watch"
    cwd: "<CONFIG_DIR>"
    autostart: false          # start manually with `s` when needed

  logs:
    shell: "docker compose logs -f --tail=50 api worker"
    autostart: false
```

`<CONFIG_DIR>` expands to the directory containing this yaml file — useful in monorepos.

## Useful proc options

| Field | Role |
|-------|------|
| `cwd` | Working directory for the proc |
| `env` | Extra env vars (`null` clears inherited var) |
| `autostart` | Start when mprocs opens (default `true`) |
| `autorestart` | Restart on exit (default `false`) |
| `stop.cmd` | Shell command on quit instead of SIGTERM (e.g. `docker compose down`) |
| `log` | Per-proc log file under a dir (`true` or `{ dir: "./logs" }`) |

## Keys (default — press `p` in TUI for full menu)

### Process list (left pane)

| Key | Action |
|-----|--------|
| `↑` / `↓` or `j` / `k` | select process |
| `Enter` / `Ctrl-a` | focus process output |
| `s` | start selected (if stopped) |
| `r` | soft kill + restart |
| `R` | hard kill + restart |
| `x` / `X` | stop (soft / hard) |
| `a` | add process interactively |
| `d` | remove process (must be stopped) |
| `z` | zoom into terminal |
| `v` | copy mode |
| `q` | quit (graceful) |
| `Q` | force quit |

### Output pane

| Key | Action |
|-----|--------|
| `Ctrl-a` | back to process list |
| `Ctrl-u` / `Ctrl-d` | scroll up / down |

### Copy mode (`v` from output)

1. `v` → move to start → `v` again to start selection → move → `c` to copy.

## Recipes

### Monorepo Node (this dotfiles style)

```yaml
procs:
  nvim-doc:
    shell: "nvim"
    cwd: "<CONFIG_DIR>"
    autostart: false

  just-watch:
    shell: "just --list && just link"
    autostart: false
```

### Go API + frontend already running elsewhere

```yaml
procs:
  api:
    cmd: ["go", "run", "./cmd/server"]
    env:
      GOFLAGS: "-tags=dev"
  test-watch:
    shell: "go test ./... -count=1 -short 2>&1 | while read l; do echo \"$l\"; done"
    autostart: false
```

### Load from justfile without yaml

```bash
cd ~/dev/mon-projet
mprocs --just    # pick recipes in the TUI, start with `s`
```

## Workflow tips

- **WezTerm:** one tab for `mp`, one tab for git/`gu` — mprocs is not a tmux replacement (processes die when mprocs quits).
- **Logs on disk:** `mprocs --log-dir ./logs` or per-proc `log: { dir: "./logs" }` when debugging flaky restarts.
- **Remote control:** `mprocs --server 127.0.0.1:4050` then `mprocs --ctl '{c: restart-all}'` from another shell.

## Links

- [tui-guide](tui-guide.md) · [wezterm](wezterm.md) · [just](just.md)
- Schema: [mprocs.json](https://raw.githubusercontent.com/pvolok/mprocs/master/schemas/mprocs.json)

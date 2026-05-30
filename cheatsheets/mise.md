# mise — runtime version manager

> **Help:** `mise --help` · `mise help <cmd>`

> Manages tool versions (Node, Python, Go, etc.) and env vars. Can replace `fnm` + `direnv`.

## Everyday usage

```bash
mise use node@22                     # install and set Node 22 for current dir
mise use python@3.12                 # install and set Python 3.12
mise use --global node@22            # set as default globally
mise install                         # install versions from .mise.toml / .tool-versions
mise ls                              # list installed versions
mise ls-remote node                  # list available Node versions
```

## Per-project config

```bash
# Creates/updates .mise.toml in current directory
mise use node@22
mise use python@3.12
```

This creates a `.mise.toml`:

```toml
[tools]
node = "22"
python = "3.12"
```

Also reads `.tool-versions` (asdf-compatible) and `.nvmrc` / `.node-version`.

## Environment variables (direnv replacement)

```toml
# .mise.toml
[tools]
node = "22"

[env]
DATABASE_URL = "postgres://localhost/mydb"
NODE_ENV = "development"

[env._.path]
# prepend to PATH
PATH = ["./node_modules/.bin", "./bin"]
```

## Task runner

```toml
# .mise.toml
[tasks.dev]
run = "npm run dev"

[tasks.test]
run = "npm test"

[tasks.lint]
run = "npm run lint"
depends = ["test"]
```

```bash
mise run dev                         # run a task
mise run test                        # run with dependencies
```

## Useful commands

| Command | Action |
|---------|--------|
| `mise use <tool>@<ver>` | install + activate |
| `mise install` | install from config |
| `mise ls` | list installed |
| `mise ls-remote <tool>` | list available versions |
| `mise prune` | remove unused versions |
| `mise self-update` | update mise itself |
| `mise doctor` | check for issues |
| `mise trust` | trust a .mise.toml (first time) |

## Migration from fnm

```bash
# mise reads .nvmrc and .node-version automatically
# To fully switch: mise use --global node@22
# Then remove fnm from zshrc
```

## Links

- Repo: https://github.com/jdx/mise
- Docs: https://mise.jdx.dev
- Config: `.mise.toml` (per-project) or `~/.config/mise/config.toml` (global)

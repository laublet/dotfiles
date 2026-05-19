# posting — TUI HTTP client (Postman replacement candidate)

> Keyboard-driven HTTP client built with Textual. Plain-text collections (`.posting.yaml`), Git-friendly, vim-like keybindings. Trial period: migrate 3-4 collections from Postman; commit or roll back.

## Launch

```bash
posting                                    # launch with default collection
posting --collection ~/api/users-api/      # specific collection directory
posting --env ./dev.env                    # load env vars from file
```

Collections are folders of YAML files. Each request is a file; folders are groups. Versioned cleanly in Git.

## Everyday keybindings

| Key | Action |
|-----|--------|
| `Ctrl+P` | command palette (fuzzy search any action) |
| `Ctrl+N` | new request |
| `Ctrl+S` | save current request |
| `Ctrl+J` | toggle response panel |
| `Ctrl+T` | toggle tree (collection sidebar) |
| `Ctrl+L` | focus URL bar |
| `j` / `k` | navigate tree (when focused) |
| `Enter` | send request (when URL bar / method focused) |
| `Tab` | switch panel (request → response → tree) |
| `?` | help / keybindings reference |
| `q` / `Ctrl+C` | quit |

## Request editing

Tabs in the request panel:

- **Body** — raw, JSON, form, multipart
- **Headers** — key/value pairs, syntax-highlighted
- **Query** — query params (auto-syncs with URL)
- **Auth** — bearer, basic, custom
- **Scripts** — pre-request / post-response (Python)
- **Options** — timeout, redirects, proxy

## Environments & variables

Variables defined in `.env` files or YAML environment files. Reference in any field with `${VAR_NAME}`.

```yaml
# dev.env
BASE_URL=https://api.dev.example.com
TOKEN=dev-token-xxx
```

Switch environment from the command palette (`Ctrl+P → Set environment`).

## Scripts (pre/post)

Inline Python snippets. Common use:

```python
# pre-request: refresh auth
import time
if env["TOKEN_EXPIRES"] < time.time():
    env["TOKEN"] = refresh_token()

# post-response: extract token
if response.status_code == 200:
    env["TOKEN"] = response.json()["access_token"]
```

## Migration from Postman

1. Export Postman collection (Collection v2.1 JSON)
2. `posting import postman path/to/collection.json` (if supported in your version, else manual)
3. Verify env vars carry over (Postman variables → posting `${VAR}`)
4. Commit the YAML collection to a Git repo (no more "shared workspace" pain)

## When to use posting vs Postman vs curl/xh

| Need | Tool |
|------|------|
| One-off `curl` style request | `curl` or `xh` (not installed) |
| Daily API exploration, multiple endpoints | **posting** (target) |
| Team collections with shared sync | Postman (still needed if team uses cloud sync) |
| Complex pre-request orchestration | posting (Python is more flexible than Postman scripts) |

## Trial commitment

Per the dotfiles install plan: if after 2 sprints you don't open posting daily, drop it. Postman cask stays in the Brewfile **until** you commit to posting fully, then we remove `cask "postman"`.

## Links

- Repo: https://github.com/darrenburns/posting
- Docs: https://posting.sh/

# glab — GitLab CLI

> **Help:** `glab help` · `glab <cmd> --help`

> Official GitLab CLI. MR review, CI watch, issues, repo clone — all from the terminal without leaving the keyboard.

## First-time setup

```bash
glab auth login --hostname gitlab.com --web --git-protocol ssh
glab auth status                           # check current session
glab config set host gitlab.example.com    # for self-hosted (per-host config)
```

Auth is stored in `~/.config/glab-cli/`. Tokens never end up in this dotfiles repo.

**Browser (macOS):** `mac-open` in PATH (`bin/mac-open` → Choosy for bare `https?://` URLs). Wired via zsh `open`, `BROWSER`, `glab`/`gh` browser config. Force a browser: `open -a "Firefox Developer Edition" …` or `MAC_OPEN_BROWSER='Google Chrome' mac-open …`.

**Duplicate config warning:** old glab versions used `~/Library/Application Support/glab-cli/`. Keep only `~/.config/glab-cli/`. Fix: `rm -rf ~/Library/Application\ Support/glab-cli` (aliases are migrated to XDG on `just link`).

**“Remotes point to github.com”:** `glab` infers the project from `git remote` in the **current directory**. This dotfiles repo is on GitHub — use an explicit repo or `cd` into a GitLab clone:

```bash
glab mr list -R neo-k/my-project          # group/project on gitlab.com
glab mr list -R https://gitlab.com/neo-k/my-project
cd ~/dev/work/some-gitlab-repo && glab mr list
```

## TUI picker (`glab-pick`)

```bash
gp                     # alias — smart context (see below)
gp -a                  # always show project picker
gp -f blank            # only paths matching *blank*
gp -R neo-k/foo        # skip project picker
```

**Smart context (default):**

1. Inside a GitLab clone → uses `git remote` (no project list, fast).
2. Else if `$PWD` has a segment like `blank` → filters neo-k projects to `*blank*` only.
3. Else → cached project list (`~/.cache/glab-pick/`, 5 min TTL).

**MRs:** use **All open MRs** first — review/assigned/authored filter with `@me` and can show “none” while MRs exist on the project.

Actions: MRs (open / review / assigned / authored), CI status/view, issues @me, open project in browser.

## Merge Requests

```bash
glab mr list                               # MRs you authored
glab mr list --assignee=@me                # MRs assigned to you
glab mr list --reviewer=@me                # MRs awaiting your review
glab mr list --state=opened --label=bug    # filter

glab mr view 123                           # detailed view (description, threads)
glab mr view 123 --web                     # open in browser
glab mr view 123 --comments                # show all comments

glab mr checkout 123                       # check out the MR branch locally
glab mr diff 123                           # show diff (uses delta if configured)
glab mr approve 123                        # approve
glab mr revoke 123                         # un-approve

glab mr create --fill                      # create from current branch (auto title/desc)
glab mr create --target-branch=develop --draft
glab mr merge 123 --squash --remove-source-branch
```

## CI / pipelines

```bash
glab ci view                               # latest pipeline for current branch
glab ci view <pipeline-id>                 # specific pipeline
glab ci trace                              # tail the job log
glab ci trace <job-id>                     # specific job
glab ci status                             # quick status check
glab ci retry <job-id>                     # retry a failed job
glab ci run                                # trigger a new pipeline manually
```

## Issues

```bash
glab issue list --assignee=@me
glab issue view 42
glab issue create --title "Bug" --description "..."
glab issue close 42
```

## Repo

```bash
glab repo list --member                    # projects you belong to (default: --mine = owner only → often empty)
glab repo list -g neo-k                    # projects in a group
glab repo list -g neo-k -G                 # include subgroups

glab repo clone group/project              # clone by path
glab repo view --web                       # open project page
glab repo fork                             # fork current repo
```

## Aliases (custom commands)

```bash
glab alias set co 'mr checkout'            # `glab co 123` shortcut
glab alias set my 'mr list --assignee=@me'
glab alias list
```

## Useful flags (global)

| Flag | Effect |
|------|--------|
| `--repo OWNER/REPO` | act on a specific project (override autodetect) |
| `-F json` | machine-readable output |
| `--web` | open in browser instead of TUI |

## Links

- Repo: https://gitlab.com/gitlab-org/cli
- Docs: https://glab.readthedocs.io/

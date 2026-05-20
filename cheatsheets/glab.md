# glab — GitLab CLI

> Official GitLab CLI. MR review, CI watch, issues, repo clone — all from the terminal without leaving the keyboard.

## First-time setup

```bash
glab auth login --hostname gitlab.com --web --git-protocol ssh
glab auth status                           # check current session
glab config set host gitlab.example.com    # for self-hosted (per-host config)
```

Auth is stored in `~/.config/glab-cli/`. Tokens never end up in this dotfiles repo.

**Browser (macOS):** dotfiles set `browser: open -a "Google Chrome"` in `conf/glab/config.yml` so OAuth / `--web` open in Chrome instead of the system default (Choosy/Firefox). Override: `glab config set -g browser 'open -a "Firefox"'` or `export BROWSER=...` (env wins over config).

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

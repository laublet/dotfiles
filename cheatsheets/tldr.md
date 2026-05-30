# tldr — community man pages (via tlrc)

> **Help:** `tldr <command>` (this *is* the help) · `tldr --help`

> Fast, example-driven cheatsheets for ~10 000 CLI commands. Use instead of `man` when you want "what's the syntax for the 80% case" rather than the full reference. Binary is `tlrc` (Rust client) but the command stays `tldr`.

## Everyday usage

```bash
tldr tar                              # examples for tar
tldr git-rebase                       # subcommands use a dash
tldr -p macos pbcopy                  # macOS-specific page
tldr -p linux systemctl               # force linux page
tldr --update                         # refresh cache
tldr --list                           # list every page
tldr --search "compress"              # search inside pages
```

## Cache

```bash
tldr --update                         # download latest pages
tldr --clean-cache                    # nuke cache
```

Cache lives in `~/.cache/tealdeer/` (default for `tlrc`). Stale after ~2 weeks — `tldr --update` will fix odd "page not found" errors.

## Platform handling

Pages exist per OS. `tlrc` auto-detects but you can force one:

```bash
tldr -p macos brew
tldr -p linux apt
tldr -p windows pwsh
tldr -p common ls                     # cross-platform variant
```

## Compared to `man`

| Need | Tool |
|------|------|
| Recipe-style examples for a CLI | `tldr` |
| Full flag reference, edge cases, signals | `man` |
| Search across pages | `tldr --search` |
| Search inside one page | `man cmd` then `/` |
| Offline, no install required | `man` |

## Tip

If a page misses an example you needed, contribute back: https://github.com/tldr-pages/tldr/blob/main/CONTRIBUTING.md — the project takes small PRs gladly.

## Links

- tlrc (client used here): https://github.com/tldr-pages/tlrc
- tldr-pages (content): https://github.com/tldr-pages/tldr

# zoxide — smart cd

> **Help:** `zoxide --help`

> Replaces `cd` with frequency-based directory jumping. Learns as you navigate.

## Everyday usage

```bash
z foo                    # jump to most frequent/recent dir matching "foo"
z foo bar                # match "foo" AND "bar" in path
zi                       # interactive mode: fzf picker of all known dirs
zi foo                   # interactive with initial filter

cd /some/path            # still works normally, zoxide learns it
z -                      # go back to previous directory
```

## How it works

1. Every time you `cd` into a directory, zoxide records it
2. Each directory gets a "frecency" score (frequency + recency)
3. `z <query>` jumps to the highest-scoring match
4. The more you visit a directory, the higher it ranks

## Examples

```bash
# You've been to ~/dev/perso/dotfiles often:
z dot                    # → ~/dev/perso/dotfiles

# Multiple matches? Most frequent wins:
z perso                  # → ~/dev/perso (if visited more than ~/dev/perso/*)

# Be more specific to disambiguate:
z perso dot              # → ~/dev/perso/dotfiles

# Not sure? Use interactive mode:
zi                       # browse all known dirs with fzf
```

## Management

```bash
zoxide query             # list all tracked directories with scores
zoxide query foo         # show matches for "foo" with scores
zoxide add /path         # manually add a directory
zoxide remove /path      # remove a directory from the database
```

## Links

- Repo: https://github.com/ajeetdsouza/zoxide
- DB location: `~/.local/share/zoxide/db.zo`

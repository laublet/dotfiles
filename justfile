# Dotfiles task runner
# Usage: just <recipe> or just -l to list recipes

default:
    @just -l

# ── Setup ─────────────────────────────────────────────────────────

[doc("Full setup: install packages + link dotfiles")]
bootstrap:
    ./bootstrap

[doc("Re-link dotfiles only (detects OS)")]
link:
    ./install

[doc("Minimal server dotfiles (nvim+vim, zsh, git, zellij, starship, atuin, mise, lazygit)")]
server:
    ./install-server

[doc("Home server dotfiles (same as server); use packages-homeserver for Docker + btop")]
homeserver:
    ./install-homeserver

# ── Packages ──────────────────────────────────────────────────────

[doc("Install/update macOS packages from Brewfile")]
[macos]
packages:
    brew bundle --file=Brewfile

[doc("Install Linux desktop packages (default profile)")]
[linux]
packages:
    bash packages-linux.sh desktop

[doc("Minimal headless server packages (Debian/ARM-safe; same as packages-server)")]
[linux]
packages-minimal:
    bash packages-linux.sh server

[doc("Minimal headless server (Pi, VPS): tmux, zellij, mosh, starship…")]
[linux]
packages-server:
    bash packages-linux.sh server

[doc("Home server packages: server + Docker + btop")]
[linux]
packages-homeserver:
    bash packages-linux.sh homeserver

[doc("Update all installed brew packages")]
[macos]
upgrade:
    brew update && brew upgrade && brew cleanup

# ── Editing ───────────────────────────────────────────────────────

[doc("Edit zshrc")]
zsh:
    $EDITOR conf/zsh/zshrc

[doc("Edit neovim config")]
nvim:
    $EDITOR conf/nvim/

[doc("Edit wezterm config")]
wezterm:
    $EDITOR conf/wezterm/

[doc("Edit starship config")]
starship:
    $EDITOR conf/starship/starship.toml

# ── Cheatsheets ───────────────────────────────────────────────────

[doc("Browse cheatsheets with fzf")]
cheat:
    #!/usr/bin/env bash
    dir="cheatsheets"
    file=$(fd -e md . "$dir" --strip-cwd-prefix -x basename {} \
        | fzf --preview "bat --style=plain --color=always $dir/{}" \
               --preview-window 'right,70%' \
               --prompt 'Cheatsheets❯ ')
    [[ -n "$file" ]] && bat --style=plain --paging=always "$dir/$file"

# ── Info ──────────────────────────────────────────────────────────

[doc("Show lines of code in dotfiles")]
stats:
    tokei --exclude dotbot --exclude .git

[doc("Show disk usage of dotfiles")]
size:
    dust -d 2 -X dotbot -X .git

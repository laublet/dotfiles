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

[doc("Re-link agent hub symlinks only (skills, research-hub, MCP, Claude/Codex pointers)")]
link-agents *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{justfile_directory()}}"
    git -C dotbot submodule sync --quiet --recursive 2>/dev/null || true
    git submodule update --init --recursive dotbot
    ./dotbot/bin/dotbot -d . -c install-agents.conf.yaml {{ARGS}}

[doc("Install AGENTS.local.md + CLAUDE.local.md in a work repo (gitignored). Args: repo path")]
work-agents-stub REPO *FLAGS:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "$HOME/.local/bin/work-agents-stub" ]] || { echo "Run: just link"; exit 1; }
    "$HOME/.local/bin/work-agents-stub" {{FLAGS}} "{{REPO}}"

[doc("Scaffold vault Projects/claude-imports/<slug>/ for a Claude.ai project")]
claude-project-init SLUG NAME *FLAGS:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "$HOME/.local/bin/claude-project-init" ]] || { echo "Run: just link"; exit 1; }
    "$HOME/.local/bin/claude-project-init" "{{SLUG}}" "{{NAME}}" {{FLAGS}}

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

[doc("Install Slack terminal tools: mise slkcli + slk-tui binary")]
install-slack-terminal:
    cd "{{justfile_directory()}}" && mise install
    test -x bin/install-slk-tui || (echo "Run: just link" >&2; exit 1)
    bin/install-slk-tui
    mise which slk >/dev/null && echo "slk (slkcli): $(mise which slk)"
    command -v slk-tui >/dev/null && echo "slk-tui: $(command -v slk-tui)"

[doc("Set Neovim as default app for text-like files (requires duti + Neovim.app)")]
[macos]
mac-neovim-defaults:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "$HOME/.local/bin/mac-neovim-defaults" ]] || { echo "Run: just link"; exit 1; }
    "$HOME/.local/bin/mac-neovim-defaults"

[doc("Regenerate Raycast ast-grep dropdown from ast-grep-patterns.lua")]
[macos]
gen-raycast-sg:
    {{justfile_directory()}}/scripts/gen-raycast-sg-pattern.sh

[doc("Patch Raycast Firefox host to foreground Dev Edition on tab switch")]
[macos]
raycast-firefox-patch:
    {{justfile_directory()}}/scripts/raycast-firefox-patch-focus.sh

[doc("Show Firefox profile suffix for Raycast Mozilla Firefox extension prefs")]
[macos]
raycast-firefox-profile:
    {{justfile_directory()}}/scripts/raycast-firefox-profile-hint.sh

raycast-quicklinks target='':
    #!/usr/bin/env bash
    set -euo pipefail
    dir="{{justfile_directory()}}/conf/raycast"
    case "{{target}}" in
      work) json="$dir/quicklinks-work-chrome.json" ; bundle="work (Chrome)" ;;
      "")   json="$dir/quicklinks-firefox.json" ; bundle="perso (Firefox)" ;;
      *)    echo "Usage: just raycast-quicklinks [work]"; exit 1 ;;
    esac
    [[ -f "$json" ]] || { echo "Missing: $json"; exit 1; }
    echo "Raycast → Import Quicklinks → $bundle:"
    echo "  $json"
    echo "Then Settings → Quicklinks → set aliases (see conf/raycast/README.md)."
    open -R "$json"

[doc("Raycast free tier: follow macOS dark appearance + restart")]
[macos]
mac-raycast-appearance:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "$HOME/.local/bin/mac-raycast-appearance" ]] || { echo "Run: just link"; exit 1; }
    "$HOME/.local/bin/mac-raycast-appearance"

[doc("Alias for mac-raycast-appearance")]
[macos]
mac-raycast-dracula:
    @just mac-raycast-appearance

[doc("Restart JankyBorders with Dracula colors (do not use brew services borders)")]
[macos]
mac-borders:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "$HOME/.local/bin/mac-borders" ]] || { DOTFILES="{{justfile_directory()}}"; "$DOTFILES/bin/mac-borders"; exit $?; }
    "$HOME/.local/bin/mac-borders"

[doc("Apply Dracula macOS appearance (dark, accent, dock, wallpaper from dracula.env)")]
[macos]
mac-appearance:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "$HOME/.local/bin/mac-appearance" ]] || { echo "Run: just link"; exit 1; }
    "$HOME/.local/bin/mac-appearance"

[doc("Apply Stats menu-bar modules (CPU + RAM + network); restarts Stats")]
[macos]
mac-stats-defaults:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "$HOME/.local/bin/mac-stats-defaults" ]] || { echo "Run: just link"; exit 1; }
    "$HOME/.local/bin/mac-stats-defaults"

[doc("Set IINA as default for .ts video (MPEG transport); run after mac-neovim-defaults")]
[macos]
mac-video-defaults:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "$HOME/.local/bin/mac-video-defaults" ]] || { echo "Run: just link"; exit 1; }
    "$HOME/.local/bin/mac-video-defaults"

[doc("Disable Slack, Signal, Todoist open-at-login (legacy items + Todoist prefs)")]
[macos]
mac-comm-no-autostart:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "$HOME/.local/bin/mac-comm-no-autostart" ]] || { echo "Run: just link"; exit 1; }
    "$HOME/.local/bin/mac-comm-no-autostart"

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

[doc("After reboot: verify agent hub, tools, MCP (no brew upgrade)")]
[macos]
post-reboot:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "$HOME/.local/bin/mac-post-update" ]] || { echo "Run: just link"; exit 1; }
    "$HOME/.local/bin/mac-post-update"

[doc("After macOS update: brew + cargo upgrades, then verify")]
[macos]
post-update:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "$HOME/.local/bin/mac-post-update" ]] || { echo "Run: just link"; exit 1; }
    "$HOME/.local/bin/mac-post-update" --upgrade --cargo

[doc("Health check: agent hub, MCP, duti, AeroSpace warp, tooling (no brew upgrade)")]
[macos]
doctor:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "$HOME/.local/bin/mac-post-update" ]] || { echo "Run: just link"; exit 1; }
    [[ -x "$HOME/.local/bin/mac-doctor" ]] || { echo "Run: just link"; exit 1; }
    "$HOME/.local/bin/mac-post-update"
    "$HOME/.local/bin/mac-doctor"

[doc("Open Zed here (same as `zed .` — finds CLI on PATH or Zed.app)")]
zed:
    #!/usr/bin/env bash
    set -euo pipefail
    if command -v zed >/dev/null; then
      exec zed .
    fi
    if [[ -x "/Applications/Zed.app/Contents/MacOS/cli" ]]; then
      exec "/Applications/Zed.app/Contents/MacOS/cli" .
    fi
    if [[ -x "/Applications/Zed.app/Contents/MacOS/zed" ]]; then
      exec "/Applications/Zed.app/Contents/MacOS/zed" .
    fi
    echo "zed not in PATH — brew install --cask zed" >&2
    exit 1

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

[doc("Check cross-tool keymap lock (Nvim/WezTerm refs)")]
keymap-lock-check:
    python3 scripts/check-keymap-lock.py

[doc("Check keymap lock as JSON (for CI/hooks)")]
keymap-lock-check-json:
    python3 scripts/check-keymap-lock.py --json

[doc("Bookmark triage helper: categorize reject/keepers, sync import CSV, generate keepers diff")]
bookmarks-triage TRIAGE_DIR="$HOME/dev/perso/vaults/Research/Inbox/karakeep-bookmarks-export/triage":
    python3 scripts/bookmarks_triage_workflow.py --triage-dir "{{TRIAGE_DIR}}"

[doc("Same as bookmarks-triage, then save current keepers as new snapshot baseline")]
bookmarks-triage-update TRIAGE_DIR="$HOME/dev/perso/vaults/Research/Inbox/karakeep-bookmarks-export/triage":
    python3 scripts/bookmarks_triage_workflow.py --triage-dir "{{TRIAGE_DIR}}" --update-snapshot

[doc("HTTP-check URLs in keepers.csv → keepers-url-status.csv")]
keepers-url-check INPUT="$HOME/dev/perso/vaults/Research/Inbox/karakeep-bookmarks-export/triage/keepers.csv":
    python3 scripts/check_keepers_urls.py --input "{{INPUT}}"

[doc("Install hoarder-sync in Main vault only (Literature/Karakeep)")]
hoarder-sync-setup:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -x "{{justfile_directory()}}/bin/setup-hoarder-sync" ]] || { echo "Run: just link"; exit 1; }
    "{{justfile_directory()}}/bin/setup-hoarder-sync"

[doc("Clean Firefox Dev Edition bookmarks to Daily folder; disable bookmark sync")]
firefox-bookmarks-clean:
    #!/usr/bin/env bash
    set -euo pipefail
    osascript -e 'tell application "Firefox Developer Edition" to quit' 2>/dev/null || true
    sleep 1
    pkill -9 -f "/Applications/Firefox Developer Edition.app/Contents/MacOS/firefox$" 2>/dev/null || true
    sleep 1
    python3 "{{justfile_directory()}}/scripts/firefox_clean_bookmarks.py"

[doc("Install local git hooks for keymap lock (pre-commit + pre-push)")]
install-git-hooks:
    #!/usr/bin/env bash
    set -euo pipefail
    root="{{justfile_directory()}}"
    hooks_dir="$root/.git/hooks"
    [[ -d "$hooks_dir" ]] || { echo "Not a git repo: $root"; exit 1; }
    install -m 0755 "$root/.githooks/pre-push" "$hooks_dir/pre-push"
    rm -f "$hooks_dir/pre-commit"
    echo "Installed git hooks: pre-push (pre-commit disabled)"

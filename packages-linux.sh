#!/usr/bin/env bash
# Package installation for Debian / Ubuntu (Pop!_OS) and headless servers.
# Layered profiles: each level includes the previous one.
#
# Usage:
#   ./packages-linux.sh server      # minimal headless server (Debian/ARM-safe, Pi, VPS…)
#   ./packages-linux.sh minimal     # alias for server (legacy name)
#   ./packages-linux.sh homeserver  # server + Docker (+ btop); no dev/IDE stack
#   ./packages-linux.sh desktop     # + GUI apps, fonts, keyd, Albert
#   ./packages-linux.sh             # defaults to "desktop"

set -e

PROFILE="${1:-desktop}"
mkdir -p ~/.local/bin

# ── Zellij release tarball suffix per machine (musl static builds) ─────────
_zellij_release_suffix() {
  case "$(uname -m)" in
    x86_64)        echo "x86_64-unknown-linux-musl" ;;
    aarch64|arm64) echo "aarch64-unknown-linux-musl" ;;
    armv7l)        echo "armv7-unknown-linux-gnueabihf" ;;
    *)             echo "" ;;
  esac
}

# ═══════════════════════════════════════════════════════════════════
# SERVER — minimal headless (Debian / Raspberry Pi OS / ARM + amd64)
# tmux: lightweight multiplexer, always in repos.
# zellij: matches dotfiles server/ config; prebuilt binary (no Rust compile on Pi).
# mosh: optional; helps flaky Wi-Fi (UDP). Use: mosh user@host
# ═══════════════════════════════════════════════════════════════════
install_server() {
  echo "==> [server] machine: $(uname -m)"
  echo "==> [server] Updating apt..."
  sudo apt update

  echo "==> [server] Installing apt packages..."
  sudo apt install -y \
    bat \
    curl \
    fd-find \
    fzf \
    git \
    htop \
    mosh \
    ripgrep \
    tmux \
    unzip \
    vim \
    wget \
    zsh

  # bat/fd are installed as batcat/fdfind on Debian/Ubuntu
  [[ ! -e ~/.local/bin/bat ]] && ln -sf "$(command -v batcat 2>/dev/null)" ~/.local/bin/bat || true
  [[ ! -e ~/.local/bin/fd ]]  && ln -sf "$(command -v fdfind 2>/dev/null)" ~/.local/bin/fd  || true

  # git-delta: use Debian package when available (all supported arches on Bookworm+)
  if ! command -v delta &>/dev/null; then
    if apt-cache show git-delta &>/dev/null; then
      echo "==> [server] Installing git-delta (apt)..."
      sudo apt install -y git-delta
    else
      echo "==> [server] git-delta: no apt package; skip (install from source if needed)."
    fi
  fi

  # eza: third-party repo (amd64/arm64); skip if install fails
  if ! command -v eza &>/dev/null; then
    echo "==> [server] Installing eza (apt repo)..."
    if [[ ! -f /etc/apt/sources.list.d/gierens.list ]]; then
      sudo mkdir -p /etc/apt/keyrings
      wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
      echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
      sudo apt update
    fi
    sudo apt install -y eza 2>/dev/null || echo "==> [server] eza: skipped (unsupported arch or repo)."
  fi

  # Zellij — prebuilt release (no cargo on small ARM boards)
  if ! command -v zellij &>/dev/null; then
    local suffix zj_tag zj_url tmpdir zj_bin
    suffix="$(_zellij_release_suffix)"
    if [[ -n "$suffix" ]]; then
      echo "==> [server] Installing zellij (GitHub release, ${suffix})..."
      zj_tag=$(curl -sL https://api.github.com/repos/zellij-org/zellij/releases/latest | grep '"tag_name"' | head -1 | cut -d'"' -f4)
      zj_url="https://github.com/zellij-org/zellij/releases/download/${zj_tag}/zellij-${suffix}.tar.gz"
      tmpdir=$(mktemp -d)
      if curl -fsSL -o /tmp/zellij.tgz "$zj_url"; then
        tar -xzf /tmp/zellij.tgz -C "$tmpdir"
        zj_bin=$(find "$tmpdir" -name zellij -type f 2>/dev/null | head -1)
        if [[ -n "$zj_bin" ]]; then
          install -m 755 "$zj_bin" ~/.local/bin/zellij
        else
          echo "==> [server] zellij: binary not found in archive; use tmux."
        fi
        rm -rf "$tmpdir" /tmp/zellij.tgz
      else
        echo "==> [server] zellij: download failed for ${suffix}; install manually or use tmux only."
        rm -rf "$tmpdir"
      fi
    else
      echo "==> [server] zellij: unsupported arch $(uname -m); use tmux."
    fi
  fi

  # Starship + zoxide (install scripts support arm64 / amd64)
  if ! command -v starship &>/dev/null; then
    echo "==> [server] Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi

  if ! command -v zoxide &>/dev/null; then
    echo "==> [server] Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  fi

  echo "==> [server] Done."
  echo "    Sessions: tmux new -A -s main   or   zellij"
  echo "    Resilient SSH: mosh user@host   (after: sudo apt install mosh on both ends)"
}

# ═══════════════════════════════════════════════════════════════════
# HOMESERVER — server + Docker (Pi-hole, Jellyfin, stacks). Strict minimum.
# ═══════════════════════════════════════════════════════════════════
install_homeserver() {
  install_server

  echo "==> [homeserver] Installing Docker..."
  if ! command -v docker &>/dev/null; then
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker "$USER"
  fi

  if ! command -v btop &>/dev/null; then
    echo "==> [homeserver] Installing btop (monitoring)..."
    sudo apt install -y btop
  fi

  echo "==> [homeserver] Done."
  echo "    Log out and back in (or newgrp docker) for the docker group."
}

# ═══════════════════════════════════════════════════════════════════
# DESKTOP — Pop!_OS workstation on top of homeserver
# ═══════════════════════════════════════════════════════════════════
install_desktop() {
  install_homeserver

  echo "==> [desktop] Installing GUI apps and desktop tools..."

  # WezTerm
  if ! command -v wezterm &>/dev/null; then
    echo "    → WezTerm"
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
    echo "deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *" | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo apt update
    sudo apt install -y wezterm
  fi

  # Cursor
  if ! command -v cursor &>/dev/null; then
    echo "    → Cursor (AppImage)"
    curl -sLo ~/.local/bin/cursor "https://downloader.cursor.sh/linux/appImage/x64"
    chmod +x ~/.local/bin/cursor
  fi

  # Obsidian
  if ! dpkg -l obsidian &>/dev/null 2>&1; then
    echo "    → Obsidian"
    OBSIDIAN_VERSION=$(curl -sL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep tag_name | cut -d '"' -f4 | tr -d v)
    curl -sLo /tmp/obsidian.deb "https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/obsidian_${OBSIDIAN_VERSION}_amd64.deb"
    sudo dpkg -i /tmp/obsidian.deb || sudo apt install -f -y
    rm -f /tmp/obsidian.deb
  fi

  # Albert (launcher)
  if ! command -v albert &>/dev/null; then
    echo "    → Albert"
    curl -fsSL https://build.opensuse.org/projects/home:manuelschneid3r/signing_keys/download?kind=gpg | sudo gpg --dearmor -o /etc/apt/keyrings/albert.gpg
    echo "deb [signed-by=/etc/apt/keyrings/albert.gpg] http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_$(lsb_release -rs)/ /" | sudo tee /etc/apt/sources.list.d/albert.list
    sudo apt update
    sudo apt install -y albert
  fi

  # keyd (macOS-like modifiers)
  if ! command -v keyd &>/dev/null; then
    echo "    → keyd"
    sudo apt install -y keyd 2>/dev/null || {
      cd /tmp
      git clone https://github.com/rvaiya/keyd
      cd keyd
      make && sudo make install
      cd /tmp && rm -rf keyd
    }
    sudo systemctl enable keyd
  fi

  # GPaste (GNOME clipboard manager)
  sudo apt install -y gnome-shell-extension-gpaste gpaste-2 2>/dev/null || true

  # FiraCode Nerd Font
  if ! fc-list | grep -qi "FiraCode Nerd Font"; then
    echo "    → FiraCode Nerd Font"
    FONT_VERSION=$(curl -sL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep tag_name | cut -d '"' -f4)
    curl -sLo /tmp/FiraCode.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/FiraCode.zip"
    mkdir -p ~/.local/share/fonts
    unzip -qo /tmp/FiraCode.zip -d ~/.local/share/fonts/FiraCode
    fc-cache -f
    rm -f /tmp/FiraCode.zip
  fi

  # Flatpak apps
  if command -v flatpak &>/dev/null; then
    echo "    → Flatpak apps..."
    flatpak install -y --noninteractive flathub \
      com.slack.Slack \
      org.signal.Signal \
      com.todoist.Todoist \
      com.getpostman.Postman \
      org.mozilla.Thunderbird \
      2>/dev/null || true
  fi

  echo "==> [desktop] Done."
  echo "    Log out and back in for Docker group and keyd to take effect."
}

# ═══════════════════════════════════════════════════════════════════
# DISPATCH
# ═══════════════════════════════════════════════════════════════════
case "$PROFILE" in
  server|minimal) install_server ;;
  homeserver)     install_homeserver ;;
  desktop)        install_desktop ;;
  *)
    echo "Usage: $0 {server|minimal|homeserver|desktop}"
    echo "  server|minimal — headless server (Debian/ARM-safe: tmux, zellij, mosh, starship…)"
    echo "  homeserver     — server + Docker + btop"
    echo "  desktop        — homeserver + GUI apps, fonts, keyd, Albert"
    exit 1
    ;;
esac

echo ""
echo "Make sure ~/.local/bin and ~/.cargo/bin are in your PATH."

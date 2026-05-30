#!/usr/bin/env bash
# One-time setup on perso (Pop!_OS) — requires sudo (password prompt).
# Run on the machine: bash ~/dev/perso/dotfiles/scripts/perso-sudo-setup.sh

set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$BASEDIR"

install_greenclip() {
  # Wayland (Pop!_OS COSMIC): cliphist + wl-clipboard — greenclip is X11-only
  if [[ "${XDG_SESSION_TYPE:-}" == wayland ]] || [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
    echo "==> Wayland clipboard (cliphist + wl-clipboard)"
    sudo apt install -y wl-clipboard xdg-utils
    if ! command -v cliphist &>/dev/null; then
      export PATH="$HOME/.local/bin:$(go env GOPATH 2>/dev/null)/bin:$PATH"
      go install go.senan.xyz/cliphist@latest
    fi
    return 0
  fi

  if command -v greenclip &>/dev/null; then
    return 0
  fi
  echo "==> greenclip (X11 — GitHub release)"
  local tmp arch url
  tmp="$(mktemp)"
  arch="$(uname -m)"
  case "$arch" in
    x86_64) url="https://github.com/erebe/greenclip/releases/latest/download/greenclip" ;;
    aarch64|arm64) url="https://github.com/erebe/greenclip/releases/latest/download/greenclip-arm64" ;;
    *) echo "greenclip: unsupported arch $arch"; return 1 ;;
  esac
  curl -fsSL -o "$tmp" "$url"
  chmod +x "$tmp"
  sudo install -m 755 "$tmp" /usr/local/bin/greenclip
  rm -f "$tmp"
}

install_cursor() {
  if [[ -x ~/.local/bin/cursor ]]; then
    return 0
  fi
  echo "==> Cursor (linux x64)"
  mkdir -p ~/.local/bin
  curl -fsSL -o ~/.local/bin/cursor \
    "https://api2.cursor.sh/updates/download/golden/linux-x64/cursor/latest"
  chmod +x ~/.local/bin/cursor
}

if [[ "$(hostname)" != "perso" ]]; then
  echo "==> Hostname → perso"
  sudo hostnamectl set-hostname perso
  sudo sed -i 's/\bpop-os\b/perso/g' /etc/hosts
  sudo tailscale set --hostname=perso
else
  echo "==> Hostname already perso — skip"
fi

echo "==> Apt packages (desktop gaps)"
sudo apt update
sudo apt install -y \
  fzf \
  tmux \
  mosh \
  rofi \
  golang-go \
  git-delta

install_greenclip

echo "==> bat/fd symlinks"
mkdir -p ~/.local/bin
[[ ! -e ~/.local/bin/bat ]] && ln -sf "$(command -v batcat)" ~/.local/bin/bat
[[ ! -e ~/.local/bin/fd ]]  && ln -sf "$(command -v fdfind)" ~/.local/bin/fd

install_cursor

echo "==> fzf-tab (prezto contrib)"
if [[ ! -d ~/.zprezto/contrib/fzf-tab ]]; then
  git clone https://github.com/Aloxaf/fzf-tab ~/.zprezto/contrib/fzf-tab
fi

echo "==> Fix broken ~/.local/bin/nvim shim"
rm -f ~/.local/bin/nvim

echo "==> keyd (disabled — native Linux modifiers)"
if [[ -x scripts/disable-keyd.sh ]]; then
  scripts/disable-keyd.sh
fi
sudo rm -f /etc/keyd/default.conf /etc/keyd/games-classic.conf /etc/keyd/mac-cmd-passthrough.conf 2>/dev/null || true

echo "==> Dotbot link"
./install || true

echo "==> Flatpak gaming/streaming (user install)"
if command -v flatpak &>/dev/null; then
  flatpak remote-add --if-not-exists --user flathub \
    https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
  flatpak install -y --noninteractive --user flathub \
    org.jellyfin.JellyfinDesktop \
    com.discordapp.Discord \
    2>/dev/null || true
fi

echo ""
echo "Done. From Mac: ssh perso-ts"
echo "Run: exec zsh"

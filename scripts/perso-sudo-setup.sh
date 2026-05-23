#!/usr/bin/env bash
# One-time setup on perso (Pop!_OS) — requires sudo (password prompt).
# Run on the machine: bash ~/dev/perso/dotfiles/scripts/perso-sudo-setup.sh

set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$BASEDIR"

echo "==> Hostname → perso"
sudo hostnamectl set-hostname perso
sudo sed -i 's/\bpop-os\b/perso/g' /etc/hosts
sudo tailscale set --hostname=perso

echo "==> Apt packages (desktop gaps)"
sudo apt update
sudo apt install -y \
  fzf \
  tmux \
  mosh \
  rofi \
  greenclip \
  golang-go \
  git-delta

echo "==> bat/fd symlinks"
mkdir -p ~/.local/bin
[[ ! -e ~/.local/bin/bat ]] && ln -sf "$(command -v batcat)" ~/.local/bin/bat
[[ ! -e ~/.local/bin/fd ]]  && ln -sf "$(command -v fdfind)" ~/.local/bin/fd

echo "==> Cursor AppImage"
if [[ ! -x ~/.local/bin/cursor ]]; then
  curl -fsSL -o ~/.local/bin/cursor "https://downloader.cursor.sh/linux/appImage/x64"
  chmod +x ~/.local/bin/cursor
fi

echo "==> fzf-tab (prezto contrib)"
if [[ ! -d ~/.zprezto/contrib/fzf-tab ]]; then
  git clone https://github.com/Aloxaf/fzf-tab ~/.zprezto/contrib/fzf-tab
fi

echo "==> Fix broken ~/.local/bin/nvim shim"
rm -f ~/.local/bin/nvim

echo "==> keyd config"
if command -v keyd &>/dev/null && [[ -f conf/keyd/default.conf ]]; then
  sudo cp conf/keyd/default.conf /etc/keyd/default.conf
  sudo systemctl enable keyd
  sudo systemctl restart keyd
fi

echo "==> Dotbot link"
./install

echo ""
echo "Done. After Tailscale DNS updates (~1 min), from Mac:"
echo "  ssh perso-ts"
echo "Update conf/ssh/hosts HostName to perso.tail6c9b30.ts.net when MagicDNS shows perso."
echo "Run: exec zsh"

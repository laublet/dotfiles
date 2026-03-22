#!/usr/bin/env bash
# Package installation for Pop!_OS / Ubuntu
# Mirrors the Brewfile for macOS — same CLI tools, different install methods.

set -e

echo "==> Updating apt..."
sudo apt update

# ── Available from apt ────────────────────────────────────────────
echo "==> Installing apt packages..."
sudo apt install -y \
  bat \
  fd-find \
  fzf \
  ripgrep \
  zsh

# bat and fd are installed as batcat / fdfind on Debian/Ubuntu.
# Symlink them so configs and muscle memory work consistently.
mkdir -p ~/.local/bin
[[ ! -e ~/.local/bin/bat ]] && ln -s "$(which batcat)" ~/.local/bin/bat || true
[[ ! -e ~/.local/bin/fd ]]  && ln -s "$(which fdfind)" ~/.local/bin/fd  || true

# ── Cargo-based tools (atuin, dust, sd, procs, tokei, ouch, just) ─
if ! command -v cargo &>/dev/null; then
  echo "==> Installing Rust toolchain..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

for tool in atuin du-dust sd procs tokei ouch just zellij; do
  bin_name="$tool"
  [[ "$tool" == "du-dust" ]] && bin_name="dust"
  if ! command -v "$bin_name" &>/dev/null; then
    echo "==> Installing $bin_name (cargo)..."
    cargo install "$tool"
  fi
done

# ── mise (runtime version manager) ──────────────────────────────
if ! command -v mise &>/dev/null; then
  echo "==> Installing mise..."
  curl https://mise.run | sh
fi

# ── Neovim (latest stable from PPA) ──────────────────────────────
if ! command -v nvim &>/dev/null; then
  echo "==> Installing Neovim..."
  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo apt update
  sudo apt install -y neovim
fi

# ── Starship prompt ──────────────────────────────────────────────
if ! command -v starship &>/dev/null; then
  echo "==> Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# ── zoxide ───────────────────────────────────────────────────────
if ! command -v zoxide &>/dev/null; then
  echo "==> Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# ── eza (ls replacement) ─────────────────────────────────────────
if ! command -v eza &>/dev/null; then
  echo "==> Installing eza..."
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo apt update
  sudo apt install -y eza
fi

# ── git-delta ────────────────────────────────────────────────────
if ! command -v delta &>/dev/null; then
  echo "==> Installing git-delta..."
  DELTA_VERSION=$(curl -sL https://api.github.com/repos/dandavies00/delta/releases/latest | grep tag_name | cut -d '"' -f4)
  curl -sLO "https://github.com/dandavies00/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
  sudo dpkg -i "git-delta_${DELTA_VERSION}_amd64.deb"
  rm -f "git-delta_${DELTA_VERSION}_amd64.deb"
fi

# ── lazygit ──────────────────────────────────────────────────────
if ! command -v lazygit &>/dev/null; then
  echo "==> Installing lazygit..."
  LAZYGIT_VERSION=$(curl -sL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f4 | tr -d v)
  curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  install -m 755 lazygit ~/.local/bin/lazygit
  rm -f lazygit lazygit.tar.gz
fi

# ── lazydocker ───────────────────────────────────────────────────
if ! command -v lazydocker &>/dev/null; then
  echo "==> Installing lazydocker..."
  curl -sL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

# ── WezTerm ──────────────────────────────────────────────────────
if ! command -v wezterm &>/dev/null; then
  echo "==> Installing WezTerm..."
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
  echo "deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *" | sudo tee /etc/apt/sources.list.d/wezterm.list
  sudo apt update
  sudo apt install -y wezterm
fi

# ── FiraCode Nerd Font ───────────────────────────────────────────
if ! fc-list | grep -qi "FiraCode Nerd Font"; then
  echo "==> Installing FiraCode Nerd Font..."
  FONT_VERSION=$(curl -sL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep tag_name | cut -d '"' -f4)
  curl -sLo /tmp/FiraCode.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/FiraCode.zip"
  mkdir -p ~/.local/share/fonts
  unzip -qo /tmp/FiraCode.zip -d ~/.local/share/fonts/FiraCode
  fc-cache -f
  rm -f /tmp/FiraCode.zip
fi

# ── yazi (terminal file manager) ──────────────────────────────
if ! command -v yazi &>/dev/null; then
  echo "==> Installing yazi..."
  YAZI_VERSION=$(curl -sL https://api.github.com/repos/sxyazi/yazi/releases/latest | grep tag_name | cut -d '"' -f4)
  curl -sLo /tmp/yazi.zip "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip"
  unzip -qo /tmp/yazi.zip -d /tmp/yazi
  install -m 755 /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi ~/.local/bin/yazi
  rm -rf /tmp/yazi /tmp/yazi.zip
fi

# ── keyd (system-level key remapping for macOS-like modifiers) ─
if ! command -v keyd &>/dev/null; then
  echo "==> Installing keyd..."
  sudo apt install -y keyd 2>/dev/null || {
    cd /tmp
    git clone https://github.com/rvaiya/keyd
    cd keyd
    make && sudo make install
    cd /tmp && rm -rf keyd
  }
  sudo systemctl enable keyd
fi

# ── GUI apps ──────────────────────────────────────────────────
echo "==> Installing GUI apps..."

# Cursor
if ! command -v cursor &>/dev/null; then
  echo "    → Cursor (AppImage from cursor.sh)"
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

# Docker
if ! command -v docker &>/dev/null; then
  echo "    → Docker"
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER"
fi

# Flatpak apps (Discord, Slack, Signal, Bitwarden, VLC, Todoist, Postman, Zoom)
if command -v flatpak &>/dev/null; then
  echo "    → Flatpak apps..."
  flatpak install -y --noninteractive flathub \
    com.discordapp.Discord \
    com.slack.Slack \
    org.signal.Signal \
    com.bitwarden.desktop \
    org.videolan.VLC \
    com.todoist.Todoist \
    com.getpostman.Postman \
    us.zoom.Zoom \
    2>/dev/null || true
fi

# GPaste (clipboard manager — GNOME native, replaces CopyQ/Raycast clipboard)
sudo apt install -y gnome-shell-extension-gpaste gpaste-2 2>/dev/null || true

# Albert (launcher — open source Raycast/Alfred alternative)
if ! command -v albert &>/dev/null; then
  echo "    → Albert"
  curl -fsSL https://build.opensuse.org/projects/home:manuelschneid3r/signing_keys/download?kind=gpg | sudo gpg --dearmor -o /etc/apt/keyrings/albert.gpg
  echo "deb [signed-by=/etc/apt/keyrings/albert.gpg] http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_$(lsb_release -rs)/ /" | sudo tee /etc/apt/sources.list.d/albert.list
  sudo apt update
  sudo apt install -y albert
fi

echo "==> Linux packages done."
echo "    Make sure ~/.local/bin is in your PATH."
echo "    Log out and back in for Docker group to take effect."

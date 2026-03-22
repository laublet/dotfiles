#!/usr/bin/env bash
# Package installation for Pop!_OS / Ubuntu
# Layered profiles: each level includes the previous one.
#
# Usage:
#   ./packages-linux.sh minimal     # server basics (vim, zsh, bat, fzf, rg…)
#   ./packages-linux.sh homeserver  # + neovim, lazygit, docker, dev tools
#   ./packages-linux.sh desktop     # + GUI apps, fonts, keyd, Albert
#   ./packages-linux.sh             # defaults to "desktop"

set -e

PROFILE="${1:-desktop}"
mkdir -p ~/.local/bin

# ═══════════════════════════════════════════════════════════════════
# MINIMAL — base server (vim, zsh, shell tools)
# ═══════════════════════════════════════════════════════════════════
install_minimal() {
  echo "==> [minimal] Updating apt..."
  sudo apt update

  echo "==> [minimal] Installing apt packages..."
  sudo apt install -y \
    bat \
    curl \
    fd-find \
    fzf \
    git \
    ripgrep \
    unzip \
    vim \
    wget \
    zsh

  # bat/fd are installed as batcat/fdfind on Debian/Ubuntu
  [[ ! -e ~/.local/bin/bat ]] && ln -sf "$(which batcat 2>/dev/null)" ~/.local/bin/bat || true
  [[ ! -e ~/.local/bin/fd ]]  && ln -sf "$(which fdfind 2>/dev/null)" ~/.local/bin/fd  || true

  # Rust toolchain (needed for cargo installs in both minimal and homeserver)
  if ! command -v cargo &>/dev/null; then
    echo "==> [minimal] Installing Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
  fi

  # zellij (terminal multiplexer)
  if ! command -v zellij &>/dev/null; then
    echo "==> [minimal] Installing zellij (cargo)..."
    cargo install zellij
  fi

  # starship prompt
  if ! command -v starship &>/dev/null; then
    echo "==> [minimal] Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi

  # zoxide (smart cd)
  if ! command -v zoxide &>/dev/null; then
    echo "==> [minimal] Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  fi

  # eza (ls replacement)
  if ! command -v eza &>/dev/null; then
    echo "==> [minimal] Installing eza..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
  fi

  # git-delta (diff viewer)
  if ! command -v delta &>/dev/null; then
    echo "==> [minimal] Installing git-delta..."
    DELTA_VERSION=$(curl -sL https://api.github.com/repos/dandavison/delta/releases/latest | grep tag_name | cut -d '"' -f4)
    curl -sLO "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
    sudo dpkg -i "git-delta_${DELTA_VERSION}_amd64.deb"
    rm -f "git-delta_${DELTA_VERSION}_amd64.deb"
  fi

  # tlrc (tldr client)
  if ! command -v tldr &>/dev/null; then
    echo "==> [minimal] Installing tlrc (cargo)..."
    cargo install tlrc
  fi

  echo "==> [minimal] Done."
}

# ═══════════════════════════════════════════════════════════════════
# HOMESERVER — dev tools on top of minimal
# ═══════════════════════════════════════════════════════════════════
install_homeserver() {
  install_minimal

  echo "==> [homeserver] Installing dev tools..."

  # Cargo-based CLI tools
  for tool in atuin du-dust sd procs tokei ouch just; do
    bin_name="$tool"
    [[ "$tool" == "du-dust" ]] && bin_name="dust"
    if ! command -v "$bin_name" &>/dev/null; then
      echo "==> [homeserver] Installing $bin_name (cargo)..."
      cargo install "$tool"
    fi
  done

  # Neovim (latest stable from PPA)
  if ! command -v nvim &>/dev/null; then
    echo "==> [homeserver] Installing Neovim..."
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt update
    sudo apt install -y neovim
  fi

  # mise (runtime version manager)
  if ! command -v mise &>/dev/null; then
    echo "==> [homeserver] Installing mise..."
    curl https://mise.run | sh
  fi

  # lazygit
  if ! command -v lazygit &>/dev/null; then
    echo "==> [homeserver] Installing lazygit..."
    LAZYGIT_VERSION=$(curl -sL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f4 | tr -d v)
    curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    install -m 755 lazygit ~/.local/bin/lazygit
    rm -f lazygit lazygit.tar.gz
  fi

  # lazydocker
  if ! command -v lazydocker &>/dev/null; then
    echo "==> [homeserver] Installing lazydocker..."
    curl -sL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
  fi

  # btop
  if ! command -v btop &>/dev/null; then
    echo "==> [homeserver] Installing btop..."
    sudo apt install -y btop
  fi

  # glow (markdown viewer)
  if ! command -v glow &>/dev/null; then
    echo "==> [homeserver] Installing glow..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update
    sudo apt install -y glow
  fi

  # yazi (terminal file manager)
  if ! command -v yazi &>/dev/null; then
    echo "==> [homeserver] Installing yazi..."
    YAZI_VERSION=$(curl -sL https://api.github.com/repos/sxyazi/yazi/releases/latest | grep tag_name | cut -d '"' -f4)
    curl -sLo /tmp/yazi.zip "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip"
    unzip -qo /tmp/yazi.zip -d /tmp/yazi
    install -m 755 /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi ~/.local/bin/yazi
    rm -rf /tmp/yazi /tmp/yazi.zip
  fi

  # Docker
  if ! command -v docker &>/dev/null; then
    echo "==> [homeserver] Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker "$USER"
  fi

  echo "==> [homeserver] Done."
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
  minimal)    install_minimal ;;
  homeserver) install_homeserver ;;
  desktop)    install_desktop ;;
  *)
    echo "Usage: $0 {minimal|homeserver|desktop}"
    echo "  minimal     — server basics (vim, zsh, bat, fzf, rg, zellij…)"
    echo "  homeserver  — minimal + neovim, lazygit, docker, dev tools"
    echo "  desktop     — homeserver + GUI apps, fonts, keyd, Albert"
    exit 1
    ;;
esac

echo ""
echo "Make sure ~/.local/bin and ~/.cargo/bin are in your PATH."

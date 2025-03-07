#!/bin/sh

# Install systemct
echo 'Installing System...'
sudo pacman -S --noconfirm git alacritty rxvt-unicode ntfs-3g

# Install paru
echo 'Installing Paru...'
cd ~
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ~

# Install i3 & related tooling
echo "Installing i3 and relevant tools..."
sudo pacman -S --noconfirm i3 polybar rofi feh arandr pavucontrol-qt playerctl neofetch
paru -S autorandr autotiling-git
echo "done"

# Install basics
echo 'Installing basics tools...'
sudo pacman -S --noconfirm curl wget htop xsel xclip xauth tar zip unzip p7zip net-tools openssh ufw fzf code notepaddqq ripgrep
echo "done"

echo "Installing fonts..."
paru -S --noconfirm nerd-fonts-hack nerd-fonts-source-code-pro
paru -S --noconfirm nvm robot3t-bin lazydocker nerd-fonts-hack nerd-fonts-source-code-pro
echo "done"

# Install zsh
if [ ! -e "/usr/bin/zsh" ]; then
  echo 'Installing zsh'
  sudo pacman -S zsh
  echo 'Zsh installed'
else
  echo 'Zsh already installed'
fi
# Change default shell to zsh
echo 'Changing default shell to zsh'
chsh -s /bin/zsh

#Check if prezto is installed
if [ ! -d "$HOME/.zprezto/" ]; then
  echo 'Installing prezto'
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  echo 'Prezto installed'
else
  echo 'Prezto already installed'
fi

# Install p10k
paru -Sy --noconfirm ttf-meslo-nerd-font-powerlevel10k

# Spotify
echo "Installing Spotify, get the GPG key first..."
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -

echo "Install spotify..."
paru -S --noconfirm spotify
echo "done"

# Work related
echo "Installing work apps..."
paru -S --noconfirm slack-desktop zoom
echo "done"

# Node
echo "Installing node..."
paru -S --noconfirm nvm
nvm install --lts
echo "done"

# Python
echo "Installing python..."
sudo pacman -S --noconfirm python python-pip python2
echo "done"

# Neovim
echo "Installing neovim and dependencies..."
sudo pacman -S --noconfirm neovim powerline powerline-font
echo "done"

echo "Installing neovim-remote..."
pip3 install neovim-remote
echo "done"

# tmux
echo "Installing tmux..."
sudo pacman -S --noconfirm tmux

tmux source ~/.tmux.conf
echo "done"

echo "Cloning tmux-plugins..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "done"


# Docker
echo "Installing and enabling Docker..."
sudo pacman -S --noconfirm docker docker-compose
echo "done"

echo "Enabling and starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker
echo "done"


echo "Add user to the docker user group..."
sudo gpasswd -a ${USER} docker
echo "done"

cd ~
# Prepare ssh config (need to be copied from safe)
mkdir .ssh

mkdir Pictures

cp ./wallpapers ~/Pictures/

sudo pacman -S --noconfirm libreoffice-still
paru -S stacer

echo "Rebooting"
sudo reboot

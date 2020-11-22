#!/bin/sh

# Install systemct
echo 'Installing System...'
sudo pacman -S --noconfirm git alacritty rxvt-unicode ntfs-3g

# Install yay
echo 'Installing Yay...'
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -i
cd ~

# Install i3 & related tooling
echo "Installing i3 and relevant tools..."
sudo pacman -S --noconfirm i3 polybar rofi feh arandr pavucontrol-qt playerctl neofetch
yay -S autotiling-git
echo "done"

# Install basics
echo 'Installing basics tools...'
sudo pacman -S --noconfirm curl wget htop xsel xclip tar zip unzip p7zip net-tools openssh ufw fzf code notepaddqq
echo "done"

echo "Installing fonts..."
yay -S --noconfirm nerd-fonts-hack nerd-fonts-source-code-pro
yay -S --noconfirm nvm robot3t-bin lazydocker nerd-fonts-hack nerd-fonts-source-code-pro
echo "done"

# Spotify
echo "Installing Spotify, get the GPG key first..."
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -

echo "Install spotify..."
yay -S --noconfirm spotify
echo "done"

# Work related
echo "Installing work apps..."
yay -S --noconfirm slack-desktop zoom
echo "done"

# Node
echo "Installing node..."
yay -S --noconfirm nvm
nvm install --lts
echo "done"

# Python
echo "Installing python..."
sudo pacman -S --noconfirm python python-pip python2
echo "done"

# Go
# echo "Installing go"
# sudo pacman -S --noconfirm go

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
echo "done"

echo "Cloning tmux-plugins..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "done"

# Ranger
echo "Installing ranger..."
sudo pacman -S ranger
echo "done"

echo "Adding devicons to ranger..."
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
echo "done"

echo "Installing ueberzug for ranger image support..."
pip install ueberzug
echo "done"

# Docker
echo "Installing and enabling Docker..."
sudo pacman -S --noconfirm Docker docker-compose
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
yay -S stacer

echo "Rebooting"
sudo reboot

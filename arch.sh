# Install basics
sudo pacman -S --noconfirm curl wget htop xsel xclip net-tools openssh neovim fzf tmux code

# Install yay
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -i
cd ~

## Install AUR's
yay -S --noconfirm nvm robot3t-bin lazydocker nerd-fonts-hack nerd-fonts-source-code-pro 

### Work related
yay -S --noconfirm slack-desktop zoom

### Install node
nvm install --lts

### Install python
sudo pacman -S --noconfirm python python-pip python2

## Neovim
sudo pacman -S --noconfirm powerline powerline-font

pip3 install neovim-remote

### Install tmux-plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install i3 & related tooling
sudo pacman -S --noconfirm i3 alacritty rofi feh arandr rxvt-unicode pavucontrol-qt 
yay autotiling-git

## Install ranger
sudo pacman -S ranger

### Add devicons for ranger
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

### Add image support for ranger
pip install ueberzug

# Install go
sudo pacman -S --noconfirm go

# Docker
sudo pacman -S --noconfirm Docker

sudo systemctl enable docker
sudo systemctl start docker

# Prepare ssh config
mkdir ~/.ssh

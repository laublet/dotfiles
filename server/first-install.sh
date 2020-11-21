#!/bin/bash

# Basics
sudo apt-get install curl wget htop xsel xclip -y

# Install xauth (for copy over ssh)
sudo apt-get install xauth -y

if [ ! -e "/usr/bin/zsh" ]; then
  echo 'Installing zsh'
  sudo apt-get install zsh -y
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

# Install Tmux & tmux-plugins manager
if [ ! -e "/usr/bin/tmux" ]; then
  echo 'Installing tmux'
  sudo apt-get install tmux -y

  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  tmux source ~/.tmux.conf
  echo 'Tmux installed'
else
  echo 'Tmux already installed'
fi

# Install vim && vim-plug
if [ ! -e "/usr/bin/vim" ]; then
  echo 'Installing vim'
  sudo apt-get install vim -y

  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo 'Vim installed'
else
  echo 'Vim already installed'
fi

# Install fzf
if [ ! -e "$HOME/.fzf" ]; then
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
else
  echo 'fzf already installed'
fi

#!/bin/sh

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Basics
brew install bat fd fnm fzf htop neovim ripgrep vim wget zoxide zsh 

# Dev / work
brew install awscli sqlite yarn 

# Granted 
brew tap common-fate/granted
brew install granted

# Utils
brew install bitwarden

# Install Casks
brew install --cask nikitabobko/tap/aerospace
brew install --cask chatgpt copyq cursor choosy discord docker firefox firefox@developer-edition google-chrome obsidian postman raycast slack steermouse todoist vlc wezterm zoom

brew install --cask aws-vpn-client

# Perso
brew install --cask nvidia-geforce-now philips-hue-sync

# Install Fonts
brew install --cask font-hack-nerd-font font-atkinson-hyperlegible

IF [ ! -d "$HOME/.zprezto/" ]; then
  echo 'Installing prezto'
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  echo 'Prezto installed'
else
  echo 'Prezto already installed'
fi
# Need to go to the app store for these
# amphetamine


#!/bin/sh

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Basics
brew install bat fd fnm fzf htop neovim ripgrep vim wget zoxide zsh 

# Dev / work
brew install awscli granted sqlite yarn 

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

# Need to go to the app store for these
# amphetamine


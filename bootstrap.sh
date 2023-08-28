#!/bin/sh
# `bootstrap` handles installation of the dotfiles.

echo "Setting up your Mac"

# If any command returns a non-zero exit code, the script will terminate
set -e

export DOTFILES=$HOME/.dotfiles

# Set macOS defaults
/bin/bash $DOTFILES/macos/set-defaults.sh

# Installs Homebrew (if not installed)
if test ! $(which brew)
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Brewfile dependencies
brew bundle --file ~/.dotfiles/Brewfile

## Git
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

## VSCode
rm -rf $HOME/Library/Application\ Support/Code/User
mkdir -p $HOME/Library/Application\ Support/Code
ln -s $DOTFILES/vscode/User $HOME/Library/Application\ Support/Code/User
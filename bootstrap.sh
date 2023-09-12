#!/bin/sh
# `bootstrap` handles installation of the dotfiles.

echo "Setting up your Mac"

export DOTFILES=$HOME/.dotfiles

# Set macOS defaults
/bin/bash $DOTFILES/macos/set-defaults.sh

# Installs Homebrew (if not installed)
if test ! $(which brew)
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install Brewfile dependencies
brew bundle --file ~/.dotfiles/Brewfile

# Symlink gitcongig
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

# Symlink VSCode settings
rm -rf $HOME/Library/Application\ Support/Code/User
mkdir -p $HOME/Library/Application\ Support/Code
ln -s $DOTFILES/vscode/User $HOME/Library/Application\ Support/Code/User

# Install Mac App Store applications
read -p "Do you want to install creative apps? (yes/no): " choice

if [[ "$choice" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Great! Proceeding with Mac App Store app installation."
    mas 824171161 # Affinity Designer
    mas 824183456 # Affinity Photo
    mas 424390742 # Compressor
    mas 424389933 # Final Cut Pro
    mas 434290957 # Motion
else
    echo "No problem! Skipping Mac App Store app installation."
fi
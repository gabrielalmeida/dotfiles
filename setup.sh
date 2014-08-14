#!/bin/bash
echo "Make sure git and curl are installed to get this setup working!"
echo "Installing oh-my-zsh shell."
curl -L http://install.ohmyz.sh | sh

if [ ! -d ~/.dotfiles_backup ]; then
  echo "Creating backup directory."
  mkdir ~/.dotfiles_backup
fi

if [ ! -d ~/bin.]; then
  echo "Creating bin directory."
  mkdir ~/bin
fi


if [ -e ~/.zshrc ]; then
    mv ~/.zshrc ~/.dotfiles_backup
    echo ".zshrc Backed up"
fi

if [ -e ~/.tmux.conf ]; then
    mv ~/.tmux.conf ~/.dotfiles_backup
    echo ".tmux.conf Backed up"
fi

echo "Creating dotfiles symlinks"
ln -nsf "$PWD"/zshrc ~/.zshrc
ln -nsf "$PWD"/bin/* ~/bin
ln -nsf "$PWD"/gitconfig ~/.gitconfig
ln -nsf "$PWD"/tmux.conf ~/.tmux.conf

echo "I'll clone dotvim now:"
git clone https://github.com/gabrielalmeida/dotvim ~/dotvim
echo "Starting dotvim setup automatically!"
cd ~/dotvim
./setup.sh

echo "Dotfiles setup is complete"

zsh
echo "Trying to change to zsh, if it does not occur try by yourself: \$zsh"

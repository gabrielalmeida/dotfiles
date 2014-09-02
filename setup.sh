#!/bin/bash
echo "Make sure git and curl are installed to get this setup working!"
echo "Installing oh-my-zsh shell."
curl -L http://install.ohmyz.sh | sh

if [ ! -d ~/dotfiles_backup ]; then
  echo "Creating backup directory."
  mkdir ~/dotfiles_backup
fi

if [ ! -d ~/bin ]; then
  echo "Creating bin directory."
  mkdir ~/bin
fi

if [ -e ~/.zshrc ]; then
    mv -f ~/.zshrc ~/dotfiles_backup; rm -f ~/.zshrc
    echo ".zshrc Backed up"
fi

if [ -e ~/.gitconfig ]; then
    mv -f ~/.gitconfig ~/dotfiles_backup; rm -f ~/.gitconfig
    echo ".gitconfig Backed up"
fi

if [ -e ~/dotvim ]; then
    mv -f ~/dotvim ~/dotfiles_backup; rm -rf ~/dotvim
    echo "dotvim dir Backed up"
fi

if [ -e ~/.tmux.conf ]; then
    mv -f ~/.tmux.conf ~/dotfiles_backup
    echo ".tmux.conf Backed up"
fi

echo "Creating dotfiles symlinks"
ln -nsf "$PWD"/zshrc ~/.zshrc
ln -nsf "$PWD"/bin/* ~/bin
ln -nsf "$PWD"/tmux.conf ~/.tmux.conf
ln -nsf "$PWD"/gitconfig ~/.gitconfig
ln -nsf "$PWD"/ssh/config ~/.ssh/config

echo "Cloning zsh-plugins now:"
rm -rf "$PWD"/zsh-plugins; mkdir "$PWD"/zsh-plugins
cd "$PWD"/zsh-plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting
git clone https://github.com/hchbaw/opp.zsh

echo "I'll clone dotvim now:"
git clone https://github.com/gabrielalmeida/dotvim ~/dotvim
echo "Starting dotvim setup automatically!"
cd ~/dotvim
./setup.sh

echo "Dotfiles setup is complete"

zsh
echo "Trying to change to zsh, if it does not occur try by yourself: \$zsh"

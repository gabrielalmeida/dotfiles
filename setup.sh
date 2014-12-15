#!/bin/bash

echo "Make sure git and curl are installed to get this setup working!"

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
ln -nsf "$PWD"/files/zshrc ~/.zshrc
ln -nsf "$PWD"/bin/* ~/bin
ln -nsf "$PWD"/files/tmux.conf ~/.tmux.conf
ln -nsf "$PWD"/files/gitconfig ~/.gitconfig
ln -nsf "$PWD"/files/config ~/.ssh/config
ln -nsf "$PWD"/files/vimrc ~/.vimrc

run_scripts() {
  rm -rf /tmp/dotfiles
  git clone https://github.com/gabrielalmeida/dotfiles.git /tmp/dotfiles/

  # concatenate all shell scripts together, so things like variables can be reused
  cat /tmp/dotfiles/scripts/*.sh > /tmp/script
  bash /tmp/script
}

run_scripts

echo "Dotfiles setup is complete"

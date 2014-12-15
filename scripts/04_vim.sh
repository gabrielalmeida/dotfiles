#!/usr/bin/env bash

if [ ! -d ~/.vim_swp ]; then
  echo "Creating swp directory."
  mkdir ~/.vim_swp
fi

if [ -d ~/.vim ]; then
  echo "Creating vim backup directory."
  cp -R ~/.vim ~/.vim_backup; rm -rf ~/.vim
fi

#echo "Creating vim symlinks"
#mv "/tmp/dotfiles/files/vimrc" "${HOME}/.vimrc"

if [ -d vim/bundle ]; then
  echo "Cleaning bundle directory."
  rm -rf vim/bundle/*
fi

if [ ! -d vim/bundle ]; then
  echo "Creating bundle directory."
  mkdir -p "$PWD"/vim/bundle
fi

echo "Cloning neobundle into bundle directory"
git clone https://github.com/Shougo/neobundle.vim vim/bundle/neobundle.vim

mv -f "$PWD"/vim ~/.vim

echo "Installing bundles"
"$HOME"/.vim/bundle/neobundle.vim/bin/neoinstall

echo "Vim setup is complete"

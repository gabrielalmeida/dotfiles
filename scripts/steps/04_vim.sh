#!/usr/bin/env bash

if [ $(ask "Should I mess with vim?") == 'y' ]; then

  if [ ! -d ~/.vim_swp ]; then
    echo "Creating swp directory."
    mkdir ~/.vim_swp
  fi

  if [ -d "$PWD"/vim/bundle ]; then
    echo "Cleaning bundle directory."
    rm -rf "$PWD"/vim/bundle/*
    mkdir -p "$PWD"/vim/bundle
  fi

  echo "Cloning neobundle into bundle directory"
  git clone https://github.com/Shougo/neobundle.vim vim/bundle/neobundle.vim

  mv -f "$PWD"/vim ~/.vim

  echo "Installing bundles"
  "$HOME"/.vim/bundle/neobundle.vim/bin/neoinstall

  echo "Vim setup is complete"
fi

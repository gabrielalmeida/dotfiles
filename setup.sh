#!/bin/bash

# TODO Verify which OS is running this install and make it agnostic(remove .osx configs for eg)
# TODO Make it more flexible/optional steps
# TODO Check if its a full install(including apps/OS configs/etc)  or if want ONLY dotfiles installed/re-installed 
# TODO Make an "namespaced/isolated" mode for dotfiles, where everything overwritten will be backup'ed and can be restored to original version with a single command run(./setup.sh restore-original)

echo "Make sure git and curl are installed to get this setup working!"

display_help() {
  cat <<-EOF
  Usage: ./setup.sh [options]
  Options:
    -h|--help|help                Display help
    -i|--install|install          Perform dotfiles install 
EOF
  exit 0
}

run_scripts() {
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


  rm -rf /tmp/dotfiles
  git clone https://github.com/gabrielalmeida/dotfiles.git /tmp/dotfiles/

  # concatenate all shell scripts together, so things like variables can be reused
  cat /tmp/dotfiles/scripts/*.sh > /tmp/script
  bash /tmp/script
}

install() {
  while true; do
    read -p "Do you want to install dotfiles WITH SUDO PERMISSION?
    1. NO -> Install dotfiles WITHOUT sudo permission – Will install only what
    doesn't require sudo/can be installed without asking permmission
    2. YES -> Install dotfiles WITH sudo permission – Complete Install
    [choose #]: " env

    case "$env" in
      "1"|"no_sudo"|"without"|"no"|"n")
        DOTFILES_SUDO="install_without_sudo"
        break;
        ;;
      "2"|"sudo"|"yes"|"y")
        DOTFILES_SUDO="install_with_sudo"
        break;
        ;;
      *) echo "**** Try again. Use 'ctrl + C' to stop."; echo; ;;
    esac
  done

  run_scripts
}

install_without_ask_sudo() {
  DOTFILES_SUDO="install_without_sudo"
  run_scripts
}

if [ $# -eq 0 ]; then
  #install_without_ask_sudo
  display_help
else
  while [ $# -ne 0 ]; do
    case $1 in
      -h|--help|help)                  display_help ;;
      -i|--install|install)            install ;;
      *)                               display_help ;;
    esac
    shift
  done
  install $1
fi

echo "Dotfiles setup is complete"

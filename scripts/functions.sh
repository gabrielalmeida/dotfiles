#!/bin/bash

display_help() {
  cat <<-EOF
  Usage: ./setup.sh [options]
  Options:
    -h|--help|help                   Display help
    -i|--install|install             Install dotfiles, apps and other settings/tweaks
    -d|--dotfiles|dotfiles           Install dotfiles only
    -u|--update|update               Update to latest remote version
    -r|--revert|revert               Revert to your original settings

EOF
  exit 0
}

backup() {
  if [ $# -eq 0 ]; then
    echo "Backup functions needs ONE param"

  else

    for file in "$@"; do
      full_path=$(python -c "import os.path; print os.path.relpath('$file', '$HOME')")
      filename=$(basename "$full_path")
      path=$(dirname "$full_path")
      if [ ! -d ~/dotfiles_backup/"$path" ]; then
        mkdir -p ~/dotfiles_backup/"$path"
      fi
      if [ -e "$1" ]; then
        mv -f "$1" ~/dotfiles_backup/"$path"/"$filename"
        echo "$1 Backed up. 😙 "
      fi
    done

  fi
}

revert() {
  if [ ! -d ~/dotfiles_backup ];then
    echo "There is no backup available, perhaps you have never installed gabrielalmeida/dotfiles before so you don't have a backup? Maybe ${HOME}/backup_dotfiles got rm/mv command."
    exit 0;
  else
    while true; do
      read -p "Do you really want this?
       It will overwrite your present settings with the version that you have backuped(check "${HOME}"/dotfiles_backup dir).
      1. YES -> Recover my stuff from backup now! I know it will overwrite my current settings, no problem, I hated them.
      2. NO  -> Ok, I'll do nothing!
      [Choose #]: " option

      case "$option" in
        "1"|"yes"|"y")
          cp -Rf ~/dotfiles_backup/ ${HOME}
          echo "Hey, you have your files again at '${HOME}'!"
          break;
          ;;
        "2"|"no"|"n")
          echo "Exiting.."
          break;
          ;;
        *) echo "**** Try again. Use 'ctrl + C' to stop."; echo; ;;
      esac
    done
  fi
}

run_backup() {

  if [ -d "${HOME}"/dotfiles_backup ]; then
    echo "Cleaning/Creating backup directory."
    rm -rf "${HOME}"/dotfiles_backup
    mkdir "${HOME}"/dotfiles_backup
  fi

  backup "${HOME}"/.spacemacs
  backup "${HOME}"/.zshrc
  backup "${HOME}"/.vim
  backup "${HOME}"/.gitconfig
  backup "${HOME}"/.tmux.conf
  backup "${HOME}"/.ssh/config
  echo "Backup complete, check restore command or ~/dotfiles_backup folder"
}

run_scripts() {

  if [ ! -d ~/bin ]; then
    echo "Creating bin directory."
    mkdir ~/bin
  fi

  run_backup

  echo "Creating dotfiles symlinks"
  ln -nsf "$PWD"/files/zshrc ~/.zshrc
  ln -nsf "$PWD"/files/spacemacs ~/.spacemacs
  ln -nsf "$PWD"/bin ~/bin
  ln -nsf "$PWD"/files/tmux.conf ~/.tmux.conf
  ln -nsf "$PWD"/files/eslintrc ~/.eslintrc
  ln -nsf "$PWD"/files/gitconfig ~/.gitconfig
  ln -nsf "$PWD"/files/ssh-config ~/.ssh/config
  ln -nsf "$PWD"/files/vimrc ~/.vimrc

  #rm -rf /tmp/dotfiles
  #git clone https://github.com/gabrielalmeida/dotfiles.git /tmp/dotfiles/

  ## concatenate all shell scripts together, so things like variables can be reused
  cat "$PWD"/scripts/steps/*.sh > /tmp/script
  bash /tmp/script
}

exists() {
  command -v "$1" >/dev/null 2>&1;
}

update() {
  echo "Sorry, update not implemented yet, do it with git!"
  exit 0;
}

install_only_dotfiles() {
  while true; do
    read -p "Do you really want this? It'll change some of your settings, but everything overwritten will be backuped at '${HOME}'/dotfiles_backup
    1. YES -> I'll replace files like ~/.vim and ~/.tmux.conf, just to name a few
    2. NO  -> Ok, bye.
    [Choose #]: " option

    case "$option" in
      "1"|"y"|"yes")
        INSTALL="DOTFILES"
        echo "Installing!"
        run_scripts
        break;
        ;;
      "2"|"n"|"no")
        echo "Quit."
        break;
        ;;
      *) echo "**** Try again. Use 'ctrl + C' to stop."; echo; ;;
    esac
  done
}

ask() {
  while true; do
    read -p "$1
    1. Yes
    2. No
    [Choose #]: " option

    if [ "$INSTALL" == 'EVERYTHING' ]; then
      echo 'y'
      break;
    fi

    case "$option" in
      "1"|"yes"|"y")
        echo 'y'
        break;
        ;;
      "2"|"no"|"n")
        echo 'n'
        break;
        ;;
      *) echo "**** Try again. Use 'ctrl + C' to stop."; echo; ;;
    esac
  done

}

install() {
  while true; do
    read -p "Which OS are you using?
    1. OS X -> Will be able to install everything
    2. LINUX -> Will install only dotfiles/compatible stuff
    [Choose #]: " option

    case "$option" in
      "1"|"osx"|"mac")
        OS="OSX"
        break;
        ;;
      "2"|"linux")
        OS="LINUX"
        break;
        ;;
      *) echo "**** Try again. Use 'ctrl + C' to stop."; echo; ;;
    esac
  done

  if [ "$OS" == 'OSX' ]; then
    while true; do
      read -p "Do you want to install apps and other perks?
      1. YES, just install everything
      2. YES, but let me choose what to install
      3. NO, only dotfiles please
      4. NO, nein, nothing, nada – Cancel install
      [Choose #]: " option

      case "$option" in
        "1")
          INSTALL="EVERYTHING"
          break;
          ;;
        "2")
          INSTALL="CHOOSE"
          break;
          ;;
        "3")
          INSTALL="DOTFILES"
          break;
          ;;
        "4")
          INSTALL="CANCEL"
          break;
          ;;
        *) echo "**** Try again. Use 'ctrl + C' to stop."; echo; ;;
      esac
    done
  fi

  if [ "$INSTALL" == "CANCEL" ]; then
    echo "Install aborted."
  else
    echo "Installing!"
    run_scripts
  fi
}

if [ "$FUNCTIONS_LOADED" != 'TRUE' ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "${DIR}/../functions.sh"
fi

install_zsh() {
    brew install zsh --without-etcdir
}

install_zplug() {
  sh -c "$(curl -sL get.zplug.sh | zsh)"
}

make_zsh_default_shell() {
  sudo sh -c "echo '/usr/bin/zsh' >> /etc/shells"
  chsh -s "/bin/zsh"
}

if [ "$BREW" == 'y' ]; then
  if [ $(ask "Should I install zsh?") == 'y' ]; then
      install_zsh
      install_zplug

    if [ $(ask "Should I make zsh the default shell?") == 'y' ]; then
        make_zsh_default_shell
    fi
  fi
fi

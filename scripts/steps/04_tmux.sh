if [ "$FUNCTIONS_LOADED" != 'TRUE' ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "${DIR}/../functions.sh"
fi

install_tmux() {
    brew install --HEAD tmux
}

install_tpm() {
# Tmux plugin manager
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

if [ "$BREW" == 'y' ]; then
  if [ $(ask "Should I install tmux?") == 'y' ]; then
      install_tmux
      install_tpm

      echo "Remember to install plugins form TPM(Tmux Plugin Manager) \
        at first run. Press PREFIX + I; eg: Ctrl-A + I"
  fi
fi

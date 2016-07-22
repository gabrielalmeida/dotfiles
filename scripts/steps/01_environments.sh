if [ "$FUNCTIONS_LOADED" != 'TRUE' ]; then
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  source "${DIR}/../functions.sh"
fi

install_xcode() {
  if ! xcode-select --print-path 2> /dev/null; then
    xcode-select --install

    until xcode-select --print-path 2> /dev/null; do
      sleep 5
    done
  fi
}

update_osx() {
  # make sure system is up-to-date
  softwareupdate --install --all
}

install_brew() {
  renew_sudo
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
}

install_python() {
  brew install python

  # install some eggs
  pip3 install glances
}

install_ruby() {
  brew install ruby
  # install some gems
  gem install --no-document pygments.rb # needed for installing ghi with brew
}

install_node() {
  brew install node
  # install some packages
  npm install --global eslint how2 jsonlint nativefier nightmare pageres-cli updtr gulp tldr
}

if [ "$OS" == 'OSX' ] && { [ "$INSTALL" == 'EVERYTHING' ] || [ "$INSTALL" == "CHOOSE" ]; } then

  # TODO – Dependency check/solve less piggy
  if ! exists curl; then
    echo "You MUST have curl installed";
    exit 0;
  fi

  if ! exists ruby; then
    echo "You MUST have ruby installed";
    exit 0;
  fi

  if [ $(ask "Should I install Xcode?") == 'y' ]; then
    install_xcode
  fi;

  if [ $(ask "Should I check if OSX is up-to-date?") == 'y' ]; then
    update_osx
  fi;

  if [ $(ask "Should I install homebrew? If you choose to not install homebrew,
    most of the next install options will be skipped because they depends on
    brew to be installed") == 'y' ]; then
    if exists brew; then
      BREW='y'
      if [ $(ask "It looks like brew is already installed, should I skip
        this step??") == 'n' ]; then
        install_brew
      fi
    else
      install_brew
      BREW='y'
    fi
  fi


  if [ "$BREW" == 'y' ]; then
    if [ $(ask "Should I install python?") == 'y' ]; then
      install_python
    fi

    if [ $(ask "Should I update ruby and install some cool gems?") == 'y' ]; then
      install_ruby
    fi

    if [ $(ask "Should I install node and install some nice packages") == 'y' ]; then
      install_node
    fi

  fi

fi

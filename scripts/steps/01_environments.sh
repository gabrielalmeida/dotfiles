install_brew() {
    renew_sudo
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
}

install_python() {
    brew reinstall pyenv
    local python2="$(pyenv install --list | tr -d ' ' | grep '^2' | grep --invert-match 'dev\|a\|b' | tail -1)"
    local python_latest="$(pyenv install --list | tr -d ' ' | grep '^\d' | grep --invert-match 'dev\|a\|b' | tail -1)"
    pyenv install "${python2}"
    pyenv install "${python_latest}"
    if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
    pyenv global "${python_latest}"
    # install some eggs
    pip install livestreamer subliminal cheat
}

install_ruby() {
    brew reinstall chruby ruby-install
    ruby-install --src-dir "$(mktemp -d)" --latest ruby
    source '/usr/local/share/chruby/chruby.sh'
    chruby ruby
    # install some gems
    gem install --no-document bundler chromedriver2-helper maid pry redcarpet rubocop seeing_is_believing site_validator video_transcoding watir-webdriver
}

install_node() {
    brew reinstall nvm
    export NVM_DIR="${HOME}/.nvm"
    source "$(brew --prefix nvm)/nvm.sh"
    nvm install node
    nvm alias default node
    # install some packages
    npm install --global eslint how2 jsonlint nativefier nightmare pageres-cli updtr watch gulp grunt-cli bower vtop gitignore harp puer imageoptim-cli
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
       install_brew
   fi

   if [ "$BREW" == 'y' ] && { [ $(ask "Should I install python?") == 'y' ]; } then
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

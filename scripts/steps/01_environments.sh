# PATH
export PATH="/usr/local/bin:$PATH"

echo "$OS"
echo "$INSTALL"

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

  if [ $(ask "Should I check if system is up-to-date?") == 'y' ]; then
    # make sure system is up-to-date
    softwareupdate --install --all --background
  fi;


  if [ $(ask "Should I install homebrew? If you choose to not install homebrew,
    most of the next install options will be skipped because they depends on
    brew to be installed") == 'y' ]; then

    # install homebrew
    BREW="y"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  #if [ "$BREW" == 'y' ] && { [ $(ask "Should I install python?") == 'y' ]; } then
  if [ "$BREW" == 'y' ]; then

    if [ $(ask "Should I install python?") == 'y' ]; then
      # python environment
      brew install python
      # install some eggs
      pip install asciinema livestreamer subliminal
    fi

    if [ $(ask "Should I update ruby and install some cool gems?") == 'y' ]; then
      # ruby environment
      brew install ruby
      # install some gems
      export GEM_HOME="$(brew --prefix)"
      gem install --no-ri --no-rdoc bundler chromedriver2-helper csscss did_you_mean
      jekyll pry redcarpet ronn site_validator watir-webdriver
    fi

    if [ $(ask "Should I install node and install some nice packages") == 'y' ]; then
      # nodejs environment
      brew install node
      # install some packages
      npm install --global github-todos browser-sync gulp bower vtop divshot-cli gitignore grunt-cli harp
      html2jade imageoptim-cli nightmare pageres puer tldr
    fi

  fi

fi

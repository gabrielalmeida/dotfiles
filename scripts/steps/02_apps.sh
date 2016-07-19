if [ "$FUNCTIONS_LOADED" != 'TRUE' ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "${DIR}/../functions.sh"
fi

install_brew_apps() {
    brew install imagemagick --with-libtiff
    brew install ffmpeg --with-libvpx --with-libvorbis --with-openssl --with-theora --with-x265
    brew install --HEAD --with-bundle mpv

    brew install pandoc wakatime-cli z reattach-to-user-namespace subliminal cheat livestreamer aria2 asciinema atool ccat cpulimit duff duti exiftool eye-d3 gifify git git-extras ghi hub git-ftp haskell-stack hr httpie jq lftp mediainfo mkvtoolnix mp4v2 phantomjs pup shellcheck the_silver_searcher trash tree wiki youtube-dl fasd ranger watchman namebench mackup

    brew tap railwaycat/emacsmacport
    brew install emacs-mac --with-spacemacs-icon --with-imagemagick
}

install_cask_apps() {
  brew cask install calibre drop-to-gif dropbox flux fog gifloopcoder gitup
  brew cask install google-chrome handbrakecli imageoptim jadengeller-helium key-codes screenflow
  brew cask install shotcut spectacle transmission vlc mplayerx skype 
  brew cask install evernote sublime-text3 amethyst teamviewer spotify robomongo
  brew cask install franz hyperterm mou launchrocket karabiner

  # install alternative versions
  brew tap caskroom/versions
  brew cask install atom-beta google-chrome-canary

  # prefpanes, qlplugins, colorpickers
  brew cask install betterzipql colorpicker-skalacolor epubquicklook qlcolorcode qlimagesize qlplayground qlstephen quicklook-json ttscoff-mmd-quicklook qlmarkdown

  # fonts
  brew tap caskroom/fonts
  # multiple
  brew cask install font-alegreya font-alegreya-sans font-alegreya-sans-sc font-alegreya-sc
  brew cask install font-source-code-pro font-source-sans-pro font-source-serif-pro
  brew cask install font-pt-mono font-pt-sans font-pt-serif
  brew cask install font-merriweather font-merriweather-sans
  brew cask install font-fira-mono font-fira-sans
  # sans
  brew cask install font-exo2 font-lato font-open-sans font-open-sans-condensed font-signika
  # serif
  brew cask install font-abril-fatface font-butler font-gentium-book-basic font-playfair-display font-playfair-display-sc
  # slab
  brew cask install font-bitter font-kreon
  # script
  brew cask install font-pacifico
}

install_atom_packages() {
    # packages
    apm install atom-alignment color-picker dash esformatter git-plus highlight-line language-jade language-swift linter linter-eslint linter-jsonlint linter-rubocop linter-shellcheck merge-conflicts node-debugger p5xjs-autocomplete pigments relative-numbers seeing-is-believing vim-mode vim-surround

    # themes and syntaxes
    apm install peacock-syntax seti-ui
}

install_fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

if [ "$OS" == 'OSX' ] && { [ "$INSTALL" == 'EVERYTHING' ] || [ "$INSTALL" == "CHOOSE" ]; } then

  if [ $(ask "Should I install brew apps?") == 'y' ]; then
      install_brew_apps
  fi

  if [ $(ask "Should I install cask apps?") == 'y' ]; then
      install_cask_apps
  fi

  if [ $(ask "Should I install FZF?") == 'y' ]; then
      install_fzf
  fi

  if [ $(ask "Should I install Atom packages?") == 'y' ]; then
      install_atom_packages
  fi
fi

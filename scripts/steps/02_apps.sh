if [ "$FUNCTIONS_LOADED" != 'TRUE' ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "${DIR}/../functions.sh"
fi

install_brew_apps() {
    brew install imagemagick
    brew install ffmpeg --with-libvorbis --with-openssl --with-theora --with-x265
    brew install --HEAD mpv

    brew install thefuck pandoc wakatime-cli z reattach-to-user-namespace subliminal cheat livestreamer aria2 asciinema atool ccat cpulimit duff duti exiftool eye-d3 gifify git git-extras ghi hub git-ftp haskell-stack hr httpie jq lftp mediainfo mkvtoolnix mp4v2 pup shellcheck the_silver_searcher trash tree wiki youtube-dl fasd ranger watchman namebench mackup bat fd

    brew tap railwaycat/emacsmacport
    brew install emacs-mac --with-spacemacs-icon --with-imagemagick
}

install_cask_apps() {
  brew install --cask calibre drop-to-gif flux fog gifloopcoder gitup
  brew install --cask google-chrome handbrakecli imageoptim jadengeller-helium key-codes screenflow
  brew install --cask shotcut raycast transmission vlc mplayerx 
  brew install --cask sublime-text3 amethyst teamviewer spotify robomongo
  brew install --cask warp mou launchrocket karabiner resolutionator

  # install alternative versions
  brew tap caskroom/versions
  brew install --cask google-chrome-canary

  # prefpanes, qlplugins, colorpickers
  brew install --cask betterzipql colorpicker-skalacolor epubquicklook qlcolorcode qlimagesize qlplayground qlstephen quicklook-json ttscoff-mmd-quicklook qlmarkdown

  # fonts
  brew tap caskroom/fonts
  # multiple
  brew install --cask font-alegreya font-alegreya-sans font-alegreya-sans-sc font-alegreya-sc
  brew install --cask font-source-code-pro font-source-sans-pro font-source-serif-pro
  brew install --cask font-pt-mono font-pt-sans font-pt-serif
  brew install --cask font-merriweather font-merriweather-sans
  brew install --cask font-fira-mono font-fira-sans
  # sans
  brew install --cask font-exo2 font-lato font-open-sans font-open-sans-condensed font-signika
  # serif
  brew install --cask font-abril-fatface font-butler font-gentium-book-basic font-playfair-display font-playfair-display-sc
  # slab
  brew install --cask font-bitter font-kreon
  # script
  brew install --cask font-pacifico
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

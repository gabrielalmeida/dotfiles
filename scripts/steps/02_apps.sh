
install_brew_apps() {
    brew install imagemagick --with-libtiff
    brew install ffmpeg --with-libvpx --with-libvorbis --with-openssl --with-theora --with-x265
    brew install mpv --with-bundle
    brew install sox --with-flac --with-lame --with-libvorbis
    brew install zsh --without-etcdir

    brew install aria2 asciinema atool ccat cpulimit duff duti exiftool eye-d3 gifify git git-extras ghi hub git-ftp haskell-stack hr httpie jq lftp mediainfo mkvtoolnix mp4v2 onepass phantomjs pup shellcheck the_silver_searcher trash tree wiki youtube-dl fasd ranger peerflix watchman namebench mackup

    brew install vim --with-lua
    brew install railwaycat/emacsmacport/emacs-mac --with-spacemacs-icon --with-imagemagick

    # install apps from other taps
    brew install laurent22/massren/massren
    brew install peco/peco/peco

    # install and configure tor
    brew install tor torsocks
    cp "$(brew --prefix)/etc/tor/torrc.sample" "$(brew --prefix)/etc/tor/torrc"
    echo 'ExitNodes {us}' >> "$(brew --prefix)/etc/tor/torrc"
}

make_caskroom() {
  sudo -S mkdir -p /opt/homebrew-cask/Caskroom <<< "${sudo_password}" 2> /dev/null
  sudo -S chown -R ${USER}:staff /opt/homebrew-cask <<< "${sudo_password}" 2> /dev/null
}

install_cask_apps() {
  brew cask install --appdir='/Applications' calibre drop-to-gif dropbox duelystlauncher enjoyable flux fog gifloopcoder gitup google-chrome handbrakecli imageoptim jadengeller-helium key-codes screenflow shotcut spectacle torbrowser transmission yacreader vlc mplayerx skype sunrise evernote sublime-text3 amethyst pokerstars teamviewer

  # install alternative versions
  brew tap caskroom/versions
  brew cask install --appdir='/Applications' atom-beta google-chrome-canary iterm2-beta openemu-experimental

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
      make_caskroom
      install_cask_apps
  fi

  if [ $(ask "Should I install FZF?") == 'y' ]; then
      install_fzf
  fi

  if [ $(ask "Should I install Atom packages?") == 'y' ]; then
      install_atom_packages
  fi
fi

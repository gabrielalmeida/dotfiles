if [ "$OS" == 'OSX' ] && { [ "$INSTALL" == 'EVERYTHING' ] || [ "$INSTALL" == "CHOOSE" ]; } then

  # TODO – Segment/organize apps per categories
  # TODO – Ask for install accordingly to categories

  if [ $(ask "Should I install all your stuff?") == 'y' ]; then
    # homebrew apps
    brew install atool cpulimit duff exiftool eye-d3 gifify git git-flow git-extras git-ftp
    hr jq lftp mackup mediainfo mkvtoolnix mp4box namebench peerflix phantomjs pup
    ranger shellcheck the_platinum_searcher trash tree watchman youtube-dl fasd
    brew install imagemagick --with-libtiff
    brew install ffmpeg --with-libvpx --with-libvorbis --with-openssl --with-theora --with-x265
    brew install macvim --with-lua --custom-icons
    brew install vim --with-lua
    brew install sox --with-flac --with-lame --with-libvorbis
    brew install hub
    brew install railwaycat/emacsmacport/emacs-mac --with-spacemacs-icon --with-imagemagick 

    brew install zsh --disable-etcdir

    # install apps from other taps
    brew install mpv-player/mpv/mpv
    brew install laurent22/massren/massren
    brew install peco/peco/peco

    # homebrew-cask apps
    # install brew cask
    brew install caskroom/cask/brew-cask

    # set caskroom permissions
    mkdir -p /opt/homebrew-cask/Caskroom
    sudo chown -R ${USER}:staff /opt/homebrew-cask

    # install apps
    # airserver alfred apikitchen bartender
    # bettertouchtool cocoadialog couleurs dropbox enjoyable flashlight flux fontprep
    # google-chrome hex-fiend hexels hydra imageoptim instacast iterm2 joinme keka
    # key-codes leap-motion macaw node-webkit nsregextester openemu p5 platypus
    # pokerstars processing screenflow shotcut spectacle steam sublime-text subtitles
    # textexpander transmission whiskey yacreader evernote mplayerx
    # mailbox skype

    brew cask install --appdir="/Applications" evernote dropbox spectacle
    google-chrome iterm2 mplayerx skype sunrise transmission sublime-text3
    atom vlc amethyst

    # install alternative versions
    brew cask install caskroom/versions/google-chrome-canary

    # prefpanes and qlplugins
    brew cask install betterzipql epubquicklook jsonlook qlcolorcode qlimagesize
    qlmarkdown qlstephen scriptql secrets suspicious-package

  # cleanup homebrew's cache
  brew cleanup --force -s
  rm -rf $(brew --cache)
  fi
fi

info() {
    echo "$(tput setaf 2)•$(tput sgr0) $1"
}

request() { # output a message and open an app
    message="$1"
    app="$2"
    shift && shift # get rid of '$1' and '$2'

    echo "$(tput setaf 5)•$(tput sgr0) ${message}"
    open -Wa "${app}" --args "$@" # don't continue until app closes
}

request_preferences() { # 'request' for System Preferences
    request "$1" "System Preferences"
}

request_chrome_extension() { # 'request' for Google Chrome extensions
    chrome_or_canary="$1"
    extension_short_name="$2"
    extension_code="$3"

    request "Install '${extension_short_name}' extension." "${chrome_or_canary}" --no-first-run "https://chrome.google.com/webstore/detail/${extension_short_name}/${extension_code}"
}

preferences_pane() { # open 'System Preferences' is specified pane
    osascript -e "tell application \"System Preferences\"
    activate
    reveal pane \"$1\"
  end tell" &> /dev/null
}

preferences_pane_anchor() { # open 'System Preferences' is specified pane and tab
    osascript -e "tell application \"System Preferences\"
    activate
    reveal anchor \"$1\" of pane \"$2\"
  end tell" &> /dev/null
}

if [ "$OS" == 'OSX' ] && { [ "$INSTALL" == 'EVERYTHING' ] || [ "$INSTALL" == "CHOOSE" ]; } then
   clear

   echo "This script will help configure the rest of OS X. It is divided in two parts:

  $(tput setaf 2)•$(tput sgr0) Commands that will change settings without needing intervetion.
  $(tput setaf 5)•$(tput sgr0) Commands that will open a GUI and require manual graphical interaction.$(tput sgr0)

  The first part will simply output what it is doing (the action itself, not the commands).

  The second part will open the appropriate panels/apps, inform what needs to be done, and pause. Unless prefixed with the message 'ALL TABS', all changes can be performed in the opened tab.
  After the changes are done, close the app and the script will continue.
" | sed -E 's/ {2}//'


   if [ $(ask "Should I hack your OSX?") == 'y' ]; then

       # ask for 'sudo' authentication
       if sudo -n true 2> /dev/null; then
           read -s -n0 -p "$(tput bold)Some commands require 'sudo', but it seems you have already authenticated. When you’re ready to continue, press ↵.$(tput sgr0)"
           echo
       else
           echo -n "$(tput bold)When you’re ready to continue, insert your password. This is done upfront for the commands that require 'sudo'.$(tput sgr0) "
           sudo -v
       fi

       # first part
       # more options on http://mths.be/osx

       info 'Expand save panel by default.'
       defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

       info 'Save to disk (not to iCloud) by default.'
       defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

       info 'Disable Resume system-wide.'
       defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

       info 'Enable tap to click for this user.'
       defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

       info 'Enable full keyboard access for all controls.'
       # (e.g. enable Tab in modal dialogs)
       defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

       info 'Disable auto-correct.'
       defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

       info 'Disable shadow in screenshots.'
       defaults write com.apple.screencapture disable-shadow -bool true

       info 'Set Desktop as the default location for new Finder windows.'
       # For other paths, use `PfLo` and `file:///full/path/here/`
       defaults write com.apple.finder NewWindowTarget -string "PfDe"
       defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

       info 'Show all filename extensions in Finder.'
       defaults write NSGlobalDomain AppleShowAllExtensions -bool true

       info 'Disable the warning when changing a file extension.'
       defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

       info 'Show item info near icons on the desktop.'
       /usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:showItemInfo true' "${HOME}/Library/Preferences/com.apple.finder.plist"

       info 'Increase grid spacing for icons on the desktop.'
       /usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:gridSpacing 100' "${HOME}/Library/Preferences/com.apple.finder.plist"

       info 'Increase the size of icons on the desktop.'
       /usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:iconSize 128' "${HOME}/Library/Preferences/com.apple.finder.plist"

       info 'Use list view in all Finder windows by default.'
       # Four-letter codes for the other view modes: 'icnv', 'clmv', 'Flwv'
       defaults write com.apple.finder FXPreferredViewStyle -string 'Nlsv'

       info 'Disable the warning before emptying the Trash.'
       defaults write com.apple.finder WarnOnEmptyTrash -bool false

       info 'Show the ~/Library folder, and hide Applications, Documents, Music, Pictures and Public.'
       chflags nohidden "${HOME}/Library"
       chflags hidden "${HOME}/Applications"
       chflags hidden "${HOME}/Documents"
       chflags hidden "${HOME}/Music"
       chflags hidden "${HOME}/Pictures"
       chflags hidden "${HOME}/Public"

       info 'Set the icon size of Dock items.'
       defaults write com.apple.dock tilesize -int 35

       info 'Set Dock to appear on the left.'
       defaults write com.apple.dock orientation -string left

       info 'Set hot corners.'
       # Possible values:
       #  0: no-op
       #  2: Mission Control
       #  3: Show application windows
       #  4: Desktop
       #  5: Start screen saver
       #  6: Disable screen saver
       #  7: Dashboard
       # 10: Put display to sleep
       # 11: Launchpad
       # Top left screen corner → Start screen saver
       defaults write com.apple.dock wvous-br-corner -int 5
       # Top right screen corner → Sleep display
       defaults write com.apple.dock wvous-tr-corner -int 10
       # Bottom right screen corner → Desktop
       defaults write com.apple.dock wvous-br-corner -int 4
       # Bottom left screen corner → Mission Control
       defaults write com.apple.dock wvous-bl-corner -int 2

       info 'Disable Time Machine.'
       sudo tmutil disable

       info 'Use OpenDNS servers.'
       sudo networksetup -setdnsservers Wi-Fi 208.67.220.220 208.67.222.222

       info 'Stop iTunes from responding to keyboard media keys.'
       launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist

       for app in "Dock" "Finder"; do
           killall "${app}" &> /dev/null
       done

   fi


   # second part
   # find values for System Preferences by opening the desired pane and running the following AppleScript:
   # tell application "System Preferences" to return anchors of current pane

   echo

   if [ $(ask "Should I open App store to you?") == 'y' ]; then
       request 'Download the apps you want.' 'App Store'
   fi

   if [ $(ask "Should I open some preference panes so you can config your things?") == 'y' ]; then
       request 'Allow to send and receive SMS messages.' 'Messages'

       preferences_pane 'com.apple.preference.general'
       request_preferences 'Set dark menu bar and dock.' 'System Preferences'

       preferences_pane_anchor 'shortcutsTab' 'com.apple.preference.keyboard'
       request_preferences "Turn off Spotlight's keyboard shortcut."

       preferences_pane 'com.apple.preference.trackpad'
       request_preferences 'ALL TABS: Set Trackpad preferences.'

       preferences_pane_anchor 'com.apple.twitter' 'com.apple.preferences.internetaccounts'
       request_preferences 'Setup Twitter account.'

       preferences_pane 'com.apple.preferences.users'
       request_preferences 'Turn off Guest User account.'

       preferences_pane_anchor 'Mouse' 'com.apple.preference.universalaccess'
       request_preferences 'Under "Trackpad Options…", enable three finger drag.'

       preferences_pane_anchor 'Dictation' 'com.apple.preference.speech'
       request_preferences 'Turn on enhanced dictation and download other languages.'

       preferences_pane_anchor 'TTS' 'com.apple.preference.speech'
       request_preferences 'Download and keep only "Ava" and "Joana" voices.'
   fi

   # chrome extentions

   echo

   if [ $(ask "Should I install some chrome extensions?") == 'y' ]; then
       request_chrome_extension 'Google Chrome' 'directlinks' 'mmlodedokepmgdiakhfcbopalplppiok'
       request_chrome_extension 'Google Chrome' 'earthviewfromgoogleearth' 'bhloflhklmhfpedakmangadcdofhnnoh'
       request_chrome_extension 'Google Chrome' 'httpseverywhere' 'gcbommkclmclpchllfjekcdonpmejbdp'
       request_chrome_extension 'Google Chrome' 'thegreatsuspender' 'klbibkeccnjlkjkiokjodocebajanakg'
       request_chrome_extension 'Google Chrome' 'ublockorigin' 'cjpalhdlnbpafiamejdnhcphjbkeiagm'

       request_chrome_extension 'Google Chrome Canary' 'chromeextensionsdeveloper' 'ohmmkhmmmpcnpikjeljgnaoabkaalbgc'
       request_chrome_extension 'Google Chrome Canary' 'daydream' 'oajnmbophdhdobfpalhkfgahchpcoali'
       request_chrome_extension 'Google Chrome Canary' 'emmetlivestyle' 'diebikgmpmeppiilkaijjbdgciafajmg'
       request_chrome_extension 'Google Chrome Canary' 'honey' 'bmnlcjabgnpnenekpadlanbbkooimhnj'
       request_chrome_extension 'Google Chrome Canary' 'pesticide' 'bblbgcheenepgnnajgfpiicnbbdmmooh'
       request_chrome_extension 'Google Chrome Canary' 'selectorgadget' 'mhjhnkcfbdhnjickkkdbjoemdmbfginb'
       request_chrome_extension 'Google Chrome Canary' 'snappysnippet' 'blfngdefapoapkcdibbdkigpeaffgcil'
       request_chrome_extension 'Google Chrome Canary' 'tape' 'jmfleijdbicilompnnombcbkcgidbefb'
       request_chrome_extension 'Google Chrome Canary' 'thecamelizer' 'ghnomdcacenbmilgjigehppbamfndblo'
       request_chrome_extension 'Google Chrome Canary' 'tincr' 'lfjbhpnjiajjgnjganiaggebdhhpnbih'
   fi

fi

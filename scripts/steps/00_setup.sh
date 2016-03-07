if [ "$FUNCTIONS_LOADED" != 'TRUE' ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "${DIR}/../functions.sh"
fi

initial_setup() {
    export PATH="/usr/local/bin:$PATH"

    trap 'exit 0' SIGINT # exit cleanly if aborted with ⌃C
    caffeinate & # prevent computer from going to sleep

    # ask for the administrator password upfront, for commands that require 'sudo'
    clear
    bold_echo 'Insert the "sudo" password now (will not be echoed).'
    until sudo -n true 2> /dev/null; do # if password is wrong, keep asking
        read -s -p "Password:" sudo_password
        echo
        sudo -S -v <<< "${sudo_password}" 2> /dev/null
    done
}

ask_details() {
    clear
    bold_echo 'Some contact information to be set in the lock screen:'
    read -p 'Message > ' message
    read -p 'Email address > ' email
    read -p 'Telephone number > ' telephone
    sudo -S defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "${message}\n✉️ ${email} 📞 ${telephone}" <<< "${sudo_password}" 2> /dev/null

}

initial_setup

if [ "$OS" == 'OSX' ]; then
    if [ $(ask "Should I setup a message with your email and telephone on start screen?") == 'y' ]; then
        ask_details
    fi
fi

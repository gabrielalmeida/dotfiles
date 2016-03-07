if [ "$FUNCTIONS_LOADED" != 'TRUE' ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "${DIR}/../functions.sh"
fi

initial_setup() {
    export PATH="/usr/local/bin:$PATH"

    trap 'exit 0' SIGINT # exit cleanly if aborted with ⌃C
    caffeinate & # prevent computer from going to sleep

    # variables for helper files and directories
    helper_files='/tmp/dotfiles-master/files'
    post_install_files="${HOME}/Desktop/post_install_files"
    post_install_script="${HOME}/Desktop/post_install_script.sh"

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
    read -p 'Email address > ' email
    read -p 'Telephone number > ' telephone
    sudo -S defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Email: ${email}\nTel: ${telephone}" <<< "${sudo_password}" 2> /dev/null
}

}

initial_setup
ask_details
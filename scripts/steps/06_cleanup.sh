if [ "$FUNCTIONS_LOADED" != 'TRUE' ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "${DIR}/../functions.sh"
fi

cleanup_brew() {
    brew cleanup --force
    rm -rf "$(brew --cache)"
}

final_message() {
    clear
    echo "All the automated scripts have now finished."
    echo "Dotfiles setup is complete! ♥️ ♥️ ♥️"
}

cleanup_brew
killall caffeinate # computer can go back to sleep
final_message

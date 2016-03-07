if [ "$FUNCTIONS_LOADED" != 'TRUE' ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "${DIR}/../functions.sh"
fi

install_ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    # install zsh-syntax-highlighting
    mkdir -p "${HOME}/.oh-my-zsh/custom/plugins"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

    # make default shell
    sudo sh -c "echo '/usr/bin/zsh' >> /etc/shells"
    chsh -s "/bin/zsh"
}

if [ $(ask "Should I install oh-my-zsh?") == 'y' ]; then
    install_ohmyzsh
fi

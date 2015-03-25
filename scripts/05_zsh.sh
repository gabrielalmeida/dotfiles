# install oh-my-zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

# install zsh-syntax-highlighting
mkdir -p "${HOME}/.oh-my-zsh/custom/plugins"
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting


if [ "$DOTFILES_SUDO" -eq "install_with_sudo" ]
  # make default shell
  sudo sh -c "echo '/usr/bin/zsh' >> /etc/shells"
fi

chsh -s "/bin/zsh"

# dotfiles
#mv "/tmp/dotfiles/files/zshrc" "${HOME}/.zshrc"
#mv "/tmp/dotfiles/files/zsh-alias" "${HOME}/.zsh-alias"

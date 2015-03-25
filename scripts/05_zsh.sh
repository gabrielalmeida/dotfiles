# install oh-my-zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

# install zsh-syntax-highlighting
mkdir -p "${HOME}/.oh-my-zsh/custom/plugins"
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# clone opp zsh
git clone https://github.com/hchbaw/opp.zsh ${HOME}/dotfiles/zsh-plugins/opp.zsh

# clone auto-fu.zsh
git clone https://github.com/hchbaw/auto-fu.zsh ${HOME}/dotfiles/auto-fu.zsh/auto-fu.zsh

if [ "$DOTFILES_SUDO" == "install_with_sudo" ]; then
  # make default shell
  sudo sh -c "echo '/usr/bin/zsh' >> /etc/shells"
fi

chsh -s "/bin/zsh"

# dotfiles
#mv "/tmp/dotfiles/files/zshrc" "${HOME}/.zshrc"
#mv "/tmp/dotfiles/files/zsh-alias" "${HOME}/.zsh-alias"

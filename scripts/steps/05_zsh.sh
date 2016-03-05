# install oh-my-zsh

if [ $(ask "Should I mess with zsh?") == 'y' ]; then

  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  # install zsh-syntax-highlighting
  mkdir -p "${HOME}/.oh-my-zsh/custom/plugins"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

  # make default shell
  sudo sh -c "echo '/usr/bin/zsh' >> /etc/shells"
  chsh -s "/bin/zsh"

  # dotfiles
  #mv "/tmp/dotfiles/files/zshrc" "${HOME}/.zshrc"
  #mv "/tmp/dotfiles/files/zsh-alias" "${HOME}/.zsh-alias"
fi

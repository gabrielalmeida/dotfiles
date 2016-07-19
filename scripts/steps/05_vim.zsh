if [ "$FUNCTIONS_LOADED" != 'TRUE' ]; then
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  source "${DIR}/../functions.sh"
fi


if [ $(ask "Should I mess with vim stuff?") == 'y' ]; then

  if [ $(ask "Should I install neovim?") == 'y' ]; then
    brew install neovim/neovim/neovim

    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  if [ $(ask "Should I install vim?") == 'y' ]; then
    brew install vim --with-lua

    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  if [ ! -d ~/.vim_swp ]; then
    echo "Creating swp directory."
    mkdir ~/.vim_swp
  fi

  if [ ! -d ~/.undofile ]; then
    echo "Creating undofile directory."
    touch ~/.undofile
  fi

  echo "Vim setup is complete"
fi

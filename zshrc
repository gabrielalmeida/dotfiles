# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cloud"

# Example aliases
 alias zshconfig="vi ~/.zshrc"
 alias ohmyzsh="vi ~/.oh-my-zsh"

# Set this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often to auto-update? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
#DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to the command execution time stamp shown
# in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="dd/mm/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git github heroku osx command-not-found  meteor node brew
composer bower cloudapp common-aliases compleat gitfast git-extras 
laravel4 nyan themes npm atom last-working-dir copydir
copyfile cp extract)

source $ZSH/oh-my-zsh.sh

# zsh-syntax-highlighting
source ~/dotfiles/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

# opp vi zsh
source ~/dotfiles/zsh-plugins/opp.zsh/opp.zsh
source ~/dotfiles/zsh-plugins/opp.zsh/opp/*.zsh

## User configuration

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:~/bin"
export MANPATH="/usr/local/man:$MANPATH"

# Using bindkey -v instead of vi-mode plugin(it was freezing zsh)
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

export KEYTIMEOUT=1


# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/dsa_id"


# Homebrew Cask Application Directory
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Aliases
alias cle=clear
alias cl=clear
alias lc=cl
alias tm='tmux'
alias ta='tmux a'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'

# setting TERM
export TERM="xterm-256color"
export LANG="en_US.UTF-8"

# Open Dev folder

function dev() {
  cd ~/Nitrous/gbrl;

      if [ -e "$1" ] || [ -e "$2" ] || [ -e "$3" ] || [ -e "$4"] || [ -e "$5"]; then
            for i in "$1" "$2" "$3" "$4" "$5"; do
                [ -e "$i" ] && cd "$i";
            done
     fi
}

# Uncomment if on Nitrous or Codio Boxes
#export PATH="$HOME/.parts/autoparts/bin:$PATH"
#eval "$(parts init -)"

# Start eclimd
export ECLIPSE_HOME="/Applications/eclipse/"
alias eclimd='$ECLIPSE_HOME/eclimd&'


CLASSPATH=~/Dev/lucene-4.9.0:$CLASSPATH
export CLASSPATH
cd ~/

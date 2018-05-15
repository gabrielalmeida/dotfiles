# enable aliases to be sudo'ed
alias sudo="sudo "
alias ..="\cd .."
alias ...='\cd ../..'
alias ....='\cd ../../..'
alias .....='\cd ../../../..'
alias ......='\cd ../../../../..'
# clear
alias cle=clear
alias cl=clear
alias lc=clear
alias cls=clear
# reattach to user namespace
alias open='reattach-to-user-namespace open'
# editors
alias e=$EDITOR
alias vi=vim
alias em="open -a emacs"

# osx
alias am="open -a \"Activity Monitor\""
alias pref="open -a \"System Preferences\""
alias flushdns='dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say flushed'
# tmux
alias tmux='TERM=screen-256color tmux'
alias tm='tmux a || tmux new'
alias ta='tmux a'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
# refresh zshrc
alias rr="source ~/.zshrc"
alias vtop="vtop --theme monokai"
# archives
alias mktar="tar -cvf"
alias mkbz2="tar -cvjf"
alias mkgz="tar -cvzf"
alias untar="tar -xvf"
alias unbz2="tar -xvjf"
alias ungz="tar -xvzf"
# wifi cli
alias wifi='osx-wifi-cli'
# ls, the common ones
alias ls="ls -G"      # always colorize
alias l='ls -lFh'     # size,show type,human readable
alias la='ls -lAFh'   # long list,show almost all,show type,human readable
alias lr='ls -tRFh'   # sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   # long list,sorted by date,show type,human readable
alias ll='ls -l'      # long list
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
# edit zshrc
alias zshrc='$EDITOR ~/.zshrc'
# better grep
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '
# tail refresh
alias t='tail -f'
# command line head/tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias -g P="2>&1| pygmentize -l pytb"
# fs info
alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'
# file size
alias fs="stat -f %z"
alias h='history'
alias hgrep="fc -El 0 | grep"
alias help='man'
alias p='ps -f'
alias sortnr='sort -n -r'
alias unexport='unset'
alias whereami=display_info
# rm, mv, cp always on interactive mode
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

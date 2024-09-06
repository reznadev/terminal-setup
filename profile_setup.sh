
# use yellow for directories
export CLICOLOR=1
export LSCOLORS=fxfxcxdxbxegedabagacad

# quickly edit and source .zshrc
alias vz="vim ~/.zshrc"
alias sz=" source ~/.zshrc; echo '~/.zshrc sourced'"

# sublime

alias subl="fzf | xargs subl"

# vscode 

alias code="fzf | xargs code"


# Other alias
alias grep='grep --color'
alias ll="ls -lah"

# IP alias
alias ip="ifconfig -a | egrep -A 7 '^en0' | grep inet | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' | head -n 1"
alias myip="curl -s http://checkip.dyndns.org/ | sed 's/[a-zA-Z<>/ :]//g'"

# Pretty print the PATH
alias path='echo; tr ":" "\n" <<< "$PATH"; echo;'

# Git and zsh
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='🐧 %F{099}%~ %F{015}${vcs_info_msg_0_}%f%k%F{228}★%f '

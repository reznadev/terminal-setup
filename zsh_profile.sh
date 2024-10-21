# use yellow for directories
export CLICOLOR=1
export LSCOLORS=fxfxcxdxbxegedabagacad

# sublime

alias subl="fzf | xargs subl" 


# quickly edit and source .zshrc

alias vz="vim ~/.zshrc"
alias sz=" source ~/.zshrc; echo '~/.zshrc sourced'"

# Other alias

alias grep='grep --color'
alias ll="ls -lah"
alias add='git add .' 
alias com='git commit -m' 
alias status='git status'
alias push='git push'
alias pull='git pull' 

# Pretty print the PATH

alias path='echo; tr ":" "\n" <<< "$PATH"; echo;'


# Git and zsh

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='🐧 %F{099}%~ %F{015}${vcs_info_msg_0_}%f%k%F{228}★%f '


# IP alias

alias myip="curl -s http://checkip.dyndns.org/ | sed 's/[a-zA-Z<>/ :]//g'"

alias myip="ifconfig en0 | grep inet | grep -v inet6 | awk '{print \$2}'"




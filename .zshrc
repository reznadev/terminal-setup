# use yellow for directories
export CLICOLOR=1
export LSCOLORS=fxfxcxdxbxegedabagacad



# quickly edit and source .zshrc

alias vz="vim ~/Macbook/github/terminal-setup/.zshrc"
sz () {
 source ~/Macbook/github/terminal-setup/.zshrc
 echo '~/.zshrc sourced'
 cd ~/Macbook/github/terminal-setup/
 echo 'changed to git repo'
 git add ./.zshrc
 echo 'added zshrc file'
 git commit -m 'upgraded terminalfile'
 git push
 echo 'pushed to github'
}



# Other alias

alias grep='grep --color'
alias ll="eza -1 --icons -l -a --no-filesize --no-time -o --git-repos-no-status --no-permissions --colour=always"
alias lt="eza -1 --icons -l --no-filesize --no-time -o --git-repos-no-status --no-permissions -T --group-directories-first"
alias gadd='git add .' 
alias gcom='git commit -m' 
alias gstat='git status'
alias gpush='git push'
alias gpull='git pull' 
alias v='vim'
alias tf="terraform"
alias z='zed'


# Pretty print the PATH

alias path='echo; tr ":" "\n" <<< "$PATH"; echo;'


# Git and zsh

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='🐧 %F{099}%~ %F{015}${vcs_info_msg_0_}%f%k%F{228}★%f '


# IP alias

alias pubip="curl -s http://checkip.dyndns.org/ | sed 's/[a-zA-Z<>/ :]//g'"

alias myip="ifconfig en0 | grep inet | grep -v inet6 | awk '{print \$2}'"


# Not main config

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# functions

sub() {
    # Search for both files and directories under $HOME
    local target
    target=$(find "$HOME" \( -type f -o -type d \) 2>/dev/null | fzf)
    # If something is selected, open it with Sublime Text (using "command subl" to bypass any alias)
    [ -n "$target" ] && command subl "$target"
}




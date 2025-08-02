# use yellow for directories
export CLICOLOR=1
export LSCOLORS=fxfxcxdxbxegedabagacad

# TUI File Manager

function y() {
  local tmp
  tmp=$(mktemp -t "yazi-cwd.XXXXXX")
  yazi "$@" --cwd-file="$tmp"
  if [[ -s "$tmp" ]]; then
    cd "$(cat "$tmp")"
  fi
  rm -f -- "$tmp"
}


# Dotfiles root
export DOTFILES="$HOME/github/terminal-setup/dotfiles"


# STOW alias

# base stow
alias st='stow --dir=$DOTFILES --target=$HOME'

# install package e.g. stowp tmux (links tmux to home) 
alias stowp='st'

# remove symlinks e.g. stoud tmux (unlinks tmux from home) 
alias stoud='st -D'

# re-create symlinks after adding/renaming/removing files in a package
alias stowr='st -R'


# quickly edit and source .zshrc

alias reload="source ~/.zshrc"

alias vz="vim $DOTFILES/zsh/.zshrc"
sz() {
  source ~/.zshrc && echo "\033[0;36m++++ ~/.zshrc sourced ++++\033[0m"
  cd "$DOTFILES" && echo "\033[0;36m++++ Changed to dotfiles repo: $DOTFILES ++++\033[0m"
  git add zsh/.zshrc && echo "\033[0;36m++++ Staged zsh/.zshrc ++++\033[0m"
  git commit -m "Update zshrc" && echo "\033[0;36m++++ Committed changes ++++\033[0m"
  git push && echo "\033[0;36m++++ Pushed to GitHub ++++\033[0m"
}

# quickly edit vimrc 
alias vv='vim $DOTFILES/vim/.vimrc'
sv() {
  cd "$DOTFILES" && echo "++++ Changed to dotfiles repo: $DOTFILES ++++"
  git add vim/.vimrc && echo "++++ Staged vim/.vimrc ++++"
  git commit -m "Updated vimrc" && echo "++++ Committed changes ++++"
  git push && echo "++++ Pushed to Github ++++"
}


# Other alias

alias grep='grep --color'
alias ll="eza -1 -g --icons -l -a --no-filesize --no-time -o --git-repos-no-status --no-permissions --colour=always"
alias lt="eza -1 --icons -l --no-filesize --no-time -o --git-repos-no-status --no-permissions -T --group-directories-first"
alias ga='git add .'
alias gc='git commit -m'
alias gs='git status'
alias gsw='git switch'
alias gb='git branch'
alias gpush='git push'
alias gpull='git pull'
alias v='vim'
alias tf='terraform'
alias c='code'
alias lsp='lsof -PiTCP -sTCP:LISTEN'
alias tx='tmux'

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


# Load machine-specific overrides (not tracked by Git)

if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi


# Not main config

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion



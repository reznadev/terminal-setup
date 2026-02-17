# Tmux autostart 

if [ -x "$(command -v tmux)" ] && [ -z "${TMUX}" ]; then
    exec tmux new-session -A -s ${USER}
fi

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
alias rz="source ~/.zshrc"

alias vz="vim $DOTFILES/zsh/.zshrc"
sz() {
    cd "$DOTFILES" || return
    echo "\033[0;32m++++ Changed to dotfiles repo: $DOTFILES ++++\033[0m"

    # Check for unstaged changes
    if ! git diff --quiet; then
        echo "\033[0;33mStashing unstaged changes...\033[0m"
        git stash push -u -m "Auto-stash before sync"
        local stashed=true
    fi

    git pull --rebase || { echo "\033[0;31mPull failed! Resolve conflicts first.\033[0m"; return 1; }

    # Restore stashed changes
    if [[ $stashed == true ]]; then
        git stash pop
    fi

    if ! git diff --quiet || ! git diff --cached --quiet; then
        git add zsh/.zshrc
        git commit -m "Update zshrc"
        git push
        echo "\033[0;32m++++ Committed and pushed ++++\033[0m"
    fi

    source ~/.zshrc
    echo "\033[0;32m++++ ~/.zshrc sourced ++++\033[0m"
}

# quickly edit vimrc 
alias vv='vim $DOTFILES/vim/.vimrc'
sv() {
    cd "$DOTFILES" || return
    echo "\033[0;32m++++ Changed to dotfiles repo: $DOTFILES ++++\033[0m"
    if ! git diff --quiet; then
    echo "\033[0;33mStashing unstaged changes...\033[0m"
    git stash push -u -m "Auto-stash before sync"
         local stashed=true
     fi

git pull --rebase || { echo "\033[0;31mPull failed! Resolve conflicts first.\033[0m"; return 1; }
   if [[ $stashed == true ]]; then
         git stash pop
   fi

    if ! git diff --quiet || ! git diff --cached --quiet; then
         git add vim/.vimrc
   git commit -m "Update vimrc"
      git push
        echo "\033[0;32m++++ Committed and pushed ++++\033[0m"
     fi
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
alias gps='git push'
alias gpl='git pull'
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
PROMPT='🐧 %F{099}%~ %F{205}${vcs_info_msg_0_}%f%k%F{228}★%f '


# IP alias

alias pubip="curl -s http://checkip.dyndns.org/ | sed 's/[a-zA-Z<>/ :]//g'"

alias myip="ifconfig en0 | grep inet | grep -v inet6 | awk '{print \$2}'"


# Load machine-specific overrides (not tracked by Git)

if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi


# Created by `pipx` on 2025-09-11 15:02:20
export PATH="$PATH:/Users/rezana/.local/bin"

# opencode
export PATH=/Users/musint/.opencode/bin:$PATH

# brew auto suggest
# source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fixes broken double tab
autoload -Uz compinit && compinit
unsetopt auto_menu
#
#
# Not main config

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion



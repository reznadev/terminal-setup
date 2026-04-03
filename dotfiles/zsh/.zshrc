# ───────────────────────────────────────────────
# TMUX AUTOSTART
# ───────────────────────────────────────────────

if [ -x "$(command -v tmux)" ] && [ -z "${TMUX}" ]; then
    exec tmux new-session -A -s ${USER}
fi

# ───────────────────────────────────────────────
# DOTFILES
# ───────────────────────────────────────────────
export DOTFILES="$HOME/github/terminal-setup/dotfiles"

# ───────────────────────────────────────────────
# STOW 
# ───────────────────────────────────────────────
# base stow
alias st='stow --dir=$DOTFILES --target=$HOME'
# install package e.g. stowp tmux (links tmux to home) 
alias stowp='st'
# remove symlinks e.g. stoud tmux (unlinks tmux from home) 
alias stoud='st -D'
# re-create symlinks after adding/renaming/removing files in a package
alias stowr='st -R'

# ───────────────────────────────────────────────
# DOTFILE SYNC
# ───────────────────────────────────────────────

sdot() {
  local file="$1"
  cd "$DOTFILES" || return
  echo "\033[0;32m++++ Changed to dotfiles repo: $DOTFILES ++++\033[0m"
  if ! git diff --quiet; then
    echo "\033[0;33mStashing unstaged changes...\033[0m"
    git stash push -u -m "Auto-stash before sync"
    local stashed=true
  fi
  git pull --rebase || { echo "\033[0;31mPull failed! Resolve conflicts first.\033[0m"; return 1; }
  [[ $stashed == true ]] && git stash pop
  if ! git diff --quiet || ! git diff --cached --quiet; then
    git add "$file"
    git commit -m "Update $(basename $file)"
    git push
    echo "\033[0;32m++++ Committed and pushed ++++\033[0m"
  fi
  source ~/.zshrc
  echo "\033[0;32m++++ ~/.zshrc sourced ++++\033[0m"
}

alias sz="sdot zsh/.zshrc"
alias sv="sdot vim/.vimrc"
alias rz="source ~/.zshrc"
alias vz="vim $DOTFILES/zsh/.zshrc"
alias vv="vim $DOTFILES/vim/.vimrc"


# ───────────────────────────────────────────────
# NAVIGATION
# ───────────────────────────────────────────────

alias ll="eza -1 -g --icons -l -a --no-filesize --no-time -o --git-repos-no-status --no-permissions --colour=always"
alias lt="eza -1 --icons -l --no-filesize --no-time -o --git-repos-no-status --no-permissions -T --group-directories-first"
alias path='echo; tr ":" "\n" <<< "$PATH"; echo;'

# ───────────────────────────────────────────────
# GIT
# ───────────────────────────────────────────────

alias ga='git add .'
alias gc='git commit -m'
alias gs='git status'
alias gsw='git switch'
alias gb='git branch'
alias gf='git fetch'
alias gps='git push'
alias gpl='git pull'


# ───────────────────────────────────────────────
# NETWORK
# ───────────────────────────────────────────────
alias pubip="curl -s http://checkip.dyndns.org/ | sed 's/[a-zA-Z<>/ :]//g'"
alias myip="ifconfig en0 | grep inet | grep -v inet6 | awk '{print \$2}'"
alias lsp='lsof -PiTCP -sTCP:LISTEN'


# ───────────────────────────────────────────────
# TOOLS
# ───────────────────────────────────────────────

alias grep='grep --color'
alias v='vim'
alias tf='terraform'
alias c='code'
alias tx='tmux'
alias cat='bat'


# ───────────────────────────────────────────────
# YAZI
# ───────────────────────────────────────────────

function y() {
  local tmp
  tmp=$(mktemp -t "yazi-cwd.XXXXXX")
  yazi "$@" --cwd-file="$tmp"
  if [[ -s "$tmp" ]]; then
    cd "$(cat "$tmp")"
  fi
  rm -f -- "$tmp"
}

# ───────────────────────────────────────────────
# SHELL
# ───────────────────────────────────────────────

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='🐧 %F{099}%~ %F{205}${vcs_info_msg_0_}%f%k%F{228}★%f '

# ───────────────────────────────────────────────
# KEYBINDINGS
# ───────────────────────────────────────────────

bindkey '^G' delete-char
bindkey '^W' forward-word
bindkey '^B' backward-word

# ───────────────────────────────────────────────
# COMPLETION
# ───────────────────────────────────────────────

autoload -Uz compinit && compinit
unsetopt auto_menu

# ───────────────────────────────────────────────
# PATH
# ───────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ───────────────────────────────────────────────
# ZOXIDE
# ───────────────────────────────────────────────
eval "$(zoxide init zsh)"

# ───────────────────────────────────────────────
# OVERRIDE
# ───────────────────────────────────────────────

if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi







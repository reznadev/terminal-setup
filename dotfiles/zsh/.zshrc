# ───────────────────────────────────────────────
# TMUX FUZZY AUTOSTART
# ───────────────────────────────────────────────

if [ -z "$TMUX" ] && [ -n "$PS1" ] && [ -z "$SKIP_TMUX" ]; then
    # Get existing sessions
    sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
    
    # Create the picker list (existing sessions + a "NEW" option)
    selection=$(echo -e "${sessions}\n[ NEW SESSION ]" | fzf --reverse --header="── TMUX SESSIONS ──" --height=20%)

    if [[ "$selection" == "[ NEW SESSION ]" ]]; then
        read "sname?Enter session name: "
        tmux new-session -s "$sname"
    elif [[ -n "$selection" ]]; then
        tmux attach-session -t "$selection"
    fi
    # If selection is empty (Esc/Ctrl-C), it just continues to plain Zsh
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
  if ! git diff --quiet -- "$file" || ! git diff --cached --quiet -- "$file"; then
    echo "\033[0;33mStashing all changes before pull...\033[0m"
    git stash push -u -m "Auto-stash before sync"
    local stashed=true
  fi
  git pull --rebase || { echo "\033[0;31mPull failed! Resolve conflicts first.\033[0m"; return 1; }
  if [[ $stashed == true ]]; then
    git stash pop || { echo "\033[0;31mStash pop failed! Resolve conflicts manually.\033[0m"; return 1; }
  fi
  if ! git diff --quiet -- "$file" || ! git diff --cached --quiet -- "$file"; then
    git add "$file"
    git commit -m "Update $(basename $file)"
    git push
    echo "\033[0;32m++++ Committed and pushed ++++\033[0m"
  else
    echo "\033[0;33mNo changes to $file — nothing to commit.\033[0m"
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

alias ga='git add -A'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit -am'
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -3'
alias gsw='git switch'
alias gb='git branch -vv'
alias gf='git fetch --prune'
alias gps='git push'
alias gpl='git pull --rebase'
alias gst='git stash'
alias gstp='git stash pop'
alias grb='git rebase'
alias gm='git merge --no-ff'


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
# PLUGINS & INTEGRATIONS
# ───────────────────────────────────────────────

# FZF Integration (Ctrl-R, Ctrl-T, Alt-C)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# FZF Previews using 'bat'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color='header:italic:underline'"

# Plugins (Brew installed)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ───────────────────────────────────────────────
# OVERRIDE
# ───────────────────────────────────────────────

if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi







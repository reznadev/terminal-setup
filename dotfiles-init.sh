#!/usr/bin/env bash
set -e

# 1) install gnu
if ! command -v stow &>/dev/null; then
  echo "→ Installing GNU Stow…"
  if [[ "$(uname)" == "Darwin" ]]; then
    brew install stow
  else
    sudo apt update && sudo apt install -y stow
  fi
fi

# 2) change to repo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/dotfiles"

# 3) add packages (configfiles you want to stow) here

packages=(kitty zsh vim tmux claude yazi)

for pkg in "${packages[@]}"; do
  echo "→ Stowing $pkg"
  stow --restow --target="$HOME" "$pkg"
done

echo "🧪 Magic done!"

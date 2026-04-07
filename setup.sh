#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Homebrew
if ! command -v brew &>/dev/null; then
  echo " 🦣 Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo " 🦦 Homebrew already installed"
fi

# Always ensure brew is on PATH (covers fresh install + re-runs)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Install packages from Brewfile
echo " 🐋 Installing packages from Brewfile"
brew bundle --file="$SCRIPT_DIR/Brewfile"

# Ensure stow is available before stowing dotfiles
brew install stow 2>/dev/null || true

# Stow dotfiles
echo " 🦩 Stowing dotfiles…"
"$SCRIPT_DIR/dotfiles-init.sh"


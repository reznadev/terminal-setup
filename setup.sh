#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Homebrew
if ! command -v brew &>/dev/null; then
  echo " 🦣 Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for the rest of this script (Apple Silicon)
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo " 🦦 Homebrew already installed"
fi

# Install packages from Brewfile
echo " 🐋 Installing packages from Brewfile"
brew bundle --file="$SCRIPT_DIR/Brewfile"

# Stow dotfiles
echo " 🦩 Stowing dotfiles…"
"$SCRIPT_DIR/dotfiles-init.sh"


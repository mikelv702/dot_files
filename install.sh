#!/usr/bin/env bash

# Install dotfiles using GNU Stow
# Run from the dotfiles directory: ./install.sh
# Or install specific packages: ./install.sh zsh vim tmux

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

HOSTNAME=$(hostname -f 2>/dev/null || hostname)
if [[ "$HOSTNAME" == *amazon.com* ]]; then
    PACKAGES=(shell bash zsh vim tmux git ssh bash_functions)
else
    PACKAGES=(shell bash zsh vim tmux git ssh claude)
fi

# Check that stow is installed
if ! command -v stow &> /dev/null; then
    echo "Error: GNU Stow is not installed."
    echo "Install it with: sudo apt install stow"
    exit 1
fi

cd "$DOTFILES_DIR"

if [ $# -gt 0 ]; then
    # Install only specified packages
    for pkg in "$@"; do
        echo "Stowing $pkg..."
        stow -v -t "$HOME" "$pkg"
    done
else
    # Install all packages
    for pkg in "${PACKAGES[@]}"; do
        echo "Stowing $pkg..."
        stow -v -t "$HOME" "$pkg"
    done
fi

echo "Done!"

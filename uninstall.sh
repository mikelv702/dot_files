#!/usr/bin/env bash

# Remove dotfile symlinks using GNU Stow
# Run from the dotfiles directory: ./uninstall.sh
# Or uninstall specific packages: ./uninstall.sh zsh vim

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(shell bash zsh vim tmux git ssh claude)

cd "$DOTFILES_DIR"

if [ $# -gt 0 ]; then
    for pkg in "$@"; do
        echo "Unstowing $pkg..."
        stow -v -D -t "$HOME" "$pkg"
    done
else
    for pkg in "${PACKAGES[@]}"; do
        echo "Unstowing $pkg..."
        stow -v -D -t "$HOME" "$pkg"
    done
fi

echo "Done!"

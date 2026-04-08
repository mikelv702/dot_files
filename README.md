# dot files

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package | Contents |
|---------|----------|
| `shell` | `.aliases`, `.aliases_test`, `.bash_functions`, `.motd` |
| `bash`  | `.bashrc`, `.bash_profile` |
| `zsh`   | `.zshrc` |
| `vim`   | `.vim/vimrc` |
| `tmux`  | `.tmux.conf` |
| `git`   | `.gitconfig` |
| `ssh`   | `.ssh/my_config` |
| `claude` | `.claude/commands/` |

## Setup

```bash
# Clone to your home directory
git clone <repo-url> ~/dot_files
cd ~/dot_files

# Install all packages
./install.sh

# Or install specific packages
./install.sh zsh vim tmux
```

## Uninstall

```bash
# Remove all symlinks
./uninstall.sh

# Or remove specific packages
./uninstall.sh zsh vim
```

## Adding new dotfiles

1. Create or add to a package directory (e.g. `zsh/.zshrc`)
2. The file path inside the package should mirror its path relative to `$HOME`
3. Run `stow <package>` to create the symlink

## Helpful link
https://vim.rtorr.com/

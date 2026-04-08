# My BashRC File

# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/bashrc.pre.bash"




# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/bashrc.post.bash" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/bashrc.post.bash"
alias finch='sudo HOME=/home/halllmic DOCKER_CONFIG=/home/halllmic/.docker finch'
export PATH="$HOME/.local/share/mise/shims:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Added by AIM CLI
export PATH="$HOME/.aim/mcp-servers:$PATH"


if [ -f ~/.motd ]; then
    cat ~/.motd
    echo ""  # Add a blank line after the MOTD for better readability
fi

# Load Aliases
for aliasfile in $HOME/.aliases*; do
    [ -f "$aliasfile" ] && source "$aliasfile"
done

# Load custom shell functions
for functionfile in $HOME/bash_functions/*; do
    [ -f "$aliasfile" ] && source "$aliasfile"
done



## Which pager to use.
export PAGER=less

## Choose your weapon
EDITOR=/usr/bin/vim
export EDITOR

## The maximum number of lines in your history file
export HISTFILESIZE=50

export ORGANIZATION="Rubber Duck Development LLC"

## Enables displaying colors in the terminal
export TERM=xterm-color



# Function to get Git branch
git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Function to truncate path
truncated_pwd() {
  local pwd=$(pwd)
  local home=$HOME
  local size=${#pwd}
  local max_size=30
  local offset=$((size - max_size))
  if [[ $size -gt $max_size ]]; then
    pwd="...${pwd:$offset:$max_size}"
  fi
  if [[ $pwd = "$home" ]]; then
    pwd="~"
  elif [[ $pwd = "$home/"* ]]; then
    pwd="~${pwd:${#home}}"
  fi
  echo "$pwd"
}

# Set up colors
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
MAGENTA="\[\033[0;35m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
RESET="\[\033[0m\]"
BOLD="\[\033[1m\]"

# Set up the prompt
PS1="${BOLD}${GREEN}\u@\h${RESET}:${BLUE}\$(truncated_pwd)${MAGENTA}\$(git_branch)${RESET} ${BOLD}${RED}❯${YELLOW}❯${GREEN}❯${RESET} "autoload -Uz compinit && compinit

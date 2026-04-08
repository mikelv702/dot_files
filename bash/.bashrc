
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

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

## If this is an interactive console, disable messaging
#tty -s && mesg n

## Aliases
alias bye=logout
alias h=history
alias jobs='jobs -l'
alias lf='ls -algF'
alias log=logout
alias cls=clear
alias edit=$EDITOR

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
PS1="${BOLD}${GREEN}\u@\h${RESET}:${BLUE}\$(truncated_pwd)${MAGENTA}\$(git_branch)${RESET} ${BOLD}${RED}❯${YELLOW}❯${GREEN}❯${RESET} "
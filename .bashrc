
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

## Append to history file; do not overwrite
shopt -s histappend

## Prevent accidental overwrites when using IO redirection
set -o noclobber

## Set the prompt to display the current git branch
## and use pretty colors
export PS1='$(git branch &>/dev/null; if [ $? -eq 0 ]; then \
echo "\[\e[1m\]\u@\h\[\e[0m\]: \w [\[\e[34m\]$(git branch | grep ^* | sed s/\*\ //)\[\e[0m\]\
$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; if [ "$?" -ne "0" ]; then \
echo "\[\e[1;31m\]*\[\e[0m\]"; fi)] \$ "; else \
echo "\[\e[1m\]\u@\h\[\e[0m\]: \w \$ "; fi )'

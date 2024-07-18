# My ZSHRC file

if [ -f ~/.motd ]; then
    cat ~/.motd
    echo ""  # Add a blank line after the MOTD for better readability
fi
for aliasfile in $HOME/.aliases*; do
    [ -f "$aliasfile" ] && source "$aliasfile"
done
source $HOME/.bash_functions
# Default Prompt
PS1="%F{green}[%B%n:%m%b] %~%f >"
RPROMPT="%t"

set_red_prompt_background () {
  if [[ ${(%):-%M} = *PROD* ]]; then
    PS1="%F{green}%K{red}PROD%k [%B%n:%m%b] %~%f>"
  else
    PS1="%F{green}[%B%n:%m%b] %~%f>"
  fi
}

typeset -a precmd_functions
precmd_functions+=(set_red_prompt_background)

# Git Stuff

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
setopt prompt_subst
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:git:*' formats '%b'
set_git_branch () {
  if [[ ${vcs_info_msg_0_} != "" ]]; then
    RPROMPT='%t (${vcs_info_msg_0_})'
  else
    RPROMPT='%t'
  fi
}

precmd_functions+=(set_git_branch)



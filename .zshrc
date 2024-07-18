# My ZSHRC file

source $HOME/.aliases

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
precmd_functions+=( precmd_vcs_info )

set_git_branch () {
  if [[ ${vcs_info_msg_0_} != "" ]]; then
    RPROMPT='%t (${vcs_info_msg_0_::-1})'
  else
    RPROMPT='%t'
  fi
}

precmd_functions+=(set_git_branch)



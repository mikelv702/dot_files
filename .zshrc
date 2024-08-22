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
# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats ' %B%F{magenta}(%b)%f'

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
    pwd="~${pwd:$((${#home}))}"
  fi
  echo "$pwd"
}

# Set up the prompt
setopt PROMPT_SUBST
PROMPT='%B%F{green}%n@%m%f%b:%F{blue}$(truncated_pwd)%f${vcs_info_msg_0_} %B%F{red}❯%F{yellow}❯%F{green}❯%f%b '
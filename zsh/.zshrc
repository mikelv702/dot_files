# My ZSHRC file

# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh"

# PATH
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$HOME/.claude/local/bin:$PATH"

# Rust
# export RUST_BACKTRACE=1
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

if [[ -d "$HOME/.aim" ]]; then
    PATH="$HOME/.aim/mcp-servers:$PATH"
fi

if [[ -d "$HOME/.toolbox/bin" ]]; then
    PATH="$HOME/.toolbox/bin:$PATH"
fi

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
    [ -f "$functionfile" ] && source "$functionfile"
done



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
# if you wish to use IMDS set AWS_EC2_METADATA_DISABLED=false

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh"

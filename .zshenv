# path
  export PATH="$HOME/.local/bin:$HOME/.local/shims:/usr/bin"
  [ -d /opt/homebrew ] && export PATH="/opt/homebrew/bin:$PATH"
  [ -d /opt/homebrew ] && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# environment variables
  export LANG="en_US.UTF-8"
  export LC_TIME="en_DK.UTF-8" # YYYY-MM-DD
  export EDITOR="helix --log /dev/null"
  export LESSHISTFILE="/dev/null"
  export NVIM_LOG_FILE="/dev/null"
  export LS_COLORS="di=1;34:ln=36:so=1;31:pi=33:ex=1;32:bd=1;33:cd=1;33:or=31"
  export EZA_COLORS="xa=90:da=90"

# language variables
  export GOPATH="$HOME/.local/go"
  export CARGO_HOME="$HOME/.local/cargo"

# finder/selector
  local FZF_LAYOUT="--border=none --no-separator --no-scrollbar --no-info --pointer=•"
  local FZF_COLORS="--color=prompt:0,query:4,pointer:4,hl:4,hl+:4,fg+:7,bg+:16"
  export FZF_DEFAULT_OPTS="--reverse --no-mouse ${FZF_COLORS} ${FZF_LAYOUT}"
  export FZF_DEFAULT_COMMAND="fd --type=f"
  export FZF_CTRL_T_COMMAND="fd"
  export FZF_ALT_C_COMMAND="fd --type=d"

# scope permissions of new files to only this user
  umask 077

# zsh settings
  SHELL_SESSIONS_DISABLE=1

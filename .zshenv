# path
  export PATH="$HOME/.local/bin:/usr/bin"
  [ -d /opt/homebrew ] && export PATH="/opt/homebrew/bin:$PATH"
  [ -d /opt/homebrew ] && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# environment variables
  export LANG="en_US.UTF-8"
  export LC_TIME="en_DK.UTF-8" # YYYY-MM-DD
  export EDITOR="helix --log /dev/null"
  export LESSHISTFILE="/dev/null"
  export GOPATH="$HOME/.local/go"
  export CARGO_HOME="$HOME/.local/cargo"

# environment settings
  umask 077 # scope permissions of new files to only this user

# zsh settings
  SHELL_SESSIONS_DISABLE=1

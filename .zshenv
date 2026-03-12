# path
  export PATH="$HOME/.local/bin:$HOME/.local/bin/shims:/usr/bin"
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
  local FZF_COLORS="--color='prompt:0 query:2 pointer:4 hl:2 hl+:2 fg+:7'"
  local FZF_LAYOUT="--reverse --no-info --no-separator --no-mouse --no-scrollbar"
  export FZF_DEFAULT_OPTS="${FZF_LAYOUT} ${FZF_COLORS}"
  export FZF_DEFAULT_COMMAND="fd --type=f"
  export FZF_CTRL_T_COMMAND="fd --type=f"
  export FZF_ALT_C_COMMAND="fd --type=d"

# scope permissions of new files to only this user
  umask 077

# zsh settings
  SHELL_SESSIONS_DISABLE=1

# exit if not interactive
  [[ ! -o interactive ]] && exit

# command aliases
  alias {hx,helix}="helix --log /dev/null"
  alias diff="diff --color"
  alias curl="curl --no-progress-meter"
  alias ugrep="ugrep --smart-case"
  alias tl="eza -a --group-directories-first --tree -L1"
  alias ll="eza -a --group-directories-first --long --time-style=long-iso"
  alias git="TZ=UTC git"

# command functions
  timestamp() { date +%Y%m%d-%H%M%S }

# zsh settings
  skip_global_compinit=1
  PROMPT='$ ' ; [[ "$UID" -eq 0 ]] && PROMPT='# '
  WORDCHARS="${WORDCHARS/\/}" # exclude forward slash / as part of word
  bindkey -e ; bindkey "^[[1;5C" forward-word ; bindkey "^[[1;5D" backward-word # ctrl+left/right

# zsh history
  setopt extendedhistory incappendhistory histignorealldups histignorespace histreduceblanks
  HISTSIZE=10000 SAVEHIST=10000 HISTFILE=~/.zsh_history

# zsh completions
  autoload -Uz compinit && compinit -u -d ~/.cache/zsh/zcompcache
  zstyle ":completion:*" menu select
  precmd() { set-terminal-tab-title }
  source <(fzf --zsh)

# function to set the tab title for the terminal (directory with vcs branch name)
  set-terminal-tab-title() {
    local title="${PWD/#$HOME/~}"
    local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    [ -n "${branch}" ] && title="${title} • ${branch}"
    print -n $"\e]2;${title}\007"
  }

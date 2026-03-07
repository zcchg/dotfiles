# command aliases
  alias {hx,helix}="helix --log /dev/null"
  alias git="TZ=UTC git"
  alias diff="diff --color"
  alias curl="curl --silent --show-error"
  alias {grep,ugrep}="ugrep --smart-case"
  alias tl="eza -a --group-directories-first --tree -L1"
  alias ll="eza -a --group-directories-first --long --time-style=long-iso"

# command functions
  timestamp() { date +%Y%m%d-%H%M%S }

# zsh settings
  skip_global_compinit=1
  PROMPT='$ ' ; [[ "$OSTYPE" != "linux-"* ]] && PROMPT='★ '
  WORDCHARS="${WORDCHARS/\/}" # exclude forward slash / as part of word
  bindkey -e ; bindkey "^[[1;5C" forward-word ; bindkey "^[[1;5D" backward-word # ctrl+left/right

# zsh completions and history
  autoload -Uz compinit && compinit -u -d ~/.cache/zsh/zcompcache
  zstyle ":completion:*" menu select
  setopt extendedhistory incappendhistory histignorealldups histignorespace histreduceblanks
  precmd() { import-shell-command-history ; set-terminal-tab-title }
  source <(fzf --zsh)

# function to set the tab title for the terminal (directory or project)
  set-terminal-tab-title() {
    [ -d .git ] && local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    local title="${PWD/#$HOME/~}" ; match= # reset match variable
    [[ "$PWD" =~ "^$HOME/Projects/([^/]+)(/.+)?/?$" ]] && title="${match[1]}"
    [ -n "${match[2]}" ] && title="${match[2]#/} in ${title}"
    [ -n "${branch}" ] && title="${title} • ${branch}"
    print -n $"\e]2;${title}\007"
  }

# function to clear history then import project-scoped or main zsh history
  import-shell-command-history() {
    local f="main"
    [[ "$PWD" =~ "^$HOME/Projects/([^/]+)(/.+)?$" ]] && f="project-${match[1]}"
    [[ "$HISTFILE" = ~/.local/history/"${f}" ]] && return
    HISTSIZE=0     SAVEHIST=0     HISTFILE= fc -p
    HISTSIZE=10000 SAVEHIST=10000 HISTFILE=~/.local/history/pre-history ; fc -R
    HISTSIZE=10000 SAVEHIST=10000 HISTFILE=~/.local/history/"${f}" ; fc -R
  }

# project selector
  select-project() {
    local f ; f=$(print -l -- ~/Projects/*/*(/) | cut -d/ -f5-6 | fzf --height=100%) || return
    cd ~/Projects/"${f}" && import-shell-command-history && set-terminal-tab-title
    zle reset-prompt
  }
  zle -N select-project ; bindkey '^[^P' select-project

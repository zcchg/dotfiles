# command aliases
  alias {hx,helix}="helix --log /dev/null"
  alias git="TZ=UTC git"
  alias diff="diff --color=auto"
  alias curl="curl --silent --show-error"
  alias {grep,ugrep}="ugrep --smart-case"

# command functions
  nvim() { env NVIM_LOG_FILE=/dev/null \nvim "$@" }
  tl() { EZA_COLORS=xa=90:da=90 eza -a --group-directories-first --tree -L1 "$@" }
  ll() { EZA_COLORS=xa=90:da=90 eza -a --group-directories-first --long --time-style=long-iso "$@" }
  timestamp() { date +%Y%m%d-%H%M%S }

# zsh settings
  PROMPT='$ ' ; [[ "$OSTYPE" != "linux-"* ]] && PROMPT='★ '
  WORDCHARS="${WORDCHARS/\/}" # exclude forward slash / as part of word
  bindkey -e ; bindkey "^[[1;5C" forward-word ; bindkey "^[[1;5D" backward-word # ctrl+KEY keybindings
  autoload -Uz compinit && compinit -u -d ~/.cache/zsh/zcompcache
  setopt extendedhistory incappendhistory histignorealldups histignorespace histreduceblanks
  precmd() { import-shell-command-history ; set-terminal-tab-title }

# function to set the tab title for the terminal (directory or volume/mount or project name)
  set-terminal-tab-title() {
    [ -d .git ] && local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    local title="${PWD/#$HOME/~}"
    [[ "$PWD" =~ "^$HOME/Projects/([^/]+)/([^/]+)(/.)?" ]] && title="${match[1]}/${match[2]}"
    [ -n "${match[3]}" ] && title="$(basename $PWD) in ${title}"
    [ -n "${branch}" ] && title="${title} • ${branch}"
    print -n $"\e]2;${title}\007"
  }

# function to clear history then import volume/mount-scoped or project-scoped or main zsh history
  import-shell-command-history() {
    local f="main"
    [[ "$PWD" =~ "^/(Volumes|mnt)/([^/]+)" ]] && f="mnt-${match[2]}"
    [[ "$PWD" =~ "^$HOME/Projects/([^/]+)/([^/]+)" ]] && f="project-${match[1]}-${match[2]}"
    [[ "$HISTFILE" = ~/.local/history/"${f}" ]] && return
    HISTSIZE=0     SAVEHIST=0     HISTFILE= fc -p
    HISTSIZE=10000 SAVEHIST=10000 HISTFILE=~/.local/history/pre-history ; fc -R
    HISTSIZE=10000 SAVEHIST=10000 HISTFILE=~/.local/history/"${f}" ; fc -R
  }

# finder/selector
  source <(fzf --zsh)
  export FZF_DEFAULT_COMMAND="fd --type=f"
  export FZF_CTRL_T_COMMAND="fd"
  export FZF_ALT_C_COMMAND="fd --type=d"
  local FZF_COLORS="--color=prompt:0,query:4,pointer:4,hl:4,hl+:4,fg+:7,bg+:16"
  export FZF_DEFAULT_OPTS="${FZF_COLORS} --reverse --no-mouse --pointer=• --no-info --border=none"

# script selector
  select-script() {
    local f ; f=$(print -rl -- ~/.local/bin/*(N:t) | fzf --height=100%) || return
    print "${f}"
    ~/.local/bin/"${f}"
    zle reset-prompt
  }
  zle -N select-script ; bindkey '\eS' 'select-script'

# project selector
  select-project() {
    local f ; f=$(print -l -- ~/Projects/*/*(/) | cut -d/ -f5-6 | fzf --height=100%) || return
    cd -- ~/Projects/"${f}" && import-shell-command-history && set-terminal-tab-title
    zle reset-prompt
  }
  zle -N select-project ; bindkey '\eP' 'select-project'

# zsh settings
  skip_global_compinit=1

# custom includes
  [ -f ~/.config/zsh/dev.zsh ] && . ~/.config/zsh/dev.zsh

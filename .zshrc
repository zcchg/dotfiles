#!/usr/bin/env zsh

# path
  export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
  [ -d /opt/homebrew ] && export PATH="/opt/homebrew/bin:$PATH"
  [ -d /opt/homebrew ] && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# environment variables
  export LANG="en_US.UTF-8"
  export EDITOR="hx --log /dev/null"
  export LESSHISTFILE="/dev/null"

# command aliases and functions
  alias hx="hx --log /dev/null"
  alias {vi,vim}="vim -i NONE"
  alias git="TZ=UTC git"
  alias diff="diff --color=auto"
  alias curl="curl --silent --show-error"
  alias {grep,ugrep}="ugrep --smart-case"
  tl() { EZA_COLORS=xa=90:da=90 eza -a --group-directories-first --tree -L1 $@ }
  ll() { EZA_COLORS=xa=90:da=90 eza -a --group-directories-first --long --time-style=long-iso $@ }
  timestamp() { date +%Y%m%d-%H%M%S }

# zsh settings
  PROMPT='$ ' ; [[ "$OSTYPE" == "linux-"* ]] && PROMPT='λ '
  WORDCHARS="${WORDCHARS/\/}" # include forward slash / as part of word
  bindkey -e # ctrl+KEY keybindings
  bindkey "^[[1;5C" forward-word
  bindkey "^[[1;5D" backward-word
  autoload -Uz compinit && compinit -u -d ~/.cache/zsh/zcompcache
  umask 077 # scope permissions of new files to only this user
  setopt extendedhistory incappendhistory histignorealldups histignorespace histreduceblanks
  precmd() { import-shell-command-history ; set-terminal-tab-title }

# finder/selector
  source <(fzf --zsh)
  __selector() { fzf --height=100% }
  export FZF_DEFAULT_COMMAND="fd --type=f" FZF_CTRL_T_COMMAND="fd" FZF_ALT_C_COMMAND="fd --type=d"
  export FZF_DEFAULT_OPTS="--color=prompt:0,query:4,pointer:4,hl:4,hl+:4,fg+:7,bg+:16 --border=none"
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --reverse --no-info --pointer=•"

# script selector
  select-script() {
    local f ; cat index | __selector | read -r f || return
    echo "${f}"
    eval ${f}
    echo
    zle reset-prompt
  }
  zle -N select-script ; bindkey '\eS' 'select-script'

# project selector
  select-project() {
    local f ; ls -1d ~/Projects/*/* | cut -d/ -f5-6 | __selector | read -r f || return
    cd ~/Projects/"${f}"
    zle reset-prompt
    set-terminal-tab-title
  }
  zle -N select-project ; bindkey '\eP' 'select-project'

# function to set the tab title for the terminal (directory or volume/mount or project name)
  set-terminal-tab-title() {
    local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    local title="$(basename $PWD)"
    [[ "$PWD" == "$HOME" ]] && title="~"
    [[ "$PWD" =~ "^/(Volumes|mnt)/([^/]+)(/.)?" ]] && title="${match[2]}"
    [[ "$PWD" =~ "^$HOME/Projects/([^/]+)/([^/]+)(/.)?" ]] && title="${match[1]}/${match[2]}"
    [ ! -z "${match[3]}" ] && title="$(basename $PWD) in ${title}"
    [ ! -z "${branch}" ] && title="${title} • ${branch}"
    echo -n -e "\e]2;${title}\007"
  }

# function to clear history then import volume/mount-scoped or project-scoped or main zsh history
  import-shell-command-history() {
    local f="main"
    [[ "$PWD" =~ "^/(Volumes|mnt)/([^/]+)" ]] && f="mnt-${match[2]}"
    [[ "$PWD" =~ "^$HOME/Projects/([^/]+)/([^/]+)" ]] && f="project-${match[1]}-${match[2]}"
    if [[ "$HISTFILE" != ~/.cache/history/"${f}" ]] ; then
      HISTSIZE=0     SAVEHIST=0     HISTFILE= fc -p
      HISTSIZE=10000 SAVEHIST=10000 HISTFILE=~/.cache/history/pre-history ; fc -R
      HISTSIZE=10000 SAVEHIST=10000 HISTFILE=~/.cache/history/"${f}" ; fc -R
    fi
  }

# custom includes
  [ -f ~/.zshinclude ] && source ~/.zshinclude

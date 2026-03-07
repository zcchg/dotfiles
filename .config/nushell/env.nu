#!/usr/bin/env nu

# path
  $env.PATH = [ $"($env.HOME)/.local/bin" "/usr/bin" ]

# environment variables
  $env.LANG          = "en_US.UTF-8"
  $env.LC_TIME       = "en_DK.UTF-8" # YYYY-MM-DD
  $env.EDITOR        = "helix --log /dev/null"
  $env.LESSHISTFILE  = "/dev/null"
  $env.NVIM_LOG_FILE = "/dev/null"
  $env.LS_COLORS     = "di=1;34:ln=36:so=1;31:pi=33:ex=1;32:bd=1;33:cd=1;33:or=31"
  $env.EZA_COLORS    = "xa=90:da=90"

# language variables
  $env.GOPATH = $"($env.HOME)/.local/go"
  $env.CARGO_HOME = $"($env.HOME)/.local/cargo"

# fzf settings
  $env.FZF_DEFAULT_COMMAND = "fd --type=f"
  $env.FZF_CTRL_T_COMMAND = "fd"
  $env.FZF_ALT_C_COMMAND = "fd --type=d"
  $env.FZF_DEFAULT_OPTS = (
    "--reverse --no-info --pointer=• --no-mouse --no-separator --no-scrollbar"
    + " --color=prompt:0,query:4,pointer:4,hl:4,hl+:4,fg+:7,bg+:16 --border=none"
  )

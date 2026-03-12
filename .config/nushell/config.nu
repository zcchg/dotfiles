#!/usr/bin/env nu

# environment settings
  umask rwx------

# path
  $env.PATH = [$"($env.HOME)/.local/bin" $"($env.HOME)/.local/bin/shims" "/usr/bin"]

# environment variables
  $env.LANG          = "en_US.UTF-8"
  $env.LC_TIME       = "en_DK.UTF-8" # YYYY-MM-DD
  $env.EDITOR        = "helix --log /dev/null"
  $env.LESSHISTFILE  = "/dev/null"
  $env.NVIM_LOG_FILE = "/dev/null"
  $env.LS_COLORS     = "di=1;34:ln=36:so=1;31:pi=33:ex=1;32:bd=1;33:cd=1;33:or=31"
  $env.EZA_COLORS    = "xa=90:da=90"

# language variables
  $env.GOPATH        = $"($env.HOME)/.local/go"
  $env.CARGO_HOME    = $"($env.HOME)/.local/cargo"

# aliases
  alias helix = ^helix --log /dev/null
  alias hx    = helix
  alias vim   = echo
  alias diff  = ^diff --color=auto
  alias curl  = ^curl --no-progress-meter
  alias ugrep = ^ugrep --smart-case
  alias tl    = ^eza -a --group-directories-first --tree -L1
  alias ll    = ^eza -a --group-directories-first --long --time-style=long-iso

# commands
  def timestamp [] { ^date +"%Y%m%d-%H%M%S" }
  def --wrapped git [...args: string] { with-env { TZ: "UTC" } { ^git ...$args } }

# keybindings
  $env.config.keybindings ++= ([
    [control_alt  c  directory  "commandline edit --insert (fd --type=d | fzf)"]
    [control_alt  t  file       "commandline edit --insert (fd --type=f | fzf)"]
    [control_alt  p  project    "select-project"]
    [control_alt  s  script     "select-script"]
    [control      r  history    "select-scoped-history"]
  ] | each { |r| {
    modifier: $r.0 keycode: $"char_($r.1)" name: $"($r.2)_selector" mode: "emacs"
    event: { send: executehostcommand cmd: $r.3 }
  } })
  $env.config.keybindings ++= [{
    modifier: "alt" keycode: "char_." name: "insert_last_token" mode: "emacs"
    event: [{ edit: "InsertString" value: "!$" } { send: "Enter" }]
  }]

# fzf settings
  $env.FZF_DEFAULT_COMMAND = "fd --type=f"
  $env.FZF_CTRL_T_COMMAND  = "fd --type=f"
  $env.FZF_ALT_C_COMMAND   = "fd --type=d"
  $env.FZF_DEFAULT_OPTS    = " --reverse --no-info --no-separator --no-mouse --no-scrollbar"
  $env.FZF_DEFAULT_OPTS    += " --color='prompt:0 query:2 pointer:4 hl:2 hl+:2 fg+:7'"

# prompt
  $env.PROMPT_INDICATOR     = { "" }
  $env.PROMPT_COMMAND       = { $"(ansi reset)$ " }
  $env.PROMPT_COMMAND_RIGHT = {
    let cwd = if $env.PWD == $env.HOME { "~" } else { $env.PWD | path basename }
    let vcs = try { ^git rev-parse --abbrev-ref HEAD e> /dev/null }
    let prefix = if ($vcs | is-not-empty) { $"($vcs) • " }
    $"(ansi grey)($prefix)(ansi blue_bold)($cwd)"
  }
  $env.config.show_banner = false

# title
  $env.config.hooks = { pre_prompt: [{
    let cwd = if $env.PWD == $env.HOME { "~" } else { $env.PWD | path basename }
    print -n $"\e]2;($cwd)\a"
  }] }
  $env.config.shell_integration = { osc2: false } # process indictator

# completions
  let carapace_completer = { |spans| carapace $spans.0 nushell ...$spans | from json }
  $env.config.completions = { external: { completer: $carapace_completer } }
  $env.config.show_hints = false

# styling
  source ($nu.default-config-dir | path join "theme.nu")
  $env.config.color_config = $theme_text_colors
  $env.config.menus = [{
    name: completion_menu
    only_buffer_difference: false
    marker: ""
    type: { layout: columnar }
    style: $theme_menu_colors
  }]

# function to select a project
  def --env select-project [] {
    ls ~/Projects/*/* | where type == "dir" | get name
    | each { |p| $p | path relative-to ~/Projects }
    | input list --fuzzy --no-footer "Select a project"
    | if $in != null { cd ($"~/Projects/($in)") }
  }

# function to select a script
  def select-script [] {
    ls ~/.local/bin | where type == "file" | get name
    | each { |p| $p | path relative-to ~/.local/bin }
    | input list --fuzzy --no-footer "Select a script"
    | if $in != null { commandline edit --replace $in }
  }

# function to select from project-scoped or main history
  $env.config.history = {
    file_format: "sqlite" isolation: true max_size: 10_000
    path: $"($env.HOME)/.local/state/nushell/history.db"
  }
  def select-scoped-history [] {
    let pre_history_file = $"($env.HOME)/.local/secrets.d/history/pre-history"
    let project_match = $env.PWD | parse --regex $"^($env.HOME)/Projects/\([^/]+\)\(/[^/]+\)?$"

    history
    | select command cwd
    | where { |r|
      if ($project_match | is-not-empty) {
        $r.cwd =~ $"^($env.HOME)/Projects/($project_match.0.capture0)\(/.*\)?$"
      } else {
        $r.cwd !~ $"^($env.HOME)/Projects/[^/]+\(/.*\)?$"
      }
    }
    | get command
    | reverse | uniq | reverse # keep the newest
    | prepend (
      try { open $pre_history_file | lines | str replace --regex "^: [0-9]+:[0-9];" "" } catch {}
    )
    | enumerate
    | each { |r| $"($r.index + 1 | fill --width 4 --alignment right):  ($r.item)" }
    | reverse
    | str join (char nl)
    | fzf --scheme=history --delimiter ":  " --with-nth "1,2" --nth "2.."
    | str trim
    | split row ":  "
    | get 1
    | commandline edit -r $in
  }

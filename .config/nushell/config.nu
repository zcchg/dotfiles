#!/usr/bin/env nu

# environment settings
  umask rwx------

# aliases
  alias helix = ^helix --log /dev/null
  alias hx    = helix
  alias diff  = ^diff --color=auto
  alias curl  = ^curl --silent --show-error
  alias grep  = ^ugrep --smart-case
  alias tl    = ^eza -a --group-directories-first --tree -L1
  alias ll    = ^eza -a --group-directories-first --long --time-style=long-iso

# commands
  def timestamp [] { ^date +"%Y%m%d-%H%M%S" }
  def --wrapped git [...args: string] { with-env { TZ: "UTC" } { ^git ...$args } }

# keybindings
  add-keybinding  control_alt c  directory  "fd --type=d | fzf"
  add-keybinding  control_alt t  file       "fd --type=f | fzf"
  add-keybinding  control_alt p  project    "select-project"
  add-keybinding  control_alt s  script     "select-script"
  add-keybinding  control     r  history    "select-scoped-history"
  $env.config.keybindings ++= [{
    modifier: "alt" keycode: "char_." mode: "emacs" name: "insert_last_token"
    event: [{ edit: "InsertString" value: "!$" } { send: "Enter" }]
  }]

# prompt
  $env.PROMPT_INDICATOR     = { "" }
  $env.PROMPT_COMMAND       = { $"(ansi reset)$ " }
  $env.PROMPT_COMMAND_RIGHT = {
    let cwd = if $env.PWD == $env.HOME { "~" } else { $env.PWD | path basename }
    let vcs = try { ^git rev-parse --abbrev-ref HEAD e> /dev/null }
    let prefix = if ($vcs | is-not-empty) { $"($vcs) • " }
    $"(ansi grey)($prefix)(ansi blue_bold)($cwd)"
  }
  $env.config.hooks = {
    pre_prompt: [{
      let cwd = if $env.PWD == $env.HOME { "~" } else { $env.PWD | path basename }
      print -n $"\e]2;($cwd)\a"
    }]
  }

# nushell settings
  #let carapace_completer = { |spans| carapace $spans.0 nushell ...$spans | from json }
  $env.config.show_banner = false
  $env.config.shell_integration = { osc2: false }
  $env.config.history = { file_format: "sqlite" isolation: true max_size: 10_000 }
  $env.config.show_hints = false
  $env.config.completions = {
    case_sensitive: false
    partial: false
    algorithm: "prefix"
    #external: { enable: false max_results: 100 completer: $carapace_completer }
  }
  $env.config.color_config = (
    $env.config.color_config
    | items { |k, v|
      {
        key: $k
        value: (if ($k | str starts-with "shape_") { "white" } else { $v })
      }
    } | transpose -r -d | merge { hints: "white_dimmed" }
  )
  $env.config.menus = [{
    name: completion_menu
    only_buffer_difference: false
    marker: ""
    type: { layout: columnar }
    style: {
      text:                { fg: "blue" bg: "transparent" }
      selected_text:       { fg: "white" bg: "blue" }
      match_text:          { fg: "white" bg: "red" }
      selected_match_text: { fg: "white" bg: "red" }
      description_text:    { fg: "gray" bg: "none" }
    }
  }]

# function to add a keybinding
  def --env add-keybinding [m: string k: string n: string c: string] {
    $env.config.keybindings ++= [{
      modifier: $m keycode: $"char_($k)" name: $"($n)_selector"
      mode: "emacs" event: { send: executehostcommand cmd: $c }
    }]
  }

# function to select a project
  def --env select-project [] {
    fd -td . ~/Projects --exact-depth=2
    | cut -d/ -f5-6
    | fzf
    | cd ~/Projects/($in)
  }

# function to select a script
  def select-script [] {
    fd -tf . ~/.local/bin --exact-depth=1
    | cut -d/ -f6
    | fzf
    | tee { print }
    | bash -lc $in
  }

# function to select from project-scoped or main history
  def select-scoped-history [] {
    let pre_history = try {
      open ~/.local/history/pre-history | lines | str replace --regex "^: [0-9]+:[0-9];" ""
    } catch { "" }

    let scope = $env.PWD | parse --regex $"^($env.HOME)/Projects/\([^/]+\)/\([^/]+\)"

    history
    | select command_line cwd
    | where { |r|
      if ($scope | is-not-empty) {
        $r.cwd =~ $"^($env.HOME)/Projects/($scope.0.capture0)/($scope.0.capture1)\(/.*\)?$"
      } else {
        $r.cwd !~ $"^($env.HOME)/Projects/[^/]+/[^/]+\(/.*\)?$"
      }
    }
    | get command_line
    | reverse | uniq | reverse # keep the newest
    | prepend $pre_history
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

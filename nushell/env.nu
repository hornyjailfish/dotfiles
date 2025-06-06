# Nushell Environment Config File
$env.EDITOR = "nvim"
# $env.SHELL = "nu"

def create_left_prompt [] {
    let path_segment = ($env.PWD)

    $path_segment
}

def create_right_prompt [] {
    let time_segment = ([
        (date now | format date '%m/%d/%Y %r')
    ] | str join)

    $time_segment
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { || create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = { || "〉" }
$env.PROMPT_INDICATOR_VI_INSERT = { || ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = { || "〉" }
$env.PROMPT_MULTILINE_INDICATOR = { || "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let es = (char esep)
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row ';' }
    to_string: { |v| $v | str join ';' }
  }
  "Path": {
    from_string: { |s| $s | split row ';' }
    to_string: { |v| $v | str join ';' }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
$env.NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
 $env.Path = ($env.Path | split row (char esep) )
 # let-env =:: = '::\'

$env.PRETTIER_DEFAULT_CONFIG = "~/.prettierrc"



# $env.SURREAL_PATH = "file://c:/Users/5q/Documents/surrealdbs/"
# zoxide init nushell --hook prompt | save ~/.zoxide.nu -f

# Carapace setup
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

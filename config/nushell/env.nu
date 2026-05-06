const NU_LIB_DIRS = [
    ($nu.data-dir | path join 'completions')
]

const NU_PLUGIN_DIRS = [
    ($nu.current-exe | path dirname)
    ...$NU_PLUGIN_DIRS
]

$env.path ++= [
    "~/.local/bin"
    "~/.cargo/bin"
]

$env.EDITOR = "nvim"
$env.MANPAGER = "nvim +Man!"
$env.PAGER = "bat --plain --paging=always"
$env.FZF_DEFAULT_OPTS_FILE = $'($env.HOME)/.fzfrc'
$env.LS_COLORS = (vivid generate ansi)
$env.__zoxide_hooked = true
$env.RUST_BACKTRACE = 1
$env.HOMEBREW_NO_ENV_HINTS = 1

zoxide init nushell | save -f ~/.zoxide.nu

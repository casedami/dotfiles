source themes/iceclimber.nu

def overlay_info [] {
    let current_overlays = (overlay list | where name != zero | where active == true | get name)
    if ($current_overlays | length) > 0 {
        let overlays = ($current_overlays | str join ", ")
        $"(ansi $theme.operator)\((ansi $theme.property)($overlays)(ansi $theme.operator)\)(ansi reset) "
    } else {
        ""
    }
}

def jobs [] {
    let job_count = (job list | length)
    if ($job_count | into int) > 0 {
        $"(ansi bi)(ansi $theme.func)%($job_count)(ansi reset) "
    } else {
        ""
    }
}

def create_left_prompt [] {
    let path = $"(ansi $theme.string)(flamingo path)(ansi reset)"
    let git = $" (ansi i)(ansi $theme.alt)(flamingo git)(ansi reset)"

    $"(jobs)(overlay_info)($path)($git)"
}

def create_right_prompt [] {
    let time_segment = (date now | format date '%H:%M')
    $"(ansi $theme.string)($time_segment)(ansi reset)"
}

def prompt_indicator [sym] {
    let indicator_color = if ($env.LAST_EXIT_CODE != 0) {
        (ansi b)(ansi $theme.diag_red)
    } else if (is-admin) {
        (ansi b)(ansi $theme.constant)
    } else {
        (ansi $theme.operator)
    }

    $"($indicator_color)($sym)(ansi reset) "
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| prompt_indicator ">" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| prompt_indicator ":" }
$env.PROMPT_MULTILINE_INDICATOR = {|| $"(ansi $theme.operator):::(ansi reset) " }
$env.TRANSIENT_PROMPT_COMMAND = ""
$env.EDITOR = "nvim"

$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

$env.NU_LIB_DIRS = [
    ($nu.data-dir | path join 'completions')
]

const NU_PLUGIN_DIRS = [
  ($nu.current-exe | path dirname)
  ...$NU_PLUGIN_DIRS
]

$env.path ++= [
    "~/.local/bin",
    "~/.cargo/bin",
]

if $nu.os-info.name == "linux" {
    $env.path ++= [
    "/home/linuxbrew/.linuxbrew/bin",
    "~/.nvm",
    ]
    $env.PYTHONPATH = "/usr/lib/python3/dist-packages"
    $env.XDG_SESSION_TYPE = 'wayland'
    $env.XDG_CURRENT_DESKTOP = 'sway'
    $env.XDG_SESSION_DESKTOP = 'sway'
}

$env.__zoxide_hooked = true
$env.RUST_BACKTRACE = 1
$env.VIRTUAL_ENV_DISABLE_PROMPT = 1
$env.GPG_TTY = (tty)
$env.MANPAGER = "nvim +Man!"
$env.PAGER = "less"
$env.LESS = ($env.LESS? | default "" | str replace --regex 'X' '')
$env.APPIMAGE_EXTRACT_AND_RUN = 1
$env.FZF_DEFAULT_OPTS_FILE = '/home/cdm/.config/.fzfrc'

zoxide init nushell | save -f ~/.zoxide.nu
source $"($nu.home-path)/.cargo/env.nu"

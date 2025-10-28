source themes/iceclimber.nu

def get-git-info [] {
    let git_status = (do -i { git status --porcelain } | complete)
    if ($git_status.exit_code == 0) {
        let branch = (
            do -i { git branch --show-current }
            | complete
            | get stdout
            | str trim
        )
        let branch = $"(ansi i)(ansi b)(ansi $theme.type)($branch)(ansi reset)"

        if ($branch | is-empty) {
            ""
        } else {
            let dirty = (
                if ($git_status.stdout | lines | length) > 0 {
                    $"(ansi $theme.alt)*(ansi reset)"
                }
                else { "" }
            )
            let ab_info = ""
            let ab_info = $"(ansi $theme.property)($ab_info)(ansi reset)"
            $" ($dirty)($branch)($ab_info)"
        }
    } else { "" }
}

def create_left_prompt [] {
    let dir = match (
        do -i { $env.PWD | path relative-to $nu.home-path }
    ) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let git_info = (get-git-info)
    let path_color = (
        if (is-admin) { ansi $theme.diag_red }
        else { ansi $theme.string })
    let separator_color = (
        if (is-admin) { ansi $theme.diag_red }
        else { ansi $theme.string })
    let path_segment = $"($path_color)($dir)(ansi reset)"
    let overlays = (overlay list | where name != zero | where active)
    let overlay_info = if ($overlays | length) > 0 {
        let current_overlays = $overlays | where active == true | get name | str join ", "
        $"(ansi $theme.operator)\((ansi $theme.constant)($current_overlays)(ansi $theme.operator)\)(ansi reset) "
    } else {
        ""
    }

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
    $"($overlay_info)($path_segment)($git_info)"
}

def create_right_prompt [] {
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%H:%M') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi $theme.diag_green)${1}(ansi $theme.operator)" |
        str replace --regex --all "([AP]M)" $"(ansi $theme.operator)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment, (char space)] | str join)
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| $"(ansi $theme.operator)>(ansi reset) " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| $"(ansi $theme.operator):(ansi reset) " }
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
    ($nu.default-config-dir | path join 'scripts')
    ($nu.data-dir | path join 'completions')
]

$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

$env.path ++= [
    "~/.local/bin",
    "~/.cargo/bin",
    "/home/linuxbrew/.linuxbrew/bin",
    "~/.nvm",
]

$env.PYTHONPATH = "/usr/lib/python3/dist-packages"

$env.XDG_SESSION_TYPE = 'wayland'
$env.XDG_CURRENT_DESKTOP = 'sway'
$env.XDG_SESSION_DESKTOP = 'sway'
$env.__zoxide_hooked = true
$env.RUST_BACKTRACE = 1
$env.VIRTUAL_ENV_DISABLE_PROMPT = 1
$env.GPG_TTY = (tty)
$env.MANPAGER = "nvim +Man!"
$env.PAGER = "less"
$env.LESS = ($env.LESS? | default "" | str replace --regex 'X' '')
$env.APPIMAGE_EXTRACT_AND_RUN = 1
$env.FZF_DEFAULT_OPTS = '
--color=fg:#555568,bg:#171719,hl:#a8a6de,gutter:#171719
--color=fg+:#629da3,bg+:#1d1d22,hl+:#a8a6de
--color=info:#abbceb,prompt:#a8a6de,pointer:#629da3
--color=marker:#8a88db,spinner:#8a88db,header:#8a88db
--separator="─" --scrollbar="│" --layout="reverse" --info="right"
--prompt="$ "
--marker="*"
--pointer=">"
--cycle
--multi
--height 40%
--preview "cat {} 2> /dev/null"
--preview-window="right:60%:hidden"
--bind="?:toggle-preview"
--bind="ctrl-u:preview-page-up"
--bind="ctrl-d:preview-page-down"'

zoxide init nushell | save -f ~/.zoxide.nu
source $"($nu.home-path)/.cargo/env.nu"

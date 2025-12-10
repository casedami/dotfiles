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
    ]
    $env.PYTHONPATH = "/usr/lib/python3/dist-packages"
    $env.XDG_SESSION_TYPE = 'wayland'
    $env.XDG_CURRENT_DESKTOP = 'sway'
    $env.XDG_SESSION_DESKTOP = 'sway'
    $env.APPIMAGE_EXTRACT_AND_RUN = 1

    keychain --quiet --eval --agents ssh id_ed25519 o> /dev/null
} else {
    $env.path ++= [
        "/opt/homebrew/bin"
    ]
}

$env.__zoxide_hooked = true
$env.RUST_BACKTRACE = 1
$env.VIRTUAL_ENV_DISABLE_PROMPT = 1
$env.GPG_TTY = (tty)
$env.MANPAGER = "nvim +Man!"
$env.PAGER = "less"
$env.LESS = ($env.LESS? | default "" | str replace --regex 'X' '')
$env.FZF_DEFAULT_OPTS_FILE = $'($env.HOME)/.config/.fzfrc'
$env.LS_COLORS = 'rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.jxl=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:'

zoxide init nushell | save -f ~/.zoxide.nu

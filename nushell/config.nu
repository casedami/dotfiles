use std/dirs

$env.config = {
    show_banner: false
    table: {
        show_empty: false
        trim: {methodology: truncating, truncating_suffix: "..."}
    }
    display_errors: {termination_signal: false}
    history: {max_size: 5000, file_format: "sqlite", isolation: true}
    completions: {algorithm: "fuzzy"}
    cursor_shape: {vi_insert: line, vi_normal: block}
    footer_mode: 20
    buffer_editor: nvim
    edit_mode: vi
}

source ~/.zoxide.nu
source themes/hojicha.nu
source gitcmd.nu # source here instead of autoload/ to expose to git aliases

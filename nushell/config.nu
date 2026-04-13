use std/dirs
source completions/git/cmp.nu
source themes/hojicha.nu
source gitcmd.nu # source here instead of autoload/ to expose to git aliases

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
    menus: [
        {
            name: abbr_menu
            only_buffer_difference: false
            marker: none
            type: {
                layout: columnar
                columns: 1
                col_width: 20
                col_padding: 2
            }
            style: {text: green, selected_text: green_reverse, description_text: yellow}
            source: {|buffer, position|
                let match = $abbrevs | columns | where $it == $buffer
                if ($match | is-empty) {
                    {value: $buffer}
                } else {
                    {
                        value: ($abbrevs | get $match.0)
                    }
                }
            }
        }
    ]
}

source ~/.zoxide.nu

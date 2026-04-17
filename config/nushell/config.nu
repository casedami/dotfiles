use std/dirs
source themes/hojicha.nu
source completions/git/cmp.nu

let abbrevs = {
    ga: 'git add'
    gac: 'git-add-fzf'
    gb: 'git branch'
    gc: 'git commit -v'
    gd: 'git diff'
    gdt: 'git difftool -d'
    gl: 'git-log-tbl'
    gm: 'git merge'
    gq: 'git-conflicts'
    gr: 'git rebase'
    gR: 'git restore'
    gs: 'git-status-tbl'
    gS: 'git show'
    gwa: 'git worktree add'
    gwr: 'git worktree remove'
    gwl: 'git worktree list'
    gx: 'git switch'
    gxc: 'git-checkout-fzf'
    la: 'ls -a'
    ll: 'ls -l'
    fg: 'job unfreeze'
    dad: 'dirs add ~/dotfiles'
    ou: 'overlay use'
    oh: 'overlay hide'
    ol: 'overlay list'
}

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

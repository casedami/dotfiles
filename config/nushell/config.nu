use std/dirs
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
    da: 'dirs add'
    dd: 'dirs drop'
    dad: 'dirs add ~/dotfiles'
    ou: 'overlay use'
    oh: 'overlay hide'
    ol: 'overlay list'
}

$env.config.show_banner = false
$env.config.table = {
    show_empty: false
    trim: {methodology: truncating, truncating_suffix: "..."}
}

$env.config.display_errors = {termination_signal: false}
$env.config.history = {max_size: 5000, file_format: "sqlite", isolation: true}
$env.config.cursor_shape = {vi_insert: line, vi_normal: block}
$env.config.footer_mode = 20
$env.config.buffer_editor = "nvim"
$env.config.edit_mode = "vi"
$env.config.menus ++= [
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

$env.config.keybindings ++= [
    {
        name: complete_history_word_partial
        modifier: control
        keycode: char_w
        mode: vi_insert
        event: {send: historyhintwordcomplete}
    }
    {
        name: file_manager
        modifier: control
        keycode: char_y
        mode: [vi_normal, vi_insert]
        event: {send: executehostcommand, cmd: "Fexplore"}
    }
    {
        name: open_sys_diagnostics
        modifier: control
        keycode: char_d
        mode: [vi_normal]
        event: {send: executehostcommand, cmd: "btm"}
    }
    {
        name: open_reedline_editor
        modifier: control
        keycode: char_f
        mode: [vi_normal]
        event: {send: openeditor}
    }
    {
        name: open_editor
        modifier: control
        keycode: char_o
        mode: [emacs, vi_normal, vi_insert]
        event: {send: executehostcommand, cmd: "nvim"}
    }
    {
        name: dirs_cycle_next
        modifier: control
        keycode: char_k
        mode: [vi_normal, vi_insert]
        event: {send: executehostcommand, cmd: "dirs next"}
    }
    {
        name: dirs_cycle_prev
        modifier: control
        keycode: char_j
        mode: [vi_normal, vi_insert]
        event: {send: executehostcommand, cmd: "dirs prev"}
    }
    {
        name: job_resume
        modifier: alt
        keycode: char_z
        mode: [vi_normal, vi_insert]
        event: {send: executehostcommand, cmd: "job unfreeze"}
    }
    {
        name: abbr_menu
        modifier: none
        keycode: enter
        mode: [emacs, vi_normal, vi_insert]
        event: [
            {send: menu, name: abbr_menu}
            {send: enter}
        ]
    }
    {
        name: abbr_menu
        modifier: none
        keycode: space
        mode: [emacs, vi_normal, vi_insert]
        event: [
            {send: menu, name: abbr_menu}
            {edit: insertchar, value: ' '}
        ]
    }
]

source ~/.zoxide.nu

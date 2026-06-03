use std/dirs
source completions/git/cmp.nu

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
$env.config.abbreviations = {
    f: fzf
    ptop: 'ps | sort-by cpu -r | first 15'
    ga: 'git add'
    gac: git-add-fzf
    gb: 'git branch'
    gc: 'git commit -v'
    gd: 'git diff'
    gdt: 'git difftool -d'
    gl: git-log-tbl
    gm: 'git merge'
    gq: git-conflicts
    gr: 'git rebase'
    gR: 'git restore'
    gs: git-status-tbl
    gS: 'git show'
    gwa: 'git worktree add'
    gwr: 'git worktree remove'
    gwl: 'git worktree list'
    gx: 'git switch'
    gxc: git-checkout-fzf
    fg: 'job unfreeze'
    da: 'dirs add'
    dd: 'dirs drop'
    dad: 'dirs add ~/dotfiles'
    ou: 'overlay use'
    oh: 'overlay hide'
    ol: 'overlay list'
}

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
        name: open_reedline_editor
        modifier: control
        keycode: char_f
        mode: [vi_normal, vi_insert]
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
        mode: [emacs, vi_normal, vi_insert]
        event: {send: executehostcommand, cmd: "dirs next"}
    }
    {
        name: dirs_cycle_prev
        modifier: control
        keycode: char_j
        mode: [emacs, vi_normal, vi_insert]
        event: {send: executehostcommand, cmd: "dirs prev"}
    }
]

source ~/.zoxide.nu

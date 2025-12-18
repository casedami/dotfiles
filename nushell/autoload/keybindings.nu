$env.config.keybindings = [
    {
        name: completion_menu
        modifier: none
        keycode: tab
        mode: vi_normal
        event: {
            until: [
                { send: menu name: completion_menu }
                { send: menunext }
                { edit: complete }
            ]
        }
    }
    {
        name: complete_history_word
        modifier: none
        keycode: tab
        mode: vi_insert
        event: { send: historyhintcomplete }
    }
    {
        name: newline
        modifier: none
        keycode: "char_|"
        mode: vi_normal
        event: [
            { edit: insertnewline }
            { edit: insertchar value: "|" }
            { edit: insertchar value: " " }
        ]
    }
    {
        name: completion_previous_menu
        modifier: shift
        keycode: backtab
        mode: [vi_normal, vi_insert]
        event: { send: menuprevious }
    }
    {
        name: history_menu
        modifier: control
        keycode: char_r
        mode: vi_normal
        event: { send: menu name: history_menu }
    }
    {
        name: help_menu
        modifier: none
        keycode: char_?
        mode: vi_normal
        event: { send: menu name: help_menu }
    }
    {
        name: next_page_menu
        modifier: none
        keycode: "char_]"
        mode: vi_normal
        event: { send: menupagenext }
    }
    {
        name: undo_or_previous_page_menu
        modifier: none
        keycode: "char_["
        mode: vi_normal
        event: {
            until: [
                { send: menupageprevious }
                { edit: undo }
            ]
        }
    }
    {
        name: cancel_command
        modifier: control
        keycode: char_c
        mode: [emacs, vi_normal, vi_insert]
        event: { send: ctrlc }
    }
    {
        name: clear_screen
        modifier: shift
        keycode: char_l
        mode: vi_normal
        event: { send: clearscreen }
    }
    {
        name: search_history
        modifier: none
        keycode: char_/
        mode: vi_normal
        event: [
            { send: searchhistory }
            { send: vichangemode mode: insert}
        ]
    }
    {
        name: file_manager
        modifier: control
        keycode: char_p
        mode: [vi_normal, vi_insert]
        event: { send: executehostcommand cmd: "P" }
    }
    {
        name: file_manager_no_cd
        modifier: alt
        keycode: char_p
        mode: [vi_normal, vi_insert]
        event: { send: executehostcommand cmd: "yazi" }
    }
    {
        name: open_command_editor
        modifier: control
        keycode: char_o
        mode: [emacs, vi_normal, vi_insert]
        event: { send: executehostcommand cmd: "vim" }
    }
    {
        name: dirs_cycle_next
        modifier: control
        keycode: char_j
        mode: [emacs, vi_normal, vi_insert]
        event: { send: executehostcommand cmd: "dirs next" }
    }
    {
        name: dirs_cycle_prev
        modifier: control
        keycode: char_k
        mode: [emacs, vi_normal, vi_insert]
        event: { send: executehostcommand cmd: "dirs prev" }
    }
    {
        name: job_resume
        modifier: alt
        keycode: char_z
        mode: [vi_normal, vi_insert]
        event: { send: executehostcommand cmd: "job unfreeze" }
    }
    {
        name: sys_monitor
        modifier: control
        keycode: char_m
        mode: [emacs, vi_normal, vi_insert]
        event: { send: executehostcommand cmd: "btm" }
    }
]


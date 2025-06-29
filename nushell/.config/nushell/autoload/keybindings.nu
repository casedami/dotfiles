
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
        keycode: char_/
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
        name: escape
        modifier: none
        keycode: escape
        mode: [emacs, vi_normal, vi_insert]
        event: { send: esc }    # NOTE: does not appear to work
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
        name: file_manager
        modifier: control
        keycode: char_p
        mode: [vi_normal, vi_insert]
        event: { send: executehostcommand cmd: "P" }
    }
    {
        name: search_history
        modifier: none
        keycode: char_/
        mode: vi_normal
        event: { send: searchhistory }
    }
    {
        name: open_command_editor
        modifier: control
        keycode: char_o
        mode: [emacs, vi_normal, vi_insert]
        event: { send: openeditor }
    }
]


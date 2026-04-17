$env.config.keybindings ++= [
    {
        name: completion_menu
        modifier: none
        keycode: tab
        mode: vi_normal
        event: {
            until: [
                {send: menu, name: completion_menu}
                {send: menunext}
                {edit: complete}
            ]
        }
    }
    {
        name: complete_history_word
        modifier: none
        keycode: tab
        mode: vi_insert
        event: {send: historyhintcomplete}
    }
    {
        name: complete_history_word_partial
        modifier: control
        keycode: char_w
        mode: vi_insert
        event: {send: historyhintwordcomplete}
    }
    {
        name: search_history
        modifier: none
        keycode: char_/
        mode: vi_normal
        event: [
            {send: searchhistory}
            {send: vichangemode, mode: insert}
        ]
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
        keycode: char_t
        mode: [vi_normal]
        event: {send: executehostcommand, cmd: "btm"}
    }
    {
        name: open_command_editor
        modifier: control
        keycode: char_o
        mode: [emacs, vi_normal, vi_insert]
        event: {send: executehostcommand, cmd: "nvim"}
    }
    {
        name: dirs_cycle_next
        modifier: control
        keycode: char_n
        mode: [emacs, vi_normal, vi_insert]
        event: {send: executehostcommand, cmd: "dirs next"}
    }
    {
        name: dirs_cycle_prev
        modifier: control
        keycode: char_p
        mode: [emacs, vi_normal, vi_insert]
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
        name: goto_home
        modifier: control
        keycode: char_h
        mode: [vi_normal, vi_insert]
        event: {send: executehostcommand, cmd: "cd"}
    }
    {
        name: goto_config
        modifier: control
        keycode: char_d
        mode: [vi_normal, vi_insert]
        event: {send: executehostcommand, cmd: "cd ~/dotfiles"}
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

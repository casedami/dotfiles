
$env.config = {
    show_banner: false
    ls: { use_ls_colors: true }
    rm: { always_trash: false }

    table: {
        mode: rounded
        index_mode: always
        show_empty: false
        padding: { left: 1, right: 1 }
        trim: {
            methodology: truncating
            wrapping_try_keep_words: true
            truncating_suffix: "..."
        }
        header_on_separator: false
    }

    error_style: "fancy"

    display_errors: {
        exit_code: false
        termination_signal: false
    }

    datetime_format: {}

    history: {
        max_size: 1000
        sync_on_enter: true
        file_format: "plaintext"
        isolation: false
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
        sort: "smart"
        external: {
            enable: true
            max_results: 100
            completer: null
        }
        use_ls_colors: true
    }

    filesize: {
        metric: true
        format: "auto"
    }

    cursor_shape: {
        vi_insert: line
        vi_normal: block
    }

    footer_mode: 20
    float_precision: 2
    buffer_editor: nvim
    use_ansi_coloring: true
    bracketed_paste: true
    edit_mode: vi
    shell_integration: {
        osc2: true
        osc7: true
        osc8: true
        osc9_9: false
        osc133: true
        osc633: true
        reset_application_mode: true
    }
    render_right_prompt_on_last_line: false
    recursion_limit: 50

    plugin_gc: {
        default: {
            enabled: true
            stop_after: 10sec
        }
        plugins: {}
    }

    hooks: {
        pre_prompt: [{ null }] # run before the prompt is shown
        pre_execution: [{ null }] # run before the repl input is run
        env_change: {
            PWD: [{|before, after| null }] # run if the PWD environment is different since the last repl input
        }
        display_output: "if (term size).columns >= 100 { table -e } else { table }" # run to display the output of a pipeline
        command_not_found: { null } # return an error message when a command is not found
    }
}

source ~/.zoxide.nu
source alias.nu
source keybindings.nu
source menus.nu


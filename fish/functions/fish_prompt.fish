function fish_prompt
    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l green (set_color -o green)
    set -l blue (set_color -o blue)
    set -l magenta (set_color -o magenta)
    set -l normal (set_color normal)

    set -l __last_command_exit_status $status

    set -g __fish_git_prompt_color yellow
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showupstream git
    set -g __fish_git_prompt_color_upstream magenta
    set -g __fish_git_prompt_char_upstream_ahead ↑
    set -g __fish_git_prompt_char_upstream_behind ↓
    set -g __fish_git_prompt_char_upstream_equal ''
    set -g __fish_git_prompt_char_stateseparator :

    set -l promptchar_color "$normal"
    if test $__last_command_exit_status != 0
        set promptchar_color "$red"
    end

    set -l promptchar "$promptchar_color> "
    if fish_is_root_user
        set promptchar "$promptchar_color# "
    end

    set -l cwd $cyan(basename (prompt_pwd))

    echo -n -s $cwd (fish_git_prompt) ' ' $promptchar ''$normal''
end

function fish_prompt
    set -l __last_command_exit_status $status
    set -l magenta (set_color -o magenta)
    set -l red (set_color -o red)

    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showupstream auto

    set -g __fish_git_prompt_color $alt
    set -g __fish_git_prompt_color_prefix $orange
    set -g __fish_git_prompt_color_suffix $orange
    set -g __fish_git_prompt_color_dirtystate $orange
    set -g __fish_git_prompt_color_upstream magenta
    set -g __fish_git_prompt_color_merging red

    set -g __fish_git_prompt_char_upstream_ahead :↑
    set -g __fish_git_prompt_char_upstream_behind :↓
    set -g __fish_git_prompt_char_upstream_diverged :󰹹
    set -g __fish_git_prompt_char_upstream_equal ''
    set -g __fish_git_prompt_char_stateseparator ':'

    set -l promptchar_color (set_color normal)
    if test $__last_command_exit_status != 0
        set promptchar_color (set_color red)
    end

    set -l promptchar "$promptchar_color> "
    if fish_is_root_user
        set promptchar "$promptchar_color# "
    end

    set -g fish_prompt_pwd_full_dirs 2
    set -l cwd (set_color blue) (prompt_pwd)

    echo -n -s $cwd (fish_git_prompt) ' ' $promptchar (set_color normal)
end

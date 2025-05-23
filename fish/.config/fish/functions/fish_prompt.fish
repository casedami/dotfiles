function fish_prompt
    # MARK: git prompt opts
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showupstream auto
    # MARK: git prompt colors
    set -g __fish_git_prompt_color $type
    set -g __fish_git_prompt_color_prefix $alt
    set -g __fish_git_prompt_color_suffix $alt
    set -g __fish_git_prompt_color_dirtystate $alt
    set -g __fish_git_prompt_color_upstream $constant
    set -g __fish_git_prompt_color_merging red
    # MARK: git prompt chars
    set -g __fish_git_prompt_char_upstream_ahead :↑
    set -g __fish_git_prompt_char_upstream_behind :↓
    set -g __fish_git_prompt_char_upstream_diverged :󰹹
    set -g __fish_git_prompt_char_upstream_equal ''
    set -g __fish_git_prompt_char_stateseparator ':'

    # MARK: prompt char color based on last command status
    set -l promptchar_color (set_color normal)
    if test $status != 0
        set promptchar_color (set_color -o red)
    end

    # MARK: prompt char based on user
    set -l promptchar "$promptchar_color> "
    if fish_is_root_user
        set promptchar "$promptchar_color# "
    end

    # MARK: venv prompt
    set -l venv ""
    if set -q VIRTUAL_ENV
        set venv (set_color $property --italics)'('(basename "$VIRTUAL_ENV")')'(set_color normal) ' '
    end

    set -g fish_prompt_pwd_full_dirs 2
    set -l cwd (set_color $str) (prompt_pwd)

    echo -n -s $venv $cwd (fish_git_prompt) ' ' $promptchar (set_color normal)
end

function fish_right_prompt -d "Write out the right prompt"
    set -l time (set_color $comment --italics) (date '+%H:%M')
    echo $time (set_color normal)
end

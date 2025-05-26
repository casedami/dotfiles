abbr --add gb git branch -a
abbr --add gc git checkout
abbr --add gc git commit
abbr --add gp git push
abbr --add ga git add
abbr --add gs git status -s
abbr --add gl git ll
abbr --add gd git diff
abbr --add gr git rebase

alias vim="nvim"
alias C="clear"
alias ssh="TERM=xterm-256color $(which ssh)"
alias python="python3.13"
alias cat="bat"

set -U fish_greeting
set -Ux EDITOR nvim
set -gx LANG en_US.UTF-8
set -gx TERM xterm-256color
set -gx RUST_BACKTRACE 1
set -Ux VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx MANPAGER "nvim +Man!"
set -gx GPG_TTY $(tty)
set -x LESS (string replace -r 'X' '' $LESS)

set -gx FZF_DEFAULT_OPTS '
--color=fg:#767777,bg:#161617,hl:#bbc7b1,gutter:#161617
--color=fg+:#748fa6,bg+:#222324,hl+:#bbc7b1
--color=info:#767777,prompt:#bbc7b1,pointer:#748fa6
--color=marker:#72966c,spinner:#72966c,header:#72966c
--separator="─" --scrollbar="│" --layout="reverse" --info="right"
--prompt=" "
--marker=">"
--pointer="󰘍"
--cycle
--multi
--height 40%
--preview "cat {} 2> /dev/null"
--preview-window="right:60%:hidden"
--bind="?:toggle-preview"
--bind="ctrl-u:preview-page-up"
--bind="ctrl-d:preview-page-down"'

zoxide init fish | source

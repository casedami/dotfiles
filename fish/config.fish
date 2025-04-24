zoxide init fish | source

abbr --add gC git checkout
abbr --add gc git commit
abbr --add gp git push
abbr --add gs git s
abbr --add mm monthly

alias vim="nvim"
alias ssh="TERM=xterm-256color $(which ssh)"
alias python="python3.13"

set -gx NOTES_DIR ~/self/notes/main/monthly/

set -U fish_greeting
set -U EDITOR nvim
set -gx LANG en_US.UTF-8
set -gx TERM xterm-256color
set -gx RUST_BACKTRACE 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -Ux VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx FZF_DEFAULT_OPTS '
--color=fg:#adacac,bg:#111111,hl:#8a879c,gutter:#111111
--color=fg+:#9c797d,bg+:#1b1c1d,hl+:#8a879c
--color=info:#696969,prompt:#8a879c,pointer:#9c797d
--color=marker:#a18b7f,spinner:#a18b7f,header:#a18b7f
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

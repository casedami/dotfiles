if status is-interactive
    # Commands to run in interactive sessions can go here
end

zoxide init fish | source

alias vim="nvim"
alias cd="z"
alias tm="tmux"
alias sed="sed -E"
alias ls="exa --icons --group-directories-first"
alias lsl="exa -l -h --no-user --git"
alias tree="exa -T"
alias grep="grep --color=auto"

alias morning="morning.zsh"
alias evening="evening.zsh"
alias todo="todo.sh"

alias cade="ssh u1337847@lab1-13.eng.utah.edu"
alias transfer="sftp u1337847@lab1-13.eng.utah.edu"
alias ssh="TERM=xterm-256color $(which ssh)"
alias ystop="yabai --stop-service"
alias ystart="yabai --start-service"
alias python="python3"

alias uni="cd ~/self/dev/uni/"
alias notes="cd ~/self/notes/uni/"
alias conf="cd ~/.config/"

set -gx LANG en_US.UTF-8
set -gx TERM xterm-256color
set -U EDITOR nvim

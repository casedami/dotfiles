zoxide init fish | source

abbr --add gC git checkout
abbr --add gc git commit
abbr --add gp git push
abbr --add gs git s
abbr --add mm monthly

alias vim="nvim"
alias sed="sed -E"
alias ls="eza --icons --group-directories-first"
alias ll="ls --long --header --git --binary --smart-group --time-style=iso --total-size"
alias la="eza -tree 3"
alias tree="eza -tree"
alias top="top -n 25 -s 3"
alias fd="fd -c never"

alias cade="ssh u1337847@lab1-13.eng.utah.edu"
alias transfer="sftp u1337847@lab1-13.eng.utah.edu"
alias ssh="TERM=xterm-256color $(which ssh)"

alias python="python3.13"
alias conda+="conda activate"
alias conda-="conda deactivate"
alias pydb="python -m pdb"

set -U fish_greeting
set -gx LANG en_US.UTF-8
set -gx TERM xterm-256color
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx RUST_BACKTRACE 1
set -U EDITOR nvim
set -gx NOTES_DIR ~/self/notes/main/monthly/

fish_add_path $HOME/.local/bin/scripts/
fish_add_path $HOME/Library/Python/3.13/bin

set -gx FZF_DEFAULT_OPTS '
--color=fg:#bbbac1,bg:#171719,hl:#a8a6de,gutter:#171719
--color=fg+:#629da3,bg+:#1d1d22,hl+:#a8a6de
--color=info:#555568,prompt:#a8a6de,pointer:#629da3
--color=marker:#8a88db,spinner:#8a88db,header:#8a88db
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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
    eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
        . "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /opt/homebrew/Caskroom/miniconda/base/bin $PATH
    end
end
# <<< conda initialize <<<

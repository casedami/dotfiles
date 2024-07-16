zoxide init fish | source
fzf --fish | source
abbr --add go git checkout
abbr --add gc git commit
abbr --add gp git push
abbr --add gs git s
abbr --add kitty "rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock"
abbr --add assgn "cp -r ~/Developer/tex/templates/assignment-template"
abbr --add wrtg "cp -r ~/Developer/tex/templates/wrtg-template"

alias vim="nvim"
alias cd="z"
alias tm="tmux"
alias sed="sed -E"
alias ls="exa --icons --group-directories-first"
alias lsl="exa -l -h --no-user --git"
alias tree="exa -T"
alias grep="grep --color=auto"
alias top="top -n 25"
alias fd="fd -c never"
alias timeit="/usr/bin/time -p"

alias cade="ssh u1337847@lab1-13.eng.utah.edu"
alias transfer="sftp u1337847@lab1-13.eng.utah.edu"
alias ssh="TERM=xterm-256color $(which ssh)"

alias python="python3"
alias conda+="conda activate"
alias conda-="conda deactivate"
alias pydb="python -m pdb"

alias uni="cd ~/self/dev/uni/"
alias notes="cd ~/self/notes/main/"
alias conf="cd ~/.config/"
alias ic="cd /Users/caseymiller/Library/Mobile Documents/com~apple~CloudDocs"

set -U fish_greeting
set -gx LANG en_US.UTF-8
set -gx TERM xterm-256color
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx RUST_BACKTRACE 1
set -U EDITOR nvim

set -gx __zoxide_zi cdi
set -gx FZF_DEFAULT_OPTS '
--color=fg:#bbbac1,bg:#121212,hl:#a3b8b5,gutter:#121212
--color=fg+:#bbbac1,bg+:#26262a,hl+:#a3b8b5
--color=info:#555555,prompt:#a3849b,pointer:#a3849b
--color=marker:#6b8f89,spinner:#6b8f89,header:#6b8f89"
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

fish_add_path $HOME/.local/bin/scripts/
fish_add_path $HOME/Library/Python/3.11/bin

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

if status is-interactive
    zoxide init fish | source
    fzf --fish | source

    abbr --add go git checkout
    abbr --add gc git commit
    abbr --add gp git push
    abbr --add gs git s
    abbr --add kitty "rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock"

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

    alias pad="desktop_padding.sh"

    alias cade="ssh u1337847@lab1-13.eng.utah.edu"
    alias transfer="sftp u1337847@lab1-13.eng.utah.edu"
    alias ssh="TERM=xterm-256color $(which ssh)"
    alias ystop="yabai --stop-service"
    alias ystart="yabai --start-service"

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
    set -U EDITOR nvim

    set -gx __zoxide_zi cdi
    set -gx FZF_DEFAULT_OPTS '
  --color=fg:#bbbac1,bg:#171718,hl:#d6a56f,gutter:#171718
  --color=fg+:#bbbac1,bg+:#333336,hl+:#d6a56f
  --color=info:#55555e,prompt:#559ba3,pointer:#559ba3
  --color=marker:#817faf,spinner:#817faf,header:#817faf
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
end

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

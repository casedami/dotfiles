PATH="$PATH:$HOME/.local/bin/scripts/"
PATH="$PATH:$HOME/Library/Python/3.11/bin"

[ -f "/Users/caseymiller/.ghcup/env" ] && source "/Users/caseymiller/.ghcup/env" # ghcup-env

source /Users/caseymiller/.config/zsh/prompt.zsh
source /Users/caseymiller/.config/zsh/aliases.sh
source /Users/caseymiller/.config/zsh/opt.sh
source /Users/caseymiller/.config/zsh/fg_bg.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


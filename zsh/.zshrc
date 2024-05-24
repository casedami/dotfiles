if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

PATH="$PATH:$HOME/.local/bin/scripts/"
PATH="$PATH:$HOME/Library/Python/3.11/bin"

source /Users/caseymiller/.config/zsh/prompt.zsh
source /Users/caseymiller/.config/zsh/aliases.sh
source /Users/caseymiller/.config/zsh/opt.sh

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
export __zoxide_zi='cdi'
export LANG="en_US.UTF-8"
export TERM="xterm-256color"
export HOMEBREW_NO_ENV_HINTS

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


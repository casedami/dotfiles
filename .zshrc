# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
#
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# load prompt plugin
fpath+=("$(brew --prefix)/share/zsh/site-functions")

# history
HISTSIZE=30
HISTFILE=~/.zsh_history
SAVEHIST=30
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# aliases
alias ystop="yabai --stop-service"
alias ystart="yabai --start-service"
alias ls="exa --icons --group-directories-first"
alias lsl="exa -l -h --no-user --git"
alias tree="exa -T"
alias cade="ssh u1337847@lab1-13.eng.utah.edu"
alias vim="nvim"
alias ssh="TERM=xterm-256color $(which ssh)"
alias python="python3"
alias sed="sed -E"
alias time="/usr/bin/time -p"
alias tm="tmux"
alias cd="z"
alias help="help.sh"

# add directory to PATH
path+=('/Users/caseymiller/Library/Python/3.11/bin')
export PATH

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# set lang variable
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export TERM="xterm-256color"
eval "$(zoxide init zsh)"

PATH="$PATH:$HOME/.local/bin"

export FZF_DEFAULT_OPTS="
--color=fg+:#D699B6,pointer:#D699B6,hl:#D699B6,hl+:#D699B6,gutter:-1,bg+:-1,prompt:#D3C6AA
--reverse
--cycle
--multi
--height 40%
"

# fzf completion
source /opt/homebrew/Cellar/fzf/0.45.0/shell/completion.zsh
source /Users/caseymiller/.local/share/fzftab/zsh/fzf-zsh-completion.sh
bindkey '^I' fzf_completion
zstyle ':completion:*' fzf-search-display true
autoload -U compinit
compinit

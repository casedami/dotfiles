# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# load prompt plugin
fpath+=("$(brew --prefix)/share/zsh/site-functions")

# history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# aliases
alias icd="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents"
alias school="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/school"
alias txtbook="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/school/textbooks"
alias hist="rm .zsh_history .Rhistory .bash_history .python_history"
alias ls="ls -G"
alias ystop="yabai --stop-service"
alias ystart="yabai --start-service"

# change color of directories for <ls> output
export LSCOLORS=Exfxcxdxbxegedabagacad

# add directory to PATH
path+=('/Users/caseymiller/Library/Python/3.11/bin')
export PATH

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


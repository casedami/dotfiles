KEYTIMEOUT=1
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

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export TERM="xterm-256color"
eval "$(zoxide init zsh)"

bindkey -v

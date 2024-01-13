KEYTIMEOUT=1

HISTSIZE=30
HISTFILE=~/.local/.zsh_history
SAVEHIST=30
HISTDUP=erase
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

setopt cd_silent     # don't print dir after cd
setopt extended_glob # extened globbing functionality
setopt vi            # turn on vi-mode

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export TERM="xterm-256color"
eval "$(zoxide init zsh)"

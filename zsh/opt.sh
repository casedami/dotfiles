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
setopt extended_glob # extended globbing functionality

bindkey '^K' up-line-or-search
bindkey '^J' down-line-or-search

export LANG="en_US.UTF-8"
export TERM="xterm-256color"
eval "$(zoxide init zsh)"

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg+:#ecae6d,pointer:#ecae6d,hl:#ecae6d,hl+:#ecae6d,gutter:-1,bg+:-1,prompt:#8da0d6,info:#4f5b58
  --separator="─" --scrollbar="│" --layout="reverse" --info="right"
  --prompt=" "
  --marker=">"
  --pointer="󰘍"
  --cycle
  --multi
  --height 40%
  --preview "cat {} 2> /dev/null"
  --preview-window='right:60%:hidden'
  --bind='?:toggle-preview'
  --bind='ctrl-u:preview-page-up'
  --bind='ctrl-d:preview-page-down'
  '
export FZF_COMPLETION_TRIGGER=';'

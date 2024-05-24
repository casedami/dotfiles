KEYTIMEOUT=1

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

setopt cd_silent     # don't print dir after cd
setopt extended_glob # extended globbing functionality

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#bbbac1,bg:#181b1b,hl:#e69875,gutter:#181b1b
  --color=fg+:#bbbac1,bg+:#313b35,hl+:#e69875
  --color=info:#7a8478,prompt:#78b0a8,pointer:#78b0a8
  --color=marker:#7da77e,spinner:#7da77e,header:#7da77e
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

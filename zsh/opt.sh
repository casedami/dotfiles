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

# format completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls $realpath'
zstyle ':fzf-tab:*' fzf-flags --bind "tab:toggle,btab:ignore,ctrl-space:ignore"

# eval "$(fzf --zsh)"
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
export FZF_ALT_C_COMMAND='^e'

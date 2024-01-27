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
setopt vi            # turn on vi-mode

export LANG="en_US.UTF-8"
export TERM="xterm-256color"
eval "$(zoxide init zsh)"

# plugin opts
exa_colors=(di=32;i ex=31;1 fi=37 ln=35)
export EXA_COLORS=${(j<:>)exa_colors}

export FZF_DEFAULT_OPTS="
--color=fg+:#D699B6,pointer:#D699B6,hl:#D699B6,hl+:#D699B6,gutter:-1,bg+:-1,prompt:#D3C6AA
--reverse
--cycle
--multi
--height 40%
"
export FZF_COMPLETION_TRIGGER=';'

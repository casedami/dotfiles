export FZF_DEFAULT_OPTS="
--color=fg+:#D699B6,pointer:#D699B6,hl:#D699B6,hl+:#D699B6,gutter:-1,bg+:-1,prompt:#D3C6AA
--reverse
--cycle
--multi
--height 40%
"

source /opt/homebrew/Cellar/fzf/0.45.0/shell/completion.zsh
source /Users/caseymiller/.local/share/fzftab/zsh/fzf-zsh-completion.sh
bindkey '^I' fzf_completion
zstyle ':completion:*' fzf-search-display true
autoload -U compinit
compinit

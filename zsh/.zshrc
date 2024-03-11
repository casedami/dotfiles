PATH="$PATH:$HOME/.local/bin/scripts/"
PATH="$PATH:$HOME/Library/Python/3.11/bin"

[ -f "/Users/caseymiller/.ghcup/env" ] && source "/Users/caseymiller/.ghcup/env" # ghcup-env

source /Users/caseymiller/.config/zsh/prompt.zsh
source /Users/caseymiller/.config/zsh/aliases.sh
source /Users/caseymiller/.config/zsh/opt.sh
source /Users/caseymiller/.config/zsh/fg_bg.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

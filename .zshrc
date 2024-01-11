# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# load prompt plugin
fpath+=("$(brew --prefix)/share/zsh/site-functions")

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

PATH="$PATH:$HOME/.local/bin/scripts/"
PATH="$PATH:$HOME/Library/Python/3.11/bin"

[ -f "/Users/caseymiller/.ghcup/env" ] && source "/Users/caseymiller/.ghcup/env" # ghcup-env

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
source /Users/caseymiller/.config/zsh/sources.sh
source /Users/caseymiller/.config/zsh/opt.sh
source /Users/caseymiller/.config/zsh/fg_bg.zsh
source /Users/caseymiller/.config/zsh/fzf.sh

export TERM=xterm-256color

RED='\[\e[31m\]'
PINK='\[\e[91m\]'
GREEN='\[\e[92m\]'
YELLOW='\[\e[33m\]'
BLUE='\[\e[94m\]'
MAGENTA='\[\e[35m\]'
CYAN='\[\e[36m\]'
WHITE='\[\e[37m\]'
RESET='\[\e[0m\]'

git_branch() {
    flamingo git
}

path() {
    flamingo path
}

venv_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "($(basename "$VIRTUAL_ENV"))"
    elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "($CONDA_DEFAULT_ENV)"
    fi
}

PS1="${CYAN}\$(venv_info)${RESET}${MAGENTA}\$(path)${RESET} ${PINK}\$(git_branch)${RESET} \$ "

# Basic aliases for convenience
alias ll='eza -la'
alias la='eza -a'
alias ls='eza'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias vim='nvim'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

bind '"\C-p": "y\n"'
bind '"\C-o": "vim\n"'

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Update window size after each command
shopt -s checkwinsize

kernel=$(uname -s)
# Linux config
if [ "$kernel_name" == "Linux" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
            . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
            . /etc/bash_completion
        fi
    fi
fi

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    echo -e "\033[2 q"  # Block cursor
fi

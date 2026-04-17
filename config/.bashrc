export TERM=xterm-256color

alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

bind '"\C-e": "y\n"'
bind '"\C-o": "nvim\n"'

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
export PATH="$HOME/.local/bin:$PATH"

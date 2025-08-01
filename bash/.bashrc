# Enable color support
export TERM=xterm-256color

RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
YELLOW='\[\033[0;33m\]'
BLUE='\[\033[1;34m\]'
MAGENTA='\[\033[0;35m\]'
CYAN='\[\033[1;36m\]'
WHITE='\[\033[0;37m\]'
RESET='\[\033[0m\]'

git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

venv_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "($(basename "$VIRTUAL_ENV"))"
    elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "($CONDA_DEFAULT_ENV)"
    fi
}

PS1="${CYAN}\$(venv_info)${RESET}${BLUE}\u${RESET}@${GREEN}\W${RESET} ${MAGENTA}\$(git_branch)${RESET}\$ "

# Basic aliases for convenience
alias ll='eza -la'
alias la='eza -a'
alias ls='eza'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

export LS_COLORS="di=32:ln=35:fi=37:ex=37:*.tar=33:*.tgz=33:*.arc=33:*.arj=33:*.taz=33:*.lha=33:*.lz4=33:*.lzh=33:*.lzma=33:*.tlz=33:*.txz=33:*.tzo=33:*.t7z=33:*.zip=33:*.z=33:*.dz=33:*.gz=33:*.lrz=33:*.lz=33:*.lzo=33:*.xz=33:*.zst=33:*.tzst=33:*.bz2=33:*.bz=33:*.tbz=33:*.tbz2=33:*.tz=33:*.deb=33:*.rpm=33:*.jar=33:*.war=33:*.ear=33:*.sar=33:*.rar=33:*.alz=33:*.ace=33:*.zoo=33:*.cpio=33:*.7z=33:*.rz=33:*.cab=33:*.wim=33:*.swm=33:*.dwm=33:*.esd=33:*.jpg=36:*.jpeg=36:*.mjpg=36:*.mjpeg=36:*.gif=36:*.bmp=36:*.pbm=36:*.pgm=36:*.ppm=36:*.tga=36:*.xbm=36:*.xpm=36:*.tif=36:*.tiff=36:*.png=36:*.svg=36:*.svgz=36:*.mng=36:*.pcx=36:*.webp=36:*.ico=36:*.pdf=36:*.ps=36:*.eps=36"

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Update window size after each command
shopt -s checkwinsize

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

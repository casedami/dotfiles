autoload -Uz vcs_info
autoload -Uz promptinit && promptinit
setopt PROMPT_SUBST

# print new line after each entry
precmd() {
  precmd() {
    echo
  }
}

precmd() {
  vcs_info
}

precmd_functions+=( precmd_vcs_info )

# change promptchar depending on current mode
ins="%#"
com=">"
mode=$ins

function zle-keymap-select {
  mode="${${KEYMAP/vicmd/${com}}/(main|viins)/${ins}}"
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  mode=$ins
}
zle -N zle-line-finish

function TRAPINT() {
  mode=$ins
  return $(( 128 + $1 ))
}

# build prompt
dir="%F{blue}%(3~|.../%1~|%~)%f "
git='${vcs_info_msg_0_}'
promptchar='%(?|%F{white}${mode}%f |%F{red}${mode}%f '

PS1=${PS1//$prompt_newline/$'\n'}
ps1=( ${(f)PS1} )
ps1=(
  $dir
  $git
  $promptchar
)
PS1="${(j::)ps1}"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr "*"
zstyle ':vcs_info:*' stagedstr ""
zstyle ':vcs_info:git:*' formats '%F{yellow}%b%u%f %F{cyan}%c%f (%a) '

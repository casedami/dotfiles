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

zstyle ':vcs_info:git*+set-message:*' hooks git-st
function +vi-git-st() {
    local ahead behind
    local -a gitstatus

    # Exit early in case the worktree is on a detached HEAD
    git rev-parse ${hook_com[branch]}@{upstream} >/dev/null 2>&1 || return 0

    local -a ahead_and_behind=(
        $(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null)
    )

    ahead=${ahead_and_behind[1]}
    behind=${ahead_and_behind[2]}

    (( $ahead )) && gitstatus+=( "+${ahead}" )
    (( $behind )) && gitstatus+=( "-${behind}" )

    hook_com[misc]+=${(j:/:)gitstatus}
}

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr "*"
zstyle ':vcs_info:*' stagedstr ""
zstyle ':vcs_info:git:*' formats '%F{yellow}%b%u%f %F{cyan}%c%m%f '

autoload -Uz vcs_info
autoload -Uz add-zsh-hook
precmd_functions+=( precmd_vcs_info )
setopt PROMPT_SUBST

load_vcs () {
  vcs_info
}

# print newline after each command
# newline() {
#   precmd() {
#       echo
#   }
# }

add-zsh-hook precmd load_vcs
# add-zsh-hook precmd newline

# don't print newline before prompt on clear command
# alias clear="precmd() {precmd() {echo }} && clear"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr "*"
zstyle ':vcs_info:*' stagedstr "+"
zstyle ':vcs_info:git:*' formats '%F{12}%b%u%c%f%F{magenta}%m%f '

zstyle ':vcs_info:git*+set-message:*' hooks git-st
function +vi-git-st() {
    local ahead behind
    local -a gitstatus

    # exit early in case the worktree is on a detached HEAD
    git rev-parse ${hook_com[branch]}@{upstream} >/dev/null 2>&1 || return 0

    local -a ahead_and_behind=(
        $(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null)
    )

    ahead=${ahead_and_behind[1]}
    behind=${ahead_and_behind[2]}

    (( $ahead )) && gitstatus+=( " " )
    (( $behind )) && gitstatus+=( " " )

    hook_com[misc]+=${(j::)gitstatus}
}

# build prompt
dir="%F{blue}%(3~|.../%1~|%~)%f "
git='${vcs_info_msg_0_}'
promptchar='%(?|%F{white}>%f |%F{red}>%f '

ps1=(
  $dir
  $git
  $promptchar
)
PS1="${(j::)ps1}"

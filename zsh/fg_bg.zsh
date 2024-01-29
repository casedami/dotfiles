function fg-bg {
  local jobcount=$(jobs | wc -l | xargs)
  # if the jobcount is not 0
  if ! [[ $jobcount =~ 0 ]]; then
    zle push-input
    BUFFER='\fg'
    zle accept-line
  fi
}
zle -N fg-bg
bindkey -M viins '^K' fg-bg

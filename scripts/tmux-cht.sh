#!/usr/bin/env bash

selected=$(cat ~/.config/tmux/.tmux-cht-lang ~/.config/tmux/.tmux-cht-command | fzf)
if [[ -z $selected ]]; then
  exit 0
fi

if grep -qs "$selected" ~/.config/tmux/.tmux-cht-lang; then
  read -p "Enter Query: " query
  query=$(echo $query | tr ' ' '+')
  tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
  read -p "Type (man or tldr): " query
  if [[ $query == "man" ]]; then
    tmux neww zsh -c "man $selected"
  elif [[ $query == "tldr" ]]; then
    tmux neww bash -c "tldr $selected & while [ : ]; do sleep 1; done"
  fi
fi

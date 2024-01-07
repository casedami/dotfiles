#!/usr/bin/env bash

selected=$(cat ~/.config/tmux/.tmux-cht-lang ~/.config/tmux/.tmux-cht-command | fzf)
if [[ -z $selected ]]; then
  exit 0
fi

if grep -qs "^$selected$" ~/.config/tmux/.tmux-cht-lang; then
  read -p "Enter Query: " query
  query=$(echo $query | tr ' ' '+')
  curl cht.sh/$selected/$query/else
else
  read -p "Type (man or tldr): " query
  if [[ $query == "man" ]]; then
    man $selected
  elif [[ $query == "tldr" ]]; then
    tldr $selected
  fi
fi

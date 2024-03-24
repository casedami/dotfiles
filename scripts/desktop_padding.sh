#!/usr/bin/env bash

if [[ $(yabai -m query --displays | jq ".[].id" | grep 2) ]]; then
  desktop_spaces=$(yabai -m query --displays | jq "map(select(.id == 2).spaces)" | sed 's/[^0-9]*//g' | xargs)

  for space in $desktop_spaces; do
    # FIX: popup windows are begin included
    if [[ $(yabai -m query --windows --space $space | jq "length") > 2 ]]; then
      hpad=50
      gap=25
    else
      hpad=200
      gap=50
    fi
    yabai -m config --space $space top_padding 200
    yabai -m config --space $space bottom_padding 200
    yabai -m config --space $space left_padding $hpad
    yabai -m config --space $space right_padding $hpad
    yabai -m config --space $space window_gap $gap
  done
fi

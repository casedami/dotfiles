#!/usr/bin/env bash

desktop_spaces=$(yabai -m query --displays | jq "map(select(.id == 2).spaces)" | sed 's/[^0-9]*//g' | xargs)

for space in $desktop_spaces; do
  yabai -m config --space $space top_padding 200
  yabai -m config --space $space bottom_padding 200
  yabai -m config --space $space left_padding 200
  yabai -m config --space $space right_padding 200
  yabai -m config --space $space window_gap 50
done

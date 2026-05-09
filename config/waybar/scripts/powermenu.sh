#!/usr/bin/env nu

let shutdown = "Shutdown"
let lock = "Lock"
let suspend = "Suspend"

let chosen = [$shutdown $lock $suspend] | to text | rofi -dmenu -p "select..." -theme-str 'configuration { show-icons: false; } mainbox { children: [ inputbar, listview ]; } inputbar { children: [ prompt ]; } listview { lines: 3; }'

match $chosen {
  "Shutdown" => { systemctl poweroff },
  "Lock" => { hyprlock },
  "Suspend" => { systemctl suspend },
}

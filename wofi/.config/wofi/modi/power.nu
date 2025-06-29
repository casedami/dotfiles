#!/home/cdm/.cargo/bin/nu

def main [] {
    let menu = [
        "  lock",
        "  logout",
        "󰒲  suspend",
        "  reboot",
        "  shutdown"
    ]

    let selection = ($menu
    | str join "\n"
    | wofi --dmenu --prompt "" --lines 7 --width 400)

    if ($selection | is-empty) {
        return  # User cancelled
    } else if ($selection | str ends-with "lock") {
        (swaylock -f)
    } else if ($selection | str ends-with "logout") {
        (swaymsg exit)
    } else if ($selection | str ends-with "suspend") {
        (systemctl suspend)
    } else if ($selection | str ends-with "reboot") {
        (systemctl reboot)
    } else if ($selection | str ends-with "shutdown") {
        (systemctl poweroff -i)
    } else {
        # ignore
        return
    }
}

main

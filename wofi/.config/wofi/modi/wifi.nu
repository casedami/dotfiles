#!/home/cdm/.cargo/bin/nu

let icon_curr = "󱚽 "
let icon_lock = "󱚿 "
let icon_inactive = "󱛅 "
let icon_refresh = " "
let icon_more = "󰇘 "
let icon_disconnect = "󰅛 "

def get_active_connection [] {
    let active_conn = (nmcli -t -f NAME,TYPE,DEVICE connection show --active
        | lines
        | where { |line| $line | str contains "wireless" }
        )
    if ($active_conn | is-empty) {
        { active: false }
    } else {
        let parts = (
            $active_conn
            | first
            | split column ":" name type device
            | update name { |row| $row.name | str replace --all --regex '^\[|\]$' '' }
        )
        { active: true, name: $parts.name, device: $parts.device, type: $parts.type }
    }
}

def get_available_networks [] {
    try {
        nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE device wifi list
        | lines
        | each { |line|
            let parts = (
                $line
                | split column ":" ssid signal security in_use
                | update ssid { |row| $row.ssid | str replace --all --regex '^\[|\]$' '' }
                | update signal { |row| $row.signal | str replace --all --regex '^\[|\]$' '' }
            )
            if ($parts.ssid | is-not-empty) and ($parts.ssid != "--") {
                let security_icon = if ($parts.security | is-empty) { "" } else { $"($icon_lock) " }
                let active_icon = if ($parts.in_use == "*") { $"($icon_curr) " } else { "" }
                $"($security_icon)($active_icon)($parts.ssid) (($parts.signal))"
            }
        }
        | compact
        | uniq
    } catch {
        ["Error: Could not scan networks"]
    }
}

def connect_to_network [ssid: string, secured: bool] {
    if $secured {
        let password = (echo "" | wofi --dmenu --prompt $"Password for ($ssid)" --password)
        if ($password | is-empty) {
            print "Connection cancelled"
            return
        }
        try {
            nmcli device wifi connect $ssid password $password
            notify-send "WiFi" $"Connected to ($ssid)" --urgency=normal
        } catch { |e|
            notify-send "WiFi Error" $"Failed to connect to ($ssid)" --urgency=critical
            print $"Error: ($e.msg)"
        }
    } else {
        try {
            nmcli device wifi connect $ssid
            notify-send "WiFi" $"Connected to ($ssid)" --urgency=normal
        } catch { |e|
            notify-send "WiFi Error" $"Failed to connect to ($ssid)" --urgency=critical
            print $"Error: ($e.msg)"
        }
    }
}

def disconnect_current [] {
    let status = (get_active_connection)
    if $status.active {
        try {
            nmcli connection down $status.name
            notify-send "WiFi" $"Disconnected from ($status.name)" --urgency=normal
        } catch { |e|
            notify-send "WiFi Error" $"Failed to disconnect from ($status.name)" --urgency=critical
            print $"Error: ($e.msg)"
        }
    }
}

def reconnect_current [] {
    let status = (get_active_connection)
    if $status.active {
        try {
            nmcli connection down $status.name
            sleep 1sec
            nmcli connection up $status.name
            notify-send "WiFi" $"Reconnected to ($status.name)" --urgency=normal
        } catch { |e|
            notify-send "WiFi Error" $"Failed to reconnect to ($status.name)" --urgency=critical
            print $"Error: ($e.msg)"
        }
    }
}

def refresh_networks [] {
    try {
        nmcli device wifi rescan
        sleep 2sec  # Give time for scan to complete
        notify-send "WiFi" "Network scan completed" --urgency=low
        display_networks_menu
    } catch { |e|
        notify-send "WiFi Error" "Failed to refresh networks" --urgency=critical
        print $"Error: ($e.msg)"
    }
}

def display_networks_menu [] {
    let networks = (get_available_networks)

    let networks_menu = [
            $"($icon_refresh) Refresh",
        ] ++ $networks

    let selection = ($networks_menu
        | str join "\n"
        | wofi --dmenu --prompt "Available Networks" --lines 10 --width 400)

    if ($selection | is-empty) {
        return  # User cancelled
    } else if ($selection | str ends-with "Refresh") {
        refresh_networks
    } else if ($selection | str contains "Error:") {
        # Error message selected, try refresh
        refresh_networks
    } else {
        # Network selected for connection
        let is_secured = ($selection | str contains $"($icon_lock)")
        # Extract SSID from selection (remove signal strength, icons, etc.)
        let ssid = ($selection
            | split row -r '\s+'
            | get 1
            | str replace --regex --all $'[\[\]]' ''
            | str trim
        )

        if ($ssid | is-not-empty) {
            print $"Connecting to: ($ssid)"
            connect_to_network $ssid $is_secured
        }
    }
}

def main [] {
    let status = (get_active_connection)
    if not $status.active {
        display_networks_menu
    } else {
        let current = ($status.name | first)
        let status_menu = [
            $"($icon_curr) ($current)",
            $"($icon_disconnect) Disconnect",
            $"($icon_more) Display networks",
        ]
        let selection = ($status_menu
            | str join "\n"
            | wofi --dmenu --prompt "Wifi Status" --lines 5 --width 400)

        if ($selection | is-empty) {
            return  # User cancelled
        } else if ($selection | str ends-with $"($current)") {
            print $"Reconnecting to ($current)..."
            reconnect_current
        } else if ($selection | str ends-with "Disconnect") {
            disconnect_current
        } else if ($selection | str ends-with "Display networks") {
            display_networks_menu
        } else {
            return
        }
    }
}

def check_dependencies [] {
    let deps = ["nmcli", "wofi", "notify-send"]
    for dep in $deps {
        if (which $dep | is-empty) {
            print $"Error: ($dep) is required but not installed"
            exit 1
        }
    }
}

# check_dependencies
main

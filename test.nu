#!/usr/bin/env nu

def get_active_connection [] {
    let active_conn = (nmcli -t -f NAME,TYPE,DEVICE connection show --active
        | lines
        | where { |line| $line | str contains "wireless" }
        )
    if ($active_conn | is-empty) {
        { active: false }
    } else {
        let parts = ($active_conn | first | split column ":" name type device | update name { |row| $row.name | str replace --all --regex '^\[|\]$' '' })
        { active: true, name: $parts.name, device: $parts.device, type: $parts.type }
    }
}

let status = (get_active_connection)
print $status.name

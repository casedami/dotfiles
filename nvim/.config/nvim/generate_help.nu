#!/usr/bin/env nu

use std repeat

let text_width = 78
let SEARCH_DIR = ($env.HOME | path join ".config/nvim/lua")

let mode = '[^"{]+(?P<mode>"\w"|{[^}]+})' # ex: "n" or { "n", "v" }
let map = '[^"]+"(?P<map>[^"]+)"' # ex: "<leader>a"
let tag_and_desc = '.+desc = "(?P<tag>\S+): (?P<desc>[^"]+)"' # ex: desc = "TAG: desc"
let tag_ignored = "Extend"

def parse-keymaps [files: list] {
    $files | each { |f|
        open $f
        | lines
        | where $it =~ "set.*desc"
        | each { |line|
            let parsed = (
                $line
                | parse --regex $"set\(($mode)($map)($tag_and_desc)\)"
            )
            if ($parsed | is-not-empty) {
                {
                    mode: ($parsed.mode | first | str replace --regex '"|{|}|\s' '' --all),
                    map: ($parsed.map | first),
                    tag: ($parsed.tag | first),
                    desc: ($parsed.desc | first),
                }
            }
        }
        | where tag != null
    }
    | where ($it | is-not-empty)
    | flatten
    | group-by tag
    | reject $tag_ignored
}

def align-lr [left: string, right: string] {
    let remainder = $text_width - ($left | str length)
    let right = (
        $right
        | fill --alignment r --width $remainder
    )
    $"($left)($right)"
}

def format-meta [] {
    let meta = align-lr "*selfhelp.txt*" (date now | format date "%Y-%m-%d")
    $meta + "\n"
}

def format-footer [] {
    $"vim:tw=($text_width):ts=8:noet:ft=help:norl:"
}

def format-header [idx: int, h: string] {
    let left = $"($idx + 1). ($h)"
    let right = $"*selfhelp-($h | str downcase)*"
    let header = align-lr $left $right

    [
        ("=" | repeat $text_width | str join),
        $header,
        "\n",
    ]
    | str join "\n"
}

def format-content [c] {
    $c
    | reject tag
    | table --index false
    | to text
    | ansi strip
}

let formatted = (
    glob $"($SEARCH_DIR)/**/*.lua"
    | parse-keymaps $in
    | transpose group items
    | sort-by group
    | enumerate
    | each { |row|
        let maps = $row.item
        $"(format-header $row.index $maps.group)(format-content $maps.items)"
    }
    | str join "\n"
)

let meta = format-meta
let footer = format-footer

[ $meta, $formatted, $footer ] | str join "\n" | save -f doc/selfhelp.txt
cd doc
nvim -c "helptags ." -c "q"

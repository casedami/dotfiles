#!/usr/bin/env nu

let upstream_url = "https://github.com/vial-kb/vial-qmk.git"

def main [clone_path?: string] {
    let clone_path = if ($clone_path | is-not-empty) {
        $clone_path
    } else if ("VIAL_QMK_PATH" in $env) {
        $env.VIAL_QMK_PATH
    } else {
        $env.HOME | path join "vial-qmk"
    }

    if not ($clone_path | path exists) {
        print $"Cloning (ansi blue)($upstream_url)(ansi reset) into (ansi yellow)($clone_path)(ansi reset)..."
        git clone $upstream_url $clone_path
    }

    let script_dir = $env.CURRENT_FILE | path dirname
    let vial_source = $script_dir | path join "vial"
    let keymap_dir = $clone_path | path join "keyboards" "crkbd" "keymaps" "vial"

    if ($keymap_dir | path exists) {
        rm -rf $keymap_dir
    }

    ln -sf $vial_source $keymap_dir

    with-env { QMK_HOME: $clone_path } {
        qmk compile -kb crkbd/rev4_1/standard -km vial
    }
}

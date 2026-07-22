#!/usr/bin/env nu

# Regenerates keymap.svg from crkbd.vil: the live layout exported from the
# Vial app. crkbd.vil is the source of truth; vial/keymap.c is only used to
# build firmware and may lag behind it.
def main [clone_path?: string] {
    let clone_path = if ($clone_path | is-not-empty) {
        $clone_path
    } else if ("VIAL_QMK_PATH" in $env) {
        $env.VIAL_QMK_PATH
    } else {
        $env.HOME | path join "vial-qmk"
    }

    if not ($clone_path | path exists) {
        print $"Cloning (ansi blue)https://github.com/vial-kb/vial-qmk.git(ansi reset) into (ansi yellow)($clone_path)(ansi reset)..."
        git clone https://github.com/vial-kb/vial-qmk.git $clone_path
    }

    let script_dir = $env.CURRENT_FILE | path dirname
    let vial_source = $script_dir | path join "vial"
    let keymap_dir = $clone_path | path join "keyboards" "crkbd" "keymaps" "vial"

    if not ($keymap_dir | path exists) {
        ln -sf $vial_source $keymap_dir
    }

    let info_json = $clone_path | path join "keyboards" "crkbd" "rev4_1" "info.json"
    let vil_path = $script_dir | path join "crkbd.vil"
    let scripts_dir = $script_dir | path join "scripts"
    let layout_name = "LAYOUT_split_3x6_3_ex2"
    let tmp = (mktemp -d)

    uv run python3 ($scripts_dir | path join "vil2json.py") $vil_path $info_json $layout_name ($tmp | path join "keymap.json")

    uvx --from keymap-drawer keymap parse -q ($tmp | path join "keymap.json") -l Base Num Sym Nav Media -o ($tmp | path join "keymap.yaml")

    let out_svg = $script_dir | path join "keymap.svg"
    uv run --with pyyaml python3 ($scripts_dir | path join "render_keymap.py") ($tmp | path join "keymap.yaml") $info_json $layout_name $out_svg $vil_path

    rm -rf $tmp
    print $"Wrote ($out_svg)"
}

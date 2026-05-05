#!/usr/bin/env nu
def create-symlinks [src_type: string, dest: string] {
    let to_link = ls (pwd | path join "config") -af | where type == $src_type

    cd $dest

    $to_link
    | each {|target| rm ($target.name | path basename); ln -s $target.name ./}
    | ignore
}

def main [] {
    create-symlinks dir ($env.XDG_CONFIG_HOME? | default ($env.HOME | path join .config))
    create-symlinks file $env.HOME
}

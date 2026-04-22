#!/usr/bin/env nu
def create-symlinks [src_type: string, dest: string] {
    ls (pwd | path join "config") -af
    | where type == $src_type
    | each {|target| ln -s $target.name $"($dest)/($target.name | path basename)"}
    | ignore
}

def main [] {
    create-symlinks dir ($env.XDG_CONFIG_HOME? | default ($env.HOME | path join .config))
    create-symlinks file $env.HOME
}

#!/usr/bin/env nu
def ln-dirs [from, to] {
    ls
    | where type == "dir"
    | each { ln -s $"($from)/($in.name) ($to)/($in.name)"}
}

def ln-files [from, to] {
    ls -a .*
    | where type == "file"
    | where name !~ "git"
    | each { ln -s $"($from)/($in.name) ($to)/($in.name)"}
}

def main [] {
    let cwd = pwd
    ln-dirs $cwd $env.XDG_CONFIG_HOME
    ln-files $cwd $env.HOME
}

alias cat = bat
alias nix-clean = sudo nix-collect-garbage -d

# rebuid nix-os
def nix-build [] {
    cd ~/dotfiles/nix
    sudo nixos-rebuild switch --flake .
}

# update nix packages
def nix-up [] {
    cd ~/dotfiles/nix
    sudo nix flake update
}

# setup flake for python development
def --env pyinit [] {
    cp ~/dev/flake.nix .
}

# use yazi to cd
def --env Fexplore [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -fp $tmp
}

# cd to a subdirectory using fzf
def --env cdc [] {
    let dir = (
    ls **/**
    | where type == dir
    | get name
    | str join (char nl)
    | fzf --no-multi
  )
    cd $dir
}

# cd to the git project root
def --env cdr [] {
    try {
        let root = git rev-parse --show-toplevel | str trim
        cd $root
    } catch {
        print "Unable to locate project root"
    }
}

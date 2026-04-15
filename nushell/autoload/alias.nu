alias cat = bat

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

def --env cdr [] {
    try {
        let root = git rev-parse --show-toplevel | str trim
        cd $root
    } catch {
        print "Unable to locate project root"
    }
}

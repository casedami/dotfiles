def _str-color [c, s: string] {
    match ($c | describe) {
        string => $"(ansi ($c))($s)(ansi reset)"
        "list<string>" => {
            $s
            | split chars
            | enumerate
            | each { |item|
                let idx = $item.index mod ($c | length)
                let color = $c | get $idx
                $"(ansi $color)($item.item)(ansi reset)"
            }
            | str join ""
        }
        _ => $s
    }
}

def --env git-checkout-fzf [] {
    let branch = (
        git branch -a
        | lines
        | str trim
        | where ($it !~ '\*')
        | where ($it != '')
        | str join (char nl)
        | fzf --no-multi
    )
    if ($branch | is-not-empty) {
        git checkout ($branch | str replace "remotes/origin/" "")
    }
}

def --env git-log-tbl [n: int = 10, --all(-a)] {
    mut flags = ""
    if $all {
        $flags = "-a"
    } else {
        $flags = $"-n ($n)"
    }

    git log --pretty=%h»¦«%s»¦«%an»¦«%aD $flags
    | lines
    | split column "»¦«" commit subject name date
    | upsert date {|d| $d.date | into datetime}
    | sort-by date
    | reverse
    | update subject { |row|
        let parsed = (
            $row.subject
            | parse --regex '^(?:(?P<tag>\w+)?(?:\((?P<scope>[^)]+)\))?: )?(?P<subject>.+)$'
            | first
        )
        let tag = $parsed.tag | default '' | str trim
        let subject = $parsed.subject | default '' | str trim
        let scope = (
            if ($parsed.scope | is-not-empty) {
                $"\(($parsed.scope)\)"
            } else { "" }
        )
        let sep = (
            if ($tag | is-not-empty) or ($scope | is-not-empty) { ": " }
            else { "" }
        )
        $"(ansi light_red)($tag)(ansi light_cyan)($scope)(ansi reset)($sep)(ansi yellow)($subject)"
    }
    | update commit { |row|
        $"(ansi light_magenta) ($row.commit)"
    }
    | update name { |row|
        $"(ansi cyan) ($row.name)"
    }
}

def --env git-status-tbl [] {
    let status = (git status -s)
    let branch = (
        $status
        | lines
        | first
        | parse --regex '^## (?P<local>[^\.]+)(?:\.{3}(?P<remote>[^\.]+))?'
        | first
    )
    let local = (
        if ($branch.local | is-not-empty) {
            $" 󰘬 ($branch.local)"
        } else { "" }
    )
    let remote = (
        if ($branch.remote | is-not-empty) {
            $" 󱘾 ($branch.remote)"
        } else { "" }
    )
    let sep = (
        if ($local | is-not-empty) and ($remote | is-not-empty) { "\n" }
        else { "" }
    )

    print $"(ansi light_yellow)($local)(ansi reset)($sep)(ansi yellow)($remote)(ansi reset)"

    $status
    | lines
    | skip 1
    | parse --regex '(?P<status>\s*[A-Z?]{1,2})\s+(?P<file>.+)$'
    | update status { |row|
        match $row.status {
            "A" => (_str-color "green" ($row.status | str trim)),
            " D" => (_str-color "red" ($row.status | str trim)),
            "M" => (_str-color "green" ($row.status | str trim)),
            " M" => (_str-color "light_blue" ($row.status | str trim)),
            "MM" => (_str-color ["green", "red"] ($row.status | str trim)),
            "MD" => (_str-color ["green", "red"] ($row.status | str trim)),
            "??" => (_str-color "light_yellow" ($row.status | str trim)),
            _ => (_str-color "white" ($row.status | str trim))
        }
    }
}

def --env git-add-fzf [] {
    let files = (
        git status -s
        | lines
        | skip 1
        | parse --regex '^\s*(?P<status>\S+)\s+(?P<file>.+)$'
        | each {|it| $"($it.status)\t($it.file)"}
        | to text
    )
    let selection = $files | fzf --multi

    if ($selection | is-not-empty) {
        let selected = (
            $selection
            | lines
            | parse "{status}\t{file}"
            | get file
        )
        $selected | each {|file| git add $file}
        print $"Staged ($selected | length) files for commit"
    }
}

def git-conflicts [] {
    let tmpfile = (mktemp -t git-conflicts.XXXXXX.qf)
    ^git ls-files -u
    | lines
    | parse "{mode} {hash} {stage}\t{file}"
    | get file
    | uniq
    | each { |file|
            open $file
                | lines
                | enumerate
                | where {|it| $it.item | str contains '<<<<<<<' }
                | each { |it|
                    $"($file):($it.index + 1):1:conflict"
                }
        }
    | flatten
    | str join "\n"
    | save -f $tmpfile

    if ((open $tmpfile | str trim) | is-empty) {
        print "No conflicts"
    } else {
        nvim -q $tmpfile
    }
}

let abbrevs = {
    ga: 'git add'
    gac: 'git-add-fzf'
    gb: 'git branch'
    gc: 'git commit -v'
    gd: 'git diff'
    gdt: 'git difftool -d'
    gl: 'git-log-tbl'
    gm: 'git merge'
    gq: 'git-conflicts'
    gr: 'git rebase'
    gR: 'git restore'
    gs: 'git-status-tbl'
    gS: 'git show'
    gwa: 'git worktree add'
    gwr: 'git worktree remove'
    gwl: 'git worktree list'
    gx: 'git switch'
    gxc: 'git-checkout-fzf'
}

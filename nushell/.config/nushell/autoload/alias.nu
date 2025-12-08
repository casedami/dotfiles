
alias cat = bat
alias la = ls -a
alias ll = ls -l
alias vim = nvim
alias fg = job unfreeze
alias dad = dirs add ~/dotfiles

# use yazi to cd
def --env P [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

def str-color [c, s: string] {
    match ($c | describe) {
        "string" => $"(ansi ($c))($s)(ansi reset)",
        "list<string>" => {
            $s
            | split chars
            | enumerate
            | each { |item|
                let idx = ($item.index mod ($c | length))
                let color = ($c | get $idx)
                $"(ansi $color)($item.item)(ansi reset)"
            }
            | str join ""
        }
        _ => $s
    }
}

# MARK: git functions

# git checkout with fzf
def --env gxc [] {
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

# git merge with fzf
def --env gmc [] {
    let branch = (
        git branch
        | lines
        | str trim
        | where ($it !~ '\*')
        | where ($it != '')
        | str join (char nl)
        | fzf --no-multi
    )
    if ($branch | is-not-empty) {
        git merge $branch
    }
}

# git branch delete with fzf
def --env gdc [] {
    let branches = (
        git branch
        | lines
        | str trim
        | where ($it !~ '\*')
        | where ($it != '')
        | str join (char nl)
        | fzf --multi
        | lines
        | where ($it != '')
    )
    if ($branches | is-not-empty) {
        $branches | each { |b| git branch -d $b }
    }
}

# pretty git log
def --env gl [n: int = 10, --all(-a)] {
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

# pretty git status
def --env gs [] {
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

    print $"(ansi light_red)($local)(ansi reset)($sep)(ansi red)($remote)(ansi reset)"

    $status
    | lines
    | skip 1
    | parse --regex '(?P<status>\s*[A-Z?]{1,2})\s+(?P<file>.+)$'
    | update status { |row|
        match $row.status {
            "A" => (str-color "green" ($row.status | str trim)),
            " D" => (str-color "red" ($row.status | str trim)),
            "M" => (str-color "green" ($row.status | str trim)),
            " M" => (str-color "light_blue" ($row.status | str trim)),
            "MM" => (str-color ["green", "red"] ($row.status | str trim)),
            "MD" => (str-color ["green", "red"] ($row.status | str trim)),
            "??" => (str-color "light_yellow" ($row.status | str trim)),
            _ => (str-color "white" ($row.status | str trim))
        }
    }
}

# git add chooe with fzf
def --env gac [] {
    let files = (
        git status -s
        | lines
        | skip 1
        | parse --regex '^\s*(?P<status>\S+)\s+(?P<file>.+)$'
        | each {|it| $"($it.status)\t($it.file)"}
        | to text
    )
    let selection = ($files | fzf --multi)

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
                | where { |it| $it.item | str contains '<<<<<<<' }
                | each { |it|
                    $"($file):($it.index + 1):1:conflict"
                }
        }
        | flatten
        | str join "\n"
        | save -f $tmpfile
    $tmpfile
}
alias gq = nvim -q (git-conflicts)


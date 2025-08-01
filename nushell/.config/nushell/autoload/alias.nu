
alias cat = bat
alias la = ls -a
alias ll = ls -l
alias vim = nvim
alias fg = job unfreeze

# MARK: git
alias ga = git add
alias gb = git branch
alias gc = git commit
alias gd = git branch -d
alias gm = git merge
alias gp = git pull
alias gP = git push
alias gr = git rebase
alias gx = git checkout

def --env gxc [] {
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
        git checkout $branch
    }
}

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

def --env gl [n: int = 10] {
    git log --pretty=%h»¦«%s»¦«%an»¦«%aD -n $n
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
    | parse --regex '^\s*(?P<status>\S+)\s+(?P<file>.+)$'
    | update status { |row|
        match $row.status {
            "A" => $"(ansi green)($row.status)(ansi reset)",
            "D" => $"(ansi red)($row.status)(ansi reset)",
            "M" => $"(ansi light_blue)($row.status)(ansi reset)",
            "MD" => $"(ansi purple)($row.status)(ansi reset)",
            "??" => $"(ansi light_yellow)($row.status)(ansi reset)",
            _ => $"(ansi white)($row.status)(ansi reset)"
        }
    }
}

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

# MARK: dir stack
alias dlist = dirs
alias dadd = dirs add
alias ddel = dirs drop

def --env dto [idx: int] {
    dirs goto $idx
}

def --env dclear [] {
    let cwd = (dirs | where active == true | get path)
    while (dirs | get path | uniq | length) > 1 {
        if (pwd) not-in $cwd {
            dirs drop
        } else {
            dirs next
        }
    }
    # remove duplicates of cwd
    while (dirs | length) > 1 {
        dirs drop
    }
}

# MARK: misc

def --env P [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

def --env ":q" [] {
    dclear
    cd
}

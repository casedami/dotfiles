source ../themes/hojicha.nu

def _overlay_info [] {
    let current_overlays = (
        overlay list
        | where name != zero
        | where active == true
        | get name
    )
    if ($current_overlays | length) > 0 {
        let overlays = $current_overlays | str join ", "
        $"(ansi $theme.operator)\((ansi $theme.property)($overlays)(ansi $theme.operator)\)(ansi reset) "
    } else {
        ""
    }
}

def _jobs [] {
    let job_count = job list | length
    if ($job_count | into int) > 0 {
        $"(ansi bi)(ansi $theme.func)%($job_count)(ansi reset) "
    } else {
        ""
    }
}

def _path [] {
    let cwd = if ($env.PWD | str starts-with $env.HOME) {
        $env.PWD | str replace $env.HOME "~"
    } else {
        $env.PWD
    }
    let parts = $cwd | path split
    let truncated = if ($parts | length) > 1 {
        let head = $parts | drop | each {|part| $part | str substring 0..0 }
        let tail = $parts | last
        ($head | append $tail | str join "/")
    } else {
        $parts | first
    }
    $"(ansi $theme.func)($truncated)(ansi reset)"
}

def _git [] {
    let git_status = do { git status --porcelain=v1 } | complete
    if $git_status.exit_code == 0 {
        let branch = (
            do { git branch --show-current 2>/dev/null }
            | complete
            | get stdout
            | str trim
        )
        if ($branch | is-not-empty) {
            let status_lines = $git_status.stdout | lines
            let unstaged = $status_lines | where {|line| ($line | str substring 1..1) =~ "[MD]"} | length
            let staged = $status_lines | where {|line| ($line | str substring 0..0) =~ "[MADRC]"} | length
            let untracked = $status_lines | where {|line| ($line | str starts-with "??")} | length

            let ahead_behind = do { git rev-list --count --left-right @{upstream}...HEAD } | complete
            mut indicators = ""
            let color_ahead_behind = $"(ansi $theme.number)"
            if $ahead_behind.exit_code == 0 {
                let counts = $ahead_behind.stdout | str trim | split row "\t"
                if ($counts | length) == 2 {
                    let behind = $counts.0 | into int
                    let ahead = $counts.1 | into int
                    if $behind > 0 { $indicators += $" ($color_ahead_behind)↓($behind)" }
                    if $ahead > 0 { $indicators += $" ($color_ahead_behind)↑($ahead)" }
                }
            }

            let color_status = $"(ansi $theme.string)"
            if $unstaged > 0 { $indicators += $" ($color_status)*" }
            if $staged > 0 { $indicators += $" ($color_status)+" }
            if $untracked > 0 { $indicators += $" ($color_status)?" }

            if ($indicators | is-not-empty) {
                $indicators = $indicators | str replace --all " " $"(ansi $theme.operator):"
            }

            $" (ansi i)(ansi $theme.alt)($branch)($indicators)(ansi reset)"
        } else {
            ""
        }
    } else {
        ""
    }
}

def _left_prompt [] {
    $" (_jobs)(_overlay_info)(_path)(_git)"
}

def _right_prompt [] {
    let time_segment = date now | format date '%H:%M'
    $"(ansi $theme.string)($time_segment)(ansi reset)"
}

def _prompt_indicator [sym] {
    let indicator_color = if $env.LAST_EXIT_CODE != 0 {
        (ansi b)(ansi $theme.diag_red)
    } else {
        (ansi $theme.operator)
    }

    $"($indicator_color)($sym)(ansi reset) "
}

$env.PROMPT_COMMAND = {|| _left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| _right_prompt }
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| _prompt_indicator ">" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| _prompt_indicator ":" }
$env.PROMPT_MULTILINE_INDICATOR = {|| $"(ansi $theme.operator):::(ansi reset) " }
$env.TRANSIENT_PROMPT_COMMAND = ""

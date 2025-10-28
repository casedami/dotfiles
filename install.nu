#!/usr/bin/env nu

let cargo_tools = {
    source: "crates.io"
    install: { |tool| cargo install $tool.cmd }
    fmt: { |tool| $tool.name }
    actual: [
        { name: "eza" cmd: "eza" },
        { name: "just" cmd: "just" },
        { name: "ripgrep" cmd: "ripgrep" },
        { name: "stylua" cdm: "stylua" },
        { name: "tree-sitter" cmd: "tree-sitter-cli" },
        { name: "bat" cmd: "--locked bat" },
        { name: "yazi" cmd: "--locked yazi-fm yazi-cli" },
        { name: "zoxide" cmd: "--locked zoxide" },
        { name: "bottom" cmd: "--locked bottom" },
        { name: "typst" cmd: "--locked typst-cli" },
    ]
}

let pacman_tools = {
    source: "apt" # change as needed
    install: { |tool| run-external sudo [apt install -y] $tool.cmd}
    fmt: { |tool| $tool.name }
    actual: [
        { name: "curl" cmd: "curl" },
        { name: "git" cmd: "git" },
        { name: "fzf" cmd: "fzf" },
        { name: "tmux" cmd: "tmux" },
        { name: "waybar" cmd: "waybar" },
        { name: "wofi" cmd: "wofi" },
        { name: "zathura" cmd: "zathura" },
    ]
}

let misc_tools = {
    source: "a remote script"
    install: { |tool| curl -LsSf $tool.cmd }
    fmt: { |tool| $tool.name }
    actual: [
        { name: "uv" cmd: "https://astral.sh/uv/install.sh" },
        { name: "ruff" cmd: "https://astral.sh/ruff/install.sh" },
    ]
}

let github_tools = {
    source: "github releases"
    fmt: { |tool| $tool.name }
    install: { |tool|
        let url = $"https://github.com/($tool.repo)/releases/latest/download/($tool.appimage)"
        run-external wget [-O /tmp/($tool.appimage) $url]
        run-external chmod [+x /tmp/($tool.appimage)]
        run-external mkdir [-p ~/.local/bin]
        run-external sudo [mv /tmp/($nvim.appimage) /.local/bin/($tool.cmd)]
    }
    actual: [
        { name: "neovim" cmd: "nvim" repo: "neovim/nvim" appimage: "nvim.appimage" }
        {
            name: "wezterm"
            cmd: "wezterm"
            repo: "wezterm/wezterm"
            appimage: "20240203-110809-5046fc22/WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage"
        }
    ]
}

def info [text: string] {
    $"(ansi b)(ansi u)(ansi light_magenta)($text)(ansi reset)"
}

def help [text: string] {
    $"(ansi i)(ansi magenta)($text)(ansi reset)"
}

def err [text: string] {
    $"(ansi b)(ansi u)(ansi red)($text)(ansi reset)"
}

def hi [text: string] {
    $"(ansi i)(ansi u)(ansi light_cyan)($text)(ansi reset)"
}

def dialogue [msg: string help: string] {
    print $msg
    let inp = (
        input $"(help ($help)): "
        | str downcase
    )
    $inp
}

def select_and_do [items: list, action: closure] {
    let help = "[<comma separated indices>/a/all/s/skip/c/cancel]"
    loop {
        let inp = dialogue "" $help
        if $inp == ["a", "all"] {
            print "Selected all..."
            $items | each $action
            break
        } else if $inp in ["skip", "s"] {
            print "\n"
            return
        } else if $inp in ["c", "cancel"] {
            print (err "Aborting...")
            exit 0
        } else {
            let idxs = ($inp | split row ',' | each {|char| $char | into int})
            let max_idx = ($items | length) - 1

            let valid_idxs = ($idxs | where $it <= $max_idx and $it >= 0)
            if ($valid_idxs | length) != ($idxs | length) {
                print $"Invalid indices. Please use numbers 0-($max_idx) separated by a comma."
                continue
            }

            let selected = ($valid_idxs | each {|idx| $items | get $idx})
            print $"Selected: ($selected | each {$in.name} | str join ', ')"
            $selected | each $action
            break
        }
    }
}

def install [tools] {
    print $"Select the following programs to install from (hi $tools.source):"
    print ($tools.actual | each $tools.fmt)
    select_and_do $tools.actual $tools.install
}

def stow_tools [] {
    print $"Select the following configurations to stow:"
    let cfgs = (ls | where type == dir | select name)
    print $cfgs
    let action = {|cfg| stow $cfg.name}
    select_and_do $cfgs $action
}

def main [] {
    let help = "[y/yes/n/no]"

    let inp = (dialogue "Install tools?" $help)
    if $inp in ["y", "yes"] {
        install $cargo_tools
        install $pacman_tools
        install $misc_tools
        install $github_tools
    }

    let inp = (dialogue "Stow tools?" $help)
    if $inp in ["y", "yes"] {
        stow_tools
    }
}


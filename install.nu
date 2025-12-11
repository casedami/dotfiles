#!/usr/bin/env nu

let cargo_tools = {
    source: "crates.io"
    install: { |tool|
        cargo install $tool.cmd | complete | ignore
        print $"(ansi green)✓(ansi reset) Installed ($tool.name)"
    }
    fmt: { |tool| $tool.name }
    actual: [
        { name: "eza" cmd: "eza" },
        { name: "just" cmd: "just" },
        { name: "ripgrep" cmd: "ripgrep" },
        { name: "stylua" cmd: "stylua" },
        { name: "tree-sitter" cmd: "tree-sitter-cli" },
        { name: "bat" cmd: "bat" },
        { name: "yazi" cmd: "--locked yazi-fm yazi-cli" },
        { name: "zoxide" cmd: "--locked zoxide" },
        { name: "bottom" cmd: "--locked bottom" },
        { name: "typst" cmd: "--locked typst-cli" },
    ]
}

let pacman_tools = {
    source: "homebrew"
    install: { |tool|
        brew install $tool.name | complete | ignore
        print $"(ansi green)✓(ansi reset) Installed ($tool.name)"
    }
    fmt: { |tool| $tool.name }
    actual: [
        { name: "fzf" },
        { name: "neovim" },
        { name: "waybar" },
        { name:  "wofi" },
        { name: "zathura" },
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
    let help = "[<comma separated indices>/a/all/s/skip/q/quit]"
    let inp = dialogue "" $help
    loop {
        if $inp in ["a", "all"] {
            print "Selected all..."
            $items | each $action
            break
        } else if $inp in ["skip", "s"] {
            print "\n"
            return
        } else if $inp in ["q", "quit"] {
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
    let cwd = pwd
    mkdir ~/.config
    let action = {|cfg| ln -s $"($cwd)/($cfg.name)" $"($env.HOME)/.config/($cfg.name)"}
    select_and_do $cfgs $action
}

def main [] {
    let help = "[y/yes/n/no/q/quit]"

    let inp = (dialogue "Install rust toolchain?" $help)
    if $inp in ["y", "yes"] {
        curl curl https://sh.rustup.rs -sSf | bash | complete | ignore
        $env.path ++= [ "~/.cargo/bin" ]
        install $cargo_tools
    } else if $inp in ["q", "quit"] {
        exit 0
    }

    let inp = (dialogue "Install homebrew?" $help)
    if $inp in ["y", "yes"] {
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash | complete | ignore
        if $nu.os-info.name == "linux" {
            $env.path ++= [
                "/home/linuxbrew/.linuxbrew/bin",
            ]
        } else {
            $env.path ++= [
                "/opt/homebrew/bin"
            ]
        }
        install $pacman_tools
    } else if $inp in ["q", "quit"] {
        exit 0
    }

    let inp = (dialogue "Stow tools?" $help)
    if $inp in ["y", "yes"] {
        stow_tools
    }
    nu
}


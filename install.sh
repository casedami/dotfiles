#!/usr/bin/env bash

# install homebrew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sh

set -euo pipefail

info() {
    echo "[INFO] $1"
}

success() {
    echo "[SUCCESS]"
}

warn() {
    echo "[WARN] $1"
}

error() {
    echo "[ERROR] $1"
}

ask() {
    echo "$1"
    read -r response
    echo "$response"
}

install_rust_tools() {
    info "installing rust and cargo tools..."

    if ! command_exists cargo; then
        info "installing rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

        # Add cargo to PATH
        export PATH="$HOME/.cargo/bin:$PATH"
        source "$HOME/.cargo/env"
    fi

    local tools=(
        "eza"
        "just"
        "ripgrep"
        "stylua"
        "tree-sitter-cli"
        "bat"
        "macchina"
        "--locked yazi-fm yazi-cli"
        "--locked zoxide"
        "--locked bottom"
        "--locked typst-cli"
    )

    for tool in "${tools[@]}"; do
        info "installing: $tool"
        cargo install $tool
    done

    success
}

install_python_tools() {
    info "installing python tools..."

    if ! command_exists uv; then
        info "installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi

    if ! command_exists ruff; then
        info "installing ruff..."
        curl -LsSf https://astral.sh/ruff/install.sh | sh
    fi

    success
}

install_homebrew_tools() {
    if ! command_exists brew; then
        info "installing homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add to PATH for current session
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            export PATH="/opt/homebrew/bin:$PATH"
        else
            # Linux
            export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
        fi

        success
    else
        info "homebrew already installed"
    fi

    local tools=(
        "fzf"
        "--cask neovim"
        "--cask ghostty"
        "--cask font-lilex-nerd-font"
    )

    for tool in "${tools[@]}"; do
        info "installing: $tool"
        brew install $tool
    done

    success
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

symlink_configs() {
    info "symlinking dotfile configurations..."

    mkdir -p "$HOME/.config"

    # Symlink all directories to ~/.config/
    for dir in */; do
        dir=${dir%/}  # Remove trailing slash

        # Skip git directory and any hidden directories
        if [[ "$dir" == ".git" || "$dir" == .* ]]; then
            continue
        fi

        if [[ -d "$dir" ]]; then
            info "Symlinking $dir configuration to ~/.config/"
            ln -sf "$(pwd)/$dir" "$HOME/.config/"
        fi
    done

    # Symlink all dotfiles (files starting with .) to home directory
    for dotfile in .*; do
        # Skip current directory, parent directory, .git directory, and .gitignore
        if [[ "$dotfile" == "." || "$dotfile" == ".." || "$dotfile" == ".git" || "$dotfile" == ".gitignore"  || "$dotfile" == "README.md"]]; then
            continue
        fi

        if [[ -f "$dotfile" ]]; then
            info "Symlinking $dotfile to home directory"
            ln -sf "$(pwd)/$dotfile" "$HOME/$dotfile"
        fi
    done

    success
}

main() {
    info "starting dotfiles installation..."

    install_homebrew_tools
    install_rust_tools
    install_python_tools
    symlink_configs

    echo "DONE"
}

main "$@"

#!/bin/bash

# change as needed
PACMAN_INSTALL="sudo apt install -y"

sudo $PACMAN_INSTALL curl
echo "Installing rust toolchain..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

sudo $PACMAN_INSTALL stow
cargo install nu --locked
install.nu

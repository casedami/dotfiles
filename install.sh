#!/bin/bash

DIM='\033[2m'
RED='\033[0;31m'
MAGENTA='\033[1;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

CHECK_MARK="✓"
CROSS_MARK="✗"
ARROW="→"
BULLET="•"

# Auto-detect package manager
detect_package_manager() {
  if command -v apt &>/dev/null; then
    PACKAGE_MANAGER="sudo apt install -y"
  elif command -v pacman &>/dev/null; then
    PACKAGE_MANAGER="sudo pacman -S --noconfirm"
  elif command -v dnf &>/dev/null; then
    PACKAGE_MANAGER="sudo dnf install -y"
  else
    echo "No supported package manager found!"
    exit 1
  fi

  echo -e "${DIM}Detected package manager: $PACKAGE_MANAGER${NC}"
}

AVAILABLE_PACKAGES=(
  "fish"
  "swaync"
  "hypridle"
  "hyprlock"
  "hyprland"
  "neovim"
  "stow"
  "tmux"
  "tpl"
  "waybar"
  "wezterm"
  "wofi"
  "yazi"
)

# MARK: package selection
select_packages() {
  echo -e "${CYAN}Select packages to install (space-separated numbers, or 'all' for everything):${NC}"
  for i in "${!AVAILABLE_PACKAGES[@]}"; do
    echo -e "${MAGENTA}$((i + 1)).${NC} ${YELLOW}${AVAILABLE_PACKAGES[i]}${NC}"
  done
  echo

  read -p "Enter your choices: " choices

  SELECTED_PACKAGES=()

  if [[ "$choices" == "all" ]]; then
    SELECTED_PACKAGES=("${AVAILABLE_PACKAGES[@]}")
  else
    for choice in $choices; do
      if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#AVAILABLE_PACKAGES[@]}" ]; then
        SELECTED_PACKAGES+=("${AVAILABLE_PACKAGES[$((choice - 1))]}")
      fi
    done
  fi
}

# MARK: package installation
install_packages() {
  if [ ${#SELECTED_PACKAGES[@]} -eq 0 ]; then
    echo -e "${RED}${CROSS_MARK} No packages selected. Exiting.${NC}"
    return 1
  fi

  echo -e "${BLUE}${BOLD}${ARROW} Installing selected packages...${NC}"
  echo -e "${CYAN}${BULLET} Selected packages: ${YELLOW}${SELECTED_PACKAGES[*]}${NC}"
  echo -e "${DIM}${DIM}Using package manager: $PACKAGE_MANAGER${NC}"
  echo

  local success_count=0
  local total_count=${#SELECTED_PACKAGES[@]}

  for package in "${SELECTED_PACKAGES[@]}"; do
    echo -e "${YELLOW}${ARROW} Installing ${BOLD}$package${NC}${YELLOW}...${NC}"
    if $PACKAGE_MANAGER "$package" &>/dev/null; then
      echo -e "${GREEN}${CHECK_MARK} ${BOLD}$package${NC}${GREEN} installed successfully${NC}"
      ((success_count++))
    else
      echo -e "${RED}${CROSS_MARK} ${BOLD}$package${NC}${RED} installation failed${NC}"
      echo -e "${DIM}${DIM}  └─ Check package name or repository availability${NC}"
    fi
    echo
  done

  echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
  if [ $success_count -eq $total_count ]; then
    echo -e "${MAGENTA}║${GREEN}${BOLD}  Installation Complete! ${CHECK_MARK}           ${NC}${MAGENTA}║${NC}"
  else
    echo -e "${MAGENTA}║${YELLOW}${BOLD}  Installation Finished             ${NC}${MAGENTA}║${NC}"
  fi
  echo -e "${MAGENTA}║${WHITE}  Success: ${GREEN}$success_count${WHITE}/${total_count} packages installed    ${NC}${MAGENTA}║${NC}"
  if [ $success_count -lt $total_count ]; then
    echo -e "${MAGENTA}║${RED}  Failed:  $((total_count - success_count)) packages               ${NC}${MAGENTA}║${NC}"
  fi
  echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
}

# MARK: stow
get_stow_directories() {
  local current_dir=$(pwd)
  STOW_DIRECTORIES=()

  while IFS= read -r -d '' dir; do
    local dirname=$(basename "$dir")
    # Skip hidden directories, current directory, and common non-config directories
    if [[ ! "$dirname" =~ ^\. ]] && [[ "$dirname" != "." ]] && [[ "$dirname" != ".git" ]]; then
      STOW_DIRECTORIES+=("$dirname")
    fi
  done < <(find "$current_dir" -maxdepth 1 -type d -print0)
}

# MARK: stow selection
select_stow_directories() {
  get_stow_directories

  if [ ${#STOW_DIRECTORIES[@]} -eq 0 ]; then
    echo -e "${YELLOW}${BULLET} No directories found for stowing.${NC}"
    return 1
  fi

  echo -e "${CYAN}Select configuration directories to stow (space-separated numbers, or 'all' for everything):${NC}"
  for i in "${!STOW_DIRECTORIES[@]}"; do
    echo -e "${WHITE}$((i + 1)).${NC} ${YELLOW}${STOW_DIRECTORIES[i]}${NC}"
  done
  echo -e "${LIGHT_GRAY}${DIM}(These will be symlinked to your home directory)${NC}"
  echo

  read -p "Enter your choices: " choices

  SELECTED_STOW_DIRS=()

  if [[ "$choices" == "all" ]]; then
    SELECTED_STOW_DIRS=("${STOW_DIRECTORIES[@]}")
  else
    for choice in $choices; do
      if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#STOW_DIRECTORIES[@]}" ]; then
        SELECTED_STOW_DIRS+=("${STOW_DIRECTORIES[$((choice - 1))]}")
      fi
    done
  fi
}

# MARK: stow installation
stow_directories() {
  if [ ${#SELECTED_STOW_DIRS[@]} -eq 0 ]; then
    echo -e "${RED}${CROSS_MARK} No directories selected for stowing.${NC}"
    return 1
  fi

  if ! command -v stow &>/dev/null; then
    echo -e "${RED}${CROSS_MARK} GNU Stow is not installed. Please install it first.${NC}"
    return 1
  fi

  echo -e "${BLUE}${BOLD}${ARROW} Stowing selected directories...${NC}"
  echo -e "${CYAN}${BULLET} Selected directories: ${YELLOW}${SELECTED_STOW_DIRS[*]}${NC}"
  echo -e "${LIGHT_GRAY}${DIM}Target directory: $HOME${NC}"
  echo

  local success_count=0
  local total_count=${#SELECTED_STOW_DIRS[@]}

  for dir in "${SELECTED_STOW_DIRS[@]}"; do
    echo -e "${YELLOW}${ARROW} Stowing ${BOLD}$dir${NC}${YELLOW}...${NC}"
    if stow "$dir" 2>/dev/null; then
      echo -e "${GREEN}${CHECK_MARK} ${BOLD}$dir${NC}${GREEN} stowed successfully${NC}"
      ((success_count++))
    else
      echo -e "${RED}${CROSS_MARK} ${BOLD}$dir${NC}${RED} stowing failed${NC}"
      echo -e "${LIGHT_GRAY}${DIM}  └─ Check for conflicting files or invalid directory structure${NC}"
    fi
    echo
  done

  echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
  if [ $success_count -eq $total_count ]; then
    echo -e "${MAGENTA}║${GREEN}${BOLD}  Stowing Complete! ${CHECK_MARK}               ${NC}${MAGENTA}║${NC}"
  else
    echo -e "${MAGENTA}║${YELLOW}${BOLD}  Stowing Finished                ${NC}${MAGENTA}║${NC}"
  fi
  echo -e "${MAGENTA}║${WHITE}  Success: ${GREEN}$success_count${WHITE}/${total_count} directories stowed   ${NC}${MAGENTA}║${NC}"
  if [ $success_count -lt $total_count ]; then
    echo -e "${MAGENTA}║${LIGHT_GRAY}  Failed:  $((total_count - success_count)) directories            ${NC}${MAGENTA}║${NC}"
  fi
  echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
}

# MARK: main execution

detect_package_manager

echo
echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${WHITE}${BOLD}     Dotfiles Package Installer         ${NC}${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
echo

select_packages
install_packages

echo
read -p "$(echo -e "${CYAN}Would you like to stow configuration directories? (y/N): ${NC}")" stow_choice

if [[ "$stow_choice" =~ ^[Yy]$ ]]; then
  echo
  echo -e "${BLUE}${BOLD}${ARROW} Configuration Stowing Phase${NC}"
  echo
  select_stow_directories
  stow_directories
else
  echo -e "${LIGHT_GRAY}${DIM}Skipping stow configuration.${NC}"
fi

echo
echo -e "${GREEN}${BOLD}${CHECK_MARK} Dotfiles setup complete!${NC}"

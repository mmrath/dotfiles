#!/usr/bin/env bash
# Shared helper functions for dotfiles scripts

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[0;33m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

log_success() {
    printf "${GREEN}[OK]${NC} %s\n" "$1"
}

log_warning() {
    printf "${YELLOW}[WARN]${NC} %s\n" "$1"
}

log_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1" >&2
}

# Platform detection
is_macos() {
    [[ "$(uname)" == "Darwin" ]]
}

is_linux() {
    [[ "$(uname)" == "Linux" ]]
}

# Command availability check
command_exists() {
    command -v "$1" &>/dev/null
}

# Get the dotfiles directory (parent of scripts/)
get_dotfiles_dir() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    dirname "$script_dir"
}

# Check if running interactively
is_interactive() {
    [[ -t 0 ]]
}

# Prompt for confirmation (defaults to yes)
confirm() {
    local prompt="${1:-Continue?}"
    if is_interactive; then
        read -r -p "$prompt [Y/n] " response
        [[ -z "$response" || "$response" =~ ^[Yy] ]]
    else
        true
    fi
}

# Create directory if it doesn't exist
ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        log_info "Created directory: $dir"
    fi
}

# Backup a file if it exists and is not a symlink
backup_file() {
    local file="$1"
    local backup_dir="${2:-$HOME/dotfiles-backup}"

    if [[ -e "$file" && ! -L "$file" ]]; then
        ensure_dir "$backup_dir"
        local filename
        filename="$(basename "$file")"
        cp -r "$file" "$backup_dir/$filename.$(date +%Y%m%d_%H%M%S)"
        log_info "Backed up: $file"
    fi
}

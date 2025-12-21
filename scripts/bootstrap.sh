#!/usr/bin/env bash
set -euo pipefail

# Bootstrap script for dotfiles (macOS)
# This sets up the minimal requirements to run `make all`

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/lib.sh"

# Require macOS
if ! is_macos; then
    log_error "This dotfiles setup is for macOS only"
    exit 1
fi

log_info "Bootstrapping dotfiles..."

# Install Homebrew if not present
if ! command_exists brew; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
fi

log_success "Homebrew installed"

# Install core dependencies
log_info "Installing core dependencies..."
brew bundle --file="$DOTFILES/Brewfile"

log_success "Dependencies installed"

# Install fzf key bindings and completion
if [[ -d "$(brew --prefix)/opt/fzf" ]]; then
    log_info "Setting up fzf..."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# Set up zsh as default shell
setup_shell() {
    local zsh_path
    zsh_path="$(brew --prefix)/bin/zsh"

    # Add to /etc/shells if not present
    if ! grep -qxF "$zsh_path" /etc/shells; then
        log_info "Adding $zsh_path to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    # Change default shell
    if [[ "$SHELL" != "$zsh_path" ]]; then
        log_info "Changing default shell to zsh..."
        chsh -s "$zsh_path"
    fi
}

setup_shell
log_success "Shell configured"

# Create necessary directories
ensure_dir "$HOME/.config"
ensure_dir "$HOME/.local/bin"

# Initialize default theme (light)
if [[ ! -f "$HOME/.config/current-theme" ]]; then
    echo "light" > "$HOME/.config/current-theme"
    log_info "Set default theme to light"
fi

log_success "Bootstrap complete!"
log_info "Run 'make all' to stow all packages"

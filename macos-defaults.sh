#!/usr/bin/env bash
set -euo pipefail

# macOS system preferences (opt-in, run manually)

log_info() { printf '\033[0;34m[INFO]\033[0m %s\n' "$1"; }

if [[ "$(uname)" != "Darwin" ]]; then
    echo "This script only runs on macOS" >&2
    exit 1
fi

log_info "Configuring macOS defaults..."

# Finder
log_info "Configuring Finder..."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
chflags nohidden ~/Library

# Keyboard
log_info "Configuring keyboard..."
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Trackpad
log_info "Configuring trackpad..."
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Terminal
log_info "Configuring Terminal..."
defaults write com.apple.terminal StringEncodings -array 4

# Save dialogs
log_info "Configuring dialogs..."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Font rendering
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Safari
log_info "Configuring Safari..."
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

log_info "macOS defaults configured"
log_info "Some changes require logout/restart to take effect"

#!/usr/bin/env bash
set -euo pipefail

# Install Nerd Fonts

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

log_info "Installing fonts..."

if is_macos; then
    # macOS: Install via Homebrew casks
    brew install --cask font-jetbrains-mono-nerd-font || true
    brew install --cask font-iosevka-nerd-font || true
    log_success "Fonts installed via Homebrew"

elif is_linux; then
    # Linux: Download from Nerd Fonts releases
    local fonts=("JetBrainsMono" "Iosevka")
    local version="v3.3.0"
    local base_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${version}"
    local font_dir="$HOME/.local/share/fonts/NerdFonts"

    ensure_dir "$font_dir"

    for font in "${fonts[@]}"; do
        log_info "Downloading $font..."
        curl -fLo "/tmp/${font}.zip" "${base_url}/${font}.zip"
        unzip -o "/tmp/${font}.zip" -d "$font_dir" -x "*.md" -x "*.txt" -x "LICENSE"
        rm "/tmp/${font}.zip"
    done

    # Rebuild font cache
    fc-cache -f -v

    log_success "Fonts installed to $font_dir"
fi

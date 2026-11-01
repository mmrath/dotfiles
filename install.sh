#!/usr/bin/env bash
# Bootstrap a new Mac: Homebrew -> chezmoi -> apply these dotfiles.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

command -v chezmoi >/dev/null 2>&1 || brew install chezmoi

chezmoi init --apply --source "$DOTFILES"

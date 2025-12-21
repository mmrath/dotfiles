# zshenv - Loaded first for all zsh sessions
# Keep this minimal - only environment variables needed by all shells

# XDG Base Directory
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"

# Editor
export EDITOR='nvim'
export VISUAL='nvim'
export GIT_EDITOR='nvim'

# Vi mode - fast mode switching
export KEYTIMEOUT=1

# GPG
export GPG_TTY=${TTY}

# Golang
export GOPATH="${HOME}/go"

# Dotfiles location
export DOTFILES="${HOME}/dotfiles"

# Rust (source if exists)
[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"

# Nix (source if exists)
[[ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]] && source "${HOME}/.nix-profile/etc/profile.d/nix.sh"

# PATH is set in .config/zsh/path.zsh (sourced by .zshrc)

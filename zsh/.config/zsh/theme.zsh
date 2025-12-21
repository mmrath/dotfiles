# theme.zsh - Theme toggle support for dotfiles

THEME_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/current-theme"

# Get current theme (default to light)
get_theme() {
    if [[ -f "$THEME_FILE" ]]; then
        cat "$THEME_FILE"
    else
        echo "light"
    fi
}

# Export for other applications
export DOTFILES_THEME="$(get_theme)"

# Convenience aliases
alias dark='theme-toggle dark'
alias light='theme-toggle light'
alias theme='theme-toggle'

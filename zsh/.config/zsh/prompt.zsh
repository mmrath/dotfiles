# prompt.zsh - Oh-my-posh prompt configuration (theme-aware)

# Skip in Apple Terminal (limited capabilities)
[[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && return

# Initialize oh-my-posh with theme-aware prompt
if command -v oh-my-posh &>/dev/null; then
    # Read current theme (default: light)
    local theme_mode
    theme_mode="$(cat "${XDG_CONFIG_HOME:-$HOME/.config}/current-theme" 2>/dev/null || echo "light")"

    # Select appropriate prompt theme
    local theme_file
    if [[ "$theme_mode" == "dark" ]]; then
        theme_file="${DOTFILES}/themes/prompt-dark.omp.json"
    else
        theme_file="${DOTFILES}/themes/prompt-light.omp.json"
    fi

    if [[ -f "$theme_file" ]]; then
        eval "$(oh-my-posh init zsh --config "$theme_file")"
    else
        # Fallback to built-in theme
        eval "$(oh-my-posh init zsh)"
    fi
fi

# prompt.zsh - Oh-my-posh prompt configuration

# Skip in Apple Terminal (limited capabilities)
[[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && return

# Initialize oh-my-posh with custom theme
if command -v oh-my-posh &>/dev/null; then
    if [[ -f "${DOTFILES}/themes/prompt.omp.json" ]]; then
        eval "$(oh-my-posh init zsh --config "${DOTFILES}/themes/prompt.omp.json")"
    else
        # Fallback to built-in theme
        eval "$(oh-my-posh init zsh --config "$(brew --prefix oh-my-posh 2>/dev/null)/themes/agnoster.omp.json" 2>/dev/null)" || \
        eval "$(oh-my-posh init zsh)"
    fi
fi

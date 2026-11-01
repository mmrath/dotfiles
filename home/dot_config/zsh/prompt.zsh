# prompt.zsh - Oh-my-posh prompt (ANSI colors, so it follows the terminal theme)

[[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && return

if command -v oh-my-posh &>/dev/null; then
    eval "$(oh-my-posh init zsh --config "$XDG_CONFIG_HOME/oh-my-posh/prompt.omp.json")"
fi

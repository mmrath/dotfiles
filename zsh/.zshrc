# zshrc - Main zsh configuration
# Sources modular config files from ~/.config/zsh/

# Zsh options
setopt nobanghist           # Disable ! history expansion (safer)
setopt auto_cd              # cd by typing directory name
setopt correct              # Suggest corrections for commands
setopt hist_ignore_dups     # Don't record duplicate commands
setopt share_history        # Share history between sessions
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Disable some magic
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_AUTO_TITLE="true"

# Config directory
ZSH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Source modular config files (order matters)
for config in path theme plugins prompt aliases functions; do
    [[ -f "$ZSH_CONFIG/$config.zsh" ]] && source "$ZSH_CONFIG/$config.zsh"
done

# Source local overrides (machine-specific, not in git)
[[ -f "$ZSH_CONFIG/local.zsh" ]] && source "$ZSH_CONFIG/local.zsh"

# Mise (version manager) - must be last to properly hook into shell
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi

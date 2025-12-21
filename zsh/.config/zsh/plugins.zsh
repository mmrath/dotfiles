# plugins.zsh - Plugin management with antidote.lite

# Plugin settings (set before loading)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
ZSH_AUTOSUGGEST_USE_ASYNC="true"

# ZSH config directories
ZSH=${ZSH:-${ZDOTDIR:-$HOME/.config/zsh}}
ZSH_CUSTOM=${ZSH_CUSTOM:-$ZSH/custom}

# Install antidote.lite if missing
if [[ ! -e $ZSH/lib/antidote.lite.zsh ]]; then
    mkdir -p $ZSH/lib
    curl -fsSL -o $ZSH/lib/antidote.lite.zsh \
        https://raw.githubusercontent.com/mattmc3/zsh_unplugged/main/antidote.lite.zsh
fi

# Source antidote.lite
source $ZSH/lib/antidote.lite.zsh

# Plugin list
repos=(
    # Oh-my-zsh utilities
    ohmyzsh/ohmyzsh/lib/clipboard.zsh
    ohmyzsh/ohmyzsh/plugins/colored-man-pages
    ohmyzsh/ohmyzsh/plugins/magic-enter

    # Completions
    zsh-users/zsh-completions
    mattmc3/zephyr/plugins/completion

    # Fish-like features
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-history-substring-search
)

# Clone and load plugins
plugin-clone $repos
plugin-load $repos

# Keybindings for history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

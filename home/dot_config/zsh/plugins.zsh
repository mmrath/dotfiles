# plugins.zsh - Completion and plugins (installed via Homebrew, see Brewfile)

BREW_SHARE="${HOMEBREW_PREFIX:-/opt/homebrew}/share"

# Completion
fpath=("$BREW_SHARE/zsh-completions" "$BREW_SHARE/zsh/site-functions" $fpath)
autoload -Uz compinit
mkdir -p "$XDG_CACHE_HOME/zsh"
compinit -u -d "$XDG_CACHE_HOME/zsh/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# fzf keybindings (Ctrl-R history, Ctrl-T files, Alt-C cd)
command -v fzf &>/dev/null && source <(fzf --zsh)

# Fish-like features
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
ZSH_AUTOSUGGEST_USE_ASYNC="true"

for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search; do
    [[ -f "$BREW_SHARE/$plugin/$plugin.zsh" ]] && source "$BREW_SHARE/$plugin/$plugin.zsh"
done
unset plugin BREW_SHARE

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

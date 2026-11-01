# path.zsh - All PATH modifications in one place

typeset -aU path

if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# User binaries (highest priority)
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    $path
)

# Golang
[[ -d "/usr/local/go/bin" ]] && path+=("/usr/local/go/bin")
[[ -d "${GOPATH}/bin" ]] && path+=("${GOPATH}/bin")

export PATH

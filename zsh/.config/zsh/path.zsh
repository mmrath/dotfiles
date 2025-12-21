# path.zsh - All PATH modifications in one place

# Ensure unique entries in path
typeset -aU path

# User binaries (highest priority)
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    $path
)

# Golang
[[ -d "/usr/local/go/bin" ]] && path+=("/usr/local/go/bin")
[[ -d "${GOPATH}/bin" ]] && path+=("${GOPATH}/bin")

# Homebrew (macOS)
if [[ -d "/opt/homebrew/bin" ]]; then
    path=("/opt/homebrew/bin" "/opt/homebrew/sbin" $path)
elif [[ -d "/usr/local/bin" ]]; then
    path=("/usr/local/bin" $path)
fi

# Linuxbrew
[[ -d "/home/linuxbrew/.linuxbrew/bin" ]] && path=("/home/linuxbrew/.linuxbrew/bin" $path)

export PATH

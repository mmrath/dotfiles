#!/usr/bin/env zsh
# vim: set filetype=zsh


# Add more dirs to PATH
if [[ ! "${PATH}" == *:.* ]]; then
    export PATH="${PATH}:."
fi
for dir in bin .bin; do
    if [[ ! "${PATH}" == *${HOME}/${dir}* ]]; then
        export PATH="${HOME}/${dir}:${PATH}"
    fi
done

# Golang
export GOPATH="${HOME}/go"
if [[ ! "${PATH}" == */usr/local/go/bin* ]]; then
    export PATH="${PATH}:/usr/local/go/bin"
fi

if [[ ! "${PATH}" == *${GOPATH}/bin* ]]; then
    export PATH="${PATH}:${GOPATH}/bin"
fi

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# Set XDG_CONFIG_HOME
export XDG_CONFIG_HOME="${HOME}/.config"

# Set the GPG_TTY to the current TTY
export GPG_TTY=${TTY}

# Rust
test -f "${HOME}/.cargo/env" && source "${HOME}/.cargo/env"

# FZF
export FZF_DEFAULT_COMMAND='find -L'
export FZF_DEFAULT_OPTS="--bind 'ctrl-v:execute(vim {})+abort,?:toggle-preview,alt-a:select-all,alt-d:deselect-all' --tiebreak=index --cycle --preview-window right:50%:border:wrap"
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --color=dark,fg:7,bg:-1,hl:5,fg+:15,bg+:8,hl+:13,info:2,prompt:4,pointer:1,marker:3,spinner:4,header:4"
export FZF_CTRL_R_OPTS="--layout=reverse --preview-window hidden"

export DOTFILES="$(dirname "$(dirname "$(readlink "${(%):-%N}")")")"
export CACHEDIR="$HOME/.local/share"
export VIM_TMP="$HOME/.vim-tmp"

[[ -d "$CACHEDIR" ]] || mkdir -p "$CACHEDIR"
[[ -d "$VIM_TMP" ]] || mkdir -p "$VIM_TMP"

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local


typeset -aU path

export EDITOR='nvim'
export GIT_EDITOR='nvim'
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer


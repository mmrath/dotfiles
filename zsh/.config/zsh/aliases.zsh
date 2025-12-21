# aliases.zsh - Shell aliases

# Editor
alias vi="nvim"
alias vim="nvim"

# Better defaults
alias cat="bat"
alias ls="eza"
alias ll="eza -la"
alias la="eza -a"
alias tree="eza --tree"

# Safety
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Git shortcuts (complement gitconfig aliases)
alias g="git"
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"

# Zellij (terminal multiplexer)
alias zj="zellij"
alias zja="zellij attach"
alias zjl="zellij list-sessions"

# Theme toggle
alias dark="theme-toggle dark"
alias light="theme-toggle light"
alias theme="theme-toggle"

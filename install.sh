#!/usr/bin/env bash

DOTFILES="$(pwd)"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

title() {
    echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
    echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
    echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
    exit 1
}

warning() {
    echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
    echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
    echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

get_linkables() {
    find -H "$DOTFILES" -maxdepth 3 -name '*.symlink'
}

backup() {
    BACKUP_DIR=$HOME/dotfiles-backup

    echo "Creating backup directory at $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    for file in $(get_linkables); do
        filename=".$(basename "$file" '.symlink')"
        target="$HOME/$filename"
        if [ -f "$target" ]; then
            echo "backing up $filename"
            cp "$target" "$BACKUP_DIR"
        else
            warning "$filename does not exist at this location or is a symlink"
        fi
    done

    for filename in "$HOME/.config/nvim" "$HOME/.vim" "$HOME/.vimrc"; do
        if [ ! -L "$filename" ]; then
            echo "backing up $filename"
            cp -rf "$filename" "$BACKUP_DIR"
        else
            warning "$filename does not exist at this location or is a symlink"
        fi
    done
}

setup_fonts(){
    title "Installing fonts"

    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS: Install via Homebrew casks (defined in Brewfile)
        info "Installing fonts via Homebrew..."
        brew install --cask font-jetbrains-mono-nerd-font
        brew install --cask font-caskaydia-mono-nerd-font
        brew install --cask font-iosevka-nerd-font
        brew install --cask font-fira-code-nerd-font
        brew install --cask font-maple-mono-nf
        success "Fonts installed via Homebrew"
    elif [[ "$(uname)" == "Linux" ]]; then
        # Linux: Download from Nerd Fonts releases
        local fonts=("JetBrainsMono" "CascadiaCode" "Iosevka" "FiraCode")
        local version="v3.3.0"
        local base_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${version}"
        local font_dir="$HOME/.local/share/fonts/NerdFonts"

        mkdir -p "$font_dir"
        for font in "${fonts[@]}"; do
            info "Downloading $font..."
            curl -fLo "/tmp/${font}.zip" "${base_url}/${font}.zip"
            unzip -o "/tmp/${font}.zip" -d "$font_dir" -x "*.md" -x "*.txt" -x "LICENSE"
            rm "/tmp/${font}.zip"
        done
        fc-cache -f -v
        success "Fonts installed to $font_dir"
    fi
}

setup_symlinks() {
    title "Creating symlinks"

    for file in $(get_linkables) ; do
        target="$HOME/.$(basename "$file" '.symlink')"
        if [ -e "$target" ]; then
            info "~${target#$HOME} already exists... Skipping."
        else
            info "Creating symlink for $file"
            ln -s "$file" "$target"
        fi
    done

    echo -e
    info "installing to ~/.config"
    if [ ! -d "$HOME/.config" ]; then
        info "Creating ~/.config"
        mkdir -p "$HOME/.config"
    fi

    config_files=$(find "$DOTFILES/config" -maxdepth 1 -mindepth 1 2>/dev/null)
    for config in $config_files; do
	    
        target="$HOME/.config/$(basename "$config")"
        if [ -e "$target" ]; then
            info "~${target#$HOME} already exists... Skipping."
        else
            info "Creating symlink for $config"
            ln -s "$config" "$target"
        fi
    done
}

setup_git() {
    title "Setting up Git"

    defaultName=$(git config user.name)
    defaultEmail=$(git config user.email)
    defaultGithub=$(git config github.user)

    read -rp "Name [$defaultName] " name
    read -rp "Email [$defaultEmail] " email
    read -rp "Github username [$defaultGithub] " github

    git config -f ~/.gitconfig-local user.name "${name:-$defaultName}"
    git config -f ~/.gitconfig-local user.email "${email:-$defaultEmail}"
    git config -f ~/.gitconfig-local github.user "${github:-$defaultGithub}"

    if [[ "$(uname)" == "Darwin" ]]; then
        git config --global credential.helper "osxkeychain"
    else
        read -rn 1 -p "Save user and password to an unencrypted file to avoid writing? [y/N] " save
        if [[ $save =~ ^([Yy])$ ]]; then
            git config --global credential.helper "store"
        else
            git config --global credential.helper "cache --timeout 3600"
        fi
    fi
}

setup_homebrew() {
    title "Setting up Homebrew"

    if test ! "$(command -v brew)"; then
        info "Homebrew not installed. Installing."
        # Run as a login shell (non-interactive) so that the script doesn't pause for user input
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
    fi

    if [ "$(uname)" == "Linux" ]; then
        test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        # Only add to bash_profile if not already present
        if test -r ~/.bash_profile && ! grep -q "linuxbrew" ~/.bash_profile; then
            echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
        fi
    fi

    # install brew dependencies from Brewfile
    brew bundle

    # install fzf
    echo -e
    info "Installing fzf"
    "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
}

setup_shell() {
    title "Configuring shell"

    if [ "$(uname)" == "Linux" ]; then
        zsh_path="$(which zsh)"
        if [[ "$SHELL" != "$zsh_path" ]]; then
            chsh -s "$zsh_path"
            info "default shell changed to $zsh_path"
        fi
    fi

    if [[ "$(uname)" == "Darwin" ]]; then
        [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"
        if ! grep -qxF "$zsh_path" /etc/shells; then
            info "adding $zsh_path to /etc/shells"
            echo "$zsh_path" | sudo tee -a /etc/shells
        fi

        if [[ "$SHELL" != "$zsh_path" ]]; then
            chsh -s "$zsh_path"
            info "default shell changed to $zsh_path"
        fi
    fi 
}

setup_zsh_config(){
    title "Setting up Zsh configuration"

    # Install oh-my-posh if not present
    if ! command -v oh-my-posh &> /dev/null; then
        info "Installing oh-my-posh..."
        if [[ "$(uname)" == "Darwin" ]]; then
            brew install jandedobbeleer/oh-my-posh/oh-my-posh
        else
            curl -s https://ohmyposh.dev/install.sh | bash -s
        fi
    else
        info "oh-my-posh already installed"
    fi

    # Create zsh config directory
    mkdir -p "$HOME/.config/zsh"

    # Symlinks are handled by setup_symlinks(), but ensure zshenv/zshrc are linked
    ln -sf "$DOTFILES/home_symlinks/zshenv.symlink" "$HOME/.zshenv"
    ln -sf "$DOTFILES/home_symlinks/zshrc.symlink" "$HOME/.zshrc"

    success "Zsh configured with oh-my-posh + antidote.lite"
}

function setup_terminfo() {
    title "Configuring terminfo"

    info "adding tmux.terminfo"
    tic -x "$DOTFILES/resources/tmux.terminfo"

    info "adding xterm-256color-italic.terminfo"
    tic -x "$DOTFILES/resources/xterm-256color-italic.terminfo"
}

setup_macos() {
    title "Configuring macOS"
    if [[ "$(uname)" == "Darwin" ]]; then

        echo "Finder: show all filename extensions"
        defaults write NSGlobalDomain AppleShowAllExtensions -bool true

        echo "show hidden files by default"
        defaults write com.apple.Finder AppleShowAllFiles -bool false

        echo "only use UTF-8 in Terminal.app"
        defaults write com.apple.terminal StringEncodings -array 4

        echo "expand save dialog by default"
        defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

        echo "show the ~/Library folder in Finder"
        chflags nohidden ~/Library

        echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
        defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

        echo "Enable subpixel font rendering on non-Apple LCDs"
        defaults write NSGlobalDomain AppleFontSmoothing -int 2

        echo "Use current directory as default search scope in Finder"
        defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

        echo "Show Path bar in Finder"
        defaults write com.apple.finder ShowPathbar -bool true

        echo "Show Status bar in Finder"
        defaults write com.apple.finder ShowStatusBar -bool true

        echo "Disable press-and-hold for keys in favor of key repeat"
        defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

        echo "Set a blazingly fast keyboard repeat rate"
        defaults write NSGlobalDomain KeyRepeat -int 1

        echo "Set a shorter Delay until key repeat"
        defaults write NSGlobalDomain InitialKeyRepeat -int 15

        echo "Enable tap to click (Trackpad)"
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

        echo "Enable Safari's debug menu"
        defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

        echo -e
        info "Settings applied. Restart affected apps or log out/in for changes to take effect."
    else
        warning "macOS not detected. Skipping."
    fi
}

case "$1" in
    backup)
        backup
        ;;
    link)
        setup_symlinks
        ;;
    git)
        setup_git
        ;;
    homebrew)
        setup_homebrew
        ;;
    shell)
        setup_shell
        setup_zsh_config
        ;;
    terminfo)
        setup_terminfo
        ;;
    macos)
        setup_macos
        ;;
    fonts)
        setup_fonts
        ;;
    all)
        setup_symlinks
        setup_terminfo
        setup_homebrew
        setup_shell
        setup_zsh_config
        setup_git
        setup_macos
        setup_fonts
        ;;
    *)
        echo -e $"\nUsage: $(basename "$0") {backup|link|git|homebrew|shell|terminfo|macos|all}\n"
        exit 1
        ;;
esac

echo -e
success "Done."

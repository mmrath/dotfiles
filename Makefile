# Dotfiles Makefile
# Usage: make [target]
#   make install   - Install all dependencies via Homebrew
#   make all       - Install deps + stow all packages
#   make stow      - Stow all packages (no install)
#   make unstow    - Remove all symlinks

DOTFILES := $(shell pwd)
STOW := stow --verbose --target=$(HOME) --dir=$(DOTFILES)
RESTOW := $(STOW) --restow
UNSTOW := $(STOW) --delete

# Use --adopt only for force target (backs up then adopts)
ADOPT := $(STOW) --adopt --restow

# Package groups
CORE_PACKAGES := zsh git bin
TERMINAL_PACKAGES := wezterm ghostty zellij kitty
EDITOR_PACKAGES := nvim jetbrains
TOOL_PACKAGES := ripgrep
ALL_PACKAGES := $(CORE_PACKAGES) $(TERMINAL_PACKAGES) $(EDITOR_PACKAGES) $(TOOL_PACKAGES)

.PHONY: all install stow core terminals editors tools help
.PHONY: $(ALL_PACKAGES) kitty
.PHONY: unstow clean bootstrap ensure-brew ensure-stow update

# Ensure Homebrew is installed
ensure-brew:
	@command -v brew >/dev/null 2>&1 || { \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	}

# Ensure stow is installed
ensure-stow: ensure-brew
	@command -v stow >/dev/null 2>&1 || { \
		echo "Installing stow..."; \
		brew install stow; \
	}

# Install all dependencies from Brewfile
install: ensure-brew
	@echo "Installing dependencies from Brewfile..."
	@brew bundle --file="$(DOTFILES)/Brewfile"
	@echo "Dependencies installed!"

# Update all dependencies
update: ensure-brew
	@echo "Updating dependencies..."
	@brew update
	@brew bundle --file="$(DOTFILES)/Brewfile"
	@brew upgrade
	@brew cleanup
	@echo "Dependencies updated!"

# Default target: install deps then stow
all: install stow
	@echo "All done! Dependencies installed and configs stowed."

# Remove non-symlink files that would conflict with stow
# First unstow to remove symlinks, then delete any remaining regular files
clean-conflicts:
	@for pkg in $(ALL_PACKAGES); do \
		$(UNSTOW) $$pkg 2>/dev/null || true; \
	done
	@for pkg in $(ALL_PACKAGES); do \
		if [ -d "$(DOTFILES)/$$pkg" ]; then \
			cd "$(DOTFILES)/$$pkg" && find . -type f | while read f; do \
				target="$(HOME)/$${f#./}"; \
				if [ -e "$$target" ] && [ ! -L "$$target" ]; then \
					echo "Removing conflicting file: $$target"; \
					rm -f "$$target"; \
				fi; \
			done; \
		fi; \
	done

# Stow all packages (without installing deps)
stow: ensure-stow clean-conflicts core terminals editors tools
	@echo "All packages stowed successfully!"

# Package groups
core: $(CORE_PACKAGES)
	@echo "Core packages stowed."

terminals: $(TERMINAL_PACKAGES)
	@echo "Terminal packages stowed."

editors: $(EDITOR_PACKAGES)
	@echo "Editor packages stowed."

tools: $(TOOL_PACKAGES)
	@echo "Tool packages stowed."

# Individual packages
zsh:
	@echo "Stowing zsh..."
	@$(RESTOW) zsh

git:
	@echo "Stowing git..."
	@$(RESTOW) git

bin:
	@echo "Stowing bin..."
	@$(RESTOW) bin

wezterm:
	@echo "Stowing wezterm..."
	@$(RESTOW) wezterm

ghostty:
	@echo "Stowing ghostty..."
	@$(RESTOW) ghostty

zellij:
	@echo "Stowing zellij..."
	@$(RESTOW) zellij

kitty:
	@echo "Stowing kitty..."
	@$(RESTOW) kitty

nvim:
	@echo "Stowing nvim..."
	@$(RESTOW) nvim

jetbrains:
	@echo "Stowing jetbrains..."
	@$(RESTOW) jetbrains

ripgrep:
	@echo "Stowing ripgrep..."
	@$(RESTOW) ripgrep

# Unstow all packages
unstow:
	@echo "Removing all symlinks..."
	@for pkg in $(ALL_PACKAGES); do \
		$(UNSTOW) $$pkg 2>/dev/null || true; \
	done
	@echo "All packages unstowed."

# Force stow (adopts existing files, use with caution)
force:
	@echo "Force stowing all packages (adopting existing files)..."
	@for pkg in $(ALL_PACKAGES); do \
		$(ADOPT) $$pkg; \
	done
	@echo "Done. Check 'git status' - adopted files may differ from repo versions."

# Bootstrap: full setup for new machine
bootstrap:
	@./scripts/bootstrap.sh
	@$(MAKE) all

# macOS specific setup
macos:
	@./scripts/macos-defaults.sh

# Install fonts
fonts:
	@./scripts/fonts.sh

# Show help
help:
	@echo "Dotfiles Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Main Targets:"
	@echo "  all        - Install dependencies + stow all (recommended)"
	@echo "  install    - Install/update dependencies from Brewfile"
	@echo "  stow       - Stow all packages (no install)"
	@echo "  update     - Update all Homebrew dependencies"
	@echo "  unstow     - Remove all symlinks"
	@echo ""
	@echo "Package Groups:"
	@echo "  core       - Stow core: zsh, git, bin"
	@echo "  terminals  - Stow terminals: wezterm, ghostty, zellij"
	@echo "  editors    - Stow editors: nvim, jetbrains"
	@echo "  tools      - Stow tools: ripgrep"
	@echo ""
	@echo "Individual Packages:"
	@echo "  zsh, git, bin, wezterm, ghostty,"
	@echo "  zellij, nvim, jetbrains, ripgrep"
	@echo ""
	@echo "Setup:"
	@echo "  bootstrap  - Full setup for new machine"
	@echo "  macos      - Apply macOS defaults"
	@echo "  fonts      - Install fonts"
	@echo "  help       - Show this help"

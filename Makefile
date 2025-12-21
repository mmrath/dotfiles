# Dotfiles Makefile
# Usage: make [target]
#   make all       - Stow all packages
#   make core      - Stow core packages (zsh, git, bin, mise)
#   make terminals - Stow terminal configs
#   make editors   - Stow editor configs
#   make unstow    - Remove all symlinks

DOTFILES := $(shell pwd)
STOW := stow --verbose --target=$(HOME) --dir=$(DOTFILES)
RESTOW := $(STOW) --restow
UNSTOW := $(STOW) --delete

# Use --adopt only for force target (backs up then adopts)
ADOPT := $(STOW) --adopt --restow

# Package groups
CORE_PACKAGES := zsh git bin mise
TERMINAL_PACKAGES := wezterm ghostty zellij
EDITOR_PACKAGES := nvim jetbrains
TOOL_PACKAGES := ripgrep
ALL_PACKAGES := $(CORE_PACKAGES) $(TERMINAL_PACKAGES) $(EDITOR_PACKAGES) $(TOOL_PACKAGES)

.PHONY: all core terminals editors tools help
.PHONY: $(ALL_PACKAGES)
.PHONY: unstow clean bootstrap ensure-stow

# Ensure stow is installed
ensure-stow:
	@command -v stow >/dev/null 2>&1 || { \
		echo "Installing stow..."; \
		brew install stow; \
	}

# Default target
all: ensure-stow core terminals editors tools
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

mise:
	@echo "Stowing mise..."
	@$(RESTOW) mise

wezterm:
	@echo "Stowing wezterm..."
	@$(RESTOW) wezterm

ghostty:
	@echo "Stowing ghostty..."
	@$(RESTOW) ghostty

zellij:
	@echo "Stowing zellij..."
	@$(RESTOW) zellij

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

# Bootstrap: install dependencies and stow
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
	@echo "Package Groups:"
	@echo "  all        - Stow all packages"
	@echo "  core       - Stow core: zsh, git, bin, mise"
	@echo "  terminals  - Stow terminals: wezterm, ghostty, zellij"
	@echo "  editors    - Stow editors: nvim, jetbrains"
	@echo "  tools      - Stow tools: ripgrep"
	@echo ""
	@echo "Individual Packages:"
	@echo "  zsh, git, bin, mise, wezterm, ghostty,"
	@echo "  zellij, nvim, jetbrains, ripgrep"
	@echo ""
	@echo "Other:"
	@echo "  unstow     - Remove all symlinks"
	@echo "  bootstrap  - Install deps and stow all"
	@echo "  macos      - Apply macOS defaults"
	@echo "  fonts      - Install fonts"
	@echo "  help       - Show this help"

# Dotfiles

macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/)

## What's Included

- **Shell**: Zsh with oh-my-posh prompt
- **Terminals**: WezTerm, Ghostty
- **Multiplexer**: Zellij
- **Editors**: Neovim (LSP, Telescope, Treesitter), JetBrains IdeaVim
- **Theme**: Catppuccin Frappe (default) / Latte light with toggle

## Quick Start

```bash
git clone https://github.com/murali/dotfiles ~/dotfiles
cd ~/dotfiles
make all          # Install deps + stow configs
```

## Installation

### Prerequisites

- macOS 12+

### Fresh Install

```bash
make all          # Install dependencies + stow all configs
```

Or step by step:
```bash
make install      # Install dependencies from Brewfile
make stow         # Symlink all configurations
```

### Updating

```bash
make update       # Update all Homebrew dependencies
make stow         # Re-stow configs (if needed)
```

### Individual Packages

```bash
make zsh          # Shell configuration
make wezterm      # WezTerm terminal
make ghostty      # Ghostty terminal
make zellij       # Zellij multiplexer
make nvim         # Neovim editor
make git          # Git configuration
```

### All Make Targets

```bash
make help         # Show all available targets
```

## Theme Toggle

Switch between Catppuccin Frappe (dark) and Latte (light) themes:

```bash
dark              # Switch to Catppuccin Frappe (default)
light             # Switch to Catppuccin Latte
theme-toggle      # Toggle between themes
theme-toggle status  # Show current theme
```

**Affects**: WezTerm, Ghostty, Neovim, Zellij, oh-my-posh prompt

## Zellij (Terminal Multiplexer)

Uses default keybindings (modal system). Press the key combo to enter a mode, then use the actions:

| Mode | Enter | Common Keys |
|------|-------|-------------|
| Pane | `Ctrl+p` | `d` split down, `r` split right, `x` close, `hjkl` navigate |
| Tab | `Ctrl+t` | `n` new, `x` close, `r` rename, `1-9` goto |
| Resize | `Ctrl+n` | `hjkl` resize |
| Scroll | `Ctrl+s` | `jk` scroll, `/` search |
| Session | `Ctrl+o` | `d` detach, `w` session manager |
| Lock | `Ctrl+g` | Pass all keys to terminal |

The status bar shows available keys in each mode.

## Directory Structure

```
dotfiles/
├── bin/          # Custom scripts (~/.local/bin)
├── git/          # Git configuration
├── ghostty/      # Ghostty terminal
├── jetbrains/    # IdeaVim for JetBrains IDEs
├── nvim/         # Neovim configuration
├── ripgrep/      # Ripgrep config
├── scripts/      # Bootstrap & setup scripts
├── themes/       # Prompt themes (oh-my-posh)
├── wezterm/      # WezTerm terminal
├── zellij/       # Zellij multiplexer
├── zsh/          # Zsh shell configuration
├── Brewfile      # Homebrew dependencies
└── Makefile      # Installation targets
```

## Customization

### Local Overrides

These files are not tracked in git:

- `~/.config/zsh/local.zsh` - Machine-specific shell config
- `~/.gitconfig-local` - Git user info (name, email, signing key)

### Theme Colors

| Theme | Description |
|-------|-------------|
| **Catppuccin Frappe** | Medium dark (#303446), balanced contrast |
| **Catppuccin Latte** | Light theme (#eff1f5), easy on the eyes |

## Bin Scripts

| Script | Purpose |
|--------|---------|
| `theme-toggle` | Switch dark/light theme |
| `killport` | Kill process on port |
| `wtfport` | Show what's using a port |
| `git-bare-clone` | Clone as bare repo for worktrees |
| `git-clc` | Copy last commit hash |
| `git-kill` | Delete branch locally and remotely |
| `jwt` | Decode JWT tokens |
| `colortest` | Test terminal colors |

## Neovim

Key bindings (Leader = Space):

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Recent files |
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>w` | Save file |

## Syncing Changes

```bash
cd ~/dotfiles
git pull
make all          # Install any new deps + re-stow
```

## Uninstalling

```bash
make unstow      # Remove all symlinks
```

## License

MIT

# Dotfiles

macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/)

## What's Included

- **Shell**: Zsh with oh-my-posh prompt
- **Terminals**: WezTerm, Ghostty
- **Multiplexer**: Zellij
- **Editors**: Neovim (LSP, Telescope, Treesitter), JetBrains IdeaVim
- **Theme**: GitHub Light (default) / Catppuccin dark with toggle

## Quick Start

```bash
git clone https://github.com/murali/dotfiles ~/dotfiles
cd ~/dotfiles
make bootstrap
make all
```

## Installation

### Prerequisites

- macOS 12+
- [Homebrew](https://brew.sh)

### Bootstrap (Fresh Install)

```bash
make bootstrap    # Install Homebrew, dependencies, fonts
make all          # Symlink all configurations
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

## Theme Toggle

Switch between GitHub Light and Catppuccin dark themes:

```bash
light             # Switch to GitHub Light (default)
dark              # Switch to Catppuccin dark
theme-toggle      # Toggle between themes
theme status      # Show current theme
```

**Affects**: WezTerm, Ghostty, Neovim, oh-my-posh prompt

**Note**: The light theme uses colorblind-friendly colors (orange for errors/deletions, blue for success/additions).

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
├── mise/         # Runtime version manager
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
| **GitHub Light** | Soft cream background (#f5f5f0), colorblind-friendly (orange for errors, blue for success) |
| **Catppuccin Mocha** | Deep purple background (#1e1e2e), warm accent colors |

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

## Updating

```bash
cd ~/dotfiles
git pull
make all
```

## Uninstalling

```bash
make unstow      # Remove all symlinks
```

## License

MIT

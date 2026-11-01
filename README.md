# Dotfiles

macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/) and [Homebrew](https://brew.sh/).

- **Terminal**: Ghostty, Maple Mono NF
- **Editor**: Neovim with [LazyVim](https://www.lazyvim.org/)
- **Shell**: zsh with oh-my-posh, autosuggestions, syntax highlighting, fzf
- **Theme**: Catppuccin, following macOS appearance (Latte when light, Frappe when dark)

## New machine

```bash
git clone git@github.com:mmrath/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` installs Homebrew and chezmoi, then runs `chezmoi init --apply`. On the first run
chezmoi asks for your git name and email; they are written to `~/.gitconfig.local` only if it
doesn't exist yet.

Optional macOS defaults (key repeat, Finder, etc.):

```bash
~/dotfiles/macos-defaults.sh
```

## Daily use

| Task | Command |
| --- | --- |
| Preview what would change | `chezmoi diff` |
| Apply the repo to `$HOME` | `chezmoi apply` |
| Edit a managed file | `chezmoi edit ~/.zshrc` (or edit under `home/` and `chezmoi apply`) |
| Pull in a change made directly in `$HOME` | `chezmoi re-add` |
| Pull the repo and apply | `chezmoi update` |
| Jump to the repo | `chezmoi cd` |

## Layout

```
.chezmoiroot           -> "home": chezmoi source state lives in home/
home/                  files mapped to $HOME (dot_zshrc -> ~/.zshrc, ...)
home/.chezmoiscripts/  scripts run by chezmoi apply
nvim/                  LazyVim config; ~/.config/nvim is a symlink to it
Brewfile               Homebrew packages
install.sh             bootstrap for a new machine
macos-defaults.sh      opt-in macOS preferences
```

### Packages

`Brewfile` is applied by `chezmoi apply` whenever its contents change
(`run_onchange_before_10-brew-bundle.sh`). Add a package by editing `Brewfile` and running
`chezmoi apply`. Packages are never uninstalled automatically; use
`brew bundle cleanup --file=~/dotfiles/Brewfile` to see what isn't listed.

### Neovim

`~/.config/nvim` is a symlink into this repo, so `:Lazy update` writes `nvim/lazy-lock.json`
directly here and shows up in `git status`. Commit it to pin plugin versions. When the lock file
changes, `chezmoi apply` runs `Lazy! restore` so every machine runs the same plugin versions.
Background update checks are disabled.

The colorscheme is `catppuccin-nvim` rather than `catppuccin`, because Neovim 0.12 ships a
built-in `catppuccin` colorscheme that would otherwise shadow the plugin.

### Theme

Ghostty uses `theme = light:Catppuccin Latte,dark:Catppuccin Frappe`. Neovim detects the
terminal background and picks the matching flavour. The prompt uses ANSI color names, so it
follows the terminal palette. Nothing rewrites managed files when the theme changes.

### Machine-specific config

Kept out of the repo and loaded if present:

- `~/.gitconfig.local` (git user, signing key, ...). Created once from the chezmoi prompts, never overwritten.
- `~/.config/zsh/local.zsh` (extra PATH entries, aliases, secrets)

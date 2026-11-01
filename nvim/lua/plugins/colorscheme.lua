-- Neovim detects the terminal background (OSC 11), so Ghostty's
-- light/dark theme selects Latte or Frappe automatically.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "auto",
      background = { light = "latte", dark = "frappe" },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin-nvim" },
  },
}

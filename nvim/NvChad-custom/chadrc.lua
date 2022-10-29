
M.options = {
   relativenumber = true,
}

M.mappings = {
  n = {
  },
  i = {
    ["jk"] = { "<ESC>", "escape vim" },
  }
}

M.plugins = require "custom.plugins"

M.ui = {
  -- theme stuff
theme = "everforest",
  transparency = false,
  theme_toggle = { "everforest", "everforest_light" },

  hl_override = require("custom.highlights").overriden_hlgroups,
}

M.mappings = require "custom.mappings"

vim.cmd("nnoremap <Left>  :echoe \"Use h\"<CR>")
vim.cmd("nnoremap <Right> :echoe \"Use l\"<CR>")
vim.cmd("nnoremap <Up>    :echoe \"Use k\"<CR>")
vim.cmd("nnoremap <Down>  :echoe \"Use j\"<CR>")
vim.cmd("inoremap <Left>  <ESC>:echoe \"Use h\"<CR>")
vim.cmd("inoremap <Right> <ESC>:echoe \"Use l\"<CR>")
vim.cmd("inoremap <Up>    <ESC>:echoe \"Use k\"<CR>")
vim.cmd("inoremap <Down>  <ESC>:echoe \"Use j\"<CR>")

return M

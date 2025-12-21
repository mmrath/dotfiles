--[[
  Neovim Configuration
  Based on kickstart.nvim (https://github.com/nvim-lua/kickstart.nvim)

  This is a well-documented starting point. Modify as needed.
--]]

-- Set <space> as the leader key (before lazy)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install lazy.nvim plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
require('lazy').setup({
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Git integration
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
    end,
  },

  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls', 'ts_ls', 'pyright' },
      }

      -- LSP keymaps (set when LSP attaches)
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end
          map('gd', vim.lsp.buf.definition, 'Go to definition')
          map('gr', vim.lsp.buf.references, 'Go to references')
          map('K', vim.lsp.buf.hover, 'Hover documentation')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
        end,
      })

      -- Configure LSP servers
      local lspconfig = require 'lspconfig'
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
          },
        },
      }
      lspconfig.ts_ls.setup {}
      lspconfig.pyright.setup {}
    end,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
      }
    end,
  },

  -- Treesitter (better syntax highlighting)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'lua', 'javascript', 'typescript', 'python', 'bash', 'json', 'yaml', 'markdown' },
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },

  -- Catppuccin theme (supports both light and dark)
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'auto',
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = false,
        term_colors = true,
      }
    end,
  },

  -- GitHub Light theme (for light mode, colorblind-friendly)
  {
    'projekt0n/github-nvim-theme',
    priority = 1000,
    config = function()
      require('github-theme').setup {
        options = {
          styles = { comments = 'italic' },
        },
        groups = {
          github_light = {
            -- Soft background
            Normal = { bg = '#f5f5f0' },
            NormalFloat = { bg = '#ebebeb' },
            SignColumn = { bg = '#f5f5f0' },
            LineNr = { bg = '#f5f5f0' },
            -- Colorblind-friendly diagnostics
            DiagnosticError = { fg = '#dc6d09' },
            DiagnosticWarn = { fg = '#b45309' },
            DiagnosticInfo = { fg = '#0969da' },
            DiagnosticHint = { fg = '#8250df' },
            -- Git signs (additions blue, deletions orange)
            GitSignsAdd = { fg = '#0969da' },
            GitSignsChange = { fg = '#b45309' },
            GitSignsDelete = { fg = '#dc6d09' },
            -- Diff colors
            DiffAdd = { bg = '#ddf4ff' },
            DiffDelete = { bg = '#fce4c4' },
            DiffChange = { bg = '#fef9c3' },
            DiffText = { bg = '#f8c896' },
          },
        },
      }
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- Which-key (shows pending keybindings)
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {},
  },

  -- Comment toggle
  { 'numToStr/Comment.nvim', opts = {} },

  -- Surround text objects
  { 'kylechui/nvim-surround', opts = {} },
}, {})

-- [[ Settings ]]
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.mouse = 'a'           -- Enable mouse
vim.opt.showmode = false      -- Mode shown in status line
vim.opt.clipboard = 'unnamedplus' -- System clipboard
vim.opt.breakindent = true    -- Wrapped lines continue indented
vim.opt.undofile = true       -- Persistent undo
vim.opt.ignorecase = true     -- Case insensitive search
vim.opt.smartcase = true      -- Unless uppercase used
vim.opt.signcolumn = 'yes'    -- Always show sign column
vim.opt.updatetime = 250      -- Faster updates
vim.opt.timeoutlen = 300      -- Faster which-key
vim.opt.splitright = true     -- Vertical split to right
vim.opt.splitbelow = true     -- Horizontal split below
vim.opt.list = true           -- Show whitespace
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'  -- Live substitution preview
vim.opt.cursorline = true     -- Highlight current line
vim.opt.scrolloff = 10        -- Keep lines above/below cursor
vim.opt.termguicolors = true  -- True color support

-- Default indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- [[ Keymaps ]]
-- Clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic list' })

-- Quick save
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })

-- Better escape
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- [[ Autocommands ]]
-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos('.', save_cursor)
  end,
})

-- [[ Theme Detection ]]
-- Read theme from ~/.config/current-theme (default: light)
local function get_theme()
  local theme_file = vim.fn.expand('~/.config/current-theme')
  local file = io.open(theme_file, 'r')
  if file then
    local theme = file:read('*l')
    file:close()
    return theme or 'light'
  end
  return 'light'
end

vim.g.theme_mode = get_theme()
if vim.g.theme_mode == 'dark' then
  vim.opt.background = 'dark'
else
  vim.opt.background = 'light'
end
vim.cmd.colorscheme 'catppuccin'

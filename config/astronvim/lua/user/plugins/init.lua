return {

  -- Markdown preview
  ["iamcco/markdown-preview.nvim"] = {
    run = function()
      vim.fn["mkdp#util#install"](0)
    end,
    ft = {
      "markdown",
    },
  },

  -- Reopen files at last edit position
  ["ethanholz/nvim-lastplace"] = {
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup(require "user.plugins.nvim-lastplace")
    end,
  },

  -- Go programming
  ["ray-x/go.nvim"] = {
    after = "mason-lspconfig.nvim",
    config = function()
      require("go").setup {
        lsp_cfg = astronvim.lsp.server_settings "gopls",
      }
    end,  
  },

  -- Programming, Testing, Debugging
  ["mfussenegger/nvim-dap"] = {
    module = "dap",
    config = require "user.plugins.dap",
    requires = {
      {
        "rcarriga/nvim-dap-ui",
        after = "nvim-dap",
        config = require "user.plugins.dapui",
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        after = "nvim-dap",
        config = function()
          require("nvim-dap-virtual-text").setup(require "user.plugins.dap-virtual-text")
        end,
      },
      {
        "nvim-telescope/telescope-dap.nvim",
        after = "telescope.nvim",
        module = "telescope._extensions.dap",
        config = function()
          require("telescope").load_extension "dap"
        end,
      },
    },
  },

}

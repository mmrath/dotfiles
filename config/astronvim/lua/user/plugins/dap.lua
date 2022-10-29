return function()
  local dap = require "dap"
  dap.adapters = {
    nlua = function(callback, config)
      callback { type = "server", host = config.host, port = config.port }
    end,
  }
  dap.configurations = {
    {
      -- For Go, using https://github.com/ray-x/go.nvim
      -- For Flutter, using https://github.com/akinsho/flutter-tools.nvim
      -- For Rust, using https://github.com/simrat39/rust-tools.nvim
    },
  }
  vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticWarn" })
  vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticInfo" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticInfo" })
  vim.fn.sign_define("DapLogPoint", { text = ".>", texthl = "DiagnosticInfo" })
end

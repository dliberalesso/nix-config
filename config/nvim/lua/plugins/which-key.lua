---@type LazySpec
return {
  "folke/which-key.nvim",

  event = "VeryLazy",

  init = function()
    vim.opt.timeout = true
    vim.opt.timeoutlen = 300
    vim.opt.updatetime = 250
  end,

  config = function(_, opts)
    local wk = require "which-key"
    wk.setup(opts)

    wk.register({
      f = { name = "File" },
      b = { name = "Buffer" },
      g = { name = "Git" },
    }, { prefix = "<leader>" })
  end,

  opts = {
    icons = {
      group = "",
      separator = "-",
    },
    disable = { filetypes = { "TelescopePrompt" } },
  },
}

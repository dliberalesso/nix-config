---@type LazySpec
return {
  "folke/which-key.nvim",

  event = "VeryLazy",

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.register({
      f = { name = "File" },
      b = { name = "Buffer" },
      g = { name = "Git" },
      p = { name = "Packages" },
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

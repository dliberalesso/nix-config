---@type LazySpec
return {
  "folke/which-key.nvim",

  dependencies = { "AstroNvim/astroui" },

  event = "VeryLazy",

  config = function(_, opts)
    local which_key = require "which-key"
    which_key.setup(opts)

    local get_icon = require("astroui").get_icon
    which_key.register {
      ["<leader>f"] = { name = get_icon("Search", 1, true) .. "Find" },
      ["<leader>g"] = { name = get_icon("Git", 1, true) .. "Git" },
    }
  end,

  opts = {
    icons = {
      group = vim.g.icons_enabled ~= false and "" or "+",
      separator = "-",
    },
    disable = { filetypes = { "TelescopePrompt" } },
  },
}

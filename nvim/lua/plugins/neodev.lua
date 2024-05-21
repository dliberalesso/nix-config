return {
  {
    "folke/neodev.nvim",

    event = "VeryLazy",

    dependencies = { "neovim/nvim-lspconfig" },

    config = function()
      -- then setup your lsp server as usual
      local lspconfig = require "lspconfig"

      -- example to setup lua_ls and enable call snippets
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      }
    end,
  },
}

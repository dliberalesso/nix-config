return {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      { "j-hui/fidget.nvim", config = true },
      { "folke/neodev.nvim", config = true },
    },

    event = { "BufReadPost", "BufNewFile", "BufWritePre" },

    config = function()
      local lspconfig = require "lspconfig"

      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      local servers = {
        lua_ls = {},
        nixd = {},
      }

      for name, opts in pairs(servers) do
        opts = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, opts)

        lspconfig[name].setup(opts)
      end
    end,
  },
}

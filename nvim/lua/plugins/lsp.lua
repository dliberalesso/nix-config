return {
  {
    "neovim/nvim-lspconfig",

    event = { "BufReadPost", "BufNewFile", "BufWritePre" },

    dependencies = {
      { "j-hui/fidget.nvim", config = true },
      { "folke/neodev.nvim", config = true },
    },

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

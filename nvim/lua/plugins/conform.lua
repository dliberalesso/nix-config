local enabled = true

local M = {
  "stevearc/conform.nvim",

  event = { "BufWritePre" },

  cmd = { "ConformInfo" },

  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "nixpkgs_fmt" },
    },

    format_on_save = { timeout_ms = 500, lsp_fallback = true },
  },

  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}

return enabled and M or {}

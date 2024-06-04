local enabled = true

if not enabled then
  return {}
end

return {
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

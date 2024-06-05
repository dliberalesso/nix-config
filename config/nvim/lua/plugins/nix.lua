local enabled = true

if not enabled then
  return {}
end

return {
  -- add nixd to lspconfig
  {
    "neovim/nvim-lspconfig",

    opts = {
      servers = {
        nixd = {},
      },
    },
  },
  -- add nixpkgs-fmt to conform.nvim
  {
    "stevearc/conform.nvim",

    opts = {
      formatters_by_ft = {
        nix = { "nixpkgs_fmt" },
      },
    },
  },
}

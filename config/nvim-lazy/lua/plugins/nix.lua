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
  -- add nix parser to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "nix" })
      opts.auto_install = true
    end,
  },
}

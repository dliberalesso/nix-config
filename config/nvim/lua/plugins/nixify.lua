-- Because of how binaries work when using NixOs,
-- we need to adjust/disable some plugins.

---@type LazySpec
return {
  -- Disable Mason. We will manage binaries using Nix.
  -- This will be the responsability of flake.nix inside each project.
  -- If needed, we can even use a local spec
  { "williamboman/mason.nvim", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },
  { "jay-babu/mason-null-ls.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },

  -- Every parser will be installed using Nix
  -- See home/neovim.nix
  {
    "nvim-treesitter/nvim-treesitter",
    ---@diagnostic disable-next-line:assign-type-mismatch
    build = false,
    opts_extend = {},
    opts = {
      ensure_installed = {},
      auto_install = false,
      highlight = {
        additional_vim_regex_highlighting = false,
      },
    },
  },

  -- We will install and manage this plugin using Nix
  -- See home/neovim.nix
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    enabled = true,
    dev = true,
    ---@diagnostic disable-next-line:assign-type-mismatch
    build = false,
  },
}

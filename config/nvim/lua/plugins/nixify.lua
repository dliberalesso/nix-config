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

  -- We will install and manage this plugin using Nix
  -- See home/neovim.nix
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    dev = true,
    build = false,
    enabled = true,
  },
}

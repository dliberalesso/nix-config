local enabled = true

if not enabled then
  return {}
end

-- Because of how binaries work when using NixOs,
-- we need to adjust/disable some plugins

return {
  -- Disable mason.nvim, because we will manage binaries using Nix
  -- This will be the responsability of flake.nix inside each project
  -- If needed, we can even use a local.spec to set/load plugins on a per project basis
  { "williamboman/mason.nvim", enabled = false },

  -- We will install and manage this plugin using Nix
  -- See home/neovim.nix
  -- {
  --   "nvim-telescope/telescope-fzf-native.nvim",
  --   dev = true,
  --   build = false,
  --   enabled = true,
  -- },
}

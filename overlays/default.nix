{ inputs, ... }:

(final: prev: {
  vimPlugins = prev.vimPlugins // {
    dracula-nvim = prev.vimUtils.buildVimPluginFrom2Nix {
      name = "dracula.nvim";
      pname = "dracula-nvim";
      src = inputs.dracula-nvim;
    };
  };
})

{ inputs, system, ... }:

let
  neovim-unwrapped = inputs.neovim-upstream.packages.${system}.neovim;
  dracula-nvim = inputs.dracula-nvim;
in

(final: prev: {
  # Why can't I just use 'neovim-upstream.overlay'?
  inherit neovim-unwrapped;

  vimPlugins = prev.vimPlugins // {
    dracula-nvim = prev.vimUtils.buildVimPluginFrom2Nix {
      name = "dracula.nvim";
      pname = "dracula-nvim";
      src = dracula-nvim;
    };
  };
})

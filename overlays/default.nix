{ inputs, system, ... }:

let
  neovim-unwrapped = inputs.neovim-upstream.packages.${system}.neovim;
in

(final: prev: {
  # Why can't I just use 'neovim-upstream.overlay'?
  inherit neovim-unwrapped;
})

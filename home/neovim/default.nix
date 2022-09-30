{ config, pkgs, ... }:

let
  colors = config.theme.colors;


in

{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim = {
    enable = true;

    package = pkgs.neovim; # From neovim-upstream overlay

    plugins = with pkgs.vimPlugins; [
      (import ./sensible.nix { inherit vim-sensible; })
      (import ./alucard.nix { inherit colors dracula-nvim; })

      nvim-web-devicons
      (import ./lualine.nix { inherit lualine-nvim; })

      (import ./colorizer.nix { inherit nvim-colorizer-lua; })

      telescope-nvim

      (import ./treesitter.nix {
        nvim-treesitter = (nvim-treesitter.withPlugins (_:
          pkgs.tree-sitter.allGrammars));
      })

      vim-nix
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
  };
}

{ config, pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      vim-sensible
      (import ./alucard.nix { inherit config dracula-vim; })

      nvim-web-devicons
      (import ./lualine.nix { inherit lualine-nvim; })

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

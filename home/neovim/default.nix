{ pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      vim-sensible
      (import ./dracula.nix { inherit dracula-vim; })

      nvim-web-devicons
      (import ./lualine.nix { inherit lualine-nvim; })

      telescope-nvim

      vim-nix

      (import ./treesitter.nix {
        nvim-treesitter = (nvim-treesitter.withPlugins (_:
          pkgs.tree-sitter.allGrammars));
      })
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
  };
}

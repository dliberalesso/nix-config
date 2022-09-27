{ pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim = {
    extraConfig = ''
      set termguicolors
    '';

    plugins = with pkgs.vimPlugins; [
      vim-sensible

      (import ./lualine.nix { inherit lualine-nvim; })

      telescope-nvim

      vim-nix

      (nvim-treesitter.withPlugins (_:
        pkgs.tree-sitter.allGrammars)
      )
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
  };
}

{ pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim = {
    extraConfig = ''
      set termguicolors
      syntax enable
    '';

    plugins = with pkgs.vimPlugins; [
      vim-sensible

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

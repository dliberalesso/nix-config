let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
  });
in
{
  imports = [ nixvim.nixosModules.nixvim ];

  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };

    opts = {
      number = true;         # Show line numbers
      relativenumber = true; # Show relative line numbers
      shiftwidth = 2;        # Tab width should be 2
    };

    colorschemes.catppuccin.enable = true;

    plugins = {
      lualine.enable = true;
      neo-tree.enable = true;
      rainbow-delimiters.enable = true;
      treesitter.enable = true;
      treesitter-textobjects.enable = true;
      ts-autotag.enable = true;
      web-devicons.enable = true;
    };
  };
}

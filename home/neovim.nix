{ config, lib, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [ lazy-nvim ];
  };

  home.file = builtins.listToAttrs (
    [
      {
        name = ".config/nvim";
        value = {
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/nix-config/nvim";
        };
      }
      {
        name = ".local/share/nvim/site/parser";
        value = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${pkgs.symlinkJoin { name = "treesitter-parsers"; paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies; }}/parser";
        };
      }
    ]

    ++

    lib.lists.forEach [
      { package = "telescope-fzf-native-nvim"; name = "telescope-fzf-native.nvim"; }
    ]
      ({ package, name ? package }:
        { name = ".local/share/nvim/nixpkgs/${name}"; value = { source = builtins.getAttr "${package}" pkgs.vimPlugins; }; }
      )
  );
}

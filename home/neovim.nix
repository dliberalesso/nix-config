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
    ]

    ++

    lib.lists.forEach [
      "telescope-fzf-native-nvim"
    ]
      (name:
        { name = ".local/share/nvim/nixpkgs/${name}"; value = { source = builtins.getAttr "${name}" pkgs.vimPlugins; }; }
      )
  );
}

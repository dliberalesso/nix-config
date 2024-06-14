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

    extraPackages = with pkgs; [
      # Formatters
      nixpkgs-fmt
      prettierd
      shfmt
      stylua

      # Language Servers
      lua-language-server
      marksman
      nixd
      taplo
      vscode-langservers-extracted
      yaml-language-server

      # Linters/Static analyzers
      deadnix
      selene
      statix

      # Others
      gcc
      just
      unzip
      zip
    ];
  };

  programs.fish.shellAliases = {
    astro = "NVIM_APPNAME=nvim-astro nvim";
  };

  home.file = builtins.listToAttrs (
    lib.lists.forEach [
      ""
      "-astro"
    ]
      (name:
        {
          name = ".config/nvim${name}";
          value = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/config/nvim${name}";
          };
        }
      )
  );
}

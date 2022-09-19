{ lib, ... }:

{
  imports = [
    ./colors.nix
    ./exa.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./starship.nix
  ];

  programs = {
    bat = {
      enable = true;

      config = {
        color = "always";
        pager = "less";
        theme = "dracula_pro";
      };

      themes.dracula_pro = builtins.readFile ./dracula_pro.tmTheme;
    };

    bottom.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    tealdeer.enable = true;

    zoxide.enable = true;
  };

  home.activation.tealdeer = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD tldr --update $VERBOSE_ARG
  '';
}

{ lib, ... }:

{
  imports = [
    ./exa.nix
    ./fish.nix
    ./fzf.nix
  ];

  programs = {
    bat = {
      enable = true;
      config.color = "always";
      config.pager = "less";
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

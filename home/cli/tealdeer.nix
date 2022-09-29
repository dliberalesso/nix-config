{ lib, ... }:

{
  programs.tealdeer.enable = true;

  home.activation.tealdeer = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD tldr --update $VERBOSE_ARG
  '';
}

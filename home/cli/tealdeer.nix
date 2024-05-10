{
  lib,
  pkgs,
  ...
}: {
  programs.tealdeer.enable = true;

  home.activation.tealdeer =
    lib.hm.dag.entryAfter [
      "linkGeneration"
      "writeBoundary"
    ] ''
      $DRY_RUN_CMD ${pkgs.tealdeer}/bin/tldr --update $VERBOSE_ARG
    '';
}

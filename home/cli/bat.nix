{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.bat = {
    enable = true;

    config = {
      color = "always";
      pager = "less";
      theme = config.theme.name;
    };

    themes = {
      mydracula = {
        src = ../theme;
        file = config.theme.name + ".tmTheme";
      };
    };
  };

  home.activation.bat =
    lib.hm.dag.entryAfter [
      "linkGeneration"
      "writeBoundary"
    ] ''
      $DRY_RUN_CMD ${pkgs.bat}/bin/bat cache --build $VERBOSE_ARG
    '';
}

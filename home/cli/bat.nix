{ config, lib, ... }:

{
  programs.bat = {
    enable = true;

    config = {
      color = "always";
      pager = "less";
      theme = config.theme.name;
    };

    themes = {
      alucard = builtins.readFile config.theme.tmTheme;
    };
  };

  home.activation.bat = lib.hm.dag.entryAfter [
    "linkGeneration"
    "writeBoundary"
  ] ''
    $DRY_RUN_CMD bat cache --build $VERBOSE_ARG
  '';
}

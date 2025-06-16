{
  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.sessionVariables = {
        BATDIFF_USE_DELTA = "true";
      };

      programs.bat = {
        enable = true;

        config = {
          color = "always";
          pager = "less -FR";
        };

        extraPackages = builtins.attrValues {
          inherit (pkgs.bat-extras)
            batdiff
            batgrep
            batman
            batpipe
            batwatch
            prettybat
            ;
        };
      };
    };
}

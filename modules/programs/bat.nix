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

            # FIXME: https://github.com/NixOS/nixpkgs/issues/454391
            # batgrep

            batman
            batpipe
            batwatch
            prettybat
            ;
        };
      };
    };
}

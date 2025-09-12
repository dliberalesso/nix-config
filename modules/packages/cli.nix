{
  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = builtins.attrValues {
        inherit (pkgs)
          dust
          grex
          fselect
          hyperfine
          lnav
          presenterm
          procs
          sd
          tokei
          trash-cli
          wget
          xh
          zip
          ;
      };
    };
}

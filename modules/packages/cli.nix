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
          gitmoji-cli
          grex
          fselect
          hyperfine
          lnav
          presenterm
          procs
          sd
          tokei
          trash-cli
          unzip
          wget
          xh
          zip
          ;
      };
    };
}

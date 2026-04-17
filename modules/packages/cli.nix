{
  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = builtins.attrValues {
        inherit (pkgs)
          cachix
          devenv
          dust
          gitmoji-cli
          glow
          grex
          fselect
          hyperfine
          lnav
          ouch
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

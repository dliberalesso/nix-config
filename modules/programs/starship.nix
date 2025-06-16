{
  unify.home =
    {
      pkgs,
      lib,
      ...
    }:
    let
      package = pkgs.starship;
      # package = pkgs.starship.overrideAttrs (oa: {
      #   patches = (oa.patches or [ ]) ++ [
      #     # TODO: maybe replace with npins
      #     (pkgs.fetchpatch {
      #       url = "https://github.com/starship/starship/pull/5772.patch";
      #       hash = "sha256-DEazRBdybnPrqviBoKpAhHabulP8jE9rnN3ecKWs5Gg=";
      #     })
      #   ];
      # });

      nerdFontSymbols = lib.pipe package [
        (p: "${lib.getExe p} preset nerd-font-symbols -o $out")
        (c: pkgs.runCommand "gen-starship-nerdfonts-config" { } c)
        builtins.readFile
        builtins.fromTOML
      ];
    in
    {
      programs.starship = {
        inherit package;

        enable = true;

        settings = {
          username.format = "[$user]($style) on ";
        } // nerdFontSymbols;
      };
    };
}

{
  perSystem = {
    nixpkgs.overlays = [
      (_: prev: {
        jujutsu = prev.jujutsu.overrideAttrs (oa: {
          buildInputs = oa.buildInputs ++ [ prev.watchman ];
        });
      })
    ];
  };
}

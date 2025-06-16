{
  unify.hosts.nixos.nixavell.nixos = {
    nixpkgs.overlays = [
      (_: prev: {
        libratbag = prev.libratbag.overrideAttrs (_: {
          patches = [
            ./g502-x-plus-wireless.patch
          ];
        });
      })
    ];
  };
}

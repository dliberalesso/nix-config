{
  unify.nixos.nixpkgs.overlays = [
    (_: prev: {
      lazymoji = prev.writeShellApplication {
        name = "lazymoji";

        runtimeInputs = builtins.attrValues {
          inherit (prev) git gum;
        };

        text = builtins.readFile ./lazymoji.sh;
      };
    })
  ];
}

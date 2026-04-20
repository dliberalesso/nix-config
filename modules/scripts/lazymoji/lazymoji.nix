{
  perSystem =
    {
      pkgs,
      ...
    }:
    let
      lazymoji = pkgs.writeShellApplication {
        name = "lazymoji";

        runtimeInputs = builtins.attrValues {
          inherit (pkgs) git gum;
        };

        text = builtins.readFile ./lazymoji.sh;
      };
    in
    {
      make-shells.default.packages = [ pkgs.lazymoji ];

      overlayAttrs = { inherit lazymoji; };

      packages = { inherit lazymoji; };
    };
}

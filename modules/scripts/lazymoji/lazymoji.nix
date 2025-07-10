{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      make-shells.default.packages = [ pkgs.lazymoji ];

      overlayAttrs = {
        lazymoji = pkgs.writeShellApplication {
          name = "lazymoji";

          runtimeInputs = builtins.attrValues {
            inherit (pkgs) git gum;
          };

          text = builtins.readFile ./lazymoji.sh;
        };
      };
    };
}

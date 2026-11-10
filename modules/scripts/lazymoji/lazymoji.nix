{
  perSystem =
    {
      pkgs,
      ...
    }:
    let
      lazymoji = pkgs.writeShellApplication {
        name = "lazymoji";

        runtimeInputs = with pkgs; [
          git
          gum
        ];

        text = builtins.readFile ./lazymoji.sh;
      };
    in
    {
      make-shells.default.packages = [ lazymoji ];

      overlayAttrs = { inherit lazymoji; };

      packages = { inherit lazymoji; };
    };

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.lazymoji ];
    };
}

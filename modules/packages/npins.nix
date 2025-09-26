{
  inputs,
  ...
}:
{
  _module.args = {
    pins = import ../../npins;
  };

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      make-shells.default = {
        packages = [ pkgs.npins ];
      };

      packages = { inherit (pkgs) npins; };

      overlayAttrs = {
        npins = pkgs.callPackage (inputs.npins + "/npins.nix") { };
      };
    };
}

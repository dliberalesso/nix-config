{
  inputs,
  ...
}:
{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      _module.args.sources = import ../../npins;

      overlayAttrs = { inherit (config.packages) npins; };

      packages = {
        npins = pkgs.callPackage (inputs.npins + "/npins.nix") { };

        npins-update = pkgs.writeShellApplication {
          name = "npins-update";

          meta.description = ''
            Update npins
          '';

          runtimeInputs = [ pkgs.npins ];

          text = ''
            npins update
          '';
        };
      };
    };
}

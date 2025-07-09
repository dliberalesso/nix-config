{
  flake-parts-lib,
  inputs,
  ...
}:
let
  inherit (flake-parts-lib) mkPerSystemOption;

  inherit (inputs) wrapper-manager;
in
{
  options.perSystem = mkPerSystemOption (
    {
      inputs',
      lib,
      pkgs,
      self',
      system,
      ...
    }:
    let
      inherit (lib) mkDefault mkOption types;
    in
    {
      options.wrappers = mkOption {
        type = types.attrsOf (
          types.submoduleWith {
            modules = [
              "${wrapper-manager}/modules/wrapper.nix"
              {
                _module.args = { inherit pkgs; };
                wrapperType = mkDefault "binary";
              }
            ];

            specialArgs = { inherit inputs' self' system; };
          }
        );

        internal = true;
      };
    }
  );
}

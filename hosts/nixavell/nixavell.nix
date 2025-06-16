_:
let
  hostName = "nixavell";

  args = import ../_args.nix hostName;
in
{
  imports = [ args ];

  unify.hosts.nixos.${hostName}.nixos =
    {
      inputs,
      ...
    }:
    {
      imports = [
        ../../old_modules/hyprde
        ../../old_modules/laptop
        ../../old_modules/programs

        inputs.nixos-facter-modules.nixosModules.facter
      ];

      facter.reportPath = ./facter.json;
    };
}

_:
let
  hostName = "nixwsl";

  args = import ../_args.nix hostName;
in
{
  imports = [ args ];

  unify.hosts.nixos.${hostName}.nixos = {
    imports = [
      ../../old_modules/wsl.nix
    ];
  };
}

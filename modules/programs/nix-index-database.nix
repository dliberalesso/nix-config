{
  inputs,
  ...
}:
let
  inherit (inputs.nix-index-database) homeModules nixosModules;
in
{
  unify.home = {
    imports = [
      homeModules.nix-index
    ];

    programs = {
      nix-index-database.comma.enable = true;
      nix-index.enable = true;
    };
  };

  unify.nixos = {
    imports = [
      nixosModules.nix-index
    ];
  };
}

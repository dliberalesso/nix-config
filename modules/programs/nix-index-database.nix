{
  inputs,
  ...
}:
let
  inherit (inputs.nix-index-database) hmModules nixosModules;
in
{
  unify.home = {
    imports = [
      hmModules.nix-index
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

{
  hm,
  inputs,
  lib,
  ...
}:
lib.optionalAttrs (inputs.nix-index-database ? nixosModules) (
  {
    imports = [
      inputs.nix-index-database.nixosModules.nix-index
    ];
  }
  // hm {
    imports = [
      inputs.nix-index-database.hmModules.nix-index
    ];

    programs = {
      nix-index-database.comma.enable = true;
      nix-index.enable = true;
    };
  }
)

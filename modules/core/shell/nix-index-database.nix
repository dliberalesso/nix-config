{
  hm,
  inputs,
  lib,
  ...
}:
let
  nid = inputs.nix-index-database ? nixosModules;
in
{
  imports = lib.optionals nid [
    inputs.nix-index-database.nixosModules.nix-index
  ];
}
// hm {
  imports = lib.optionals nid [
    inputs.nix-index-database.hmModules.nix-index
  ];

  config = lib.mkIf nid {
    programs = {
      nix-index-database.comma.enable = true;
      nix-index.enable = true;
    };
  };
}

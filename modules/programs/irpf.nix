{
  pkgs,
  lib,
  ...
}:
let
  version = "2025-1.2";
  hash = "sha256-RlkDioXLcD3wHm9DDLw42QCRT4z0rEwlM0sGMORxk/A=";
in
{
  home-manager.users.dli50.home.packages = [
    (pkgs.irpf.overrideAttrs {
      inherit version;

      src =
        let
          year = lib.head (lib.splitVersion version);
        in
        pkgs.fetchzip {
          url = "https://downloadirpf.receita.fazenda.gov.br/irpf/${year}/irpf/arquivos/IRPF${version}.zip";
          inherit hash;
        };
    })
  ];
}

{
  pkgs,
  lib,
  ...
}:
let
  version = "2025-1.3";
  hash = "sha256-BWCxnKPvkijVkXfbA1iVbdcgLZqY5SAzASqnzdjXwiw=";
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

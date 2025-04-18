{
  pkgs,
  ...
}:
let
  version = "2025-1.2";
  hash = "sha256-RlkDioXLcD3wHm9DDLw42QCRT4z0rEwlM0sGMORxk/A=";
in
{
  home.packages = with pkgs; [
    (irpf.overrideAttrs {
      inherit version;

      src =
        let
          year = lib.head (lib.splitVersion version);
        in
        fetchzip {
          url = "https://downloadirpf.receita.fazenda.gov.br/irpf/${year}/irpf/arquivos/IRPF${version}.zip";
          inherit hash;
        };
    })
  ];
}

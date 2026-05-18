{
  # perSystem =
  #   {
  #     pkgs,
  #     lib,
  #     ...
  #   }:
  #   let
  #     version = "2026-1.2";
  #
  #     # hash = lib.fakeHash;
  #     hash = "sha256-Zw/QtmbINCV1VPz52KCxam+WFgkh8Kjz1v0e7oVeZCs=";
  #
  #     irpf = pkgs.irpf.overrideAttrs {
  #       inherit version;
  #
  #       src =
  #         let
  #           year = lib.head (lib.splitVersion version);
  #         in
  #         pkgs.fetchzip {
  #           url = "https://downloadirpf.receita.fazenda.gov.br/irpf/${year}/irpf/arquivos/IRPF${version}.zip";
  #           inherit hash;
  #         };
  #     };
  #   in
  #   {
  #     overlayAttrs = { inherit irpf; };
  #
  #     packages = { inherit irpf; };
  #   };

  unify.modules.irpf.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [ irpf ];
    };
}

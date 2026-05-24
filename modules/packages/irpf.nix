{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      version = "2026-1.3";

      # hash = lib.fakeHash;
      hash = "sha256-5CX+HaIfQRoeWQHvXTGBhqRAaCM7UH2Duq8+6+3Ai7o=";

      irpf = pkgs.irpf.overrideAttrs (oldAttrs: {
        inherit version;

        src =
          let
            year = lib.head (lib.splitVersion version);
          in
          pkgs.fetchzip {
            url = "https://downloadirpf.receita.fazenda.gov.br/irpf/${year}/irpf/arquivos/IRPF${version}.zip";
            inherit hash;
          };

        postFixup = (oldAttrs.postFixup or "") + ''
          mkdir -p $out/libexec/irpf-browser-compat
          ln -sf ${lib.getExe pkgs.google-chrome} $out/libexec/irpf-browser-compat/firefox

          wrapProgram $out/bin/irpf \
            --suffix PATH : $out/libexec/irpf-browser-compat
        '';
      });
    in
    {
      overlayAttrs = { inherit irpf; };

      packages = { inherit irpf; };
    };

  unify.modules.irpf.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [ irpf ];
    };
}

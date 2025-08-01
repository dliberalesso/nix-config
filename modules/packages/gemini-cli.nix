{
  perSystem =
    {
      config,
      pkgs,
      sources,
      ...
    }:
    {
      overlayAttrs = { inherit (config.packages) gemini-cli; };

      packages.gemini-cli = pkgs.gemini-cli.overrideAttrs (
        final: _old: {
          inherit (sources.gemini-cli) version;

          src = sources.gemini-cli // {
            rev = sources.gemini-cli.revision;
          };

          npmDeps = pkgs.fetchNpmDeps {
            inherit (final) src;
            hash = "sha256-6lyBrkvQsUKFTnIK5aLBszLXzsVyFq2nUwfwiCbBPAY=";
          };

          makeCacheWritable = true;
          npmFlags = [ "--legacy-peer-deps" ];
        }
      );
    };
}

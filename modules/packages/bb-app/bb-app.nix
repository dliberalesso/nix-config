{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      bb-app = inputs.llm-agents.packages.${system}.bb-app.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          ${pkgs.nodejs}/bin/node ${./.}/_patch-bridges.mjs "$out/lib/node_modules/bb-app"
        '';
        installCheckPhase = (old.installCheckPhase or "") + ''
          ${pkgs.nodejs}/bin/node ${./_test-pi.mjs} "$out/lib/node_modules/bb-app"
          ${pkgs.nodejs}/bin/node ${./_test-acp.mjs} "$out/lib/node_modules/bb-app"
        '';
      });
    in
    {
      packages = { inherit bb-app; };
      overlayAttrs = { inherit bb-app; };
    };
}

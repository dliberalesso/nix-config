{
  perSystem =
    {
      inputs',
      ...
    }:
    let
      llm-agents = inputs'.llm-agents.packages;

      llm-agents-packages = {
        inherit (llm-agents)
          agentsview
          cli-proxy-api
          codex
          gemini-cli
          gitnexus
          mcporter
          nono
          opencode
          openspec
          pi
          rtk
          sidecar
          skills
          td
          ;

        antigravity-cli = llm-agents.antigravity.overrideAttrs (_oa: {
          pname = "antigravity-cli";

          installPhase = ''
            runHook preInstall

            install -Dm755 antigravity $out/bin/agy

            runHook postInstall
          '';
        });
      };
    in
    {
      overlayAttrs = llm-agents-packages;

      packages = llm-agents-packages;
    };

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        (python3.withPackages (ps: [
          ps.huggingface-hub
          ps.unsloth
        ]))

        nodejs

        agentsview
        antigravity-cli
        cli-proxy-api
        codex
        gemini-cli
        gitnexus
        mcporter
        nono
        opencode
        openspec
        pi
        rtk
        sidecar
        skills
        td
      ];

      programs.npm.enable = true;
    };
}

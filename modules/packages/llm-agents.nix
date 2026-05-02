{
  perSystem =
    {
      inputs',
      ...
    }:
    let
      llm-agents-packages = {
        inherit (inputs'.llm-agents.packages)
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

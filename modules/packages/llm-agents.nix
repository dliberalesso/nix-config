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
          openspec
          pi
          skills
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
        agentsview
        cli-proxy-api
        codex
        gemini-cli
        gitnexus
        openspec
        pi
        skills
      ];
    };
}

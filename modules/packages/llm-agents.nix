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
          claude-code
          claw-code
          cli-proxy-api
          codex
          gemini-cli
          gitagent
          gitnexus
          openspec
          pi
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
        claude-code
        claw-code
        cli-proxy-api
        codex
        gemini-cli
        gitagent
        gitnexus
        openspec
        pi
      ];
    };
}

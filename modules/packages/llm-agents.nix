{
  perSystem =
    {
      inputs',
      ...
    }:
    {
      overlayAttrs = {
        inherit (inputs'.llm-agents.packages)
          cli-proxy-api
          gemini-cli
          gitagent
          hermes-agent
          opencode
          pi
          ;
      };
    };

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        gemini-cli
        opencode
        pi
      ];
    };
}

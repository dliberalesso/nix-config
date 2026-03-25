{
  perSystem =
    {
      inputs',
      ...
    }:
    {
      overlayAttrs = {
        inherit (inputs'.llm-agents.packages)
          gemini-cli
          opencode
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
      ];
    };
}

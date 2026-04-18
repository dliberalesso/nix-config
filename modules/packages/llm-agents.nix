{
  perSystem =
    {
      inputs',
      ...
    }:
    {
      overlayAttrs = {
        inherit (inputs'.llm-agents.packages)
          agentsview
          cli-proxy-api
          codex
          gemini-cli
          gitagent
          gitnexus
          openspec
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
        agentsview
        cli-proxy-api
        codex
        gemini-cli
        gitagent
        gitnexus
        openspec
        pi
      ];
    };

  unify.nixos = {
    nix.settings = {
      extra-substituters = [
        "https://cache.numtide.com"
      ];

      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
  };
}

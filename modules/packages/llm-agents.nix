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
          claw-code
          cli-proxy-api
          gemini-cli
          gitagent
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
        claw-code
        cli-proxy-api
        gemini-cli
        gitagent
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

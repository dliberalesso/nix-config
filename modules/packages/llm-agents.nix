{
  inputs,
  ...
}:
{
  perSystem = {
    nixpkgs.overlays = [
      inputs.llm-agents.overlays.default
    ];
  };

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        gemini-cli
        opencode-desktop
        spec-kit
      ];
    };
}

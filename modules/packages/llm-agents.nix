{
  inputs,
  ...
}:
{
  unify.home =
    {
      pkgs,
      ...
    }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      llmAgentPackages = inputs.llm-agents.packages.${system};
    in
    {
      home.packages =
        (with pkgs; [
          nodejs
        ])
        ++ (with llmAgentPackages; [
          antigravity-cli
          codex
          herdr
          hunk
          mcporter
          nono
          openspec
          pi
          rtk
          skills
        ]);

      programs.npm.enable = true;
    };
}

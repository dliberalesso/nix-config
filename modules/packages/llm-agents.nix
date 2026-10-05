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
          codex
          herdr
          hunk
          pi
          skills
        ]);

      programs.npm.enable = true;
    };
}

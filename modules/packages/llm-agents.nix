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
          (python3.withPackages (ps: [
            ps.huggingface-hub
            ps.unsloth
          ]))

          nodejs
        ])
        ++ (with llmAgentPackages; [
          antigravity-cli
          codex
          herdr
          hunk
          mcporter
          pi
          rtk
          skills
        ]);

      programs.npm.enable = true;
    };
}

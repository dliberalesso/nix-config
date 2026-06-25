{
  perSystem =
    {
      inputs',
      ...
    }:
    {
      overlayAttrs = inputs'.llm-agents.packages;
    };

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        (python3.withPackages (ps: [
          ps.huggingface-hub
          ps.unsloth
        ]))

        nodejs

        antigravity-cli
        codex
        herdr
        hunk
        mcporter
        pi
        rtk
        skills
      ];

      programs.npm.enable = true;
    };
}

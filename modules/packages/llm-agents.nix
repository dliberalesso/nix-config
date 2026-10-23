{
  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        nodejs

        llm-agents.antigravity-cli
        llm-agents.codex
        llm-agents.herdr
        llm-agents.hunk
        llm-agents.pi
        llm-agents.skills
      ];

      programs.npm.enable = true;
    };
}

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
        llm-agents.opencode2
        llm-agents.pi
        llm-agents.skills
      ];

      programs.npm.enable = true;
    };

  unify.modules.gui.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        llm-agents.bb-app
        llm-agents.chatgpt
        llm-agents.opencode2-desktop
      ];
    };
}

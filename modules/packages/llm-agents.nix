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
        (writeShellScriptBin "opencode" ''
          exec ${llm-agents.opencode2}/bin/opencode2 "$@"
        '')
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
        bb-app
        llm-agents.chatgpt
        llm-agents.opencode2-desktop
      ];
    };
}

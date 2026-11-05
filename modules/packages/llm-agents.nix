{
  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs.llm-agents; [
        pkgs.nodejs

        antigravity-cli
        claude-code
        codex
        herdr
        herdr-core
        hunk
        opencode2
        pi
        skills
      ];

      home.sessionVariables = {
        PI_CLIPBOARD_OSC52 = 1;
      };

      programs.npm.enable = true;
    };

  unify.modules.gui.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs.llm-agents; [
        chatgpt
        claude-desktop
        herdr-app
        opencode2-desktop
      ];
    };
}

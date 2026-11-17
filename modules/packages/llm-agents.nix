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
        bb-app
        beads-rust
        beads-viewer
        claude-code
        codex
        git-surgeon
        nono
        omp
        opencode2
        openspec
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
        opencode2-desktop
      ];
    };
}

{
  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs.llm-agents; [
        pkgs.nodejs
        pkgs.openssl # maki needs this

        antigravity-cli
        beads-rust
        beads-viewer
        claude-code
        codex
        herdr-core
        maki
        nono
        omp
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

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
        codex
        herdr
        hunk
        opencode2
        pi
        skills
      ];

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
        opencode2-desktop
      ];
    };
}

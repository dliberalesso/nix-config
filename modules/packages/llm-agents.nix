{
  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs.llm-agents; [
        pkgs.nodejs

        codex
        herdr
        hunk
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
      ];
    };
}

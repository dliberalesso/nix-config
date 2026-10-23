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
        pi
        skills
      ];

      programs.npm.enable = true;
    };
}

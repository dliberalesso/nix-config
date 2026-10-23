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
        nono
        openspec
        pi
        skills
      ];

      programs.npm.enable = true;
    };
}

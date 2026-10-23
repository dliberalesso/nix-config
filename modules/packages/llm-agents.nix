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

      programs.npm.enable = true;
    };
}

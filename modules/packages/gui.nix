{
  unify.modules.gui.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = builtins.attrValues {
        inherit (pkgs)
          antigravity
          google-chrome
          obsidian
          prismlauncher
          qalculate-qt
          spotify
          vesktop # Discord
          ;
      };
    };
}

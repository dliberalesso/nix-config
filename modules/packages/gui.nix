{
  unify.modules.gui.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = builtins.attrValues {
        inherit (pkgs)
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

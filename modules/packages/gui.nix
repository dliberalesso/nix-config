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

      xdg.mimeApps.defaultApplications = {
        "text/html" = [ "google-chrome.desktop" ];
        "x-scheme-handler/http" = [ "google-chrome.desktop" ];
        "x-scheme-handler/https" = [ "google-chrome.desktop" ];
      };
    };
}

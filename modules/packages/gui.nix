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
          ;
      };

      xdg.mimeApps.defaultApplications = {
        "text/html" = [ "google-chrome.desktop" ];
        "x-scheme-handler/http" = [ "google-chrome.desktop" ];
        "x-scheme-handler/https" = [ "google-chrome.desktop" ];
      };
    };
}

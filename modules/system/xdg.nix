{
  unify = {
    home =
      {
        config,
        ...
      }:
      let
        mkDirStr = dir: "${config.home.homeDirectory}/${dir}";
      in
      {
        xdg.userDirs = {
          enable = true;

          documents = mkDirStr "documents";
          desktop = mkDirStr "desktop";
          download = mkDirStr "downloads";
          music = mkDirStr "music";
          pictures = mkDirStr "pictures";
          publicShare = mkDirStr "public";
          templates = mkDirStr "templates";
          videos = mkDirStr "videos";

          extraConfig = {
            XDG_PROJECTS_DIR = mkDirStr "projects";
            XDG_MISC_DIR = mkDirStr "misc";
          };
        };
      };

    modules.hyprde.nixos =
      {
        pkgs,
        ...
      }:
      {
        xdg.portal = {
          enable = true;

          configPackages = [ pkgs.hyprland ];

          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        };
      };
  };
}

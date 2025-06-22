{
  unify.modules.hyprde.home =
    {
      lib,
      pkgs,
      ...
    }:
    let
      hypr-monitor-toggle = pkgs.writeShellApplication {
        name = "hypr-monitor-toggle";

        runtimeInputs = builtins.attrValues {
          inherit (pkgs) findutils hyprland ripgrep;
        };

        text = builtins.readFile ./hypr-monitor-toggle.sh;
      };
    in
    {
      home.packages = [
        hypr-monitor-toggle
      ];

      wayland.windowManager.hyprland.settings = {
        bindl = [
          ", XF86Favorites, exec, ${lib.getExe hypr-monitor-toggle}"
        ];

        exec-once = [
          "${lib.getExe hypr-monitor-toggle}"
        ];
      };
    };
}

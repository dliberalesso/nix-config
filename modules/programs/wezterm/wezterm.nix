{
  unify.modules.hyprde.home =
    {
      lib,
      pkgs,
      ...
    }:
    {
      wayland.windowManager.hyprland = {
        settings = {
          "$terminal" = "${lib.getExe pkgs.wezterm}";
        };
      };
    };

  unify.modules.gui.home =
    {
      config,
      ...
    }:
    {
      catppuccin.wezterm.enable = false;

      programs.wezterm.enable = true;

      xdg.configFile =
        let
          inherit (config.catppuccin.sources) wezterm;
          inherit (config.lib.file) mkOutOfStoreSymlink;
          inherit (config.home) homeDirectory;

          configPath = "${homeDirectory}/projects/nix-config/modules/programs/wezterm/wezterm.lua";
        in
        {
          "wezterm/plugin/catppuccin".source = wezterm;
          "wezterm/wezterm.lua".source = mkOutOfStoreSymlink configPath;
        };
    };
}

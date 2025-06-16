{
  home-manager.users.dli50 =
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

          configPath = "${homeDirectory}/nix-config/old_modules/programs/wezterm/wezterm.lua";
        in
        {
          "wezterm/plugin/catppuccin".source = wezterm;
          "wezterm/wezterm.lua".source = mkOutOfStoreSymlink configPath;
        };
    };
}

{
  home-manager.users.dli50 = {
    catppuccin.wezterm.apply = true;

    programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./nix_wezterm.lua;
    };
  };
}

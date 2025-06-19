{
  unify.modules.hyprde.nixos = {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      # xwayland.enable = false;
    };
  };
}

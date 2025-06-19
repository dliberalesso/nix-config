{
  unify.modules.hyprde.nixos = {
    services = {
      power-profiles-daemon.enable = true;

      # Battery and power related modules
      upower.enable = true;
    };
  };
}

{
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      # xwayland.enable = false;
    };
  };

  security.pam.services.hyprlock = { };
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true; # Battery and power related modules
  services.gvfs.enable = true; # For network cover art urls to be cached (spotify for example)
}

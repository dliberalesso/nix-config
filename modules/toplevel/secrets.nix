{
  unify.nixos =
    {
      config,
      pkgs,
      ...
    }:
    let
      waylandEnabled = config.programs.hyprland.enable;
    in
    {
      environment.systemPackages = with pkgs; [
        (if waylandEnabled then pass-wayland else pass)
        secretspec
      ];

      programs.gnupg = {
        agent = {
          enable = true;
          enableSSHSupport = true;
        };
      };
    };
}

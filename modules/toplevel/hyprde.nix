{
  unify.modules.hyprde.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.wl-clipboard ];

      home.sessionVariables.NIXOS_OZONE_WL = "1";

      services = {
        clipse.enable = true;
        hyprpolkitagent.enable = true;
      };
    };
}

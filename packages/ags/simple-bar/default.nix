{
  inputs,
  ...
}:
{
  perSystem =
    {
      inputs',
      config,
      pkgs,
      ...
    }:
    {
      packages.simple-bar = inputs.ags.lib.bundle {
        inherit pkgs;
        src = ./.;
        name = "simple-bar";
        entry = "app.ts";
        gtk4 = false;

        extraPackages = with inputs'.ags.packages; [
          battery
          hyprland
          mpris
          network
          tray
          wireplumber
        ];
      };

      overlayAttrs = {
        inherit (config.packages) simple-bar;
      };
    };
}

{
  inputs,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem =
    {
      inputs',
      config,
      pkgs,
      ...
    }:
    let
      extraPackages = with inputs'.ags.packages; [
        battery
        hyprland
        mpris
        network
        tray
        wireplumber
      ];
    in
    {
      packages.simple-bar = inputs.ags.lib.bundle {
        inherit extraPackages pkgs;
        src = ./.;
        name = "simple-bar";
        entry = "app.ts";
        gtk4 = false;
      };

      devShells.simple-bar = pkgs.mkShell {
        buildInputs = [
          # includes astal3 astal4 astal-io by default
          (inputs'.ags.packages.default.override {
            inherit extraPackages;
          })
        ];
      };

      overlayAttrs = {
        inherit (config.packages) simple-bar;
      };
    };
}

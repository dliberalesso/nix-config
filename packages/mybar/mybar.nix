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
    {
      packages.mybar = inputs.ags.lib.bundle {
        inherit pkgs;

        name = "mybar";
        entry = "app.ts";

        extraPackages = with inputs'.ags.packages; [
          battery
          hyprland
          mpris
          network
          tray
          wireplumber
        ];

        gtk4 = true;

        src = builtins.path {
          path = ./.;
          name = "source";
        };
      };

      devShells.mybar = pkgs.mkShell {
        buildInputs = [ inputs'.ags.packages.agsFull ];
      };

      overlayAttrs = { inherit (config.packages) mybar; };
    };
}

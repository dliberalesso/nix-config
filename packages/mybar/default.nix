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
      packages.mybar = inputs.ags.lib.bundle {
        inherit pkgs;
        src = ./.;
        name = "mybar";
        entry = "app.ts";
        gtk4 = true;

        extraPackages = with inputs'.ags.packages; [
          battery
          hyprland
          mpris
          network
          tray
          wireplumber
        ];
      };

      devShells.mybar = pkgs.mkShell {
        buildInputs = [
          inputs'.ags.packages.agsFull
        ];
      };

      overlayAttrs = { inherit (config.packages) mybar; };
    };
}

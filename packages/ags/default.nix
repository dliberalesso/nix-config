{
  imports = [
    # ./mybar
    ./simple-bar
  ];

  perSystem =
    {
      inputs',
      pkgs,
      ...
    }:
    {
      devShells.ags = pkgs.mkShell {
        buildInputs = [
          inputs'.ags.packages.agsFull
        ];
      };
    };
}

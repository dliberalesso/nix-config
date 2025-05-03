{
  inputs,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay

    # ./ags
    ./libratbag
  ];
}

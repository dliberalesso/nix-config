{
  inputs,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay

    ./libratbag
  ];
}

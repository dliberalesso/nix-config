{
  inputs,
  ...
}:
{
  imports = [
    ../hosts

    (inputs.import-tree ../packages)
  ];
}

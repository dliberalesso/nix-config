{
  inputs,
  ...
}:
{
  imports =
    [ ../hosts/old.nix ]
    ++ map inputs.import-tree [
      # ../hosts
      ../packages
    ];

  # debug = true;
}

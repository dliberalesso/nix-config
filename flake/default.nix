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

  debug = true;

  # TODO: Should be a merge from the values set on hosts
  systems = [ "x86_64-linux" ];
}

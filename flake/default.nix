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
      ../scripts
    ];

  # WARN: Keep this to help debugging in the REPL
  debug = false;

  # TODO: Should be a merge from the values set on hosts
  systems = [ "x86_64-linux" ];
}

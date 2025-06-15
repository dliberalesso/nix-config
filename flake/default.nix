{
  inputs,
  ...
}:
{
  imports = [
    ../to_migrate/hosts/old.nix

    (inputs.import-tree [
      # ../hosts
      ../packages
      ../scripts
    ])
  ];

  # WARN: Keep this to help debugging in the REPL
  debug = false;

  # TODO: Should be a merge from the values set on hosts
  systems = [ "x86_64-linux" ];
}

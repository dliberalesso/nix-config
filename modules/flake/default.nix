{
  inputs,
  ...
}:
{
  imports = [
    inputs.unify.flakeModule
  ];

  # WARN: Keep this to help debugging in the REPL
  debug = false;

  # TODO: Should be a merge from the values set on hosts
  systems = [ "x86_64-linux" ];
}

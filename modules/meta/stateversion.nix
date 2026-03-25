let
  stateVersion = "26.05";
in
{
  unify = {
    home.home = { inherit stateVersion; };

    nixos.system = { inherit stateVersion; };
  };
}

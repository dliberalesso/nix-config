{
  unify.home.programs = {
    carapace.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}

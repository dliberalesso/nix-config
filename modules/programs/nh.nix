{
  unify.nixos =
    {
      hostConfig,
      ...
    }:
    {
      environment.variables = {
        NH_NO_CHECKS = 1;
      };

      programs.nh = {
        enable = true;

        clean = {
          enable = true;
          extraArgs = "--keep 3 --keep-since 8d";
        };

        flake = hostConfig.flakePath;
      };
    };
}

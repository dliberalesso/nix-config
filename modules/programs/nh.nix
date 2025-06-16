{
  unify =
    let
      NH_NO_CHECKS = 1;

      configFor = flakePath: {
        enable = true;

        clean = {
          enable = true;
          extraArgs = "--keep 3 --keep-since 8d";
        };

        flake = flakePath;
      };
    in
    {
      home =
        {
          config,
          ...
        }:
        {
          home.sessionVariables = { inherit NH_NO_CHECKS; };

          programs = {
            nh = configFor "${config.home.homeDirectory}/nix-config";
          };
        };

      nixos =
        {
          hostConfig,
          ...
        }:
        {
          environment.variables = { inherit NH_NO_CHECKS; };

          programs = {
            nh = configFor "/home/${hostConfig.user.username}/nix-config";
          };
        };
    };
}

{
  unify = {
    home =
      {
        hostConfig,
        lib,
        ...
      }:
      let
        inherit (hostConfig.user) username;
      in
      {
        home = {
          inherit username;

          homeDirectory = "/home/${username}";
        };

        # Workaround home-manager bug
        # https://github.com/nix-community/home-manager/issues/2033
        news = {
          display = "silent";
          entries = lib.mkForce [ ];
        };

        # Reload system units on config change
        systemd.user.startServices = "sd-switch";

        xdg.enable = true;
      };

    nixos.home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}

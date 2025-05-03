{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users.dli50 = {
      programs.home-manager.enable = true;
      xdg.enable = true;

      home = rec {
        inherit (config.system) stateVersion;

        username = "dli50";
        homeDirectory = "/home/${username}";
      };

      home.packages = [ pkgs.cachix ];

      systemd.user.startServices = "sd-switch"; # Reload system units on config change
    };
  };
}

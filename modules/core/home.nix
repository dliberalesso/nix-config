{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  username = "dli50";
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users.${username} = {
      home = {
        inherit (config.system) stateVersion;
        inherit username;

        homeDirectory = "/home/${username}";

        packages = [ pkgs.cachix ];
      };

      # Workaround home-manager bug
      # https://github.com/nix-community/home-manager/issues/2033
      news = {
        display = "silent";
        entries = lib.mkForce [ ];
      };

      systemd.user.startServices = "sd-switch"; # Reload system units on config change

      xdg.enable = true;
    };
  };
}

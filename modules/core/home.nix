{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users.dli50 = {
      programs.home-manager.enable = true;
      xdg.enable = true;

      home = rec {
        username = "dli50";
        homeDirectory = "/home/${username}";
        stateVersion = "25.05";
      };

      home.sessionVariables.NIXOS_OZONE_WL = "1";

      home.packages = with pkgs; [
        cachix
      ];

      systemd.user.startServices = "sd-switch"; # Reload system units on config change
    };
  };
}

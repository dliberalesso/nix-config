{
  inputs,
  ...
}:
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    ../../modules/catppuccin.nix

    ../common.nix

    ./audio.nix
    ./boot.nix
    ./fonts.nix
    ./greetd.nix
    ./hardware-configuration.nix
    ./hyperion.nix
    ./hyprland.nix
    ./input.nix
    ./locale.nix
    ./network.nix
    ./nvidia.nix
    ./pcscd.nix
    ./xdg.nix
  ];

  hostName = "nixavell";

  nixos = {
    audio.enable = true;
    boot.enable = true;
    fonts.enable = true;
    greetd.enable = true;
    hyperion.enable = true;
    hyprland.enable = true;
    locale.enable = true;
    network.enable = true;
    nvidia.enable = true;
    pcscd.enable = true;
    xdg.enable = true;
  };

  services.logind.lidSwitchExternalPower = "ignore";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dli50 = {
    isNormalUser = true;
    description = "Douglas Liberalesso";
    extraGroups = [
      "audio"
      "networkmanager"
      "wheel"
    ];
  };
}

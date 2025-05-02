{
  imports = [
    ./espanso

    ./audio.nix
    ./boot.nix
    ./fonts.nix
    ./greetd.nix
    ./hardware-configuration.nix
    ./hyperion.nix
    ./hyprland.nix
    ./keyboard.nix
    ./locale.nix
    ./mouse.nix
    ./network.nix
    ./nvidia.nix
    ./pcscd.nix
    ./xdg.nix
  ];

  services.logind.lidSwitchExternalPower = "ignore";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dli50 = {
    isNormalUser = true;
    description = "Douglas Liberalesso";
    extraGroups = [
      "audio"
      "input"
      "networkmanager"
      "video"
      "wheel"
    ];
  };
}

{
  imports = [
    ./audio.nix
    ./boot.nix
    ./hardware-configuration.nix
    ./hyperion.nix
    ./keyboard.nix
    ./locale.nix
    ./mouse.nix
    ./network.nix
    ./nvidia.nix
    ./pcscd.nix
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

{
  user,
  ...
}:
{
  imports = [
    ./audio.nix
    ./boot.nix
    ./hardware-configuration.nix
    ./hyperion.nix
    ./keyboard.nix
    ./kernel.nix
    ./locale.nix
    ./mouse.nix
    ./network.nix
    ./nvidia.nix
    ./pcscd.nix
  ];

  services.logind.lidSwitchExternalPower = "ignore";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user.username} = {
    isNormalUser = true;
    description = "${user.name}";

    extraGroups = [
      "audio"
      "input"
      "networkmanager"
      "video"
      "wheel"
    ];
  };
}

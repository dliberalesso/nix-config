{ inputs
, pkgs
, ...
}: {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    ../../modules/catppuccin.nix

    ../common.nix

    ./hardware-configuration.nix
    ./hyperion.nix
    ./input.nix
    ./nvidia.nix
  ];

  environment.systemPackages = with pkgs; [
    pcsc-tools
  ];

  services.pcscd = {
    enable = true;
    plugins = [ pkgs.pcsc-safenet ];
  };

  programs.firefox = {
    enable = true;

    policies.SecurityDevices.Add = {
      "PKCS#11 JFRS" = "${pkgs.pcsc-safenet}/lib/libeToken.so";
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixavell";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs; [
    monaspace
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dli50 = {
    isNormalUser = true;
    description = "Douglas Liberalesso";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}

{
  unify.modules.laptop.nixos = {
    time = {
      timeZone = "America/Sao_Paulo";

      # Because of Windows dualboot
      hardwareClockInLocalTime = true;
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
        LC_ADDRESS = "pt_BR.UTF-8";
        LC_CTYPE = "pt_BR.UTF-8";
        LC_IDENTIFICATION = "pt_BR.UTF-8";
        LC_MEASUREMENT = "pt_BR.UTF-8";
        LC_MONETARY = "pt_BR.UTF-8";
        LC_NAME = "pt_BR.UTF-8";
        LC_NUMERIC = "pt_BR.UTF-8";
        LC_PAPER = "pt_BR.UTF-8";
        LC_TELEPHONE = "pt_BR.UTF-8";
        LC_TIME = "pt_BR.UTF-8";
      };

      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "pt_BR.UTF-8/UTF-8"
      ];
    };
  };
}

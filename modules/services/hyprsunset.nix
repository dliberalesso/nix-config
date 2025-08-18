{
  unify.modules.hyprde.home = {
    services.hyprsunset = {
      enable = true;
      extraArgs = [ "--identity" ];

      settings = {
        profile = [
          {
            time = "06:00";
            temperature = 6500;
            identity = true;
          }
          {
            time = "18:00";
            temperature = 5000;
          }
        ];
      };
    };
  };
}

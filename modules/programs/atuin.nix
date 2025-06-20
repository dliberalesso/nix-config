{
  unify.home.programs = {
    atuin = {
      enable = true;

      daemon.enable = true;

      flags = [
        "--disable-up-arrow"
      ];

      settings = {
        sync_frequency = "5m";
      };
    };
  };
}

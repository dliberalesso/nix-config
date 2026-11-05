{
  unify.modules.wsl.nixos = {
    services.openssh = {
      enable = true;
      ports = [ 2222 ];

      settings = {
        PubkeyAuthentication = true;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}

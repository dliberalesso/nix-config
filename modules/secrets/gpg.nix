{
  unify.nixos = {
    programs.gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true; # Optional: for SSH agent forwarding
      };
    };
  };
}

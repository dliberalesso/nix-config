{
  unify.modules.gui.home.programs = {
    zathura.enable = true;
  };

  unify.modules.gui.nixos =
    { lib, ... }:
    {
      # niri enables gnome-keyring by default, which also enables the GCR ssh-agent;
      # only one agent may be installed at a time.
      services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

      programs.ssh.startAgent = true;
    };
}

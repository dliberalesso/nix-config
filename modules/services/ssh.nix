{
  unify.modules = {
    gui = {
      home =
        { lib, pkgs, ... }:
        let
          # the gcr-ssh-agent preloads ~/.ssh keys and decrypts them on demand,
          # taking the passphrase from the PAM-unlocked gnome-keyring — the
          # wrapper only needs to point ssh-keygen at the gcr socket
          sshSignEnsure = pkgs.writeShellApplication {
            name = "ssh-sign-ensure";
            runtimeInputs = [ pkgs.openssh ];
            text = ''
              if [ "''${1:-}" = "-Y" ] && [ "''${2:-}" = "sign" ]; then
                export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
              fi
              exec ssh-keygen "$@"
            '';
          };
        in
        {
          programs.git.signing.signer = lib.getExe sshSignEnsure;

          sshAuthSock = {
            enable = true;
            initialization.bash = ''export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"'';
            systemd.socketProviderUnit = "gcr-ssh-agent.service";
          };
        };

      nixos = _: {
        # niri enables gnome-keyring by default for libsecret; its GCR ssh-agent
        # provides the session agent — nixpkgs forbids a second agent alongside it.
        # The agent stores the key passphrase in the gnome-keyring login
        # collection, which pam_gnome_keyring unlocks at the greeter
        # (see modules/toplevel/niride.nix).
        services.gnome.gcr-ssh-agent.enable = true;

        programs.ssh.extraConfig = "AddKeysToAgent yes";
      };
    };

    wsl.nixos = {
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
  };
}

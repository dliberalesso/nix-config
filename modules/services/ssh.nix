_:
let
  # gcr-ssh-agent (gui) and wsl2-ssh-agent (wsl) both expose a session socket;
  # the wrapper only points ssh-keygen at it when signing
  sshSignEnsure =
    pkgs: socket:
    pkgs.writeShellApplication {
      name = "ssh-sign-ensure";
      runtimeInputs = [ pkgs.openssh ];
      text = ''
        if [ "''${1:-}" = "-Y" ] && [ "''${2:-}" = "sign" ]; then
          export SSH_AUTH_SOCK="${socket}"
        fi
        exec ssh-keygen "$@"
      '';
    };
in
{
  unify.modules = {
    gui = {
      home =
        { lib, pkgs, ... }:
        {
          programs.git.signing.signer = lib.getExe (sshSignEnsure pkgs "$XDG_RUNTIME_DIR/gcr/ssh");

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

    wsl = {
      home =
        { lib, pkgs, ... }:
        {
          programs.git.signing.signer = lib.getExe (
            sshSignEnsure pkgs "$XDG_RUNTIME_DIR/wsl2-ssh-agent.sock"
          );

          # nixos-wsl bridges the Windows ssh-agent onto this socket
          # (modules/toplevel/wsl.nix); exporting it here reaches non-login
          # shells (jj) as well as the git signer wrapper
          sshAuthSock = {
            enable = true;
            initialization.bash = ''export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/wsl2-ssh-agent.sock"'';
            systemd.socketProviderUnit = "wsl2-ssh-agent.service";
          };
        };

      nixos = {
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
  };
}

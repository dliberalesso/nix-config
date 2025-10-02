{
  unify.modules.podman.nixos =
    {
      hostConfig,
      pkgs,
      ...
    }:
    let
      inherit (hostConfig.user) username;
    in
    {
      boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

      environment.systemPackages = [ pkgs.podman-compose ];

      users.users.${username} = {
        extraGroups = [
          "podman"
        ];
      };

      virtualisation = {
        containers.enable = true;

        oci-containers.backend = "podman";

        podman = {
          enable = true;
          dockerCompat = true;

          # Required for containers under podman-compose to be able to talk to each other.
          defaultNetwork.settings.dns_enabled = true;
        };
      };
    };
}

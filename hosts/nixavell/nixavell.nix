{
  config,
  ...
}:
let
  hostName = "nixavell";

  args = import ../_args.nix hostName;

  inherit (config) unify;
in
{
  imports = [ args ];

  unify.hosts.nixos.${hostName} =
    {
      config,
      ...
    }:
    {
      modules = builtins.attrValues {
        inherit (unify.modules)
          facter
          gui
          irpf
          laptop
          ;
      };

      nixos = {
        imports = [
          ../../old_modules/hyprde

          ./_filesystem.nix
        ];

        # Don't forget to set a password with ‘passwd’.
        users.users.${config.user.username} = {
          isNormalUser = true;
          description = config.user.name;

          extraGroups = [
            "audio"
            "input"
            "networkmanager"
            "video"
            "wheel"
          ];
        };
      };

      users.${config.user.username} = { inherit (config) modules; };
    };
}

{
  config,
  ...
}:
let
  inherit (config.unify) modules;

  hostName = "nixavell";
in
{
  unify.hosts.nixos.${hostName} =
    {
      config,
      ...
    }:
    let
      inherit (config.user) name username;
    in
    {
      modules = builtins.attrValues {
        inherit (modules)
          facter
          gui
          hyprde
          irpf
          laptop
          ;
      };

      nixos = {
        imports = [ ./_filesystem.nix ];

        # Don't forget to set a password with ‘passwd’.
        users.users.${username} = {
          isNormalUser = true;
          description = name;

          extraGroups = [
            "audio"
            "input"
            "networkmanager"
            "video"
            "wheel"
          ];
        };
      };

      users.${username} = { inherit (config) modules; };
    };
}

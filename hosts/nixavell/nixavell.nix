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
      inherit (config.user) username;
    in
    {
      modules = builtins.attrValues {
        inherit (modules)
          facter
          gui
          hyprde
          # irpf
          laptop
          work
          ;
      };

      nixos = {
        imports = [ ./_filesystem.nix ];

        nixpkgs.hostPlatform.system = "x86_64-linux";

        # Don't forget to set a password with ‘passwd’.
        users.users.${username} = {
          extraGroups = [
            "audio"
            "input"
            "networkmanager"
            "video"
          ];
        };
      };

      users.${username} = { inherit (config) modules; };
    };
}

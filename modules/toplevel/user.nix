{
  unify.nixos =
    {
      hostConfig,
      ...
    }:
    let
      inherit (hostConfig.user) name username;
    in
    {
      users.users.${username} = {
        description = name;

        extraGroups = [ "wheel" ];

        isNormalUser = true;
      };
    };
}

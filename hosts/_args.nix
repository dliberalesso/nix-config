# TODO: Maybe remove at the end
hostName:
{
  inputs,
  ...
}:
{
  unify.hosts.nixos.${hostName} =
    {
      config,
      ...
    }:
    let
      inherit (config) user;
    in
    {
      args = {
        inherit inputs user;

        hm = args: {
          home-manager.users.${user.username} = args;
        };
      };

      users.${user.username} = { };
    };
}

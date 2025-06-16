{
  unify.nixos =
    {
      hostConfig,
      ...
    }:
    {
      networking.hostName = hostConfig.name;
    };
}

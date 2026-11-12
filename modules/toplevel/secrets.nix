{
  unify.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        age
        passage
        secretspec
      ];
    };
}

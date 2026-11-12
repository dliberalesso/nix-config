{
  unify.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        age
        gnupg
        passage
        secretspec
      ];
    };
}

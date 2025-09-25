{
  unify.nixos =
    let
      allowed-users = [ "@wheel" ];
    in
    {
      nix.settings = {
        inherit allowed-users;

        always-allow-substitutes = true;

        auto-optimise-store = true;

        experimental-features = [
          "flakes"
          "nix-command"
        ];

        trusted-substituters = [
          "https://dliberalesso.cachix.org"
          "https://nix-community.cachix.org"
          "https://cachix.cachix.org"
        ];

        trusted-public-keys = [
          "dliberalesso.cachix.org-1:7qs1S5Qd766dYFU86nVux/wRMZ8UEUbhn3Qxp/TwiOc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        ];

        trusted-users = allowed-users;
      };
    };
}

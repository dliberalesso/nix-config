{
  perSystem =
    {
      inputs',
      pkgs,
      ...
    }:
    let
      inherit (inputs'.bun2nix.packages) bun2nix;
      inherit (inputs'.llm-agents.packages) bun-bin formatelf;

      thinkrail = pkgs.callPackage ./_thinkrail.nix {
        inherit bun-bin bun2nix formatelf;
      };

      thinkrail-desktop = pkgs.callPackage ./_desktop.nix {
        inherit
          bun-bin
          bun2nix
          formatelf
          thinkrail
          ;
      };
    in
    {
      overlayAttrs = {
        inherit thinkrail thinkrail-desktop;
      };

      packages = {
        inherit thinkrail thinkrail-desktop;
      };
    };

  unify.modules.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.thinkrail ];
    };

  unify.modules.gui.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.thinkrail-desktop ];
    };
}

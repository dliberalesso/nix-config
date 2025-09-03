{
  perSystem =
    {
      inputs',
      ...
    }:
    {
      overlayAttrs = {
        inherit (inputs'.nix-ai-tools.packages) gemini-cli;
      };
    };

  unify.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.gemini-cli ];
    };
}

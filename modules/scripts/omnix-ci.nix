{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.omnix-ci = pkgs.writeShellApplication {
        name = "omnix-ci";

        meta.description = ''
          Build all flake outputs with omnix
        '';

        runtimeInputs = [ pkgs.omnix ];

        text = ''
          om ci
        '';
      };
    };
}

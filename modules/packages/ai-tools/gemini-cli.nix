{
  pins,
  ...
}:
{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      gemini-cli-src = pins.gemini-cli { inherit pkgs; };

      npmDepsHash = "sha256-0Tbwco+9Int7krl2bsphCMPtObJtJhYw8X3zyof30qA=";

      src = gemini-cli-src // {
        rev = gemini-cli-src.revision;
      };

      version = lib.strings.removePrefix "v" src.version;
    in
    {
      packages = { inherit (pkgs) gemini-cli; };

      overlayAttrs = {
        gemini-cli = pkgs.gemini-cli.overrideAttrs (oa: {
          inherit npmDepsHash src version;

          npmDeps = pkgs.fetchNpmDeps {
            inherit src;
            name = "${oa.pname}-${version}-npm-deps";
            hash = npmDepsHash;
          };
        });
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

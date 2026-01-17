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

      # npmDepsHash = lib.fakeHash;
      npmDepsHash = "sha256-1hHPXYgeinK7SxF9yvQBCHYO7H1htnED3ot7wFzHDn0=";

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

          postInstall = ''
            # Remove broken symlink to missing CONTRIBUTING.md
            rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-core/dist/docs/CONTRIBUTING.md
          '';
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

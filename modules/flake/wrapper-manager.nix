{
  inputs,
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
      inherit (lib) mkOption types;
    in
    {
      options.wrapper-manager = mkOption {
        type = types.lazyAttrsOf types.raw;
        internal = true;

        default = { };

        apply =
          attrs:
          (inputs.wrapper-manager.lib {
            inherit pkgs;

            modules = [
              {
                wrappers = attrs;
              }
            ];
          }).config.build.packages;
      };
    };
}

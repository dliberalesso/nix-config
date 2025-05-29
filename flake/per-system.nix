{
  inputs,
  self,
  ...
}:
{
  imports = with inputs; [
    git-hooks.flakeModule
    treefmt-nix.flakeModule
  ];

  perSystem =
    {
      config,
      pkgs,
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;

        overlays = [
          inputs.hyprpanel.overlay
          inputs.neovim-nightly-overlay.overlays.default
          self.overlays.default
        ];

        config.allowUnfree = true;
      };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          git
          just
          nh
        ];

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };

      pre-commit = {
        check.enable = true;

        settings.hooks = {
          treefmt.enable = true;
          treefmt.package = config.treefmt.build.wrapper;
        };
      };

      treefmt = {
        projectRootFile = "flake.nix";

        programs = {
          deadnix.enable = true;
          prettier.enable = true;
          nixfmt.enable = true;
          shfmt.enable = true;
          stylua.enable = true;
          statix.enable = true;
          taplo.enable = true;
        };
      };
    };
}

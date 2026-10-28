{
  perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      overlayAttrs = { inherit (config.packages) zennotes-tui; };

      packages = {
        zennotes-tui = pkgs.buildGoModule (finalAttrs: {
          pname = "zennotes-tui";
          version = "0.12.2";

          src = pkgs.fetchFromGitHub {
            owner = "ZenNotes";
            repo = "tui";
            tag = "v${finalAttrs.version}";

            # hash = lib.fakeHash;
            hash = "sha256-syXxQBB83R9ZJj+DDW7xzt4epZfyjA5ukkzS2gnF7fU=";
          };

          subPackages = [ "cmd/zn" ];

          # vendorHash = lib.fakeHash;
          vendorHash = "sha256-sGHO+48ghb14bx0R8aT1lrYuG85h2MP7ZtIhwL/tzfY=";

          ldflags = [
            "-s"
            "-w"
            "-X github.com/ZenNotes/tui/internal/cli.Version=${finalAttrs.version}"
          ];

          env.CGO_ENABLED = 0;

          meta = {
            description = "ZenNotes in the terminal: a scriptable CLI, a full terminal workspace, and an MCP server in one Go binary.";
            homepage = "https://github.com/ZenNotes/tui";
            license = lib.licenses.mit;
            mainProgram = "zn";
          };
        });
      };
    };

  unify.modules.wsl.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.zennotes-tui ];
    };
}

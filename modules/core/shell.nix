{
  pkgs,
  ...
}:
{
  environment.shells = [ pkgs.fish ];

  programs.fish.enable = true;

  users.defaultUserShell = pkgs.fish;

  home-manager.users.dli50 = {
    home.shell.enableFishIntegration = true;

    programs = {
      fish = {
        enable = true;

        interactiveShellInit = ''
          set -g fish_greeting
          set -gx fish_term24bit 1
          set -gx COLORTERM truecolor
        '';
      };

      carapace.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      starship = {
        enable = true;

        settings = {
          # Format
          username.format = "[$user]($style) on ";

          # Nerd Font Symbols
          aws.symbol = "  ";
          buf.symbol = " ";
          bun.symbol = " ";
          c.symbol = " ";
          cpp.symbol = " ";
          cmake.symbol = " ";
          conda.symbol = " ";
          crystal.symbol = " ";
          dart.symbol = " ";
          deno.symbol = " ";
          directory.read_only = " 󰌾";
          docker_context.symbol = " ";
          elixir.symbol = " ";
          elm.symbol = " ";
          fennel.symbol = " ";
          fossil_branch.symbol = " ";
          gcloud.symbol = "  ";
          git_branch.symbol = " ";
          git_commit.tag_symbol = "  ";
          golang.symbol = " ";
          gradle.symbol = " ";
          guix_shell.symbol = " ";
          haskell.symbol = " ";
          haxe.symbol = " ";
          hg_branch.symbol = " ";
          hostname.ssh_symbol = " ";
          java.symbol = " ";
          julia.symbol = " ";
          kotlin.symbol = " ";
          lua.symbol = " ";
          memory_usage.symbol = "󰍛 ";
          meson.symbol = "󰔷 ";
          nim.symbol = "󰆥 ";
          nix_shell.symbol = " ";
          nodejs.symbol = " ";
          ocaml.symbol = " ";
          os.symbols.NixOS = " ";
          package.symbol = "󰏗 ";
          perl.symbol = " ";
          php.symbol = " ";
          pijul_channel.symbol = " ";
          pixi.symbol = "󰏗 ";
          python.symbol = " ";
          rlang.symbol = "󰟔 ";
          ruby.symbol = " ";
          rust.symbol = "󱘗 ";
          scala.symbol = " ";
          swift.symbol = " ";
          zig.symbol = " ";
        };
      };

      zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };
    };
  };
}

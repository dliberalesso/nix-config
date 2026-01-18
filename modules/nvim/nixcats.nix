{
  inputs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    let
      excludedRtpPlugins = [
        # "ftplugin.vim"
        "indent.vim"
        "menu.vim"
        "mswin.vim"
        "plugin/gzip.vim"
        "plugin/matchit.vim"
        "plugin/matchparen.vim"
        "plugin/netrwPlugin.vim"
        "plugin/osc52.lua"
        "plugin/rplugin.vim"
        "plugin/rplugin.vim.orig"
        "plugin/spellfile.vim"
        "plugin/tohtml.vim"
        "plugin/tohtml.lua"
        "plugin/tutor.vim"
        "plugin/tarPlugin.vim"
        "plugin/zipPlugin.vim"
      ];

      postInstallCommands = map (target: "rm -f $out/share/nvim/runtime/${target}") excludedRtpPlugins;
    in
    {
      overlayAttrs = {
        neovim-unwrapped = pkgs.neovim-unwrapped.overrideAttrs (oa: {
          postInstall = ''
            ${oa.postInstall or ""}
            ${builtins.concatStringsSep "\n" postInstallCommands}
          '';
        });
      };
    };

  unify.home =
    {
      hostConfig,
      ...
    }:
    let
      inherit (inputs.nixCats) utils;
    in
    {
      imports = [ inputs.nixCats.homeModule ];

      home.sessionVariables.EDITOR = "nvim";

      nixCats = {
        enable = true;

        addOverlays = [ (utils.standardPluginOverlay inputs) ];

        packageNames = [ "nvim" ];

        luaPath = ./.;

        categoryDefinitions.replace =
          {
            pkgs,
            ...
          }:
          {
            lspsAndRuntimeDeps = {
              general = with pkgs; [
                marksman
                prettierd
                shfmt
                taplo
                vscode-langservers-extracted
                yaml-language-server
              ];

              go = with pkgs; [
                gopls
                delve
                golint
                golangci-lint
                gotools
                go-tools
                go
              ];

              lua = with pkgs; [
                lua-language-server
                selene
                stylua
              ];

              nix = with pkgs; [
                deadnix
                nixd
                nixfmt
                statix
              ];
            };

            startupPlugins.general = with pkgs.vimPlugins; [
              snacks-nvim
              vim-sleuth
            ];

            optionalPlugins = {
              general = with pkgs.vimPlugins; [
                catppuccin-nvim
                nui-nvim
                hunk-nvim
                pkgs.neovimPlugins.jj-diffconflicts
                vim-jjdescription
                mini-nvim
                nvim-lspconfig
                vim-startuptime
                blink-cmp
                nvim-treesitter-textobjects
                nvim-treesitter.withAllGrammars
                lualine-nvim
                lualine-lsp-progress
                gitsigns-nvim
                which-key-nvim
                nvim-lint
                conform-nvim
                nvim-dap
                nvim-dap-ui
                nvim-dap-virtual-text
                render-markdown-nvim
              ];

              lua = with pkgs; [
                neovimPlugins.wezterm-types

                vimPlugins.lazydev-nvim
              ];
            };

            extraLuaPackages.general = p: [
              p.jsregexp
              p.lze
              p.lzextras
            ];

            optionalLuaPreInit.general = [ "vim.loader.enable()" ];
          };

        packageDefinitions.replace.nvim =
          {
            pkgs,
            ...
          }:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = "UNWRAP_NVIM";

              unwrappedCfgPath = "${hostConfig.flakePath}/modules/nvim";

              aliases = [
                "vi"
                "vim"
              ];

              hosts = {
                node.enable = false;
                perl.enable = false;
                python.enable = false;
                ruby.enable = false;
              };
            };

            categories = {
              general = true;
              elixir = true;
              go = true;
              lua = true;
              nix = true;
            };

            extra.nixdExtras = {
              nixpkgs = ''import "${pkgs.path}" {};'';

              nixos_options = ''((import "${pkgs.path}" {}).lib.evalModules { modules = (import "${pkgs.path}/nixos/modules/module-list.nix"); check = false; }).options ]]'';

              home_manager_options = ''(let pkgs = import "${pkgs.path}" {}; lib = import "${inputs.home-manager}/modules/lib/stdlib-extended.nix" pkgs.lib; in (lib.evalModules { modules = (import "${inputs.home-manager}/modules/modules.nix") { inherit lib pkgs; check = false; }; })).options'';
            };
          };
      };
    };
}

{ inputs, ... }:
let
  inherit (inputs.nixCats) utils;
in
{
  imports = [ inputs.nixCats.homeModule ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # this value, nixCats is the defaultPackageName you pass to mkNixosModules
  # it will be the namespace for your options.
  nixCats = {
    enable = true;
    # nixpkgs_version = inputs.nixpkgs;
    # this will add the overlays from ./overlays and also,
    # add any plugins in inputs named "plugins-pluginName" to pkgs.neovimPlugins
    # It will not apply to overall system, just nixCats.
    addOverlays = # (import ./overlays inputs) ++
      [ (utils.standardPluginOverlay inputs) ];
    # see the packageDefinitions below.
    # This says which of those to install.
    packageNames = [ "nvim" ];

    luaPath = ../../config/nvim;

    # the .replace vs .merge options are for modules based on existing configurations,
    # they refer to how multiple categoryDefinitions get merged together by the module.
    # for useage of this section, refer to :h nixCats.flake.outputs.categories
    categoryDefinitions.replace =
      { pkgs, ... }:
      {
        # to define and use a new category, simply add a new list to a set here,
        # and later, you will include categoryname = true; in the set you
        # provide when you build the package using this builder function.
        # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

        # lspsAndRuntimeDeps:
        # this section is for dependencies that should be available
        # at RUN TIME for plugins. Will be available to PATH within neovim terminal
        # this includes LSPs
        lspsAndRuntimeDeps = {
          general = with pkgs; [
            marksman
            prettierd
            shfmt
            taplo
            vscode-langservers-extracted
            yaml-language-server
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
          go = with pkgs; [
            gopls
            delve
            golint
            golangci-lint
            gotools
            go-tools
            go
          ];
        };

        startupPlugins = {
          general = with pkgs.vimPlugins; [
            snacks-nvim
            vim-sleuth
          ];
        };

        optionalPlugins = {
          go = with pkgs.vimPlugins; [ nvim-dap-go ];
          lua = with pkgs.vimPlugins; [ lazydev-nvim ];
          general = with pkgs.vimPlugins; [
            catppuccin-nvim
            mini-nvim
            nvim-lspconfig
            vim-startuptime
            blink-cmp
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
          ];
        };

        # shared libraries to be added to LD_LIBRARY_PATH
        # variable available to nvim runtime
        sharedLibraries = {
          general = with pkgs; [ ];
        };

        # environmentVariables:
        # this section is for environmentVariables that should be available
        # at RUN TIME for plugins. Will be available to path within neovim terminal
        environmentVariables = {
          # test = {
          #   CATTESTVAR = "It worked!";
          # };
        };

        # populates $LUA_PATH and $LUA_CPATH
        extraLuaPackages = {
          general = p: [
            p.lze
            p.lzextras
            p.jsregexp
          ];
        };

        # categories of the function you would have passed to withPackages
        extraPython3Packages = {
          # test = [ (_:[]) ];
        };

        # If you know what these are, you can provide custom ones by category here.
        # If you dont, check this link out:
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
        extraWrapperArgs = {
          # test = [
          #   '' --set CATTESTVAR2 "It worked again!"''
          # ];
        };
      };

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions.replace = {
      # These are the names of your packages
      # you can include as many as you wish.
      nvim =
        { pkgs, ... }:
        {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            suffix-path = true;
            suffix-LD = true;
            wrapRc = false;
            unwrappedCfgPath = utils.mkLuaInline "os.getenv('HOME') .. '/nix-config/config/nvim'";
            # IMPORTANT:
            # your alias may not conflict with your other packages.
            # aliases = [ "vi" "vim" ];
            viAlias = true;
            vimAlias = true;
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            withRuby = false;
            withPython3 = false;
            withNodeJs = false;
            withPerl = false;
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          # and a set of categories that you want
          categories = {
            general = true;
            lua = true;
            nix = true;
            go = false;
          };
          # anything else to pass and grab in lua with `nixCats.extra`
          extra = {
            nixdExtras.nixpkgs = "import ${pkgs.path} {}";
          };
        };
    };
  };
}

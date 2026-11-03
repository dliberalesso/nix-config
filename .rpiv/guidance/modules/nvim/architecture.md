# Neovim Layer

## Responsibility

`modules/nvim/` defines the editor distribution. It uses `nixCats` to bridge Nix-managed package pruning, plugins, and categories with native Lua configuration and Tree-sitter query overrides.

## Dependencies

- **`nixCats`**: Nix-to-Lua bridge for plugin categories and unwrapped package assembly
- **Neovim Lua API (`vim.*`)**: Native editor runtime configuration engine
- **Tree-sitter**: Query extensions augmenting syntax trees via path conventions

## Consumers

- **Home Manager**: Installs the configured `nvim` package and sets `EDITOR=nvim`
- **Git / CLI tools**: Terminal workflows invoke this editor via `EDITOR=nvim`

## Module Structure

- `nixcats.nix` — derivation pruning, plugin category definitions, and Home Manager packaging
- `init.lua` — lazy-loaded plugin specifications, LSP configs, keymaps, and autocmds
- `queries/<language>/` — Tree-sitter query extensions by language convention (e.g. `highlights.scm`)

## Nix-to-Lua Category Gating

```nix
# nixcats.nix
categoryDefinitions.replace = { pkgs, ... }: {
  optionalPlugins.general = with pkgs.vimPlugins; [ gitsigns-nvim ];
  lspsAndRuntimeDeps.nix = with pkgs; [ nixd nixfmt ];
};

packageDefinitions.replace.nvim = { ... }: {
  settings = {
    wrapRc = "UNWRAP_NVIM";
    unwrappedCfgPath = "${hostConfig.flakePath}/modules/nvim";
  };
  categories.general = true;
  categories.nix = true;
};
```

## Lazy LSP Specification (Adding a Server to Shared Infrastructure)

```lua
-- init.lua: servers plug into the shared nvim-lspconfig infrastructure
local lze = require("lze")
lze.register_handlers(require("lzextras").lsp)

lze.load({
  {
    "nixd",
    enabled = nixCats("nix") or false,
    lsp = {
      filetypes = { "nix" },
      settings = {
        nixd = { formatting = { command = { "nixfmt" } } },
      },
    },
  },
})
```

## Architectural Boundaries

- **NO plugin downloading in Lua**: all plugins and binaries are packaged in `nixcats.nix` and gated with `nixCats(...)`
- **LIVE EDITING VIA FLAKEPATH**: `wrapRc = "UNWRAP_NVIM"` loads Lua directly from `${hostConfig.flakePath}/modules/nvim` when the env var is set
- **EXTEND Tree-sitter queries via files**: place overrides in `queries/<lang>/<type>.scm` starting with `;; extends`

<important if="you are adding a new plugin, LSP, or query to this layer">
## Extending Neovim
1. Declare plugin or binary in `nixcats.nix` under the appropriate category (`lspsAndRuntimeDeps`, `optionalPlugins`)
2. Enable the category in `packageDefinitions.replace.nvim.categories`
3. Add a lazy plugin spec or LSP server config in `init.lua` gated by `nixCats("<category>")`
4. For mappings, use `vim.keymap.set` with `desc`; buffer-local actions belong in `lsp_on_attach`
5. For formatters/linters, register in Conform (`formatters_by_ft`) or nvim-lint (`linters_by_ft`)
6. For runtime pruning, add paths to `excludedRtpPlugins` in `nixcats.nix` preserving `old.postInstall`
7. Place language query overrides under `queries/<language>/highlights.scm` using `;; extends`
8. Format with `just fmt` and validate configuration with `just lint`. Runtime verification of the newly configured editor requires launching the generated nixCats wrapper (e.g. testing via `testvm` or the nixCats output package), as executing `nvim` in the current shell only checks the currently active system profile.
</important>

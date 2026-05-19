# Neovim Layer

## Responsibility

`modules/nvim/` defines the repository’s Neovim distribution. Nix chooses packages, plugins, and categories through nixCats; Lua consumes those categories to configure runtime behavior, LSPs, keymaps, and Tree-sitter tweaks.

## Dependencies

- **`nixCats`**: Core boundary between Nix packaging and Lua runtime configuration
- **Neovim Lua API**: Runtime setup uses native `vim.*` APIs instead of a framework wrapper
- **Tree-sitter queries**: Query overrides extend upstream highlights by path convention

## Consumers

- **Home Manager user config**: Enables the generated `nvim` package and default editor settings
- **Other tools**: Jujutsu and Lazygit reuse this Neovim setup as an editor/diff tool

## Module Structure

- `nixcats.nix` — package override, plugin/runtime dependency categories, nixCats package definition
- `init.lua` — runtime entrypoint, plugin specs, LSP setup, keymaps, autocmds
- `queries/<language>/` — Tree-sitter query extensions by language

## Nix Declares Categories, Lua Consumes Them

```nix
# nixcats.nix
categoryDefinitions.replace = { pkgs, ... }: {
  optionalPlugins.general = with pkgs.vimPlugins; [ gitsigns-nvim ];
};
packageDefinitions.replace.nvim.categories.general = true;
```

```lua
-- init.lua
require("lze").load({
  {
    "gitsigns.nvim",
    enabled = nixCats("general") or false,
    after = function() require("gitsigns").setup({}) end,
  },
})
```

## One LSP Spec Per Server (Shared Attach Logic)

```lua
local function lsp_on_attach(_client, bufnr)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: definition" })
end

vim.lsp.config("nixd", {
  on_attach = lsp_on_attach,
  settings = { nixd = { formatting = { command = { "nixfmt" } } } },
})
vim.lsp.enable("nixd")
```

## Architectural Boundaries

- **NO install decisions in Lua**: add plugins/LSP binaries/categories in `nixcats.nix`, then gate Lua config with `nixCats(...)`
- **KEEP query overrides minimal and path-based**: use `queries/<lang>/<type>.scm` with `;; extends` rather than patching plugin code

<important if="you are adding a new Neovim plugin, language tool, or query to this layer">
## Extending Neovim
1. Add plugin packages or runtime tools in `nixcats.nix`
2. Enable or add the relevant category on the `nvim` package definition
3. Gate Lua setup with `nixCats("<category>")`
4. Add one plugin/LSP spec in `init.lua` with lazy triggers where possible
5. Put syntax tweaks in `queries/<language>/...` using `;; extends`
</important>

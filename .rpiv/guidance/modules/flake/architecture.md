# Flake Layer

## Responsibility

`modules/flake/` owns flake-parts infrastructure: supported system architectures, devshells, formatter aggregation, pre-commit checks, and project-root resolution.

## Dependencies

- **`flake-parts`**: Per-system module framework used by all files in this directory
- **`treefmt-nix`, `git-hooks.nix`, `make-shell`, `flake-root`**: Flake tooling adapters

## Consumers

- **Root `flake.nix`**: Auto-imports these files into the root flake-parts configuration
- **Developer workflow**: CLI commands `just fmt`, `just lint`, and direnv devshells

## Module Structure

- `default.nix` — base flake settings (systems list) and `unify` flake module import
- `shell.nix` — base interactive devshell package set (`git`, `just`, `nh`, `nix`)
- `treefmt.nix, pre-commit.nix, flake-root.nix` — tooling adapters appending to `make-shells.default.inputsFrom`

## Flake-Parts Per-System Tooling Integration

```nix
{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { config, ... }:
    {
      treefmt = {
        inherit (config.flake-root) projectRootFile;
        flakeCheck = false; # pre-commit handles check in CI
      };
    };
}
```

## Devshell Composition Through `inputsFrom`

```nix
{ inputs, ... }:
{
  imports = [ inputs.make-shell.flakeModules.default ];

  perSystem =
    { config, pkgs, ... }:
    {
      make-shells.default = {
        packages = with pkgs; [
          git
          just
          nh
          nix
        ];
        inputsFrom = [
          config.flake-root.devShell
          config.treefmt.build.devShell
          config.pre-commit.devShell
        ];
      };
    };
}
```

## Architectural Boundaries

- **NO NixOS/Home Manager runtime logic here**: system and user configs belong outside `modules/flake/`
- **NO duplicate shell tool definitions**: pull devShells from sibling tooling modules via `inputsFrom`

<important if="you are adding a new flake tool integration to this layer">
## Adding Flake Tooling and Checks
1. **Flake tool integration**: Create `modules/flake/<tool>.nix`, import upstream flake module from `inputs`, configure in `perSystem`, and append shell output to `make-shells.default.inputsFrom`
2. **Formatter/Linter**: Enable in `modules/flake/treefmt.nix` via `programs.<tool>.enable = true`; pre-commit automatically delegates formatting checks to treefmt via `config ? treefmt`
3. **Pre-commit hook**: Enable in `modules/flake/pre-commit.nix` under `pre-commit.settings.hooks.<name>.enable = true` (use regex patterns for exclusions, not globs)
4. Verify with `just fmt` and `just lint`
</important>

# Flake Layer

## Responsibility

`modules/flake/` owns flake-parts infrastructure: supported systems, dev shells, formatter wiring, pre-commit hooks, and project-root integration. It is flake-level plumbing, not NixOS/Home Manager runtime config.

## Dependencies

- **`flake-parts`**: The module model used by every file in this directory
- **`make-shell`, `treefmt-nix`, `git-hooks.nix`, `flake-root`**: Each file adapts one flake integration

## Consumers

- **Root flake**: Imports these modules into the shared flake-parts graph
- **Developer commands**: `just fmt`, `just lint`, and `just debug` depend on outputs configured here

## Module Structure

- `default.nix` — base flake settings and `unify` flake-module import
- `shell.nix` — direct packages added to `make-shells.default`
- `flake-root.nix` — project-root dev-shell integration
- `treefmt.nix` — formatter/linter registry
- `pre-commit.nix` — pre-commit hook registry

## One Integration Per File (Flake-Parts Adapter)

```nix
{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = { config, ... }: {
    treefmt = {
      inherit (config.flake-root) projectRootFile;
      flakeCheck = false; # pre-commit owns this check here
    };
  };
}
```

## Shared Dev Shell Composition (`inputsFrom`, Not Duplication)

```nix
{ inputs, ... }: {
  imports = [ inputs.make-shell.flakeModules.default ];

  perSystem = { config, pkgs, ... }: {
    make-shells.default = {
      packages = with pkgs; [ git just nh nix ];
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

- **NO NixOS/Home Manager runtime behavior here**: system/user policy belongs outside `modules/flake/`
- **NO duplicate tool wiring**: prefer consuming another module’s `devShell` or option output through `config.*`

<important if="you are adding a new flake tool integration to this layer">
## Adding a New Flake Tool Integration
1. Create `modules/flake/<tool>.nix`
2. Import the upstream flake module from `inputs`
3. Configure it in `perSystem`
4. Add its shell to `make-shells.default.inputsFrom` if it exposes one
5. Use `config ? tool` guards when cross-module integration is optional
</important>

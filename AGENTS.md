# Agent Instructions for nix-config

## Build/Lint/Test Commands

- Format code: `just fmt` (runs treefmt with nixfmt, prettier, stylua, etc.)
- Lint/check: `just lint` (runs nix flake check)
- Rebuild system: `just rebuild` (rebuilds and switches NixOS)
- Update dependencies: `just update` (updates flake inputs)
- Clean store: `just clean` (garbage collect and optimize)

## Code Style Guidelines

- **Indentation**: 2 spaces for all files
- **Line endings**: LF (Unix)
- **Encoding**: UTF-8
- **Final newline**: Required
- **Trailing whitespace**: Trimmed
- **Nix**: Use nixfmt, deadnix, statix
- **Lua**: stylua (2 spaces, always call parentheses, collapse simple statements)
- **Other**: prettier with editorconfig, actionlint for workflows
- **Shell**: shellcheck and shfmt
- **TOML**: taplo
- **Pre-commit**: editorconfig-checker, trim whitespace, gitleaks

## Conventions

- Use `inherit` for common imports in Nix
- Follow existing module structure patterns
- No comments unless necessary
- Use lib.mkOption for options with proper types

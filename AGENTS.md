# Agent Instructions for nix-config

## Build/Lint/Test Commands

- Format code: `just fmt` (runs treefmt with nixfmt, prettier, stylua, etc.)
- Lint/check: `just lint` (runs nix flake check)
- Rebuild system: `just rebuild` (rebuilds and switches NixOS with nh)
- Update dependencies: `just update` (updates flake inputs)
- Diff lock file: `just diff` (shows changes to flake.lock using jj)
- Clean store: `just clean` (garbage collect and optimize with nh)
- Repair store: `just repair` (verify and repair Nix store integrity)
- Debug in REPL: `just debug` (opens nix repl with debug flag enabled)

## Architecture Guidance

- Start with `.rpiv/guidance/architecture.md` for the current project map and architectural boundaries
- Before changing a specific area, read the matching sub-guide under `.rpiv/guidance/**/architecture.md`
- Treat `.rpiv/guidance/` as the canonical architecture and workflow reference; prefer linking to it over duplicating detailed patterns here

## Architecture

- Framework: **unify** + **flake-parts** + **import-tree**
- High-level shape: `hosts/` contains concrete machines; `modules/` contains reusable capabilities, packages, programs, and profiles
- Current desktop direction: `niride` is transitional; shared graphical concerns belong in `gui`; future work may support both `niride` and `hyprde`
- Current secret-management entrypoint: `modules/toplevel/secrets.nix`

## Common Patterns

- Defining a host: see `.rpiv/guidance/hosts/architecture.md`
- Adding/changing program modules: see `.rpiv/guidance/modules/programs/architecture.md`
- Reusable system/platform changes: see `.rpiv/guidance/modules/system/architecture.md`
- Package/export changes: see `.rpiv/guidance/modules/packages/architecture.md`
- Top-level profile or desktop-session changes: see `.rpiv/guidance/modules/toplevel/architecture.md`
- Neovim/nixCats changes: see `.rpiv/guidance/modules/nvim/architecture.md`
- Flake tooling changes: see `.rpiv/guidance/modules/flake/architecture.md`
- Adding flake inputs: for eval-time inputs, follow `nix-proxy-flake/nixpkgs` where applicable; for build-time only inputs, use `buildTime = true;` and `flake = false;`
- Theme scheme plumbing: check `.rpiv/guidance/architecture.md` first because `modules/theme/scheme.nix` currently references a missing `base16` input

## Key Technologies

- **Package Manager**: Nix with flakes
- **System Builder**: nh (Nix Helper)
- **Task Runner**: just
- **VCS**: Git + Jujutsu (jj)
- **Shell**: Fish with modern CLI tools (eza, bat, fzf, zoxide, atuin)
- **Editor**: Neovim via nixCats
- **Desktop**: Niri-based desktop session today via `niride`; future direction may support both `niride` and `hyprde`
- **Theme**: Catppuccin
- **Containers**: Podman
- **Formatting**: treefmt with multiple formatters
- **AI/LLM**: Numtide llm-agents integration

## Code Style Guidelines

- **Indentation**: 2 spaces for all files
- **Line endings**: LF (Unix)
- **Encoding**: UTF-8
- **Final newline**: Required
- **Trailing whitespace**: Trimmed
- **Commit Messages**: Follow Conventional Commits and Gitmoji, but **NEVER** include a scope (e.g., use `feat: message` instead of `feat(scope): message`).
- **Lua**: stylua (2 spaces, always call parentheses, collapse simple statements)
- **Other**: prettier with editorconfig, actionlint for workflows
- **Shell**: shellcheck and shfmt
- **TOML**: taplo
- **Pre-commit**: editorconfig-checker, trim whitespace, gitleaks

## Conventions

- Use `inherit` for common imports in Nix
- For architecture patterns, read the relevant `.rpiv/guidance/**/architecture.md` before copying local examples
- Minimal comments - code should be self-documenting
- Use `lib.mkOption` for options with proper types and descriptions
- Keep host definitions in `hosts/${hostname}/${hostname}.nix`
- Hardware-specific configs go in `hosts/${hostname}/_filesystem.nix` or use facter
- WSL-specific: Note that `just rebuild` copies wezterm config to Windows
- User info is centralized in `modules/meta/user.nix`
- Split large program configs into subdirectories (e.g., `modules/programs/<program>/`)
- Secrets are currently handled in `modules/toplevel/secrets.nix`; keep any broader refactor aligned with `.rpiv/guidance/modules/toplevel/architecture.md`
- For debugging: Toggle `debug = true` in `modules/flake/default.nix` and use REPL

## Special Notes

- **WSL**: After rebuild on nixWSL, wezterm.lua is automatically copied to Windows user directory
- **Neovim**: Managed via nixCats, configuration in `modules/nvim/`, queries in `modules/nvim/queries/`
- **nixos-facter**: Used for hardware detection (see `facter.json` in host directories)
- **CI/CD**: GitHub Actions builds and caches on every push
- **Pre-commit**: Hooks are configured in `modules/flake/pre-commit.nix`; see `.rpiv/guidance/modules/flake/architecture.md`

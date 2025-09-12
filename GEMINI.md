# Gemini Collaboration Guide: Nix-Config

This guide provides essential context for AI collaboration on the Nix-Config project.

## 1. Project Overview

- **Project:** Nix-Config
- **Description:** A NixOS configuration repository using Nix Flakes for declarative system management across multiple hosts (`nixavell`, `nixwsl`, `testvm`).
- **Tech Stack:**
  - **Language:** Nix
  - **Frameworks:** NixOS, home-manager, flake-parts
  - **Key Dependencies:** `nixpkgs`, `home-manager`, `flake-parts`, `nixos-wsl`, `catppuccin`, `treefmt-nix`

## 2. Key Files

- **`flake.nix`**: The central entry point for the entire configuration.
- **`hosts/**/\*.nix`\*\*: Host-specific configurations.
- **`modules/**/\*.nix`\*\*: Shared, reusable configuration logic.
- **`justfile`**: A command runner with shortcuts for common tasks.
- **`.github/workflows/build-and-cache.yml`**: CI/CD pipeline definition.

## 3. Development Workflow

### 3.1. Key Commands

Use `just` for common tasks:

- **`just rebuild`**: Rebuild and switch to the new NixOS configuration.
- **`just update`**: Update flake inputs.
- **`just fmt`**: Format all Nix code.
- **`just lint`**: Check the Nix Flake for errors.
- **`just clean`**: Run garbage collection and optimize the Nix store.

### 3.2. Testing and Validation

- **Formatting:** Run `just fmt` or `nix fmt`.
- **Linting/Checking:** Run `just lint` or `nix flake check`.
- **Pre-commit Hooks:** Run `pre-commit run --all-files` before committing. If a hook modifies a file, stage the change and re-run the commit command.

### 3.3. Dependencies

1.  Add the new dependency to the `inputs` in `flake.nix`.
2.  Run `just update` or `nix flake update` to update `flake.lock`.

### 3.4. Commit Messages

- **Tooling:** All commits should be created using `jj` (Jujutsu).
- **Convention:** We follow the `lazymoji` convention, which is a scope-less version of Conventional Commits with an emoji prefix.
- **Implementation:** The `lazymoji.sh` script, integrated with `jj` via aliases (`cm`, `dm`), is the standard way to create commit messages. This interactive script ensures all commits adhere to the format: `EMOJI TYPE: Summary`.
- **Example:** `✨ feat: Add new user authentication feature`

## 4. AI Collaboration Guidelines

- **Infrastructure as Code (IaC):** Any change to a `.nix` file can alter the system configuration. Review all changes carefully.
- **Security:** Do not hardcode secrets. A `gpg`-based secret management strategy is in use (see `/secrets` directory).
- **Modularity:** Use the `modules` directory for reusable configurations.
- **Host-specific changes:** Place host-specific configurations in the `hosts` directory.

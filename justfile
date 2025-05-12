default:
  @just --list

update:
  nix flake update

diff:
  git diff ':!flake.lock'

# Rebuild nixos
rebuild:
  git add *
  nh os switch . --ask

# Run GC and optmise Nix Store
clean:
  nh clean all
  sudo nix-store --optimise

repair:
  sudo nix-store --verify --check-contents --repair

fmt:
  nix fmt

lint:
  nix flake check

wezterm user:
  cp {{justfile_directory()}}/config/wezterm.lua /mnt/c/Users/{{user}}/.wezterm.lua

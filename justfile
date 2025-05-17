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
  @if [ "$HOSTNAME" == "nixWSL" ]; then just _wezterm; fi

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

_wezterm:
  #!/usr/bin/env sh
  config_dir="{{justfile_directory()}}/modules/programs/wezterm"
  for item in "win" "nix"; do
    cat "$config_dir/${item}_wezterm.lua"
    echo
  done > /mnt/c/Users/dli50/.wezterm.lua

default:
  @just --list

update:
  nix flake update

diff:
  git diff ':!flake.lock'

# Rebuild nixos
rebuild:
  git add *
  nixos-rebuild switch --flake .#$(hostname) --use-remote-sudo

# Rebuild home
remodel:
  git add *
  home-manager switch --flake .#dli50

# Run GC and optmise Nix Store
clean:
  sudo nix-collect-garbage -d
  nix-collect-garbage -d
  sudo nix-collect-garbage --delete-older-than 7d
  nix-collect-garbage --delete-older-than 7d
  sudo nix-store --optimise
  nix-store --optimise

upgrade: clean rebuild remodel clean

repair:
  sudo nix-store --verify --check-contents --repair

fmt:
  nix fmt

lint:
  nix flake check

wezterm user:
  cp {{justfile_directory()}}/config/wezterm.lua /mnt/c/Users/{{user}}/.wezterm.lua

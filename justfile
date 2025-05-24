default:
  @just --list

# Update flake inputs
update:
  @nix flake update

# Diff flake.lock
diff:
  @git diff ':!flake.lock'

# Build NixOS
build:
  @git add *
  @nix build .#nixosConfigurations.$(hostname).config.system.build.toplevel --out-link /tmp/ncfr |& nom
  @nvd diff /run/current-system /tmp/ncfr
  @rm /tmp/ncfr

# Rebuild and Switch NixOS
rebuild:
  @just build
  @just confirm-switch

[confirm]
[private]
confirm-switch:
  @nixos-rebuild switch --flake .#$(hostname) --sudo
  @if [ "$HOSTNAME" == "nixWSL" ]; then just wezterm; fi

# Run GC and optmise Nix Store
clean:
  @sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old
  @sudo nix-collect-garbage -d
  @sudo nix-store --optimise

# Verify and repair the Nix Store
repair:
  @sudo nix-store --verify --check-contents --repair

# Format files
fmt:
  @nix fmt

# Check files
lint:
  @nix flake check

# Reboot the system
reboot:
  @sudo reboot

# Poweroff the system
poweroff:
  @sudo poweroff

[private]
wezterm:
  #!/usr/bin/env sh
  config_dir="{{justfile_directory()}}/modules/programs/wezterm"
  cp "$config_dir/wezterm.lua" /mnt/c/Users/dli50/.wezterm.lua

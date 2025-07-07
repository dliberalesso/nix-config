default:
  @just --list

# Update flake inputs
update:
  @nix flake update

# Diff flake.lock
diff:
  @jj diff 'flake.lock'

# Load the flake in a REPL with debug enabled
debug:
  @sd "debug = false" "debug = true" ./modules/flake/default.nix
  @nix repl .
  @sd "debug = true" "debug = false" ./modules/flake/default.nix

# Rebuild and Switch NixOS
rebuild:
  @nh os switch . --ask
  @if [ "$HOSTNAME" == "nixWSL" ]; then just wezterm; fi

# Run GC and optmise Nix Store
clean:
  @nh clean all --nogcroots
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

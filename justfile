default:
  @just --list

# Update flake inputs
update:
  @nix flake update

# Diff flake.lock
diff:
  @git diff ':!flake.lock'

# Load the flake in a REPL with debug enabled
debug:
  @git add *
  @nix repl .

# Rebuild and Switch NixOS
rebuild:
  @git add *
  @nh os switch . --ask
  @if [ "$HOSTNAME" == "nixWSL" ]; then just wezterm; fi

# Run GC and optmise Nix Store
clean:
  @nh clean all
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

# System Modules

## Responsibility

`modules/system/` manages core OS subsystems: bootloader, temporary directory cleanup, kernel tuning, audio, graphics, networking, container virtualization, and user XDG base directories.

## Dependencies

- **NixOS module system**: Primary target for kernel and service configurations
- **Home Manager**: Manages user-level XDG directory configurations
- **`hostConfig` and `lib`**: Injects host metadata and provides `lib.mkDefault` override hooks

## Consumers

- **`laptop` profile**: Groups physical machine capabilities (boot, audio, graphics, network, locale, kernel)
- **`podman` profile**: Enables rootless container virtualization (`virtualization.nix`)
- **All hosts**: Receive global temporary directory cleanup (`boot.tmp.cleanOnBoot`)
- **All users**: Receive global user XDG directory configuration (`xdg.nix`)

## Module Structure

- `boot.nix, kernel.nix` — systemd-boot, kernel packages, and initrd modules
- `audio.nix, graphics.nix` — PipeWire audio server and GPU driver acceleration
- `locale.nix, network.nix` — timezone, localization, and NetworkManager defaults
- `virtualization.nix` — Podman container engine configuration
- `xdg.nix` — user XDG directory enforcement in Home Manager

## Capability Profile Module (`laptop`)

```nix
{
  unify.modules.laptop.nixos =
    { hostConfig, lib, ... }:
    {
      networking.useDHCP = lib.mkDefault true;
      users.users.${hostConfig.user.username}.extraGroups = [ "networkmanager" ];
    };
}
```

## Kernel Add-On Modules Sourced from `kernelPackages`

```nix
{
  unify.modules.laptop.nixos =
    { config, pkgs, ... }:
    {
      boot = {
        kernelPackages = pkgs.linuxPackages;
        kernelModules = [ "kvm-intel" ];
        # Ensure extra kernel modules match the active kernel package
        extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      };
    };
}
```

## Architectural Boundaries

- **NO machine-local disk configs**: storage partitions and UUIDs belong exclusively in `hosts/`
- **INTENTIONAL OVERRIDE POLICY**: `lib.mkDefault` is applied where host overrides are expected (`networking.useDHCP`); other settings evaluate with standard priority
- **COUPLE kernel extensions to `config.boot.kernelPackages`**: never instantiate unlinked kernel modules

<important if="you are adding a new system capability to this layer">
## Adding a System Capability
1. Create `modules/system/<capability>.nix`
2. Use `unify.nixos` only for global baselines; use `unify.modules.<profile>.nixos` for opt-in profiles
3. Read usernames dynamically via `hostConfig.user.username`
4. Source external kernel modules from `config.boot.kernelPackages`
5. Verify changes with `just lint`
</important>

# System Modules

## Responsibility

`modules/system/` provides low-level OS and platform behavior: bootloader, kernel, audio, locale, networking, virtualization, graphics, and user XDG directories. It represents reusable system policy rather than host-specific hardware details.

## Dependencies

- **NixOS module system**: Primary target for system configuration files
- **Home Manager**: Used for user XDG directory configuration
- **`hostConfig` and `lib`**: Used for host-derived usernames and override-friendly defaults

## Consumers

- **`laptop` profile**: Consumes physical hardware-oriented system modules from this directory
- **`podman` profile**: Consumes container runtime support
- **All users**: Receive `unify.home` XDG directory configuration

## Module Structure

- `boot.nix, kernel.nix` — systemd-boot, kernel family/modules, and initrd
- `audio.nix, graphics.nix` — PipeWire multimedia and OpenGL/graphics acceleration
- `locale.nix, network.nix` — system locale and networking defaults with host override support
- `virtualization.nix` — `podman`-scoped rootless container support
- `xdg.nix` — Home Manager user XDG directory policy

## Hardware-Oriented Profile (`laptop`)

```nix
{
  unify.modules.laptop.nixos = { hostConfig, lib, ... }: {
    networking.useDHCP = lib.mkDefault true;
    users.users.${hostConfig.user.username}.extraGroups = [ "networkmanager" ];
  };
}
```

## Kernel Package Coupling (`config.boot.kernelPackages`)

```nix
{
  unify.modules.laptop.nixos = { config, pkgs, ... }: {
    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [
        config.boot.kernelPackages.v4l2loopback
      ]; # keep add-on modules tied to the chosen kernel
    };
  };
}
```

## Architectural Boundaries

- **NO machine-local disks or generated hardware files here**: those belong strictly under `hosts/`
- **TREAT `laptop` AS HARDWARE-SHAPED**: group reusable physical-machine concerns here even if `nixavell` is the primary current consumer

<important if="you are adding a new system capability to this layer">
## Adding a New System Capability
1. Create `modules/system/<feature>.nix`
2. Use `unify.nixos` only for truly global defaults; otherwise prefer `unify.modules.<profile>.nixos`
3. Read usernames from `hostConfig.user.username`
4. Use `lib.mkDefault` for settings that hosts may override
5. When touching kernel add-ons, source them from `config.boot.kernelPackages`
</important>

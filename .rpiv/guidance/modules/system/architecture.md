# System Modules

## Responsibility

`modules/system/` provides low-level OS/platform behavior: boot, kernel, audio, locale, networking, virtualization, and user XDG directories. It is reusable system policy, not host definition.

## Dependencies

- **NixOS module system**: Primary target for most files in this directory
- **Home Manager**: Used only for user XDG directory policy
- **`hostConfig` and `lib`**: Used for host-derived usernames and override-friendly defaults

## Consumers

- **`laptop` profile**: Consumes most hardware-oriented system fragments from this directory
- **`podman` profile**: Consumes container runtime support
- **All users**: Receive `unify.home` XDG directory config

## Module Structure

- `boot.nix, kernel.nix` — bootloader, tmp cleanup, kernel family/modules/initrd
- `audio.nix, graphics.nix` — runtime multimedia and graphics support
- `locale.nix, network.nix` — machine defaults that still allow host-level override
- `virtualization.nix` — `podman`-scoped container support
- `xdg.nix` — Home Manager XDG user directory policy

## Hardware-Oriented Profile, Not Host Alias

```nix
{
  unify.modules.laptop.nixos = { hostConfig, lib, ... }: {
    networking.useDHCP = lib.mkDefault true;
    users.users.${hostConfig.user.username}.extraGroups = [ "networkmanager" ];
  };
}
```

## Kernel Package Coupling (Use `config.boot.kernelPackages`)

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

- **NO machine-local disk or generated hardware files here**: those stay under `hosts/`
- **TREAT `laptop` AS HARDWARE-SHAPED**: group reusable physical-machine concerns here even if only `nixavell` uses them today

<important if="you are adding a new system capability to this layer">
## Adding a New System Capability
1. Create `modules/system/<feature>.nix`
2. Use `unify.nixos` only for truly global defaults; otherwise prefer `unify.modules.<profile>.nixos`
3. Read usernames from `hostConfig.user.username`
4. Use `lib.mkDefault` for settings that hosts may override
5. When touching kernel add-ons, source them from `config.boot.kernelPackages`
</important>

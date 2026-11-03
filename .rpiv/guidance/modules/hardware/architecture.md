# Hardware Modules

## Responsibility

`modules/hardware/` defines reusable, opt-in hardware capabilities for NixOS hosts. It translates machine hardware requirements (firmware, CPU microcode, GPU drivers, and input peripherals) into NixOS configurations without defining concrete machines.

## Dependencies

- **NixOS hardware subsystem**: Core options (`hardware.bluetooth`, `hardware.graphics`, `services.libinput`, `hardware.firmware`)
- **Nixpkgs `hardware.facter`**: Upstreamed Nixpkgs module consuming host hardware facts from `facter.json`

## Consumers

- **`laptop` profile hosts**: Groups physical machine capabilities (`hosts/nixavell/nixavell.nix`)
- **`facter` profile hosts**: Ingests auto-detected hardware facts from `hosts/<host>/facter.json`

## Module Structure

- `bluetooth.nix, mouse.nix, keyboard.nix` — input peripherals and HID policies (libinput, custom XKB mappings)
- `intel.nix, nvidia.nix` — CPU microcode updates and proprietary GPU acceleration (modesetting, Prime offload)
- `lightpack.nix, redistributable-firmware.nix` — Hyperion ambient lighting systemd daemon and redistributable hardware firmware
- `facter.nix` — hardware inventory consumption bridge (`hardware.facter.reportPath`)

## Distributed Capability Augmentation (`laptop`)

```nix
{
  unify.modules.laptop.nixos = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
}
```

## Hardware Fact Ingestion (`facter`)

```nix
{
  unify.modules.facter.nixos =
    { config, ... }:
    let
      inherit (config.networking) hostName;
    in
    {
      hardware.facter = {
        enable = true;
        reportPath = ../../hosts/${hostName}/facter.json;
      };
    };
}
```

## Architectural Boundaries

- **NO concrete machine definitions**: disks, partition layouts, and host imports belong in `hosts/`
- **REQUIRE HOST-LOCAL `facter.json`**: hosts selecting the `facter` capability must supply `hosts/<host>/facter.json`; there is no fallback
- **FIXED TOPOLOGY IN `laptop`**: `nvidia.nix` configures PRIME offload with fixed PCI bus IDs (`PCI:0@0:2:0` and `PCI:1@0:0:0`); reusing `laptop` on different dual-GPU hardware requires matching or overriding those bus IDs
- **PREFER distributed capability slices**: augment `laptop` or `facter` directly rather than creating cross-file dependencies

<important if="you are adding or modifying hardware modules in this layer">
## Adding a Hardware Module
1. Determine capability scope: augment existing `laptop` or define a distinct capability (e.g. `facter`)
2. Use `unify.modules.<capability>.nixos` to declare device drivers, firmware, or udev rules
3. Gate host-specific variations through `config.networking.hostName` or `hostConfig` rather than hardcoding hostnames
4. Validate Nix evaluation and build planning via dry-run (`nix build .#nixosConfigurations.<host>.config.system.build.toplevel --dry-run`) or validate flake checks with `just lint`. Note that dry-run builds check evaluation, not physical device functioning; do not switch the active system with `just rebuild` without explicit user request.
</important>

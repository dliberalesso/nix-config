# Hosts

## Responsibility

`hosts/` defines concrete machines. Each host registers `unify.hosts.nixos.${hostName}`, selects reusable modules, and adds only host-local wiring such as filesystems, VM profiles, or WSL composition.

## Dependencies

- **`unify`**: Provides the `unify.hosts.nixos` host-registration boundary
- **NixOS module system**: Hosts supply the final `nixos = { ... };` machine config

## Consumers

- **`flake.nix`**: Auto-imports this tree through `import-tree`
- **CI and local rebuilds**: Build `nixosConfigurations.<host>` outputs from these declarations

## Module Structure

- `hosts/<hostname>/<hostname>.nix` — one entrypoint per concrete machine
- `hosts/<hostname>/_*.nix` — host-private helpers such as filesystem layout
- `hosts/<hostname>/facter.json` — hardware inventory consumed by the reusable `facter` module

## Host Registration (Concrete Machine, Reusable Modules)

```nix
{
  config,
  ...
}:
let
  inherit (config.unify) modules;
  hostName = "my-host";
in {
  unify.hosts.nixos.${hostName} = { config, ... }:
  let inherit (config.user) username; in {
    modules = builtins.attrValues {
      inherit (modules) laptop gui podman;
    };

    nixos = {
      nixpkgs.hostPlatform.system = "x86_64-linux";
      users.users.${username}.extraGroups = [ "wheel" ];
    };

    users.${username} = { };
  };
}
```

## Host-Private Hardware Boundary (Keep Machine Facts Out of Shared Modules)

```nix
# hosts/my-host/my-host.nix
nixos.imports = [ ./_filesystem.nix ];

# hosts/my-host/_filesystem.nix
{ modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  fileSystems."/".device = "/dev/disk/by-uuid/...";
  swapDevices = [{ device = "/dev/disk/by-uuid/..."; }];
}
```

## Architectural Boundaries

- **NO reusable feature logic here**: put shared behavior under `modules/`, then select it from the host
- **NO hardcoded user identity**: derive usernames from shared metadata (`config.user` / `hostConfig.user`)

<important if="you are adding a new host to this layer">
## Adding a New Host
1. Create `hosts/<hostname>/<hostname>.nix`
2. Bind `hostName = "<hostname>"` and register `unify.hosts.nixos.${hostName}`
3. Select reusable modules from `config.unify.modules`
4. Keep machine-local disks/hardware in `_*.nix` or `facter.json`
5. Add `users.${username}` for the Home Manager side
6. Run `just fmt` and `just lint`
</important>

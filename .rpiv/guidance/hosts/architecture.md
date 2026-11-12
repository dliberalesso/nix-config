# Hosts

## Responsibility

`hosts/` defines concrete machines. Each host registers `unify.hosts.nixos.${hostName}`, selects reusable capability modules from `config.unify.modules`, and supplies machine-local hardware, disk layouts, or platform specifics.

## Dependencies

- **`unify`**: Provides `unify.hosts.nixos` host-registration schema and `config.unify.modules`
- **NixOS module system**: Target for final machine evaluation (`nixosConfigurations.<host>`)

## Consumers

- **`flake.nix`**: Auto-imports the host tree via `inputs.import-tree`
- **NixOS rebuilds & CI**: Evaluates target configurations through `just rebuild` or GitHub Actions

## Module Structure

- `hosts/<hostname>/<hostname>.nix` — entrypoint registering concrete machine and selecting modules
- `hosts/<hostname>/_*.nix` — host-private hardware/filesystem specifics (excluded from auto-import)
- `hosts/<hostname>/facter.json` — hardware detection inventory consumed by the `facter` module

## Host Registration (Concrete Machine, Reusable Modules)

```nix
{ config, ... }:
let
  inherit (config.unify) modules;
  hostName = "my-host";
in
{
  unify.hosts.nixos.${hostName} =
    { config, ... }:
    let
      inherit (config.user) username;
    in
    {
      # Select reusable capabilities from modules/
      modules = with modules; [
        laptop
        gui
        podman
      ];

      nixos = {
        nixpkgs.hostPlatform.system = "x86_64-linux";
        users.users.${username}.extraGroups = [ "wheel" ];
      };

      users.${username} = { inherit (config) modules; };
    };
}
```

## Per-host SSH Signing Key

Each host declares the public key it signs commits with; the shared program modules read it through `hostConfig.signingKey`.

```nix
# hosts/my-host/my-host.nix
unify.hosts.nixos.my-host =
  { config, ... }:
  {
    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...";
  };
```

`config.unify.options.allowedSigners` (declared in `modules/meta/signing.nix`) collects one `<email> namespaces="git" <public key>` line per host, so Git and Jujutsu share one generated `allowed_signers` file. Hosts without a key — a throwaway VM, or a laptop whose key does not exist yet — simply omit `signingKey` and end up with signing disabled.

## Host-Private Hardware Boundary (Keep Machine Facts Local)

```nix
# hosts/my-host/my-host.nix
nixos.imports = [ ./_filesystem.nix ];

# hosts/my-host/_filesystem.nix
{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  fileSystems."/".device = "/dev/disk/by-uuid/0000-0000";
  swapDevices = [ { device = "/dev/disk/by-uuid/1111-1111"; } ];
}
```

## Architectural Boundaries

- **NO reusable feature logic here**: shared capabilities belong under `modules/`
- **NO hardcoded user identity**: derive usernames from `config.user` / `hostConfig.user`
- **NO machine facts in shared modules**: disk UUIDs and facter outputs stay in `hosts/<host>/`

<important if="you are adding a new host to this layer">
## Adding a New Host
1. Create `hosts/<hostname>/<hostname>.nix`
2. Bind `hostName = "<hostname>"` and register `unify.hosts.nixos.${hostName}`
3. Select desired capabilities from `config.unify.modules`
4. Isolate disk partitions and hardware scanning in `_filesystem.nix` or `facter.json`
5. Configure `users.${username} = { inherit (config) modules; };` for Home Manager integration
6. Add the hostname to the CI matrix list in `.github/scripts/generate-build-matrix.sh`
7. If introducing another CPU architecture, add it to `systems` in `modules/flake/default.nix`
8. Verify with `just fmt` and `just lint`
</important>

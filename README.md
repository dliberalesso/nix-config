# nix-config

[![🏠 Home 🏠](https://github.com/dliberalesso/nix-config/actions/workflows/home.yml/badge.svg)](https://github.com/dliberalesso/nix-config/actions/workflows/home.yml)
[![❄️ NixOS ❄️](https://github.com/dliberalesso/nix-config/actions/workflows/nixos.yml/badge.svg)](https://github.com/dliberalesso/nix-config/actions/workflows/nixos.yml)

### NixOS-WSL

The NixOS-WSL configuration can be installed by running the following command.

```shell
sudo nixos-rebuild switch --flake github:dliberalesso/nix-config#nixosWSL
```

### Home-Manager

The entire Home-Manager configuration can also be built as any other flake.

```shell
nix build github:dliberalesso/nix-config#homeConfigurations.dli.activationPackage
result/activate
```

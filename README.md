# nix-config

### NixOS-WSL

The NixOS-WSL configuration can be installed by running the following command.

```console
$ sudo nixos-rebuild switch --flake github:dliberalesso/nix-config#nixosWSL
```

### Home-Manager

The entire Home-Manager configuration can also be built as any other flake.

```console
$ nix build github:dliberalesso/nix-config#homeConfigurations.dli.activationPackage
$ result/activate
```

# Toplevel Profiles

## Responsibility

`modules/toplevel/` defines cross-cutting baselines and high-level environment profiles: global user accounts, Home Manager bridge defaults, secret management tooling, platform profiles (`wsl`), and desktop sessions (`niride`).

## Dependencies

- **`unify`**: Module framework for global baselines (`unify.nixos`, `unify.home`) and named profiles (`unify.modules.*`)
- **Home Manager Bridge**: Connects NixOS user accounts to Home Manager environments
- **`nixos-wsl`**: Imported in `wsl.nix` for WSL2 guest integration

## Consumers

- **All hosts**: Automatically inherit global baselines (`home.nix`, `user.nix`, `secrets.nix`)
- **Selected hosts**: Select named composite profiles (`wsl`, `niride`)

## Module Structure

- `home.nix, user.nix` — global Home Manager defaults and primary user account creation
- `secrets.nix` — global secret-management tooling (`pass`, `secretspec`, GPG agent with SSH support)
- `wsl.nix` — WSL2 guest platform profile
- `niride.nix` — transitional Niri desktop session bundle (greeter, portals, lid handler)

## Global Baseline and Bridge Configuration

```nix
{
  unify = {
    home =
      { hostConfig, lib, ... }:
      {
        home.username = hostConfig.user.username;
        news.entries = lib.mkForce [ ];
        xdg.enable = true;
      };

    nixos.home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
    };
  };
}
```

## Paired Profile Pattern (System + User Coordination)

```nix
{
  unify.modules.niride.nixos =
    { pkgs, ... }:
    {
      programs.niri.enable = true;
      security.polkit.enable = true;
      xdg.portal = {
        enable = true;
        config.niri.default = [
          "gnome"
          "gtk"
        ];
      };
    };

  unify.modules.niride.home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.xwayland-satellite ];
      services.polkit-gnome.enable = true;
    };
}
```

## Architectural Boundaries

- **TREAT `niride` AS TRANSITIONAL**: session-specific wiring lives here, but general GUI apps stay in `modules/programs/gui.nix`
- **SECRET WAYLAND HOOK IS A TRANSITIONAL STUB**: `secrets.nix:9` checks `config.programs.hyprland.enable` for `pass-wayland`; this is a known placeholder awaiting desktop session refactoring
- **DISTRIBUTED BUNDLE CONTRIBUTIONS ARE ACCEPTED**: packages and programs outside `toplevel/` (e.g. `modules/packages/zennotes-tui.nix`) may directly contribute to bundles like `wsl.home`

<important if="you are adding or modifying desktop session profiles in this layer">
## Desktop Session Profile Guidance
1. Keep compositor services, display greeters, lid handlers, and portal order in the session profile
2. Ensure generic desktop apps/fonts remain in `unify.modules.gui.*`
3. Design desktop profiles so upcoming options (e.g. `hyprde`) share common GUI components cleanly
4. Format with `just fmt` and validate with `just lint`
</important>

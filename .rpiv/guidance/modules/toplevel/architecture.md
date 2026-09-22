# Toplevel Profiles

## Responsibility

`modules/toplevel/` defines cross-cutting base policy and high-level environment profiles. It establishes global user/home defaults and integrates composite environments such as `wsl` and desktop session bundles.

## Dependencies

- **`unify`**: Exposes global `unify.nixos` / `unify.home` and named `unify.modules.*` bundles
- **Home Manager bridge**: Connects base home environment and NixOS↔Home Manager integration
- **`nixos-wsl`**: Imported inside the `wsl` profile module

## Consumers

- **All hosts**: Consume the global user and home baseline defined here
- **Selected hosts**: Opt into composite bundles like `wsl` or `niride`

## Module Structure

- `home.nix, user.nix` — global Home Manager baseline and user-account defaults
- `secrets.nix` — cross-cutting secret and key management hooks
- `wsl.nix` — platform-specific WSL2 profile bundle
- `niride.nix` — current Niri desktop/session bundle (marked transitional)

## Global Baseline + Bridge

```nix
{
  unify = {
    home = { hostConfig, lib, ... }: {
      home.username = hostConfig.user.username;
      news.entries = lib.mkForce [ ];
      xdg.enable = true;
    };

    nixos.home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
```

## Paired Profile Boundary (System Side + User Side)

```nix
{
  unify.modules.niride.nixos = { pkgs, ... }: {
    programs.niri.enable = true;
    security.polkit.enable = true;
  };

  unify.modules.niride.home = { pkgs, ... }: {
    home.packages = [ pkgs.xwayland-satellite ];
    services.polkit-gnome.enable = true;
  };
}
```

## Architectural Boundaries

- **NO generic GUI app ownership here**: shared desktop applications belong in `gui` (e.g. `modules/programs/gui.nix` and `modules/packages/gui.nix`); keep compositor/session-specific wiring in dedicated desktop modules
- **TREAT `niride` AS TRANSITIONAL**: future architecture will support multiple DEs (e.g. `hyprde`) via dedicated DE modules and a shared `common` foundation

<important if="you are changing desktop-session architecture in this layer">
## Desktop Session Guidance
1. Put compositor/session-specific services, portals, greeters, and lid handlers in the desktop bundle here
2. Keep DE-independent GUI apps/fonts in `unify.modules.gui.*` rather than `niride`
3. Design desktop modules so future additions (such as `hyprde`) can reuse shared foundations without inheriting Niri-specific services
</important>

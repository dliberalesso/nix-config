# Toplevel Profiles

## Responsibility

`modules/toplevel/` defines cross-cutting base policy plus high-level profiles. It is where global user/home defaults live and where larger environment bundles such as `wsl` and the current Niri desktop bundle are assembled.

## Dependencies

- **`unify`**: Exposes global `unify.nixos` / `unify.home` and named `unify.modules.*` bundles
- **Home Manager bridge**: Base home policy and NixOS↔Home Manager integration meet here
- **`nixos-wsl`**: Imported inside the `wsl` profile module

## Consumers

- **All hosts**: Consume the global base fragments defined here
- **Selected hosts**: Opt into named bundles like `wsl` or `niride`

## Module Structure

- `home.nix, user.nix` — global Home Manager and user-account baseline
- `secrets.nix` — cross-cutting secret/GPG tooling
- `wsl.nix` — platform-specific WSL bundle
- `niride.nix` — current Niri desktop/session bundle, marked transitional

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
  unify.modules.desktop.nixos = { pkgs, ... }: {
    programs.someCompositor.enable = true;
    security.polkit.enable = true;
  };

  unify.modules.desktop.home = { pkgs, ... }: {
    home.packages = [ pkgs.some-user-tool ];
    systemd.user.services.desktop-helper.Service.ExecStart = "...";
  };
}
```

## Architectural Boundaries

- **NO generic GUI app/theme ownership here**: shared graphical apps, fonts, and theme belong under the stable `gui` layer; keep compositor/session-specific wiring in desktop bundles
- **TREAT `niride` AS TRANSITIONAL**: it is the current Niri integration point, but future work should move toward narrower modules so `niride` and a future `hyprde` can coexist

<important if="you are changing desktop-session architecture in this layer">
## Desktop Session Guidance
1. Put compositor/session-specific services, portals, greeters, and user session helpers in a desktop bundle here
2. Keep shared GUI apps/fonts/theme in `unify.modules.gui.*` instead of `niride`
3. Prefer new narrow modules over making `niride` broader
4. Design changes so a future `hyprde` can reuse shared GUI layers without inheriting Niri-specific wiring
</important>

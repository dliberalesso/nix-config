# Theme Modules

## Responsibility

`modules/theme/` defines visual styling, theme token options, and asset integration across desktop applications, terminal tools, GTK, Qt, and display managers.

## Dependencies

- **`catppuccin/nix`**: Flake module enabling Catppuccin color schemes across NixOS and Home Manager
- **Home Manager styling APIs**: `gtk`, `qt`, and `dconf` desktop integration options
- **`flake-parts` (`perSystem`)**: Declares theme token schemas (`options.theme.scheme`) and local assets

## Consumers

- **Global user configuration**: Inherits Catppuccin color palette across CLI and desktop tools
- **`gui` capability bundle**: Receives GTK/Qt themes, cursor themes, and desktop visual settings

## Module Structure

- `scheme.nix` — perSystem theme options (`theme.scheme`, `theme.accent`) defining base16 tokens
- `catppuccin.nix` — global Catppuccin module enablement across NixOS and Home Manager
- `gtk.nix, qt.nix` — desktop toolkit style integration (Kvantum, GTK dark theme)
- `cursor.nix, wallpaper.nix, dconf.nix` — pointer theme (hyprcursor / Xcursor), wallpaper asset, and GNOME preferences

## Per-System Palette Option Declaration (`scheme.nix`)

```nix
{
  perSystem =
    { lib, ... }:
    let
      inherit (lib) mkOption types;
    in
    {
      options.theme = {
        accent = mkOption {
          type = types.str;
          internal = true;
          readOnly = true;
          default = "base0E";
        };
        scheme = mkOption {
          type = types.attrsOf types.anything;
          internal = true;
          readOnly = true;
          default = {
            variant = "dark";
            base00 = "1e1e2e"; # base
            base05 = "cdd6f4"; # text
            base0D = "89b4fa"; # blue
            base0E = "cba6f7"; # mauve
          };
        };
      };
    };
}
```

## Distributed GUI Styling (`qt.nix`)

```nix
{
  unify.modules.gui.home = {
    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };
  };
}
```

## Architectural Boundaries

- **`perSystem` OPTIONS DO NOT AUTO-PROPAGATE**: `options.theme.scheme` and `options.theme.wallpaper` are declared per-system in flake-parts; no current in-tree consumers exist for them, so they do not automatically apply to toolkits or desktop environments without explicit wiring
- **BASE16 TOKENS OMIT `#`**: hex colors in `scheme.nix` follow base16 conventions (`"1e1e2e"`); prepend `#` where toolkits require it
- **WALLPAPER IS A TYPED PATH**: `wallpaper.nix` defines `options.theme.wallpaper` defaulting to `./wallpaper.jpg` as `types.path`, rather than assigning desktop settings directly
- **NO window-manager logic here**: compositor settings belong in session profiles (`modules/toplevel/`)

<important if="you are adding or styling new desktop applications">
## Adding Theming Rules
1. To consume central colors or artwork, read from per-system `config.theme.scheme` or `config.theme.wallpaper` and explicitly wire into the target module scope
2. Augment `unify.modules.gui.home` for tool-specific GTK, Qt, or desktop styling
3. When adding binary artwork (wallpapers, icons), place files alongside the module and reference via Nix path
4. Verify styling syntax with `just fmt` and `just lint`
</important>

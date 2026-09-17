# Remaining Missing Packages in ekapkgs

Packages not yet available in the ekapkgs/corepkgs package set, blocking full
feature parity in various package expressions.

**Note:** Many packages below are blocked by the `gtk4` package being marked as
broken in ekapkgs. Once gtk4 is fixed, all GTK4-dependent packages below should
work.

## WebKit

| Package | Status | Notes |
|---|---|---|
| `webkitgtk_4_1` | **DONE** | Evaluates OK |
| `webkitgtk_6_0` | **DONE** | Blocked by broken gtk4 |

## Glycin (image loading)

| Package | Status | Notes |
|---|---|---|
| `libglycin` | **DONE** | Evaluates OK |
| `libglycin-gtk4` | **DONE** | Blocked by broken gtk4 |
| `glycin-loaders` | **DONE** | Evaluates OK |

## NetworkManager ecosystem

| Package | Status | Notes |
|---|---|---|
| `libnma-gtk4` | **DONE** | Blocked by broken gtk4 |
| `modemmanager` | **DONE** | Evaluates OK |
| `networkmanagerapplet` | **DONE** | Evaluates OK |

## GNOME components

| Package | Status | Notes |
|---|---|---|
| `packagekit` | **DONE** | Evaluates OK |
| `malcontent` | **DONE** | Evaluates OK |
| `gnome-color-manager` | **Already existed** | |
| `gnome-remote-desktop` | **Already existed** | |
| `gnome-tecla` | **Already existed** | Blocked by broken gtk4 |
| `nixos-icons` | **DONE** | Evaluates OK |
| `gucharmap` | **DONE** | Evaluates OK |
| `libfoundry` | **DONE** | Blocked by broken gtk4 (via webkitgtk_6_0) |

## Desktop/system libraries

| Package | Status | Notes |
|---|---|---|
| `libwacom` | **Already in corepkgs** | |
| `gsound` | **Already existed** | |
| `colord-gtk4` | **DONE** | Blocked by broken gtk4 |
| `gmobile` | **Already existed** | |
| `libpwquality` | **Already in corepkgs** | |
| `sound-theme-freedesktop` | **Already existed** | |
| `udisks` | **Already existed** | |
| `shadow` | **Already in corepkgs** | |
| `libcamera` | **DONE** | Evaluates OK |
| `libvirt-glib` | **DONE** | Evaluates OK |
| `gtk-frdp` | **DONE** | Evaluates OK |
| `liquidctl` | **DONE** | Evaluates OK (simplified deps) |
| `libcanberra-gtk3` | **DONE** | Alias for libcanberra |
| `uhttpmock` | **Already existed** | |

## Mozilla / JavaScript

| Package | Status | Notes |
|---|---|---|
| `spidermonkey_140` (mozjs) | **DONE** | Evaluates OK |

## Testing / dev tools

| Package | Status | Notes |
|---|---|---|
| `xvfb-run` | **DONE** | Evaluates OK |
| `valgrind-light` | **DONE** | Alias for valgrind |

## Misc

| Package | Status | Notes |
|---|---|---|
| `samba` | **Already existed** | |
| `telepathy-glib` | **Already existed** | |
| `dnsutils` | **DONE** | Alias for bind.utils |
| `vte-gtk4` | **DONE** | Blocked by broken gtk4 |
| `libsoup_2_4` | **Stubbed as null** | Removed upstream |

---

## Still Missing (requires larger porting efforts)

### GStreamer

| Package | Needed by |
|---|---|
| `gst-editing-services` | (top-level gst_all_1 scope) |
| `gst-plugins-rs` | snapshot, (top-level gst_all_1 scope) |
| `gstreamermm` | (top-level gst_all_1 scope) |

### Qt6

| Package | Needed by |
|---|---|
| `qtbase` | qgnomeplatform, xdg-desktop-portal-hyprland |
| `qtwayland` | qgnomeplatform, xdg-desktop-portal-hyprland |
| `adwaita-qt` / `adwaita-qt6` | qgnomeplatform |
| `wrapQtAppsHook` (Qt6) | xdg-desktop-portal-hyprland |

### Python packages

| Package | Needed by |
|---|---|
| `babelgladeextractor` | gnome-keysign |
| `gpg` (python gpgme bindings) | gnome-keysign |
| `pygobject3` / `dbus-python` | mutter (python tests), tinysparql |
| `mlt` (python bindings) | flowblade |

### Blocking issue: gtk4

The `gtk4` package override in `top-level.nix` is currently marked broken.
This blocks the following packages from evaluating:
- `webkitgtk_6_0`, `vte-gtk4`, `colord-gtk4`, `libnma-gtk4`
- `libglycin-gtk4`, `libfoundry`, `gnome-tecla`
- Many GNOME apps that depend on gtk4 transitively

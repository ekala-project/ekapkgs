# ekapkgs Module Gaps

Gaps in ekapkgs program/service modules that block a full home-manager
migration or system configuration. Tracks per-user home modules,
system service modules, and test coverage.

Last reviewed: 2026-10-11

---

## 1. Neovim module — RESOLVED

`ekaos/modules/home/programs/neovim.nix` provides per-user Neovim
configuration with `plugins`, `extraConfig`, `extraLuaConfig`,
`extraPackages`, `viAlias`, `vimAlias`, `defaultEditor`, and
`coc` settings.

---

## 2. SSH client module — RESOLVED

`home/programs/ssh.nix` (corepkgs) provides per-user SSH client
configuration with `matchBlocks`, global options, `includes`, and
`extraConfig`.

---

## 3. VSCode module — RESOLVED

`ekaos/modules/home/programs/vscode.nix` provides per-user VSCode
with optional FHS wrapping via `fhs.enable` and `fhs.packages`.

---

## 4. Waybar module — RESOLVED

`ekaos/modules/home/programs/waybar.nix` provides per-user Waybar
configuration with `settings` (JSON) and `style` (CSS).

---

## 5. OBS Studio module — RESOLVED

`ekaos/modules/home/programs/obs-studio.nix` provides per-user OBS
Studio with `plugins` list wrapping.

---

## 6. GPG agent module — RESOLVED

`home/programs/gpg-agent.nix` (corepkgs) provides per-user GPG agent
with pinentry, SSH support, cache TTLs, and systemd user units.

---

## 7. Per-user program modules — RESOLVED

| Module | Per-user? | Location |
|--------|-----------|----------|
| bash | Yes | corepkgs `home/programs/bash.nix` |
| git | Yes | corepkgs `home/programs/git.nix` |
| ssh | Yes | corepkgs `home/programs/ssh.nix` |
| gpg-agent | Yes | corepkgs `home/programs/gpg-agent.nix` |
| alacritty | Yes | ekapkgs `home/programs/alacritty.nix` |
| htop | Yes | ekapkgs `home/programs/htop.nix` |
| direnv | Yes | ekapkgs `home/programs/direnv.nix` |
| fzf | Yes | ekapkgs `home/programs/fzf.nix` |
| neovim | Yes | ekapkgs `home/programs/neovim.nix` |

---

## 8. `jq` module — OPEN (trivial)

Just a package, no config needed. Use `pkgs.jq` in user packages.

---

## 9. XDG per-user setup — RESOLVED

`ekaos/modules/home/programs/xdg.nix` provides per-user XDG base
directory variables and optional directory creation.

---

## 10. `mkFlake` home support — RESOLVED

`lib/mk-flake.nix` accepts `homeConfigurations` evaluated through
ekapkgs' `eval-home.nix`.

---

## 11. Service module type conflicts — RESOLVED

Removed conflicting option declarations (`command`, `restartPolicy`,
`systemd`, `ports`, `environment`) from 11 ekapkgs service modules
that clashed with corepkgs' `serviceOpts` types. App-specific options
preserved.

Affected: docker, tailscale, ollama, plex, syncthing, transmission,
kubo, jack, pipewire, xserver, ydotool.

---

## 12. yubikey-touch-detector service — RESOLVED

`ekaos/modules/services/yubikey-touch-detector.nix` provides a user
service with socket activation.

---

## 13. dsearch service — RESOLVED

`ekaos/modules/services/dsearch.nix` provides a user service for the
dsearch filesystem search daemon.

---

## 14. seahorse dbus integration — RESOLVED

`ekaos/modules/programs/seahorse.nix` registers seahorse with
`services.dbus.packages`.

---

## 15. xfconf dbus integration — RESOLVED

`ekaos/modules/programs/xfconf.nix` registers xfconf with
`services.dbus.packages`.

---

## 16. Missing system service modules — RESOLVED

Added 20 service/program modules for packages that ship systemd
units and/or dbus services but previously had no ekaos module:

| Module | Type | Integration |
|--------|------|-------------|
| keyd | program | systemd |
| fail2ban | program | systemd |
| fprintd | service | dbus + systemd |
| iwd | service | dbus + systemd |
| rtkit | service | dbus + systemd + polkit |
| geoclue2 | service | dbus + systemd + user/group |
| wpa_supplicant | service | dbus + systemd |
| blueman | service | systemd |
| thermald | service | dbus + systemd |
| brltty | service | systemd + udev |
| input-remapper | service | dbus + systemd + udev |
| autorandr | program | systemd + udev |
| caddy | service | systemd |
| speech-dispatcher | program | systemd |
| openfortivpn | program | systemd |
| logiops | service | dbus + systemd |
| realmd | service | dbus + systemd |
| packagekit | service | dbus + systemd + polkit |
| gpsd | service | systemd + udev + user/group |
| snapper | service | dbus + systemd |

---

## 17. Home module tests — RESOLVED

`ekaos/tests/home.nix` validates all 9 ekapkgs per-user home
modules (alacritty, htop, direnv, fzf, neovim, waybar, obs-studio,
vscode, xdg). Tests file generation, env vars, aliases, activation
scripts, package counts, and verifies disabled modules produce no
output. Registered in `ekaos/tests/default.nix` as `home`.

---

## Summary

| # | Gap | Status |
|---|-----|--------|
| 1 | Neovim module | Resolved |
| 2 | SSH client module | Resolved |
| 3 | VSCode module | Resolved |
| 4 | Waybar module | Resolved |
| 5 | OBS Studio module | Resolved |
| 6 | GPG agent module | Resolved |
| 7 | Per-user modules | Resolved |
| 8 | jq module | Open (trivial) |
| 9 | XDG per-user setup | Resolved |
| 10 | mkFlake home support | Resolved |
| 11 | Service type conflicts | Resolved |
| 12 | yubikey-touch-detector | Resolved |
| 13 | dsearch service | Resolved |
| 14 | seahorse dbus | Resolved |
| 15 | xfconf dbus | Resolved |
| 16 | System service modules | Resolved |
| 17 | Home module tests | Resolved |

All gaps resolved except #8 (trivial — jq is just a package).

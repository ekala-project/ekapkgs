# ekapkgs Home Gaps

Gaps in ekapkgs program/service modules that block a full home-manager
migration. These are modules that either don't exist or exist only as
system-wide (`/etc`) configuration with no per-user equivalent.

Last reviewed: 2026-10-09

---

## 1. Neovim module — RESOLVED

**Status:** Resolved

`ekaos/modules/home/programs/neovim.nix` provides per-user Neovim
configuration with `plugins`, `extraConfig`, `extraLuaConfig`,
`extraPackages`, `viAlias`, `vimAlias`, `defaultEditor`, and
`coc` settings. Generates `~/.config/nvim/init.vim` and wraps
neovim with plugin runtime paths and extra packages on PATH.

---

## 2. SSH client module — RESOLVED

**Status:** Resolved

`ekaos/modules/home/programs/ssh.nix` (in corepkgs) provides full
per-user SSH client configuration with `matchBlocks`, global options,
`includes`, and `extraConfig`. Generates `~/.ssh/config`.

---

## 3. VSCode module — RESOLVED

**Status:** Resolved

`ekaos/modules/home/programs/vscode.nix` provides per-user VSCode
with optional FHS wrapping via `fhs.enable` and `fhs.packages`.

---

## 4. Waybar module — RESOLVED

**Status:** Resolved

`ekaos/modules/home/programs/waybar.nix` provides per-user Waybar
configuration with `settings` (JSON) and `style` (CSS). Generates
`~/.config/waybar/config.jsonc` and `~/.config/waybar/style.css`.

---

## 5. OBS Studio module — RESOLVED

**Status:** Resolved

`ekaos/modules/home/programs/obs-studio.nix` provides per-user OBS
Studio with `plugins` list. Wraps OBS with plugin paths via
`OBS_PLUGINS_PATH` and `OBS_DATA_PATH`.

---

## 6. GPG agent module — RESOLVED

**Status:** Resolved

`ekaos/modules/home/programs/gpg-agent.nix` (in corepkgs) provides
per-user GPG agent configuration with `enable`, `pinentryPackage`,
`enableSshSupport`, cache TTL settings, and `extraConfig`. Generates
`~/.gnupg/gpg-agent.conf` and systemd user units.

---

## 7. Per-user program modules — RESOLVED

All program modules now have per-user variants:

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

## 8. `jq` module (does not exist) — OPEN (trivial)

**What exists:** Nothing (jq is available as a package)

**Workaround:** Add `pkgs.jq` to user packages

**Severity:** None — just a package, no config needed

---

## 9. `xdg.enable` equivalent — RESOLVED

**Status:** Resolved

`ekaos/modules/home/programs/xdg.nix` provides per-user XDG base
directory setup with `XDG_CACHE_HOME`, `XDG_CONFIG_HOME`,
`XDG_DATA_HOME`, `XDG_STATE_HOME` environment variables and optional
directory creation via activation script.

---

## 10. `mkFlake` home support — RESOLVED

**Status:** Resolved

`lib/mk-flake.nix` now accepts a `homeConfigurations` parameter.
Each entry specifies `modules` and `system`, evaluated through
ekapkgs' `eval-home.nix`. Exposed as
`homeConfigurations.<name>.activationPackage`.

Usage:
```nix
ekapkgs.lib.mkFlake {
  homeConfigurations.alice = {
    system = "x86_64-linux";
    modules = [ ./home.nix ];
  };
};
```

---

## Summary

| # | Gap | Severity | Status |
|---|-----|----------|--------|
| 1 | Neovim module | — | Resolved |
| 2 | SSH client module | — | Resolved |
| 3 | VSCode module | — | Resolved |
| 4 | Waybar module | — | Resolved |
| 5 | OBS Studio module | — | Resolved |
| 6 | GPG agent module | — | Resolved |
| 7 | Per-user modules | — | Resolved |
| 8 | jq module | None | Open — package in list |
| 9 | XDG per-user setup | — | Resolved |
| 10 | mkFlake home support | — | Resolved |

**No remaining blockers.** All gaps except #8 (trivial, just a package)
are resolved with dedicated per-user home modules.

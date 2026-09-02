# Agent Guide for ekapkgs

Ekapkgs is an overlay repository that extends [corepkgs](https://github.com/ekala-project/corepkgs). All packaging conventions, build system guides, validation requirements, and porting workflows from corepkgs apply here. See the [corepkgs AGENTS.md](https://github.com/ekala-project/corepkgs/blob/master/AGENTS.md) for the full guide.

## Repository Structure

Ekapkgs aggregates corepkgs and satellite repositories (Python, Haskell, CUDA, R, Vim plugins) into a single unified package set via `pkgs-module.nix`.

```
pkgs/                  # Package expressions (auto-registered in pkgs.* scope)
top-level.nix          # Explicit overrides, aliases, and variant definitions
python-packages.nix    # Python package overrides (applied after upstream)
ekaos/modules/         # EkaOS service and program modules
  services/            # Service modules (e.g., ollama, plex, lightdm)
  programs/            # Program modules (auto-generated wrappers)
build-support/         # Build helpers (desktop items, hooks)
pins.nix               # Pinned dependencies from flake.lock
repos-packages.nix     # Unified derivation list for automated updates
```

## Key Differences from corepkgs

- **Packages go in `pkgs/`** — there is no `pkgs-many/` directory in this repo.
- **Python overrides** go in `python-packages.nix`, not in `pkgs/`.
- **`top-level.nix`** is an overlay (`final: prev:`) for aliases, variant wrappers, and overrides that can't be expressed as a simple `callPackage`.
- **Validation** uses the same commands (`nix-instantiate -A`, `nix-build -A`, `nix fmt`) but run from this repo's root.
- **EkaOS modules** live under `ekaos/modules/` — see `services/AGENTS.md` in corepkgs for service module conventions.

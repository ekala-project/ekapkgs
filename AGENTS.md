# Agent Guide for ekapkgs

Ekapkgs is an overlay repository that extends [corepkgs](https://github.com/ekala-project/corepkgs). All packaging conventions, build system guides, validation requirements, and porting workflows from corepkgs apply here. See the [corepkgs AGENTS.md](https://github.com/ekala-project/corepkgs/blob/master/AGENTS.md) for the full guide.

## Commit Conventions

- **One logical change per commit** — squash small linting fixes and trivial corrections into the commit they belong to rather than creating separate fixup commits
- **Prefer `finalAttrs` over `rec`** for package expressions — use the `finalAttrs` pattern (e.g., `stdenv.mkDerivation (finalAttrs: { ... })`) instead of `rec { ... }`
- **Run `nix fmt .` after every edit** — all `.nix` files must be formatted before committing

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
ci/repos-packages.nix  # Unified derivation list for automated updates
```

## Package Defaults

- **`enableParallelBuilding`** defaults to `true` — do not set it explicitly unless disabling it (`= false`).
- **`cmakeFlags`** should not be used for `-D` cache entries. Use **`cmakeEntries`** instead (booleans auto-convert to `ON`/`OFF`). Reserve `cmakeFlags` only for non-`-D` flags (e.g., `--log-level=STATUS`, `-G Ninja`) or dynamic/conditional flag lists that can't be expressed as a static attrset.
- **`mesonFlags`** should not be used for `-D` options. Use **`mesonEntries`** (booleans auto-convert to `true`/`false`) for plain options and **`mesonFeatures`** (booleans auto-convert to `enabled`/`disabled`) for Meson `feature` type options. Reserve `mesonFlags` only for non-`-D` flags or dynamic/conditional lists.

## Writing Packages

| Task | Guide |
|------|-------|
| Go (buildGoModule, vendorHash, ldflags, CGO_ENABLED, tags, subPackages, version pinning) | [go](.agents/skills/go/SKILL.md) |

## Fixing Build Failures

| Symptom | Guide |
|---------|-------|
| Fix all broken builds across the repo (background build + iterative fix loop) | [fix-builds](.agents/skills/fix-builds/SKILL.md) |

## Reviewing Packages

Use the [best-practices](.agents/skills/best-practices/SKILL.md) skill to review package expressions for meta completeness, build-system idioms, dependency placement, and packaging conventions.

## Porting from nixpkgs

When porting packages from nixpkgs, apply the following substitutions in addition to the standard porting checklist (strip `meta.maintainers`, `meta.teams`, `updateScript`, add build-system hooks, etc.):

- **`gst_all_1`** has been renamed to **`gstreamer`**. Replace `gst_all_1` in function arguments and `with gst_all_1;` blocks with `gstreamer`. Individual plugins are accessed as `gstreamer.gst-plugins-base`, `gstreamer.gst-plugins-good`, etc.
- **`docbook_xml_dtd_*`** has been renamed. Use `docbook-xml-dtd` as the function argument and access specific versions as `docbook-xml-dtd.v4_5`, `docbook-xml-dtd.v4_3`, `docbook-xml-dtd.v4_2`, etc.
- **`nixosTests`** references should be commented out with a `# TODO(ekaos)` marker. NixOS tests will be replaced by EkaOS integration tests via the `integrationTests` passthru attribute in a future sweep. Example:
  ```nix
  passthru = {
    # TODO(ekaos): replace with integrationTests
    # tests = { inherit (nixosTests) foo; };
  };
  ```

## Key Differences from corepkgs

- **Packages go in `pkgs/`** — there is no `pkgs-many/` directory in this repo.
- **Python overrides** go in `python-packages.nix`, not in `pkgs/`.
- **`top-level.nix`** is an overlay (`final: prev:`) for aliases, variant wrappers, and overrides that can't be expressed as a simple `callPackage`.
- **Validation** uses the same commands (`nix-instantiate -A`, `nix-build -A`, `nix fmt`) but run from this repo's root.
- **EkaOS modules** live under `ekaos/modules/` — see `services/AGENTS.md` in corepkgs for service module conventions.

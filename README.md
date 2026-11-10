# Ekapkgs

The default entrypoint for the Ekala package ecosystem. Ekapkgs aggregates
[corepkgs](https://github.com/ekala-project/corepkgs) and all satellite
repositories (Haskell, Python, CUDA, R, Vim plugins) into a single unified
package set. Most users should use this repository rather than importing
the individual ecosystem repos directly.

## Usage

### Flake

```nix
{
  inputs.ekapkgs.url = "github:ekala-project/ekapkgs";

  outputs = { ekapkgs, ... }: {
    # Access the full package set
    packages.x86_64-linux.default = ekapkgs.legacyPackages.x86_64-linux.hello;
  };
}
```

### Non-flake

```nix
let
  pkgs = import (fetchTarball "https://github.com/ekala-project/ekapkgs/archive/master.tar.gz") {
    system = "x86_64-linux";
  };
in
pkgs.hello
```

### EkaOS system configuration

`ekaos/default.nix` evaluates an EkaOS system configuration (analogous to
NixOS's `nixosSystem`) using corepkgs' EkaOS evaluator plus the ekapkgs
modules:

```nix
let
  ekapkgs = fetchTarball "https://github.com/ekala-project/ekapkgs/archive/master.tar.gz";
in
import "${ekapkgs}/ekaos" {
  pkgs = import ekapkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  configuration = ./configuration.nix;
}
```

## What's included

Ekapkgs merges packages from across the Ekala ecosystem:

| Source | Contents |
|--------|----------|
| [corepkgs](https://github.com/ekala-project/corepkgs) | Stdenv, compilers, toolchains, core libraries, EkaOS modules |
| [haskell-pkgs](https://github.com/ekala-project/haskell-pkgs) | GHC and Haskell package set |
| [python-packages](https://github.com/ekala-project/python-packages) | Python interpreters and package set |
| [cuda-pkgs](https://github.com/ekala-project/cuda-pkgs) | CUDA toolkit and GPU libraries |
| [r-pkgs](https://github.com/ekala-project/r-pkgs) | R interpreter and CRAN packages |
| [vim-plugins](https://github.com/ekala-project/vim-plugins) | Vim and Neovim plugin set |
| **ekapkgs** | Over 8,000 user-facing packages (including KDE, Perl and PostgreSQL extensions), EkaOS program and service modules |

Together with corepkgs and the satellite repositories, the combined set
provides tens of thousands of packages, along with EkaOS modules for
system services such as OpenSSH, PostgreSQL and nginx (from corepkgs) and
Kubo/IPFS, Ollama, Plex and Transmission (from ekapkgs).

## Structure

```
pkgs/            # User-facing packages (auto-imported to pkgs scope)
pkgs-many/       # Packages with multiple variants
kde/             # KDE Frameworks, Gear and Plasma (kdePackages)
perl/pkgs/       # Perl packages (perlPackages)
python/pkgs/     # Python packages (python3Packages)
postgresql/pkgs/ # PostgreSQL extensions
ekaos/
  modules/
    programs/    # EkaOS program modules (fish, helix, hyprland, steam, etc.)
    services/    # EkaOS service modules (kubo, ollama, plex, etc.)
    home/        # Home modules
build-support/   # Desktop file utilities and hooks
top-level.nix    # Overlay for overrides and aliases at pkgs scope
pkgs-module.nix  # Aggregates all ecosystem overlays
python-packages.nix  # Python package overrides
default.nix      # Non-flake entry point
flake.nix        # Flake entry point
```

## Guiding design principles

- Explicit over implicit
- Intuitive over pedantic
- Good defaults over assumed configuration
- Automation over manual
- Fun over drudgery

## Binary cache

```
substituters = https://ekala-corepkgs.cachix.org
trusted-public-keys = ekala-corepkgs.cachix.org-1:DcZV+vegWoEzacbSdXFXU4S7728C0eS9RfGpKeyHd6w=
```

# EkaOS in ekapkgs

EkaOS is the Nix-based system builder from
[corepkgs](https://github.com/ekala-project/corepkgs/tree/master/ekaos). It
builds bootable systems, per-user home environments and development shells
from one module system. This directory holds ekapkgs' additions: more
program, service, home and language modules, plus wrappers that load them on
top of corepkgs' evaluators.

The engine is documented in the corepkgs
[ekaos/README.md](https://github.com/ekala-project/corepkgs/blob/master/ekaos/README.md),
[home.md](https://github.com/ekala-project/corepkgs/blob/master/ekaos/home.md)
and [services/README.md](https://github.com/ekala-project/corepkgs/blob/master/services/README.md).
Sections 1 and 2 summarize them. Section 3 states the service design this
repository is moving toward.

## 1. EkaOS in brief (from corepkgs)

### System builds

`system.build.toplevel` is a complete, bootable generation. It contains the
stage-2 `init`, an RFC-0125 `boot.json` (bootspec), the initramfs, `etc/`,
`sw/` (system packages), the `activate` script and GC roots.

Boot sequence:

1. UEFI loads **systemd-boot** from the ESP, which reads the generated entries.
2. The **kernel** starts with the **initramfs** (stage 1). Stage 1 loads
   modules, unlocks LUKS, assembles LVM/RAID, mounts root and `switch_root`s.
3. **Stage 2** mounts the special filesystems and `/nix/store` (read-only),
   runs the activation scripts and execs **systemd** as PID 1.

Configuration uses NixOS-style modules:

- `boot.loader.systemd-boot.*`, `boot.kernelPackages`, `boot.kernelParams`
- `boot.initrd.*`: kernel modules, filesystems, compressor, `luks.devices`,
  and the `postDeviceCommands`/`postMountCommands` hooks
- `system.activationScripts.<name> = { deps; text; }`, topologically sorted
- `environment.etc.<path>`, `environment.systemPackages`

### Testing

- `virtualisation.*` turns any configuration into a QEMU VM or a QCOW2 disk
  image (OVMF/UEFI, serial console, user networking).
- **ekaosTest** is the nixosTest equivalent: a Python driver with
  `machine.start()`, `wait_for_unit`, `succeed` and so on. Packages expose
  these tests through the `integrationTests` passthru attribute; this
  replaces `nixosTests` (see `AGENTS.md`).

### Home environments

`home.users.<name>` replaces home-manager. It manages packages
(`~/.ekaos-profile`), dotfiles (`file.*`, either store symlinks or
`mutable` create-only copies), `sessionVariables`, `sessionPath`,
`shellAliases` and per-user `activation` scripts. Generations are numbered.
It can be evaluated standalone (`eval-home.nix`, Linux and Darwin) or as part
of a full system. The `ekapkgs home switch|build|rollback|generations` CLI
drives it.

### Services API

`corepkgs/services` defines one set of service options: `command`, `args`,
`environment`, `path`, `workingDirectory`, `user`/`group`, `restartPolicy`,
`preStart`/`postStart`/`postStop`, `after`/`before`, `ports` and
`observability`. Translators render these options for each backend:

| Backend | Output |
|---|---|
| systemd | system and user `.service` units |
| launchd | macOS user agents and daemons |
| runit | service directories and Docker images with sidecars |
| BSD rc.d | FreeBSD, NetBSD, DragonFly and OpenBSD scripts |
| process-compose | `mkDevShell` services (`pc-up`, `pc-logs`, ...) |

Definitions are validated at build time.

## 2. What ekapkgs adds

```
ekaos/
├── default.nix              # system evaluator: corepkgs eval-config.nix + module-list.nix
├── eval-home.nix            # home evaluator: corepkgs eval-home.nix + home-module-list.nix
├── modules/
│   ├── module-list.nix      # system modules added on top of corepkgs
│   ├── home-module-list.nix # home modules added on top of corepkgs
│   ├── services/            # system services (ollama, plex, syncthing, gnome, ...)
│   ├── programs/            # program modules
│   ├── home/programs/       # per-user programs (zsh, fish, tmux, kitty, emacs, ...)
│   ├── home/services/       # per-user services (dunst, mako, mpd, postgresql, ...)
│   ├── languages/           # language modules (dart, elm, helm)
│   └── config/
└── tests/                   # ekaosTest integration tests
```

The corepkgs revision is pinned in `../pins.nix`. Development-shell feature
modules are in `../dev-shell/modules/`.

## 3. Services: declare once, run anywhere

### Intent

**Service modules do not write unit files by hand.** A module states what to
run: the command, arguments, environment, lifecycle hooks, dependencies and
the paths it needs. The services API turns that into a systemd unit, a
launchd agent, a runit directory or a process-compose entry.

**One definition serves every context.** The same PostgreSQL module should
back all three of these:

```nix
# A system service
services.postgresql.enable = true;

# A per-user service, provisioned by `ekapkgs home switch`
home.users.alice.services.postgresql = {
  enable = true;
  ensureDatabases = [ "myapp" ];
};

# A project dev shell, run under process-compose
pkgs.mkDevShell {
  modules = [ { services.postgresql.enable = true; } ];
}
```

Language modules already work this way: one file in `modules/languages/`
feeds `environment.*`, `home.users.<name>` and `mkDevShell`. Services
should follow the same pattern.

### Design

- **One module per service, one fixed name.** Each service is one module that
  declares its high-level options (`package`, `port`, `settings`,
  `ensureDatabases`, ...) and maps them onto the common service fields. Every
  context imports the same module, as `services.postgresql`. There is one
  instance per context.
- **The context supplies paths.** A service never hard-codes where its state
  lives. Each context provides the state, runtime and log directories:

  | Context | State | Runtime/socket |
  |---|---|---|
  | System | `/var/lib/<name>` | `/run/<name>` |
  | Home | `$XDG_DATA_HOME/<name>` | `$XDG_RUNTIME_DIR/<name>` |
  | Dev shell | `$DEV_DATA_DIR/<name>` (`./.dev/data`) | under `./.dev` |

  Version-sensitive state, such as a PostgreSQL cluster, still appends a
  version (`<state>/<major>`) inside that directory.
- **corepkgs renders home units.** corepkgs will provide a generic
  `home.users.<name>.services` option, with the same interface as
  `users.services` and `services.*`. The home build will render it into
  `~/.config/systemd/user` on Linux and LaunchAgents on Darwin, including
  `WantedBy=` enablement links. ekapkgs modules only declare services; they
  never write into `file.".config/systemd/user/..."`.
- **Missing features go into the API, not into one service.** Readiness
  (`Type=notify` vs. a `pg_isready` probe), state and runtime directories,
  and reload or stop signals are needed by many services. When a service
  needs one of them, extend the common options and every translator rather
  than working around the gap inside that service's module.

### Open question: backend escape hatches

How much a service module may rely on backend-specific options
(`systemd.serviceConfig`, `systemd.unitConfig`, `launchd.*`) is undecided.
It needs more research into the long-term consequences:

- With **strict portability**, every service runs in a dev shell and on
  every backend. The cost is that the common options must grow to cover
  readiness, sandboxing and resource limits, and some of these have no
  meaning outside systemd.
- With **free use of escape hatches**, modules are quicker to write and can
  use systemd fully. The cost is that a service can silently degrade or
  break in process-compose, launchd or runit. The common interface also
  erodes as each module expresses the same need in its own way.

Until this is settled, new service modules should prefer the portable fields
and keep any escape-hatch use small and commented with the reason.

### Prerequisites in corepkgs

1. Add `home.users.<name>.services`, rendered by the home build and
   reconciled on switch and rollback (see ekapkgs-cli#40).
2. Let one service module be imported by the system, home and `mkDevShell`
   evaluators. `mkDevShell` currently types `services` as generic
   `attrsOf` common options, so a module that declares
   `options.services.postgresql` cannot load there.
3. Add context-provided state, runtime and log directory options.
4. Add a readiness abstraction that maps to systemd `Type=notify` and to
   process-compose `readiness_probe`.
5. Align corepkgs' system `services.postgresql`
   (`modules/services/databases/postgresql.nix`) with the shared module, so
   there is one PostgreSQL definition and not three.

### Migration list

These modules currently write systemd unit files by hand. Each should move
to the services API once the prerequisites land:

| Module | Unit(s) |
|---|---|
| `modules/home/services/postgresql.nix` (PR #148) | `postgresql.service` |
| `modules/home/services/mpd.nix` | `mpd.service` |
| `modules/home/services/dunst.nix` | `dunst.service` |
| `modules/home/services/mako.nix` | `mako.service` |
| `modules/home/services/gammastep.nix` | `gammastep.service` |
| `modules/home/services/darkman.nix` | `darkman.service` |
| `modules/home/services/udiskie.nix` | `udiskie.service` |
| `modules/home/services/cliphist.nix` | `cliphist.service` |
| `modules/home/programs/emacs.nix` | `emacs.service` (daemon) |

System services in `modules/services/` (for example `ollama.nix`) already
feed `services.*` into corepkgs' systemd service manager. However, they
re-declare the common options (`command`, `args`, `user`, ...) by hand.
They should instead import the shared option set so that they too can run in
a dev shell.

## Usage

```bash
# Evaluate or build a system
nix-build ekaos --arg configuration ./my-system.nix -A system
```

```nix
# Build a home environment
let
  pkgs = import ./. { system = "x86_64-linux"; };
  evalHome = import ./ekaos/eval-home.nix { inherit (pkgs) lib; inherit pkgs; };
in
(evalHome { modules = [ ./home.nix ]; }).activationPackage
```

Module conventions are in the corepkgs `services/AGENTS.md` and in this
repository's `AGENTS.md`.

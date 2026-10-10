# ekaos Home Configuration (ekapkgs)

Per-user home environment management. Ekapkgs delegates to corepkgs'
`eval-home.nix` / `eval-config.nix` with ekapkgs modules and overlays
applied, giving access to the full ekapkgs package set.

## Evaluation modes

### Standalone

```nix
# flake.nix — using mkFlake (recommended)
{
  inputs.ekapkgs.url = "github:ekala-project/ekapkgs";

  outputs = { ekapkgs, ... }:
    ekapkgs.lib.mkFlake {
      homeConfigurations.alice = {
        system = "x86_64-linux";
        modules = [ ./home.nix ];
      };
    };
}
```

Or call `eval-home.nix` directly:

```nix
# flake.nix — direct evaluation
{
  inputs.ekapkgs.url = "github:ekala-project/ekapkgs";

  outputs = { ekapkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = ekapkgs.legacyPackages.${system};
      evalHome = import "${ekapkgs}/ekaos/eval-home.nix" {
        inherit (pkgs) lib;
        inherit pkgs;
      };
      result = evalHome {
        modules = [ ./home.nix ];
      };
    in {
      config.home.build.activationPackage = result.activationPackage;
    };
}
```

### Full system

Use `ekaos/default.nix` (which loads ekapkgs modules automatically):

```nix
import ./ekaos { configuration = ./configuration.nix; }
```

Home config is available via `home.users.<name>` alongside system options.

## Configuration

All options live under `home.users.<name>`:

```nix
{ pkgs, ... }:
{
  home.users.alice = {
    packages = [ pkgs.git pkgs.ripgrep ];
    sessionVariables.EDITOR = "vim";
    sessionPath = [ "$HOME/.local/bin" ];
    shellAliases.ll = "ls -la";

    file.".config/git/ignore".text = ''
      .direnv
      result
    '';

    activation.setupDirs = {
      deps = [];
      text = "mkdir -p $HOME/.local/bin";
    };

    programs.bash.enable = true;
    programs.git.settings = {
      user.name = "Alice";
      user.email = "alice@example.com";
    };
    programs.ssh.matchBlocks.github = {
      hostname = "github.com";
      identityFile = "~/.ssh/id_ed25519";
    };
  };
}
```

### Program modules (corepkgs)

| Module | Manages |
|--------|---------|
| `programs.bash` | `.bashrc`, `.bash_profile`, history, shell options |
| `programs.git` | `~/.config/git/config`, signing, aliases, LFS |
| `programs.ssh` | `~/.ssh/config`, match blocks, forwarding |
| `programs.gpg-agent` | `~/.gnupg/gpg-agent.conf`, SSH support, cache TTLs |

### Program modules (ekapkgs)

| Module | Manages |
|--------|---------|
| `programs.neovim` | Wrapped nvim with plugins, `init.vim`, CoC, LSP packages |
| `programs.alacritty` | `~/.config/alacritty/alacritty.toml` |
| `programs.htop` | `~/.config/htop/htoprc` |
| `programs.direnv` | `~/.config/direnv/direnv.toml`, bash hook |
| `programs.fzf` | Keybindings, fuzzy completion, `FZF_DEFAULT_OPTS` |
| `programs.waybar` | `~/.config/waybar/config.jsonc`, `style.css` |
| `programs.obs-studio` | OBS wrapped with plugin paths |
| `programs.vscode` | VSCode with optional FHS wrapping |
| `programs.xdg` | `XDG_*` env vars, directory creation |

## Activation

The `activate` script (`home.build.activationPackage`):

1. Symlinks `home-path` to `~/.ekaos-profile`
2. Removes stale dotfile symlinks
3. Links new dotfiles into `$HOME`
4. Installs `session-vars.sh` to `~/.config/ekaos/session-vars.sh`
5. Runs user activation scripts
6. Records a generation in `~/.config/ekaos/generations/`

Source session variables in your shell (or enable `programs.bash`):
```bash
. "$HOME/.config/ekaos/session-vars.sh"
```

## CLI usage

```bash
ekapkgs home switch          # Build and activate
ekapkgs home build           # Build without activating
ekapkgs home update          # Update inputs and rebuild
ekapkgs home generations     # List generations
ekapkgs home rollback        # Roll back to previous generation
```

### Imperative packages

```bash
ekapkgs home packages add ripgrep fd
ekapkgs home packages remove ripgrep
ekapkgs home packages list
```

Add `~/.ekapkgs-packages/bin` to PATH for imperative packages.

### User services

```bash
ekapkgs home services add myservice --set command=/usr/bin/myapp
ekapkgs home services remove myservice
ekapkgs home services apply
ekapkgs home services status
ekapkgs home services logs myservice --follow
```

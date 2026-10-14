# ekapkgs home module tests
#
# Validates per-user program modules added by ekapkgs on top of
# corepkgs' home infrastructure.
#
# Usage:
#   nix-build ekaos/tests/home.nix -A all
#   cat result/test-results.txt
{
  pkgs ? import ../../. { },
}:

let
  inherit (pkgs) lib;

  evalHome =
    modules:
    (import ../eval-home.nix { inherit lib pkgs; }) {
      inherit modules;
    };

  # Evaluate all ekapkgs home modules with test config
  result = evalHome [
    {
      home.users.alice = {
        programs.alacritty = {
          enable = true;
          settings = {
            font.size = 14;
            window.opacity = 0.9;
          };
        };

        programs.htop = {
          enable = true;
          settings = {
            tree_view = 1;
            hide_kernel_threads = 1;
          };
        };

        programs.direnv = {
          enable = true;
          enableBashIntegration = true;
          direnvrcExtra = "layout_python() { VIRTUAL_ENV=.venv; }";
        };

        programs.fzf = {
          enable = true;
          keybindings = true;
          fuzzyCompletion = true;
          defaultOptions = "--height 40%";
          defaultCommand = "fd --type f";
        };

        programs.neovim = {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
          extraConfig = "set number";
          extraLuaConfig = "vim.opt.relativenumber = true";
        };

        programs.waybar = {
          enable = true;
          settings = [{ layer = "top"; modules-right = [ "clock" ]; }];
          style = "* { font-size: 13px; }";
        };

        programs.obs-studio.enable = true;

        programs.vscode.enable = true;

        programs.xdg = {
          enable = true;
          cacheHome = "$HOME/.cache";
          configHome = "$HOME/.config";
          dataHome = "$HOME/.local/share";
          stateHome = "$HOME/.local/state";
        };
      };

      # Disabled modules should produce no files
      home.users.bob = {
        programs.alacritty.enable = false;
        programs.htop.enable = false;
        programs.direnv.enable = false;
        programs.fzf.enable = false;
        programs.neovim.enable = false;
        programs.waybar.enable = false;
        programs.obs-studio.enable = false;
        programs.vscode.enable = false;
        programs.xdg.enable = false;
        sessionVariables.X = "1";
      };
    }
  ];

  alice = result.config.home.users.alice;
  bob = result.config.home.users.bob;

in
{
  all = pkgs.runCommand "ekapkgs-home-tests" { } ''
    mkdir -p $out
    results=$out/test-results.txt

    pass=0
    fail=0

    check_contains() {
      local name="$1" text="$2" pattern="$3"
      if echo "$text" | grep -qF "$pattern"; then
        echo "PASS: $name" >> "$results"
        pass=$((pass + 1))
      else
        echo "FAIL: $name (expected '$pattern')" >> "$results"
        fail=$((fail + 1))
      fi
    }

    echo "=== ekapkgs home module tests ===" > "$results"
    echo "" >> "$results"

    # ── htop ──
    htoprc=${lib.escapeShellArg alice.file.".config/htop/htoprc".text}
    check_contains "htop: tree_view" "$htoprc" "tree_view=1"
    check_contains "htop: hide_kernel_threads" "$htoprc" "hide_kernel_threads=1"

    # ── direnv ──
    direnvrc=${lib.escapeShellArg alice.file.".config/direnv/direnvrc".text}
    check_contains "direnv: direnvrcExtra" "$direnvrc" "layout_python"

    # ── neovim ──
    initvim=${lib.escapeShellArg alice.file.".config/nvim/init.vim".text}
    check_contains "neovim: extraConfig" "$initvim" "set number"
    check_contains "neovim: extraLuaConfig" "$initvim" "vim.opt.relativenumber"

    # ── waybar ──
    waybar_config=${lib.escapeShellArg alice.file.".config/waybar/config.jsonc".text}
    waybar_style=${lib.escapeShellArg alice.file.".config/waybar/style.css".text}
    check_contains "waybar: config has layer" "$waybar_config" "top"
    check_contains "waybar: config has clock" "$waybar_config" "clock"
    check_contains "waybar: style" "$waybar_style" "font-size: 13px"

    # ── neovim aliases ──
    ${if alice.shellAliases ? vi && alice.shellAliases.vi == "nvim" then ''
      echo "PASS: neovim: viAlias" >> "$results"
      pass=$((pass + 1))
    '' else ''
      echo "FAIL: neovim: viAlias" >> "$results"
      fail=$((fail + 1))
    ''}
    ${if alice.shellAliases ? vim && alice.shellAliases.vim == "nvim" then ''
      echo "PASS: neovim: vimAlias" >> "$results"
      pass=$((pass + 1))
    '' else ''
      echo "FAIL: neovim: vimAlias" >> "$results"
      fail=$((fail + 1))
    ''}

    # ── neovim defaultEditor ──
    ${if alice.sessionVariables ? EDITOR && alice.sessionVariables.EDITOR == "nvim" then ''
      echo "PASS: neovim: defaultEditor" >> "$results"
      pass=$((pass + 1))
    '' else ''
      echo "FAIL: neovim: defaultEditor" >> "$results"
      fail=$((fail + 1))
    ''}

    # ── fzf env vars ──
    ${if alice.sessionVariables ? FZF_DEFAULT_OPTS then ''
      echo "PASS: fzf: FZF_DEFAULT_OPTS set" >> "$results"
      pass=$((pass + 1))
    '' else ''
      echo "FAIL: fzf: FZF_DEFAULT_OPTS not set" >> "$results"
      fail=$((fail + 1))
    ''}
    ${if alice.sessionVariables ? FZF_DEFAULT_COMMAND then ''
      echo "PASS: fzf: FZF_DEFAULT_COMMAND set" >> "$results"
      pass=$((pass + 1))
    '' else ''
      echo "FAIL: fzf: FZF_DEFAULT_COMMAND not set" >> "$results"
      fail=$((fail + 1))
    ''}

    # ── xdg env vars ──
    ${if alice.sessionVariables ? XDG_CACHE_HOME then ''
      echo "PASS: xdg: XDG_CACHE_HOME set" >> "$results"
      pass=$((pass + 1))
    '' else ''
      echo "FAIL: xdg: XDG_CACHE_HOME not set" >> "$results"
      fail=$((fail + 1))
    ''}
    ${if alice.sessionVariables ? XDG_CONFIG_HOME then ''
      echo "PASS: xdg: XDG_CONFIG_HOME set" >> "$results"
      pass=$((pass + 1))
    '' else ''
      echo "FAIL: xdg: XDG_CONFIG_HOME not set" >> "$results"
      fail=$((fail + 1))
    ''}

    # ── xdg activation ──
    ${if alice.activation ? xdgDirs then ''
      echo "PASS: xdg: activation script exists" >> "$results"
      pass=$((pass + 1))
    '' else ''
      echo "FAIL: xdg: activation script missing" >> "$results"
      fail=$((fail + 1))
    ''}

    # ── package counts ──
    # alice should have packages from all enabled modules
    ${let count = builtins.length alice.packages; in
      if count >= 8 then ''
        echo "PASS: alice: ${toString count} packages (>= 8 expected)" >> "$results"
        pass=$((pass + 1))
      '' else ''
        echo "FAIL: alice: only ${toString count} packages (expected >= 8)" >> "$results"
        fail=$((fail + 1))
      ''
    }

    # ── disabled modules produce no files ──
    ${if !(bob.file ? ".config/htop/htoprc") then ''
      echo "PASS: disabled: no htoprc" >> "$results"
      pass=$((pass + 1))
    '' else ''
      echo "FAIL: disabled: htoprc should not exist" >> "$results"
      fail=$((fail + 1))
    ''}
    ${if !(bob.file ? ".config/nvim/init.vim") then ''
      echo "PASS: disabled: no init.vim" >> "$results"
      pass=$((pass + 1))
    '' else ''
      echo "FAIL: disabled: init.vim should not exist" >> "$results"
      fail=$((fail + 1))
    ''}
    ${if !(bob.file ? ".config/waybar/config.jsonc") then ''
      echo "PASS: disabled: no waybar config" >> "$results"
      pass=$((pass + 1))
    '' else ''
      echo "FAIL: disabled: waybar config should not exist" >> "$results"
      fail=$((fail + 1))
    ''}
    ${if bob.packages == [] then ''
      echo "PASS: disabled: no packages" >> "$results"
      pass=$((pass + 1))
    '' else ''
      echo "FAIL: disabled: should have no packages" >> "$results"
      fail=$((fail + 1))
    ''}

    echo "" >> "$results"
    echo "ekapkgs home results: $pass passed, $fail failed" >> "$results"

    if [ "$fail" -gt 0 ]; then
      cat "$results" >&2
      exit 1
    fi
  '';
}

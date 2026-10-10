# Per-user fzf configuration
#
# Extends home.users.<name> with fzf options.
# Sources keybindings and completion scripts into bash.
#
# Usage:
#   home.users.alice.programs.fzf = {
#     enable = true;
#     keybindings = true;
#     fuzzyCompletion = true;
#     defaultOptions = "--height 40% --layout=reverse --border";
#   };
{ lib, pkgs, ... }:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    types
    concatStringsSep
    optional
    optionalString
    ;

  fzfOpts =
    { config, ... }:
    let
      cfg = config.programs.fzf;
    in
    {
      options.programs.fzf = {
        enable = mkEnableOption "per-user fzf configuration";

        package = mkOption {
          type = types.package;
          default = pkgs.fzf;
          description = "fzf package to install.";
        };

        keybindings = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to enable fzf keybindings in bash (Ctrl-T, Ctrl-R, Alt-C).";
        };

        fuzzyCompletion = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to enable fzf fuzzy completion in bash (**<TAB>).";
        };

        defaultOptions = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "--height 40% --layout=reverse --border";
          description = "Default options set via FZF_DEFAULT_OPTS.";
        };

        defaultCommand = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "fd --type f --hidden --follow --exclude .git";
          description = "Default command set via FZF_DEFAULT_COMMAND.";
        };
      };

      config = mkIf cfg.enable (mkMerge [
        {
          packages = [ cfg.package ];

          programs.bash.initExtra = concatStringsSep "\n" (
            optional cfg.fuzzyCompletion "source ${cfg.package}/share/fzf/completion.bash"
            ++ optional cfg.keybindings "source ${cfg.package}/share/fzf/key-bindings.bash"
          );
        }

        (mkIf (cfg.defaultOptions != null) {
          sessionVariables.FZF_DEFAULT_OPTS = cfg.defaultOptions;
        })

        (mkIf (cfg.defaultCommand != null) {
          sessionVariables.FZF_DEFAULT_COMMAND = cfg.defaultCommand;
        })
      ]);
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule fzfOpts);
  };
}

# System-wide fzf configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.fzf;
in

{
  options.programs.fzf = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install fzf system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.fzf;
      description = "fzf package to use.";
    };

    keybindings = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable fzf keybindings in bash.";
    };

    fuzzyCompletion = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable fzf fuzzy completion in bash.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.bash.interactiveInit = concatStringsSep "\n" (
      optional cfg.fuzzyCompletion "source ${cfg.package}/share/fzf/completion.bash"
      ++ optional cfg.keybindings "source ${cfg.package}/share/fzf/key-bindings.bash"
    );
  };
}

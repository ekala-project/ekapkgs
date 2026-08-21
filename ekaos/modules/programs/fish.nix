# System-wide fish shell configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.fish;
in

{
  options.programs.fish = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install fish system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.fish;
      description = "fish package to use.";
    };

    interactiveShellInit = mkOption {
      type = types.lines;
      default = "";
      description = "fish interactive init commands.";
    };

    shellInit = mkOption {
      type = types.lines;
      default = "";
      description = "fish shell init (runs for all fish shells).";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ cfg.package ];
    }

    (mkIf (cfg.interactiveShellInit != "") {
      environment.etc."fish/conf.d/99-ekaos-interactive.fish".text = ''
        if status is-interactive
        ${cfg.interactiveShellInit}
        end
      '';
    })

    (mkIf (cfg.shellInit != "") {
      environment.etc."fish/conf.d/99-ekaos-shell.fish".text = cfg.shellInit;
    })
  ]);
}

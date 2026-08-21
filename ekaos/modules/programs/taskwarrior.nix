# System-wide taskwarrior configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.taskwarrior;
in

{
  options.programs.taskwarrior = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install taskwarrior system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.taskwarrior;
      description = "taskwarrior package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

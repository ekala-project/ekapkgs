# System-wide go-task configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.go-task;
in

{
  options.programs.go-task = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install go-task system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.go-task;
      description = "go-task package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

# System-wide awslogs configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.awslogs;
in

{
  options.programs.awslogs = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install awslogs system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.awslogs;
      description = "awslogs package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

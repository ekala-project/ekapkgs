# System-wide analog configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.analog;
in

{
  options.programs.analog = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install analog system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.analog;
      description = "analog package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

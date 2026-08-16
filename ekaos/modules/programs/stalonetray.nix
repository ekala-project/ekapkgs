# System-wide stalonetray configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.stalonetray;
in

{
  options.programs.stalonetray = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install stalonetray system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.stalonetray;
      description = "stalonetray package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

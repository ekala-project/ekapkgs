# System-wide nethogs configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nethogs;
in

{
  options.programs.nethogs = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nethogs system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nethogs;
      description = "nethogs package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

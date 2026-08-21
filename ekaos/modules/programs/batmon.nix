# System-wide batmon configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.batmon;
in

{
  options.programs.batmon = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install batmon system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.batmon;
      description = "batmon package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

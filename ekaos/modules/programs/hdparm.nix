# System-wide hdparm configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hdparm;
in

{
  options.programs.hdparm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install hdparm system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hdparm;
      description = "hdparm package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

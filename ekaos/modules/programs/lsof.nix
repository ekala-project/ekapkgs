# System-wide lsof configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.lsof;
in

{
  options.programs.lsof = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install lsof system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lsof;
      description = "lsof package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

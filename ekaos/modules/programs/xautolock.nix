# System-wide xautolock configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.xautolock;
in

{
  options.programs.xautolock = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install xautolock system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.xautolock;
      description = "xautolock package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

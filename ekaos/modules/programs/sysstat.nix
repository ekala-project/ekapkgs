# System-wide sysstat configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sysstat;
in

{
  options.programs.sysstat = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install sysstat system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sysstat;
      description = "sysstat package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

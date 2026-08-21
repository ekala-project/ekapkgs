# System-wide activemq configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.activemq;
in

{
  options.programs.activemq = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install activemq system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.activemq;
      description = "activemq package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

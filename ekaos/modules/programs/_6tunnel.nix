# System-wide _6tunnel configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs."_6tunnel";
in

{
  options.programs."_6tunnel" = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install _6tunnel system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs._6tunnel;
      description = "_6tunnel package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

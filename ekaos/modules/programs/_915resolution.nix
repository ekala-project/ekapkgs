# System-wide _915resolution configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs."_915resolution";
in

{
  options.programs."_915resolution" = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install _915resolution system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs._915resolution;
      description = "_915resolution package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

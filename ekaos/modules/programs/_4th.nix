# System-wide _4th configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs."_4th";
in

{
  options.programs."_4th" = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install _4th system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs._4th;
      description = "_4th package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

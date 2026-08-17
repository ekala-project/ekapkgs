# System-wide duplicity configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.duplicity;
in

{
  options.programs.duplicity = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install duplicity system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.duplicity;
      description = "duplicity package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

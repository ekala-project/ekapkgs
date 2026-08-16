# System-wide atool configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.atool;
in

{
  options.programs.atool = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install atool system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.atool;
      description = "atool package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

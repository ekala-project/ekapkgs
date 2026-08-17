# System-wide lzip configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.lzip;
in

{
  options.programs.lzip = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install lzip system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lzip;
      description = "lzip package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

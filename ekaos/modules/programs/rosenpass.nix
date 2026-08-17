# System-wide rosenpass configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.rosenpass;
in

{
  options.programs.rosenpass = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install rosenpass system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rosenpass;
      description = "rosenpass package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

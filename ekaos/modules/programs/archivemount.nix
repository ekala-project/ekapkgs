# System-wide archivemount configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.archivemount;
in

{
  options.programs.archivemount = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install archivemount system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.archivemount;
      description = "archivemount package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

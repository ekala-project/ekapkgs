# System-wide ant configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ant;
in

{
  options.programs.ant = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ant system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ant;
      description = "ant package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

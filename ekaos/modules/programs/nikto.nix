# System-wide nikto configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nikto;
in

{
  options.programs.nikto = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nikto system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nikto;
      description = "nikto package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

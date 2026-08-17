# System-wide flite configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.flite;
in

{
  options.programs.flite = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install flite system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.flite;
      description = "flite package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

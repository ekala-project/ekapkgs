# System-wide freesweep configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.freesweep;
in

{
  options.programs.freesweep = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install freesweep system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.freesweep;
      description = "freesweep package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

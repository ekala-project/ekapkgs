# System-wide csvlens configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.csvlens;
in

{
  options.programs.csvlens = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install csvlens system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.csvlens;
      description = "csvlens package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

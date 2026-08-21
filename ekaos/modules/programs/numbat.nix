# System-wide numbat configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.numbat;
in

{
  options.programs.numbat = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install numbat system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.numbat;
      description = "numbat package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

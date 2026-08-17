# System-wide gdu configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.gdu;
in

{
  options.programs.gdu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install gdu system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gdu;
      description = "gdu package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

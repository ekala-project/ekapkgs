# System-wide bmon configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bmon;
in

{
  options.programs.bmon = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bmon system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bmon;
      description = "bmon package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

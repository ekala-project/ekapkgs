# System-wide mc configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mc;
in

{
  options.programs.mc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mc system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mc;
      description = "mc package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

# System-wide powertop configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.powertop;
in

{
  options.programs.powertop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install powertop system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.powertop;
      description = "powertop package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

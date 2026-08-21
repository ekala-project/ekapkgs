# System-wide irqbalance configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.irqbalance;
in

{
  options.programs.irqbalance = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install irqbalance system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.irqbalance;
      description = "irqbalance package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

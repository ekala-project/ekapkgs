# System-wide pay-respects configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pay-respects;
in

{
  options.programs.pay-respects = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pay-respects system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pay-respects;
      description = "pay-respects package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

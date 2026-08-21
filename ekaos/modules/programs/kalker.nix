# System-wide kalker configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.kalker;
in

{
  options.programs.kalker = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install kalker system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.kalker;
      description = "kalker package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

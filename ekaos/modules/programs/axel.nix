# System-wide axel configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.axel;
in

{
  options.programs.axel = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install axel system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.axel;
      description = "axel package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

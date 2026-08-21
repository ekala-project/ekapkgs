# System-wide taplo configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.taplo;
in

{
  options.programs.taplo = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install taplo system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.taplo;
      description = "taplo package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

# System-wide ddns-go configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ddns-go;
in

{
  options.programs.ddns-go = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ddns-go system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ddns-go;
      description = "ddns-go package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

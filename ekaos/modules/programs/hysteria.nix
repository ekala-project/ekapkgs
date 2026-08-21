# System-wide hysteria configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hysteria;
in

{
  options.programs.hysteria = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install hysteria system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hysteria;
      description = "hysteria package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

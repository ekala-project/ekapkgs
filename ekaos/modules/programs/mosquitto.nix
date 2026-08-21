# System-wide mosquitto configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mosquitto;
in

{
  options.programs.mosquitto = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mosquitto system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mosquitto;
      description = "mosquitto package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

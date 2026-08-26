# System-wide hyprpicker configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hyprpicker;
in

{
  options.programs.hyprpicker = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install hyprpicker system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hyprpicker;
      description = "hyprpicker package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

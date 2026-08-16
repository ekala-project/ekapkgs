# System-wide wayshot configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wayshot;
in

{
  options.programs.wayshot = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wayshot system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wayshot;
      description = "wayshot package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

# System-wide lynx configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.lynx;
in

{
  options.programs.lynx = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install lynx system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lynx;
      description = "lynx package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration for lynx.cfg.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."lynx.cfg" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

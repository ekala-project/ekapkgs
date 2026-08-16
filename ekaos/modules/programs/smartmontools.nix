# System-wide smartmontools configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.smartmontools;
in

{
  options.programs.smartmontools = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install smartmontools system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.smartmontools;
      description = "smartmontools package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional smartd.conf configuration content.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."smartd.conf" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

# System-wide ranger file manager configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ranger;
in

{
  options.programs.ranger = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ranger system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ranger;
      description = "ranger package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra ranger configuration lines written to /etc/ranger/rc.conf.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."ranger/rc.conf" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

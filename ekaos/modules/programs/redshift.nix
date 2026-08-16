# System-wide redshift configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.redshift;
in

{
  options.programs.redshift = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install redshift system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.redshift;
      description = "redshift package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra redshift configuration content written to /etc/redshift/redshift.conf.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."redshift/redshift.conf" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

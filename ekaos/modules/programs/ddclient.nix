# System-wide ddclient configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ddclient;
in

{
  options.programs.ddclient = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ddclient system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ddclient;
      description = "ddclient package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional ddclient configuration.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."ddclient/ddclient.conf" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

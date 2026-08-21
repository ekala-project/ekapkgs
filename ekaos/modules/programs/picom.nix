# System-wide picom configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.picom;
in

{
  options.programs.picom = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install picom system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.picom;
      description = "picom package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra picom configuration content written to /etc/xdg/picom/picom.conf.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."xdg/picom/picom.conf" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

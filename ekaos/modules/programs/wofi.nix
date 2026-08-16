# System-wide wofi configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wofi;
in

{
  options.programs.wofi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wofi system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wofi;
      description = "wofi package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration written to /etc/wofi/config.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."wofi/config" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

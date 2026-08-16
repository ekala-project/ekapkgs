# System-wide irssi configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.irssi;
in

{
  options.programs.irssi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install irssi system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.irssi;
      description = "irssi package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration for irssi.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."irssi/config" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

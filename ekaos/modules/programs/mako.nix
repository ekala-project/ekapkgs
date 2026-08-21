# System-wide mako configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mako;
in

{
  options.programs.mako = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mako system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mako;
      description = "mako package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra mako configuration content written to /etc/xdg/mako/config.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."xdg/mako/config" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

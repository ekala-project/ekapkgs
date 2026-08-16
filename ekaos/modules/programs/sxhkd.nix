# System-wide sxhkd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sxhkd;
in

{
  options.programs.sxhkd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install sxhkd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sxhkd;
      description = "sxhkd package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra sxhkdrc configuration content written to /etc/sxhkd/sxhkdrc.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."sxhkd/sxhkdrc" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

# System-wide kanshi configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.kanshi;
in

{
  options.programs.kanshi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install kanshi system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.kanshi;
      description = "kanshi package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra kanshi configuration content written to /etc/xdg/kanshi/config.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."xdg/kanshi/config" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

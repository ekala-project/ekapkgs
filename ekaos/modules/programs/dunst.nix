# System-wide dunst configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dunst;
in

{
  options.programs.dunst = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dunst system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dunst;
      description = "dunst package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra dunstrc configuration content written to /etc/dunst/dunstrc.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."dunst/dunstrc" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

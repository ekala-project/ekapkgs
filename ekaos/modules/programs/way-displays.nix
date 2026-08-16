# System-wide way-displays configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.way-displays;
in

{
  options.programs.way-displays = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install way-displays system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.way-displays;
      description = "way-displays package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra way-displays YAML configuration content written to /etc/way-displays/cfg.yaml.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."way-displays/cfg.yaml" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

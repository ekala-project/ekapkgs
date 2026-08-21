# System-wide Micro editor configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.micro;
  settingsFormat = pkgs.formats.json { };
  settingsFile = settingsFormat.generate "micro-settings.json" cfg.settings;
in

{
  options.programs.micro = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install Micro system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.micro;
      description = "Micro package to use.";
    };

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to set Micro as the default editor via the EDITOR environment variable.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Configuration written as JSON to /etc/micro/settings.json.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.variables = mkIf cfg.defaultEditor {
      EDITOR = "micro";
    };

    environment.etc."micro/settings.json".source = mkIf (cfg.settings != { }) settingsFile;
  };
}

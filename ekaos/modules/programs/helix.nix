# System-wide Helix editor configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.helix;
  settingsFormat = pkgs.formats.toml { };
  settingsFile = settingsFormat.generate "helix-config.toml" cfg.settings;
in

{
  options.programs.helix = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install Helix system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.helix;
      description = "Helix package to use.";
    };

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to set Helix as the default editor via the EDITOR environment variable.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Configuration written as TOML to /etc/helix/config.toml.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.variables = mkIf cfg.defaultEditor {
      EDITOR = "hx";
    };

    environment.etc."helix/config.toml".source = mkIf (cfg.settings != { }) settingsFile;
  };
}

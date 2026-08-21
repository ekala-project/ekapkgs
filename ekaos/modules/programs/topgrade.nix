# System-wide topgrade configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.topgrade;
  settingsFormat = pkgs.formats.toml { };
  settingsFile = settingsFormat.generate "topgrade.toml" cfg.settings;
in

{
  options.programs.topgrade = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install topgrade system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.topgrade;
      description = "topgrade package to use.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Configuration written as TOML to /etc/topgrade.toml.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."topgrade.toml".source = mkIf (cfg.settings != { }) settingsFile;

    environment.variables = mkIf (cfg.settings != { }) {
      TOPGRADE_CONFIG_PATH = "/etc/topgrade.toml";
    };
  };
}

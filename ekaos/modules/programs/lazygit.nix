# System-wide lazygit configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.lazygit;
  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "lazygit-config.yml" cfg.settings;
in

{
  options.programs.lazygit = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install lazygit system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lazygit;
      description = "lazygit package to use.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "lazygit configuration written to /etc/lazygit/config.yml in YAML format.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."lazygit/config.yml" = mkIf (cfg.settings != { }) {
      source = settingsFile;
    };

    environment.variables.LG_CONFIG_FILE = mkIf (cfg.settings != { }) "/etc/lazygit/config.yml";
  };
}

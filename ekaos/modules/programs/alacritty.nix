# System-wide Alacritty configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.alacritty;
  settingsFormat = pkgs.formats.toml { };
  settingsFile = settingsFormat.generate "alacritty.toml" cfg.settings;
in

{
  options.programs.alacritty = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install Alacritty system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.alacritty;
      description = "Alacritty package to use.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Configuration written as TOML to /etc/xdg/alacritty/alacritty.toml.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."xdg/alacritty/alacritty.toml".source = mkIf (cfg.settings != { }) settingsFile;
  };
}

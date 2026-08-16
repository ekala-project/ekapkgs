# System-wide bat configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bat;
in

{
  options.programs.bat = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bat system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bat;
      description = "bat package to use.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      example = {
        theme = "TwoDark";
        paging = "never";
      };
      description = ''
        System-wide bat settings written to /etc/bat.conf.
        Settings are converted to bat's --key=value config format.
        See bat(1) for available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."bat.conf" = mkIf (cfg.settings != { }) {
      text =
        concatStringsSep "\n" (mapAttrsToList (key: value: "--${key}=${toString value}") cfg.settings)
        + "\n";
    };

    environment.variables.BAT_CONFIG_PATH = "/etc/bat.conf";
  };
}

# System-wide FreeTDS configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.freetds;
in

{
  options.programs.freetds = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install and configure FreeTDS system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.freetds;
      description = "FreeTDS package to use.";
    };

    databases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        MYDATABASE = ''
          host = 10.0.2.100
          port = 1433
          tds version = 7.2
        '';
      };
      description = ''
        Database entries for freetds.conf. Each attribute name becomes
        a section header, and the value is the config content for that section.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.variables = mkIf (cfg.databases != { }) {
      FREETDSCONF = "/etc/freetds.conf";
      FREETDS = "/etc/freetds.conf";
      SYBASE = "${cfg.package}";
    };

    environment.etc."freetds.conf" = mkIf (cfg.databases != { }) {
      text = concatStrings (
        mapAttrsToList (name: value: ''
          [${name}]
          ${value}
        '') cfg.databases
      );
    };
  };
}

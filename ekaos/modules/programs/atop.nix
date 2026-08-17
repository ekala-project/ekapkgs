# System-wide atop configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.atop;

  atoprcText = concatStringsSep "\n" (
    mapAttrsToList (key: value: "${key} ${toString value}") cfg.settings
  );
in

{
  options.programs.atop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable atop.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.atop;
      description = "atop package to use.";
    };

    setuidWrapper = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the setuid wrapper for atop.";
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        Settings written to /etc/atoprc as "key value" lines.
      '';
      example = literalExpression ''
        {
          interval = 5;
          flags = "afg";
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc.atoprc = mkIf (cfg.settings != { }) {
      text = atoprcText;
    };

    security.wrappers.atop = mkIf cfg.setuidWrapper {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.package}/bin/atop";
    };
  };
}

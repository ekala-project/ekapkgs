# System-wide btop configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.btop;
  configFile = pkgs.writeText "btop.conf" (
    concatStringsSep "\n" (
      mapAttrsToList (k: v: "${k} = ${if isString v then "\"${v}\"" else toString v}") cfg.settings
    )
  );
in

{
  options.programs.btop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install btop system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.btop;
      description = "btop package to use.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Configuration written as key = value lines to /etc/btop/btop.conf.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."btop/btop.conf".source = mkIf (cfg.settings != { }) configFile;
  };
}

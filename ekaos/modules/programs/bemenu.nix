# System-wide bemenu configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bemenu;
in

{
  options.programs.bemenu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bemenu system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bemenu;
      description = "bemenu package to use.";
    };

    extraOptions = mkOption {
      type = types.str;
      default = "";
      description = "Extra options set via the BEMENU_OPTS environment variable.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.variables.BEMENU_OPTS = mkIf (cfg.extraOptions != "") cfg.extraOptions;
  };
}

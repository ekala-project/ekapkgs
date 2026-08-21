# System-wide less configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.less;
in

{
  options.programs.less = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install less system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.less;
      description = "less package to use.";
    };

    defaultPager = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to set PAGER=less.";
    };

    envVariables = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Environment variables to set for less (e.g. LESS, LESSHISTFILE).";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.variables =
      cfg.envVariables
      // optionalAttrs cfg.defaultPager {
        PAGER = "less";
      };
  };
}

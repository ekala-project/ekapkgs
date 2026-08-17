# System-wide lighttpd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.lighttpd;
in

{
  options.programs.lighttpd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install lighttpd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lighttpd;
      description = "lighttpd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

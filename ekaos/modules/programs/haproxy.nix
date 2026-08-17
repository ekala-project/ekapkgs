# System-wide haproxy configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.haproxy;
in

{
  options.programs.haproxy = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install haproxy system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.haproxy;
      description = "haproxy package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

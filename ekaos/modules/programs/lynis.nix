# System-wide lynis configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.lynis;
in

{
  options.programs.lynis = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install lynis system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lynis;
      description = "lynis package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

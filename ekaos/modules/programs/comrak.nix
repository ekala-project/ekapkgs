# System-wide comrak configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.comrak;
in

{
  options.programs.comrak = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install comrak system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.comrak;
      description = "comrak package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

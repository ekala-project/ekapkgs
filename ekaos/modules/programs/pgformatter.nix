# System-wide pgformatter configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pgformatter;
in

{
  options.programs.pgformatter = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pgformatter system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pgformatter;
      description = "pgformatter package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

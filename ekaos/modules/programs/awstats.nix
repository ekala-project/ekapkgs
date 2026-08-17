# System-wide awstats configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.awstats;
in

{
  options.programs.awstats = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install awstats system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.awstats;
      description = "awstats package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

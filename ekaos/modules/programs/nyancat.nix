# System-wide nyancat configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nyancat;
in

{
  options.programs.nyancat = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nyancat system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nyancat;
      description = "nyancat package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

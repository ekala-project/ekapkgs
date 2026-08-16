# System-wide git-chglog configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.git-chglog;
in

{
  options.programs.git-chglog = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install git-chglog system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.git-chglog;
      description = "git-chglog package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

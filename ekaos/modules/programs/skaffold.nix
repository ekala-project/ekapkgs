# System-wide skaffold configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.skaffold;
in

{
  options.programs.skaffold = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install skaffold system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.skaffold;
      description = "skaffold package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

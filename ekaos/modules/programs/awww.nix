# System-wide awww configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.awww;
in

{
  options.programs.awww = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install awww system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.awww;
      description = "awww package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

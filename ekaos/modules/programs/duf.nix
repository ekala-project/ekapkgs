# System-wide duf configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.duf;
in

{
  options.programs.duf = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install duf system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.duf;
      description = "duf package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

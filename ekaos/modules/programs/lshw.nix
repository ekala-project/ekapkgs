# System-wide lshw configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.lshw;
in

{
  options.programs.lshw = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install lshw system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lshw;
      description = "lshw package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

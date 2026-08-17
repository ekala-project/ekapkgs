# System-wide activate-linux configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.activate-linux;
in

{
  options.programs.activate-linux = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install activate-linux system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.activate-linux;
      description = "activate-linux package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

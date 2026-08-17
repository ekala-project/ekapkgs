# System-wide ethtool configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ethtool;
in

{
  options.programs.ethtool = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ethtool system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ethtool;
      description = "ethtool package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

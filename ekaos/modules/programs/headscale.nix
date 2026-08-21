# System-wide headscale configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.headscale;
in

{
  options.programs.headscale = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install headscale system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.headscale;
      description = "headscale package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

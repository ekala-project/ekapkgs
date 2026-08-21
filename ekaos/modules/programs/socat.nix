# System-wide socat configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.socat;
in

{
  options.programs.socat = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install socat system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.socat;
      description = "socat package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

# System-wide containerd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.containerd;
in

{
  options.programs.containerd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install containerd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.containerd;
      description = "containerd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

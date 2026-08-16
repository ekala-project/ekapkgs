# System-wide podman-tui configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.podman-tui;
in

{
  options.programs.podman-tui = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install podman-tui system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.podman-tui;
      description = "podman-tui package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

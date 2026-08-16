# System-wide ssh-audit configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ssh-audit;
in

{
  options.programs.ssh-audit = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ssh-audit system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ssh-audit;
      description = "ssh-audit package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

# System-wide sshuttle configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sshuttle;
in

{
  options.programs.sshuttle = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install sshuttle system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sshuttle;
      description = "sshuttle package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

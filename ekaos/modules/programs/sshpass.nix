# System-wide sshpass configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sshpass;
in

{
  options.programs.sshpass = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install sshpass system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sshpass;
      description = "sshpass package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

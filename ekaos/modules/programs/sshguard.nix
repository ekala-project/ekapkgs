# System-wide sshguard configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sshguard;
in

{
  options.programs.sshguard = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install sshguard system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sshguard;
      description = "sshguard package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional sshguard configuration.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."sshguard/sshguard.conf" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

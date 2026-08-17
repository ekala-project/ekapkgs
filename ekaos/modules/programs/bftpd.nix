# System-wide bftpd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bftpd;
in

{
  options.programs.bftpd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bftpd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bftpd;
      description = "bftpd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

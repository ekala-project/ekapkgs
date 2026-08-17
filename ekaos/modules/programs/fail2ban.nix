# System-wide fail2ban configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.fail2ban;
in

{
  options.programs.fail2ban = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install fail2ban system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.fail2ban;
      description = "fail2ban package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

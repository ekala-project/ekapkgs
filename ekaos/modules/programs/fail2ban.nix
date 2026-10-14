# fail2ban — ban hosts that cause authentication failures
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
    enable = mkEnableOption "fail2ban, a log-scanning ban daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.fail2ban;
      description = "fail2ban package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.fail2ban = {
      wantedBy = [ "multi-user.target" ];
    };
  };
}

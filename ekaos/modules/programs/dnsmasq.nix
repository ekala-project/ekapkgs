# System-wide dnsmasq configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dnsmasq;
in

{
  options.programs.dnsmasq = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dnsmasq system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dnsmasq;
      description = "dnsmasq package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        server=8.8.8.8
        cache-size=1000
      '';
      description = "Additional dnsmasq configuration content.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."dnsmasq.conf" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}

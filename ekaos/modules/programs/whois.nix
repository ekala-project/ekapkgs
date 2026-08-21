# System-wide whois configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.whois;
in

{
  options.programs.whois = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install whois system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.whois;
      description = "whois package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

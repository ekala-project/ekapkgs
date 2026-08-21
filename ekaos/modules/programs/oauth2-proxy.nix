# System-wide oauth2-proxy configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.oauth2-proxy;
in

{
  options.programs.oauth2-proxy = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install oauth2-proxy system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.oauth2-proxy;
      description = "oauth2-proxy package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

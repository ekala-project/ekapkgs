# System-wide nginx configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nginx;
in

{
  options.programs.nginx = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nginx system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nginx;
      description = "nginx package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

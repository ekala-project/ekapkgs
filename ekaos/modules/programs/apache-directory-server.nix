# System-wide apache-directory-server configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.apache-directory-server;
in

{
  options.programs.apache-directory-server = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install apache-directory-server system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.apache-directory-server;
      description = "apache-directory-server package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

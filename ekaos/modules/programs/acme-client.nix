# System-wide acme-client configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.acme-client;
in

{
  options.programs.acme-client = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install acme-client system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.acme-client;
      description = "acme-client package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

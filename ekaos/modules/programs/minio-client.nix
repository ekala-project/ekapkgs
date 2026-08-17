# System-wide minio-client configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.minio-client;
in

{
  options.programs.minio-client = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install minio-client system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.minio-client;
      description = "minio-client package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

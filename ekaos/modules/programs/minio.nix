# System-wide minio configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.minio;
in

{
  options.programs.minio = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install minio system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.minio;
      description = "minio package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

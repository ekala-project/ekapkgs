# System-wide grpcurl configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.grpcurl;
in

{
  options.programs.grpcurl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install grpcurl system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.grpcurl;
      description = "grpcurl package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

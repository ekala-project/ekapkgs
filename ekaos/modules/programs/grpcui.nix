# System-wide grpcui configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.grpcui;
in

{
  options.programs.grpcui = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install grpcui system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.grpcui;
      description = "grpcui package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

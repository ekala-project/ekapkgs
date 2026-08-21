# System-wide gomplate configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.gomplate;
in

{
  options.programs.gomplate = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install gomplate system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gomplate;
      description = "gomplate package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

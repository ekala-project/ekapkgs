# System-wide pv configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pv;
in

{
  options.programs.pv = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pv system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pv;
      description = "pv package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

# System-wide vifm configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.vifm;
in

{
  options.programs.vifm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install vifm system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.vifm;
      description = "vifm package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

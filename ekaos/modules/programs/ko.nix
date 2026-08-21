# System-wide ko configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ko;
in

{
  options.programs.ko = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ko system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ko;
      description = "ko package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

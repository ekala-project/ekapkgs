# System-wide bandwhich configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bandwhich;
in

{
  options.programs.bandwhich = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bandwhich system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bandwhich;
      description = "bandwhich package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

# System-wide swayr configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.swayr;
in

{
  options.programs.swayr = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install swayr system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.swayr;
      description = "swayr package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

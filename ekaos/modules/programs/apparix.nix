# System-wide apparix configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.apparix;
in

{
  options.programs.apparix = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install apparix system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.apparix;
      description = "apparix package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

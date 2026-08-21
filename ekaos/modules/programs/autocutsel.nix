# System-wide autocutsel configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.autocutsel;
in

{
  options.programs.autocutsel = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install autocutsel system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.autocutsel;
      description = "autocutsel package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

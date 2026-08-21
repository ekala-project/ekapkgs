# System-wide ascii configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ascii;
in

{
  options.programs.ascii = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ascii system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ascii;
      description = "ascii package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

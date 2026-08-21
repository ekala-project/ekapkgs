# System-wide calcurse configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.calcurse;
in

{
  options.programs.calcurse = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install calcurse system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.calcurse;
      description = "calcurse package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

# System-wide hexedit configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hexedit;
in

{
  options.programs.hexedit = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install hexedit system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hexedit;
      description = "hexedit package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

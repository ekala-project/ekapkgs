# System-wide xmlstarlet configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.xmlstarlet;
in

{
  options.programs.xmlstarlet = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install xmlstarlet system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.xmlstarlet;
      description = "xmlstarlet package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

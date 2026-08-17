# System-wide _9menu configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs."_9menu";
in

{
  options.programs."_9menu" = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install _9menu system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs._9menu;
      description = "_9menu package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}

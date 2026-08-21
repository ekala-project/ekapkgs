# System-wide _3cpio configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs."_3cpio";
in

{
  options.programs."_3cpio" = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install _3cpio system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs._3cpio;
      description = "_3cpio package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
